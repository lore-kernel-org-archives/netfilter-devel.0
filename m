From: Christophe Saout <christophe@saout.de>
Subject: Re: 2.6.16-rc1-mm3 XFRM+NAT issue
Date: Sun, 29 Jan 2006 23:30:48 +0100
Message-ID: <1138573848.28464.1.camel@leto.intern.saout.de>
References: <1138563710.26998.22.camel@leto.intern.saout.de>
	<43DD1E3E.70503@trash.net>
	<1138568354.21229.1.camel@leto.intern.saout.de>
	<43DD3E3D.5070201@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-vFqmzJcvfotcoQwUtr64"
Cc: netfilter-devel@lists.netfilter.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <43DD3E3D.5070201@trash.net>
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


--=-vFqmzJcvfotcoQwUtr64
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Am Sonntag, den 29.01.2006, 23:14 +0100 schrieb Patrick McHardy:

> 41 is IPPROTO_IPV6, you seem to be talking to the remote side using IPv6
> over sit, which is why NAT on the TCP packet doesn't work.

Ok, I'm stupid, forget this, IPv6 is a completely different issue. It's
really IPv4 that isn't working.

This time with -4 on the command line:

Jan 29 23:27:38 server IN=3Deth0 OUT=3D MAC=3D00:01:80:5c:0f:48:00:02:8a:ba=
:b8:58:08:00 SRC=3D192.168.80.90 DST=3D<inet host> LEN=3D60 TOS=3D0x10 PREC=
=3D0x00 TTL=3D64 ID=3D38799 DF PROTO=3DTCP SPT=3D40255 DPT=3D25 WINDOW=3D58=
40 RES=3D0x00 CWR ECE SYN URGP=3D0=20
Jan 29 23:27:38 server IN=3Deth0 OUT=3Dppp0 SRC=3D192.168.80.90 DST=3D<inet=
 host> LEN=3D60 TOS=3D0x10 PREC=3D0x00 TTL=3D63 ID=3D38799 DF PROTO=3DTCP S=
PT=3D40255 DPT=3D25 WINDOW=3D5840 RES=3D0x00 CWR ECE SYN URGP=3D0=20
Jan 29 23:27:38 server IN=3D OUT=3Dppp0 SRC=3D192.168.80.90 DST=3D<inet hos=
t> LEN=3D60 TOS=3D0x10 PREC=3D0x00 TTL=3D63 ID=3D38799 DF PROTO=3DTCP SPT=
=3D40255 DPT=3D25 WINDOW=3D5840 RES=3D0x00 CWR ECE SYN URGP=3D0=20
Jan 29 23:27:38 server IN=3D OUT=3Dppp0 SRC=3D<gateway pub ip> DST=3D<inet =
host> LEN=3D104 TOS=3D0x10 PREC=3D0x00 TTL=3D63 ID=3D38799 DF PROTO=3DESP S=
PI=3D0x1249d895=20
Jan 29 23:27:38 server IN=3D OUT=3Dppp0 SRC=3D<gateway pub ip> DST=3D<inet =
host> LEN=3D104 TOS=3D0x10 PREC=3D0x00 TTL=3D63 ID=3D38799 DF PROTO=3DESP S=
PI=3D0x1249d895=20
Jan 29 23:27:38 server IN=3Dppp0 OUT=3D MAC=3D SRC=3D<inet host> DST=3D<gat=
eway pub ip> LEN=3D104 TOS=3D0x00 PREC=3D0x00 TTL=3D55 ID=3D0 DF PROTO=3DES=
P SPI=3D0xbdbf1ca7=20
Jan 29 23:27:38 server IN=3Dppp0 OUT=3D MAC=3D SRC=3D<inet host> DST=3D<gat=
eway pub ip> LEN=3D104 TOS=3D0x00 PREC=3D0x00 TTL=3D55 ID=3D0 DF PROTO=3DES=
P SPI=3D0xbdbf1ca7=20
Jan 29 23:27:38 server IN=3Dppp0 OUT=3D MAC=3D45:00:00:68:00:00:40:00:37:06=
:56:bd:d5:ef:c5:f1:54:38:fc:8d:bd:bf SRC=3D<inet host> DST=3D<gateway pub i=
p> LEN=3D60 TOS=3D0x00 PREC=3D0x00 TTL=3D55 ID=3D0 DF PROTO=3DTCP SPT=3D25 =
DPT=3D40255 WINDOW=3D5792 RES=3D0x00 ECE ACK SYN URGP=3D0=20
Jan 29 23:27:38 server IN=3Dppp0 OUT=3D MAC=3D45:00:00:68:00:00:40:00:37:06=
:56:bd:d5:ef:c5:f1:54:38:fc:8d:bd:bf SRC=3D<inet host> DST=3D192.168.80.90 =
LEN=3D60 TOS=3D0x00 PREC=3D0x00 TTL=3D55 ID=3D0 DF PROTO=3DTCP SPT=3D25 DPT=
=3D40255 WINDOW=3D5792 RES=3D0x00 ECE ACK SYN URGP=3D0=20
Jan 29 23:27:38 server IN=3D OUT=3Dppp0 SRC=3D<gateway pub ip> DST=3D<inet =
host> LEN=3D40 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D954 DF PROTO=3DTCP SPT=
=3D40255 DPT=3D25 WINDOW=3D0 RES=3D0x00 RST URGP=3D0=20
Jan 29 23:27:38 server IN=3D OUT=3Dppp0 SRC=3D<gateway pub ip> DST=3D<inet =
host> LEN=3D40 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D954 DF PROTO=3DTCP SPT=
=3D40255 DPT=3D25 WINDOW=3D0 RES=3D0x00 RST URGP=3D0=20
Jan 29 23:27:38 server IN=3D OUT=3Dppp0 SRC=3D<gateway pub ip> DST=3D<inet =
host> LEN=3D88 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D954 DF PROTO=3DESP SPI=
=3D0x1249d895=20
Jan 29 23:27:38 server IN=3D OUT=3Dppp0 SRC=3D<gateway pub ip> DST=3D<inet =
host> LEN=3D88 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D954 DF PROTO=3DESP SPI=
=3D0x1249d895=20


--=-vFqmzJcvfotcoQwUtr64
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBD3UIYZCYBcts5dM0RAiEdAJ9yJG4DHR66AMYZuEQBEjglCNJuNQCdEs0v
9HkGBTkQMMlK/jqKZg6Zk+c=
=Dwaa
-----END PGP SIGNATURE-----

--=-vFqmzJcvfotcoQwUtr64--
