class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data."
  homepage "https://google.github.io/jsonnet/doc/"
  url "https://github.com/google/jsonnet/archive/v0.7.9.tar.gz"
  sha256 "103a262636b8db3bfc7dcef7a5d93912d6bf713dd468e188760f6622a9889e44"

  needs :cxx11

  depends_on :macos => :yosemite

  def install
    ENV.cxx11
    system "make"
    bin.install "jsonnet"
  end

  test do
    require "json"

    (testpath/"example.jsonnet").write <<-EOS
      {
        person1: {
          name: "Alice",
          welcome: "Hello " + self.name + "!",
        },
        person2: self.person1 { name: "Bob" },
      }
    EOS

    expected_output = <<-EOS
      {
        "person1": {
          "name": "Alice",
          "welcome": "Hello Alice!"
        },
        "person2": {
          "name": "Bob",
          "welcome": "Hello Bob!"
        }
      }
    EOS

    output = shell_output("#{bin}/jsonnet #{testpath}/example.jsonnet")

    assert_equal JSON.parse(expected_output), JSON.parse(output)
  end
end
