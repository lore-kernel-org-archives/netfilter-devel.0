From: Harald Welte <laforge@gnumonks.org>
Subject: [PATCH] ipt_multiport invert fix
Date: Thu, 9 Jan 2003 15:39:42 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030109143942.GE9467@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U4Pv8ouM+6WX/UB7"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David Miller <davem@redhat.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--U4Pv8ouM+6WX/UB7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This is another patch of the series of patches you will receive from me tod=
ay.

Please apply to 2.4.x and 2.5.x, thanks.

This patch fixes the ULOG target when logging packets without any
ethernet header (mac address).

--- linux-2.4.20-pre11-plain/net/ipv4/netfilter/ipt_ULOG.c	Wed Oct 30 10:09=
:41 2002
+++ linux-2.4.20-pre11-ulogfix/net/ipv4/netfilter//ipt_ULOG.c	Wed Oct 30 10=
:07:31 2002
@@ -12,6 +12,7 @@
  * 	      module loadtime -HW
  * 2002/07/07 remove broken nflog_rcv() function -HW
  * 2002/08/29 fix shifted/unshifted nlgroup bug -HW
+ * 2002/10/30 fix uninitialized mac_len field - <Anders K. Pedersen>
  *
  * Released under the terms of the GPL
  *
@@ -31,7 +32,7 @@
  *   Specify, after how many clock ticks (intel: 100 per second) the queue
  * should be flushed even if it is not full yet.
  *
- * ipt_ULOG.c,v 1.21 2002/08/29 10:54:34 laforge Exp
+ * ipt_ULOG.c,v 1.22 2002/10/30 09:07:31 laforge Exp
  */
=20
 #include <linux/module.h>
@@ -224,7 +225,8 @@
 	    && in->hard_header_len <=3D ULOG_MAC_LEN) {
 		memcpy(pm->mac, (*pskb)->mac.raw, in->hard_header_len);
 		pm->mac_len =3D in->hard_header_len;
-	}
+	} else
+		pm->mac_len =3D 0;
=20
 	if (in)
 		strncpy(pm->indev_name, in->name, sizeof(pm->indev_name));
--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--U4Pv8ouM+6WX/UB7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+HYmuXaXGVTD0i/8RAnk1AJwMbuqEQb+ehgqemtnEHVFLo+weZgCggSwJ
yhBJXvvy6Z0Wav6deU1tC5s=
=dChh
-----END PGP SIGNATURE-----

--U4Pv8ouM+6WX/UB7--
