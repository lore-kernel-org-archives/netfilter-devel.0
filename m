From: Harald Welte <laforge@netfilter.org>
Subject: Re: adding field into conntrack
Date: Sun, 1 Aug 2004 19:19:30 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040801171930.GD14539@sunbeam2>
References: <1091042173.4107fb7d2cabf@mail.crocetta.org> <1091060982.28111.30.camel@bach>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eheScQNz3K90DVRs"
Cc: sandr8@crocetta.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline
In-Reply-To: <1091060982.28111.30.camel@bach>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--eheScQNz3K90DVRs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 29, 2004 at 10:29:43AM +1000, Rusty Russell wrote:
> On Thu, 2004-07-29 at 05:16, sandr8@crocetta.org wrote:

> > would you mind if i add two 32 bits fields to the cnntrack structure?
> > i can surround them with an ifdef to have them only if the module i
> > am writing is configured. Their aim would be to count how many bytes
> > were transmitted on each side of the connection.
>=20
> 	I believe there's already a patch like that, or one in progress.=20
> You're not the only one who want this.

Yes, please see the 'conntrack-acct' patch in patch-o-matic-ng CVS.

> Rusty.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--eheScQNz3K90DVRs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBDSYiXaXGVTD0i/8RAllRAJ40ya3d4teKTbGDLLi3IxD4ONyK1gCgnvz5
5EbRDwF5ra7D7GdjwPqbPNQ=
=ZUgW
-----END PGP SIGNATURE-----

--eheScQNz3K90DVRs--
