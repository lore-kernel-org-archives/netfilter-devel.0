From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4] Re: Fw: Re: 2.4.22-bk2 and 2.4.23-pre1 broke routing
Date: Sat, 30 Aug 2003 20:55:10 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030830185510.GD17715@sunbeam.de.gnumonks.org>
References: <20030829041620.15eb0796.davem@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HENu/cXyPKFN4XCQ"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
Content-Disposition: inline
In-Reply-To: <20030829041620.15eb0796.davem@redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--HENu/cXyPKFN4XCQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 29, 2003 at 04:16:20AM -0700, David S. Miller wrote:
> Please review...

Hi Dave!

The fix is correct.  However, I would like to ask you to include the
below patch.  The only difference is that it inserts the new line=20
3 lines above.

Please apply, thanks.

=3D=3D=3D=3D=3D net/ipv4/netfilter/ipt_MASQUERADE.c 1.6 vs edited =3D=3D=3D=
=3D=3D
--- 1.6/net/ipv4/netfilter/ipt_MASQUERADE.c	Tue Aug 12 11:30:12 2003
+++ edited/net/ipv4/netfilter/ipt_MASQUERADE.c	Fri Aug 29 02:09:24 2003
@@ -87,6 +87,7 @@
 	key.dst =3D (*pskb)->nh.iph->daddr;
 	key.src =3D 0; /* Unknown: that's what we're trying to establish */
 	key.tos =3D RT_TOS((*pskb)->nh.iph->tos)|RTO_CONN;
+	key.oif =3D 0;
 #ifdef CONFIG_IP_ROUTE_FWMARK
 	key.fwmark =3D (*pskb)->nfmark;
 #endif

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--HENu/cXyPKFN4XCQ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/UPMOXaXGVTD0i/8RAguBAJ9HNysPxXsxp8U5/T5XWP1h/9W5WgCgqs2y
R2J+TfsSiF0kk6Q8uF49HpQ=
=89Gu
-----END PGP SIGNATURE-----

--HENu/cXyPKFN4XCQ--
