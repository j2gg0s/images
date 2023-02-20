ARG TAG=release-1.16-025cd87a38a3864495e5f54a1916c04cd33ebacd

FROM gcr.io/istio-testing/build-tools-proxy:${TAG}

RUN git clone https://github.com/istio/proxy.git /root/proxy
WORKDIR /root/proxy

RUN git checkout tags/1.16.0 && \
    make build

RUN printf 'load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")\n\n# Hedrons Compile Commands Extractor for Bazel\n# https://github.com/hedronvision/bazel-compile-commands-extractor\nhttp_archive(\nname = "hedron_compile_commands",\n# Replace the commit hash in both places (below) with the latest, rather than using the stale one here.\n# Even better, set up Renovate and let it do the work for you (see "Suggestion: Updates" in the README).\nurl = "https://github.com/hedronvision/bazel-compile-commands-extractor/archive/1266d6a25314d165ca78d0061d3399e909b7920e.tar.gz",\nstrip_prefix = "bazel-compile-commands-extractor-1266d6a25314d165ca78d0061d3399e909b7920e",\n# When you first run this tool, itll recommend a sha256 hash to put here with a message like: "DEBUG: Rule hedron_compile_commands indicated that a canonical reproducible form can be obtained by modifying arguments sha256 = ..."\n)\nload("@hedron_compile_commands//:workspace_setup.bzl", "hedron_compile_commands_setup")\nhedron_compile_commands_setup()' >> WORKSPACE && \
    bazel run @hedron_compile_commands//:refresh_all

RUN apt update && \
    apt install -y \
        zsh

RUN chsh -s /bin/sh && \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc

RUN git clone https://github.com/universal-ctags/ctags.git && \
    cd ctags && ./autogen.sh && ./configure && make && make install

RUN git clone https://github.com/j2gg0s/vim.git /root/.vim && \
    rm /root/.vimrc && ln -s /root/.vim/vimrc /root/.vimrc && \
    rm /root/.zshrc && ln -s /root/.vim/zshrc /root/.zshrc && \
    rm /root/.gitconfig && ln -s /root/.vim/gitconfig /root/.gitconfig && \
    git clone https://github.com/j2gg0s/images.git /root/images
