From: Harald Welte <laforge@netfilter.org>
Subject: Re: SNAT and IP ID
Date: Fri, 2 May 2003 17:43:19 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030502154319.GN26924@sunbeam.de.gnumonks.org>
References: <20030502070651.GG15143@oknodo.bof.de> <20030502090512.834482C085@lists.samba.org> <20030502095420.GI15143@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GeONROBiaq1zPAtT"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20030502095420.GI15143@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--GeONROBiaq1zPAtT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 02, 2003 at 11:54:21AM +0200, Patrick Schaaf wrote:
> Hi all,
>=20
> I have a question that seems too simple, somehow. Anyway, out with it:

one which has already been mentioned, not sure if on this list or on
netdev@oss.sgi.com a couple of months ago.;)

> Now, consider both hosts sending out an IP packet with identical ID
> field. Will the IDs be made unique by the SNAT process? If not, what
> happens when, after the SNAT, the packets get fragmented on their
> way to the server? The server cannot sanely reassemble.

yes, they will clash.   DaveM said something like IP ID's can already
clash on a single host at gbit speeds...  so it's not worth considering
this issue.

I said, that it can easily be fixed by creating a mangle table IPID
target which would reset the IPID on the NAT gateway.

This target (if used on nat boxes) would also prevent the
recently-published way to heuristically guess that NAT is used (because
of the different incrementing sequences IPID's that reveal multiple
hosts).

> best regards
>   Patrick
>=20

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--GeONROBiaq1zPAtT
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+spIXXaXGVTD0i/8RAhxZAJ9Vl6l9zsmTiXEgtwtuUsiPDLoVQwCgi1sG
7BCcDr2+uofADbfkoQZUjuc=
=4xTw
-----END PGP SIGNATURE-----

--GeONROBiaq1zPAtT--
