From: Harald Welte <laforge@netfilter.org>
Subject: Re: MAX_PORTS for ftp modules
Date: Tue, 27 Jan 2004 12:01:49 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040127110149.GI11761@sunbeam.de.gnumonks.org>
References: <20040126211441.GA10833@66.27.62.2>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Rmm1Stw9KgbdL9/H"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Nick Pasich <newsletters@NickAndBarb.net>
Content-Disposition: inline
In-Reply-To: <20040126211441.GA10833@66.27.62.2>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Rmm1Stw9KgbdL9/H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 26, 2004 at 01:14:41PM -0800, Nick Pasich wrote:
>  Hi,
>=20
>  I've exhausted the MAX_PORTS limit of 8 for ftp using my own port id.
>=20
>  I'm wondering if there are any repercussions in upping the limit to say,
>  16 in the following modules.

No, as has been discussed before (and I believe is also on the FAQ or
some HOWTO).

>  ip_conntrack_ftp.c:  #define MAX_PORTS 8
>  ip_conntrack_irc.c:  #define MAX_PORTS 8
>  ip_conntrack_tftp.c: #define MAX_PORTS 8
>  ip_nat_ftp.c:        #define MAX_PORTS 8
>  ip_nat_irc.c:        #define MAX_PORTS 8
>  ip_nat_tftp.c:       #define MAX_PORTS 8
>=20
>=20
>  I noticed that ipfwadm_core.c has "IP_FW_MAX_PORTS" which is defined in
>  ipfwadm_core.h as 10.

ipfwadm is 2.0.x kernel backwards compatibility.  please don't look at
that code ever again ;)

=20

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Rmm1Stw9KgbdL9/H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAFkUdXaXGVTD0i/8RAmW4AKC0hGThSs5UAr4Kxt/Eti/A67pLIwCeOJzb
dc0RwY5GkUOcyGDvjhcOc2Y=
=xZ7g
-----END PGP SIGNATURE-----

--Rmm1Stw9KgbdL9/H--
