From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables PATCH v2] nft: Split nft core to become family independant
Date: Wed, 30 Jan 2013 15:33:48 +0200
Message-ID: <1359552828-13386-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:3805 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183Ab3A3NeG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2013 08:34:06 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This makes nft core code independant from the family. Each family needs
to implement and provide a struct nft_family_ops {}.

This split will ease the future support of bridge and arp rules manipulations.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>

---

Version 2:
	- added (C) headers 
	- put relevant shared macros in nft-shared.h

 iptables/Makefile.am  |   1 +
 iptables/nft-ipv4.c   | 315 ++++++++++++++++++
 iptables/nft-ipv6.c   | 224 +++++++++++++
 iptables/nft-shared.c | 426 ++++++++++++++++++++++++
 iptables/nft-shared.h | 110 +++++++
 iptables/nft.c        | 893 +-------------------------------------------------
 iptables/nft.h        |   2 +
 iptables/xtables.c    |  19 +-
 8 files changed, 1100 insertions(+), 890 deletions(-)
 create mode 100644 iptables/nft-ipv4.c
 create mode 100644 iptables/nft-ipv6.c
 create mode 100644 iptables/nft-shared.c
 create mode 100644 iptables/nft-shared.h

diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index f91682e..15f319e 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -29,6 +29,7 @@ if HAVE_LIBMNL
 if HAVE_LIBNFTABLES
 xtables_multi_SOURCES += xtables-save.c xtables-restore.c \
 			 xtables-standalone.c xtables.c nft.c \
