From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: [PATCH 1/6] build: also use libtool for install stage
Date: Wed, 6 Mar 2013 15:08:36 +0400
Message-ID: <20130306110836.GA4017@altlinux.org>
References: <1359381586-11940-1-git-send-email-jengelh@inai.de> <1359381586-11940-2-git-send-email-jengelh@inai.de> <20130205033007.GA20407@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Cc: Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vint.altlinux.org ([194.107.17.35]:32875 "EHLO
	vint.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757107Ab3CFLIi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Mar 2013 06:08:38 -0500
Content-Disposition: inline
In-Reply-To: <20130205033007.GA20407@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 05, 2013 at 04:30:07AM +0100, Pablo Neira Ayuso wrote:
> On Mon, Jan 28, 2013 at 02:59:41PM +0100, Jan Engelhardt wrote:
> > The just-built library has DT_RPATH entries to be runnable from
> > whereever it is. If we just install that, the distro build systems
> > will throw warnings like
> >=20
> > 	(Open Build Service) ERROR: RPATH
> > 	"/home/abuild/rpmbuild/BUILD/iptables-1.4.17a/libxtables/.libs"
> > 	on /home/abuild/rpmbuild/BUILDROOT/iptables-1.4.17a-0.x86_64/usr/lib64=
/xtables/libxt_unclean.so
> > 	is not allowed
> >=20
> > These RPATH entries are indeed undesired for libraries is in a system
> > location, which is why libtool produces another copy of the library on
> > installation. The makefile however missed using libtool during
> > installation (introduced with commit v1.4.17-1-g68e77a2).
> > This patch now resolves this.
> >=20
> > There will be extra "warnings" emitted by libtool during `make install`,
> > like:
> >=20
> > 	libtool: install: warning: relinking "libxt_AUDIT.la"
> >=20
> > This is normal (and unfixable)
>=20
> I prefer that distros live with that warning. Users will be annoyed by
> that warning for sure.

There is a clear misunderstanding on your side, a RPATH entry containing
buildroot is a FATAL ERROR that distro maintainers have to fix just to
release new builds of iptables package.  The question is how long distro
maintainers would have to reinvent the wheel and rebase these build fixes
onto new iptables releases.  To be honest, I was much surprised to find
out that these build fixes didn't get into 1.4.18.

With regards to libtool's warnings about relinking, it happens to all
hundreds of packages that manipulate RPATH entries during build, so
the amount of annoyance among libtool users would hardly increase.


--=20
ldv

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAlE3I7QACgkQfKvmrJ41Nh4uFQCeJ3p6vuxz2IOq6+HIsGJWY8o1
pm8Anjn2vBJ85F9/FP3r+eg4O+AmOMC1
=kV5L
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
