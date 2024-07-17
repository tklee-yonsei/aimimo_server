# Server Setup

## 세션 가이드

### tmux

세션을 유지하기 위해 `tmux` 또는 `screen`과 같은 것을 사용하기를 권장합니다.

#### 세션 시작

```shell
$ tmux new -s [세션이름]
```

예제는 다음과 같습니다.

```shell
$ tmux new -s sionna_session
```

#### 세션 나가기

현재 세션에서 나갈 수 있습니다.

tmux 세션이 실행 중인 상태에서 `Ctrl` + `b` `d`를 누르면, 세션을 유지시킨 채 나올 수 있습니다.

#### 세션 목록보기 및 재접속

이런 식으로 목록을 확인할 수 있습니다.

```shell
$ tmux ls
sionna_session: 1 windows (created Wed Jul 17 10:56:24 2024)
```

그리고 실행했던 세션에 재접속 할 수 있습니다.

```shell
$ tmux attach-session -t [세션이름]
```

예제는 다음과 같습니다.

```shell
$ tmux attach-session -t sionna_session
```

#### 세션 강제 종료

세션에 재접속해서 `exit` 명령으로 종료시킬 수도 있으며,

세션에 접속하지 않고도 다음과 같은 명령을 수행하여 세션을 종료할 수 있습니다.

```shell
$ tmux kill-session -t [세션이름]
```

예제는 다음과 같습니다.

```shell
$ tmux kill-session -t sionna_session
```

## Docker 목록

### Sionna 0.18.0 (GPU)

기본 Sionna에 세팅되어 있는대로 수행합니다.

[https://github.com/NVlabs/sionna/blob/v0.18.0/DOCKERFILE](https://github.com/NVlabs/sionna/blob/v0.18.0/DOCKERFILE)을 토대로 만들어졌으며,

`Dockerfile-sionna_0.18.0-gpu` 파일을 통해 수행할 수 있습니다.

#### Docker 이미지 빌드

```shell
$ docker build -t sionna_0.18.0 -f Dockerfile-sionna_0.18.0-gpu .
```

#### Docker 컨테이너 실행

컨테이너를 실행할 때, `tmux`로 세션을 만들고 수행하면, 이후 관리가 편리합니다.

아래의 명령을 `[주피터 노트북이 저장될 경로]`를 변경하여 실행합니다. 절대 경로로 수정합니다.

```shell
$ docker run -p 8888:8888 --privileged=true --gpus=all \
    --mount type=bind,src="[주피터 노트북이 저장될 경로]",target="/app/notes" \
    --env NVIDIA_DRIVER_CAPABILITIES=graphics,compute,utility \
    --rm -it --name sionna_0.18.0_container sionna_0.18.0
```

예제는 다음과 같습니다.

```shell
$ docker run -p 8888:8888 --privileged=true --gpus=all \
    --mount type=bind,src="/home/tklee/aimimo_code/notes",target="/app/notes" \
    --env NVIDIA_DRIVER_CAPABILITIES=graphics,compute,utility \
    --rm -it --name sionna_0.18.0_container sionna_0.18.0
```

### boston_twin

#### 셋업 및 다운로드

[Pypi](https://pypi.org/)에 업로드 한 내용이 없으므로, 직접 소스코드를 활용해야 합니다.
이 셋업 및 데이터세트 설정은 한 번만 수행하면 됩니다.

1. Bostontwin을 받을 경로로 이동합니다. (가령, `/home/tklee/aimimo_code/boston_twin`으로 하고 싶은 경우, `/home/tklee/aimimo_code`으로 이동하여 git clone을 수행합니다.)

2. [bostontwin](https://github.com/wineslab/boston_twin)에서 코드를 가져옵니다.

```shell
$ git clone https://github.com/wineslab/boston_twin.git
```

이 명령을 수행하여, 저는 `/home/tklee/aimimo_code/boston_twin` 이 경로에 Bostontwin을 받았습니다.

3. 데이터셋 다운로드

코드를 클론한 폴더(`/home/tklee/aimimo_code/boston_twin`)로 이동하여, 다음을 수행합니다.

```shell
$ mkdir bostontwin
$ cd bostontwin
$ wget https://repository.library.northeastern.edu/downloads/neu:4f232h94c?datastream_id=content -O BostonTwin_dataset.zip
$ unzip BostonTwin_dataset.zip
```

#### Docker 이미지 빌드

`aimimo_server` 폴더에서, `bostontwin` 이미지를 빌드합니다.

```shell
$ docker build -t boston_twin -f Dockerfile-bostontwin .
```

#### Docker 컨테이너 실행

컨테이너를 실행할 때, `tmux`로 세션을 만들고 수행하면, 이후 관리가 편리합니다.

아래의 명령을 `[주피터 노트북이 저장될 경로]`를 변경하여 실행합니다. 절대 경로로 수정합니다.

```shell
$ docker run -p 8888:8888 --privileged=true --gpus=all \
    --mount type=bind,src="[주피터 노트북이 저장될 경로]",target="/app/notes" \
    --mount type=bind,src="/home/tklee/aimimo_code/boston_twin",target="/app" \
    --env NVIDIA_DRIVER_CAPABILITIES=graphics,compute,utility \
    --rm -it --name boston_twin_container boston_twin
```

예제는 다음과 같습니다.

```shell
$ docker run -p 8888:8888 --privileged=true --gpus=all \
    --mount type=bind,src="/home/tklee/aimimo_code/notes",target="/app/notes" \
    --mount type=bind,src="/home/tklee/aimimo_code/boston_twin",target="/app" \
    --env NVIDIA_DRIVER_CAPABILITIES=graphics,compute,utility \
    --rm -it --name boston_twin_container boston_twin
```

## (개발자 용) 코드 편집 및 활용

### sh 파일 설정

터미널에서 sh 파일들에 대한 권한을 주어야 합니다. 이렇게 함으로, cmd 폴더 안에 있는 `sh` 파일들에 실행 권한을 줍니다.

```shell
$ chmod +x cmd/*
```

### 서버 지정

1. `보기 > 명령 팔레트`에서, `Tasks: Run Task`를 실행합니다.
2. 이후, `원격 설정`을 실행합니다. 
3. 이 명령을 수행하면, `.env/remote_server_config` 파일이 생성되며, 이 파일을 편집하여, 전체 코드를 전송할 서버를 지정할 수 있습니다.

### 서버 전송

1. `보기 > 명령 팔레트`에서, `Tasks: Run Task`를 실행합니다.
2. 이후, `원격으로 배포하기`를 실행합니다. 
3. 이 명령을 수행하면, `.env/remote_server_config`에 지정된 곳으로 코드를 전송합니다. 단, `rsync_exclude`에 지정된 파일은 제외합니다.

### 서버에서 가져오기

1. `보기 > 명령 팔레트`에서, `Tasks: Run Task`를 실행합니다.
2. 이후, `원격으로부터 가져오기`를 실행합니다. 
3. 이 명령을 수행하면, 서버에서 파일을 가져옵니다. 단, `rsync_exclude`에 지정된 파일은 제외합니다.
