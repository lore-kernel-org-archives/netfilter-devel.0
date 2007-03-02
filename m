From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: Is libiptc still the preferred library for manipulating tables?
Date: Fri, 02 Mar 2007 20:44:21 +0100
Message-ID: <1172864661.3183.24.camel@henriknordstrom.net>
References: <57f837150702251105y7d70c345n233a75fc2f328592@mail.gmail.com>
	<45E2D126.7010003@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-MswC/JfdrLl5Dmz1RAtP"
Cc: netfilter-devel@lists.netfilter.org, Warren Kenny <warren.kenny@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45E2D126.7010003@netfilter.org>
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


--=-MswC/JfdrLl5Dmz1RAtP
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

m=C3=A5n 2007-02-26 klockan 13:23 +0100 skrev Pablo Neira Ayuso:

> Unfortunately, libiptc is not a supported as a standalone library, it is=20
> just a directory inside iptables. The only interface available, at the=20
> moment, is iptables, the command line tool. You can blame us for not=20
> providing an appropiate library interface yet.

This said, "iptables-restore -n" is a quite effective and potent batch
interface for rule updates.=20

And if it (or actually the underlying iptables code it's using) had an
option for dumping rules in iptables-save format then it could be as
potent for read access as well.. Today iptables-restore can only read
rules to the same level of detail as iptables -L -v.

Regards
Henrik

--=-MswC/JfdrLl5Dmz1RAtP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQCVAwUAReh+kUNPQ5Kbx8daAQI5fwP/f/hXtpS/wUlacNdRBeY8rDKz6ZeJPdZ2
6iPuzLzDI41tJdvhYTXeNFUPis7NMKMovL8WibYb5e+X+FOWaIAQCde26KM5WoSf
lyGCWwVeOR/1VBT5EgRVSkzgLXzeUpV6hOhNIwud0/ymiVCe3O8spJotjNFf815B
FfstXeZMjtM=
=OI0E
-----END PGP SIGNATURE-----

--=-MswC/JfdrLl5Dmz1RAtP--