+			 nft-shared.c nft-ipv4.c nft-ipv6.c \
 			 xtables-config-parser.y xtables-config-syntax.l \
 			 xtables-config.c
 xtables_multi_LDADD   += -lmnl -lnftables
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
new file mode 100644
index 0000000..154dabe
--- /dev/null
+++ b/iptables/nft-ipv4.c
@@ -0,0 +1,315 @@
+/*
+ * Authors:
+ * 	(C) 2013 by Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
+ * 	(C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License as published by
+ *	the Free Software Foundation; either version 2 of the License, or
+ *	(at your option) any later version.
+ *
+ *	This program is distributed in the hope that it will be useful,
+ *	but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *	GNU General Public License for more details.
+ *
+ *	You should have received a copy of the GNU General Public License
+ *	along with this program; if not, write to the Free Software
+ *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <string.h>
+#include <stdio.h>
+
+#include <sys/socket.h>
+#include <netinet/in.h>
+#include <arpa/inet.h>
+#include <netinet/ip.h>
+
+#include <xtables.h>
+
+#include <linux/netfilter/nf_tables.h>
+
+#include "nft-shared.h"
+
+static int nft_ipv4_add(struct nft_rule *r, struct iptables_command_state *cs)
+{
+	uint32_t op;
+
+	if (cs->fw.ip.iniface[0] != '\0')
+		add_iniface(r, cs->fw.ip.iniface, cs->fw.ip.invflags);
+
+	if (cs->fw.ip.outiface[0] != '\0')
+		add_outiface(r, cs->fw.ip.outiface, cs->fw.ip.invflags);
+
+	if (cs->fw.ip.src.s_addr != 0)
+		add_addr(r, offsetof(struct iphdr, saddr),
+			 &cs->fw.ip.src.s_addr, 4, cs->fw.ip.invflags);
+
+	if (cs->fw.ip.dst.s_addr != 0)
+		add_addr(r, offsetof(struct iphdr, daddr),
+			 &cs->fw.ip.dst.s_addr, 4, cs->fw.ip.invflags);
+
+	if (cs->fw.ip.proto != 0)
+		add_proto(r, offsetof(struct iphdr, protocol), 1,
+			  cs->fw.ip.proto, cs->fw.ip.invflags);
+
+	if (cs->fw.ip.flags & IPT_F_FRAG) {
+		add_payload(r, offsetof(struct iphdr, frag_off), 2);
+		/* get the 13 bits that contain the fragment offset */
+		add_bitwise_u16(r, 0x1fff, !0x1fff);
+
+		/* if offset is non-zero, this is a fragment */
+		if (cs->fw.ip.invflags & IPT_INV_FRAG)
+			op = NFT_CMP_EQ;
+		else
+			op = NFT_CMP_NEQ;
+
+		add_cmp_u16(r, 0, op);
+	}
+
+	return cs->fw.ip.flags;
+}
+
+static bool nft_ipv4_is_same(const struct iptables_command_state *a,
+			     const struct iptables_command_state *b)
+{
+	if (a->fw.ip.src.s_addr != b->fw.ip.src.s_addr
+	    || a->fw.ip.dst.s_addr != b->fw.ip.dst.s_addr
+	    || a->fw.ip.smsk.s_addr != b->fw.ip.smsk.s_addr
+	    || a->fw.ip.dmsk.s_addr != b->fw.ip.dmsk.s_addr
+	    || a->fw.ip.proto != b->fw.ip.proto
+	    || a->fw.ip.flags != b->fw.ip.flags
+	    || a->fw.ip.invflags != b->fw.ip.invflags) {
+		DEBUGP("different src/dst/proto/flags/invflags\n");
+		return false;
+	}
+
+	return is_same_interfaces(a->fw.ip.iniface, a->fw.ip.outiface,
+				  a->fw.ip.iniface_mask, a->fw.ip.outiface_mask,
+				  b->fw.ip.iniface, b->fw.ip.outiface,
+				  b->fw.ip.iniface_mask, b->fw.ip.outiface_mask);
+}
+
+static void get_frag(struct nft_rule_expr_iter *iter, bool *inv)
+{
+	struct nft_rule_expr *e;
+	const char *name;
+	uint8_t op;
+
+	e = nft_rule_expr_iter_next(iter);
+	if (e == NULL)
+		return;
+
+	/* we assume correct mask and xor */
+	name = nft_rule_expr_get_str(e, NFT_RULE_EXPR_ATTR_NAME);
+	if (strcmp(name, "bitwise") != 0) {
+		DEBUGP("skipping no bitwise after payload\n");
+		return;
+	}
+
+	/* Now check for cmp */
+	e = nft_rule_expr_iter_next(iter);
+	if (e == NULL)
+		return;
+
+	/* we assume correct data */
+	name = nft_rule_expr_get_str(e, NFT_RULE_EXPR_ATTR_NAME);
+	if (strcmp(name, "cmp") != 0) {
+		DEBUGP("skipping no cmp after payload\n");
+		return;
+	}
+
+	op = nft_rule_expr_get_u8(e, NFT_EXPR_CMP_OP);
+	if (op == NFT_CMP_EQ)
+		*inv = true;
+	else
+		*inv = false;
+}
+
+static void print_frag(bool inv)
+{
+	if (inv)
+		printf("! -f ");
+	else
+		printf("-f ");
+}
+
+static const char *mask_to_str(uint32_t mask)
+{
+	static char mask_str[sizeof("255.255.255.255")];
+	uint32_t bits, hmask = ntohl(mask);
+	struct in_addr mask_addr = {
+		.s_addr = mask,
+	};
+	int i;
+
+	if (mask == 0xFFFFFFFFU) {
+		sprintf(mask_str, "32");
+		return mask_str;
+	}
+
+	i    = 32;
+	bits = 0xFFFFFFFEU;
+	while (--i >= 0 && hmask != bits)
+		bits <<= 1;
+	if (i >= 0)
+		sprintf(mask_str, "%u", i);
+	else
+		sprintf(mask_str, "%s", inet_ntoa(mask_addr));
+
+	return mask_str;
+}
+
+static void nft_ipv4_print_payload(struct nft_rule_expr *e,
+				  struct nft_rule_expr_iter *iter)
+{
+	uint32_t offset;
+	bool inv;
+
+	offset = nft_rule_expr_get_u32(e, NFT_EXPR_PAYLOAD_OFFSET);
+
+	switch(offset) {
+	struct in_addr addr;
+	uint8_t proto;
+
+	case offsetof(struct iphdr, saddr):
+		get_cmp_data(iter, &addr, sizeof(addr), &inv);
+		if (inv)
+			printf("! -s %s/%s ", inet_ntoa(addr),
+						mask_to_str(0xffffffff));
+		else
+			printf("-s %s/%s ", inet_ntoa(addr),
+						mask_to_str(0xffffffff));
+		break;
+	case offsetof(struct iphdr, daddr):
+		get_cmp_data(iter, &addr, sizeof(addr), &inv);
+		if (inv)
+			printf("! -d %s/%s ", inet_ntoa(addr),
+						mask_to_str(0xffffffff));
+		else
+			printf("-d %s/%s ", inet_ntoa(addr),
+						mask_to_str(0xffffffff));
+		break;
+	case offsetof(struct iphdr, protocol):
+		get_cmp_data(iter, &proto, sizeof(proto), &inv);
+		print_proto(proto, inv);
+		break;
+	case offsetof(struct iphdr, frag_off):
+		get_frag(iter, &inv);
+		print_frag(inv);
+		break;
+	default:
+		DEBUGP("unknown payload offset %d\n", offset);
+		break;
+	}
+}
+
+static void nft_ipv4_parse_meta(struct nft_rule_expr *e, uint8_t key,
+				struct iptables_command_state *cs)
+{
+	parse_meta(e, key, cs->fw.ip.iniface, cs->fw.ip.iniface_mask,
+		   cs->fw.ip.outiface, cs->fw.ip.outiface_mask,
+		   &cs->fw.ip.invflags);
+}
+
+static void nft_ipv4_parse_payload(struct nft_rule_expr_iter *iter,
+				   struct iptables_command_state *cs,
+				   uint32_t offset)
+{
+	switch(offset) {
+	struct in_addr addr;
+	uint8_t proto;
+	bool inv;
+
+	case offsetof(struct iphdr, saddr):
+		get_cmp_data(iter, &addr, sizeof(addr), &inv);
+		cs->fw.ip.src.s_addr = addr.s_addr;
+		cs->fw.ip.smsk.s_addr = 0xffffffff;
+		if (inv)
+			cs->fw.ip.invflags |= IPT_INV_SRCIP;
+		break;
+	case offsetof(struct iphdr, daddr):
+		get_cmp_data(iter, &addr, sizeof(addr), &inv);
+		cs->fw.ip.dst.s_addr = addr.s_addr;
+		cs->fw.ip.dmsk.s_addr = 0xffffffff;
+		if (inv)
+			cs->fw.ip.invflags |= IPT_INV_DSTIP;
+		break;
+	case offsetof(struct iphdr, protocol):
+		get_cmp_data(iter, &proto, sizeof(proto), &inv);
+		cs->fw.ip.proto = proto;
+		if (inv)
+			cs->fw.ip.invflags |= IPT_INV_PROTO;
+		break;
+	case offsetof(struct iphdr, frag_off):
+		cs->fw.ip.flags |= IPT_F_FRAG;
+		get_frag(iter, &inv);
+		if (inv)
+			cs->fw.ip.invflags |= IPT_INV_FRAG;
+		break;
+	default:
+		DEBUGP("unknown payload offset %d\n", offset);
+		break;
+	}
+}
+
+static void nft_ipv4_parse_immediate(struct iptables_command_state *cs)
+{
+	cs->fw.ip.flags |= IPT_F_GOTO;
+}
+
+static void print_ipv4_addr(const struct iptables_command_state *cs,
+			    unsigned int format)
+{
+	char buf[BUFSIZ];
+
+	fputc(cs->fw.ip.invflags & IPT_INV_SRCIP ? '!' : ' ', stdout);
+	if (cs->fw.ip.smsk.s_addr == 0L && !(format & FMT_NUMERIC))
+		printf(FMT("%-19s ","%s "), "anywhere");
+	else {
+		if (format & FMT_NUMERIC)
+			strcpy(buf, xtables_ipaddr_to_numeric(&cs->fw.ip.src));
+		else
+			strcpy(buf, xtables_ipaddr_to_anyname(&cs->fw.ip.src));
+		strcat(buf, xtables_ipmask_to_numeric(&cs->fw.ip.smsk));
+		printf(FMT("%-19s ","%s "), buf);
+	}
+
+	fputc(cs->fw.ip.invflags & IPT_INV_DSTIP ? '!' : ' ', stdout);
+	if (cs->fw.ip.dmsk.s_addr == 0L && !(format & FMT_NUMERIC))
+		printf(FMT("%-19s ","-> %s"), "anywhere");
+	else {
+		if (format & FMT_NUMERIC)
+			strcpy(buf, xtables_ipaddr_to_numeric(&cs->fw.ip.dst));
+		else
+			strcpy(buf, xtables_ipaddr_to_anyname(&cs->fw.ip.dst));
+		strcat(buf, xtables_ipmask_to_numeric(&cs->fw.ip.dmsk));
+		printf(FMT("%-19s ","-> %s"), buf);
+	}
+}
+
+
+static uint8_t nft_ipv4_print_firewall(const struct iptables_command_state *cs,
+				       const char *targname, unsigned int num,
+				       unsigned int format)
+{
+	print_firewall_details(cs, targname, cs->fw.ip.flags,
+			       cs->fw.ip.invflags, cs->fw.ip.proto,
+			       cs->fw.ip.iniface, cs->fw.ip.outiface,
+			       num, format);
+
+	print_ipv4_addr(cs, format);
+
+	return cs->fw.ip.flags;
+}
+
+struct nft_family_ops nft_family_ops_ipv4 = {
+	.add = nft_ipv4_add,
+	.is_same = nft_ipv4_is_same,
+	.print_payload = nft_ipv4_print_payload,
+	.parse_meta = nft_ipv4_parse_meta,
+	.parse_payload = nft_ipv4_parse_payload,
+	.parse_immediate = nft_ipv4_parse_immediate,
+	.print_firewall = nft_ipv4_print_firewall,
+};
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
new file mode 100644
index 0000000..0470c37
--- /dev/null
+++ b/iptables/nft-ipv6.c
@@ -0,0 +1,224 @@
+/*
+ * Authors:
+ * 	(C) 2013 by Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
+ * 	(C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License as published by
+ *	the Free Software Foundation; either version 2 of the License, or
+ *	(at your option) any later version.
+ *
+ *	This program is distributed in the hope that it will be useful,
+ *	but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *	GNU General Public License for more details.
+ *
+ *	You should have received a copy of the GNU General Public License
+ *	along with this program; if not, write to the Free Software
+ *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <string.h>
+#include <stdio.h>
+
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <arpa/inet.h>
+#include <netinet/ip6.h>
+
+#include <xtables.h>
+
+#include "nft-shared.h"
+
+static int nft_ipv6_add(struct nft_rule *r, struct iptables_command_state *cs)
+{
+	if (cs->fw6.ipv6.iniface[0] != '\0')
+		add_iniface(r, cs->fw6.ipv6.iniface, cs->fw6.ipv6.invflags);
+
+	if (cs->fw6.ipv6.outiface[0] != '\0')
+		add_outiface(r, cs->fw6.ipv6.outiface, cs->fw6.ipv6.invflags);
+
+	if (!IN6_IS_ADDR_UNSPECIFIED(&cs->fw6.ipv6.src))
+		add_addr(r, offsetof(struct ip6_hdr, ip6_src),
+			 &cs->fw6.ipv6.src, 16, cs->fw6.ipv6.invflags);
+
+	if (!IN6_IS_ADDR_UNSPECIFIED(&cs->fw6.ipv6.dst))
+		add_addr(r, offsetof(struct ip6_hdr, ip6_dst),
+			 &cs->fw6.ipv6.dst, 16, cs->fw6.ipv6.invflags);
+
+	if (cs->fw6.ipv6.proto != 0)
+		add_proto(r, offsetof(struct ip6_hdr, ip6_nxt), 1,
+			  cs->fw6.ipv6.proto, cs->fw6.ipv6.invflags);
+
+	return cs->fw6.ipv6.flags;
+}
+
+static bool nft_ipv6_is_same(const struct iptables_command_state *a,
+			     const struct iptables_command_state *b)
+{
+	if (memcmp(a->fw6.ipv6.src.s6_addr, b->fw6.ipv6.src.s6_addr,
+		   sizeof(struct in6_addr)) != 0
+	    || memcmp(a->fw6.ipv6.dst.s6_addr, b->fw6.ipv6.dst.s6_addr,
+		    sizeof(struct in6_addr)) != 0
+	    || a->fw6.ipv6.proto != b->fw6.ipv6.proto
+	    || a->fw6.ipv6.flags != b->fw6.ipv6.flags
+	    || a->fw6.ipv6.invflags != b->fw6.ipv6.invflags) {
+		DEBUGP("different src/dst/proto/flags/invflags\n");
+		return false;
+	}
+
+	return is_same_interfaces(a->fw6.ipv6.iniface, a->fw6.ipv6.outiface,
+				  a->fw6.ipv6.iniface_mask,
+				  a->fw6.ipv6.outiface_mask,
+				  b->fw6.ipv6.iniface, b->fw6.ipv6.outiface,
+				  b->fw6.ipv6.iniface_mask,
+				  b->fw6.ipv6.outiface_mask);
+}
+
+static void nft_ipv6_print_payload(struct nft_rule_expr *e,
+				  struct nft_rule_expr_iter *iter)
+{
+	uint32_t offset;
+	bool inv;
+
+	offset = nft_rule_expr_get_u32(e, NFT_EXPR_PAYLOAD_OFFSET);
+
+	switch (offset) {
+	char addr_str[INET6_ADDRSTRLEN];
+	struct in6_addr addr;
+	uint8_t proto;
+	case offsetof(struct ip6_hdr, ip6_src):
+		get_cmp_data(iter, &addr, sizeof(addr), &inv);
+		inet_ntop(AF_INET6, &addr, addr_str, INET6_ADDRSTRLEN);
+
+		if (inv)
+			printf("! -s %s ", addr_str);
+		else
+			printf("-s %s ", addr_str);
+
+		break;
+	case offsetof(struct ip6_hdr, ip6_dst):
+		get_cmp_data(iter, &addr, sizeof(addr), &inv);
+		inet_ntop(AF_INET6, &addr, addr_str, INET6_ADDRSTRLEN);
+
+		if (inv)
+			printf("! -d %s ", addr_str);
+		else
+			printf("-d %s ", addr_str);
+
+		break;
+	case offsetof(struct ip6_hdr, ip6_nxt):
+		get_cmp_data(iter, &proto, sizeof(proto), &inv);
+		print_proto(proto, inv);
+		break;
+	default:
+		DEBUGP("unknown payload offset %d\n", offset);
+		break;
+	}
+}
+
+static void nft_ipv6_parse_meta(struct nft_rule_expr *e, uint8_t key,
+				struct iptables_command_state *cs)
+{
+	parse_meta(e, key, cs->fw6.ipv6.iniface,
+		   cs->fw6.ipv6.iniface_mask, cs->fw6.ipv6.outiface,
+		   cs->fw6.ipv6.outiface_mask, &cs->fw6.ipv6.invflags);
+}
+
+static void nft_ipv6_parse_payload(struct nft_rule_expr_iter *iter,
+				   struct iptables_command_state *cs,
+				   uint32_t offset)
+{
+	switch (offset) {
+	struct in6_addr addr;
+	uint8_t proto;
+	bool inv;
+
+	case offsetof(struct ip6_hdr, ip6_src):
+		get_cmp_data(iter, &addr, sizeof(addr), &inv);
+		memcpy(cs->fw6.ipv6.src.s6_addr, &addr, sizeof(addr));
+		if (inv)
+			cs->fw6.ipv6.invflags |= IPT_INV_SRCIP;
+		break;
+	case offsetof(struct ip6_hdr, ip6_dst):
+		get_cmp_data(iter, &addr, sizeof(addr), &inv);
+		memcpy(cs->fw6.ipv6.dst.s6_addr, &addr, sizeof(addr));
+		if (inv)
+			cs->fw6.ipv6.invflags |= IPT_INV_DSTIP;
+		break;
+	case offsetof(struct ip6_hdr, ip6_nxt):
+		get_cmp_data(iter, &proto, sizeof(proto), &inv);
+		cs->fw6.ipv6.proto = proto;
+		if (inv)
+			cs->fw6.ipv6.invflags |= IPT_INV_PROTO;
+	default:
+		DEBUGP("unknown payload offset %d\n", offset);
+		break;
+	}
+}
+
+static void nft_ipv6_parse_immediate(struct iptables_command_state *cs)
+{
+	cs->fw6.ipv6.flags |= IPT_F_GOTO;
+}
+
+static void print_ipv6_addr(const struct iptables_command_state *cs,
+			    unsigned int format)
+{
+	char buf[BUFSIZ];
+
+	fputc(cs->fw6.ipv6.invflags & IPT_INV_SRCIP ? '!' : ' ', stdout);
+	if (IN6_IS_ADDR_UNSPECIFIED(&cs->fw6.ipv6.src)
+	    && !(format & FMT_NUMERIC))
+		printf(FMT("%-19s ","%s "), "anywhere");
+	else {
+		if (format & FMT_NUMERIC)
+			strcpy(buf,
+			       xtables_ip6addr_to_numeric(&cs->fw6.ipv6.src));
+		else
+			strcpy(buf,
+			       xtables_ip6addr_to_anyname(&cs->fw6.ipv6.src));
+		strcat(buf, xtables_ip6mask_to_numeric(&cs->fw6.ipv6.smsk));
+		printf(FMT("%-19s ","%s "), buf);
+	}
+
+
+	fputc(cs->fw6.ipv6.invflags & IPT_INV_DSTIP ? '!' : ' ', stdout);
+	if (IN6_IS_ADDR_UNSPECIFIED(&cs->fw6.ipv6.dst)
+	    && !(format & FMT_NUMERIC))
+		printf(FMT("%-19s ","-> %s"), "anywhere");
+	else {
+		if (format & FMT_NUMERIC)
+			strcpy(buf,
+			       xtables_ip6addr_to_numeric(&cs->fw6.ipv6.dst));
+		else
+			strcpy(buf,
+			       xtables_ip6addr_to_anyname(&cs->fw6.ipv6.dst));
+		strcat(buf, xtables_ip6mask_to_numeric(&cs->fw6.ipv6.dmsk));
+		printf(FMT("%-19s ","-> %s"), buf);
+	}
+}
+
+static uint8_t nft_ipv6_print_firewall(const struct iptables_command_state *cs,
+				       const char *targname, unsigned int num,
+				       unsigned int format)
+{
+	print_firewall_details(cs, targname, cs->fw6.ipv6.flags,
+			       cs->fw6.ipv6.invflags, cs->fw6.ipv6.proto,
+			       cs->fw6.ipv6.iniface, cs->fw6.ipv6.outiface,
+			       num, format);
+
+	print_ipv6_addr(cs, format);
+
+	return cs->fw6.ipv6.flags;
+}
+
+struct nft_family_ops nft_family_ops_ipv6 = {
+	.add = nft_ipv6_add,
+	.is_same = nft_ipv6_is_same,
+	.print_payload = nft_ipv6_print_payload,
+	.parse_meta = nft_ipv6_parse_meta,
+	.parse_payload = nft_ipv6_parse_payload,
+	.parse_immediate = nft_ipv6_parse_immediate,
+	.print_firewall = nft_ipv6_print_firewall,
+};
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
new file mode 100644
index 0000000..e9c34f0
--- /dev/null
+++ b/iptables/nft-shared.c
@@ -0,0 +1,426 @@
+/*
+ * Authors:
+ * 	(C) 2013 by Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
+ * 	(C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License as published by
+ *	the Free Software Foundation; either version 2 of the License, or
+ *	(at your option) any later version.
+ *
+ *	This program is distributed in the hope that it will be useful,
+ *	but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *	GNU General Public License for more details.
+ *
+ *	You should have received a copy of the GNU General Public License
+ *	along with this program; if not, write to the Free Software
+ *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <string.h>
+#include <stdio.h>
+#include <stdbool.h>
+#include <netdb.h>
+
+#include <linux/netfilter/nf_tables.h>
+
+#include <libmnl/libmnl.h>
+#include <libnftables/rule.h>
+#include <libnftables/expr.h>
+
+#include "nft-shared.h"
+#include "xshared.h"
+
+extern struct nft_family_ops nft_family_ops_ipv4;
+extern struct nft_family_ops nft_family_ops_ipv6;
+
+void add_meta(struct nft_rule *r, uint32_t key)
+{
+	struct nft_rule_expr *expr;
+
+	expr = nft_rule_expr_alloc("meta");
+	if (expr == NULL)
+		return;
+
+	nft_rule_expr_set_u32(expr, NFT_EXPR_META_KEY, key);
+	nft_rule_expr_set_u32(expr, NFT_EXPR_META_DREG, NFT_REG_1);
+
+	nft_rule_add_expr(r, expr);
+}
+
+void add_payload(struct nft_rule *r, int offset, int len)
+{
+	struct nft_rule_expr *expr;
+
+	expr = nft_rule_expr_alloc("payload");
+	if (expr == NULL)
+		return;
+
+	nft_rule_expr_set_u32(expr, NFT_EXPR_PAYLOAD_BASE,
+			      NFT_PAYLOAD_NETWORK_HEADER);
+	nft_rule_expr_set_u32(expr, NFT_EXPR_PAYLOAD_DREG, NFT_REG_1);
+	nft_rule_expr_set_u32(expr, NFT_EXPR_PAYLOAD_OFFSET, offset);
+	nft_rule_expr_set_u32(expr, NFT_EXPR_PAYLOAD_LEN, len);
+
+	nft_rule_add_expr(r, expr);
+}
+
+/* bitwise operation is = sreg & mask ^ xor */
+void add_bitwise_u16(struct nft_rule *r, int mask, int xor)
+{
+	struct nft_rule_expr *expr;
+
+	expr = nft_rule_expr_alloc("bitwise");
+	if (expr == NULL)
+		return;
+
+	nft_rule_expr_set_u32(expr, NFT_EXPR_BITWISE_SREG, NFT_REG_1);
+	nft_rule_expr_set_u32(expr, NFT_EXPR_BITWISE_DREG, NFT_REG_1);
+	nft_rule_expr_set_u32(expr, NFT_EXPR_BITWISE_LEN, sizeof(uint16_t));
+	nft_rule_expr_set(expr, NFT_EXPR_BITWISE_MASK, &mask, sizeof(uint16_t));
+	nft_rule_expr_set(expr, NFT_EXPR_BITWISE_XOR, &xor, sizeof(uint16_t));
+
+	nft_rule_add_expr(r, expr);
+}
+
+void add_cmp_ptr(struct nft_rule *r, uint32_t op, void *data, size_t len)
+{
+	struct nft_rule_expr *expr;
+
+	expr = nft_rule_expr_alloc("cmp");
+	if (expr == NULL)
+		return;
+
+	nft_rule_expr_set_u8(expr, NFT_EXPR_CMP_SREG, NFT_REG_1);
+	nft_rule_expr_set_u8(expr, NFT_EXPR_CMP_OP, op);
+	nft_rule_expr_set(expr, NFT_EXPR_CMP_DATA, data, len);
+
+	nft_rule_add_expr(r, expr);
+}
+
+void add_cmp_u16(struct nft_rule *r, uint16_t val, uint32_t op)
+{
+	add_cmp_ptr(r, op, &val, sizeof(val));
+}
+
+void add_cmp_u32(struct nft_rule *r, uint32_t val, uint32_t op)
+{
+	add_cmp_ptr(r, op, &val, sizeof(val));
+}
+
+void add_iniface(struct nft_rule *r, char *iface, int invflags)
+{
+	int iface_len;
+	uint32_t op;
+
+	iface_len = strlen(iface);
+
+	if (invflags & IPT_INV_VIA_IN)
+		op = NFT_CMP_NEQ;
+	else
+		op = NFT_CMP_EQ;
+
+	if (iface[iface_len - 1] == '+') {
+		add_meta(r, NFT_META_IIFNAME);
+		add_cmp_ptr(r, op, iface, iface_len - 1);
+	} else {
+		add_meta(r, NFT_META_IIF);
+		add_cmp_u32(r, if_nametoindex(iface), op);
+	}
+}
+
+void add_outiface(struct nft_rule *r, char *iface, int invflags)
+{
+	int iface_len;
+	uint32_t op;
+
+	iface_len = strlen(iface);
+
+	if (invflags & IPT_INV_VIA_OUT)
+		op = NFT_CMP_NEQ;
+	else
+		op = NFT_CMP_EQ;
+
+	if (iface[iface_len - 1] == '+') {
+		add_meta(r, NFT_META_OIFNAME);
+		add_cmp_ptr(r, op, iface, iface_len - 1);
+	} else {
+		add_meta(r, NFT_META_OIF);
+		add_cmp_u32(r, if_nametoindex(iface), op);
+	}
+}
+
+void add_addr(struct nft_rule *r, int offset,
+	      void *data, size_t len, int invflags)
+{
+	uint32_t op;
+
+	add_payload(r, offset, len);
+
+	if (invflags & IPT_INV_SRCIP || invflags & IPT_INV_DSTIP)
+		op = NFT_CMP_NEQ;
+	else
+		op = NFT_CMP_EQ;
+
+	add_cmp_ptr(r, op, data, len);
+}
+
+void add_proto(struct nft_rule *r, int offset, size_t len,
+	       uint32_t proto, int invflags)
+{
+	uint32_t op;
+
+	add_payload(r, offset, len);
+
+	if (invflags & XT_INV_PROTO)
+		op = NFT_CMP_NEQ;
+	else
+		op = NFT_CMP_EQ;
+
+	add_cmp_u32(r, proto, op);
+}
+
+bool is_same_interfaces(const char *a_iniface, const char *a_outiface,
+			unsigned const char *a_iniface_mask,
+			unsigned const char *a_outiface_mask,
+			const char *b_iniface, const char *b_outiface,
+			unsigned const char *b_iniface_mask,
+			unsigned const char *b_outiface_mask)
+{
+	int i;
+
+	for (i = 0; i < IFNAMSIZ; i++) {
+		if (a_iniface_mask[i] != b_iniface_mask[i]) {
+			DEBUGP("different iniface mask %x, %x (%d)\n",
+			a_iniface_mask[i] & 0xff, b_iniface_mask[i] & 0xff, i);
+			return false;
+		}
+		if ((a_iniface[i] & a_iniface_mask[i])
+		    != (b_iniface[i] & b_iniface_mask[i])) {
+			DEBUGP("different iniface\n");
+			return false;
+		}
+		if (a_outiface_mask[i] != b_outiface_mask[i]) {
+			DEBUGP("different outiface mask\n");
+			return false;
+		}
+		if ((a_outiface[i] & a_outiface_mask[i])
+		    != (b_outiface[i] & b_outiface_mask[i])) {
+			DEBUGP("different outiface\n");
+			return false;
+		}
+	}
+
+	return true;
+}
+
+void parse_meta(struct nft_rule_expr *e, uint8_t key, char *iniface,
+		unsigned char *iniface_mask, char *outiface,
+		unsigned char *outiface_mask, uint8_t *invflags)
+{
+	uint32_t value;
+	const void *ifname;
+	size_t len;
+
+	switch(key) {
+	case NFT_META_IIF:
+		value = nft_rule_expr_get_u32(e, NFT_EXPR_CMP_DATA);
+		if (nft_rule_expr_get_u8(e, NFT_EXPR_CMP_OP) == NFT_CMP_NEQ)
+			*invflags |= IPT_INV_VIA_IN;
+
+		if_indextoname(value, iniface);
+
+		memset(iniface_mask, 0xff, strlen(iniface)+1);
+		break;
+	case NFT_META_OIF:
+		value = nft_rule_expr_get_u32(e, NFT_EXPR_CMP_DATA);
+		if (nft_rule_expr_get_u8(e, NFT_EXPR_CMP_OP) == NFT_CMP_NEQ)
+			*invflags |= IPT_INV_VIA_OUT;
+
+		if_indextoname(value, outiface);
+
+		memset(outiface_mask, 0xff, strlen(outiface)+1);
+		break;
+	case NFT_META_IIFNAME:
+		ifname = nft_rule_expr_get(e, NFT_EXPR_CMP_DATA, &len);
+		if (nft_rule_expr_get_u8(e, NFT_EXPR_CMP_OP) == NFT_CMP_NEQ)
+			*invflags |= IPT_INV_VIA_IN;
+
+		memcpy(iniface, ifname, len);
+		iniface[len] = '\0';
+
+		/* If zero, then this is an interface mask */
+		if (if_nametoindex(iniface) == 0) {
+			iniface[len] = '+';
+			iniface[len+1] = '\0';
+		}
+
+		memset(iniface_mask, 0xff, len);
+		break;
+	case NFT_META_OIFNAME:
+		ifname = nft_rule_expr_get(e, NFT_EXPR_CMP_DATA, &len);
+		if (nft_rule_expr_get_u8(e, NFT_EXPR_CMP_OP) == NFT_CMP_NEQ)
+			*invflags |= IPT_INV_VIA_OUT;
+
+		memcpy(outiface, ifname, len);
+		outiface[len] = '\0';
+
+		/* If zero, then this is an interface mask */
+		if (if_nametoindex(outiface) == 0) {
+			outiface[len] = '+';
+			outiface[len+1] = '\0';
+		}
+
+		memset(outiface_mask, 0xff, len);
+		break;
+	default:
+		DEBUGP("unknown meta key %d\n", key);
+		break;
+	}
+}
+
+void print_proto(uint16_t proto, int invert)
+{
+	const struct protoent *pent = getprotobynumber(proto);
+
+	if (invert)
+		printf("! ");
+
+	if (pent) {
+		printf("-p %s ", pent->p_name);
+		return;
+	}
+
+	printf("-p %u ", proto);
+}
+
+void get_cmp_data(struct nft_rule_expr_iter *iter,
+		  void *data, size_t dlen, bool *inv)
+{
+	struct nft_rule_expr *e;
+	const char *name;
+	size_t len;
+	uint8_t op;
+
+	e = nft_rule_expr_iter_next(iter);
+	if (e == NULL)
+		return;
+
+	name = nft_rule_expr_get_str(e, NFT_RULE_EXPR_ATTR_NAME);
+	if (strcmp(name, "cmp") != 0) {
+		DEBUGP("skipping no cmp after meta\n");
+		return;
+	}
+
+	memcpy(data, nft_rule_expr_get(e, NFT_EXPR_CMP_DATA, &len), dlen);
+	op = nft_rule_expr_get_u8(e, NFT_EXPR_CMP_OP);
+	if (op == NFT_CMP_NEQ)
+		*inv = true;
+	else
+		*inv = false;
+}
+
+void print_num(uint64_t number, unsigned int format)
+{
+	if (format & FMT_KILOMEGAGIGA) {
+		if (number > 99999) {
+			number = (number + 500) / 1000;
+			if (number > 9999) {
+				number = (number + 500) / 1000;
+				if (number > 9999) {
+					number = (number + 500) / 1000;
+					if (number > 9999) {
+						number = (number + 500) / 1000;
+						printf(FMT("%4lluT ","%lluT "), (unsigned long long)number);
+					}
+					else printf(FMT("%4lluG ","%lluG "), (unsigned long long)number);
+				}
+				else printf(FMT("%4lluM ","%lluM "), (unsigned long long)number);
+			} else
+				printf(FMT("%4lluK ","%lluK "), (unsigned long long)number);
+		} else
+			printf(FMT("%5llu ","%llu "), (unsigned long long)number);
+	} else
+		printf(FMT("%8llu ","%llu "), (unsigned long long)number);
+}
+
+void print_firewall_details(const struct iptables_command_state *cs,
+			    const char *targname, uint8_t flags,
+			    uint8_t invflags, uint8_t proto,
+			    const char *iniface, const char *outiface,
+			    unsigned int num, unsigned int format)
+{
+	if (format & FMT_LINENUMBERS)
+		printf(FMT("%-4u ", "%u "), num);
+
+	if (!(format & FMT_NOCOUNTS)) {
+		print_num(cs->counters.pcnt, format);
+		print_num(cs->counters.bcnt, format);
+	}
+
+	if (!(format & FMT_NOTARGET))
+		printf(FMT("%-9s ", "%s "), targname ? targname : "");
+
+	fputc(invflags & XT_INV_PROTO ? '!' : ' ', stdout);
+	{
+		const char *pname =
+			proto_to_name(proto, format&FMT_NUMERIC);
+		if (pname)
+			printf(FMT("%-5s", "%s "), pname);
+		else
+			printf(FMT("%-5hu", "%hu "), proto);
+	}
+
+	if (format & FMT_OPTIONS) {
+		if (format & FMT_NOTABLE)
+			fputs("opt ", stdout);
+		fputc(invflags & IPT_INV_FRAG ? '!' : '-', stdout);
+		fputc(flags & IPT_F_FRAG ? 'f' : '-', stdout);
+		fputc(' ', stdout);
+	}
+
+	if (format & FMT_VIA) {
+		char iface[IFNAMSIZ+2];
+		if (invflags & IPT_INV_VIA_IN) {
+			iface[0] = '!';
+			iface[1] = '\0';
+		}
+		else iface[0] = '\0';
+
+		if (iniface[0] != '\0') {
+			strcat(iface, iniface);
+		}
+		else if (format & FMT_NUMERIC) strcat(iface, "*");
+		else strcat(iface, "any");
+		printf(FMT(" %-6s ","in %s "), iface);
+
+		if (invflags & IPT_INV_VIA_OUT) {
+			iface[0] = '!';
+			iface[1] = '\0';
+		}
+		else iface[0] = '\0';
+
+		if (outiface[0] != '\0') {
+			strcat(iface, outiface);
+		}
+		else if (format & FMT_NUMERIC) strcat(iface, "*");
+		else strcat(iface, "any");
+		printf(FMT("%-6s ","out %s "), iface);
+	}
+}
+
+struct nft_family_ops *nft_family_ops_lookup(int family)
+{
+	switch (family) {
+	case AF_INET:
+		return &nft_family_ops_ipv4;
+	case AF_INET6:
+		return &nft_family_ops_ipv6;
+	default:
+		break;
+	}
+
+	return NULL;
+}
+
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
new file mode 100644
index 0000000..4b2594f
--- /dev/null
+++ b/iptables/nft-shared.h
@@ -0,0 +1,110 @@
+/*
+ * Authors:
+ * 	(C) 2013 by Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
+ * 	(C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License as published by
+ *	the Free Software Foundation; either version 2 of the License, or
+ *	(at your option) any later version.
+ *
+ *	This program is distributed in the hope that it will be useful,
+ *	but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *	GNU General Public License for more details.
+ *
+ *	You should have received a copy of the GNU General Public License
+ *	along with this program; if not, write to the Free Software
+ *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef _NFT_SHARED_H_
+#define _NFT_SHARED_H_
+
+#include <stdbool.h>
+
+#include <libnftables/rule.h>
+#include <libnftables/expr.h>
+
+#include "xshared.h"
+
+#if 0
+#define DEBUGP(x, args...) fprintf(stdout, x, ## args)
+#define NLDEBUG
+#define DEBUG_DEL
+#else
+#define DEBUGP(x, args...)
+#endif
+
+/*
+ * iptables print output emulation
+ */
+
+#define FMT_NUMERIC	0x0001
+#define FMT_NOCOUNTS	0x0002
+#define FMT_KILOMEGAGIGA 0x0004
+#define FMT_OPTIONS	0x0008
+#define FMT_NOTABLE	0x0010
+#define FMT_NOTARGET	0x0020
+#define FMT_VIA		0x0040
+#define FMT_NONEWLINE	0x0080
+#define FMT_LINENUMBERS 0x0100
+
+#define FMT_PRINT_RULE (FMT_NOCOUNTS | FMT_OPTIONS | FMT_VIA \
+			| FMT_NUMERIC | FMT_NOTABLE)
+#define FMT(tab,notab) ((format) & FMT_NOTABLE ? (notab) : (tab))
+
+struct nft_family_ops {
+	int (*add)(struct nft_rule *r, struct iptables_command_state *cs);
+	bool (*is_same)(const struct iptables_command_state *a,
+			const struct iptables_command_state *b);
+	void (*print_payload)(struct nft_rule_expr *e,
+			      struct nft_rule_expr_iter *iter);
+	void (*parse_meta)(struct nft_rule_expr *e, uint8_t key,
+			   struct iptables_command_state *cs);
+	void (*parse_payload)(struct nft_rule_expr_iter *iter,
+			      struct iptables_command_state *cs,
+			      uint32_t offset);
+	void (*parse_immediate)(struct iptables_command_state *cs);
+	uint8_t (*print_firewall)(const struct iptables_command_state *cs,
+				  const char *targname, unsigned int num,
+				  unsigned int format);
+};
+
+void add_meta(struct nft_rule *r, uint32_t key);
+void add_payload(struct nft_rule *r, int offset, int len);
+void add_bitwise_u16(struct nft_rule *r, int mask, int xor);
+void add_cmp_ptr(struct nft_rule *r, uint32_t op, void *data, size_t len);
+void add_cmp_u16(struct nft_rule *r, uint16_t val, uint32_t op);
+void add_cmp_u32(struct nft_rule *r, uint32_t val, uint32_t op);
+void add_iniface(struct nft_rule *r, char *iface, int invflags);
+void add_outiface(struct nft_rule *r, char *iface, int invflags);
+void add_addr(struct nft_rule *r, int offset,
+	      void *data, size_t len, int invflags);
+void add_proto(struct nft_rule *r, int offset, size_t len,
+	       uint32_t proto, int invflags);
+
+bool is_same_interfaces(const char *a_iniface, const char *a_outiface,
+			unsigned const char *a_iniface_mask,
+			unsigned const char *a_outiface_mask,
+			const char *b_iniface, const char *b_outiface,
+			unsigned const char *b_iniface_mask,
+			unsigned const char *b_outiface_mask);
+
+void parse_meta(struct nft_rule_expr *e, uint8_t key, char *iniface,
+		unsigned char *iniface_mask, char *outiface,
+		unsigned char *outiface_mask, uint8_t *invflags);
+
+void print_proto(uint16_t proto, int invert);
+void get_cmp_data(struct nft_rule_expr_iter *iter,
+		  void *data, size_t dlen, bool *inv);
+void print_num(uint64_t number, unsigned int format);
+void print_firewall_details(const struct iptables_command_state *cs,
+			    const char *targname, uint8_t flags,
+			    uint8_t invflags, uint8_t proto,
+			    const char *iniface, const char *outiface,
+			    unsigned int num, unsigned int format);
+
+struct nft_family_ops *nft_family_ops_lookup(int family);
+
+#endif
diff --git a/iptables/nft.c b/iptables/nft.c
index 29072e5..5a93294 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -9,14 +9,6 @@
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
-#if 0
-#define DEBUGP(x, args...) fprintf(stdout, x, ## args)
-#define NLDEBUG
-#define DEBUG_DEL
-#else
-#define DEBUGP(x, args...)
-#endif
-
 #include <unistd.h>
 #include <fcntl.h>
 #include <sys/types.h>
