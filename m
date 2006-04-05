From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] ip_conntrack section mismatch warning fix
Date: Wed, 5 Apr 2006 17:23:06 +0200
Message-ID: <20060405152306.GG20558@sunbeam.de.gnumonks.org>
References: <20060404113233.4de507d3@dxpl.pdx.osdl.net>
	<4433D496.2090706@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M38YqGLZlgb6RLPS"
Cc: netfilter-devel@lists.netfilter.org,
	Stephen Hemminger <shemminger@osdl.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <4433D496.2090706@trash.net>
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


--M38YqGLZlgb6RLPS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 05, 2006 at 04:30:46PM +0200, Patrick McHardy wrote:
> Stephen Hemminger wrote:
> > This is a bit of a hack. It eliminates the section mismatch warning from
> > latest linker. What happens is the init_or_cleanup code gets called
> > from cleanup() hook and the linker thinks it will reference __initdata
> > because of it's limited static analysis.  By asking compiler to
> > inline, it can eliminate that dead code. It does the __init text
> > section to grow, but then the space can be reclaimed.
>=20
> I think this might still fail without forced inlining. Our init
> functions look like crap anyway, and the reason mostly seems to
> be mass-registration of hooks, so I guess I'll clean that up
> with a small helper function and then just split them.

still I actually think of the shared init/cleanup functions as a big
feature rather than something that needs to be 'cleaned up'. =20

I'm obviously not opposing something like nf_register_hook_array(), but
that's a different issue.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--M38YqGLZlgb6RLPS
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFEM+DaXaXGVTD0i/8RAqrZAJ9rdDikAw9IvLEf/za5V81DtKfElACgkqfn
nPw+bg7zUy5dAxJ6UjDoRUg=
=Q1Qz
-----END PGP SIGNATURE-----

--M38YqGLZlgb6RLPS--
