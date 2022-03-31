module keytypes;

import main: FxKey, PropertyType;

/*
ParticleSystem
Sprite
LTBModel
DynaLight
Sound
CameraShake
Create
CreateRay
FlareSprite
Lightning
Tracer
LensFlare
DebrisSystem
VideoController
Decal
Overlay
PolyTrail
Rumble
*/

protected:
// Property Enum -> String

// SmoothShutDown, UseRadius, AllowHigherLayers, Loop,
// OnWorldModels, Solid, TranslucentLight, TwoSided, CanOverlap
// AlignToCamera, AlignAroundZ, RandomRotation, PlayerView
// Directional
// BlockedByGeometry
// ForceTranslucent, OverrideAniLength, SyncToKey
// AllowHigherLayers
// CropTexture, FitLengthToRay, StartEmitted, UseTargetPos
// MoveParticlesWithSystem, InfiniteLife, RotateParticles, Streak, EnableBounceScale
// PlayLocal
// CastVisibleRay
immutable string[] Boolean=["No", "Yes"];

// Shared
immutable string[] UpdatePos=["Fixed", "Follow", "NodeAttach", "SocketAttach"];
immutable string[] DetailLevel=["All", "High", "Medium", "Low", "Medium+High", "Low+Medium", "Low+High"];
immutable string[] IsGore=["No", "Yes", "LowViolenceOnly"];
immutable string[] SlowMotion=["All", "SlowMoOnly", "NoSlowMo"];

// CameraShake
immutable string[] Falloff=["Linear", "Quartic", "Constant"];

// CreateRay
immutable string[] Alignment=["ToSource", "Normal", "Outgoing", "ToViewer"];

// DebrisSystem
immutable string[] EmissionType=["Sphere", "Point", "Cone", "Cylinder", "Box"];
immutable string[] OrientationType=["Random", "Position", "Parent", "Velocity"];
immutable string[] TypeSelection=["Random", "Sequential"];
immutable string[] ShapeN=["Sphere", "Box", "Capsule"];

// DynaLight
immutable string[] LightLod=["Low", "Medium", "High", "Never"]; // LightLOD, WorldShadowsLOD, ObjectShadowsLOD
immutable string[] InSky=["No", "Yes", "Overlay"];
immutable string[] DynaLightType=["Point", "PointFill", "Spot", "Cubic", "BlackLight"];

// VideoController
immutable string[] VideoOperation=["Pause", "Unpause", "Restart", "SinglePlay"];

// FlareSprite
immutable string[] ObjectAngle=["Sprite", "Camera"]; // ObjectAngle, BlindObjectAngle

// Lightning
immutable string[] BoltType=["None", "Sine", "Sawtooth", "Noise"];

// ParticleSystem
immutable string[] VelocityType=["Random", "FromCenter"];

// PolyTrail
immutable string[] DistanceNode=["ObjectPos", "Node1", "Node2"];

// XP
immutable string[] CanIntersectCharacters=["False", "True", "Only"];