@@ -54,6 +46,7 @@
 
 #include "nft.h"
 #include "xshared.h" /* proto_to_name */
+#include "nft-shared.h"
 
 static void *nft_fn;
 
@@ -655,80 +648,6 @@ static void nft_rule_print_debug(struct nft_rule *r, struct nlmsghdr *nlh)
 #endif
 }
 
-static void add_meta(struct nft_rule *r, uint32_t key)
-{
-	struct nft_rule_expr *expr;
-
-	expr = nft_rule_expr_alloc("meta");
-	if (expr == NULL)
-		return;
-
-	nft_rule_expr_set_u32(expr, NFT_EXPR_META_KEY, key);
-	nft_rule_expr_set_u32(expr, NFT_EXPR_META_DREG, NFT_REG_1);
-
-	nft_rule_add_expr(r, expr);
-}
-
-static void add_payload(struct nft_rule *r, int offset, int len)
-{
-	struct nft_rule_expr *expr;
-
-	expr = nft_rule_expr_alloc("payload");
-	if (expr == NULL)
-		return;
-
-	nft_rule_expr_set_u32(expr, NFT_EXPR_PAYLOAD_BASE,
-				NFT_PAYLOAD_NETWORK_HEADER);
-	nft_rule_expr_set_u32(expr, NFT_EXPR_PAYLOAD_DREG, NFT_REG_1);
-	nft_rule_expr_set_u32(expr, NFT_EXPR_PAYLOAD_OFFSET, offset);
-	nft_rule_expr_set_u32(expr, NFT_EXPR_PAYLOAD_LEN, len);
-
-	nft_rule_add_expr(r, expr);
-}
-
-/* bitwise operation is = sreg & mask ^ xor */
-static void add_bitwise_u16(struct nft_rule *r, int mask, int xor)
-{
-	struct nft_rule_expr *expr;
-
-	expr = nft_rule_expr_alloc("bitwise");
-	if (expr == NULL)
-		return;
-
-	nft_rule_expr_set_u32(expr, NFT_EXPR_BITWISE_SREG, NFT_REG_1);
-	nft_rule_expr_set_u32(expr, NFT_EXPR_BITWISE_DREG, NFT_REG_1);
-	nft_rule_expr_set_u32(expr, NFT_EXPR_BITWISE_LEN, sizeof(uint16_t));
-	nft_rule_expr_set(expr, NFT_EXPR_BITWISE_MASK, &mask, sizeof(uint16_t));
-	nft_rule_expr_set(expr, NFT_EXPR_BITWISE_XOR, &xor, sizeof(uint16_t));
-
-	nft_rule_add_expr(r, expr);
-}
-
-static void add_cmp_ptr(struct nft_rule *r, uint32_t op, void *data, size_t len)
-{
-	struct nft_rule_expr *expr;
-
-	expr = nft_rule_expr_alloc("cmp");
-	if (expr == NULL)
-		return;
-
-	nft_rule_expr_set_u8(expr, NFT_EXPR_CMP_SREG, NFT_REG_1);
-	nft_rule_expr_set_u8(expr, NFT_EXPR_CMP_OP, op);
-	nft_rule_expr_set(expr, NFT_EXPR_CMP_DATA, data, len);
-
-	nft_rule_add_expr(r, expr);
-}
-
-static void add_cmp_u16(struct nft_rule *r, uint16_t val, uint32_t op)
-{
-	add_cmp_ptr(r, op, &val, sizeof(val));
-}
-
-static void add_cmp_u32(struct nft_rule *r, uint32_t val, uint32_t op)
-{
-	add_cmp_ptr(r, op, &val, sizeof(val));
-}
-
 static void add_counters(struct nft_rule *r, uint64_t packets, uint64_t bytes)
 {
 	struct nft_rule_expr *expr;
@@ -743,78 +662,6 @@ static void add_counters(struct nft_rule *r, uint64_t packets, uint64_t bytes)
 	nft_rule_add_expr(r, expr);
 }
 
