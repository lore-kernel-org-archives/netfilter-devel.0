From: Harald Welte <laforge@netfilter.org>
Subject: Re: pom without rebuilding kernel?
Date: Sat, 11 Oct 2003 21:20:44 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031011192044.GT13456@sunbeam.de.gnumonks.org>
References: <20031010134525.GB7985@puariko.nirvana>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lx6+J6gHrzwEpYNy"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Axel Thimm <Axel.Thimm@physik.fu-berlin.de>
Content-Disposition: inline
In-Reply-To: <20031010134525.GB7985@puariko.nirvana>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--lx6+J6gHrzwEpYNy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 10, 2003 at 03:45:25PM +0200, Axel Thimm wrote:
> I am thinking how nice it would be (or already is?) to build only the
> required kernel modules for a given kernel, without having to rebuild
> the kernel itself, like a lot of kernel drivers do (e.g. bttv, lirc,
> lm_sensors etc).

yes, you can do that in 99% of all cases.   Just use patch-o-matic like
normal and then do a=20


cd your_kernel_dir
make MODULE_SUBDIRS=3Dnet/ipv4/netfilter modules

then manually copy the modules into your module directory, or better=20
test them via insmod first.

> E.g. are there changes in pom patches to the core of the kernel
> sources, or can pom modules be compiled out of the kernel tree?

in very rare cases the core network stack needs to be modified.  all
other patches don't really require to rebuild the kernel.  But make sure
that you always unload _ALL_ netfilter modules (conntrack, etc) before
you load any of your newly-compiled modules.

I suppose your kernel will crash very soon if you keep your old
ip_conntrack.o while loading a new ip_conntrack_pptp.o, as an example.

> If there is way to do it, or a netfilter developer thinks it is worth
> the trouble, I'd rpm-package some modules for RH kernels. :)

no, I am strictly opposing binary distribution.  At least not as an
official part of the project.  Feel free to provide them at a different
place, but I just think it's too dangerous (and not really necessarry).

patch-o-matic is for potentially unstable or not generally useful code.
If people want to use some of it, they should understand enough and be
able to compile them on their own.
=20
Bugfixes shouldn't be in patch-o-matic anyway, we've had a long
discussion about that at the netfilter workshop.  This will change when
the new (2.6 compatible) patch-o-matic will be put in place.  I'm
working on that now, doing some perl coding for the first time in the
last couple of years ;)

> Thanks!
> --=20
> Axel.Thimm@physik.fu-berlin.de



--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--lx6+J6gHrzwEpYNy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/iFgMXaXGVTD0i/8RAmb8AKCgIWM45t09MO3kll1YavtD6B6AHQCdFO0+
W+jX3yMYFFa/nGCtoU8rTms=
=Tihk
-----END PGP SIGNATURE-----

--lx6+J6gHrzwEpYNy--