public:
string GetPropertyEnumString(string prop, uint index)
{
	switch(prop)
	{
		case "SmoothShutDown":
		case "UseRadius":
		case "AllowHigherLayers":
		case "Loop":
		case "OnWorldModels":
		case "Solid":
		case "TranslucentLight":
		case "TwoSided":
		case "CanOverlap":
		case "AlignToCamera":
		case "AlignAroundZ":
		case "RandomRotation":
		case "PlayerView":
		case "Directional":
		case "BlockedByGeometry":
		case "ForceTranslucent":
		case "OverrideAniLength":
		case "SyncToKey":
		case "CropTexture":
		case "FitLengthToRay":
		case "StartEmitted":
		case "UseTargetPos":
		case "MoveParticlesWithSystem":
		case "InfiniteLife":
		case "RotateParticles":
		case "Streak":
		case "EnableBounceScale":
		case "PlayLocal":
		case "CastVisibleRay":
		// XP
		case "IgnoreParentRotation":
		case "PassOnTargetInfo":
		case "LimitThisFX":
		case "CheckForDetachment":
			return Boolean[index];

		case "UpdatePos":
			return UpdatePos[index];

		case "DetailLevel":
			return DetailLevel[index];

		case "IsGore":
			return IsGore[index];

		case "SlowMotion":
			return SlowMotion[index];

		case "Falloff":
			return Falloff[index];

		case "Alignment":
			return Alignment[index];

		case "EmissionType":
			return EmissionType[index];

		case "OrientationType":
			return OrientationType[index];

		case "TypeSelection":
			return TypeSelection[index];

		case "Shape_1":
		case "Shape_2":
		case "Shape_3":
		case "Shape_4":
		case "Shape_5":
			return ShapeN[index];

		case "LightLOD":
		case "ShadowLOD":
		case "WorldShadowsLOD":
		case "ObjectShadowsLOD":
			return LightLod[index];

		case "InSky":
			return InSky[index];

		case "VideoOperation":
			return VideoOperation[index];

		case "ObjectAngle":
		case "BlindObjectAngle":
			return ObjectAngle[index];

		case "Type":
			return DynaLightType[index];

		case "Type0":
		case "Type1":
		case "Type2":
		case "Type3":
			return BoltType[index];

		case "VelocityType":
			return VelocityType[index];

		case "DistanceNode":
			return DistanceNode[index];

		// XP
		case "CanIntersectCharacters":
			return CanIntersectCharacters[index];

		default:
			throw new Exception("Unknown property name -> enum string");
			//return "Unknown";
	}
}

