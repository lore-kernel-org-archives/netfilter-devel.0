From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] patch-o-matic-ng patch
Date: Sat, 14 Feb 2004 21:42:04 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040214204204.GX7756@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.33.0402120950190.3899-200000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="S4+Kf2w4CfEO117G"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0402120950190.3899-200000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--S4+Kf2w4CfEO117G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 12, 2004 at 10:22:19AM +0100, Jozsef Kadlecsik wrote:
> Hi Harald,

Hi Jozsef. =20
>=20
> Please consider applying the attached patch on top of patch-o-matic-ng.
> The new features implemented in the patch are:

Thank you very much, I will regard this as the best birthday present
I have received this year ;)

I hope it was not too painful to wade through my crappy perl code.

>   The patch assumes that 'patch' files are renamed to 'linux.patch'.

Ok, I'll do that directly in the CVS repository to not loose version
information

> - Userspace patches are supported (iptables-x.y.z.patch).
>   In general, other projects can be plugged in easily: just the
>   new srcpath and version parsing are required and that's all.

great.  I really like to have it remain very=20

> Working on patch-o-matic-ng I believe one more important thing is
> still missing. In the current shape p-o-m-ng is more tailored for
> 'feature' patches, and not for tiny bugfixes.=20
> [...]
> If you agree with such modifications, I can start implementing the
> required code.

At the workshop last year, I think we agreed to not put bugfixes into
patch-o-matic anymore.  The general idea was to

1) not require people to run a special program for just fixing bugs
2) not blow up patch-o-matic any further
3) not require us to release a new patch-o-matic with every bugfix

However, I'm not sure whether this is still the right decision.  What
about a bit of both?

Maybe we don't include any bugfixes in pom-ng, but rather put them as
patches somewhere in our FTP tree, but have pom-ng automatically fetch
those fixes via http/ftp on demand.

As long as the fixes remain plain patches, people have the choice to
a) download them as patch and apply it by hand
b) use any kind of pom-ng release, but still get the most up-to-date
   security fixes?

what do you think?

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

--S4+Kf2w4CfEO117G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFALogcXaXGVTD0i/8RAsxmAKCSCSynaAXzCRwnFCZ0XfOZUQYg2QCeJcA5
yQghJ9+OUwMrAqozjc6qiuk=
=zjTn
-----END PGP SIGNATURE-----

--S4+Kf2w4CfEO117G--
