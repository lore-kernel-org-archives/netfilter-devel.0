From: Harald Welte <laforge@netfilter.org>
Subject: Re: using a hash table for netfilter tables?
Date: Sun, 27 Apr 2003 15:17:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030427131705.GM990@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.33.0304240213430.8241-100000@fantomas.insite.com.br>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMyE1nnBIN65x+Vj"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andre Uratsuka Manoel <andre@insite.com.br>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0304240213430.8241-100000@fantomas.insite.com.br>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--qMyE1nnBIN65x+Vj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 24, 2003 at 02:19:58AM -0300, Andre Uratsuka Manoel wrote:
>=20
> 	Hi all,
>=20
> 	I need to replace the current list-based netfilter code for=20
> something using hashtables. The reason is that I have hundreds of tables=
=20
> in a project, but set up times are killing me. I took a peek at the code=
=20
> and it looked easy to do, since the current list-based code already takes=
=20
> care of locking, that's a huge problem I don't have to care about.
>=20
> 	Is there something I should know abot? Any tips? Is this stupid?

please try to read about the nf-hipac project (www.hipac.org, IIRC)

> 	Thanks in advance,
> 	Andre

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--qMyE1nnBIN65x+Vj
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+q9hRXaXGVTD0i/8RAp1vAKCE0WsSfADowphDt56UK2J5mmD3MwCcCQkq
iYIDx3zso7vI3eIvuD1SxUw=
=VXci
-----END PGP SIGNATURE-----

--qMyE1nnBIN65x+Vj--