PropertyType GetPropTypeFromName(string name)
{
	switch(name)
	{
		case "AttachName":
		case "CollisionEffect":
		case "NodeAttractors":
		case "SocketAttractors":
		case "FloatParam0":
		case "FloatParam1":
		case "TrackedNode1":
		case "TrackedNode2":
		case "SoundCue":
		case "AltSoundCue":
		// XP
		case "NormalDecal": // filename?
			return PropertyType.String;

		case "InitialRotation":
		case "Rotation":
		case "Offset":
		case "MaxPositionOffset":
		case "MaxRotationDeg":
		case "EmissionDims":
		case "EmissionDir":
		case "MinLinearVelocity":
		case "MaxLinearVelocity":
		case "MinAngularVelocity":
		case "MaxAngularVelocity":
		case "ShapeDims_1":
		case "ShapeDims_2":
		case "ShapeDims_3":
		case "ShapeDims_4":
		case "ShapeDims_5":
		case "AttractorConeDir":
		case "EmissionOffset":
		case "AdditionalAcceleration":
		case "MinParticleVelocity":
		case "MaxParticleVelocity":
		case "NodeOffset1":
		case "NodeOffset2":
			return PropertyType.Vector;

		case "MenuLayer":
		case "NumToCreate":
		case "MinPieces":
		case "MaxPieces":
		case "RenderLayer":
		case "NumImages":
		case "Image0":
		case "Image1":
		case "Image2":
		case "Image3":
		case "Image4":
		case "Image5":
		case "Image6":
		case "Image7":
		case "Image8":
		case "Image9":
		case "Image10":
		case "Image11":
		case "Image12":
		case "Image13":
		case "Image14":
		case "Image15":
		case "BoltsPerEmission":
		case "Layer":
		case "ParticlesPerEmission":
		case "Volume":
		case "Priority":
		case "MixChannel":
		// XP
		case "MaxIntersectTries":
		case "ChildMaxBolts":
		case "GrandchildMaxBolts":
		case "DTDecalLayer_1":
		case "DTDecalLayer_2":
		case "DTDecalLayer_3":
			return PropertyType.Int;

		case "Intensity":
		case "Radius":
		case "MinFovXScale":
		case "MaxFovXScale":
		case "MinFovYScale":
		case "MaxFovYScale":
		case "MinDist":
		case "MaxDist":
		case "EffectOffset":
		case "RandomCone":
		case "CenterBias":
		case "MinRadius":
		case "MaxRadius":
		case "MinCollisionForce":
		case "MassKg_1":
		case "MassKg_2":
		case "MassKg_3":
		case "MassKg_4":
		case "MassKg_5":
		case "DensityG_1":
		case "DensityG_2":
		case "DensityG_3":
		case "DensityG_4":
		case "DensityG_5":
		case "Friction_1":
		case "Friction_2":
		case "Friction_3":
		case "Friction_4":
		case "Friction_5":
		case "COR_1":
		case "COR_2":
		case "COR_3":
		case "COR_4":
		case "COR_5":
		case "Width":
		case "Height":
		case "Depth":
		case "ForwardDepth":
		case "FalloffAngle":
		case "ScaleMin":
		case "ScaleMax":
		case "RotationalVel":
		case "ToCameraOffset":
		case "AspectWidth":
		case "AspectHeight":
		case "MinAngle":
		case "MinAlpha":
		case "MaxAlpha":
		case "MinScale":
		case "MaxScale":
		case "BlindSpriteAngle":
		case "BlindMaxScale":
		case "VisibleDistance":
		case "VisibleRadius":
		case "Scale0":
		case "Offset0":
		case "Scale1":
		case "Offset1":
		case "Scale2":
		case "Offset2":
		case "Scale3":
		case "Offset3":
		case "Scale4":
		case "Offset4":
		case "Scale5":
		case "Offset5":
		case "Scale6":
		case "Offset6":
		case "Scale7":
		case "Offset7":
		case "Scale8":
		case "Offset8":
		case "Scale9":
		case "Offset9":
		case "Scale10":
		case "Offset10":
		case "Scale11":
		case "Offset11":
		case "Scale12":
		case "Offset12":
		case "Scale13":
		case "Offset13":
		case "Scale14":
		case "Offset14":
		case "Scale15":
		case "Offset15":
		case "InnerAttractorRadius":
		case "AttractorRadius":
		case "AttractorConeAngle":
		case "StartAttractionDist":
		case "EndAttractionDist":
		case "TextureLength":
		case "UPanSpeed":
		case "EmissionInterval":
		case "MinBoltLifetime":
		case "MaxBoltLifetime":
		case "MinBoltAngle":
		case "MaxBoltAngle":
		case "SegmentLength":
		case "AmplitudeMin":
		case "AmplitudeMax":
		case "FrequencyMin":
		case "FrequencyMax":
		case "PitchVelMin":
		case "PitchVelMax":
		case "PitchMinOffset":
		case "PitchMaxOffset":
		case "Amplitude0":
		case "Frequency0":
		case "PitchVelocity0":
		case "AngularMin0":
		case "AngularMax0":
		case "Amplitude1":
		case "Frequency1":
		case "PitchVelocity1":
		case "AngularMin1":
		case "AngularMax1":
		case "Amplitude2":
		case "Frequency2":
		case "PitchVelocity2":
		case "AngularMin2":
		case "AngularMax2":
		case "Amplitude3":
		case "Frequency3":
		case "PitchVelocity3":
		case "AngularMin3":
		case "AngularMax3":
		case "ModelScale":
		case "AniLength":
		case "YHeight":
		case "FloatValue0":
		case "FloatValue1":
		case "Thickness":
		case "Velocity":
		case "MaxDistance":
		case "LightRadius":
		case "GroupCreationInterval":
		case "EmissionMinRadius":
		case "EmissionMaxRadius":
		case "ParticleScale":
		case "MinParticleLifeSpan":
		case "MaxParticleLifeSpan":
		case "GravityScale":
		case "Drag":
		case "StreakScale":
		case "PercentToBounce":
		case "BounceStrength":
		case "SplatPercent":
		case "SingleNodeWidth":
		case "SampleFrequency":
		case "SampleLifetime":
		case "UTexCoord1":
		case "UTexCoord2":
		case "Intensity0":
		case "Intensity1":
		case "InnerRadius":
		case "OuterRadius":
		case "PitchShift":
		case "AltSoundRadius":
		case "Scale":
		case "MinOverallScale":
		case "MaxOverallScale":
		case "Frequency":
		case "FovX":
		case "FovY":
		case "FlickerScale":
		case "OverlapScale":
		case "BlindCameraAngle":
		case "MinWidth":
		case "MaxWidth":
		case "Length":
		// XP
		case "NormalDecalOffsetFactor":
		case "NormalDecalOffsetMax":
		case "ChildDistanceBetweenBoltsMin":
		case "ChildDistanceBetweenBoltsMax":
		case "ChildEmissionProbability":
		case "ChildInnerConeAngle":
		case "ChildOuterConeAngle":
		case "ChildConeBias":
		case "ChildLengthMin":
		case "ChildLengthMax":
		case "ChildWidthMin":
		case "ChildWidthMax":
		case "ChildScaleFactor":
		case "ChildLifetimeMin":
		case "ChildLifetimeMax":
		case "GrandchildDistanceBetweenBoltsMin":
		case "GrandchildDistanceBetweenBoltsMax":
		case "GrandchildEmissionProbability":
		case "GrandchildInnerConeAngle":
		case "GrandchildOuterConeAngle":
		case "GrandchildConeBias":
		case "GrandchildLengthMin":
		case "GrandchildLengthMax":
		case "GrandchildWidthMin":
		case "GrandchildWidthMax":
		case "GrandchildScaleFactor":
		case "GrandchildLifetimeMin":
		case "GrandchildLifetimeMax":
		case "ShrinkRate": // possibly function?
		case "DTVertLifetime_1":
		case "DTVertFadeRate_1":
		case "DTScale_1":
		case "DTVertLifetime_2":
		case "DTVertFadeRate_2":
		case "DTScale_2":
		case "DTVertLifetime_3":
		case "DTVertFadeRate_3":
		case "DTScale_3":
			return PropertyType.Float;

		case "UpdatePos":
		case "SmoothShutDown":
		case "DetailLevel":
		case "IsGore":
		case "SlowMotion":
		case "VideoOperation":
		case "UseRadius":
		case "Falloff":
		case "Loop":
		case "Alignment":
		case "EmissionType":
		case "OrientationType":
		case "VelocityType":
		case "TypeSelection":
		case "Shape_1":
		case "Shape_2":
		case "Shape_3":
		case "Shape_4":
		case "Shape_5":
		case "OnWorldModels":
		case "Solid":
		case "TranslucentLight":
		case "TwoSided":
		case "CanOverlap":
		case "AlignToCamera":
		case "AlignAroundZ":
		case "RandomRotation":
		case "InSky":
		case "PlayerView":
		case "ObjectAngle":
		case "Directional":
		case "BlockedByGeometry":
		case "Type0":
		case "Type1":
		case "Type2":
		case "Type3":
		case "ForceTranslucent":
		case "ShadowLOD":
		case "OverrideAniLength":
		case "SyncToKey":
		case "AllowHigherLayers":
		case "CropTexture":
		case "FitLengthToRay":
		case "StartEmitted":
		case "UseTargetPos":
		case "LightLOD":
		case "WorldShadowsLOD":
		case "ObjectShadowsLOD":
		case "MoveParticlesWithSystem":
		case "InfiniteLife":
		case "RotateParticles":
		case "Streak":
		case "EnableBounceScale":
		case "DistanceNode":
		case "PlayLocal":
		case "CastVisibleRay":
		case "Type":
		case "BlindObjectAngle":
		// XP
		case "IgnoreParentRotation":
		case "PassOnTargetInfo":
		case "LimitThisFX":
		case "CanIntersectCharacters":
		case "CheckForDetachment":
			return PropertyType.Enum;

		case "AttachEffect":
		case "SplatEffect":
		case "Effect_1":
		case "Effect_2":
		case "Effect_3":
		case "Effect_4":
		case "Effect_5":
		case "Effect0":
		case "Effect1":
		case "Effect2":
		case "Effect3":
		case "Effect4":
		case "Effect5":
		case "Effect6":
		case "Effect7":
		case "Effect8":
		case "Effect9":
		case "Effect10":
		case "Effect11":
		case "Effect12":
		case "Effect13":
		case "Effect14":
		case "Effect15":
			return PropertyType.ClientFXRef;

		case "Color":
		case "Color0":
		case "Color1":
		case "Color2":
		case "Color3":
		case "Color4":
		case "Color5":
		case "Color6":
		case "Color7":
		case "Color8":
		case "Color9":
		case "Color10":
		case "Color11":
		case "Color12":
		case "Color13":
		case "Color14":
		case "Color15":
		case "BoltColor":
		case "ModelColor":
		case "LightColor":
		case "ParticleColor":
		case "SampleColor":
		case "TranslucentColor":
		case "SpecularColor":
			return PropertyType.Color;

		case "VideoName":
		case "Material":
		case "Model":
		case "Material0":
		case "Material1":
		case "Material2":
		case "Material3":
		case "Material4":
		case "OverlayMaterial":
		case "EdgeMaterial":
		case "Sound1":
		case "Sound2":
		case "Sound3":
		case "Sound4":
		case "Sound5":
		case "Sound6":
		case "Sound7":
		case "Sound8":
		case "Sound9":
		case "Sound10":
		case "AltSound1":
		case "AltSound2":
		case "AltSound3":
		case "AltSound4":
		case "AltSound5":
		case "AltSound6":
		case "AltSound7":
		case "AltSound8":
		case "AltSound9":
		case "AltSound10":
		case "Texture":
		// XP
		case "ChildMaterial":
		case "GrandchildMaterial":
		case "DTMaterialLink_1":
		case "DTMaterialEnd_1":
		case "DTMaterialLink_2":
		case "DTMaterialEnd_2":
		case "DTMaterialLink_3":
		case "DTMaterialEnd_3":
			return PropertyType.Filename;

		case "AniName":
			return PropertyType.Animation;

		default:
			return PropertyType.Unknown;
			//throw new Exception("Trying to convert unknown property name to type");
	}
}

