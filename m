From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] fixes for ipt_unclean.c
Date: Mon, 14 Oct 2002 16:05:33 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021014160533.A13233@sunbeam.de.gnumonks.org>
References: <20021014132237.N13233@sunbeam.de.gnumonks.org> <20021014132620.O13233@sunbeam.de.gnumonks.org> <20021014.042139.48671253.davem@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MhDS85o8hQkNlKhq"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
Content-Disposition: inline
In-Reply-To: <20021014.042139.48671253.davem@redhat.com>; from davem@redhat.com on Mon, Oct 14, 2002 at 04:21:39AM -0700
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--MhDS85o8hQkNlKhq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 14, 2002 at 04:21:39AM -0700, David Miller wrote:
>    From: Harald Welte <laforge@gnumonks.org>
>    Date: Mon, 14 Oct 2002 13:26:20 +0200
>=20
>    I've actually already sent you the UDP checksum fix.  The UDP sport fi=
x is=20
>    new, though.  Just ignore the one failing hunk, thanks.
>=20
> You need to resend it anyways as I've already deleted the original
> email sorry :(

No problem. Here it comes again.=20

--- linux-2.4.19-vanilla/net/ipv4/netfilter/ipt_unclean.c	2002-09-10 16:06:=
50.000000000 +0200
+++ linux/net/ipv4/netfilter/ipt_unclean.c	2002-10-12 00:56:09.000000000 +0=
200
@@ -216,10 +216,9 @@
 				 csum_partial((char *)udph, datalen, 0)) !=3D 0)
 		return 0;
=20
-	/* CHECK: Ports can't be zero. */
-	if (!udph->source || !udph->dest) {
-		limpk("UDP zero ports %u/%u\n",
-		      ntohs(udph->source), ntohs(udph->dest));
+	/* CHECK: Destination port can't be zero. */
+	if (!udph->dest) {
+		limpk("UDP zero destination port\n");
 		return 0;
 	}
=20
--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--MhDS85o8hQkNlKhq
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9qs8tXaXGVTD0i/8RAkqWAJ9VCuq4ESLeymeeVgSzOcVs6cykLACfUSxv
9gTCztaUysB3Oqkr9v+O4dE=
=q95p
-----END PGP SIGNATURE-----

--MhDS85o8hQkNlKhq--
