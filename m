From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [2.6] Nonsense-messages from iptables + co.
Date: Fri, 14 Nov 2003 16:10:04 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20031114151004.GE2395@obroa-skai.de.gnumonks.org>
References: <20031114132054.GA646@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aT9PWwzfKXlsBJM1"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Linux-Kernel mailing list <linux-kernel@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20031114132054.GA646@merlin.emma.line.org>
List-Id: netfilter-devel.vger.kernel.org


--aT9PWwzfKXlsBJM1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2003 at 02:20:54PM +0100, Matthias Andree wrote:
> Who the heck added these unhelpful
>=20
> "ipt_hook: happy cracking."
>=20
> messages to iptables/mangling/connection tracking code? There are three
> instances.

I guess it was Rusty.  The idea message is a funny way of telling you
that you are sending incomplete ip headers.  Something that is not
likely to occur unless you are trying to send corrupt packets via raw ip
sockets...

> If the kernel has got something to say, it should be clear what the
> kernel means, say, maximum <whatever> rate exceeded or something, not
> such junk like this.

There are people who do actually have fun developing linux code.  And
Rusty has a peculiar sense of humor... for further reference see the
comments like 'furniture shopping' throughout the netfilter/iptables
source code.  I sometimes wish I had the same humor like he has.

Yes, I know.  Stuff like this is not exactly useful in error messages.
I'd say it's one of the few remainders of the 2.3.x early development
time.  Like the "Rusty's brain broke" messages that have recently been
removed/replaced.

btw: *nix has a long history of funny error messages, like 'printer on
fire' or others.

> This is IMHO a MUST-FIX before 2.6.0.

It is even in 2.4.x, where it could have been fixed throughout the last
couple of years.  Nobody else has yet complained.

> Matthias Andree

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Programming is like sex: One mistake and you have to support it your lifeti=
me

--aT9PWwzfKXlsBJM1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/tPBLXaXGVTD0i/8RAp9AAJ9tTrz2L+rfeXQT3QWC9grEKKtWowCfYMcw
/5qkkIyHiolD7r3M1ZuRkEk=
=dXv9
-----END PGP SIGNATURE-----

--aT9PWwzfKXlsBJM1--
