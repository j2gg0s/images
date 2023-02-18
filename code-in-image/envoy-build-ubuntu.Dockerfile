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

RUN chsh -s /bin/sh &&
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc
