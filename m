From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - RFC v2 PATCH  14/17] xtables: nft: Complete refactoring on how rules are saved
Date: Thu, 25 Jul 2013 20:16:34 +0300
Message-ID: <1374772597-20548-15-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1374772597-20548-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:5380 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756583Ab3GYRRD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:17:03 -0400
In-Reply-To: <1374772597-20548-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now that we parse properly, in one place and at once, the rule back into a 
command structure, it's now easier to save the rule from that command
structure.


Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft-ipv4.c       | 122 ++++++-------------
 iptables/nft-ipv6.c       |  72 +++++-------
 iptables/nft-shared.c     |  73 ++++++++++--
 iptables/nft-shared.h     |  13 ++-
 iptables/nft.c            | 290 +++++++---------------------------------------
 iptables/nft.h            |   8 +-
 iptables/xtables-events.c |  21 ++--
 7 files changed, 189 insertions(+), 410 deletions(-)

diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 4b8f146..3c2a40f 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -97,50 +97,6 @@ static void get_frag_from_expr(struct nft_rule_expr *e, bool *inv)
 		*inv = false;
 }
 
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
 static const char *mask_to_str(uint32_t mask)
 {
 	static char mask_str[sizeof("255.255.255.255")];
@@ -167,50 +123,6 @@ static const char *mask_to_str(uint32_t mask)
 	return mask_str;
 }
 
