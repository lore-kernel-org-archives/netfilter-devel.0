From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] patch-o-matic-ng patch
Date: Tue, 17 Feb 2004 16:24:40 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040217152440.GP981@sunbeam.de.gnumonks.org>
References: <20040214204204.GX7756@sunbeam.de.gnumonks.org> <Pine.LNX.4.33.0402171029070.10727-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QILrdhYozogw5Vly"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0402171029070.10727-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--QILrdhYozogw5Vly
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 17, 2004 at 10:48:34AM +0100, Jozsef Kadlecsik wrote:
> > Maybe we don't include any bugfixes in pom-ng, but rather put them as
> > patches somewhere in our FTP tree, but have pom-ng automatically fetch
> > those fixes via http/ftp on demand.
> >
> > As long as the fixes remain plain patches, people have the choice to
> > a) download them as patch and apply it by hand
> > b) use any kind of pom-ng release, but still get the most up-to-date
> >    security fixes?
>=20
> It's tempting to integrate fixes into pom-ng: we could rely on the
> version-checking/enforcing feature and the help (description) files could
> also be kept. But I see the strong arguments on keeping the fixes
> separated.

Ok.  Let's assume we have a fix for a bug introduced with 2.4.22.  Our
fix was submitted and included with 2.4.24.

We would then do something like

info:
Requires: linux >=3D 2.4.22
Requires: linux <=3D 2.4.24

However, what to do with the 2.6.x version of that fix?  In many cases,
it will not be the same patch.  This again means, that we would need a
=2Einfo per version of the patch.

Or we introduce '#if KERNEL_VERSION <=3D 2.6.0, #else, #endif' in the info
files, which is ugly, too.

Or we just don't specify any 'Requires' lines, and let Netfilter_POM
figure out whether a patch was applied or not.  However, in some cases
this doesn't work for a long time, if the same piece of code is touched
later again.

Do you have a solution for this problem?

> What about a plugin in Netfilter_POM.pm which would look into a hardcoded
> place (say ../fixes) and if it's found with patches, automatically adds
> them to the candidates? (Network is not always available.)

Mh.  The idea of not having 'base', 'submitted', 'included' was mostly
to avoid the ugly moving of files in the CVS tree, once they have been
submitted.  This is fine for new features that get at some point
included into the stock kernel.

One of the major differences of bugfixes is the ordering constraint.  In
most cases, it's very important that they get applied in-order.  We
could enforce this via 'Depends' and build a linear chain of fixes that
each depend on each other.

> Best regards,
> Jozsef

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--QILrdhYozogw5Vly
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAMjI4XaXGVTD0i/8RAvyJAJ4g8CHrrhN6+o6bqiq5DzjVDkYrewCffVOa
RS6taMDea7+GgM3Xlrw9PD4=
=J1+y
-----END PGP SIGNATURE-----

--QILrdhYozogw5Vly--
