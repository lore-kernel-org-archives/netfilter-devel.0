From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH] add more functionality to the physdev module
Date: Sat, 26 Apr 2003 15:26:09 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200304261526.09395.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="------------Boundary-00=_LBDYQ14JHPAKX6O891OJ"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--------------Boundary-00=_LBDYQ14JHPAKX6O891OJ
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hello Harald,

Attached are 2 patches for the iptables physdev module, the kernel part a=
nd=20
the iptables userspace part.
The kernel patch contains the needed changes to br_netfilter.c and=20
netfilter_bridge.h, since the new physdev code depends on these changes.
Added functionality:
--physdev-is-in: matches if the packet has entered through a bridge inter=
face.
--physdev-is-out: matches if the packet will leave through a bridge inter=
face.
--physdev-is-bridged: matches if the packet is being bridged instead of=20
routed.
Could you send the kernel patch to Dave and apply the userspace patch to =
the=20
CVS?

--=20
cheers,
Bart

--------------Boundary-00=_LBDYQ14JHPAKX6O891OJ
Content-Type: text/x-diff;
  charset="us-ascii";
  name="2.5.68_physdev_bridged.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="2.5.68_physdev_bridged.diff"

--- linux-2.5.68/net/bridge/br_netfilter.c.old	Tue Apr 22 19:48:28 2003
+++ linux-2.5.68/net/bridge/br_netfilter.c	Sun Apr 20 12:57:09 2003
@@ -348,6 +348,8 @@
 	if (skb->pkt_type == PACKET_OTHERHOST) {
 		skb->pkt_type = PACKET_HOST;
 		nf_bridge->mask |= BRNF_PKT_TYPE;
+		/* The physdev module checks on this */
+		nf_bridge->mask |= BRNF_BRIDGED;
 	}

 	nf_bridge->physoutdev = skb->dev;
--- linux-2.5.68/include/linux/netfilter_bridge.h.old	Tue Apr 22 19:47:40 2003
+++ linux-2.5.68/include/linux/netfilter_bridge.h	Sun Apr 20 12:56:07 2003
@@ -30,6 +30,7 @@
 #define BRNF_PKT_TYPE			0x01
 #define BRNF_BRIDGED_DNAT		0x02
 #define BRNF_DONT_TAKE_PARENT		0x04
