From: Christophe Saout <christophe@saout.de>
Subject: Re: 2.6.16-rc1-mm3 XFRM+NAT issue
Date: Mon, 30 Jan 2006 00:11:10 +0100
Message-ID: <1138576270.28609.8.camel@leto.intern.saout.de>
References: <1138563710.26998.22.camel@leto.intern.saout.de>
	<43DD1E3E.70503@trash.net>
	<1138568354.21229.1.camel@leto.intern.saout.de>
	<43DD3E3D.5070201@trash.net>
	<1138573848.28464.1.camel@leto.intern.saout.de>
	<43DD451B.4080009@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-QNj3QZifjPbzmCd2sbkc"
Cc: netfilter-devel@lists.netfilter.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <43DD451B.4080009@trash.net>
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


--=-QNj3QZifjPbzmCd2sbkc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Am Sonntag, den 29.01.2006, 23:43 +0100 schrieb Patrick McHardy:

> > This time with -4 on the command line:
>=20
> Please also add the chain names to the logging rules.

Good idea.

Jan 29 23:58:31 server PREROUTING IN=3Deth0 OUT=3D MAC=3D00:01:80:5c:0f:48:=
00:02:8a:ba:b8:58:08:00 SRC=3D192.168.80.90 DST=3D<inet host> LEN=3D60 TOS=
=3D0x10 PREC=3D0x00 TTL=3D64 ID=3D51295 DF PROTO=3DTCP SPT=3D33806 DPT=3D25=
 WINDOW=3D5840 RES=3D0x00 CWR ECE SYN URGP=3D0=20
Jan 29 23:58:31 server FORWARD IN=3Deth0 OUT=3Dppp0 SRC=3D192.168.80.90 DST=
=3D<inet host> LEN=3D60 TOS=3D0x10 PREC=3D0x00 TTL=3D63 ID=3D51295 DF PROTO=
=3DTCP SPT=3D33806 DPT=3D25 WINDOW=3D5840 RES=3D0x00 CWR ECE SYN URGP=3D0=20
Jan 29 23:58:31 server POSTROUTING IN=3D OUT=3Dppp0 SRC=3D192.168.80.90 DST=
=3D<inet host> LEN=3D60 TOS=3D0x10 PREC=3D0x00 TTL=3D63 ID=3D51295 DF PROTO=
=3DTCP SPT=3D33806 DPT=3D25 WINDOW=3D5840 RES=3D0x00 CWR ECE SYN URGP=3D0=20
Jan 29 23:58:31 server OUTPUT IN=3D OUT=3Dppp0 SRC=3D<gateway pub ip> DST=
=3D<inet host> LEN=3D104 TOS=3D0x10 PREC=3D0x00 TTL=3D63 ID=3D51295 DF PROT=
O=3DESP SPI=3D0xe2d41c8=20
Jan 29 23:58:31 server POSTROUTING IN=3D OUT=3Dppp0 SRC=3D<gateway pub ip> =
DST=3D<inet host> LEN=3D104 TOS=3D0x10 PREC=3D0x00 TTL=3D63 ID=3D51295 DF P=
ROTO=3DESP SPI=3D0xe2d41c8=20
Jan 29 23:58:31 server PREROUTING IN=3Dppp0 OUT=3D MAC=3D SRC=3D<inet host>=
 DST=3D<gateway pub ip> LEN=3D104 TOS=3D0x00 PREC=3D0x00 TTL=3D55 ID=3D0 DF=
 PROTO=3DESP SPI=3D0x865c0e26=20
Jan 29 23:58:31 server INPUT IN=3Dppp0 OUT=3D MAC=3D SRC=3D<inet host> DST=
=3D<gateway pub ip> LEN=3D104 TOS=3D0x00 PREC=3D0x00 TTL=3D55 ID=3D0 DF PRO=
TO=3DESP SPI=3D0x865c0e26=20
Jan 29 23:58:31 server PREROUTING IN=3Dppp0 OUT=3D MAC=3D45:00:00:68:00:00:=
40:00:37:06:61:ee:d5:ef:c5:f1:54:38:f1:5c:86:5c SRC=3D<inet host> DST=3D<ga=
teway pub ip> LEN=3D60 TOS=3D0x00 PREC=3D0x00 TTL=3D55 ID=3D0 DF PROTO=3DTC=
P SPT=3D25 DPT=3D33806 WINDOW=3D5792 RES=3D0x00 ECE ACK SYN URGP=3D0=20
Jan 29 23:58:31 server INPUT IN=3Dppp0 OUT=3D MAC=3D45:00:00:68:00:00:40:00=
:37:06:61:ee:d5:ef:c5:f1:54:38:f1:5c:86:5c SRC=3D<inet host> DST=3D192.168.=
80.90 LEN=3D60 TOS=3D0x00 PREC=3D0x00 TTL=3D55 ID=3D0 DF PROTO=3DTCP SPT=3D=
25 DPT=3D33806 WINDOW=3D5792 RES=3D0x00 ECE ACK SYN URGP=3D0=20
-- Something seems to go wrong here.
Jan 29 23:58:31 server OUTPUT IN=3D OUT=3Dppp0 SRC=3D<gateway pub ip> DST=
=3D<inet host> LEN=3D40 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D6 DF PROTO=3DT=
CP SPT=3D33806 DPT=3D25 WINDOW=3D0 RES=3D0x00 RST URGP=3D0=20
Jan 29 23:58:31 server POSTROUTING IN=3D OUT=3Dppp0 SRC=3D<gateway pub ip> =
DST=3D<inet host> LEN=3D40 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D6 DF PROTO=
=3DTCP SPT=3D33806 DPT=3D25 WINDOW=3D0 RES=3D0x00 RST URGP=3D0=20
Jan 29 23:58:31 server OUTPUT IN=3D OUT=3Dppp0 SRC=3D<gateway pub ip> DST=
=3D<inet host> LEN=3D88 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D6 DF PROTO=3DE=
SP SPI=3D0xe2d41c8=20
Jan 29 23:58:31 server POSTROUTING IN=3D OUT=3Dppp0 SRC=3D<gateway pub ip> =
DST=3D<inet host> LEN=3D88 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D6 DF PROTO=
=3DESP SPI=3D0xe2d41c8=20

There are no messages about invalid connections or so.


--=-QNj3QZifjPbzmCd2sbkc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBD3UuOZCYBcts5dM0RAgrbAJ9SQbjnQgNBDfZXfL4QFTB4HVakPwCdFN0G
6Qdhe5l/r+K0xZX+xvJEi0I=
=bTTX
-----END PGP SIGNATURE-----

--=-QNj3QZifjPbzmCd2sbkc--
