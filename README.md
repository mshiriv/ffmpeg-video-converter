# ffmpeg-video-converter
This project created inorder to convert video(add watermark,resolution change and ... ) as needs via ffmpeg video converter.
first at all,you should install ffmpeg package on your linux system:

```bash
sudo yum install epel-release -y
```

There are no official FFmpeg rpm packages for CentOS for now. Instead, you can use a 3rd-party YUM repo, Nux Dextop, to finish the job.
On CentOS 7, you can install the Nux Dextop YUM repo with the following commands:

`sudo rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro`
`sudo rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm`

For CentOS 6, you need to install another release:

`sudo rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro`
`sudo rpm -Uvh http://li.nux.ro/download/nux/dextop/el6/x86_64/nux-dextop-release-0-2.el6.nux.noarch.rpm`

Now we should install FFmpeg and FFmpeg development packages

`sudo yum install ffmpeg ffmpeg-devel -y`

To install ffmpeg on debian system,Debian 8 "Jessie",edit the source list:

`sudo nano /etc/apt/sources.list`

Add the following lines at the end of the file:

`\# deb-multimedia
deb http://www.deb-multimedia.org jessie main non-free
deb-src http://www.deb-multimedia.org jessie main non-free`

`\# jessie-backports
deb http://httpredir.debian.org/debian/ jessie-backports main`

Update the package list and install deb-multimedia keyring:

`sudo apt-get update
sudo apt-get install deb-multimedia-keyring
sudo apt-get update`

Install FFmpeg with the following command:

`sudo apt-get install ffmpeg`

Update the package list and install ffmpeg:

`sudo apt-get update
sudo apt-get install ffmpeg`

After installing ffmpeg package, copy video-convert.sh to your system and get execution permission to the script:

`sudo chmod u+x video-convert.sh`

before running the script, edit script parameters according your needs and requirements.all the parameters explained with example. 
