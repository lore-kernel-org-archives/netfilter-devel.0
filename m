From: Harald Welte <laforge@netfilter.org>
Subject: Re: NAT problem with related connections
Date: Mon, 3 Nov 2003 08:48:05 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031103074805.GN1536@sunbeam.de.gnumonks.org>
References: <DAELKAPIKOFAFFKELNHOAEAHCAAA.listuser@epygi.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PVzMoMLf2pIra4Ty"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Nikolai Dahlem <listuser@epygi.de>
Content-Disposition: inline
In-Reply-To: <DAELKAPIKOFAFFKELNHOAEAHCAAA.listuser@epygi.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--PVzMoMLf2pIra4Ty
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2003 at 11:31:19AM +0100, Nikolai Dahlem wrote:
> A Master connection is established between Host1 and Server.
> Host1 and Host2 negotiate connection parameters via the Server.
> Then related data connections are established between Host1 and Host2
> directly.
> The control-connection is established and an expectation is created.
> The related connections work in some cases, the problem is that NAT chang=
es
> the source port.

this seems like a bug in your conntrack helper, but without having
access to the source I cannot possibly imagine what you are doing.
=20
> Nikolai Dahlem

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--PVzMoMLf2pIra4Ty
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/pgg1XaXGVTD0i/8RAt5yAJ4l/SmDCvXrYuxItDRuuh14zoHSQwCeOWqm
Ww0iefxFvjR5RVmwaYpHLxw=
=YaKX
-----END PGP SIGNATURE-----

--PVzMoMLf2pIra4Ty--
