import Rfam
import Gzip_jll
import Tar
using Test: @test
using Test: @test_throws
using Test: @testset

function gzip_file(path::AbstractString)
    open(path * ".gz", "w") do io
        run(pipeline(`$(Gzip_jll.gzip()) -c $path`, stdout = io))
    end
    return path * ".gz"
end

function write_remote_fixture(remote_root::AbstractString)
    mkpath(joinpath(remote_root, "fasta_files"))

    fasta_path = joinpath(remote_root, "fasta_files", "RF00162.fa")
    write(fasta_path, ">RF00162\nACGU\n")
    gzip_file(fasta_path)
    rm(fasta_path)

    cm_path = joinpath(remote_root, "Rfam.cm")
    write(cm_path, "INFERNAL1/a\n")
    gzip_file(cm_path)
    rm(cm_path)

    seed_path = joinpath(remote_root, "Rfam.seed")
    write(seed_path, "# STOCKHOLM 1.0\n//\n")
    gzip_file(seed_path)
    rm(seed_path)

    write(joinpath(remote_root, "Rfam.clanin"), "CL00001\tTest clan\n")

    tree_root = mkpath(joinpath(remote_root, "tree_payload", "Rfam.seed_tree"))
    write(joinpath(tree_root, "RF00162.seed_tree"), "(RF00162);\n")
    Tar.create(joinpath(remote_root, "tree_payload"), joinpath(remote_root, "Rfam.seed_tree.tar.gz"))
    rm(joinpath(remote_root, "tree_payload"); recursive = true)

    return (
        fasta = ">RF00162\nACGU\n",
        cm = "INFERNAL1/a\n",
        seed = "# STOCKHOLM 1.0\n//\n",
        clanin = "CL00001\tTest clan\n",
        seed_tree = "(RF00162);\n",
    )
end

@testset "path helpers" begin
    rfam_dir = mktempdir()
    rfam_version = "14.7"

    @test Rfam.base_url(; rfam_version) == "https://ftp.ebi.ac.uk/pub/databases/Rfam/14.7"
    @test Rfam.version_dir(; rfam_dir, rfam_version) == joinpath(rfam_dir, rfam_version)
    @test isdir(Rfam.version_dir(; rfam_dir, rfam_version))
    @test Rfam.fasta_dir(; rfam_dir, rfam_version) == joinpath(rfam_dir, rfam_version, "fasta_files")
    @test isdir(Rfam.fasta_dir(; rfam_dir, rfam_version))
end

@testset "preferences" begin
    saved_dir = try
        Rfam.get_rfam_directory()
    catch
        nothing
    end
    saved_version = try
        Rfam.get_rfam_version()
    catch
        nothing
    end

    rfam_dir = mktempdir()
    rfam_version = "offline-test-version"

    try
        Rfam.set_rfam_directory(rfam_dir)
        @test Rfam.get_rfam_directory() == rfam_dir
        @test_throws ArgumentError Rfam.set_rfam_directory(joinpath(rfam_dir, "missing"))

        Rfam.set_rfam_version(rfam_version)
        @test Rfam.get_rfam_version() == rfam_version
    finally
        !isnothing(saved_dir) && Rfam.set_rfam_directory(saved_dir)
        !isnothing(saved_version) && Rfam.set_rfam_version(saved_version)
    end
end

@testset "offline downloads and caching" begin
    remote_root = mktempdir()
    local_root = mktempdir()
    rfam_version = "offline"
    expected = write_remote_fixture(remote_root)
    rfam_base_url = string(Base.fileurl(remote_root))

    fasta_path = Rfam.fasta_file("RF00162"; rfam_dir = local_root, rfam_version, rfam_base_url)
    cm_path = Rfam.cm(; rfam_dir = local_root, rfam_version, rfam_base_url)
    clanin_path = Rfam.clanin(; rfam_dir = local_root, rfam_version, rfam_base_url)
    seed_path = Rfam.seed(; rfam_dir = local_root, rfam_version, rfam_base_url)
    seed_tree_path = Rfam.seed_tree("RF00162"; rfam_dir = local_root, rfam_version, rfam_base_url)

    @test isfile(fasta_path)
    @test read(fasta_path, String) == expected.fasta

    @test isfile(cm_path)
    @test read(cm_path, String) == expected.cm

    @test isfile(clanin_path)
    @test read(clanin_path, String) == expected.clanin

    @test isfile(seed_path)
    @test read(seed_path, String) == expected.seed

    @test isfile(seed_tree_path)
    @test read(seed_tree_path, String) == expected.seed_tree

    rm(remote_root; recursive = true)

    @test Rfam.fasta_file("RF00162"; rfam_dir = local_root, rfam_version, rfam_base_url) == fasta_path
    @test Rfam.cm(; rfam_dir = local_root, rfam_version, rfam_base_url) == cm_path
    @test Rfam.clanin(; rfam_dir = local_root, rfam_version, rfam_base_url) == clanin_path
    @test Rfam.seed(; rfam_dir = local_root, rfam_version, rfam_base_url) == seed_path
    @test Rfam.seed_tree("RF00162"; rfam_dir = local_root, rfam_version, rfam_base_url) == seed_tree_path
end