bool GetPropertyIsFunc(FxKey.KeyType type, string prop)
{
	switch(prop)
	{
		case "Rotation":
		case "Offset":
		case "Intensity":
		case "Radius":
		case "MaxPositionOffset":
		case "MaxRotationDeg":
		case "MinFovXScale":
		case "MaxFovXScale":
		case "MinFovYScale":
		case "MaxFovYScale":
		case "Type":
		case "FlickerScale":
		case "TranslucentColor":
		case "SpecularColor":
		case "FovX":
		case "FovY":
		case "VisibleDistance":
		case "UPanSpeed":
		case "BoltsPerEmission":
		case "MinBoltLifetime":
		case "MaxBoltLifetime":
		case "MinBoltAngle":
		case "MaxBoltAngle":
		case "BoltColor":
		case "Amplitude0":
		case "Amplitude1":
		case "Amplitude2":
		case "Amplitude3":
		case "Frequency0":
		case "Frequency1":
		case "Frequency2":
		case "Frequency3":
		case "PitchVelocity0":
		case "PitchVelocity1":
		case "PitchVelocity2":
		case "PitchVelocity3":
		case "ModelColor":
		case "ModelScale":
		case "YHeight":
		case "FloatValue0":
		case "FloatValue1":
		case "Thickness":
		case "ParticlesPerEmission":
		case "EmissionOffset":
		case "EmissionMinRadius":
		case "EmissionMaxRadius":
		case "ParticleColor":
		case "ParticleScale":
		case "MinParticleLifespan":
		case "MaxParticleLifespan":
		case "GravityScale":
		case "AdditionalAcceleration":
		case "MinParticleVelocity":
		case "MaxParticleVelocity":
		case "Drag":
		case "PercentToBounce":
		case "SplatPercent":
		case "SampleColor":
		case "Intensity0":
		case "Intensity1":
		case "Scale":
		case "Frequency":
			return true;

		case "EmissionDims":
			if (type==FxKey.KeyType.DebrisSystem)
				return false;
			return true;

		case "Color":
			if (type==FxKey.KeyType.LensFlare)
				return false;
			return true;

		case "AspectWidth":
		case "AspectHeight":
			if (type==FxKey.KeyType.FlareSprite || type==FxKey.KeyType.Sprite)
				return false;
			return true;

		default:
			return false;
	}
}