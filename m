From: Harald Welte <laforge@netfilter.org>
Subject: Re: PPTP connection tracking
Date: Tue, 18 Feb 2003 10:38:12 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030218093812.GM11812@sunbeam.de.gnumonks.org>
References: <4.2.0.58.20030119145120.00b1c6f0@avocetgw> <20030217190023.GF11812@sunbeam.de.gnumonks.org> <3E51836B.8030207@snapgear.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrvsYIebpInmECXG"
Cc: Harald Welte <laforge@netfilter.org>, Paul Mielke <paulm@routefree.com>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
Content-Disposition: inline
In-Reply-To: <3E51836B.8030207@snapgear.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--lrvsYIebpInmECXG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 18, 2003 at 10:50:51AM +1000, Philip Craig wrote:
> >Can you please test if your setup works with this patch?
>=20
> Paul and I have tested that the attached patch fixes the problem.
> It is similar to yours, except that it returns earlier.  I don't
> think the calls to place_in_hashes() and do_bindings() are
> necessary if we just need to return NF_ACCEPT without doing any
> NAT?

yes, but  I can imagine the case where somebody actually _does_ want to
do some nat from the expectfn() - and we should keep that option open...

> Philip Craig - philipc@snapgear.com - http://www.SnapGear.com

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--lrvsYIebpInmECXG
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+Uf8EXaXGVTD0i/8RAtfQAJ0Xdt0s6quvY65iHDeMwDXUX+TUbQCdE7CN
/+BBCddbeJlu/5QhKvIxdTM=
=As4X
-----END PGP SIGNATURE-----

--lrvsYIebpInmECXG--
