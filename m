From: "Piotr =?iso-8859-2?Q?Gasid=B3o?=" <quaker@pandora.barbara.ds.polsl.gliwice.pl>
Subject: New match ipt_account
Date: Wed, 25 Jun 2003 10:26:36 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030625082636.GA27987@pandora.barbara.ds.polsl.gliwice.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_pandora.barbara.ds.polsl.gliwice.pl-25184-1056529596-0001-2"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_pandora.barbara.ds.polsl.gliwice.pl-25184-1056529596-0001-2
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello.

This is my first post to this list.

I've created match ipt_account, which can be used to create traffic
statistics for all hosts in specifed network.

For example, to create statistics for 157.158.182.0/23 you only have to add
these rules:

iptables -A FORWARD -s 157.158.182.0/23 -m account=20
	--asource 157.158.182.0/23 --aname outgoing
iptables -A FORWARD -d 157.158.182.0/23 -m account
	--adest 157.158.182.0/23 --aname incomming

These rules will create entries in /proc/net/ipt_account/ containing:

$ cat /proc/net/ipt_account/incomming_32
ip =3D 157.158.182.0, bytes =3D 0 0 0 0 0, packets =3D 0 0 0 0 0
ip =3D 157.158.182.1, bytes =3D 0 0 0 0 0, packets =3D 0 0 0 0 0
ip =3D 157.158.182.2, bytes =3D 1524 160 1364 0 0, packets =3D 14 4 10 0 0
ip =3D 157.158.182.3, bytes =3D 0 0 0 0 0, packets =3D 0 0 0 0 0
ip =3D 157.158.182.4, bytes =3D 1769 160 1609 0 0, packets =3D 19 4 15 0 0
ip =3D 157.158.182.5, bytes =3D 1086 160 926 0 0, packets =3D 12 4 8 0 0
ip =3D 157.158.182.6, bytes =3D 0 0 0 0 0, packets =3D 0 0 0 0 0
ip =3D 157.158.182.7, bytes =3D 847 160 687 0 0, packets =3D 7 4 3 0 0
ip =3D 157.158.182.8, bytes =3D 1320 160 1160 0 0, packets =3D 15 4 11 0 0
ip =3D 157.158.182.9, bytes =3D 0 0 0 0 0, packets =3D 0 0 0 0 0
=2E..

Description:
[ ip, bytes =3D all tcp udp icmp other, packets =3D all tcp udp icmp other ]

For each rule are created two entries in proc : one with 32-bit counters and
one with 64-bit ones. This is for compatibility with programs which doesn't
support 64-bit number parsing.

Source code can be downloaded from:
http://www.barbara.eu.org/~quaker/ipt_account/
http://www.barbara.eu.org/~quaker/ipt_account/ipt_account_newest.tar.gz=20

--=20
Piotr 'QuakeR' Gasid=B3o ### B.O.F.H. @ pandora.barbara.eu.org ###
## quaker@barbara.eu.org ### ICQ 52605026 ### PGP 0xF3400EAA ###=20
## BOFH excuse #269:
Melting hard drives

--=_pandora.barbara.ds.polsl.gliwice.pl-25184-1056529596-0001-2
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE++Vy8gEmu6PNADqoRArnrAJ99lZfILRArWUoMWYfUfK8Kmdra7ACdHso4
ORafi0n1iOg/yVbMMDG3PE4=
=0ufN
-----END PGP SIGNATURE-----

--=_pandora.barbara.ds.polsl.gliwice.pl-25184-1056529596-0001-2--