-static void nft_ipv4_print_payload(struct nft_rule_expr *e,
-				  struct nft_rule_expr_iter *iter)
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
 static void nft_ipv4_parse_meta(struct nft_rule_expr *e, uint8_t key,
 				struct iptables_command_state *cs)
 {
@@ -311,6 +223,38 @@ static uint8_t nft_ipv4_print_firewall(const struct iptables_command_state *cs,
 	return cs->fw.ip.flags;
 }
 
+static void save_ipv4_addr(char letter, const struct in_addr *addr,
+			   uint32_t mask, int invert)
+{
+	if (!mask && !invert && !addr->s_addr)
+		return;
+
+	printf("%s-%c %s/%s ", invert ? "! " : "", letter,
+			inet_ntoa(*addr), mask_to_str(mask));
+}
+
+static uint8_t nft_ipv4_save_firewall(const struct iptables_command_state *cs,
+				      unsigned int format)
+{
+	save_firewall_details(cs, cs->fw.ip.invflags, cs->fw.ip.proto,
+				cs->fw.ip.iniface, cs->fw.ip.iniface_mask,
+				cs->fw.ip.outiface, cs->fw.ip.outiface_mask,
+				format);
+
+	if (cs->fw.ip.flags & IPT_F_FRAG) {
+		if (cs->fw.ip.invflags & IPT_INV_FRAG)
+			printf("! ");
+		printf("-f ");
+	}
+
+	save_ipv4_addr('s', &cs->fw.ip.src, cs->fw.ip.smsk.s_addr,
+					cs->fw.ip.invflags & IPT_INV_SRCIP);
+	save_ipv4_addr('d', &cs->fw.ip.dst, cs->fw.ip.dmsk.s_addr,
+					cs->fw.ip.invflags & IPT_INV_DSTIP);
+
+	return cs->fw.ip.flags;
+}
+
 static void nft_ipv4_post_parse(int command,
 				struct iptables_command_state *cs,
 				struct xtables_args *args)
@@ -360,10 +304,10 @@ static void nft_ipv4_post_parse(int command,
 struct nft_family_ops nft_family_ops_ipv4 = {
 	.add			= nft_ipv4_add,
 	.is_same		= nft_ipv4_is_same,
-	.print_payload		= nft_ipv4_print_payload,
 	.parse_meta		= nft_ipv4_parse_meta,
 	.parse_payload		= nft_ipv4_parse_payload,
 	.parse_immediate	= nft_ipv4_parse_immediate,
 	.print_firewall		= nft_ipv4_print_firewall,
+	.save_firewall		= nft_ipv4_save_firewall,
 	.post_parse		= nft_ipv4_post_parse,
 };
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index e5c8db9..138328f 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -69,48 +69,6 @@ static bool nft_ipv6_is_same(const struct iptables_command_state *a,
 				  b->fw6.ipv6.outiface_mask);
 }
 
-static void nft_ipv6_print_payload(struct nft_rule_expr *e,
-				   struct nft_rule_expr_iter *iter)
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
 static void nft_ipv6_parse_meta(struct nft_rule_expr *e, uint8_t key,
 				struct iptables_command_state *cs)
 {
@@ -209,6 +167,34 @@ static uint8_t nft_ipv6_print_firewall(const struct iptables_command_state *cs,
 	return cs->fw6.ipv6.flags;
 }
 
+static void save_ipv6_addr(char letter, const struct in6_addr *addr,
+			   int invert)
+{
+	char addr_str[INET6_ADDRSTRLEN];
+
+	if (!invert && !IN6_IS_ADDR_UNSPECIFIED(addr))
+		return;
+
+	inet_ntop(AF_INET6, &addr, addr_str, INET6_ADDRSTRLEN);
+	printf("%s-%c %s ", invert ? "! " : "", letter, addr_str);
+}
+
+static uint8_t nft_ipv6_save_firewall(const struct iptables_command_state *cs,
+				      unsigned int format)
+{
+	save_firewall_details(cs, cs->fw6.ipv6.invflags, cs->fw6.ipv6.proto,
+			cs->fw6.ipv6.iniface, cs->fw6.ipv6.iniface_mask,
+			cs->fw6.ipv6.outiface, cs->fw6.ipv6.outiface_mask,
+			format);
+
+	save_ipv6_addr('s', &cs->fw6.ipv6.src,
+				cs->fw6.ipv6.invflags & IPT_INV_SRCIP);
+	save_ipv6_addr('d', &cs->fw6.ipv6.dst,
+				cs->fw6.ipv6.invflags & IPT_INV_DSTIP);
+
+	return cs->fw6.ipv6.flags;
+}
+
 /* These are invalid numbers as upper layer protocol */
 static int is_exthdr(uint16_t proto)
 {
@@ -278,10 +264,10 @@ static void nft_ipv6_post_parse(int command, struct iptables_command_state *cs,
 struct nft_family_ops nft_family_ops_ipv6 = {
 	.add			= nft_ipv6_add,
 	.is_same		= nft_ipv6_is_same,
-	.print_payload		= nft_ipv6_print_payload,
 	.parse_meta		= nft_ipv6_parse_meta,
 	.parse_payload		= nft_ipv6_parse_payload,
 	.parse_immediate	= nft_ipv6_parse_immediate,
 	.print_firewall		= nft_ipv6_print_firewall,
+	.save_firewall		= nft_ipv6_save_firewall,
 	.post_parse		= nft_ipv6_post_parse,
 };
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 99a7681..9d25b98 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -313,18 +313,6 @@ void get_expr_cmp_data(struct nft_rule_expr *e,
 		*inv = false;
 }
 
-void get_cmp_data(struct nft_rule_expr_iter *iter,
-		  void *data, size_t dlen, bool *inv)
-{
-	struct nft_rule_expr *e;
-
-	e = nft_rule_expr_iter_next(iter);
-	if (e == NULL)
-		return;
-
-	get_expr_cmp_data(e, data, dlen, inv);
-}
-
 void print_num(uint64_t number, unsigned int format)
 {
 	if (format & FMT_KILOMEGAGIGA) {
@@ -414,6 +402,67 @@ void print_firewall_details(const struct iptables_command_state *cs,
 	}
 }
 
+static void
+print_iface(char letter, const char *iface, const unsigned char *mask,
+            int invert)
+{
+	unsigned int i;
+
+	if (mask[0] == 0)
+		return;
+
+	printf("%s-%c ", invert ? "! " : "", letter);
+
+	for (i = 0; i < IFNAMSIZ; i++) {
+		if (mask[i] != 0) {
+			if (iface[i] != '\0')
+				printf("%c", iface[i]);
+			} else {
+				if (iface[i-1] != '\0')
+					printf("+");
+				break;
+		}
+	}
+
+	printf(" ");
+}
+
+void save_firewall_details(const struct iptables_command_state *cs,
+			   uint8_t invflags, uint16_t proto,
+			   const char *iniface,
+			   unsigned const char *iniface_mask,
+			   const char *outiface,
+			   unsigned const char *outiface_mask,
+			   unsigned int format)
+{
+	if (!(format & FMT_NOCOUNTS)) {
+		printf("-c ");
+		print_num(cs->counters.pcnt, format);
+		print_num(cs->counters.bcnt, format);
+	}
+
+	if (iniface != NULL)
+		print_iface('i', iniface, iniface_mask,
+					invflags & IPT_INV_VIA_IN);
+
+	if (outiface != NULL)
+		print_iface('o', outiface, outiface_mask,
+					invflags & IPT_INV_VIA_OUT);
+
+	if (proto > 0) {
+		const struct protoent *pent = getprotobynumber(proto);
+
+		if (invflags & XT_INV_PROTO)
+			printf("! ");
+
+		if (pent)
+			printf("-p %s ", pent->p_name);
+		else
+			printf("-p %u ", proto);
+	}
+
+}
+
 struct nft_family_ops *nft_family_ops_lookup(int family)
 {
 	switch (family) {
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 2c199b4..45eccf5 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -40,8 +40,6 @@ struct nft_family_ops {
 	int (*add)(struct nft_rule *r, struct iptables_command_state *cs);
 	bool (*is_same)(const struct iptables_command_state *a,
 			const struct iptables_command_state *b);
-	void (*print_payload)(struct nft_rule_expr *e,
-			      struct nft_rule_expr_iter *iter);
 	void (*parse_meta)(struct nft_rule_expr *e, uint8_t key,
 			   struct iptables_command_state *cs);
 	void (*parse_payload)(struct nft_rule_expr *e_1,
@@ -52,6 +50,8 @@ struct nft_family_ops {
 	uint8_t (*print_firewall)(const struct iptables_command_state *cs,
 				  const char *targname, unsigned int num,
 				  unsigned int format);
+	uint8_t (*save_firewall)(const struct iptables_command_state *cs,
+				 unsigned int format);
 	void (*post_parse)(int command, struct iptables_command_state *cs,
 			   struct xtables_args *args);
 };
@@ -85,14 +85,19 @@ void parse_meta(struct nft_rule_expr *e, uint8_t key, char *iniface,
 void print_proto(uint16_t proto, int invert);
 void get_expr_cmp_data(struct nft_rule_expr *e,
 		       void *data, size_t dlen, bool *inv);
-void get_cmp_data(struct nft_rule_expr_iter *iter,
-		  void *data, size_t dlen, bool *inv);
 void print_num(uint64_t number, unsigned int format);
 void print_firewall_details(const struct iptables_command_state *cs,
 			    const char *targname, uint8_t flags,
 			    uint8_t invflags, uint8_t proto,
 			    const char *iniface, const char *outiface,
 			    unsigned int num, unsigned int format);
+void save_firewall_details(const struct iptables_command_state *cs,
+			   uint8_t invflags, uint16_t proto,
+			   const char *iniface,
+			   unsigned const char *iniface_mask,
+			   const char *outiface,
+			   unsigned const char *outiface_mask,
+			   unsigned int format);
 
 struct nft_family_ops *nft_family_ops_lookup(int family);
 
diff --git a/iptables/nft.c b/iptables/nft.c
index 39dcc06..d05f6ae 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -53,8 +53,6 @@
 #include "xtables-config-parser.h"
 #include "nft-xt-ext.h"
 
-static void initiate_nft_translation_tree(void);
-
 static void *nft_fn;
 struct nft_trans_instruction_tree *xt_nft_tree;
 
@@ -408,7 +406,7 @@ int nft_init(struct nft_handle *h)
 	}
 	h->portid = mnl_socket_get_portid(h->nl);
 
-	initiate_nft_translation_tree();
+	nft_initiate_translation_tree();
 
 	return 0;
 }
@@ -812,224 +810,27 @@ err:
 	return ret == 0 ? 1 : 0;
 }
 
-static void nft_match_save(struct nft_rule_expr *expr)
-{
-	const char *name;
-	const struct xtables_match *match;
-	struct xt_entry_match *emu;
-	const void *mtinfo;
-	size_t len;
-
-	name = nft_rule_expr_get_str(expr, NFT_EXPR_MT_NAME);
-
-	match = xtables_find_match(name, XTF_TRY_LOAD, NULL);
-	if (match == NULL)
-		return;
-
-	mtinfo = nft_rule_expr_get(expr, NFT_EXPR_MT_INFO, &len);
-	if (mtinfo == NULL)
-		return;
-
-	emu = calloc(1, sizeof(struct xt_entry_match) + len);
-	if (emu == NULL)
-		return;
-
-	memcpy(&emu->data, mtinfo, len);
-
-	if (match->alias)
-		printf("-m %s", match->alias(emu));
-	else
-		printf("-m %s", match->name);
-
-	/* FIXME missing parameter */
-	if (match->save)
-		match->save(NULL, emu);
-
-	printf(" ");
-
-	free(emu);
-}
-
-static void nft_target_save(struct nft_rule_expr *expr)
-{
-	const char *name;
-	const struct xtables_target *target;
-	struct xt_entry_target *emu;
-	const void *tginfo;
-	size_t len;
-
-	name = nft_rule_expr_get_str(expr, NFT_EXPR_TG_NAME);
-
-	/* Standard target not supported, we use native immediate expression */
-	if (strcmp(name, "") == 0) {
-		printf("ERROR: standard target seen, should not happen\n");
-		return;
-	}
-
-	target = xtables_find_target(name, XTF_TRY_LOAD);
-	if (target == NULL)
-		return;
-
-	tginfo = nft_rule_expr_get(expr, NFT_EXPR_TG_INFO, &len);
-	if (tginfo == NULL)
-		return;
-
-	emu = calloc(1, sizeof(struct xt_entry_match) + len);
-	if (emu == NULL)
-		return;
-
-	memcpy(emu->data, tginfo, len);
-
-	if (target->alias)
-		printf("-j %s", target->alias(emu));
-	else
-		printf("-j %s", target->name);
-
-	/* FIXME missing parameter */
-	if (target->save)
-		target->save(NULL, emu);
-
-	free(emu);
-}
-
-static void nft_immediate_save(struct nft_rule_expr *expr)
-{
-	uint32_t verdict;
-
-	verdict = nft_rule_expr_get_u32(expr, NFT_EXPR_IMM_VERDICT);
-
-	switch(verdict) {
-	case NF_ACCEPT:
-		printf("-j ACCEPT");
-		break;
-	case NF_DROP:
-		printf("-j DROP");
-		break;
-	case NFT_RETURN:
-		printf("-j RETURN");
-		break;
-	case NFT_GOTO:
-		printf("-g %s",
-			nft_rule_expr_get_str(expr, NFT_EXPR_IMM_CHAIN));
-		break;
-	case NFT_JUMP:
-		printf("-j %s",
-			nft_rule_expr_get_str(expr, NFT_EXPR_IMM_CHAIN));
-		break;
-	}
-}
-
-static void
-nft_print_meta(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter)
+void
+nft_rule_print_save(const struct iptables_command_state *cs,
+		    struct nft_rule *r, enum nft_rule_print type,
+		    unsigned int format)
 {
-	uint8_t key = nft_rule_expr_get_u8(e, NFT_EXPR_META_KEY);
-	uint32_t value;
-	const char *name;
-	char ifname[IFNAMSIZ];
-	const char *ifname_ptr;
-	size_t len;
-
-	e = nft_rule_expr_iter_next(iter);
-	if (e == NULL)
-		return;
-
-	name = nft_rule_expr_get_str(e, NFT_RULE_EXPR_ATTR_NAME);
-	/* meta should be followed by cmp */
-	if (strcmp(name, "cmp") != 0) {
-		DEBUGP("skipping no cmp after meta\n");
-		return;
-	}
-
-	switch(key) {
-	case NFT_META_IIF:
-		value = nft_rule_expr_get_u32(e, NFT_EXPR_CMP_DATA);
-		if_indextoname(value, ifname);
-
-		switch(nft_rule_expr_get_u8(e, NFT_EXPR_CMP_OP)) {
-		case NFT_CMP_EQ:
-			printf("-i %s ", ifname);
-			break;
-		case NFT_CMP_NEQ:
-			printf("! -i %s ", ifname);
-			break;
-		}
-		break;
-	case NFT_META_OIF:
-		value = nft_rule_expr_get_u32(e, NFT_EXPR_CMP_DATA);
-		if_indextoname(value, ifname);
-
-		switch(nft_rule_expr_get_u8(e, NFT_EXPR_CMP_OP)) {
-		case NFT_CMP_EQ:
-			printf("-o %s ", ifname);
-			break;
-		case NFT_CMP_NEQ:
-			printf("! -o %s ", ifname);
-			break;
-		}
-		break;
-	case NFT_META_IIFNAME:
-		ifname_ptr = nft_rule_expr_get(e, NFT_EXPR_CMP_DATA, &len);
-		memcpy(ifname, ifname_ptr, len);
-		ifname[len] = '\0';
-
-		/* if this is zero, then assume this is a interface mask */
-		if (if_nametoindex(ifname) == 0) {
-			ifname[len] = '+';
-			ifname[len+1] = '\0';
-		}
+	const char *chain = nft_rule_attr_get_str(r, NFT_RULE_ATTR_CHAIN);
+	int family = nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY);
+	struct xtables_rule_match *matchp;
+	struct nft_family_ops *ops;
+	int ip_flags = 0;
 
-		switch(nft_rule_expr_get_u8(e, NFT_EXPR_CMP_OP)) {
-		case NFT_CMP_EQ:
-			printf("-i %s ", ifname);
-			break;
-		case NFT_CMP_NEQ:
-			printf("! -i %s ", ifname);
-			break;
-		}
+	switch(family) {
+	case AF_INET:
+		printf("-4 ");
 		break;
-	case NFT_META_OIFNAME:
-		ifname_ptr = nft_rule_expr_get(e, NFT_EXPR_CMP_DATA, &len);
-		memcpy(ifname, ifname_ptr, len);
-		ifname[len] = '\0';
-
-		/* if this is zero, then assume this is a interface mask */
-		if (if_nametoindex(ifname) == 0) {
-			ifname[len] = '+';
-			ifname[len+1] = '\0';
-		}
-
-		switch(nft_rule_expr_get_u8(e, NFT_EXPR_CMP_OP)) {
-		case NFT_CMP_EQ:
-			printf("-o %s ", ifname);
-			break;
-		case NFT_CMP_NEQ:
-			printf("! -o %s ", ifname);
-			break;
-		}
+	case AF_INET6:
+		printf("-6 ");
 		break;
 	default:
-		DEBUGP("unknown meta key %d\n", key);
 		break;
 	}
-}
-
-static void
-nft_print_counters(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
-		   bool counters)
-{
-	if (counters) {
-		printf("-c %"PRIu64" %"PRIu64" ",
-			nft_rule_expr_get_u64(e, NFT_EXPR_CTR_PACKETS),
-			nft_rule_expr_get_u64(e, NFT_EXPR_CTR_BYTES));
-	}
-}
-
-void
-nft_rule_print_save(struct nft_rule *r, enum nft_rule_print type, bool counters)
-{
-	struct nft_rule_expr_iter *iter;
-	struct nft_rule_expr *expr;
-	const char *chain = nft_rule_attr_get_str(r, NFT_RULE_ATTR_CHAIN);
 
 	/* print chain name */
 	switch(type) {
@@ -1041,33 +842,24 @@ nft_rule_print_save(struct nft_rule *r, enum nft_rule_print type, bool counters)
 		break;
 	}
 
-	iter = nft_rule_expr_iter_create(r);
-	if (iter == NULL)
-		return;
+	ops = nft_family_ops_lookup(family);
+	ip_flags = ops->save_firewall(cs, format);
 
-	expr = nft_rule_expr_iter_next(iter);
-	while (expr != NULL) {
-		const char *name =
-			nft_rule_expr_get_str(expr, NFT_RULE_EXPR_ATTR_NAME);
+	for (matchp = cs->matches; matchp; matchp = matchp->next) {
+		printf("-m %s", matchp->match->name);
+		if (matchp->match->save != NULL)
+			matchp->match->save(NULL, matchp->match->m);
+		printf(" ");
+	}
 
-		if (strcmp(name, "counter") == 0) {
-			nft_print_counters(expr, iter, counters);
-		} else if (strcmp(name, "payload") == 0) {
-			struct nft_family_ops *ops = nft_family_ops_lookup(
-				nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY));
-			ops->print_payload(expr, iter);
-		} else if (strcmp(name, "meta") == 0) {
-			nft_print_meta(expr, iter);
-		} else if (strcmp(name, "match") == 0) {
-			nft_match_save(expr);
-		} else if (strcmp(name, "target") == 0) {
-			nft_target_save(expr);
-		} else if (strcmp(name, "immediate") == 0) {
-			nft_immediate_save(expr);
-		}
+	if (cs->target != NULL) {
+		printf("-j %s", cs->jumpto);
 
-		expr = nft_rule_expr_iter_next(iter);
-	}
+		if (cs->target->save != NULL)
+			cs->target->save(NULL, cs->target->t);
+	} else if (strlen(cs->jumpto) > 0)
+		printf("-%c %s", ip_flags & IPT_F_GOTO ? 'g' : 'j',
+								cs->jumpto);
 
 	printf("\n");
 }
@@ -1249,11 +1041,15 @@ int nft_rule_save(struct nft_handle *h, const char *table, bool counters)
 	while (r != NULL) {
 		const char *rule_table =
 			nft_rule_attr_get_str(r, NFT_RULE_ATTR_TABLE);
+		struct iptables_command_state cs = {};
 
 		if (strcmp(table, rule_table) != 0)
 			goto next;
 
-		nft_rule_print_save(r, NFT_RULE_APPEND, counters);
+		nft_rule_to_iptables_command_state(r, &cs);
+
+		nft_rule_print_save(&cs, r, NFT_RULE_APPEND,
+						counters ? 0 : FMT_NOCOUNTS);
 
 next:
 		r = nft_rule_list_iter_next(iter);
@@ -1809,9 +1605,8 @@ static int nft_parse_ip_addresses(struct nft_trans_rule_context *rule_ctx,
 	return 0;
 }
 
-static void
-nft_rule_to_iptables_command_state(struct nft_rule *r,
-				   struct iptables_command_state *cs)
+void nft_rule_to_iptables_command_state(struct nft_rule *r,
+					struct iptables_command_state *cs)
 {
 	struct nft_to_cs_data i2cs = {};
 
@@ -1957,13 +1752,12 @@ nft_rule_find(struct nft_rule_list *list, const char *chain, const char *table,
 			break;
 		} else {
 			/* Delete by matching rule case */
+			nft_rule_to_iptables_command_state(r, &this);
+
 			DEBUGP("comparing with... ");
 #ifdef DEBUG_DEL
-			nft_rule_print_save(r, NFT_RULE_APPEND, 0);
+			nft_rule_print_save(&this, r, NFT_RULE_APPEND, 0);
 #endif
-
-			nft_rule_to_iptables_command_state(r, &this);
-
 			if (!ops->is_same(cs, &this))
 				goto next;
 
@@ -2406,7 +2200,7 @@ static void
 list_save(const struct iptables_command_state *cs, struct nft_rule *r,
 	  unsigned int num, unsigned int format)
 {
-	nft_rule_print_save(r, NFT_RULE_APPEND, !(format & FMT_NOCOUNTS));
+	nft_rule_print_save(cs, r, NFT_RULE_APPEND, format);
 }
 
 static int
@@ -2710,7 +2504,7 @@ static struct nft_trans_instruction nft_ipt_ip_addr_2 = {
 	.function = nft_parse_ip_addresses,
 };
 
-static void initiate_nft_translation_tree(void)
+void nft_initiate_translation_tree(void)
 {
 	xt_nft_tree = nft_trans_instruction_tree_new();
 	if (xt_nft_tree == NULL)
diff --git a/iptables/nft.h b/iptables/nft.h
index 7a6351b..c904e21 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -65,7 +65,13 @@ enum nft_rule_print {
 	NFT_RULE_DEL,
 };
 
-void nft_rule_print_save(struct nft_rule *r, enum nft_rule_print type, bool counters);
+void nft_initiate_translation_tree(void);
+void
+nft_rule_to_iptables_command_state(struct nft_rule *r,
+				   struct iptables_command_state *cs);
+void nft_rule_print_save(const struct iptables_command_state *cs,
+			 struct nft_rule *r, enum nft_rule_print type,
+			 unsigned int format);
 
 /*
  * global commit and abort
diff --git a/iptables/xtables-events.c b/iptables/xtables-events.c
index 64ae972..220a28e 100644
--- a/iptables/xtables-events.c
+++ b/iptables/xtables-events.c
@@ -58,6 +58,7 @@ static bool counters;
 
 static int rule_cb(const struct nlmsghdr *nlh, int type)
 {
+	struct iptables_command_state cs = {};
 	struct nft_rule *r;
 
 	r = nft_rule_alloc();
@@ -71,20 +72,12 @@ static int rule_cb(const struct nlmsghdr *nlh, int type)
 		goto err_free;
 	}
 
-	switch(nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY)) {
-	case AF_INET:
-		printf("-4 ");
-		break;
-	case AF_INET6:
-		printf("-6 ");
-		break;
-	default:
-		break;
-	}
+	nft_rule_to_iptables_command_state(r, &cs);
 
-	nft_rule_print_save(r, type == NFT_MSG_NEWRULE ? NFT_RULE_APPEND :
-							 NFT_RULE_DEL,
-			    counters);
+	nft_rule_print_save(&cs, r,
+				type == NFT_MSG_NEWRULE ?
+					NFT_RULE_APPEND : NFT_RULE_DEL,
+				counters ? 0 : FMT_NOCOUNTS);
 err_free:
 	nft_rule_free(r);
 err:
@@ -195,6 +188,8 @@ int xtables_events_main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
+	nft_initiate_translation_tree();
+
 	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
 	while (ret > 0) {
 		ret = mnl_cb_run(buf, ret, 0, 0, events_cb, NULL);
-- 
1.8.3.2

