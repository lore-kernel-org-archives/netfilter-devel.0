From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH] ipt_physdev
Date: Tue, 11 Feb 2003 00:51:18 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200302110051.18402.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="------------Boundary-00=_I9A4JWVYD9KNSG7FBWBS"
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


--------------Boundary-00=_I9A4JWVYD9KNSG7FBWBS
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hello Harald,

In attachment is a patch for the userspace module corresponding with the=20
ipt_physdev.c kernel module included in the standard 2.5 kernel. This mod=
ule=20
allows filtering on the bridge ports. Since the header file is already in=
 the=20
standard kernel, I took the liberty of adding the module directly in the=20
extensions/Makefile. Please let me know if you don't think that's the rig=
ht=20
way...
Note that this kernel module does not exist for 2.4.

--=20
cheers,
Bart

--------------Boundary-00=_I9A4JWVYD9KNSG7FBWBS
Content-Type: text/x-diff;
  charset="us-ascii";
  name="libipt_physdev.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="libipt_physdev.patch"

--- userspace/extensions/Makefile.old	Mon Feb 10 19:35:25 2003
+++ userspace/extensions/Makefile	Mon Feb 10 19:37:30 2003
@@ -5,7 +5,7 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah conntrack dscp ecn esp helper icmp iplimit length limit mac mark multiport owner pkttype rpc standard state tcp tcpmss tos ttl udp unclean DNAT DSCP ECN LOG MARK MASQUERADE MIRROR REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS TTL ULOG
+PF_EXT_SLIB:=ah conntrack dscp ecn esp helper icmp iplimit length limit mac mark multiport owner physdev pkttype rpc standard state tcp tcpmss tos ttl udp unclean DNAT DSCP ECN LOG MARK MASQUERADE MIRROR REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS TTL ULOG
 PF6_EXT_SLIB:=eui64 hl icmpv6 length limit mac mark multiport owner standard tcp udp HL LOG MARK
 
 # Optionals
