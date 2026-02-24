$script = {
    # Regenerate bindings
    dotnet run --project src/Core/Silk.NET.BuildTools generator.json --profile=FreeType
    dotnet run --project src/Core/Silk.NET.BuildTools generator.json --profile=HarfBuzz
    dotnet run --project src/Core/Silk.NET.BuildTools generator.json --profile=VulkanMemoryAllocator
    dotnet run --project src/Core/Silk.NET.BuildTools generator.json --profile=Tracy
    dotnet run --project src/Core/Silk.NET.BuildTools generator.json --profile=Slang

    # Ensure solution contains only the relevant projects
    nuke sln --projects Silk.NET.FreeType Silk.NET.HarfBuzz Silk.NET.Vulkan.Vma Silk.NET.Tracy Silk.NET.Slang

    # Clear outputs folder
    Remove-Item -Path "build\output_packages/*" -Recurse -Force

    # Create NuGet packages for all bindings
    # Increment versions before running this script
    nuke pack --Configuration Release --msbuild-properties VersionSuffix=Exanite-2
    # nuke pack --Configuration Debug --msbuild-properties VersionSuffix=Exanite-2-Debug-1
}

Push-Location -Path $PSScriptRoot/submodules/Silk.NET
try {
    & $script
}
finally {
    Pop-Location
}
