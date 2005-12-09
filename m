From: Harald Welte <laforge@netfilter.org>
Subject: ipt_recent needs a maintainer!
Date: Fri, 9 Dec 2005 10:42:54 +0530
Message-ID: <20051209051254.GH4244@rama.exocore.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="smOfPzt+Qjm5bNGJ"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
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


--smOfPzt+Qjm5bNGJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

ipt_recent was merged into the mainline kernel quite some time ago, but
unfortunately the original author doesn't seem to be compelled to
maintain it.  There's nothing wrong with that, after all we do this
voluntarily!  But we have to deal with the consequences.

Some people from the netfilter community have indicated that it's coding
style rectifies a re-write, but that's something I don't want to address
now.

What we need as a short-term solution is somebody maintaining this
beast, somebody looking into bug reports, etc.

There are a number of bug reports coming in, and nobody really takes
care of them.  The latest one seems to be
https://bugzilla.netfilter.org/bugzilla/show_bug.cgi?id=3D415
but there are more, like
https://bugzilla.netfilter.org/bugzilla/show_bug.cgi?id=3D369
and I also think there have been reports to bugme.osdl.org as well.

Unless somebody volunteers to maintain that module within a short time,
I suggest that we mark it as "EXPERIMENTAL" and/or "BROKEN" in Kconfig
of 2.6.16.

Comments welcome.

[p.s: you might argue that it's the coreteam's job to do this. This is
true, but I for myself haven't even used the module once and I doubt
it's usefulness.  I'm not familiar with the code, and the past months
have shown that I'm not likely to find the time to deal with it.]

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--smOfPzt+Qjm5bNGJ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDmRJWXaXGVTD0i/8RAjJNAKCJLJuTSIO6ULAsE1gtDfU040IEggCgrE42
MSLYeevuIEgD2Mh2Z98B6es=
=XXEp
-----END PGP SIGNATURE-----

--smOfPzt+Qjm5bNGJ--
