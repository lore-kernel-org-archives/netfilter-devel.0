From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] PPTP connection tracking: fixed oops during PPTP
	connect when interface under heavy load
Date: Tue, 1 Feb 2005 11:40:02 +0100
Message-ID: <20050201104002.GV6878@sunbeam.de.gnumonks.org>
References: <41DD887D.6080007@nit.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="65fUfJaAyj3QT6Mb"
Cc: netfilter-devel@lists.netfilter.org
To: Peter Zion <pzion@nit.ca>
Content-Disposition: inline
In-Reply-To: <41DD887D.6080007@nit.ca>
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


--65fUfJaAyj3QT6Mb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 06, 2005 at 01:50:37PM -0500, Peter Zion wrote:
> Summary:
>=20
> If PPTP connection tracking is running on a machine and certain PPTP
> packets arrive out of order, or preceding packets never made
> it to the machine, the PPTP connection tracking code will
> dereference NULL pointers.  Reproduction steps are to attempt PPTP=20
> connections to the machine on an interface under heavy load.

That's really strange.  Can you please elaborate more?

The keymaps are added in ip_conntrack_pptp.c for OUT_CALL_REPLY and
IN_CALL_CONNECT messages.  And they are only changed by ip_nat_pptp.c
for exactly the same packets.

So if your bug report is correct, this means that packet arrive at
ip_nat_pptp.c but never go through ip_conntrack_pptp ?!?

> Patch:
>=20
> [..]

I'd rather like to understand what's going on before applying your
patch.  And even if the soultion was similar, I would check for missing
keymaps at the caller rather than the callee.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--65fUfJaAyj3QT6Mb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFB/1yCXaXGVTD0i/8RAmq6AJ9KjM2OzH2AHrTRAFdNOxHpKLGfRwCgjDzU
iXeAICHco2BFzIedQ+UQ0Ko=
=tB/1
-----END PGP SIGNATURE-----

--65fUfJaAyj3QT6Mb--
