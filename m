From: "Salatiel Filho" <salatiel.filho@gmail.com>
Subject: iptables -> can't initialize iptables table `filter': Bad file descriptor
Date: Sun, 2 Dec 2007 16:22:58 -0300
Message-ID: <beb91d720712021122w93088ccjf4544c591df3c4b5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:53032 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbXLBTW7 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 2 Dec 2007 14:22:59 -0500
Received: by wa-out-1112.google.com with SMTP id v27so4444041wah
        for <netfilter-devel@vger.kernel.org>; Sun, 02 Dec 2007 11:22:58 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

HI guys , i don`t know if this is the right list , but i could not
find help anywhere else.
I am having a very strange problem with my machine , i can not use
iptables at all.
I have the modules compiled and loaded but i always get :

# iptables -L
iptables v1.3.6: can't initialize iptables table `filter': Bad file des=
criptor
Perhaps iptables or your kernel needs to be upgraded.


My machine is a ARM machine with debian 4.0.
I also have already tried 1.3.8 and got the same error.

# lsmod
Module                  Size  Used by
iptable_filter          2304  0
ip_tables              22016  1 iptable_filter


strace here:

strace iptables -L
execve("/sbin/iptables", ["iptables", "-L"], [/* 20 vars */]) =3D 0
uname({sys=3D"Linux", node=3D"LS-GL7D6", ...}) =3D 0
brk(0)                                  =3D 0x1c000
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or =
directory)
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) =3D 0x40015000
access("/etc/ld.so.preload", R_OK)      =3D -1 ENOENT (No such file or =
directory)
open("/etc/ld.so.cache", O_RDONLY)      =3D 3
fstat64(3, {st_mode=3DS_IFREG|0644, st_size=3D25798, ...}) =3D 0
mmap2(NULL, 25798, PROT_READ, MAP_PRIVATE, 3, 0) =3D 0x4001e000
close(3)                                =3D 0
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or =
directory)
open("/lib/libdl.so.2", O_RDONLY)       =3D 3
read(3, "\177ELF\1\1\1a\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0\250\v\0\000"...,
512) =3D 512
fstat64(3, {st_mode=3DS_IFREG|0644, st_size=3D9592, ...}) =3D 0
mmap2(NULL, 41124, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) =3D 0x40025000
mprotect(0x40027000, 32932, PROT_NONE)  =3D 0
mmap2(0x4002e000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1) =3D 0x4002e000
close(3)                                =3D 0
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or =
directory)
open("/lib/libnsl.so.1", O_RDONLY)      =3D 3
read(3, "\177ELF\1\1\1a\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0\3703\0\000"...,
512) =3D 512
fstat64(3, {st_mode=3DS_IFREG|0644, st_size=3D68460, ...}) =3D 0
mmap2(NULL, 108188, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) =3D 0x40030000
mprotect(0x40040000, 42652, PROT_NONE)  =3D 0
mmap2(0x40047000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xf) =3D 0x40047000
mmap2(0x40049000, 5788, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) =3D 0x40049000
close(3)                                =3D 0
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or =
directory)
open("/lib/libselinux.so.1", O_RDONLY)  =3D 3
read(3, "\177ELF\1\1\1a\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0 7\0\0004"..., 51=
2) =3D 512
fstat64(3, {st_mode=3DS_IFREG|0644, st_size=3D75268, ...}) =3D 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) =3D 0x4004b000
mmap2(NULL, 109376, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) =3D 0x4004c000
mprotect(0x4005e000, 35648, PROT_NONE)  =3D 0
mmap2(0x40065000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x11) =3D 0x40065000
close(3)                                =3D 0
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or =
directory)
open("/lib/libc.so.6", O_RDONLY)        =3D 3
read(3, "\177ELF\1\1\1a\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0HO\1\0004"..., 51=
2) =3D 512
fstat64(3, {st_mode=3DS_IFREG|0755, st_size=3D1091216, ...}) =3D 0
mmap2(NULL, 1128068, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE,
3, 0) =3D 0x40067000
mprotect(0x4016e000, 50820, PROT_NONE)  =3D 0
mmap2(0x40175000, 12288, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x106) =3D 0x40175000
mmap2(0x40178000, 9860, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) =3D 0x40178000
close(3)                                =3D 0
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or =
directory)
open("/lib/libsepol.so.1", O_RDONLY)    =3D 3
read(3, "\177ELF\1\1\1a\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0h/\0\0004"..., 51=
2) =3D 512
fstat64(3, {st_mode=3DS_IFREG|0644, st_size=3D223904, ...}) =3D 0
mmap2(NULL, 297872, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) =3D 0x4017b000
mprotect(0x401b2000, 72592, PROT_NONE)  =3D 0
mmap2(0x401b9000, 4096, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x36) =3D 0x401b9000
mmap2(0x401ba000, 39824, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) =3D 0x401ba000
close(3)                                =3D 0
mprotect(0x40175000, 8192, PROT_READ)   =3D 0
mprotect(0x40065000, 4096, PROT_READ)   =3D 0
mprotect(0x40047000, 4096, PROT_READ)   =3D 0
mprotect(0x4002e000, 4096, PROT_READ)   =3D 0
mprotect(0x4001c000, 4096, PROT_READ)   =3D 0
munmap(0x4001e000, 25798)               =3D 0
access("/etc/selinux/", F_OK)           =3D -1 ENOENT (No such file or =
directory)
brk(0)                                  =3D 0x1c000
brk(0x3d000)                            =3D 0x3d000
open("/proc/mounts", O_RDONLY|O_LARGEFILE) =3D 3
fstat64(3, {st_mode=3DS_IFREG|0444, st_size=3D0, ...}) =3D 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) =3D 0x4001e000
read(3, "rootfs / rootfs rw 0 0\n/dev/root"..., 1024) =3D 486
read(3, "", 1024)                       =3D 0
close(3)                                =3D 0
munmap(0x4001e000, 4096)                =3D 0
socket(PF_INET, SOCK_RAW, IPPROTO_RAW)  =3D 3
getsockopt(3, SOL_IP, 0x40 /* IP_??? */,
"filter\0@\0\0\0\0\340\257\6@h\262\4@\1\0\0\0\234\213\0"..., [84]) =3D =
0
getsockopt(3, SOL_IP, 0x41 /* IP_??? */, 0x1c0c0, 0xbed05c10) =3D -1
EINVAL (Invalid argument)
close(3)                                =3D 0
open("/proc/sys/kernel/modprobe", O_RDONLY) =3D 3
read(3, "/sbin/modprobe\n", 1024)       =3D 15
close(3)                                =3D 0
fork()                                  =3D 22448
wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) =3D=3D 0}], 0, NULL) =3D 224=
48
--- SIGCHLD (Child exited) @ 0 (0) ---
getsockopt(-1, SOL_IP, 0x40 /* IP_??? */, 0xbed05bb4, 0xbed05c0c) =3D -=
1
EBADF (Bad file descriptor)
write(2, "iptables v1.3.6: ", 17iptables v1.3.6: )       =3D 17
write(2, "can\'t initialize iptables table "..., 61can't initialize
iptables table `filter': Bad file descriptor) =3D 61
write(2, "\n", 1
)                       =3D 1
write(2, "Perhaps iptables or your kernel "..., 54Perhaps iptables or
your kernel needs to be upgraded.
) =3D 54
io_submit(0x3, 0, 0x8 <unfinished ... exit status 3>
Process 22447 detached






strace of the child here:

 strace -Ff  iptables -L
execve("/sbin/iptables", ["iptables", "-L"], [/* 20 vars */]) =3D 0
uname({sys=3D"Linux", node=3D"LS-GL7D6", ...}) =3D 0
brk(0)                                  =3D 0x1c000
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or =
directory)
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) =3D 0x40015000
access("/etc/ld.so.preload", R_OK)      =3D -1 ENOENT (No such file or =
directory)
open("/etc/ld.so.cache", O_RDONLY)      =3D 3
fstat64(3, {st_mode=3DS_IFREG|0644, st_size=3D25798, ...}) =3D 0
mmap2(NULL, 25798, PROT_READ, MAP_PRIVATE, 3, 0) =3D 0x4001e000
close(3)                                =3D 0
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or =
directory)
open("/lib/libdl.so.2", O_RDONLY)       =3D 3
read(3, "\177ELF\1\1\1a\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0\250\v\0\000"...,
512) =3D 512
fstat64(3, {st_mode=3DS_IFREG|0644, st_size=3D9592, ...}) =3D 0
mmap2(NULL, 41124, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) =3D 0x40025000
mprotect(0x40027000, 32932, PROT_NONE)  =3D 0
mmap2(0x4002e000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1) =3D 0x4002e000
close(3)                                =3D 0
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or =
directory)
open("/lib/libnsl.so.1", O_RDONLY)      =3D 3
read(3, "\177ELF\1\1\1a\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0\3703\0\000"...,
512) =3D 512
fstat64(3, {st_mode=3DS_IFREG|0644, st_size=3D68460, ...}) =3D 0
mmap2(NULL, 108188, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) =3D 0x40030000
mprotect(0x40040000, 42652, PROT_NONE)  =3D 0
mmap2(0x40047000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xf) =3D 0x40047000
mmap2(0x40049000, 5788, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) =3D 0x40049000
close(3)                                =3D 0
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or =
directory)
open("/lib/libselinux.so.1", O_RDONLY)  =3D 3
read(3, "\177ELF\1\1\1a\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0 7\0\0004"..., 51=
2) =3D 512
fstat64(3, {st_mode=3DS_IFREG|0644, st_size=3D75268, ...}) =3D 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) =3D 0x4004b000
mmap2(NULL, 109376, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) =3D 0x4004c000
mprotect(0x4005e000, 35648, PROT_NONE)  =3D 0
mmap2(0x40065000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x11) =3D 0x40065000
close(3)                                =3D 0
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or =
directory)
open("/lib/libc.so.6", O_RDONLY)        =3D 3
read(3, "\177ELF\1\1\1a\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0HO\1\0004"..., 51=
2) =3D 512
fstat64(3, {st_mode=3DS_IFREG|0755, st_size=3D1091216, ...}) =3D 0
mmap2(NULL, 1128068, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE,
3, 0) =3D 0x40067000
mprotect(0x4016e000, 50820, PROT_NONE)  =3D 0
mmap2(0x40175000, 12288, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x106) =3D 0x40175000
mmap2(0x40178000, 9860, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) =3D 0x40178000
close(3)                                =3D 0
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or =
directory)
open("/lib/libsepol.so.1", O_RDONLY)    =3D 3
read(3, "\177ELF\1\1\1a\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0h/\0\0004"..., 51=
2) =3D 512
fstat64(3, {st_mode=3DS_IFREG|0644, st_size=3D223904, ...}) =3D 0
mmap2(NULL, 297872, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) =3D 0x4017b000
mprotect(0x401b2000, 72592, PROT_NONE)  =3D 0
mmap2(0x401b9000, 4096, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x36) =3D 0x401b9000
mmap2(0x401ba000, 39824, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) =3D 0x401ba000
close(3)                                =3D 0
mprotect(0x40175000, 8192, PROT_READ)   =3D 0
mprotect(0x40065000, 4096, PROT_READ)   =3D 0
mprotect(0x40047000, 4096, PROT_READ)   =3D 0
mprotect(0x4002e000, 4096, PROT_READ)   =3D 0
mprotect(0x4001c000, 4096, PROT_READ)   =3D 0
munmap(0x4001e000, 25798)               =3D 0
access("/etc/selinux/", F_OK)           =3D -1 ENOENT (No such file or =
directory)
brk(0)                                  =3D 0x1c000
brk(0x3d000)                            =3D 0x3d000
open("/proc/mounts", O_RDONLY|O_LARGEFILE) =3D 3
fstat64(3, {st_mode=3DS_IFREG|0444, st_size=3D0, ...}) =3D 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) =3D 0x4001e000
read(3, "rootfs / rootfs rw 0 0\n/dev/root"..., 1024) =3D 486
read(3, "", 1024)                       =3D 0
close(3)                                =3D 0
munmap(0x4001e000, 4096)                =3D 0
socket(PF_INET, SOCK_RAW, IPPROTO_RAW)  =3D 3
getsockopt(3, SOL_IP, 0x40 /* IP_??? */,
"filter\0@\0\0\0\0\340\257\6@h\262\4@\1\0\0\0\234\213\0"..., [84]) =3D =
0
getsockopt(3, SOL_IP, 0x41 /* IP_??? */, 0x1c0c0, 0xbed24c10) =3D -1
EINVAL (Invalid argument)
close(3)                                =3D 0
open("/proc/sys/kernel/modprobe", O_RDONLY) =3D 3
read(3, "/sbin/modprobe\n", 1024)       =3D 15
close(3)                                =3D 0
fork(Process 22506 attached
)                                  =3D 22506
[pid 22505] wait4(-1, Process 22505 suspended





any help ?




--=20
[]'s
Salatiel

"O maior prazer do inteligente =E9 bancar o  idiota
   diante de um  idiota que banca o inteligente".
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
