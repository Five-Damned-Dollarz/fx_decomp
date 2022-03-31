module main;

import std.stdio;
import std.conv: to;
import std.string: fromStringz, toLower;

import keytypes;

class LTFxFileBinary
{
	this() {}
	this(string filename) { Open(filename); }
	~this() { if (_file.isOpen()) Close(); }

	void Open(string filename)
	{
		_file=File(filename, "rb");
	}

	void Close()
	{
		_file.close();
	}

	void Read()
	{
		_file.rawRead((&_header)[0..1]);

		_file.seek(_header.strings_offset);
		_strings_buffer=_file.rawRead(new char[_header.strings_length]);
		_functions_buffer=_file.rawRead(new byte[_header.funcs_length]);

		_effects=new Effect[_header.effect_count];

		foreach(ref fx; _effects)
		{
			uint[3] buf;
			_file.rawRead((&buf)[0..1]);

			// debug writeln("Effect: ", buf);
			// debug writeln(fromStringz(&_strings_buffer[buf[0]]));

			fx=new Effect();
			fx.name_index=buf[0];
			fx.phase_length=buf[1];

			fx.key_count=buf[2];
			fx.keys=new FxKey[fx.key_count];

			foreach(ref key; fx.keys)
			{
				uint type;
				float[2] temp;
				uint[3] buf_;

				_file.rawRead((&type)[0..1]);
				_file.rawRead((&temp)[0..1]);
				_file.rawRead((&buf_)[0..1]);

				key=new FxKey();
				key.key_type=cast(FxKey.KeyType)type;
				key.start_time=temp[0];
				key.end_time=temp[1];
				key.e=buf_[0];
				key.f=buf_[1];

				key.property_count=buf_[2];
				key.properties=new KeyProperty[key.property_count];

				// debug writeln("Key: ", key.key_type);

				foreach(ref prop; key.properties)
				{
					uint[2] prop_;
					_file.rawRead(prop_[0..2]);

					prop=new KeyProperty();
					prop.name_index=prop_[0];
					prop.next_pos=prop_[1];

					prop.data=_file.rawRead(new byte[prop.next_pos-_file.tell()]);
				}
			}
		}
	}

	void Read(string filename)
	{
		Open(filename);
		Read();
	}

	Function!(T) GetFunction(T)(uint index)
	{
		Function!(T) temp_func=*cast(Function!(T)*)(&(_functions_buffer[index]));
		temp_func.keys=cast(Function!(T).FunctionKey[])(&(_functions_buffer[index])+4)[0..temp_func.key_count*Function!(T).FunctionKey.sizeof];

		return temp_func;
	}

private:
	File _file;

protected:
	FxHeader _header;
	char[] _strings_buffer;

	/*
	function data is:
	struct Function(T)
	{
		struct FunctionKey
		{
			float time;
			T value;
		}

		uint key_count;
		FunctionKey[] keys;
	}
	*/
	byte[] _functions_buffer;

	Effect[] _effects;
}

struct FxHeader
{
	char[4] magic;
	uint version_, dll_version; // always 2, 5? maybe version and ClientFX dll version?

	uint strings_length;
	uint funcs_length; // data size?
	uint key_count; // key count
	uint effect_count; // effect count
	uint dll_GetNum; // always 18? ClientFX dll fxGetNum?
	uint strings_offset; // strings offset
	uint total_size; // (file - header) size

	/*
	key counts:
	 0 = ParticleSystem
	 1 = Sprite
	 2 = LTBModel
	 3 = DynaLight
	 4 = Sound
	 5 = CameraShake
	 6 = Create
	 7 = CreateRay
	 8 = FlareSprite
	 9 = Lightning
	10 = Tracer
	11 = LensFlare
	12 = DebrisSystem
	13 = VideoController
	14 = Decal
	15 = Overlay
	16 = PolyTrail
	17 = Rumble
	*/
	uint[18 /* dll_GetNum */] key_counts;
	/*
	if dll_GetNum >= 19:
		18 = Laser
	if dll_GetNum >= 20:
		19 = ForkedLightning
	*/
}

class Effect
{
	uint name_index;
	uint phase_length; // in ms

	uint key_count;
	FxKey[] keys;
}

class FxKey
{
	enum KeyType : uint
	{
		ParticleSystem=0,
		Sprite=1,
		LtbModel=2,
		DynaLight=3,
		Sound=4,
		CameraShake=5,
		Create=6,
		CreateRay=7,
		FlareSprite=8,
		Lightning=9,
		Tracer=10,
		LensFlare=11,
		DebrisSystem=12,
		VideoController=13,
		Decal=14,
		Overlay=15,
		PolyTrail=16,
		Rumble=17,
		Laser=18,
		ForkedLightning=19,
	}
	KeyType key_type;
	float start_time; // in seconds
	float end_time; // in seconds
	uint e, f; // incrementing per effect key id, often has spaces where deleted keys were?

	uint property_count;
	KeyProperty[] properties;
}

class KeyProperty
{
	uint name_index;
	uint next_pos;

	byte[] data; // could be raw float, int, vector, etc. or index to string or function table
}

