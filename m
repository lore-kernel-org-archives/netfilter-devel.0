From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables RFC PATCH 6/6] nft: Handle IPv6 when printing out firewall rules
Date: Thu, 10 Jan 2013 16:29:39 +0200
Message-ID: <1357828179-18664-7-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1357828179-18664-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:10179 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005Ab3AJO3w (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jan 2013 09:29:52 -0500
In-Reply-To: <1357828179-18664-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c | 374 +++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 283 insertions(+), 91 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 7b36942..18ce790 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2028,39 +2028,82 @@ match_different(const struct xt_entry_match *a,
 }
 
 static bool
-is_same(const struct iptables_command_state *a, const struct iptables_command_state *b)
+is_same(int family, const struct iptables_command_state *a,
+	const struct iptables_command_state *b)
 {
 	unsigned int i;
+	const char *a_outiface, *a_iniface;
+	unsigned const char *a_iniface_mask, *a_outiface_mask;
+	const char *b_outiface, *b_iniface;
+	unsigned const char *b_iniface_mask, *b_outiface_mask;
 
 	/* Always compare head structures: ignore mask here. */
-	if (a->fw.ip.src.s_addr != b->fw.ip.src.s_addr
-	    || a->fw.ip.dst.s_addr != b->fw.ip.dst.s_addr
-	    || a->fw.ip.smsk.s_addr != b->fw.ip.smsk.s_addr
-	    || a->fw.ip.dmsk.s_addr != b->fw.ip.dmsk.s_addr
-	    || a->fw.ip.proto != b->fw.ip.proto
-	    || a->fw.ip.flags != b->fw.ip.flags
-	    || a->fw.ip.invflags != b->fw.ip.invflags) {
-		DEBUGP("different src/dst/proto/flags/invflags\n");
+	switch (family) {
+	case AF_INET:
+		if (a->fw.ip.src.s_addr != b->fw.ip.src.s_addr
+		    || a->fw.ip.dst.s_addr != b->fw.ip.dst.s_addr
+		    || a->fw.ip.smsk.s_addr != b->fw.ip.smsk.s_addr
+		    || a->fw.ip.dmsk.s_addr != b->fw.ip.dmsk.s_addr
+		    || a->fw.ip.proto != b->fw.ip.proto
+		    || a->fw.ip.flags != b->fw.ip.flags
+		    || a->fw.ip.invflags != b->fw.ip.invflags) {
+			DEBUGP("different src/dst/proto/flags/invflags\n");
+			return false;
+		}
+
+		a_iniface_mask = a->fw.ip.iniface_mask;
+		a_iniface = a->fw.ip.iniface;
+		a_outiface_mask = a->fw.ip.outiface_mask;
+		a_outiface = a->fw.ip.outiface;
+
+		b_iniface_mask = b->fw.ip.iniface_mask;
+		b_iniface = b->fw.ip.iniface;
+		b_outiface_mask = b->fw.ip.outiface_mask;
+		b_outiface = b->fw.ip.outiface;
+
+		break;
+	case AF_INET6:
+		if (a->fw6.ipv6.src.s6_addr != b->fw6.ipv6.src.s6_addr
+		    || a->fw6.ipv6.dst.s6_addr != b->fw6.ipv6.dst.s6_addr
+		    || a->fw6.ipv6.proto != b->fw6.ipv6.proto
+		    || a->fw6.ipv6.flags != b->fw6.ipv6.flags
+		    || a->fw6.ipv6.invflags != b->fw6.ipv6.invflags) {
+			DEBUGP("different src/dst/proto/flags/invflags\n");
+			return false;
+		}
+
+		a_iniface_mask = a->fw6.ipv6.iniface_mask;
+		a_iniface = a->fw6.ipv6.iniface;
+		a_outiface_mask = a->fw6.ipv6.outiface_mask;
+		a_outiface = a->fw6.ipv6.outiface;
+
+		b_iniface_mask = b->fw6.ipv6.iniface_mask;
+		b_iniface = b->fw6.ipv6.iniface;
+		b_outiface_mask = b->fw6.ipv6.outiface_mask;
+		b_outiface = b->fw6.ipv6.outiface;
+
+		break;
+	default:
 		return false;
 	}
 
 	for (i = 0; i < IFNAMSIZ; i++) {
-		if (a->fw.ip.iniface_mask[i] != b->fw.ip.iniface_mask[i]) {
+		if (a_iniface_mask[i] != b_iniface_mask[i]) {
 			DEBUGP("different iniface mask %x, %x (%d)\n",
-			a->fw.ip.iniface_mask[i] & 0xff, b->fw.ip.iniface_mask[i] & 0xff, i);
+			a_iniface_mask[i] & 0xff, b_iniface_mask[i] & 0xff, i);
 			return false;
 		}
-		if ((a->fw.ip.iniface[i] & a->fw.ip.iniface_mask[i])
-		    != (b->fw.ip.iniface[i] & b->fw.ip.iniface_mask[i])) {
+		if ((a_iniface[i] & a_iniface_mask[i])
+		    != (b_iniface[i] & b_iniface_mask[i])) {
 			DEBUGP("different iniface\n");
 			return false;
 		}
-		if (a->fw.ip.outiface_mask[i] != b->fw.ip.outiface_mask[i]) {
+		if (a_outiface_mask[i] != b_outiface_mask[i]) {
 			DEBUGP("different outiface mask\n");
 			return false;
 		}
-		if ((a->fw.ip.outiface[i] & a->fw.ip.outiface_mask[i])
-		    != (b->fw.ip.outiface[i] & b->fw.ip.outiface_mask[i])) {
+		if ((a_outiface[i] & a_outiface_mask[i])
+		    != (b_outiface[i] & b_outiface_mask[i])) {
 			DEBUGP("different outiface\n");
 			return false;
 		}
@@ -2071,13 +2114,16 @@ is_same(const struct iptables_command_state *a, const struct iptables_command_st
 
 static void
 nft_parse_meta(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
-	       struct iptables_command_state *cs)
+	       int family, struct iptables_command_state *cs)
 {
 	uint8_t key = nft_rule_expr_get_u8(e, NFT_EXPR_META_KEY);
 	uint32_t value;
 	const char *name;
 	const void *ifname;
+	char *iniface, *outiface;
+	unsigned char *iniface_mask, *outiface_mask;
 	size_t len;
+	uint8_t *invflags;
 
 	e = nft_rule_expr_iter_next(iter);
 	if (e == NULL)
@@ -2089,58 +2135,77 @@ nft_parse_meta(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
 		return;
 	}
 
+	switch (family) {
+	case AF_INET:
+		iniface = cs->fw.ip.iniface;
+		outiface = cs->fw.ip.outiface;
+		iniface_mask = cs->fw.ip.iniface_mask;
+		outiface_mask = cs->fw.ip.outiface_mask;
+		invflags = &cs->fw.ip.invflags;
+
+		break;
+	case AF_INET6:
+		iniface = cs->fw6.ipv6.iniface;
+		outiface = cs->fw6.ipv6.outiface;
+		iniface_mask = cs->fw6.ipv6.iniface_mask;
+		outiface_mask = cs->fw6.ipv6.outiface_mask;
+		invflags = &cs->fw6.ipv6.invflags;
+
+		break;
+	default:
+		return;
+	}
+
 	switch(key) {
 	case NFT_META_IIF:
 		value = nft_rule_expr_get_u32(e, NFT_EXPR_CMP_DATA);
 		if (nft_rule_expr_get_u8(e, NFT_EXPR_CMP_OP) == NFT_CMP_NEQ)
-			cs->fw.ip.invflags |= IPT_INV_VIA_IN;
+			*invflags |= IPT_INV_VIA_IN;
 
-		if_indextoname(value, cs->fw.ip.iniface);
+		if_indextoname(value, iniface);
 
-		memset(cs->fw.ip.iniface_mask, 0xff,
-		       strlen(cs->fw.ip.iniface)+1);
+		memset(iniface_mask, 0xff, strlen(iniface)+1);
 		break;
 	case NFT_META_OIF:
 		value = nft_rule_expr_get_u32(e, NFT_EXPR_CMP_DATA);
 		if (nft_rule_expr_get_u8(e, NFT_EXPR_CMP_OP) == NFT_CMP_NEQ)
-			cs->fw.ip.invflags |= IPT_INV_VIA_OUT;
+			*invflags |= IPT_INV_VIA_OUT;
 
-		if_indextoname(value, cs->fw.ip.outiface);
+		if_indextoname(value, outiface);
 
-		memset(cs->fw.ip.outiface_mask, 0xff,
-		       strlen(cs->fw.ip.outiface)+1);
+		memset(outiface_mask, 0xff, strlen(outiface)+1);
 		break;
 	case NFT_META_IIFNAME:
 		ifname = nft_rule_expr_get(e, NFT_EXPR_CMP_DATA, &len);
 		if (nft_rule_expr_get_u8(e, NFT_EXPR_CMP_OP) == NFT_CMP_NEQ)
-			cs->fw.ip.invflags |= IPT_INV_VIA_IN;
+			*invflags |= IPT_INV_VIA_IN;
 
-		memcpy(cs->fw.ip.iniface, ifname, len);
-		cs->fw.ip.iniface[len] = '\0';
+		memcpy(iniface, ifname, len);
+		iniface[len] = '\0';
 
 		/* If zero, then this is an interface mask */
-		if (if_nametoindex(cs->fw.ip.iniface) == 0) {
-			cs->fw.ip.iniface[len] = '+';
-			cs->fw.ip.iniface[len+1] = '\0';
+		if (if_nametoindex(iniface) == 0) {
+			iniface[len] = '+';
+			iniface[len+1] = '\0';
 		}
 
-		memset(cs->fw.ip.iniface_mask, 0xff, len);
+		memset(iniface_mask, 0xff, len);
 		break;
 	case NFT_META_OIFNAME:
 		ifname = nft_rule_expr_get(e, NFT_EXPR_CMP_DATA, &len);
 		if (nft_rule_expr_get_u8(e, NFT_EXPR_CMP_OP) == NFT_CMP_NEQ)
-			cs->fw.ip.invflags |= IPT_INV_VIA_OUT;
+			*invflags |= IPT_INV_VIA_OUT;
 
-		memcpy(cs->fw.ip.outiface, ifname, len);
-		cs->fw.ip.outiface[len] = '\0';
+		memcpy(outiface, ifname, len);
+		outiface[len] = '\0';
 
 		/* If zero, then this is an interface mask */
-		if (if_nametoindex(cs->fw.ip.outiface) == 0) {
-			cs->fw.ip.outiface[len] = '+';
-			cs->fw.ip.outiface[len+1] = '\0';
+		if (if_nametoindex(outiface) == 0) {
+			outiface[len] = '+';
+			outiface[len+1] = '\0';
 		}
 
-		memset(cs->fw.ip.outiface_mask, 0xff, len);
+		memset(outiface_mask, 0xff, len);
 		break;
 	default:
 		DEBUGP("unknown meta key %d\n", key);
@@ -2149,17 +2214,13 @@ nft_parse_meta(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
 }
 
 static void
-nft_parse_payload(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
-		  struct iptables_command_state *cs)
+nft_parse_payload_ipv4(uint32_t offset, struct nft_rule_expr_iter *iter,
+		       struct iptables_command_state *cs)
 {
-	uint32_t offset;
-	bool inv;
-
-	offset = nft_rule_expr_get_u32(e, NFT_EXPR_PAYLOAD_OFFSET);
-
 	switch(offset) {
 	struct in_addr addr;
 	uint8_t proto;
+	bool inv;
 
 	case offsetof(struct iphdr, saddr):
 		get_cmp_data(iter, &addr, sizeof(addr), &inv);
@@ -2194,6 +2255,56 @@ nft_parse_payload(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
 }
 
 static void
+nft_parse_payload_ipv6(uint32_t offset, struct nft_rule_expr_iter *iter,
+		       struct iptables_command_state *cs)
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
+static void
+nft_parse_payload(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
+		  int family, struct iptables_command_state *cs)
+{
+	uint32_t offset;
+
+	offset = nft_rule_expr_get_u32(e, NFT_EXPR_PAYLOAD_OFFSET);
+
+	switch (family) {
+	case AF_INET:
+		nft_parse_payload_ipv4(offset, iter, cs);
+		break;
+	case AF_INET6:
+		nft_parse_payload_ipv6(offset, iter, cs);
+		break;
+	}
+}
+
+static void
 nft_parse_counter(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
 		  struct xt_counters *counters)
 {
@@ -2203,7 +2314,7 @@ nft_parse_counter(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
 
 static void
 nft_parse_immediate(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
-		    struct iptables_command_state *cs)
+		    int family, struct iptables_command_state *cs)
 {
 	int verdict = nft_rule_expr_get_u32(e, NFT_EXPR_IMM_VERDICT);
 	const char *chain = nft_rule_expr_get_str(e, NFT_EXPR_IMM_CHAIN);
@@ -2220,7 +2331,10 @@ nft_parse_immediate(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
 		cs->jumpto = "RETURN";
 		return;
 	case NFT_GOTO:
-		cs->fw.ip.flags |= IPT_F_GOTO;
+		if (family == AF_INET)
+			cs->fw.ip.flags |= IPT_F_GOTO;
+		else
+			cs->fw6.ipv6.flags |= IPT_F_GOTO;
 	case NFT_JUMP:
 		cs->jumpto = chain;
 		return;
@@ -2233,6 +2347,7 @@ nft_rule_to_iptables_command_state(struct nft_rule *r,
 {
 	struct nft_rule_expr_iter *iter;
 	struct nft_rule_expr *expr;
+	int family = nft_rule_get_family(r);
 
 	iter = nft_rule_expr_iter_create(r);
 	if (iter == NULL)
@@ -2246,11 +2361,11 @@ nft_rule_to_iptables_command_state(struct nft_rule *r,
 		if (strcmp(name, "counter") == 0) {
 			nft_parse_counter(expr, iter, &cs->counters);
 		} else if (strcmp(name, "payload") == 0) {
-			nft_parse_payload(expr, iter, cs);
+			nft_parse_payload(expr, iter, family, cs);
 		} else if (strcmp(name, "meta") == 0) {
-			nft_parse_meta(expr, iter, cs);
+			nft_parse_meta(expr, iter, family, cs);
 		} else if (strcmp(name, "immediate") == 0) {
-			nft_parse_immediate(expr, iter, cs);
+			nft_parse_immediate(expr, iter, family, cs);
 		}
 
 		expr = nft_rule_expr_iter_next(iter);
@@ -2530,7 +2645,7 @@ nft_rule_find(struct nft_rule_list *list, const char *chain, const char *table,
 
 			nft_rule_to_iptables_command_state(r, &this);
 
-			if (!is_same(cs, &this))
+			if (!is_same(nft_rule_get_family(r), cs, &this))
 				goto next;
 
 			if (!find_matches(cs->matches, r)) {
@@ -2793,14 +2908,82 @@ print_match(struct nft_rule_expr *expr, int numeric)
 }
 
 static void
+print_ipv4_addr(const struct iptables_command_state *cs, unsigned int format)
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
+static void
+print_ipv6_addr(const struct iptables_command_state *cs, unsigned int format)
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
+			strcpy(buf, xtables_ipaddr_to_numeric(&cs->fw.ip.dst));
+		else
+			strcpy(buf, xtables_ipaddr_to_anyname(&cs->fw.ip.dst));
+		strcat(buf, xtables_ip6mask_to_numeric(&cs->fw6.ipv6.dmsk));
+		printf(FMT("%-19s ","-> %s"), buf);
+	}
+}
+
+static void
 print_firewall(const struct iptables_command_state *cs, struct nft_rule *r,
 	       unsigned int num, unsigned int format)
 {
 	const struct xtables_target *target = NULL;
 	const char *targname = NULL;
 	const void *targinfo = NULL;
-	uint8_t flags;
-	char buf[BUFSIZ];
+	int family;
+	uint8_t flags = 0;
+	uint8_t invflags = 0;
+	uint8_t proto = 0;
+	const char *iniface = NULL, *outiface = NULL;
 	struct nft_rule_expr_iter *iter;
 	struct nft_rule_expr *expr;
 	struct xt_entry_target *t;
@@ -2818,8 +3001,10 @@ print_firewall(const struct iptables_command_state *cs, struct nft_rule *r,
 			nft_rule_expr_get_str(expr, NFT_RULE_EXPR_ATTR_NAME);
 
 		if (strcmp(name, "target") == 0) {
-			targname = nft_rule_expr_get_str(expr, NFT_EXPR_TG_NAME);
-			targinfo = nft_rule_expr_get(expr, NFT_EXPR_TG_INFO, &target_len);
+			targname = nft_rule_expr_get_str(expr,
+							 NFT_EXPR_TG_NAME);
+			targinfo = nft_rule_expr_get(expr, NFT_EXPR_TG_INFO,
+						     &target_len);
 			break;
 		} else if (strcmp(name, "immediate") == 0) {
 			uint32_t verdict =
@@ -2836,10 +3021,12 @@ print_firewall(const struct iptables_command_state *cs, struct nft_rule *r,
 				targname = "RETURN";
 				break;
 			case NFT_GOTO:
-				targname = nft_rule_expr_get_str(expr, NFT_EXPR_IMM_CHAIN);
+				targname = nft_rule_expr_get_str(expr,
+							NFT_EXPR_IMM_CHAIN);
 				break;
 			case NFT_JUMP:
-				targname = nft_rule_expr_get_str(expr, NFT_EXPR_IMM_CHAIN);
+				targname = nft_rule_expr_get_str(expr,
+							NFT_EXPR_IMM_CHAIN);
 			break;
 			}
 		}
@@ -2847,7 +3034,26 @@ print_firewall(const struct iptables_command_state *cs, struct nft_rule *r,
 	}
 	nft_rule_expr_iter_destroy(iter);
 
-	flags = cs->fw.ip.flags;
+	family = nft_rule_get_family(r);
+
+	switch (family) {
+	case AF_INET:
+		flags = cs->fw.ip.flags;
+		invflags = flags = cs->fw.ip.invflags;
+		proto = cs->fw.ip.proto;
+		iniface = cs->fw.ip.iniface;
+		outiface = cs->fw.ip.outiface;
+
+		break;
+	case AF_INET6:
+		flags = cs->fw6.ipv6.flags;
+		invflags = cs->fw6.ipv6.invflags;
+		proto = cs->fw6.ipv6.proto;
+		iniface = cs->fw6.ipv6.iniface;
+		outiface = cs->fw6.ipv6.outiface;
+
+		break;
+	}
 
 	if (format & FMT_LINENUMBERS)
 		printf(FMT("%-4u ", "%u "), num);
@@ -2860,82 +3066,68 @@ print_firewall(const struct iptables_command_state *cs, struct nft_rule *r,
 	if (!(format & FMT_NOTARGET))
 		printf(FMT("%-9s ", "%s "), targname ? targname : "");
 
-	fputc(cs->fw.ip.invflags & XT_INV_PROTO ? '!' : ' ', stdout);
+	fputc(invflags & XT_INV_PROTO ? '!' : ' ', stdout);
 	{
 		const char *pname =
-			proto_to_name(cs->fw.ip.proto, format&FMT_NUMERIC);
+			proto_to_name(proto, format&FMT_NUMERIC);
 		if (pname)
 			printf(FMT("%-5s", "%s "), pname);
 		else
-			printf(FMT("%-5hu", "%hu "), cs->fw.ip.proto);
+			printf(FMT("%-5hu", "%hu "), proto);
 	}
 
 	if (format & FMT_OPTIONS) {
 		if (format & FMT_NOTABLE)
 			fputs("opt ", stdout);
-		fputc(cs->fw.ip.invflags & IPT_INV_FRAG ? '!' : '-', stdout);
+		fputc(invflags & IPT_INV_FRAG ? '!' : '-', stdout);
 		fputc(flags & IPT_F_FRAG ? 'f' : '-', stdout);
 		fputc(' ', stdout);
 	}
 
 	if (format & FMT_VIA) {
 		char iface[IFNAMSIZ+2];
-		if (cs->fw.ip.invflags & IPT_INV_VIA_IN) {
+		if (invflags & IPT_INV_VIA_IN) {
 			iface[0] = '!';
 			iface[1] = '\0';
 		}
 		else iface[0] = '\0';
 
-		if (cs->fw.ip.iniface[0] != '\0') {
-			strcat(iface, cs->fw.ip.iniface);
+		if (iniface[0] != '\0') {
+			strcat(iface, iniface);
 		}
 		else if (format & FMT_NUMERIC) strcat(iface, "*");
 		else strcat(iface, "any");
 		printf(FMT(" %-6s ","in %s "), iface);
 
-		if (cs->fw.ip.invflags & IPT_INV_VIA_OUT) {
+		if (invflags & IPT_INV_VIA_OUT) {
 			iface[0] = '!';
 			iface[1] = '\0';
 		}
 		else iface[0] = '\0';
 
-		if (cs->fw.ip.outiface[0] != '\0') {
-			strcat(iface, cs->fw.ip.outiface);
+		if (outiface[0] != '\0') {
+			strcat(iface, outiface);
 		}
 		else if (format & FMT_NUMERIC) strcat(iface, "*");
 		else strcat(iface, "any");
 		printf(FMT("%-6s ","out %s "), iface);
 	}
 
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
+	switch (family) {
+	case AF_INET:
+		print_ipv4_addr(cs, format);
+		break;
+	case AF_INET6:
+		print_ipv6_addr(cs, format);
+		break;
 	}
 
 	if (format & FMT_NOTABLE)
 		fputs("  ", stdout);
 
 #ifdef IPT_F_GOTO
-	if(cs->fw.ip.flags & IPT_F_GOTO)
+	if(flags & IPT_F_GOTO)
 		printf("[goto] ");
 #endif
 
-- 
1.8.0.2