+#define BRNF_BRIDGED			0x08

 enum nf_br_hook_priorities {
 	NF_BR_PRI_FIRST = INT_MIN,
--- linux-2.5.68/net/ipv4/netfilter/ipt_physdev.c.old	Tue Apr 22 19:46:36 2003
+++ linux-2.5.68/net/ipv4/netfilter/ipt_physdev.c	Mon Apr 21 21:34:37 2003
@@ -4,6 +4,9 @@
 #include <linux/skbuff.h>
 #include <linux/netfilter_ipv4/ipt_physdev.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_bridge.h>
+#define MATCH   1
+#define NOMATCH 0
 
 static int
 match(const struct sk_buff *skb,
@@ -25,29 +28,62 @@
 	/* Not a bridged IP packet or no info available yet:
 	 * LOCAL_OUT/mangle and LOCAL_OUT/nat don't know if
 	 * the destination device will be a bridge. */
-	if (!(nf_bridge = skb->nf_bridge))
-		return 1;
+	if (!(nf_bridge = skb->nf_bridge)) {
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
 
-	indev = nf_bridge->physindev ? nf_bridge->physindev->name : nulldevname;
-	outdev = nf_bridge->physoutdev ?
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
 
+	if (!(info->bitmask & IPT_PHYSDEV_OP_IN))
+		goto match_outdev;
+	indev = nf_bridge->physindev ? nf_bridge->physindev->name : nulldevname;
 	for (i = 0, ret = 0; i < IFNAMSIZ/sizeof(unsigned long); i++) {
 		ret |= (((const unsigned long *)indev)[i]
 			^ ((const unsigned long *)info->physindev)[i])
 			& ((const unsigned long *)info->in_mask)[i];
 	}
 
-	if ((ret == 0) ^ !(info->invert & IPT_PHYSDEV_OP_MATCH_IN))
-		return 0;
+	if ((ret == 0) ^ !(info->invert & IPT_PHYSDEV_OP_IN))
+		return NOMATCH;
 
+match_outdev:
+	if (!(info->bitmask & IPT_PHYSDEV_OP_OUT))
+		return MATCH;
+	outdev = nf_bridge->physoutdev ?
+		 nf_bridge->physoutdev->name : nulldevname;
 	for (i = 0, ret = 0; i < IFNAMSIZ/sizeof(unsigned long); i++) {
 		ret |= (((const unsigned long *)outdev)[i]
 			^ ((const unsigned long *)info->physoutdev)[i])
 			& ((const unsigned long *)info->out_mask)[i];
 	}
 
-	return (ret != 0) ^ !(info->invert & IPT_PHYSDEV_OP_MATCH_OUT);
+	return (ret != 0) ^ !(info->invert & IPT_PHYSDEV_OP_OUT);
 }
 
 static int
@@ -57,9 +93,13 @@
 		       unsigned int matchsize,
 		       unsigned int hook_mask)
 {
+	const struct ipt_physdev_info *info = matchinfo;
+
 	if (matchsize != IPT_ALIGN(sizeof(struct ipt_physdev_info)))
 		return 0;
-
+	if (!(info->bitmask & IPT_PHYSDEV_OP_MASK) ||
+	    info->bitmask & ~IPT_PHYSDEV_OP_MASK)
+		return 0;
 	return 1;
 }
 
--- linux-2.5.68/include/linux/netfilter_ipv4/ipt_physdev.h.old	Tue Apr 22 19:47:16 2003
+++ linux-2.5.68/include/linux/netfilter_ipv4/ipt_physdev.h	Mon Apr 21 21:42:54 2003
@@ -5,11 +5,16 @@
 #include <linux/if.h>
 #endif
 
-#define IPT_PHYSDEV_OP_MATCH_IN 0x01
-#define IPT_PHYSDEV_OP_MATCH_OUT 0x02
+#define IPT_PHYSDEV_OP_IN		0x01
+#define IPT_PHYSDEV_OP_OUT		0x02
+#define IPT_PHYSDEV_OP_BRIDGED		0x04
+#define IPT_PHYSDEV_OP_ISIN		0x08
+#define IPT_PHYSDEV_OP_ISOUT		0x10
+#define IPT_PHYSDEV_OP_MASK		(0x20 - 1)
 
 struct ipt_physdev_info {
 	u_int8_t invert;
+	u_int8_t bitmask;
 	char physindev[IFNAMSIZ];
 	char in_mask[IFNAMSIZ];
 	char physoutdev[IFNAMSIZ];

--------------Boundary-00=_LBDYQ14JHPAKX6O891OJ
Content-Type: text/x-diff;
  charset="us-ascii";
  name="physdev_user_bridged.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="physdev_user_bridged.diff"

--- userspace/iptables.8.old	Mon Mar  3 23:23:22 2003
+++ userspace/iptables.8	Tue Apr 22 20:09:19 2003
@@ -557,8 +557,7 @@
 supporting this feature)
 .SS physdev
 This module matches on the bridge port input and output devices enslaved
-to a bridge device. This is only useful if the input device or output device
-is a bridge device. This module is a part of the infrastructure that enables
+to a bridge device. This module is a part of the infrastructure that enables
 a transparent bridging IP firewall and is only useful for kernel versions
 above version 2.5.44.
 .TP
@@ -570,7 +569,8 @@
 and
 .B PREROUTING
 chains). If the interface name ends in a "+", then any
