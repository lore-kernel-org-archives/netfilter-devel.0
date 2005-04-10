From: Harald Welte <laforge@netfilter.org>
Subject: Re: Patch lifetime Re: [PATCH] Fix NAT TCP sequence adjustment
Date: Sun, 10 Apr 2005 22:49:47 +0200
Message-ID: <20050410204947.GU9155@sunbeam.de.gnumonks.org>
References: <20050402202438.GA2968@linuxace.com> <4250435E.1090309@trash.net>
	<20050403235320.GB28850@linuxace.com>
	<20050404044033.GA1847@linuxace.com> <4250FA72.3020502@trash.net>
	<20050404204716.GA4067@linuxace.com>
	<42523F00.7010902@trash.net> <d2u3vs$3on$5@sea.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MLhIi0hnvBW8zLBk"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
Content-Disposition: inline
In-Reply-To: <d2u3vs$3on$5@sea.gmane.org>
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


--MLhIi0hnvBW8zLBk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 05, 2005 at 02:33:38PM +0100, Amin Azez wrote:
> I apologise for this dumb question, which really applies to most of the
> patches submitted here.
>=20
> I oberve that Phils' fine patch has undergone some peer review and is
> just about to be "accepted".
>=20
> What happens next? Does it hit pom-ng some short time later?

pom-ng is not for bugfixes, but for new matches/targets/helpers.

> When will it hit iptables cvs head and snapshots?

iptables (userspace) patches are usually applied immediately.

> When will it (will it ever) become part of the core kernel distribution?

after some more testing and synchronizin with the kernel release cycle

> What I am really trying to find out is the best way to track such
> patches through their lifetime until I no longer need to.

http://patchwork.netfilter.org/ will help, once it's fully running
(thanks jeremy)

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--MLhIi0hnvBW8zLBk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCWZFrXaXGVTD0i/8RAvwiAJ9spwKDyyGimIq+KpvUXhhBgzB9EQCfQEuK
pFVy4h/+pANDPVfA3jH2RTU=
=qvp+
-----END PGP SIGNATURE-----

--MLhIi0hnvBW8zLBk--
