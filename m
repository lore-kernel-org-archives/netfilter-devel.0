From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: debian forwarded bug report
Date: Sat, 18 Oct 2003 10:36:40 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1066466199.12168.60.camel@tux.rsn.bth.se>
References: <20031018061355.GA17357@ljlane.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-r/BTteLtrDkNX1Oo2Xxn"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Laurence J. Lane" <ljlane@nontoxic.org>
In-Reply-To: <20031018061355.GA17357@ljlane.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-r/BTteLtrDkNX1Oo2Xxn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2003-10-18 at 08:13, Laurence J. Lane wrote:
> 191486: iptables: fragmented log messages from iptables
> http://bugs.debian.org/191486
>=20
> The URL shows badly fragmented syslog ouput from iptables. I
> can not reproduce this one.

Is this an SMP machine? I used to see the same things here but with
martian logs, havn't seen it since I upgraded the machine to 2.4.21-rc1.
It was an issue with the printk buffer iirc.

Just beware, there's a serious conntrack bug in 2.4.21 so don't
recommend the reporter of the bug to try that one, recommend 2.4.22
instead.

And as always... always apply all patches from submitted (and possibly
pending) from patch-o-matic.

--=20
/Martin

--=-r/BTteLtrDkNX1Oo2Xxn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQA/kPuXWm2vlfa207ERAgt4AKC36LtFCVsUE6TtzX6a9Az8fmMMRgCfQ0xI
fWQBUANfFVAmAXa7NeRgPnE=
=1zb9
-----END PGP SIGNATURE-----

--=-r/BTteLtrDkNX1Oo2Xxn--
