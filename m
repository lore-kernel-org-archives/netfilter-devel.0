From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: Netfilter API help
Date: Tue, 24 Apr 2007 10:15:27 +0200
Message-ID: <1177402527.26018.22.camel@henriknordstrom.net>
References: <01d001c78587$2d8a0e50$2aff7893@RoomsNet.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-+siuZkuE+ALNOsoM2Xow"
Cc: netfilter-devel@lists.netfilter.org
To: Tharanga <tharanga@roomsnet.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <01d001c78587$2d8a0e50$2aff7893@RoomsNet.com>
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


--=-+siuZkuE+ALNOsoM2Xow
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

m=C3=A5n 2007-04-23 klockan 15:10 +0600 skrev Tharanga:

> Iam new to netfilter . and trying to implement a new firewall on linux 2.=
6.X
> kernel. can some one give me a URL to find the Netfilter API documentatio=
n
> to start my work. i trid to find it but couldnt. i'll be greatful , if so=
me
> one can give me a breif introduciton to netfilter capabilities .

There is many layers...

Linux kernel TCP/IP stack

Netfilter hooks into the above.

Netfilter common infrastructure, mainly conntrack, nat  and some netlink
stuff

iptables

iptables matches & targets


The best source to netfilter programming details is the source code,
after first reading the netfilter hacking howto which gives a reasonable
(even if slightly outdated) introduction. Combined with making focused
questions on this mailinglist.

Regards
Henrik

--=-+siuZkuE+ALNOsoM2Xow
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUARi28nENPQ5Kbx8daAQL0FwQAmIDzV4DbKbyYvHAvsQ1hUeVxHtbO7iAX
oEhIC3KJJKnk0QFtpyz9+FRwYnFfL9f7YJ/92pgyqD2F7LHojPJwnxF9IXpkatDO
luVK8eseSY9CE8loEqifHuCmau2naloBwMGrRZW1kgBZqoaqj8DOeWaO0v1jBgZ2
1RuJfOUXACY=
=z2nJ
-----END PGP SIGNATURE-----

--=-+siuZkuE+ALNOsoM2Xow--
