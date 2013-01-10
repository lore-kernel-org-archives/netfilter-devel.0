From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables RFC PATCH 4/6] nft: Support IPv6 rules manipulation
Date: Thu, 10 Jan 2013 16:29:37 +0200
Message-ID: <1357828179-18664-5-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1357828179-18664-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:10179 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344Ab3AJO3t (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jan 2013 09:29:49 -0500
In-Reply-To: <1357828179-18664-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It firsts moves redondant code into helpers, and then apply the right
sequence according to the family type.

Note: It currently lacks of IPv6 fragments handling support

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c | 198 ++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 134 insertions(+), 64 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 78a100e..f12008a 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -35,6 +35,8 @@
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>	/* FIXME: only IPV4 by now */
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <netinet/ip6.h>
 
 #include <linux/netlink.h>
 #include <linux/netfilter/nfnetlink.h>
@@ -741,6 +743,78 @@ static void add_counters(struct nft_rule *r, uint64_t packets, uint64_t bytes)
 	nft_rule_add_expr(r, expr);
 }
 
+static void add_iniface(struct nft_rule *r, char *iface, int invflags)
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
+static void add_outiface(struct nft_rule *r, char *iface, int invflags)
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
+static void add_addr(struct nft_rule *r, int offset,
+			void *data, size_t len, int invflags)
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
+static void add_proto(struct nft_rule *r, int offset, size_t len,
+		      uint32_t proto, int invflags)
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
 int
 nft_rule_add(struct nft_handle *h, const char *chain, const char *table,
 	     struct iptables_command_state *cs,
@@ -753,6 +827,7 @@ nft_rule_add(struct nft_handle *h, const char *chain, const char *table,
 	int ret = 1;
 	uint32_t op;
 	int flags = append ? NLM_F_APPEND : 0;
+	int ip_flags = 0;
 
 	/* If built-in chains don't exist for this table, create them */
 	nft_chain_builtin_init(h, table, chain, NF_ACCEPT);
@@ -768,77 +843,72 @@ nft_rule_add(struct nft_handle *h, const char *chain, const char *table,
 	nft_rule_attr_set(r, NFT_RULE_ATTR_TABLE, (char *)table);
 	nft_rule_attr_set(r, NFT_RULE_ATTR_CHAIN, (char *)chain);
 
-	if (cs->fw.ip.iniface[0] != '\0') {
-		int iface_len = strlen(cs->fw.ip.iniface);
-
-		if (cs->fw.ip.invflags & IPT_INV_VIA_IN)
-			op = NFT_CMP_NEQ;
-		else
-			op = NFT_CMP_EQ;
-
-		if (cs->fw.ip.iniface[iface_len - 1] == '+') {
-			add_meta(r, NFT_META_IIFNAME);
-			add_cmp_ptr(r, op, cs->fw.ip.iniface, iface_len - 1);
-		} else {
-			add_meta(r, NFT_META_IIF);
-			add_cmp_u32(r, if_nametoindex(cs->fw.ip.iniface), op);
+	switch (h->family) {
+	case AF_INET:
+		if (cs->fw.ip.iniface[0] != '\0')
+			add_iniface(r, cs->fw.ip.iniface, cs->fw.ip.invflags);
+
+		if (cs->fw.ip.outiface[0] != '\0')
+			add_outiface(r, cs->fw.ip.outiface,
+				     cs->fw.ip.invflags);
+
+		if (cs->fw.ip.src.s_addr != 0)
+			add_addr(r, offsetof(struct iphdr, saddr),
+				 &cs->fw.ip.src.s_addr, 4,
+				 cs->fw.ip.invflags);
+
+		if (cs->fw.ip.dst.s_addr != 0)
+			add_addr(r, offsetof(struct iphdr, daddr),
+				 &cs->fw.ip.dst.s_addr, 4,
+				 cs->fw.ip.invflags);
+
+		if (cs->fw.ip.proto != 0)
+			add_proto(r, offsetof(struct iphdr, protocol), 1,
+				  cs->fw.ip.proto, cs->fw.ip.invflags);
+
+		if (cs->fw.ip.flags & IPT_F_FRAG) {
+			add_payload(r, offsetof(struct iphdr, frag_off), 2);
+			/* get the 13 bits that contain the fragment offset */
+			add_bitwise_u16(r, 0x1fff, !0x1fff);
+
+			/* if offset is non-zero, this is a fragment */
+			if (cs->fw.ip.invflags & IPT_INV_FRAG)
+				op = NFT_CMP_EQ;
+			else
+				op = NFT_CMP_NEQ;
+
+			add_cmp_u16(r, 0, op);
 		}
-	}
-	if (cs->fw.ip.outiface[0] != '\0') {
-		int iface_len = strlen(cs->fw.ip.outiface);
 
-		if (cs->fw.ip.invflags & IPT_INV_VIA_OUT)
-			op = NFT_CMP_NEQ;
-		else
-			op = NFT_CMP_EQ;
+		ip_flags = cs->fw.ip.flags;
 
-		if (cs->fw.ip.outiface[iface_len - 1] == '+') {
-			add_meta(r, NFT_META_OIFNAME);
-			add_cmp_ptr(r, op, cs->fw.ip.outiface, iface_len - 1);
-		} else {
-			add_meta(r, NFT_META_OIF);
-			add_cmp_u32(r, if_nametoindex(cs->fw.ip.outiface), op);
-		}
-	}
-	if (cs->fw.ip.src.s_addr != 0) {
-		add_payload(r, offsetof(struct iphdr, saddr), 4);
-		if (cs->fw.ip.invflags & IPT_INV_SRCIP)
-			op = NFT_CMP_NEQ;
-		else
-			op = NFT_CMP_EQ;
+		break;
+	case AF_INET6:
+		if (cs->fw6.ipv6.iniface[0] != '\0')
+			add_iniface(r, cs->fw6.ipv6.iniface,
+				    cs->fw6.ipv6.invflags);
 
-		add_cmp_u32(r, cs->fw.ip.src.s_addr, op);
-	}
-	if (cs->fw.ip.dst.s_addr != 0) {
-		add_payload(r, offsetof(struct iphdr, daddr), 4);
-		if (cs->fw.ip.invflags & IPT_INV_DSTIP)
-			op = NFT_CMP_NEQ;
-		else
-			op = NFT_CMP_EQ;
+		if (cs->fw6.ipv6.outiface[0] != '\0')
+			add_outiface(r, cs->fw6.ipv6.outiface,
+				    cs->fw6.ipv6.invflags);
 
-		add_cmp_u32(r, cs->fw.ip.dst.s_addr, op);
-	}
-	if (cs->fw.ip.proto != 0) {
-		add_payload(r, offsetof(struct iphdr, protocol), 1);
-		if (cs->fw.ip.invflags & XT_INV_PROTO)
-			op = NFT_CMP_NEQ;
-		else
-			op = NFT_CMP_EQ;
+		if (!IN6_IS_ADDR_UNSPECIFIED(&cs->fw6.ipv6.src))
+			add_addr(r, offsetof(struct ip6_hdr, ip6_src),
+				 &cs->fw6.ipv6.src, 16,
+				 cs->fw6.ipv6.invflags);
 
-		add_cmp_u32(r, cs->fw.ip.proto, op);
-	}
-	if (cs->fw.ip.flags & IPT_F_FRAG) {
-		add_payload(r, offsetof(struct iphdr, frag_off), 2);
-		/* get the 13 bits that contain the fragment offset */
-		add_bitwise_u16(r, 0x1fff, !0x1fff);
+		if (!IN6_IS_ADDR_UNSPECIFIED(&cs->fw6.ipv6.dst))
+			add_addr(r, offsetof(struct ip6_hdr, ip6_dst),
+				 &cs->fw6.ipv6.dst, 16,
+				 cs->fw6.ipv6.invflags);
 
-		/* if offset is non-zero, this is a fragment */
-		if (cs->fw.ip.invflags & IPT_INV_FRAG)
-			op = NFT_CMP_EQ;
-		else
-			op = NFT_CMP_NEQ;
+		if (cs->fw6.ipv6.proto != 0)
+			add_proto(r, offsetof(struct ip6_hdr, ip6_nxt), 1,
+				  cs->fw6.ipv6.proto, cs->fw6.ipv6.invflags);
+
+		ip_flags = cs->fw6.ipv6.flags;
 
-		add_cmp_u16(r, 0, op);
+		break;
 	}
 
 	for (matchp = cs->matches; matchp; matchp = matchp->next)
@@ -862,7 +932,7 @@ nft_rule_add(struct nft_handle *h, const char *chain, const char *table,
 			add_target(r, cs->target->t);
 	} else if (strlen(cs->jumpto) > 0) {
 		/* Not standard, then it's a go / jump to chain */
-		if (cs->fw.ip.flags & IPT_F_GOTO)
+		if (ip_flags & IPT_F_GOTO)
 			add_jumpto(r, cs->jumpto, NFT_GOTO);
 		else
 			add_jumpto(r, cs->jumpto, NFT_JUMP);
-- 
1.8.0.2

