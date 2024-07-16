# Server Setup

## Docker 목록

### Sionna 0.18.0 (GPU)

기본 Sionna에 세팅되어 있는대로 수행합니다.

[https://github.com/NVlabs/sionna/blob/v0.18.0/DOCKERFILE](https://github.com/NVlabs/sionna/blob/v0.18.0/DOCKERFILE)을 토대로 만들어졌으며,

`Dockerfile-sionna_0.18.0-gpu` 파일을 통해 수행할 수 있습니다.

#### 이미지 빌드

```shell
$ docker build -t sionna_0.18.0 -f Dockerfile-sionna_0.18.0-gpu .
```

#### 컨테이너 실행

아래의 명령을 `[주피터 노트북이 저장될 경로]`를 변경하여 실행합니다. 절대 경로로 수정합니다.

```shell
$ docker run -p 8888:8888 --privileged=true --gpus=all --mount type=bind,src="[주피터 노트북이 저장될 경로]",target="/app" --env NVIDIA_DRIVER_CAPABILITIES=graphics,compute,utility --rm -it --name sionna_0.18.0_container sionna_0.18.0
```

예제는 다음과 같습니다.

```shell
$ docker run -p 8888:8888 --privileged=true --gpus=all --mount type=bind,src="/home/tklee/aimimo_code/notes",target="/app" --env NVIDIA_DRIVER_CAPABILITIES=graphics,compute,utility --rm -it --name sionna_0.18.0_container sionna_0.18.0
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
