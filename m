From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] ipt_physdev extension
Date: Sun, 27 Apr 2003 10:22:01 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030427082201.GE990@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vmttodhTwj0NAgWp"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>
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


--vmttodhTwj0NAgWp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Davem!

On behalf of Bart de Schuymer, I'm forwarding you this patch which adds
some additional functionality to the 2.5.x ipt_physdev match.

Please apply, thanks.

--- linux-2.5.68/net/bridge/br_netfilter.c.old	Tue Apr 22 19:48:28 2003
+++ linux-2.5.68/net/bridge/br_netfilter.c	Sun Apr 20 12:57:09 2003
@@ -348,6 +348,8 @@
 	if (skb->pkt_type =3D=3D PACKET_OTHERHOST) {
 		skb->pkt_type =3D PACKET_HOST;
 		nf_bridge->mask |=3D BRNF_PKT_TYPE;
+		/* The physdev module checks on this */
+		nf_bridge->mask |=3D BRNF_BRIDGED;
 	}

 	nf_bridge->physoutdev =3D skb->dev;
--- linux-2.5.68/include/linux/netfilter_bridge.h.old	Tue Apr 22 19:47:40 2=
003
+++ linux-2.5.68/include/linux/netfilter_bridge.h	Sun Apr 20 12:56:07 2003
@@ -30,6 +30,7 @@
 #define BRNF_PKT_TYPE			0x01
 #define BRNF_BRIDGED_DNAT		0x02
 #define BRNF_DONT_TAKE_PARENT		0x04
+#define BRNF_BRIDGED			0x08

 enum nf_br_hook_priorities {
 	NF_BR_PRI_FIRST =3D INT_MIN,
--- linux-2.5.68/net/ipv4/netfilter/ipt_physdev.c.old	Tue Apr 22 19:46:36 2=
003
+++ linux-2.5.68/net/ipv4/netfilter/ipt_physdev.c	Mon Apr 21 21:34:37 2003
@@ -4,6 +4,9 @@
 #include <linux/skbuff.h>
 #include <linux/netfilter_ipv4/ipt_physdev.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_bridge.h>
+#define MATCH   1
+#define NOMATCH 0
=20
 static int
 match(const struct sk_buff *skb,
@@ -25,29 +28,62 @@
 	/* Not a bridged IP packet or no info available yet:
 	 * LOCAL_OUT/mangle and LOCAL_OUT/nat don't know if
 	 * the destination device will be a bridge. */
-	if (!(nf_bridge =3D skb->nf_bridge))
-		return 1;
+	if (!(nf_bridge =3D skb->nf_bridge)) {
+		/* Return MATCH if the invert flags of the used options are on */
+		if ((info->bitmask & IPT_PHYSDEV_OP_BRIDGED) &&
+		    !(info->invert & IPT_PHYSDEV_OP_BRIDGED))
+			return NOMATCH;
+		if ((info->bitmask & IPT_PHYSDEV_OP_ISIN) &&
+		    !(info->invert & IPT_PHYSDEV_OP_ISIN))
+			return NOMATCH;
+		if ((info->bitmask & IPT_PHYSDEV_OP_ISOUT) &&
+		    !(info->invert & IPT_PHYSDEV_OP_ISOUT))
+			return NOMATCH;
+		if ((info->bitmask & IPT_PHYSDEV_OP_IN) &&
+		    !(info->invert & IPT_PHYSDEV_OP_IN))
+			return NOMATCH;
+		if ((info->bitmask & IPT_PHYSDEV_OP_OUT) &&
+		    !(info->invert & IPT_PHYSDEV_OP_OUT))
+			return NOMATCH;
+		return MATCH;
+	}
=20
-	indev =3D nf_bridge->physindev ? nf_bridge->physindev->name : nulldevname;
-	outdev =3D nf_bridge->physoutdev ?
-		 nf_bridge->physoutdev->name : nulldevname;
+	/* This only makes sense in the FORWARD and POSTROUTING chains */
+	if ((info->bitmask & IPT_PHYSDEV_OP_BRIDGED) &&
+	    (!!(nf_bridge->mask & BRNF_BRIDGED) ^
+	    !(info->invert & IPT_PHYSDEV_OP_BRIDGED)))
+		return NOMATCH;
+
+	if ((info->bitmask & IPT_PHYSDEV_OP_ISIN &&
+	    (!nf_bridge->physindev ^ !!(info->invert & IPT_PHYSDEV_OP_ISIN))) ||
+	    (info->bitmask & IPT_PHYSDEV_OP_ISOUT &&
+	    (!nf_bridge->physoutdev ^ !!(info->invert & IPT_PHYSDEV_OP_ISOUT))))
+		return NOMATCH;
=20
+	if (!(info->bitmask & IPT_PHYSDEV_OP_IN))
+		goto match_outdev;
+	indev =3D nf_bridge->physindev ? nf_bridge->physindev->name : nulldevname;
 	for (i =3D 0, ret =3D 0; i < IFNAMSIZ/sizeof(unsigned long); i++) {
 		ret |=3D (((const unsigned long *)indev)[i]
 			^ ((const unsigned long *)info->physindev)[i])
 			& ((const unsigned long *)info->in_mask)[i];
 	}
=20
-	if ((ret =3D=3D 0) ^ !(info->invert & IPT_PHYSDEV_OP_MATCH_IN))
-		return 0;
+	if ((ret =3D=3D 0) ^ !(info->invert & IPT_PHYSDEV_OP_IN))
+		return NOMATCH;
=20
+match_outdev:
+	if (!(info->bitmask & IPT_PHYSDEV_OP_OUT))
+		return MATCH;
+	outdev =3D nf_bridge->physoutdev ?
+		 nf_bridge->physoutdev->name : nulldevname;
 	for (i =3D 0, ret =3D 0; i < IFNAMSIZ/sizeof(unsigned long); i++) {
 		ret |=3D (((const unsigned long *)outdev)[i]
 			^ ((const unsigned long *)info->physoutdev)[i])
 			& ((const unsigned long *)info->out_mask)[i];
 	}
=20
-	return (ret !=3D 0) ^ !(info->invert & IPT_PHYSDEV_OP_MATCH_OUT);
+	return (ret !=3D 0) ^ !(info->invert & IPT_PHYSDEV_OP_OUT);
 }
=20
 static int
@@ -57,9 +93,13 @@
 		       unsigned int matchsize,
 		       unsigned int hook_mask)
 {
+	const struct ipt_physdev_info *info =3D matchinfo;
+
 	if (matchsize !=3D IPT_ALIGN(sizeof(struct ipt_physdev_info)))
 		return 0;
-
+	if (!(info->bitmask & IPT_PHYSDEV_OP_MASK) ||
+	    info->bitmask & ~IPT_PHYSDEV_OP_MASK)
+		return 0;
 	return 1;
 }
