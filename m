From: Harald Welte <laforge@netfilter.org>
Subject: Re: 3 target treatment
Date: Wed, 5 Mar 2003 19:14:05 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030305181405.GD4880@sunbeam.de.gnumonks.org>
References: <3E65B570.5DA3802D@ie.cuhk.edu.hk> <200303052308.55624.fabrice@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4fNq9Po2wJlmxAaR"
Cc: Philip Ho <cbho@ie.cuhk.edu.hk>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Fabrice MARIE <fabrice@netfilter.org>
Content-Disposition: inline
In-Reply-To: <200303052308.55624.fabrice@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--4fNq9Po2wJlmxAaR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 05, 2003 at 11:08:55PM +0800, Fabrice MARIE wrote:
> On Wednesday 05 March 2003 16:29, Philip Ho wrote:
> > Dear all
> > Can I possibly force some matched packet passing through three targets
> > in a row, namely
> > 1. update fragmentation field in IP header
> > 2. update DSCP field
> > 3. mark it (must be in mangle table)
>=20
> Hello Philip,
>=20
> Short answer: for the moment you cannot.

well. I'm not sure.  Apart from the missing IPid target, I think the
solution with a custom chain and DSCP/MARK target [both return
IPT_CONTINUE] is fine for him.

writing an IPid target is extremely easy, the only problem is how to create
'secure' IPid's...

> Fabrice.
> --
> Fabrice MARIE

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--4fNq9Po2wJlmxAaR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+Zj5tXaXGVTD0i/8RAnOaAKCBNuz443MQVgL6AmnpUZQl9gHFCgCeNHjR
Z7M6Xab7uGyqdSOHdXUx55k=
=d9gf
-----END PGP SIGNATURE-----

--4fNq9Po2wJlmxAaR--