-interface which begins with this name will match.
+interface which begins with this name will match. If the packet didn't arrive
+through a bridge device, this packet won't match this option, unless '!' is used.
 .TP
 .B --physdev-out name
 Name of a bridge port via which a packet is going to be sent (for packets
@@ -585,7 +585,19 @@
 .B OUTPUT
 chains one cannot match on the bridge output port, however one can in the
 .B "filter OUTPUT"
-chain.
+chain. If the packet won't leave by a bridge device or it is yet unknown what
+the output device will be, then the packet won't match this option, unless
+'!' is used.
+.TP
+.B --physdev-is-in
+Matches if the packet has entered through a bridge interface.
+.TP
+.B --physdev-is-out
+Matches if the packet will leave through a bridge interface.
+.TP
+.B --physdev-is-bridged
+Matches if the packet is being bridged and therefore is not being routed.
+This is only useful in the FORWARD and POSTROUTING chains.
 .SS pkttype
 This module matches the link-layer packet type.
 .TP
--- userspace/extensions/libipt_physdev.c.old	Tue Feb 11 21:19:04 2003
+++ userspace/extensions/libipt_physdev.c	Tue Apr 22 20:11:22 2003
@@ -17,14 +17,20 @@
 {
 	printf(
 "physdev v%s options:\n"
-" --physdev-in [!] input name[+]	bridge port name ([+] for wildcard)\n"
+" --physdev-in [!] input name[+]		bridge port name ([+] for wildcard)\n"
 " --physdev-out [!] output name[+]	bridge port name ([+] for wildcard)\n"
+" [!] --physdev-is-in			arrived on a bridge device\n"
+" [!] --physdev-is-out			will leave on a bridge device\n"
+" [!] --physdev-is-bridged		it's a bridged packet\n"
 "\n", IPTABLES_VERSION);
 }
 
 static struct option opts[] = {
 	{ "physdev-in", 1, 0, '1' },
 	{ "physdev-out", 1, 0, '2' },
+	{ "physdev-is-in", 0, 0, '3' },
+	{ "physdev-is-out", 0, 0, '4' },
+	{ "physdev-is-bridged", 0, 0, '5' },
 	{0}
 };
 
@@ -83,26 +89,56 @@
 
 	switch (c) {
 	case '1':
-		if (*flags & IPT_PHYSDEV_OP_MATCH_IN)
-			exit_error(PARAMETER_PROBLEM,
-				   "multiple --physdev-in not allowed");
+		if (*flags & IPT_PHYSDEV_OP_IN)
+			goto multiple_use;
 		check_inverse(optarg, &invert, &optind, 0);
 		parse_interface(argv[optind-1], info->physindev, info->in_mask);
 		if (invert)
-			info->invert |= IPT_PHYSDEV_OP_MATCH_IN;
-		*flags |= IPT_PHYSDEV_OP_MATCH_IN;
+			info->invert |= IPT_PHYSDEV_OP_IN;
+		info->bitmask |= IPT_PHYSDEV_OP_IN;
+		*flags |= IPT_PHYSDEV_OP_IN;
 		break;
 
 	case '2':
-		if (*flags & IPT_PHYSDEV_OP_MATCH_OUT)
-			exit_error(PARAMETER_PROBLEM,
-				   "multiple --physdev-out not allowed");
+		if (*flags & IPT_PHYSDEV_OP_OUT)
+			goto multiple_use;
 		check_inverse(optarg, &invert, &optind, 0);
 		parse_interface(argv[optind-1], info->physoutdev,
 				info->out_mask);
 		if (invert)
-			info->invert |= IPT_PHYSDEV_OP_MATCH_OUT;
-		*flags |= IPT_PHYSDEV_OP_MATCH_OUT;
+			info->invert |= IPT_PHYSDEV_OP_OUT;
+		info->bitmask |= IPT_PHYSDEV_OP_OUT;
+		*flags |= IPT_PHYSDEV_OP_OUT;
+		break;
+
+	case '3':
+		if (*flags & IPT_PHYSDEV_OP_ISIN)
+			goto multiple_use;
+		check_inverse(optarg, &invert, &optind, 0);
+		info->bitmask |= IPT_PHYSDEV_OP_ISIN;
+		if (invert)
+			info->invert |= IPT_PHYSDEV_OP_ISIN;
+		*flags |= IPT_PHYSDEV_OP_ISIN;
+		break;
+
+	case '4':
+		if (*flags & IPT_PHYSDEV_OP_ISOUT)
+			goto multiple_use;
+		check_inverse(optarg, &invert, &optind, 0);
+		info->bitmask |= IPT_PHYSDEV_OP_ISOUT;
+		if (invert)
+			info->invert |= IPT_PHYSDEV_OP_ISOUT;
+		*flags |= IPT_PHYSDEV_OP_ISOUT;
+		break;
+
+	case '5':
+		if (*flags & IPT_PHYSDEV_OP_BRIDGED)
+			goto multiple_use;
+		check_inverse(optarg, &invert, &optind, 0);
+		if (invert)
+			info->invert |= IPT_PHYSDEV_OP_BRIDGED;
+		*flags |= IPT_PHYSDEV_OP_BRIDGED;
+		info->bitmask |= IPT_PHYSDEV_OP_BRIDGED;
 		break;
 
 	default:
@@ -110,26 +146,16 @@
 	}
 
 	return 1;
-}
+multiple_use:
+	exit_error(PARAMETER_PROBLEM,
+	   "multiple use of the same physdev option is not allowed");
 
-static void final_check(unsigned int flags)
-{
 }
 
-static void print_iface(u_int8_t invert, char *dev, char *prefix)
+static void final_check(unsigned int flags)
 {
-	char iface[IFNAMSIZ+2];
-
-	if (invert) {
-		iface[0] = '!';
-		iface[1] = '\0';
-	} else
-		iface[0] = '\0';
-
-	if (dev[0] != '\0') {
-		strcat(iface, dev);
-		printf("%s%s", prefix, iface);
-	}
+	if (flags == 0)
+		exit_error(PARAMETER_PROBLEM, "PHYSDEV: no physdev option specified");
 }
 
 static void
