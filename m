From: "Wang, Baojun" <wangbj@lzu.edu.cn>
Subject: rtsp-conntrack compile failed on 2.6.16 kernel
Date: Mon, 23 Oct 2006 14:52:07 +0800
Message-ID: <361646925.14969@eyou.net>
Reply-To: wangbj@lzu.edu.cn
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-0oHrVzvQSTysIsGFy95W"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Message-Id: <1161586327.22201.7.camel@dslab-wangbj>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--=-0oHrVzvQSTysIsGFy95W
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

hi, list:

  I have met some problems with rtsp-conntrack patch, kernel version is
2.6.16, patch with the svn version of patch-o-matic(./runme exra) and
iptables, both revision are 6688. any ideas? thanks very much!

scripts/Makefile.build:51: kbuild: net/ipv4/netfilter/Makefile - Usage
of export-objs is obsolete in 2.6. Please fix!
  CC [M]  net/ipv4/netfilter/ip_nat_rtsp.o
net/ipv4/netfilter/ip_nat_rtsp.c: In function `rtsp_mangle_tran':
net/ipv4/netfilter/ip_nat_rtsp.c:167: warning: implicit declaration of
function `ip_conntrack_change_expect'
net/ipv4/netfilter/ip_nat_rtsp.c: In function `expected':
net/ipv4/netfilter/ip_nat_rtsp.c:368: error: storage size of `mr' isn't
known
net/ipv4/netfilter/ip_nat_rtsp.c:376: error: structure has no member
named `initialized'
net/ipv4/netfilter/ip_nat_rtsp.c:368: warning: unused variable `mr'
net/ipv4/netfilter/ip_nat_rtsp.c: In function `help_out':
net/ipv4/netfilter/ip_nat_rtsp.c:411: error: structure has no member
named `seq'
net/ipv4/netfilter/ip_nat_rtsp.c:431: error: `ct' undeclared (first use
in this function)
net/ipv4/netfilter/ip_nat_rtsp.c:431: error: (Each undeclared identifier
is reported only once
net/ipv4/netfilter/ip_nat_rtsp.c:431: error: for each function it
appears in.)
net/ipv4/netfilter/ip_nat_rtsp.c:431: error: incompatible type for
argument 2 of `rtsp_mangle_tran'
net/ipv4/netfilter/ip_nat_rtsp.c:431: warning: passing arg 3 of
`rtsp_mangle_tran' from incompatible pointer type
net/ipv4/netfilter/ip_nat_rtsp.c:431: warning: passing arg 4 of
`rtsp_mangle_tran' from incompatible pointer type
net/ipv4/netfilter/ip_nat_rtsp.c:431: warning: passing arg 5 of
`rtsp_mangle_tran' makes integer from pointer without a cast
net/ipv4/netfilter/ip_nat_rtsp.c:431: error: too many arguments to
function `rtsp_mangle_tran'
net/ipv4/netfilter/ip_nat_rtsp.c: At top level:
net/ipv4/netfilter/ip_nat_rtsp.c:450: error: parameter `ct_rtsp_info'
has just a forward declaration
net/ipv4/netfilter/ip_nat_rtsp.c:449: error: parameter `ctinfo' has just
a forward declaration
net/ipv4/netfilter/ip_nat_rtsp.c:448: error: parameter `pskb' has just a
forward declaration
net/ipv4/netfilter/ip_nat_rtsp.c: In function `help':
net/ipv4/netfilter/ip_nat_rtsp.c:462: error: too many arguments to
function `help_out'
net/ipv4/netfilter/ip_nat_rtsp.c:454: warning: unused variable `tcph'
net/ipv4/netfilter/ip_nat_rtsp.c:455: warning: unused variable `datalen'
net/ipv4/netfilter/ip_nat_rtsp.c: In function `fini':
net/ipv4/netfilter/ip_nat_rtsp.c:475: error: `ip_nat_rtsp_hook'
undeclared (first use in this function)
net/ipv4/netfilter/ip_nat_rtsp.c: In function `init':
net/ipv4/netfilter/ip_nat_rtsp.c:483: error: `ip_nat_rtsp_hook'
undeclared (first use in this function)
net/ipv4/netfilter/ip_nat_rtsp.c: At top level:
net/ipv4/netfilter/ip_nat_rtsp.c:65: warning: `ports' defined but not
used
net/ipv4/netfilter/ip_nat_rtsp.c:69: warning: `num_ports' defined but
not used
net/ipv4/netfilter/ip_nat_rtsp.c:367: warning: `expected' defined but
not used
make[3]: *** [net/ipv4/netfilter/ip_nat_rtsp.o] Error 1
make[2]: *** [net/ipv4/netfilter] Error 2
make[1]: *** [net/ipv4] Error 2
make: *** [net] Error 2

--=20
Wang, Baojun                                        Lanzhou University
Distributed & Embedded System Lab              http://dslab.lzu.edu.cn
School of Information Science and Engeneering        wangbj@lzu.edu.cn
Tianshui South Road 222. Lanzhou 730000                     .P.R.China
Tel:+86-931-8912025                                Fax:+86-931-8912022

--=-0oHrVzvQSTysIsGFy95W
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQBFPGaXIuIOr7tpgg0RAkSyAJ9esyEyed2+KMGPhP6v99DO2VQ3MwCdGA4T
mvHTma6UUhbMXpLM6PmTIWw=
=dM8f
-----END PGP SIGNATURE-----

--=-0oHrVzvQSTysIsGFy95W--