enum PropertyType
{
	Unknown,
	String,
	Filename,
	Enum,
	Int,
	Float,
	Color,
	Vector,
	Animation,
	ClientFXRef,
}

immutable int[10] PropertySizes=[0, 4, 4, 4, 4, 4, 16, 12, 4, 4];

struct PropertyConv
{
	import std.bitmanip: bitfields;

	this(PropertyType type, bool is_function)
	{
		this.type=type;
		this.is_function=is_function;
	}

	mixin(bitfields!(
		PropertyType, `type`, 4,
		bool, `is_function`, 1,
		uint, ``, 3
	));
}

// possible types for a Function: int, enum (int), float, vec3, vec4 (colour)
struct Function(T)
{
	struct FunctionKey
	{
		float time;
		T value;
	}

	uint key_count;
	FunctionKey[] keys;
}

class LTFxFileAscii
{
	this() {}
	this(string filename) { Open(filename); }
	~this() { if (_file.isOpen()) Close(); }
	
	void Open(string filename)
	{
		_file=File(filename, "wt");
	}

	void Close()
	{
		if (_depth>0)
			throw new Exception("File closed with " ~ to!string(_depth) ~ " open sections");

		_file.close();
	}
	
	void OpenSection(string section)
	{
		TabLine();
		_file.writeln("(" ~ section);

		++_depth;
	}
	
	void CloseSection()
	{
		--_depth;

		TabLine();
		_file.writeln(")");
	}

	void WriteProperty(T)(string name, T value)
	{
		TabLine();
		_file.writeln("(" ~ name ~ " " ~ to!string(value) ~ ")");
	}

	void WriteProperty(T : string)(string name, T value)
	{
		TabLine();
		_file.writeln("(" ~ name ~ " \"" ~ value ~ "\")");
	}

	void WriteProperty(T : int)(string name, T value)
	{
		TabLine();
		_file.writefln("(%s %d)", name, value);
	}

	void WriteProperty(T : float)(string name, T value)
	{
		TabLine();
		_file.writefln("(%s %.6f)", name, value);
	}

	void WriteProperty(T : float[]) (string name, T value)
	{
		TabLine();
		_file.writefln("(%s %(%.6f %))", name, value);
	}

	void WriteProperty(T : int[]) (string name, T value)
	{
		TabLine();
		_file.writefln("(%s %(%d %))", name, value);
	}

private:
	void TabLine()
	{
		foreach(i; 0.._depth) _file.write("\t");
	}
	
private:
	File _file;
	uint _depth;
}