-static void add_iniface(struct nft_rule *r, char *iface, int invflags)
-{
-	int iface_len;
-	uint32_t op;
-
-	iface_len = strlen(iface);
-
-	if (invflags & IPT_INV_VIA_IN)
-		op = NFT_CMP_NEQ;
-	else
-		op = NFT_CMP_EQ;
-
-	if (iface[iface_len - 1] == '+') {
-		add_meta(r, NFT_META_IIFNAME);
-		add_cmp_ptr(r, op, iface, iface_len - 1);
-	} else {
-		add_meta(r, NFT_META_IIF);
-		add_cmp_u32(r, if_nametoindex(iface), op);
-	}
-}
-
-static void add_outiface(struct nft_rule *r, char *iface, int invflags)
-{
-	int iface_len;
-	uint32_t op;
-
-	iface_len = strlen(iface);
-
-	if (invflags & IPT_INV_VIA_OUT)
-		op = NFT_CMP_NEQ;
-	else
-		op = NFT_CMP_EQ;
-
-	if (iface[iface_len - 1] == '+') {
-		add_meta(r, NFT_META_OIFNAME);
-		add_cmp_ptr(r, op, iface, iface_len - 1);
-	} else {
-		add_meta(r, NFT_META_OIF);
-		add_cmp_u32(r, if_nametoindex(iface), op);
-	}
-}
-
-static void add_addr(struct nft_rule *r, int offset,
-			void *data, size_t len, int invflags)
-{
-	uint32_t op;
-
-	add_payload(r, offset, len);
-
-	if (invflags & IPT_INV_SRCIP || invflags & IPT_INV_DSTIP)
-		op = NFT_CMP_NEQ;
-	else
-		op = NFT_CMP_EQ;
-
-	add_cmp_ptr(r, op, data, len);
-}
-
-static void add_proto(struct nft_rule *r, int offset, size_t len,
-		      uint32_t proto, int invflags)
-{
-	uint32_t op;
-
-	add_payload(r, offset, len);
-
-	if (invflags & XT_INV_PROTO)
-		op = NFT_CMP_NEQ;
-	else
-		op = NFT_CMP_EQ;
-
-	add_cmp_u32(r, proto, op);
-}
-
 int
 nft_rule_add(struct nft_handle *h, const char *chain, const char *table,
 	     struct iptables_command_state *cs,
@@ -825,7 +672,6 @@ nft_rule_add(struct nft_handle *h, const char *chain, const char *table,
 	struct xtables_rule_match *matchp;
 	struct nft_rule *r;
 	int ret = 1;
-	uint32_t op;
 	int flags = append ? NLM_F_APPEND : 0;
 	int ip_flags = 0;
 
@@ -843,73 +689,7 @@ nft_rule_add(struct nft_handle *h, const char *chain, const char *table,
 	nft_rule_attr_set(r, NFT_RULE_ATTR_TABLE, (char *)table);
 	nft_rule_attr_set(r, NFT_RULE_ATTR_CHAIN, (char *)chain);
 
-	switch (h->family) {
-	case AF_INET:
-		if (cs->fw.ip.iniface[0] != '\0')
-			add_iniface(r, cs->fw.ip.iniface, cs->fw.ip.invflags);
-
-		if (cs->fw.ip.outiface[0] != '\0')
-			add_outiface(r, cs->fw.ip.outiface,
-				     cs->fw.ip.invflags);
-
-		if (cs->fw.ip.src.s_addr != 0)
-			add_addr(r, offsetof(struct iphdr, saddr),
-				 &cs->fw.ip.src.s_addr, 4,
-				 cs->fw.ip.invflags);
-
-		if (cs->fw.ip.dst.s_addr != 0)
-			add_addr(r, offsetof(struct iphdr, daddr),
-				 &cs->fw.ip.dst.s_addr, 4,
-				 cs->fw.ip.invflags);
-
-		if (cs->fw.ip.proto != 0)
-			add_proto(r, offsetof(struct iphdr, protocol), 1,
-				  cs->fw.ip.proto, cs->fw.ip.invflags);
-
-		if (cs->fw.ip.flags & IPT_F_FRAG) {
-			add_payload(r, offsetof(struct iphdr, frag_off), 2);
-			/* get the 13 bits that contain the fragment offset */
-			add_bitwise_u16(r, 0x1fff, !0x1fff);
-
-			/* if offset is non-zero, this is a fragment */
-			if (cs->fw.ip.invflags & IPT_INV_FRAG)
-				op = NFT_CMP_EQ;
-			else
-				op = NFT_CMP_NEQ;
-
-			add_cmp_u16(r, 0, op);
-		}
-
-		ip_flags = cs->fw.ip.flags;
-
-		break;
-	case AF_INET6:
-		if (cs->fw6.ipv6.iniface[0] != '\0')
-			add_iniface(r, cs->fw6.ipv6.iniface,
-				    cs->fw6.ipv6.invflags);
-
-		if (cs->fw6.ipv6.outiface[0] != '\0')
-			add_outiface(r, cs->fw6.ipv6.outiface,
-				    cs->fw6.ipv6.invflags);
-
-		if (!IN6_IS_ADDR_UNSPECIFIED(&cs->fw6.ipv6.src))
-			add_addr(r, offsetof(struct ip6_hdr, ip6_src),
-				 &cs->fw6.ipv6.src, 16,
-				 cs->fw6.ipv6.invflags);
-
-		if (!IN6_IS_ADDR_UNSPECIFIED(&cs->fw6.ipv6.dst))
-			add_addr(r, offsetof(struct ip6_hdr, ip6_dst),
-				 &cs->fw6.ipv6.dst, 16,
-				 cs->fw6.ipv6.invflags);
-
-		if (cs->fw6.ipv6.proto != 0)
-			add_proto(r, offsetof(struct ip6_hdr, ip6_nxt), 1,
-				  cs->fw6.ipv6.proto, cs->fw6.ipv6.invflags);
-
-		ip_flags = cs->fw6.ipv6.flags;
-
-		break;
-	}
+	ip_flags = h->ops->add(r, cs);
 
 	for (matchp = cs->matches; matchp; matchp = matchp->next)
 		add_match(r, matchp->match->m);
@@ -1158,203 +938,6 @@ nft_print_meta(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter)
 }
 
 static void
-get_cmp_data(struct nft_rule_expr_iter *iter, void *data, size_t dlen, bool *inv)
-{
-	struct nft_rule_expr *e;
-	const char *name;
-	size_t len;
-	uint8_t op;
-
-	e = nft_rule_expr_iter_next(iter);
-	if (e == NULL)
-		return;
-
-	name = nft_rule_expr_get_str(e, NFT_RULE_EXPR_ATTR_NAME);
-	if (strcmp(name, "cmp") != 0) {
-		DEBUGP("skipping no cmp after meta\n");
-		return;
-	}
-
-	memcpy(data, nft_rule_expr_get(e, NFT_EXPR_CMP_DATA, &len), dlen);
-	op = nft_rule_expr_get_u8(e, NFT_EXPR_CMP_OP);
-	if (op == NFT_CMP_NEQ)
-		*inv = true;
-	else
-		*inv = false;
-}
-
-static void get_frag(struct nft_rule_expr_iter *iter, bool *inv)
-{
-	struct nft_rule_expr *e;
-	const char *name;
-	uint8_t op;
-
-	e = nft_rule_expr_iter_next(iter);
-	if (e == NULL)
-		return;
-
-	/* we assume correct mask and xor */
-	name = nft_rule_expr_get_str(e, NFT_RULE_EXPR_ATTR_NAME);
-	if (strcmp(name, "bitwise") != 0) {
-		DEBUGP("skipping no bitwise after payload\n");
-		return;
-	}
-
-	/* Now check for cmp */
-	e = nft_rule_expr_iter_next(iter);
-	if (e == NULL)
-		return;
-
-	/* we assume correct data */
-	name = nft_rule_expr_get_str(e, NFT_RULE_EXPR_ATTR_NAME);
-	if (strcmp(name, "cmp") != 0) {
-		DEBUGP("skipping no cmp after payload\n");
-		return;
-	}
-
-	op = nft_rule_expr_get_u8(e, NFT_EXPR_CMP_OP);
-	if (op == NFT_CMP_EQ)
-		*inv = true;
-	else
-		*inv = false;
-}
-
-static void print_frag(bool inv)
-{
-	if (inv)
-		printf("! -f ");
-	else
-		printf("-f ");
-}
-
-static void print_proto(uint16_t proto, int invert)
-{
-	const struct protoent *pent = getprotobynumber(proto);
-
-	if (invert)
-		printf("! ");
-
-	if (pent) {
-		printf("-p %s ", pent->p_name);
-		return;
-	}
-
-	printf("-p %u ", proto);
-}
-
-static const char *mask_to_str(uint32_t mask)
-{
-	static char mask_str[sizeof("255.255.255.255")];
-	uint32_t bits, hmask = ntohl(mask);
-	struct in_addr mask_addr = {
-		.s_addr = mask,
-	};
-	int i;
-
-	if (mask == 0xFFFFFFFFU) {
-		sprintf(mask_str, "32");
-		return mask_str;
-	}
-
-	i    = 32;
-	bits = 0xFFFFFFFEU;
-	while (--i >= 0 && hmask != bits)
-		bits <<= 1;
-	if (i >= 0)
-		sprintf(mask_str, "%u", i);
-	else
-		sprintf(mask_str, "%s", inet_ntoa(mask_addr));
-
-	return mask_str;
-}
-
-static void
-nft_print_payload_ipv4(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter)
-{
-	uint32_t offset;
-	bool inv;
-
-	offset = nft_rule_expr_get_u32(e, NFT_EXPR_PAYLOAD_OFFSET);
-
-	switch(offset) {
-	struct in_addr addr;
-	uint8_t proto;
-
-	case offsetof(struct iphdr, saddr):
-		get_cmp_data(iter, &addr, sizeof(addr), &inv);
-		if (inv)
-			printf("! -s %s/%s ", inet_ntoa(addr),
-						mask_to_str(0xffffffff));
-		else
-			printf("-s %s/%s ", inet_ntoa(addr),
-						mask_to_str(0xffffffff));
-		break;
-	case offsetof(struct iphdr, daddr):
-		get_cmp_data(iter, &addr, sizeof(addr), &inv);
-		if (inv)
-			printf("! -d %s/%s ", inet_ntoa(addr),
-						mask_to_str(0xffffffff));
-		else
-			printf("-d %s/%s ", inet_ntoa(addr),
-						mask_to_str(0xffffffff));
-		break;
-	case offsetof(struct iphdr, protocol):
-		get_cmp_data(iter, &proto, sizeof(proto), &inv);
-		print_proto(proto, inv);
-		break;
-	case offsetof(struct iphdr, frag_off):
-		get_frag(iter, &inv);
-		print_frag(inv);
-		break;
-	default:
-		DEBUGP("unknown payload offset %d\n", offset);
-		break;
-	}
-}
-
-static void
-nft_print_payload_ipv6(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter)
-{
-	uint32_t offset;
-	bool inv;
-
-	offset = nft_rule_expr_get_u32(e, NFT_EXPR_PAYLOAD_OFFSET);
-
-	switch (offset) {
-	char addr_str[INET6_ADDRSTRLEN];
-	struct in6_addr addr;
-	uint8_t proto;
-	case offsetof(struct ip6_hdr, ip6_src):
-		get_cmp_data(iter, &addr, sizeof(addr), &inv);
-		inet_ntop(AF_INET6, &addr, addr_str, INET6_ADDRSTRLEN);
-
-		if (inv)
-			printf("! -s %s ", addr_str);
-		else
-			printf("-s %s ", addr_str);
-
-		break;
-	case offsetof(struct ip6_hdr, ip6_dst):
-		get_cmp_data(iter, &addr, sizeof(addr), &inv);
-		inet_ntop(AF_INET6, &addr, addr_str, INET6_ADDRSTRLEN);
-
-		if (inv)
-			printf("! -d %s ", addr_str);
-		else
-			printf("-d %s ", addr_str);
-
-		break;
-	case offsetof(struct ip6_hdr, ip6_nxt):
-		get_cmp_data(iter, &proto, sizeof(proto), &inv);
-		print_proto(proto, inv);
-		break;
-	default:
-		DEBUGP("unknown payload offset %d\n", offset);
-		break;
-	}
-}
-
-static void
 nft_print_counters(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
 		   bool counters)
 {
@@ -1385,10 +968,9 @@ static void nft_rule_print_save(struct nft_rule *r, bool counters)
 		if (strcmp(name, "counter") == 0) {
 			nft_print_counters(expr, iter, counters);
 		} else if (strcmp(name, "payload") == 0) {
-			if (nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY) == AF_INET)
-				nft_print_payload_ipv4(expr, iter);
-			else
-				nft_print_payload_ipv6(expr, iter);
+			struct nft_family_ops *ops = nft_family_ops_lookup(
+				nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY));
+			ops->print_payload(expr, iter);
 		} else if (strcmp(name, "meta") == 0) {
 			nft_print_meta(expr, iter);
 		} else if (strcmp(name, "match") == 0) {
@@ -2072,107 +1654,13 @@ match_different(const struct xt_entry_match *a,
 	return 0;
 }
 
-static bool
-is_same(int family, const struct iptables_command_state *a,
-	const struct iptables_command_state *b)
-{
-	unsigned int i;
-	const char *a_outiface, *a_iniface;
-	unsigned const char *a_iniface_mask, *a_outiface_mask;
-	const char *b_outiface, *b_iniface;
-	unsigned const char *b_iniface_mask, *b_outiface_mask;
-
-	/* Always compare head structures: ignore mask here. */
-	switch (family) {
-	case AF_INET:
-		if (a->fw.ip.src.s_addr != b->fw.ip.src.s_addr
-		    || a->fw.ip.dst.s_addr != b->fw.ip.dst.s_addr
-		    || a->fw.ip.smsk.s_addr != b->fw.ip.smsk.s_addr
-		    || a->fw.ip.dmsk.s_addr != b->fw.ip.dmsk.s_addr
-		    || a->fw.ip.proto != b->fw.ip.proto
-		    || a->fw.ip.flags != b->fw.ip.flags
-		    || a->fw.ip.invflags != b->fw.ip.invflags) {
-			DEBUGP("different src/dst/proto/flags/invflags\n");
-			return false;
-		}
-
-		a_iniface_mask = a->fw.ip.iniface_mask;
-		a_iniface = a->fw.ip.iniface;
-		a_outiface_mask = a->fw.ip.outiface_mask;
-		a_outiface = a->fw.ip.outiface;
-
-		b_iniface_mask = b->fw.ip.iniface_mask;
-		b_iniface = b->fw.ip.iniface;
-		b_outiface_mask = b->fw.ip.outiface_mask;
-		b_outiface = b->fw.ip.outiface;
-
-		break;
-	case AF_INET6:
-		if (memcmp(a->fw6.ipv6.src.s6_addr,
-			   b->fw6.ipv6.src.s6_addr,
-			   sizeof(struct in6_addr)) != 0	||
-		    memcmp(a->fw6.ipv6.dst.s6_addr,
-			   b->fw6.ipv6.dst.s6_addr,
-			   sizeof(struct in6_addr)) != 0	||
-		    a->fw6.ipv6.proto != b->fw6.ipv6.proto	||
-		    a->fw6.ipv6.flags != b->fw6.ipv6.flags	||
-		    a->fw6.ipv6.invflags != b->fw6.ipv6.invflags) {
-			DEBUGP("different src/dst/proto/flags/invflags\n");
-			return false;
-		}
-
-		a_iniface_mask = a->fw6.ipv6.iniface_mask;
-		a_iniface = a->fw6.ipv6.iniface;
-		a_outiface_mask = a->fw6.ipv6.outiface_mask;
-		a_outiface = a->fw6.ipv6.outiface;
-
-		b_iniface_mask = b->fw6.ipv6.iniface_mask;
-		b_iniface = b->fw6.ipv6.iniface;
-		b_outiface_mask = b->fw6.ipv6.outiface_mask;
-		b_outiface = b->fw6.ipv6.outiface;
-
-		break;
-	default:
-		return false;
-	}
-
-	for (i = 0; i < IFNAMSIZ; i++) {
-		if (a_iniface_mask[i] != b_iniface_mask[i]) {
-			DEBUGP("different iniface mask %x, %x (%d)\n",
-			a_iniface_mask[i] & 0xff, b_iniface_mask[i] & 0xff, i);
-			return false;
-		}
-		if ((a_iniface[i] & a_iniface_mask[i])
-		    != (b_iniface[i] & b_iniface_mask[i])) {
-			DEBUGP("different iniface\n");
-			return false;
-		}
-		if (a_outiface_mask[i] != b_outiface_mask[i]) {
-			DEBUGP("different outiface mask\n");
-			return false;
-		}
-		if ((a_outiface[i] & a_outiface_mask[i])
-		    != (b_outiface[i] & b_outiface_mask[i])) {
-			DEBUGP("different outiface\n");
-			return false;
-		}
-	}
-
-	return true;
-}
-
 static void
 nft_parse_meta(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
 	       int family, struct iptables_command_state *cs)
 {
 	uint8_t key = nft_rule_expr_get_u8(e, NFT_EXPR_META_KEY);
-	uint32_t value;
+	struct nft_family_ops *ops = nft_family_ops_lookup(family);
 	const char *name;
-	const void *ifname;
-	char *iniface, *outiface;
-	unsigned char *iniface_mask, *outiface_mask;
-	size_t len;
-	uint8_t *invflags;
 
 	e = nft_rule_expr_iter_next(iter);
 	if (e == NULL)
@@ -2184,171 +1672,19 @@ nft_parse_meta(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
 		return;
 	}
 
-	switch (family) {
-	case AF_INET:
-		iniface = cs->fw.ip.iniface;
-		outiface = cs->fw.ip.outiface;
-		iniface_mask = cs->fw.ip.iniface_mask;
-		outiface_mask = cs->fw.ip.outiface_mask;
-		invflags = &cs->fw.ip.invflags;
-		break;
-	case AF_INET6:
-		iniface = cs->fw6.ipv6.iniface;
-		outiface = cs->fw6.ipv6.outiface;
-		iniface_mask = cs->fw6.ipv6.iniface_mask;
-		outiface_mask = cs->fw6.ipv6.outiface_mask;
-		invflags = &cs->fw6.ipv6.invflags;
-		break;
-	default:
-		return;
-	}
-
-	switch(key) {
-	case NFT_META_IIF:
-		value = nft_rule_expr_get_u32(e, NFT_EXPR_CMP_DATA);
-		if (nft_rule_expr_get_u8(e, NFT_EXPR_CMP_OP) == NFT_CMP_NEQ)
-			*invflags |= IPT_INV_VIA_IN;
-
-		if_indextoname(value, iniface);
-
-		memset(iniface_mask, 0xff, strlen(iniface)+1);
-		break;
-	case NFT_META_OIF:
-		value = nft_rule_expr_get_u32(e, NFT_EXPR_CMP_DATA);
-		if (nft_rule_expr_get_u8(e, NFT_EXPR_CMP_OP) == NFT_CMP_NEQ)
-			*invflags |= IPT_INV_VIA_OUT;
-
-		if_indextoname(value, outiface);
-
-		memset(outiface_mask, 0xff, strlen(outiface)+1);
-		break;
-	case NFT_META_IIFNAME:
-		ifname = nft_rule_expr_get(e, NFT_EXPR_CMP_DATA, &len);
-		if (nft_rule_expr_get_u8(e, NFT_EXPR_CMP_OP) == NFT_CMP_NEQ)
-			*invflags |= IPT_INV_VIA_IN;
-
-		memcpy(iniface, ifname, len);
-		iniface[len] = '\0';
-
-		/* If zero, then this is an interface mask */
-		if (if_nametoindex(iniface) == 0) {
-			iniface[len] = '+';
-			iniface[len+1] = '\0';
-		}
-
-		memset(iniface_mask, 0xff, len);
-		break;
-	case NFT_META_OIFNAME:
-		ifname = nft_rule_expr_get(e, NFT_EXPR_CMP_DATA, &len);
-		if (nft_rule_expr_get_u8(e, NFT_EXPR_CMP_OP) == NFT_CMP_NEQ)
-			*invflags |= IPT_INV_VIA_OUT;
-
-		memcpy(outiface, ifname, len);
-		outiface[len] = '\0';
-
-		/* If zero, then this is an interface mask */
-		if (if_nametoindex(outiface) == 0) {
-			outiface[len] = '+';
-			outiface[len+1] = '\0';
-		}
-
-		memset(outiface_mask, 0xff, len);
-		break;
-	default:
-		DEBUGP("unknown meta key %d\n", key);
-		break;
-	}
-}
-
-static void
-nft_parse_payload_ipv4(uint32_t offset, struct nft_rule_expr_iter *iter,
-		       struct iptables_command_state *cs)
-{
-	switch(offset) {
-	struct in_addr addr;
-	uint8_t proto;
-	bool inv;
-
-	case offsetof(struct iphdr, saddr):
-		get_cmp_data(iter, &addr, sizeof(addr), &inv);
-		cs->fw.ip.src.s_addr = addr.s_addr;
-		cs->fw.ip.smsk.s_addr = 0xffffffff;
-		if (inv)
-			cs->fw.ip.invflags |= IPT_INV_SRCIP;
-		break;
-	case offsetof(struct iphdr, daddr):
-		get_cmp_data(iter, &addr, sizeof(addr), &inv);
-		cs->fw.ip.dst.s_addr = addr.s_addr;
-		cs->fw.ip.dmsk.s_addr = 0xffffffff;
-		if (inv)
-			cs->fw.ip.invflags |= IPT_INV_DSTIP;
-		break;
-	case offsetof(struct iphdr, protocol):
-		get_cmp_data(iter, &proto, sizeof(proto), &inv);
-		cs->fw.ip.proto = proto;
-		if (inv)
-			cs->fw.ip.invflags |= IPT_INV_PROTO;
-		break;
-	case offsetof(struct iphdr, frag_off):
-		cs->fw.ip.flags |= IPT_F_FRAG;
-		get_frag(iter, &inv);
-		if (inv)
-			cs->fw.ip.invflags |= IPT_INV_FRAG;
-		break;
-	default:
-		DEBUGP("unknown payload offset %d\n", offset);
-		break;
-	}
-}
-
-static void
-nft_parse_payload_ipv6(uint32_t offset, struct nft_rule_expr_iter *iter,
-		       struct iptables_command_state *cs)
-{
-	switch (offset) {
-	struct in6_addr addr;
-	uint8_t proto;
-	bool inv;
-
-	case offsetof(struct ip6_hdr, ip6_src):
-		get_cmp_data(iter, &addr, sizeof(addr), &inv);
-		memcpy(cs->fw6.ipv6.src.s6_addr, &addr, sizeof(addr));
-		if (inv)
-			cs->fw6.ipv6.invflags |= IPT_INV_SRCIP;
-		break;
-	case offsetof(struct ip6_hdr, ip6_dst):
-		get_cmp_data(iter, &addr, sizeof(addr), &inv);
-		memcpy(cs->fw6.ipv6.dst.s6_addr, &addr, sizeof(addr));
-		if (inv)
-			cs->fw6.ipv6.invflags |= IPT_INV_DSTIP;
-		break;
-	case offsetof(struct ip6_hdr, ip6_nxt):
-		get_cmp_data(iter, &proto, sizeof(proto), &inv);
-		cs->fw6.ipv6.proto = proto;
-		if (inv)
-			cs->fw6.ipv6.invflags |= IPT_INV_PROTO;
-	default:
-		DEBUGP("unknown payload offset %d\n", offset);
-		break;
-	}
+	ops->parse_meta(e, key, cs);
 }
 
 static void
 nft_parse_payload(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
 		  int family, struct iptables_command_state *cs)
 {
+	struct nft_family_ops *ops = nft_family_ops_lookup(family);
 	uint32_t offset;
 
 	offset = nft_rule_expr_get_u32(e, NFT_EXPR_PAYLOAD_OFFSET);
 
-	switch (family) {
-	case AF_INET:
-		nft_parse_payload_ipv4(offset, iter, cs);
-		break;
-	case AF_INET6:
-		nft_parse_payload_ipv6(offset, iter, cs);
-		break;
-	}
+	ops->parse_payload(iter, cs, offset);
 }
 
 static void
@@ -2365,6 +1701,7 @@ nft_parse_immediate(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
 {
 	int verdict = nft_rule_expr_get_u32(e, NFT_EXPR_IMM_VERDICT);
 	const char *chain = nft_rule_expr_get_str(e, NFT_EXPR_IMM_CHAIN);
+	struct nft_family_ops *ops;
 
 	/* Standard target? */
 	switch(verdict) {
@@ -2378,10 +1715,8 @@ nft_parse_immediate(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
 		cs->jumpto = "RETURN";
 		return;
 	case NFT_GOTO:
-		if (family == AF_INET)
-			cs->fw.ip.flags |= IPT_F_GOTO;
-		else
-			cs->fw6.ipv6.flags |= IPT_F_GOTO;
+		ops = nft_family_ops_lookup(family);
+		ops->parse_immediate(cs);
 	case NFT_JUMP:
 		cs->jumpto = chain;
 		return;
@@ -2669,6 +2004,8 @@ nft_rule_find(struct nft_rule_list *list, const char *chain, const char *table,
 			nft_rule_attr_get_str(r, NFT_RULE_ATTR_TABLE);
 		const char *rule_chain =
 			nft_rule_attr_get_str(r, NFT_RULE_ATTR_CHAIN);
+		const struct nft_family_ops *ops = nft_family_ops_lookup(
+				nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY));
 		struct iptables_command_state this = {};
 
 		if (strcmp(table, rule_table) != 0 ||
@@ -2692,7 +2029,7 @@ nft_rule_find(struct nft_rule_list *list, const char *chain, const char *table,
 
 			nft_rule_to_iptables_command_state(r, &this);
 
-			if (!is_same(nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY), cs, &this))
+			if (!ops->is_same(cs, &this))
 				goto next;
 
 			if (!find_matches(cs->matches, r)) {
@@ -2839,49 +2176,6 @@ int nft_rule_replace(struct nft_handle *h, const char *chain,
 	return ret;
 }
 
-/*
- * iptables print output emulation
- */
-
-#define FMT_NUMERIC	0x0001
-#define FMT_NOCOUNTS	0x0002
-#define FMT_KILOMEGAGIGA 0x0004
-#define FMT_OPTIONS	0x0008
-#define FMT_NOTABLE	0x0010
-#define FMT_NOTARGET	0x0020
-#define FMT_VIA		0x0040
-#define FMT_NONEWLINE	0x0080
-#define FMT_LINENUMBERS 0x0100
-
-#define FMT_PRINT_RULE (FMT_NOCOUNTS | FMT_OPTIONS | FMT_VIA \
-			| FMT_NUMERIC | FMT_NOTABLE)
-#define FMT(tab,notab) ((format) & FMT_NOTABLE ? (notab) : (tab))
-
-static void
-print_num(uint64_t number, unsigned int format)
-{
-	if (format & FMT_KILOMEGAGIGA) {
-		if (number > 99999) {
-			number = (number + 500) / 1000;
-			if (number > 9999) {
-				number = (number + 500) / 1000;
-				if (number > 9999) {
-					number = (number + 500) / 1000;
-					if (number > 9999) {
-						number = (number + 500) / 1000;
-						printf(FMT("%4lluT ","%lluT "), (unsigned long long)number);
-					}
-					else printf(FMT("%4lluG ","%lluG "), (unsigned long long)number);
-				}
-				else printf(FMT("%4lluM ","%lluM "), (unsigned long long)number);
-			} else
-				printf(FMT("%4lluK ","%lluK "), (unsigned long long)number);
-		} else
-			printf(FMT("%5llu ","%llu "), (unsigned long long)number);
-	} else
-		printf(FMT("%8llu ","%llu "), (unsigned long long)number);
-}
-
 static void
 print_header(unsigned int format, const char *chain, const char *pol,
 	     const struct xt_counters *counters, bool basechain, uint32_t refs)
@@ -2955,73 +2249,6 @@ print_match(struct nft_rule_expr *expr, int numeric)
 }
 
 static void
-print_ipv4_addr(const struct iptables_command_state *cs, unsigned int format)
-{
-	char buf[BUFSIZ];
-
-	fputc(cs->fw.ip.invflags & IPT_INV_SRCIP ? '!' : ' ', stdout);
-	if (cs->fw.ip.smsk.s_addr == 0L && !(format & FMT_NUMERIC))
-		printf(FMT("%-19s ","%s "), "anywhere");
-	else {
-		if (format & FMT_NUMERIC)
-			strcpy(buf, xtables_ipaddr_to_numeric(&cs->fw.ip.src));
-		else
-			strcpy(buf, xtables_ipaddr_to_anyname(&cs->fw.ip.src));
-		strcat(buf, xtables_ipmask_to_numeric(&cs->fw.ip.smsk));
-		printf(FMT("%-19s ","%s "), buf);
-	}
-
-	fputc(cs->fw.ip.invflags & IPT_INV_DSTIP ? '!' : ' ', stdout);
-	if (cs->fw.ip.dmsk.s_addr == 0L && !(format & FMT_NUMERIC))
-		printf(FMT("%-19s ","-> %s"), "anywhere");
-	else {
-		if (format & FMT_NUMERIC)
-			strcpy(buf, xtables_ipaddr_to_numeric(&cs->fw.ip.dst));
-		else
-			strcpy(buf, xtables_ipaddr_to_anyname(&cs->fw.ip.dst));
-		strcat(buf, xtables_ipmask_to_numeric(&cs->fw.ip.dmsk));
-		printf(FMT("%-19s ","-> %s"), buf);
-	}
-}
-
-static void
-print_ipv6_addr(const struct iptables_command_state *cs, unsigned int format)
-{
-	char buf[BUFSIZ];
-
-	fputc(cs->fw6.ipv6.invflags & IPT_INV_SRCIP ? '!' : ' ', stdout);
-	if (IN6_IS_ADDR_UNSPECIFIED(&cs->fw6.ipv6.src)
-	    && !(format & FMT_NUMERIC))
-		printf(FMT("%-19s ","%s "), "anywhere");
-	else {
-		if (format & FMT_NUMERIC)
-			strcpy(buf,
-			       xtables_ip6addr_to_numeric(&cs->fw6.ipv6.src));
-		else
-			strcpy(buf,
-			       xtables_ip6addr_to_anyname(&cs->fw6.ipv6.src));
-		strcat(buf, xtables_ip6mask_to_numeric(&cs->fw6.ipv6.smsk));
-		printf(FMT("%-19s ","%s "), buf);
-	}
-
-
-	fputc(cs->fw6.ipv6.invflags & IPT_INV_DSTIP ? '!' : ' ', stdout);
-	if (IN6_IS_ADDR_UNSPECIFIED(&cs->fw6.ipv6.dst)
-	    && !(format & FMT_NUMERIC))
-		printf(FMT("%-19s ","-> %s"), "anywhere");
-	else {
-		if (format & FMT_NUMERIC)
-			strcpy(buf,
-			       xtables_ip6addr_to_numeric(&cs->fw6.ipv6.dst));
-		else
-			strcpy(buf,
-			       xtables_ip6addr_to_anyname(&cs->fw6.ipv6.dst));
-		strcat(buf, xtables_ip6mask_to_numeric(&cs->fw6.ipv6.dmsk));
-		printf(FMT("%-19s ","-> %s"), buf);
-	}
-}
-
-static void
 print_firewall(const struct iptables_command_state *cs, struct nft_rule *r,
 	       unsigned int num, unsigned int format)
 {
@@ -3029,10 +2256,8 @@ print_firewall(const struct iptables_command_state *cs, struct nft_rule *r,
 	const char *targname = NULL;
 	const void *targinfo = NULL;
 	int family;
+	struct nft_family_ops *ops;
 	uint8_t flags = 0;
-	uint8_t invflags = 0;
-	uint8_t proto = 0;
-	const char *iniface = NULL, *outiface = NULL;
 	struct nft_rule_expr_iter *iter;
 	struct nft_rule_expr *expr;
 	struct xt_entry_target *t;
@@ -3084,91 +2309,9 @@ print_firewall(const struct iptables_command_state *cs, struct nft_rule *r,
 	nft_rule_expr_iter_destroy(iter);
 
 	family = nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY);
+	ops = nft_family_ops_lookup(family);
 
-	switch (family) {
-	case AF_INET:
-		flags = cs->fw.ip.flags;
-		invflags = flags = cs->fw.ip.invflags;
-		proto = cs->fw.ip.proto;
-		iniface = cs->fw.ip.iniface;
-		outiface = cs->fw.ip.outiface;
-		break;
-	case AF_INET6:
-		flags = cs->fw6.ipv6.flags;
-		invflags = cs->fw6.ipv6.invflags;
-		proto = cs->fw6.ipv6.proto;
-		iniface = cs->fw6.ipv6.iniface;
-		outiface = cs->fw6.ipv6.outiface;
-		break;
-	}
-
-	if (format & FMT_LINENUMBERS)
-		printf(FMT("%-4u ", "%u "), num);
-
-	if (!(format & FMT_NOCOUNTS)) {
-		print_num(cs->counters.pcnt, format);
-		print_num(cs->counters.bcnt, format);
-	}
-
-	if (!(format & FMT_NOTARGET))
-		printf(FMT("%-9s ", "%s "), targname ? targname : "");
-
-	fputc(invflags & XT_INV_PROTO ? '!' : ' ', stdout);
-	{
-		const char *pname =
-			proto_to_name(proto, format&FMT_NUMERIC);
-		if (pname)
-			printf(FMT("%-5s", "%s "), pname);
-		else
-			printf(FMT("%-5hu", "%hu "), proto);
-	}
-
-	if (format & FMT_OPTIONS) {
-		if (format & FMT_NOTABLE)
-			fputs("opt ", stdout);
-		fputc(invflags & IPT_INV_FRAG ? '!' : '-', stdout);
-		fputc(flags & IPT_F_FRAG ? 'f' : '-', stdout);
-		fputc(' ', stdout);
-	}
-
-	if (format & FMT_VIA) {
-		char iface[IFNAMSIZ+2];
-		if (invflags & IPT_INV_VIA_IN) {
-			iface[0] = '!';
-			iface[1] = '\0';
-		}
-		else iface[0] = '\0';
-
-		if (iniface[0] != '\0') {
-			strcat(iface, iniface);
-		}
-		else if (format & FMT_NUMERIC) strcat(iface, "*");
-		else strcat(iface, "any");
-		printf(FMT(" %-6s ","in %s "), iface);
-
-		if (invflags & IPT_INV_VIA_OUT) {
-			iface[0] = '!';
-			iface[1] = '\0';
-		}
-		else iface[0] = '\0';
-
-		if (outiface[0] != '\0') {
-			strcat(iface, outiface);
-		}
-		else if (format & FMT_NUMERIC) strcat(iface, "*");
-		else strcat(iface, "any");
-		printf(FMT("%-6s ","out %s "), iface);
-	}
-
-
-	switch (family) {
-	case AF_INET:
-		print_ipv4_addr(cs, format);
-		break;
-	case AF_INET6:
-		print_ipv6_addr(cs, format);
-		break;
-	}
+	flags = ops->print_firewall(cs, targname, num, format);
 
 	if (format & FMT_NOTABLE)
 		fputs("  ", stdout);
diff --git a/iptables/nft.h b/iptables/nft.h
index f7ed0a3..76e6688 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -2,12 +2,14 @@
 #define _NFT_H_
 
 #include "xshared.h"
+#include "nft-shared.h"
 
 struct nft_handle {
 	int			family;
 	struct mnl_socket	*nl;
 	uint32_t		portid;
 	uint32_t		seq;
+	struct nft_family_ops	*ops;
 };
 
 int nft_init(struct nft_handle *h);
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 1205a83..bc2ad13 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -40,6 +40,7 @@
 #include <xtables.h>
 #include <fcntl.h>
 #include "xshared.h"
+#include "nft-shared.h"
 #include "nft.h"
 
 #ifndef TRUE
@@ -49,21 +50,6 @@
 #define FALSE 0
 #endif
 
-#define FMT_NUMERIC	0x0001
-#define FMT_NOCOUNTS	0x0002
-#define FMT_KILOMEGAGIGA 0x0004
-#define FMT_OPTIONS	0x0008
-#define FMT_NOTABLE	0x0010
-#define FMT_NOTARGET	0x0020
-#define FMT_VIA		0x0040
-#define FMT_NONEWLINE	0x0080
-#define FMT_LINENUMBERS 0x0100
-
-#define FMT_PRINT_RULE (FMT_NOCOUNTS | FMT_OPTIONS | FMT_VIA \
-			| FMT_NUMERIC | FMT_NOTABLE)
-#define FMT(tab,notab) ((format) & FMT_NOTABLE ? (notab) : (tab))
-
-
 #define CMD_NONE		0x0000U
 #define CMD_INSERT		0x0001U
 #define CMD_DELETE		0x0002U
@@ -1250,6 +1236,9 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
 	}
 
 	h->family = family;
+	h->ops = nft_family_ops_lookup(family);
+	if (h->ops == NULL)
+		xtables_error(PARAMETER_PROBLEM, "Unknown family");
 
 	if (command == CMD_REPLACE && (s.naddrs != 1 || d.naddrs != 1))
 		xtables_error(PARAMETER_PROBLEM, "Replacement rule does not "
-- 
1.8.1.1

