From: Daniel 'NebuchadnezzaR' Dehennin <nebuchadnezzar@nerim.net>
Subject: IPROUTE compilation problem
Date: Thu, 13 May 2004 23:28:33 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <87ad0cj9tq.fsf@thorr.asgardr.info>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Hello,

The IPROUTE patch failed to build (latest CVS + 2.6.6):

  CC [M]  net/ipv4/netfilter/ipt_ROUTE.o
net/ipv4/netfilter/ipt_ROUTE.c: In function `route':
net/ipv4/netfilter/ipt_ROUTE.c:56: error: variable `key' has initializer bu=
t incomplete type
net/ipv4/netfilter/ipt_ROUTE.c:57: error: unknown field `dst' specified in =
initializer
net/ipv4/netfilter/ipt_ROUTE.c:57: warning: excess elements in struct initi=
alizer
net/ipv4/netfilter/ipt_ROUTE.c:57: warning: (near initialization for `key')
net/ipv4/netfilter/ipt_ROUTE.c:58: error: unknown field `src' specified in =
initializer
net/ipv4/netfilter/ipt_ROUTE.c:58: warning: excess elements in struct initi=
alizer
net/ipv4/netfilter/ipt_ROUTE.c:58: warning: (near initialization for `key')
net/ipv4/netfilter/ipt_ROUTE.c:59: error: unknown field `oif' specified in =
initializer
net/ipv4/netfilter/ipt_ROUTE.c:59: warning: excess elements in struct initi=
alizer
net/ipv4/netfilter/ipt_ROUTE.c:59: warning: (near initialization for `key')
net/ipv4/netfilter/ipt_ROUTE.c:60: error: unknown field `tos' specified in =
initializer
net/ipv4/netfilter/ipt_ROUTE.c:61: warning: excess elements in struct initi=
alizer
net/ipv4/netfilter/ipt_ROUTE.c:61: warning: (near initialization for `key')
net/ipv4/netfilter/ipt_ROUTE.c:56: error: storage size of `key' isn't known
net/ipv4/netfilter/ipt_ROUTE.c:56: warning: unused variable `key'
net/ipv4/netfilter/ipt_ROUTE.c: In function `ipt_route_target':
net/ipv4/netfilter/ipt_ROUTE.c:262: warning: implicit declaration of functi=
on `ip_route_output'
make[4]: *** [net/ipv4/netfilter/ipt_ROUTE.o] Error 1
make[3]: *** [net/ipv4/netfilter] Error 2

Thanks
=2D-=20
Daniel 'NebuchadnezzaR' Dehennin
R=E9cup=E9rer ma clef GPG:
gpg --keyserver pgp.mit.edu --recv-keys 0x4CA73DC6

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iQEVAwUAQKPohdWamn5Mpz3GAQLv6ggAvTz0WlkqBXj63CE64sNDXIE4m9Rh4A2t
LgB37SIdX7aRUrd3+dNl39Q3sXccBl5WqTO3e+VmPXO7g6KK9G3ZZy4gZFQL/KpE
tJnYiX+YZmahHhs8iul+n5xFY5wijoKz+53VHdgWEagnliS++7sxpbfBbyqlmqvB
yHOxVdfP/UI8/9OO1yzCTvO/ww3gzZ8QL3ilosEvkKVQQdoV/bz3Xhr6vLuoeov8
On7TpxC+r65x2n5UlQdpUEqBqHJ45He6z6iiGVt/fad0C9KYslT6JMJhcpixYNbo
4KXvn/MprnqEdL/Au+CHVUzTHp8dqSHOrd7Rk0cwImVxzbCjHiJF6g==
=blz3
-----END PGP SIGNATURE-----
--=-=-=--