--- /dev/null	Sat May 18 12:04:21 2002
+++ userspace/extensions/libipt_physdev.c	Mon Feb 10 19:35:34 2003
@@ -0,0 +1,182 @@
+/* Shared library add-on to iptables to add bridge port matching support. */
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <ctype.h>
+#include <iptables.h>
+#include <linux/netfilter_ipv4/ipt_physdev.h>
+#if defined(__GLIBC__) && __GLIBC__ == 2
+#include <net/ethernet.h>
+#else
+#include <linux/if_ether.h>
+#endif
+
+static void
+help(void)
+{
+	printf(
+"physdev v%s options:\n"
+" --physdev-in [!] input name[+]	bridge port name ([+] for wildcard)\n"
+" --physdev-out [!] output name[+]	bridge port name ([+] for wildcard)\n"
+"\n", IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ "physdev-in", 1, 0, '1' },
+	{ "physdev-out", 1, 0, '2' },
+	{0}
+};
+
+/* copied from iptables.c */
+static void
+parse_interface(const char *arg, char *vianame, unsigned char *mask)
+{
+	int vialen = strlen(arg);
+	unsigned int i;
+
+	memset(mask, 0, IFNAMSIZ);
+	memset(vianame, 0, IFNAMSIZ);
+
+	if (vialen + 1 > IFNAMSIZ)
+		exit_error(PARAMETER_PROBLEM,
+			   "interface name `%s' must be shorter than IFNAMSIZ"
+			   " (%i)", arg, IFNAMSIZ-1);
+
+	strcpy(vianame, arg);
+	if (vialen == 0)
+		memset(mask, 0, IFNAMSIZ);
+	else if (vianame[vialen - 1] == '+') {
+		memset(mask, 0xFF, vialen - 1);
+		memset(mask + vialen - 1, 0, IFNAMSIZ - vialen + 1);
+		/* Don't remove `+' here! -HW */
+	} else {
+		/* Include nul-terminator in match */
+		memset(mask, 0xFF, vialen + 1);
+		memset(mask + vialen + 1, 0, IFNAMSIZ - vialen - 1);
+		for (i = 0; vianame[i]; i++) {
+			if (!isalnum(vianame[i])
+			    && vianame[i] != '_'
+			    && vianame[i] != '.') {
+				printf("Warning: wierd character in interface"
+				       " `%s' (No aliases, :, ! or *).\n",
+				       vianame);
+				break;
+			}
+		}
+	}
+}
+
+static void
+init(struct ipt_entry_match *m, unsigned int *nfcache)
+{
+}
+
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ipt_entry *entry,
+      unsigned int *nfcache,
+      struct ipt_entry_match **match)
+{
+	struct ipt_physdev_info *info =
+		(struct ipt_physdev_info*)(*match)->data;
+
+	switch (c) {
+	case '1':
+		if (*flags & IPT_PHYSDEV_OP_MATCH_IN)
+			exit_error(PARAMETER_PROBLEM,
+				   "multiple --physdev-in not allowed");
+		check_inverse(optarg, &invert, &optind, 0);
+		parse_interface(argv[optind-1], info->physindev, info->in_mask);
+		if (invert)
+			info->invert |= IPT_PHYSDEV_OP_MATCH_IN;
+		*flags |= IPT_PHYSDEV_OP_MATCH_IN;
+		break;
+
+	case '2':
+		if (*flags & IPT_PHYSDEV_OP_MATCH_OUT)
+			exit_error(PARAMETER_PROBLEM,
+				   "multiple --physdev-out not allowed");
+		check_inverse(optarg, &invert, &optind, 0);
+		parse_interface(argv[optind-1], info->physoutdev,
+				info->out_mask);
+		if (invert)
+			info->invert |= IPT_PHYSDEV_OP_MATCH_OUT;
+		*flags |= IPT_PHYSDEV_OP_MATCH_OUT;
+		break;
+
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+static void final_check(unsigned int flags)
+{
+}
+
+static void print_iface(u_int8_t invert, char *dev, char *prefix)
+{
+	char iface[IFNAMSIZ+2];
+
+	if (invert) {
+		iface[0] = '!';
+		iface[1] = '\0';
+	} else
+		iface[0] = '\0';
+
+	if (dev[0] != '\0') {
+		strcat(iface, dev);
+		printf("%s%s", prefix, iface);
+	}
+}
+
+static void
+print(const struct ipt_ip *ip,
+      const struct ipt_entry_match *match,
+      int numeric)
+{
+	struct ipt_physdev_info *info =
+		(struct ipt_physdev_info*)match->data;
+
+	printf("PHYSDEV match");
+	print_iface(info->invert & IPT_PHYSDEV_OP_MATCH_IN, info->physindev,
+		    " physindev=");
+	print_iface(info->invert & IPT_PHYSDEV_OP_MATCH_OUT, info->physoutdev,
+		    " physoutdev=");
+	printf(" ");
+}
+
+static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+{
+	struct ipt_physdev_info *info =
+		(struct ipt_physdev_info*)match->data;
+
+	print_iface(info->invert & IPT_PHYSDEV_OP_MATCH_IN, info->physindev,
+		    "--physdev-in ");
+	print_iface(info->invert & IPT_PHYSDEV_OP_MATCH_OUT, info->physoutdev,
+		    "--physdev-out ");
+	printf(" ");
+}
+
+static
+struct iptables_match physdev
+= { NULL,
+    "physdev",
+    IPTABLES_VERSION,
+    IPT_ALIGN(sizeof(struct ipt_physdev_info)),
+    IPT_ALIGN(sizeof(struct ipt_physdev_info)),
+    &help,
+    &init,
+    &parse,
+    &final_check,
+    &print,
+    &save,
+    opts
+};
+
+void _init(void)
+{
+	register_match(&physdev);
+}
--- /dev/null	Sat May 18 12:04:21 2002
+++ userspace/include/linux/netfilter_ipv4/ipt_physdev.h	Mon Feb 10 19:48:11 2003
@@ -0,0 +1,19 @@
+#ifndef _IPT_PHYSDEV_H
+#define _IPT_PHYSDEV_H
+
+#ifdef __KERNEL__
+#include <linux/if.h>
+#endif
+
+#define IPT_PHYSDEV_OP_MATCH_IN 0x01
+#define IPT_PHYSDEV_OP_MATCH_OUT 0x02
+
+struct ipt_physdev_info {
+	u_int8_t invert;
+	char physindev[IFNAMSIZ];
+	char in_mask[IFNAMSIZ];
+	char physoutdev[IFNAMSIZ];
+	char out_mask[IFNAMSIZ];
+};
+
+#endif /*_IPT_PHYSDEV_H*/

--------------Boundary-00=_I9A4JWVYD9KNSG7FBWBS--