void main(string[] args)
{
	LTFxFileBinary fx_bin=new LTFxFileBinary(args[1]);
	fx_bin.Read();
	debug writeln(fx_bin._header);
	// debug writeln(fx_bin._strings_buffer);
	// debug writeln(fx_bin._functions_buffer);

	LTFxFileAscii fx_file=new LTFxFileAscii();

	if (args.length>2)
		fx_file.Open(args[2]);
	else
	{
		import std.path;
		string filename=args[1].stripExtension() ~ `.fx00a`;
		fx_file.Open(filename);
	}
	
	// resource-database
	{
		fx_file.OpenSection("resource-database");
		scope(exit) fx_file.CloseSection();

		fx_file.WriteProperty("version", 1);

		{
			fx_file.OpenSection("resource-list");
			scope(exit) fx_file.CloseSection();

			foreach(fx; fx_bin._effects)
			{
				fx_file.OpenSection("resource");
				scope(exit) fx_file.CloseSection();

				fx_file.WriteProperty("name", cast(string)fromStringz(&fx_bin._strings_buffer[fx.name_index]));
				fx_file.WriteProperty("type", "FX");
			}
		}
	}

	// header
	{
		fx_file.OpenSection("header");
		scope(exit) fx_file.CloseSection();

		fx_file.WriteProperty("version", 1);
	}

	// effects
	{
		fx_file.OpenSection("effect-tree");
		scope(exit) fx_file.CloseSection();

		{
			fx_file.OpenSection("container");
			scope(exit) fx_file.CloseSection();

			fx_file.WriteProperty("name", "[Effects]");

			{
				fx_file.OpenSection("children");
				scope(exit) fx_file.CloseSection();

				foreach(fx; fx_bin._effects)
				{
					fx_file.OpenSection("effect");
					scope(exit) fx_file.CloseSection();

					fx_file.WriteProperty("name", cast(string)fromStringz(&fx_bin._strings_buffer[fx.name_index]));
					fx_file.WriteProperty("length", fx.phase_length);

					{
						fx_file.OpenSection("key-list");
						scope(exit) fx_file.CloseSection();

						foreach(i, key; fx.keys)
						{
							fx_file.OpenSection("key");
							scope(exit) fx_file.CloseSection();

							fx_file.WriteProperty("name", "");
							fx_file.WriteProperty("type", to!string(key.key_type));
							fx_file.WriteProperty("id", key.e); // key.e or key.f, unknown
							fx_file.WriteProperty("start-time", cast(int)(key.start_time*1000));
							fx_file.WriteProperty("end-time", cast(int)(key.end_time*1000));
							fx_file.WriteProperty("track", cast(uint)i); // might have to sort this out later

							{
								fx_file.OpenSection("properties");
								scope(exit) fx_file.CloseSection();

								foreach(prop; key.properties)
								{
									fx_file.OpenSection("property");
									scope(exit) fx_file.CloseSection();

									string temp_name=cast(string)fromStringz(&fx_bin._strings_buffer[prop.name_index]);
									fx_file.WriteProperty("name", temp_name);

									PropertyType temp_type=GetPropTypeFromName(temp_name);
									fx_file.WriteProperty("type", to!string(temp_type));

									{
										fx_file.OpenSection("value-list");
										scope(exit) fx_file.CloseSection();

										if (GetPropertyIsFunc(key.key_type, temp_name))
										{
											switch(temp_type)
											{
												case PropertyType.Enum:
													Function!int temp_func=fx_bin.GetFunction!int(*cast(uint*)prop.data.ptr);
													foreach(fkey; temp_func.keys)
													{
														fx_file.OpenSection("value");
														scope(exit) fx_file.CloseSection();

														fx_file.WriteProperty("time", fkey.time);
														fx_file.WriteProperty("data", GetPropertyEnumString(temp_name, fkey.value));
													}
													break;

												case PropertyType.Int:
													Function!int temp_func=fx_bin.GetFunction!int(*cast(uint*)prop.data.ptr);
													foreach(fkey; temp_func.keys)
													{
														fx_file.OpenSection("value");
														scope(exit) fx_file.CloseSection();

														fx_file.WriteProperty("time", fkey.time);
														fx_file.WriteProperty("data", fkey.value);
													}
													break;

												case PropertyType.Float:
													Function!float temp_func=fx_bin.GetFunction!float(*cast(uint*)prop.data.ptr);
													foreach(fkey; temp_func.keys)
													{
														fx_file.OpenSection("value");
														scope(exit) fx_file.CloseSection();

														fx_file.WriteProperty("time", fkey.time);
														fx_file.WriteProperty("data", fkey.value);
													}
													break;

												case PropertyType.Vector:
													Function!(float[3]) temp_func=fx_bin.GetFunction!(float[3])(*cast(uint*)prop.data.ptr);
													foreach(fkey; temp_func.keys)
													{
														fx_file.OpenSection("value");
														scope(exit) fx_file.CloseSection();

														fx_file.WriteProperty("time", fkey.time);
														fx_file.WriteProperty("data", fkey.value);
													}
													break;

												case PropertyType.Color:
													Function!(float[4]) temp_func=fx_bin.GetFunction!(float[4])(*cast(uint*)prop.data.ptr);
													foreach(fkey; temp_func.keys)
													{
														fx_file.OpenSection("value");
														scope(exit) fx_file.CloseSection();

														int[4] temp_colour=[cast(int)(fkey.value[0]*255), cast(int)(fkey.value[1]*255), cast(int)(fkey.value[2]*255), cast(int)(fkey.value[3]*255)];

														fx_file.WriteProperty("time", fkey.time);
														fx_file.WriteProperty("data", temp_colour);
													}
													break;

												default:
													throw new Exception("Unknown write function property type");
													//break;
											}
										}
										else
										{
											fx_file.OpenSection("value");
											scope(exit) fx_file.CloseSection();

											// FIXME: this should really just set up a fake Function!(type) with only one key instead of being a whole branch
											WritePropertyValue(fx_bin, fx_file, key, prop, temp_type, temp_name);
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
}

void WritePropertyValue(LTFxFileBinary bin, LTFxFileAscii file, FxKey key, KeyProperty prop, PropertyType prop_type, string prop_name)
{
	switch(prop_type)
	{
		case PropertyType.Int:
			file.WriteProperty("time", 0.0f);
			file.WriteProperty("data", *cast(int*)prop.data.ptr);
			break;

		case PropertyType.Float:
			file.WriteProperty("time", 0.0f);
			file.WriteProperty("data", *cast(float*)prop.data.ptr);
			break;

		case PropertyType.Vector:
			file.WriteProperty("time", 0.0f);
			file.WriteProperty("data", *cast(float[3]*)prop.data.ptr);
			break;

		case PropertyType.Enum:
			file.WriteProperty("time", 0.0);
			file.WriteProperty("data", GetPropertyEnumString(prop_name, *cast(uint*)prop.data.ptr));
			break;

		case PropertyType.Color:
			float[4] orig_colour=*cast(float[4]*)prop.data.ptr;
			int[4] temp_colour=[cast(int)(orig_colour[0]*255), cast(int)(orig_colour[1]*255), cast(int)(orig_colour[2]*255), cast(int)(orig_colour[3]*255)];

			file.WriteProperty("time", 0.0f);
			file.WriteProperty("data", temp_colour);
			break;

		case PropertyType.Filename:
		case PropertyType.String:
		case PropertyType.Animation:
		case PropertyType.ClientFXRef:
			file.WriteProperty("time", 0.0f);
			file.WriteProperty("data", cast(string)fromStringz(&bin._strings_buffer[*cast(uint*)prop.data.ptr]));
			break;

		default:
			throw new Exception("Unknown write property type");
			//break;
	}
}