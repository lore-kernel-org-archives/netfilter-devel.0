From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] fuzzy.patch and fuzzy6.patch.ipv6
Date: Sat, 3 May 2003 20:49:17 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030503184917.GJ29373@sunbeam.de.gnumonks.org>
References: <20030430203937.18286.qmail@mail.com> <20030502231505.A30828@sith.mimuw.edu.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZG5hGh9V5E9QzVHS"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
	Hime Junior <hime@engineer.com>, cieciwa@alpha.zarz.agh.edu.pl,
	netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20030502231505.A30828@sith.mimuw.edu.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--ZG5hGh9V5E9QzVHS
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 02, 2003 at 11:15:05PM +0200, Jan Rekorajski wrote:
> >     I=B4m curious about what "unresolved symbols" are those and why,=20
> >  by changing the VALUE of a symbolic constant,the problem vanishes...
>=20
> They're because of the floating point usage, you won't see them on ix86
> because gcc uses native FPU instructions there - silently building
> incorrect code, but on other architectures gcc uses math emulation
> library thus generating unresolved symbols.

This is what I was assuming. I think I've seen this happen on PPC
before.

> The primary reason was to eliminate the usage of FPU from kernel,
> unresolved symbols is just the effect of this on non-ix86 archs.

I'll apply the patch now.
=20
> I guess Wojciech Cieciwa won't harm me if I say to direct questions
> to me as I'm the author of this patch ;)

;) So I'll put your name in the patch-o-matic Author field.

> Jan
> --=20
> Jan R?korajski            |  ALL SUSPECTS ARE GUILTY. PERIOD!
=20

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ZG5hGh9V5E9QzVHS
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+tA8tXaXGVTD0i/8RAnh6AJ9RWPjmAyXboD8doKVkLzkGK/kMyQCfe7my
VI+7hH2fbgux5RoiPMlj1s4=
=RESs
-----END PGP SIGNATURE-----

--ZG5hGh9V5E9QzVHS--
