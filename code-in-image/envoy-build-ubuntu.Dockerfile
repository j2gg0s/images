ARG SHA=7304f974de2724617b7492ccb4c9c58cd420353a

FROM envoyproxy/envoy-build-ubuntu:${SHA}

RUN apt update && \
    apt install -y \
      git \
      zsh \
      universal-ctags \
      vim

# init bazel
RUN bazel

RUN git clone https://github.com/envoyproxy/envoy.git /root/envoy
WORKDIR /root/envoy

ARG COMMIT_SHA=82e1102d6dff2863f2db652f84a92a6463fc3bd6
RUN git checkout ${COMMIT_SHA} && \
    bazel build envoy

RUN chsh -s /bin/sh && \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc

RUN apt install -y clangd-12 && \
    update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-12 100 && \
    printf 'load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")\n\n# Hedrons Compile Commands Extractor for Bazel\n# https://github.com/hedronvision/bazel-compile-commands-extractor\nhttp_archive(\nname = "hedron_compile_commands",\n# Replace the commit hash in both places (below) with the latest, rather than using the stale one here.\n# Even better, set up Renovate and let it do the work for you (see "Suggestion: Updates" in the README).\nurl = "https://github.com/hedronvision/bazel-compile-commands-extractor/archive/1266d6a25314d165ca78d0061d3399e909b7920e.tar.gz",\nstrip_prefix = "bazel-compile-commands-extractor-1266d6a25314d165ca78d0061d3399e909b7920e",\n# When you first run this tool, itll recommend a sha256 hash to put here with a message like: "DEBUG: Rule hedron_compile_commands indicated that a canonical reproducible form can be obtained by modifying arguments sha256 = ..."\n)\nload("@hedron_compile_commands//:workspace_setup.bzl", "hedron_compile_commands_setup")\nhedron_compile_commands_setup()' >> WORKSPACE && \
    bazel run @hedron_compile_commands//:refresh_all
