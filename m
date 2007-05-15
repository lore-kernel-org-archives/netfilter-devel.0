From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: Is libiptc still the preferred library for manipulating tables?
Date: Tue, 15 May 2007 09:07:41 +0200
Message-ID: <1179212861.24969.7.camel@henriknordstrom.net>
References: <e1663d820705111834g6aa95aa2ice26f26c816032b9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-KFK+StmkwckwE7HGDic3"
Cc: netfilter-devel@lists.netfilter.org
To: Hal Moroff <halm90@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <e1663d820705111834g6aa95aa2ice26f26c816032b9@mail.gmail.com>
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


--=-KFK+StmkwckwE7HGDic3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

fre 2007-05-11 klockan 18:34 -0700 skrev Hal Moroff:
> I've been trying for awhile to find this out as well.

Well.. lipiptc is not and has never been an official interface. Has
always been considered an internal API not for reuse by other
applications with the iptables and iptables-save/restore commands being
the official APIs.

> I'm working on an appliance and I need to dynamically insert/remove
> rules based on
> what's happening in the box. I prefer not to resort to
> system("itpables yada yada yada")

An alternative official interface is to popen iptables-restore in the
noflush mode. Gives you a quite smart interface for manipulating
iptables. Syntax is the same as iptables, execpt for how you select
which table to manipulate.

*tablename
iptables command line, without iptables or table selection
[repeat until done with current modification]
COMMIT

Regards
Henrik

--=-KFK+StmkwckwE7HGDic3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUARklcOkNPQ5Kbx8daAQJLtQP+PovCWXTDrbwqjpwpPs3V2dOAnzIqkE47
HqVkAyYCEFLCvBGS4iXjHg+mivc9H4AzVypmjpjqx685DyOw0ZHy3VHc74h1fiaK
cZrPOjSLdae355/4cj8gVyFX5BvEc0okU4DwOhMA2l4FyrFLWeKkzw6S3YITwhsg
GdufY2sNhxg=
=SZ2Z
-----END PGP SIGNATURE-----

--=-KFK+StmkwckwE7HGDic3--
