From: Eric Leblond <eleblond@inl.fr>
Subject: Re: [PATCH] autogen.sh for libnetfilter_conntrack
Date: Wed, 26 Oct 2005 09:21:07 +0200
Message-ID: <1130311267.4872.52.camel@localhost.localdomain>
References: <1130141237.11255.4.camel@localhost.localdomain>
	<1130141444.11255.10.camel@localhost.localdomain>
	<435D7378.5090206@netfilter.org>
	<1130292650.1269.8.camel@www.l-chr.com.ar>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-FFVymswdmLe7gvZzfryW"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	gryzor@inl.fr, Pablo Neira <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Christian Hentschel <chentschel@arnet.com.ar>
In-Reply-To: <1130292650.1269.8.camel@www.l-chr.com.ar>
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


--=-FFVymswdmLe7gvZzfryW
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

Hi;

Le mardi 25 octobre 2005 =E0 23:10 -0300, Christian Hentschel a =E9crit :
> > AFAIK, autoreconf is supposed to supersede autogen.sh-like scripts. Tha=
t=20
> > is what I've used so far. Is there any extra reason why someone could=20
> > need autogen.sh?
> No. I don't think so. But maybe adding a line about autoreconf to the INS=
TALL file would help.

Yes good idea, but things should be the same in other component where
there is a autogen.sh script.
And send a bug report to autoreconf author because autoreconf do not use
"libtoolize -f" and there is some problem with that...

BR,
--=20
=C9ric Leblond, eleblond@inl.fr
T=E9l=E9phone : 01 44 89 46 40, Fax : 01 44 89 45 01
INL, http://www.inl.fr

--=-FFVymswdmLe7gvZzfryW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBDXy5inxA7CdMWjzIRAkv6AJ4zIo9Ae9eeJeI8DKHK48nkS/VNZACeIEDC
G/gnu6KPE9AJQzg8zg9hi/M=
=QcYu
-----END PGP SIGNATURE-----

--=-FFVymswdmLe7gvZzfryW--
