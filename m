From: Harald Welte <laforge@netfilter.org>
Subject: Re: [FWD][PATCH] conntrack endianes
Date: Fri, 23 May 2003 22:33:06 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030523203306.GY3077@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.44L.0305200945070.21231-100000@alpha.zarz.agh.edu.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ia6OAXuaU8F3AWLD"
Cc: netfilter-devel@lists.netfilter.org, Jakub Bogusz <qboosh@pld.org.pl>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Wojciech Sas Cieciwa <cieciwa@alpha.zarz.agh.edu.pl>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L.0305200945070.21231-100000@alpha.zarz.agh.edu.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Ia6OAXuaU8F3AWLD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 20, 2003 at 09:47:21AM +0200, Wojciech Sas Cieciwa wrote:

> This patch fixes bugs related to machine endianess (harmless on
> little-endians, but causing that some of conntrack modules don't
> work on big-endian machines).

thanks again. =20

> * the real problem: the way that ip_conntrack_tuple structures were
>   initialized was wrong - in compound literals port number was catched
>   by the first dst.u union element, which is int64_t (so port was
>   stored in 2 least significant bytes, i.e. 6 bytes after beginning of
>   dst.u.tcp or dst.u.udp element).
>   This fix uses C99 field specifiers.

This is a problem that doesn't occur as long as you don't apply the pptp
patch.  It was known but not fixed for quite some time.

I assume that this will close at least two bugzilla bugs, thanks a lot.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Ia6OAXuaU8F3AWLD
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+zoWCXaXGVTD0i/8RArCeAJ9hej/RLRKU0b+OgoIdpCRLzo+zGgCfcH6e
kee+EAwCKc2mUOQWih8wkEQ=
=qDaP
-----END PGP SIGNATURE-----

--Ia6OAXuaU8F3AWLD--
