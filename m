From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] make multiple invocations of do_command() behave sane
Date: Tue, 03 Feb 2004 00:19:37 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1075763977.19762.195.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.44.0402030000460.16625-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4vWmUIzfs742Inf6Uv3F"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0402030000460.16625-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-4vWmUIzfs742Inf6Uv3F
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2004-02-03 at 00:04, Henrik Nordstrom wrote:
> On Mon, 2 Feb 2004, Martin Josefsson wrote:
>=20
> > I wondered the same when I found the problem. I thought that someone
> > must have noticed it before.
>=20
> Personally I am ashame for not having noticed this slight problem with=20
> iptables-restore. Have been using it since years back. But then we always=
=20
> have the same order of our matches so it is not that strangewe haven't=20
> noticed.

I first noticed it when I had rules like this:

*nat
-A PREROUTING -i eth0 -p tcp --dport 9310 -j DNAT --to-destination 192.168.=
1.2
COMMIT
*filter
-A INPUT -p tcp -m state --state NEW --dport 25 -j ACCEPT
COMMIT

Somehow --dport 25 came before --state NEW when I listed the rules after
loading the above :)
The problem went away when I split it up into two files and loaded each
table separately.

> > Since noone's screamed yet I'll merge it later today in order to give i=
t
> > wider testing, maybe then someone screams.
>=20
> Please do. Will try it out tomorrow.

I've committed it for both ipv4 and ipv6.

It seems to be working here but I havn't tested it with large rulesets
or with a lot of diffrent matches. I hope it won't break anything.

--=20
/Martin

--=-4vWmUIzfs742Inf6Uv3F
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBAHtsJWm2vlfa207ERArJzAJ9MDELT+InA358tlkQDLa7Qr62KwACfZ6GF
LpR9z5V6ZRCllxEyJzYzChs=
=DSe+
-----END PGP SIGNATURE-----

--=-4vWmUIzfs742Inf6Uv3F--