@@ -141,10 +167,22 @@
 		(struct ipt_physdev_info*)match->data;
 
 	printf("PHYSDEV match");
-	print_iface(info->invert & IPT_PHYSDEV_OP_MATCH_IN, info->physindev,
-		    " physindev=");
-	print_iface(info->invert & IPT_PHYSDEV_OP_MATCH_OUT, info->physoutdev,
-		    " physoutdev=");
+	if (info->bitmask & IPT_PHYSDEV_OP_ISIN)
+		printf("%s --physdev-is-in",
+		       info->invert & IPT_PHYSDEV_OP_ISIN ? " !":"");
+	if (info->bitmask & IPT_PHYSDEV_OP_IN)
+		printf("%s --physdev-in %s",
+		(info->invert & IPT_PHYSDEV_OP_IN) ? " !":"", info->physindev);
+
+	if (info->bitmask & IPT_PHYSDEV_OP_ISOUT)
+		printf("%s --physdev-is-out",
+		       info->invert & IPT_PHYSDEV_OP_ISOUT ? " !":"");
+	if (info->bitmask & IPT_PHYSDEV_OP_OUT)
+		printf("%s --physdev-out %s",
+		(info->invert & IPT_PHYSDEV_OP_OUT) ? " !":"", info->physoutdev);
+	if (info->bitmask & IPT_PHYSDEV_OP_BRIDGED)
+		printf("%s --physdev-is-bridged",
+		       info->invert & IPT_PHYSDEV_OP_BRIDGED ? " !":"");
 	printf(" ");
 }
 
@@ -153,10 +191,22 @@
 	struct ipt_physdev_info *info =
 		(struct ipt_physdev_info*)match->data;
 
-	print_iface(info->invert & IPT_PHYSDEV_OP_MATCH_IN, info->physindev,
-		    "--physdev-in ");
-	print_iface(info->invert & IPT_PHYSDEV_OP_MATCH_OUT, info->physoutdev,
-		    "--physdev-out ");
+	if (info->bitmask & IPT_PHYSDEV_OP_ISIN)
+		printf("%s --physdev-is-in",
+		       info->invert & IPT_PHYSDEV_OP_ISIN ? " !":"");
+	if (info->bitmask & IPT_PHYSDEV_OP_IN)
+		printf("%s --physdev-in %s",
+		(info->invert & IPT_PHYSDEV_OP_IN) ? " !":"", info->physindev);
+
+	if (info->bitmask & IPT_PHYSDEV_OP_ISOUT)
+		printf("%s --physdev-is-out",
+		       info->invert & IPT_PHYSDEV_OP_ISOUT ? " !":"");
+	if (info->bitmask & IPT_PHYSDEV_OP_OUT)
+		printf("%s --physdev-out %s",
+		(info->invert & IPT_PHYSDEV_OP_OUT) ? " !":"", info->physoutdev);
+	if (info->bitmask & IPT_PHYSDEV_OP_BRIDGED)
+		printf("%s --physdev-is-bridged",
+		       info->invert & IPT_PHYSDEV_OP_BRIDGED ? " !":"");
 	printf(" ");
 }
 
--- userspace/include/linux/netfilter_ipv4/ipt_physdev.h.old	Tue Feb 11 21:19:04 2003
+++ userspace/include/linux/netfilter_ipv4/ipt_physdev.h	Tue Apr 22 20:05:08 2003
@@ -5,11 +5,16 @@
 #include <linux/if.h>
 #endif
 
-#define IPT_PHYSDEV_OP_MATCH_IN 0x01
-#define IPT_PHYSDEV_OP_MATCH_OUT 0x02
+#define IPT_PHYSDEV_OP_IN		0x01
+#define IPT_PHYSDEV_OP_OUT		0x02
+#define IPT_PHYSDEV_OP_BRIDGED		0x04
+#define IPT_PHYSDEV_OP_ISIN		0x08
+#define IPT_PHYSDEV_OP_ISOUT		0x10
+#define IPT_PHYSDEV_OP_MASK		(0x20 - 1)
 
 struct ipt_physdev_info {
 	u_int8_t invert;
+	u_int8_t bitmask;
 	char physindev[IFNAMSIZ];
 	char in_mask[IFNAMSIZ];
 	char physoutdev[IFNAMSIZ];

--------------Boundary-00=_LBDYQ14JHPAKX6O891OJ--
