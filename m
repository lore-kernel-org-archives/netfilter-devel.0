From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 2.4] nf-log update against latest 2.4-git
Date: Sun, 30 Oct 2005 10:49:16 +0100
Message-ID: <20051030094916.GC4479@sunbeam.de.gnumonks.org>
References: <4360F91B.1010509@tac.ch>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rurDnJN+lm4sj7QY"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@tac.ch>
Content-Disposition: inline
In-Reply-To: <4360F91B.1010509@tac.ch>
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


--rurDnJN+lm4sj7QY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 27, 2005 at 05:58:19PM +0200, Roberto Nibali wrote:
> Hello,

Hi Roberto!

> While updating my patchset I realised that the nf-log patch needed for
> the tcp window tracking feature does not properly apply anymore as-is.
>=20
> So here is an updated version against the latest 2.4-git which should
> work also when 2.4.32 is released. It's compile tested.

eek, a 2.4.x user ;)

> Please consider applying,

mh, we've recently decided not to officially support any other kernels
than the latest released stable kernel (which is 2.6.14 now).

I know, we tried to be differernt for a long time, but most projects
don't support 'new feature' patches for old kernel versions.

Soon we will be able have 'remote references' from patch-o-matic, so
people can run their own repositories (like they can do now with apt,
for example).

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--rurDnJN+lm4sj7QY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDZJccXaXGVTD0i/8RAvSEAJ0dNE5dynROU50pTLq3SQUt4zv/8QCdGrLI
mFzYfxOH3ILr8UTE+aYba7o=
=8zFv
-----END PGP SIGNATURE-----

--rurDnJN+lm4sj7QY--
