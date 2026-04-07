{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "beyla";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "beyla";
    rev = "v${version}";
    hash = "sha256-W9KUFDod0rwpPxh9C0OiAVsAMqo/G85F5z+59qgupa8=";
  };

  vendorHash = null;

  postPatch = ''
    substituteInPlace go.mod \
      --replace-fail \
        $'replace go.opentelemetry.io/obi => ./.obi-src\n' \
        ""
    sed -i 's| => \./\.obi-src||g' vendor/modules.txt
  '';
  subPackages = ["cmd/beyla"];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=v${version}"
  ];

  env.CGO_ENABLED = "0";

  meta = with lib; {
    description = "eBPF-based autoinstrumentation of web applications and network metrics";
    homepage = "https://github.com/grafana/beyla";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with lib.maintainers; [ bovi ];
  };
}
