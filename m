From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] peer_pid checking in ip_queue
Date: Sat, 27 Mar 2004 22:17:21 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040327211721.GC26945@sunbeam.de.gnumonks.org>
References: <40601AE4.5070206@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BZaMRJmqxGScZ8Mx"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <40601AE4.5070206@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--BZaMRJmqxGScZ8Mx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 23, 2004 at 12:09:24PM +0100, Pablo Neira wrote:
> Hi,
>=20
> I patched ip_queue.c to modify the default behaviour if peer_pid is 0.=20
> In this case, there's no program in user space to receive the skbuff via=
=20
> netlink, but ip_queue will allocate space for the skbuff and after=20
> checking if peer_pid is 0, it will destroy this skbuff allocated. Am I=20
> missing anything?

seems fine to me, I'll put this in my list of pending patches

> Pablo
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--BZaMRJmqxGScZ8Mx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAZe9hXaXGVTD0i/8RApF8AJ9Fsp+9umRmdAH0HVPGjvcuiTeEHACgktxM
q6G0Fcjt6+bak/e85Yc6mcw=
=6T0U
-----END PGP SIGNATURE-----

--BZaMRJmqxGScZ8Mx--
