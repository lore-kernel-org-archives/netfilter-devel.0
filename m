From: netfilter@interlinx.bc.ca
Subject: arptables in kernel produces "invalid argument" from iptables 1.2.7a
Date: Fri, 25 Oct 2002 20:50:00 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021026004959.GL23228@pc.ilinx>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KIbT1ud6duwZIwNL"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--KIbT1ud6duwZIwNL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I found this problem while I was building my last production kernel
and just worked around it by removing the arptables POM patches from
the kernel.  But here I am building a new production kernel and
running into the same problem.

If I include the arptables stuff from POM in my kernel tree and set
the:

CONFIG_IP_NF_ARPTABLES
CONFIG_IP_NF_ARPFILTER

config variables, the iptables command from 1.2.7a (current CVS) fails
to operate on any of the nat table hooks.  I keep getting an "invalid
argument" error:

# iptables -t nat -A POSTROUTING -o ppp0 -s 10.75.22.0/24 -j MASQUERADE
iptables: Invalid argument

An strace from the iptables command:

execve("/sbin/iptables", ["iptables", "-t", "nat", "-A", "PREROUTING", "-i"=
, "ppp0", "-p", "udp", "--dport", "6346", "-j", "DNAT", "--to-destination",=
 "10.75.22.1"], [/* 35 vars */]) =3D 0
uname({sys=3D"Linux", node=3D"gw.ilinx", ...}) =3D 0
brk(0)                                  =3D 0x805577c
open("/etc/ld.so.preload", O_RDONLY)    =3D 3
fstat64(3, {st_mode=3DS_IFREG|0600, st_size=3D0, ...}) =3D 0
close(3)                                =3D 0
open("/etc/ld.so.cache", O_RDONLY)      =3D 3
fstat64(3, {st_mode=3DS_IFREG|0644, st_size=3D9284, ...}) =3D 0
old_mmap(NULL, 9284, PROT_READ, MAP_PRIVATE, 3, 0) =3D 0x40012000
close(3)                                =3D 0
open("/lib/libdl.so.2", O_RDONLY)       =3D 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0P\30\0\000"..., 102=
4) =3D 1024
fstat64(3, {st_mode=3DS_IFREG|0755, st_size=3D8220, ...}) =3D 0
old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0x40015000
old_mmap(NULL, 11152, PROT_READ|PROT_EXEC, MAP_PRIVATE, 3, 0) =3D 0x40016000
mprotect(0x40018000, 2960, PROT_NONE)   =3D 0
old_mmap(0x40018000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 3, =
0x1000) =3D 0x40018000
close(3)                                =3D 0
open("/lib/libc.so.6", O_RDONLY)        =3D 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0P\202\1"..., 1024) =
=3D 1024
fstat64(3, {st_mode=3DS_IFREG|0755, st_size=3D1147848, ...}) =3D 0
old_mmap(NULL, 1160224, PROT_READ|PROT_EXEC, MAP_PRIVATE, 3, 0) =3D 0x40019=
000
mprotect(0x4012b000, 37920, PROT_NONE)  =3D 0
old_mmap(0x4012b000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 3,=
 0x112000) =3D 0x4012b000
old_mmap(0x40131000, 13344, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP=
_ANONYMOUS, -1, 0) =3D 0x40131000
close(3)                                =3D 0
munmap(0x40012000, 9284)                =3D 0
brk(0)                                  =3D 0x805577c
brk(0x8055b94)                          =3D 0x8055b94
brk(0x8056000)                          =3D 0x8056000
open("/etc/nsswitch.conf", O_RDONLY)    =3D 3
fstat64(3, {st_mode=3DS_IFREG|0644, st_size=3D1888, ...}) =3D 0
old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0x40012000
read(3, "#\n# /etc/nsswitch.conf\n#\n# An ex"..., 4096) =3D 1888
brk(0x8057000)                          =3D 0x8057000
read(3, "", 4096)                       =3D 0
close(3)                                =3D 0
munmap(0x40012000, 4096)                =3D 0
open("/etc/ld.so.cache", O_RDONLY)      =3D 3
fstat64(3, {st_mode=3DS_IFREG|0644, st_size=3D9284, ...}) =3D 0
old_mmap(NULL, 9284, PROT_READ, MAP_PRIVATE, 3, 0) =3D 0x40012000
close(3)                                =3D 0
open("/lib/libnss_files.so.2", O_RDONLY) =3D 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0P\35\0\000"..., 102=
4) =3D 1024
fstat64(3, {st_mode=3DS_IFREG|0755, st_size=3D36296, ...}) =3D 0
old_mmap(NULL, 39676, PROT_READ|PROT_EXEC, MAP_PRIVATE, 3, 0) =3D 0x40135000
mprotect(0x4013e000, 2812, PROT_NONE)   =3D 0
old_mmap(0x4013e000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 3, =
0x8000) =3D 0x4013e000
close(3)                                =3D 0
munmap(0x40012000, 9284)                =3D 0
open("/etc/protocols", O_RDONLY)        =3D 3
fcntl64(3, F_GETFD)                     =3D 0
fcntl64(3, F_SETFD, FD_CLOEXEC)         =3D 0
fstat64(3, {st_mode=3DS_IFREG|0644, st_size=3D5809, ...}) =3D 0
old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D 0x40012000
read(3, "# /etc/protocols:\n# $Id: protoco"..., 4096) =3D 4096
close(3)                                =3D 0
munmap(0x40012000, 4096)                =3D 0
open("/lib/iptables/libipt_udp.so", O_RDONLY) =3D 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\320\5\0"..., 1024)=
 =3D 1024
fstat64(3, {st_mode=3DS_IFREG|0755, st_size=3D5344, ...}) =3D 0
old_mmap(NULL, 8788, PROT_READ|PROT_EXEC, MAP_PRIVATE, 3, 0) =3D 0x40012000
mprotect(0x40014000, 596, PROT_NONE)    =3D 0
old_mmap(0x40014000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 3, =
0x1000) =3D 0x40014000
close(3)                                =3D 0
open("/lib/iptables/libipt_DNAT.so", O_RDONLY) =3D 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0`\5\0\000"..., 1024=
) =3D 1024
fstat64(3, {st_mode=3DS_IFREG|0755, st_size=3D4376, ...}) =3D 0
old_mmap(NULL, 7820, PROT_READ|PROT_EXEC, MAP_PRIVATE, 3, 0) =3D 0x4013f000
mprotect(0x40140000, 3724, PROT_NONE)   =3D 0
old_mmap(0x40140000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 3, =
0) =3D 0x40140000
close(3)                                =3D 0
socket(PF_INET, SOCK_RAW, IPPROTO_RAW)  =3D 3
getsockopt(3, SOL_IP, 0x40 /* IP_??? */, [7627118], [84]) =3D 0
getsockopt(3, SOL_IP, 0x41 /* IP_??? */, [7627118], [656]) =3D 0
brk(0x8058000)                          =3D 0x8058000
setsockopt(3, SOL_IP, 0x40 /* IP_??? */, [7627118], 920) =3D -1 EINVAL (Inv=
alid argument)
write(2, "iptables: Invalid argument\n", 27iptables: Invalid argument
) =3D 27
_exit(1)                                =3D ?

Any thots other than disabling arptables?

b.

--=20
Brian J. Murrell

--KIbT1ud6duwZIwNL
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9uea3l3EQlGLyuXARAvCvAJwPFdM9JClKAK9vDIDX9TSXqkyKsACgy2ld
gZMAVJSVz52soHThxRr1xLA=
=vBW/
-----END PGP SIGNATURE-----

--KIbT1ud6duwZIwNL--