=20
--- linux-2.5.68/include/linux/netfilter_ipv4/ipt_physdev.h.old	Tue Apr 22 =
19:47:16 2003
+++ linux-2.5.68/include/linux/netfilter_ipv4/ipt_physdev.h	Mon Apr 21 21:4=
2:54 2003
@@ -5,11 +5,16 @@
 #include <linux/if.h>
 #endif
=20
-#define IPT_PHYSDEV_OP_MATCH_IN 0x01
-#define IPT_PHYSDEV_OP_MATCH_OUT 0x02
+#define IPT_PHYSDEV_OP_IN		0x01
+#define IPT_PHYSDEV_OP_OUT		0x02
+#define IPT_PHYSDEV_OP_BRIDGED		0x04
+#define IPT_PHYSDEV_OP_ISIN		0x08
+#define IPT_PHYSDEV_OP_ISOUT		0x10
+#define IPT_PHYSDEV_OP_MASK		(0x20 - 1)
=20
 struct ipt_physdev_info {
 	u_int8_t invert;
+	u_int8_t bitmask;
 	char physindev[IFNAMSIZ];
 	char in_mask[IFNAMSIZ];
 	char physoutdev[IFNAMSIZ];
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--vmttodhTwj0NAgWp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+q5MpXaXGVTD0i/8RAvIVAJ0Y4Abt60zlE12QNiAXdEP+jcroVgCeIZtw
1zBXN05sAlmWL1ppocMebQo=
=L5m4
-----END PGP SIGNATURE-----

--vmttodhTwj0NAgWp--
