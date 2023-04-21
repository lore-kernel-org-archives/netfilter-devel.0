Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77B22C77B7F
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Apr 2023 17:40:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbjDURkH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Apr 2023 13:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233170AbjDURkD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Apr 2023 13:40:03 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D718C1258D
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Apr 2023 10:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NngMboLe69LKcRNwzNViWaNjkid+HHVnFFpXkOCchqM=; b=fYg+SbAzvl7iUkLjZuLX2oCbq3
        471GFy5pXgwH+4mjLGdxUfQMZ8YnlGtib7zp+66AX5Pz7TrBpwumBKTE6yuQINT0GxUCymnKWVunL
        IEiXKL6iXyMHXaRnqKgAnLSjlwgCYJk+01ubaI8flRDeARrVaaPpjGcfItzo8lV1czPv4A+ONhYiG
        TJ/Q9LU89oOifhCG1QZiFZPlfnoyskOapswc8MLnAXJbWnGp/ryFfDQTep77hcyMWbZ/JC7AJOuaq
        NIVnrSgQV3tAzXhjIr9vUAF/q3uaqYiNVXQMJHmTbfKVfn1CX5qzorFZXEewIGleaKIRRrC/M7Cv4
        832OlLwQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1ppujj-00086N-QB; Fri, 21 Apr 2023 19:39:55 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 3/3] nft: ruleparse: Create family-specific source files
Date:   Fri, 21 Apr 2023 19:40:14 +0200
Message-Id: <20230421174014.17014-4-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230421174014.17014-1-phil@nwl.cc>
References: <20230421174014.17014-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Extract the remaining nftnl rule parsing code from
nft-<family>.c sources into dedicated ones to complete the separation.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/Makefile.am            |   2 +
 iptables/nft-arp.c              | 140 -----------
 iptables/nft-bridge.c           | 392 -----------------------------
 iptables/nft-cache.h            |   2 +
 iptables/nft-ipv4.c             | 108 --------
 iptables/nft-ipv6.c             |  85 -------
 iptables/nft-ruleparse-arp.c    | 168 +++++++++++++
 iptables/nft-ruleparse-bridge.c | 422 ++++++++++++++++++++++++++++++++
 iptables/nft-ruleparse-ipv4.c   | 135 ++++++++++
 iptables/nft-ruleparse-ipv6.c   | 112 +++++++++
 iptables/nft-ruleparse.h        |   5 +
 11 files changed, 846 insertions(+), 725 deletions(-)
 create mode 100644 iptables/nft-ruleparse-arp.c
 create mode 100644 iptables/nft-ruleparse-bridge.c
 create mode 100644 iptables/nft-ruleparse-ipv4.c
 create mode 100644 iptables/nft-ruleparse-ipv6.c

diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index d5922da6a2d84..8a7227024987f 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -47,6 +47,8 @@ xtables_nft_multi_SOURCES += nft.c nft.h \
 			     nft-chain.c nft-chain.h \
 			     nft-cmd.c nft-cmd.h \
 			     nft-ruleparse.c nft-ruleparse.h \
+			     nft-ruleparse-arp.c nft-ruleparse-bridge.c \
+			     nft-ruleparse-ipv4.c nft-ruleparse-ipv6.c \
 			     nft-shared.c nft-shared.h \
 			     xtables-monitor.c \
 			     xtables.c xtables-arp.c xtables-eb.c \
diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 7c7122374bb63..ecb05472c62ae 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -160,141 +160,6 @@ static int nft_arp_add(struct nft_handle *h, struct nftnl_rule *r,
 	return ret;
 }
 
-static void nft_arp_parse_meta(struct nft_xt_ctx *ctx,
-			       const struct nft_xt_ctx_reg *reg,
-			       struct nftnl_expr *e,
-			       struct iptables_command_state *cs)
-{
-	struct arpt_entry *fw = &cs->arp;
-	uint8_t flags = 0;
-
-	if (parse_meta(ctx, e, reg->meta_dreg.key, fw->arp.iniface, fw->arp.iniface_mask,
-		   fw->arp.outiface, fw->arp.outiface_mask,
-		   &flags) == 0) {
-		fw->arp.invflags |= flags;
-		return;
-	}
-
-	ctx->errmsg = "Unknown arp meta key";
-}
-
-static void parse_mask_ipv4(const struct nft_xt_ctx_reg *reg, struct in_addr *mask)
-{
-	mask->s_addr = reg->bitwise.mask[0];
-}
-
-static bool nft_arp_parse_devaddr(const struct nft_xt_ctx_reg *reg,
-				  struct nftnl_expr *e,
-				  struct arpt_devaddr_info *info)
-{
-	uint32_t hlen;
-	bool inv;
-
-	nftnl_expr_get(e, NFTNL_EXPR_CMP_DATA, &hlen);
-
-	if (hlen != ETH_ALEN)
-		return false;
-
-	get_cmp_data(e, info->addr, ETH_ALEN, &inv);
-
-	if (reg->bitwise.set)
-		memcpy(info->mask, reg->bitwise.mask, ETH_ALEN);
-	else
-		memset(info->mask, 0xff,
-		       min(reg->payload.len, ETH_ALEN));
-
-	return inv;
-}
-
-static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
-				  const struct nft_xt_ctx_reg *reg,
-				  struct nftnl_expr *e,
-				  struct iptables_command_state *cs)
-{
-	struct arpt_entry *fw = &cs->arp;
-	struct in_addr addr;
-	uint16_t ar_hrd, ar_pro, ar_op;
-	uint8_t ar_hln, ar_pln;
-	bool inv;
-
-	switch (reg->payload.offset) {
-	case offsetof(struct arphdr, ar_hrd):
-		get_cmp_data(e, &ar_hrd, sizeof(ar_hrd), &inv);
-		fw->arp.arhrd = ar_hrd;
-		fw->arp.arhrd_mask = 0xffff;
-		if (inv)
-			fw->arp.invflags |= IPT_INV_ARPHRD;
-		break;
-	case offsetof(struct arphdr, ar_pro):
-		get_cmp_data(e, &ar_pro, sizeof(ar_pro), &inv);
-		fw->arp.arpro = ar_pro;
-		fw->arp.arpro_mask = 0xffff;
-		if (inv)
-			fw->arp.invflags |= IPT_INV_PROTO;
-		break;
-	case offsetof(struct arphdr, ar_op):
-		get_cmp_data(e, &ar_op, sizeof(ar_op), &inv);
-		fw->arp.arpop = ar_op;
-		fw->arp.arpop_mask = 0xffff;
-		if (inv)
-			fw->arp.invflags |= IPT_INV_ARPOP;
-		break;
-	case offsetof(struct arphdr, ar_hln):
-		get_cmp_data(e, &ar_hln, sizeof(ar_hln), &inv);
-		fw->arp.arhln = ar_hln;
-		fw->arp.arhln_mask = 0xff;
-		if (inv)
-			fw->arp.invflags |= IPT_INV_ARPOP;
-		break;
-	case offsetof(struct arphdr, ar_pln):
-		get_cmp_data(e, &ar_pln, sizeof(ar_pln), &inv);
-		if (ar_pln != 4 || inv)
-			ctx->errmsg = "unexpected ARP protocol length match";
-		break;
-	default:
-		if (reg->payload.offset == sizeof(struct arphdr)) {
-			if (nft_arp_parse_devaddr(reg, e, &fw->arp.src_devaddr))
-				fw->arp.invflags |= IPT_INV_SRCDEVADDR;
-		} else if (reg->payload.offset == sizeof(struct arphdr) +
-					   fw->arp.arhln) {
-			get_cmp_data(e, &addr, sizeof(addr), &inv);
-			fw->arp.src.s_addr = addr.s_addr;
-			if (reg->bitwise.set)
-				parse_mask_ipv4(reg, &fw->arp.smsk);
-			else
-				memset(&fw->arp.smsk, 0xff,
-				       min(reg->payload.len,
-					   sizeof(struct in_addr)));
-
-			if (inv)
-				fw->arp.invflags |= IPT_INV_SRCIP;
-		} else if (reg->payload.offset == sizeof(struct arphdr) +
-						  fw->arp.arhln +
-						  sizeof(struct in_addr)) {
-			if (nft_arp_parse_devaddr(reg, e, &fw->arp.tgt_devaddr))
-				fw->arp.invflags |= IPT_INV_TGTDEVADDR;
-		} else if (reg->payload.offset == sizeof(struct arphdr) +
-						  fw->arp.arhln +
-						  sizeof(struct in_addr) +
-						  fw->arp.arhln) {
-			get_cmp_data(e, &addr, sizeof(addr), &inv);
-			fw->arp.tgt.s_addr = addr.s_addr;
-			if (reg->bitwise.set)
-				parse_mask_ipv4(reg, &fw->arp.tmsk);
-			else
-				memset(&fw->arp.tmsk, 0xff,
-				       min(reg->payload.len,
-					   sizeof(struct in_addr)));
-
-			if (inv)
-				fw->arp.invflags |= IPT_INV_DSTIP;
-		} else {
-			ctx->errmsg = "unknown payload offset";
-		}
-		break;
-	}
-}
-
 static void nft_arp_print_header(unsigned int format, const char *chain,
 				 const char *pol,
 				 const struct xt_counters *counters,
@@ -779,11 +644,6 @@ nft_arp_replace_entry(struct nft_handle *h,
 	return nft_cmd_rule_replace(h, chain, table, cs, rulenum, verbose);
 }
 
-static struct nft_ruleparse_ops nft_ruleparse_ops_arp = {
-	.meta		= nft_arp_parse_meta,
-	.payload	= nft_arp_parse_payload,
-	.target		= nft_ipv46_parse_target,
-};
 struct nft_family_ops nft_family_ops_arp = {
 	.add			= nft_arp_add,
 	.is_same		= nft_arp_is_same,
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 0c9e1238f4c21..f3dfa488c6202 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -231,390 +231,6 @@ static int nft_bridge_add(struct nft_handle *h,
 	return _add_action(r, cs);
 }
 
-static void nft_bridge_parse_meta(struct nft_xt_ctx *ctx,
-				  const struct nft_xt_ctx_reg *reg,
-				  struct nftnl_expr *e,
-				  struct iptables_command_state *cs)
-{
-	struct ebt_entry *fw = &cs->eb;
-	uint8_t invflags = 0;
-	char iifname[IFNAMSIZ] = {}, oifname[IFNAMSIZ] = {};
-
-	switch (reg->meta_dreg.key) {
-	case NFT_META_PROTOCOL:
-		return;
-	}
-
-	if (parse_meta(ctx, e, reg->meta_dreg.key, iifname, NULL, oifname, NULL, &invflags) < 0) {
-		ctx->errmsg = "unknown meta key";
-		return;
-	}
-
-	switch (reg->meta_dreg.key) {
-	case NFT_META_BRI_IIFNAME:
-		if (invflags & IPT_INV_VIA_IN)
-			cs->eb.invflags |= EBT_ILOGICALIN;
-		snprintf(fw->logical_in, sizeof(fw->logical_in), "%s", iifname);
-		break;
-	case NFT_META_IIFNAME:
-		if (invflags & IPT_INV_VIA_IN)
-			cs->eb.invflags |= EBT_IIN;
-		snprintf(fw->in, sizeof(fw->in), "%s", iifname);
-		break;
-	case NFT_META_BRI_OIFNAME:
-		if (invflags & IPT_INV_VIA_OUT)
-			cs->eb.invflags |= EBT_ILOGICALOUT;
-		snprintf(fw->logical_out, sizeof(fw->logical_out), "%s", oifname);
-		break;
-	case NFT_META_OIFNAME:
-		if (invflags & IPT_INV_VIA_OUT)
-			cs->eb.invflags |= EBT_IOUT;
-		snprintf(fw->out, sizeof(fw->out), "%s", oifname);
-		break;
-	default:
-		ctx->errmsg = "unknown bridge meta key";
-		break;
-	}
-}
-
-static void nft_bridge_parse_payload(struct nft_xt_ctx *ctx,
-				     const struct nft_xt_ctx_reg *reg,
-				     struct nftnl_expr *e,
-				     struct iptables_command_state *cs)
-{
-	struct ebt_entry *fw = &cs->eb;
-	unsigned char addr[ETH_ALEN];
-	unsigned short int ethproto;
-	uint8_t op;
-	bool inv;
-	int i;
-
-	switch (reg->payload.offset) {
-	case offsetof(struct ethhdr, h_dest):
-		get_cmp_data(e, addr, sizeof(addr), &inv);
-		for (i = 0; i < ETH_ALEN; i++)
-			fw->destmac[i] = addr[i];
-		if (inv)
-			fw->invflags |= EBT_IDEST;
-
-		if (reg->bitwise.set)
-                        memcpy(fw->destmsk, reg->bitwise.mask, ETH_ALEN);
-                else
-			memset(&fw->destmsk, 0xff,
-			       min(reg->payload.len, ETH_ALEN));
-		fw->bitmask |= EBT_IDEST;
-		break;
-	case offsetof(struct ethhdr, h_source):
-		get_cmp_data(e, addr, sizeof(addr), &inv);
-		for (i = 0; i < ETH_ALEN; i++)
-			fw->sourcemac[i] = addr[i];
-		if (inv)
-			fw->invflags |= EBT_ISOURCE;
-		if (reg->bitwise.set)
-                        memcpy(fw->sourcemsk, reg->bitwise.mask, ETH_ALEN);
-                else
-			memset(&fw->sourcemsk, 0xff,
-			       min(reg->payload.len, ETH_ALEN));
-		fw->bitmask |= EBT_ISOURCE;
-		break;
-	case offsetof(struct ethhdr, h_proto):
-		__get_cmp_data(e, &ethproto, sizeof(ethproto), &op);
-		if (ethproto == htons(0x0600)) {
-			fw->bitmask |= EBT_802_3;
-			inv = (op == NFT_CMP_GTE);
-		} else {
-			fw->ethproto = ethproto;
-			inv = (op == NFT_CMP_NEQ);
-		}
-		if (inv)
-			fw->invflags |= EBT_IPROTO;
-		fw->bitmask &= ~EBT_NOPROTO;
-		break;
-	default:
-		DEBUGP("unknown payload offset %d\n", reg->payload.offset);
-		ctx->errmsg = "unknown payload offset";
-		break;
-	}
-}
-
-/* return 0 if saddr, 1 if daddr, -1 on error */
-static int
-lookup_check_ether_payload(uint32_t base, uint32_t offset, uint32_t len)
-{
-	if (base != 0 || len != ETH_ALEN)
-		return -1;
-
-	switch (offset) {
-	case offsetof(struct ether_header, ether_dhost):
-		return 1;
-	case offsetof(struct ether_header, ether_shost):
-		return 0;
-	default:
-		return -1;
-	}
-}
-
-/* return 0 if saddr, 1 if daddr, -1 on error */
-static int
-lookup_check_iphdr_payload(uint32_t base, uint32_t offset, uint32_t len)
-{
-	if (base != 1 || len != 4)
-		return -1;
-
-	switch (offset) {
-	case offsetof(struct iphdr, daddr):
-		return 1;
-	case offsetof(struct iphdr, saddr):
-		return 0;
-	default:
-		return -1;
-	}
-}
-
-/* Make sure previous payload expression(s) is/are consistent and extract if
- * matching on source or destination address and if matching on MAC and IP or
- * only MAC address. */
-static int lookup_analyze_payloads(struct nft_xt_ctx *ctx,
-				   enum nft_registers sreg,
-				   uint32_t key_len,
-				   bool *dst, bool *ip)
-{
-	const struct nft_xt_ctx_reg *reg;
-	int val, val2 = -1;
-
-	reg = nft_xt_ctx_get_sreg(ctx, sreg);
-	if (!reg)
-		return -1;
-
-	if (reg->type != NFT_XT_REG_PAYLOAD) {
-		ctx->errmsg = "lookup reg is not payload type";
-		return -1;
-	}
-
-	switch (key_len) {
-	case 12: /* ether + ipv4addr */
-		val = lookup_check_ether_payload(reg->payload.base,
-						 reg->payload.offset,
-						 reg->payload.len);
-		if (val < 0) {
-			DEBUGP("unknown payload base/offset/len %d/%d/%d\n",
-			       reg->payload.base, reg->payload.offset,
-			       reg->payload.len);
-			return -1;
-		}
-
-		sreg = nft_get_next_reg(sreg, ETH_ALEN);
-
-		reg = nft_xt_ctx_get_sreg(ctx, sreg);
-		if (!reg) {
-			ctx->errmsg = "next lookup register is invalid";
-			return -1;
-		}
-
-		if (reg->type != NFT_XT_REG_PAYLOAD) {
-			ctx->errmsg = "next lookup reg is not payload type";
-			return -1;
-		}
-
-		val2 = lookup_check_iphdr_payload(reg->payload.base,
-						  reg->payload.offset,
-						  reg->payload.len);
-		if (val2 < 0) {
-			DEBUGP("unknown payload base/offset/len %d/%d/%d\n",
-			       reg->payload.base, reg->payload.offset,
-			       reg->payload.len);
-			return -1;
-		} else if (val != val2) {
-			DEBUGP("mismatching payload match offsets\n");
-			return -1;
-		}
-		break;
-	case 6: /* ether */
-		val = lookup_check_ether_payload(reg->payload.base,
-						 reg->payload.offset,
-						 reg->payload.len);
-		if (val < 0) {
-			DEBUGP("unknown payload base/offset/len %d/%d/%d\n",
-			       reg->payload.base, reg->payload.offset,
-			       reg->payload.len);
-			return -1;
-		}
-		break;
-	default:
-		ctx->errmsg = "unsupported lookup key length";
-		return -1;
-	}
-
-	if (dst)
-		*dst = (val == 1);
-	if (ip)
-		*ip = (val2 != -1);
-	return 0;
-}
-
-static int set_elems_to_among_pairs(struct nft_among_pair *pairs,
-				    const struct nftnl_set *s, int cnt)
-{
-	struct nftnl_set_elems_iter *iter = nftnl_set_elems_iter_create(s);
-	struct nftnl_set_elem *elem;
-	size_t tmpcnt = 0;
-	const void *data;
-	uint32_t datalen;
-	int ret = -1;
-
-	if (!iter) {
-		fprintf(stderr, "BUG: set elems iter allocation failed\n");
-		return ret;
-	}
-
-	while ((elem = nftnl_set_elems_iter_next(iter))) {
-		data = nftnl_set_elem_get(elem, NFTNL_SET_ELEM_KEY, &datalen);
-		if (!data) {
-			fprintf(stderr, "BUG: set elem without key\n");
-			goto err;
-		}
-		if (datalen > sizeof(*pairs)) {
-			fprintf(stderr, "BUG: overlong set elem\n");
-			goto err;
-		}
-		nft_among_insert_pair(pairs, &tmpcnt, data);
-	}
-	ret = 0;
-err:
-	nftnl_set_elems_iter_destroy(iter);
-	return ret;
-}
-
-static struct nftnl_set *set_from_lookup_expr(struct nft_xt_ctx *ctx,
-					      const struct nftnl_expr *e)
-{
-	const char *set_name = nftnl_expr_get_str(e, NFTNL_EXPR_LOOKUP_SET);
-	uint32_t set_id = nftnl_expr_get_u32(e, NFTNL_EXPR_LOOKUP_SET_ID);
-	struct nftnl_set_list *slist;
-	struct nftnl_set *set;
-
-	slist = nft_set_list_get(ctx->h, ctx->table, set_name);
-	if (slist) {
-		set = nftnl_set_list_lookup_byname(slist, set_name);
-		if (set)
-			return set;
-
-		set = nft_set_batch_lookup_byid(ctx->h, set_id);
-		if (set)
-			return set;
-	}
-
-	return NULL;
-}
-
-static void nft_bridge_parse_lookup(struct nft_xt_ctx *ctx,
-				    struct nftnl_expr *e)
-{
-	struct xtables_match *match = NULL;
-	struct nft_among_data *among_data;
-	bool is_dst, have_ip, inv;
-	struct ebt_match *ematch;
-	struct nftnl_set *s;
-	size_t poff, size;
-	uint32_t cnt;
-
-	s = set_from_lookup_expr(ctx, e);
-	if (!s)
-		xtables_error(OTHER_PROBLEM,
-			      "BUG: lookup expression references unknown set");
-
-	if (lookup_analyze_payloads(ctx,
-				    nftnl_expr_get_u32(e, NFTNL_EXPR_LOOKUP_SREG),
-				    nftnl_set_get_u32(s, NFTNL_SET_KEY_LEN),
-				    &is_dst, &have_ip))
-		return;
-
-	cnt = nftnl_set_get_u32(s, NFTNL_SET_DESC_SIZE);
-
-	for (ematch = ctx->cs->match_list; ematch; ematch = ematch->next) {
-		if (!ematch->ismatch || strcmp(ematch->u.match->name, "among"))
-			continue;
-
-		match = ematch->u.match;
-		among_data = (struct nft_among_data *)match->m->data;
-
-		size = cnt + among_data->src.cnt + among_data->dst.cnt;
-		size *= sizeof(struct nft_among_pair);
-
-		size += XT_ALIGN(sizeof(struct xt_entry_match)) +
-			sizeof(struct nft_among_data);
-
-		match->m = xtables_realloc(match->m, size);
-		break;
-	}
-	if (!match) {
-		match = xtables_find_match("among", XTF_TRY_LOAD,
-					   &ctx->cs->matches);
-
-		size = cnt * sizeof(struct nft_among_pair);
-		size += XT_ALIGN(sizeof(struct xt_entry_match)) +
-			sizeof(struct nft_among_data);
-
-		match->m = xtables_calloc(1, size);
-		strcpy(match->m->u.user.name, match->name);
-		match->m->u.user.revision = match->revision;
-		xs_init_match(match);
-
-		if (ctx->h->ops->rule_parse->match != NULL)
-			ctx->h->ops->rule_parse->match(match, ctx->cs);
-	}
-	if (!match)
-		return;
-
-	match->m->u.match_size = size;
-
-	inv = !!(nftnl_expr_get_u32(e, NFTNL_EXPR_LOOKUP_FLAGS) &
-				    NFT_LOOKUP_F_INV);
-
-	among_data = (struct nft_among_data *)match->m->data;
-	poff = nft_among_prepare_data(among_data, is_dst, cnt, inv, have_ip);
-	if (set_elems_to_among_pairs(among_data->pairs + poff, s, cnt))
-		xtables_error(OTHER_PROBLEM,
-			      "ebtables among pair parsing failed");
-}
-
-static void parse_watcher(void *object, struct ebt_match **match_list,
-			  bool ismatch)
-{
-	struct ebt_match *m = xtables_calloc(1, sizeof(struct ebt_match));
-
-	if (ismatch)
-		m->u.match = object;
-	else
-		m->u.watcher = object;
-
-	m->ismatch = ismatch;
-	if (*match_list == NULL)
-		*match_list = m;
-	else
-		(*match_list)->next = m;
-}
-
-static void nft_bridge_parse_match(struct xtables_match *m,
-				   struct iptables_command_state *cs)
-{
-	parse_watcher(m, &cs->match_list, true);
-}
-
-static void nft_bridge_parse_target(struct xtables_target *t,
-				    struct iptables_command_state *cs)
-{
-	/* harcoded names :-( */
-	if (strcmp(t->name, "log") == 0 ||
-	    strcmp(t->name, "nflog") == 0) {
-		parse_watcher(t, &cs->match_list, false);
-		return;
-	}
-
-	cs->target = t;
-	cs->jumpto = t->name;
-}
-
 static bool nft_rule_to_ebtables_command_state(struct nft_handle *h,
 					       const struct nftnl_rule *r,
 					       struct iptables_command_state *cs)
@@ -984,14 +600,6 @@ static int nft_bridge_xlate(const struct iptables_command_state *cs,
 	return ret;
 }
 
-static struct nft_ruleparse_ops nft_ruleparse_ops_bridge = {
-	.meta		= nft_bridge_parse_meta,
-	.payload	= nft_bridge_parse_payload,
-	.lookup		= nft_bridge_parse_lookup,
-	.match		= nft_bridge_parse_match,
-	.target		= nft_bridge_parse_target,
-};
-
 struct nft_family_ops nft_family_ops_bridge = {
 	.add			= nft_bridge_add,
 	.is_same		= nft_bridge_is_same,
diff --git a/iptables/nft-cache.h b/iptables/nft-cache.h
index 58a015265056c..29ec6b5c3232b 100644
--- a/iptables/nft-cache.h
+++ b/iptables/nft-cache.h
@@ -1,6 +1,8 @@
 #ifndef _NFT_CACHE_H_
 #define _NFT_CACHE_H_
 
+#include <libnftnl/chain.h>
+
 struct nft_handle;
 struct nft_chain;
 struct nft_cmd;
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 3f769e88663ac..6df4e46bc3773 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -115,108 +115,6 @@ static bool nft_ipv4_is_same(const struct iptables_command_state *a,
 				  b->fw.ip.iniface_mask, b->fw.ip.outiface_mask);
 }
 
-static bool get_frag(const struct nft_xt_ctx_reg *reg, struct nftnl_expr *e)
-{
-	uint8_t op;
-
-	/* we assume correct mask and xor */
-	if (!reg->bitwise.set)
-		return false;
-
-	/* we assume correct data */
-	op = nftnl_expr_get_u32(e, NFTNL_EXPR_CMP_OP);
-	if (op == NFT_CMP_EQ)
-		return true;
-
-	return false;
-}
-
-static void nft_ipv4_parse_meta(struct nft_xt_ctx *ctx,
-				const struct nft_xt_ctx_reg *reg,
-				struct nftnl_expr *e,
-				struct iptables_command_state *cs)
-{
-	switch (reg->meta_dreg.key) {
-	case NFT_META_L4PROTO:
-		cs->fw.ip.proto = nftnl_expr_get_u8(e, NFTNL_EXPR_CMP_DATA);
-		if (nftnl_expr_get_u32(e, NFTNL_EXPR_CMP_OP) == NFT_CMP_NEQ)
-			cs->fw.ip.invflags |= XT_INV_PROTO;
-		return;
-	default:
-		break;
-	}
-
-	if (parse_meta(ctx, e, reg->meta_dreg.key, cs->fw.ip.iniface, cs->fw.ip.iniface_mask,
-		   cs->fw.ip.outiface, cs->fw.ip.outiface_mask,
-		   &cs->fw.ip.invflags) == 0)
-		return;
-
-	ctx->errmsg = "unknown ipv4 meta key";
-}
-
-static void parse_mask_ipv4(const struct nft_xt_ctx_reg *sreg, struct in_addr *mask)
-{
-	mask->s_addr = sreg->bitwise.mask[0];
-}
-
-static void nft_ipv4_parse_payload(struct nft_xt_ctx *ctx,
-				   const struct nft_xt_ctx_reg *sreg,
-				   struct nftnl_expr *e,
-				   struct iptables_command_state *cs)
-{
-	struct in_addr addr;
-	uint8_t proto;
-	bool inv;
-
-	switch (sreg->payload.offset) {
-	case offsetof(struct iphdr, saddr):
-		get_cmp_data(e, &addr, sizeof(addr), &inv);
-		cs->fw.ip.src.s_addr = addr.s_addr;
-		if (sreg->bitwise.set) {
-			parse_mask_ipv4(sreg, &cs->fw.ip.smsk);
-		} else {
-			memset(&cs->fw.ip.smsk, 0xff,
-			       min(sreg->payload.len, sizeof(struct in_addr)));
-		}
-
-		if (inv)
-			cs->fw.ip.invflags |= IPT_INV_SRCIP;
-		break;
-	case offsetof(struct iphdr, daddr):
-		get_cmp_data(e, &addr, sizeof(addr), &inv);
-		cs->fw.ip.dst.s_addr = addr.s_addr;
-		if (sreg->bitwise.set)
-			parse_mask_ipv4(sreg, &cs->fw.ip.dmsk);
-		else
-			memset(&cs->fw.ip.dmsk, 0xff,
-			       min(sreg->payload.len, sizeof(struct in_addr)));
-
-		if (inv)
-			cs->fw.ip.invflags |= IPT_INV_DSTIP;
-		break;
-	case offsetof(struct iphdr, protocol):
-		get_cmp_data(e, &proto, sizeof(proto), &inv);
-		cs->fw.ip.proto = proto;
-		if (inv)
-			cs->fw.ip.invflags |= IPT_INV_PROTO;
-		break;
-	case offsetof(struct iphdr, frag_off):
-		cs->fw.ip.flags |= IPT_F_FRAG;
-		inv = get_frag(sreg, e);
-		if (inv)
-			cs->fw.ip.invflags |= IPT_INV_FRAG;
-		break;
-	case offsetof(struct iphdr, ttl):
-		if (nft_parse_hl(ctx, e, cs) < 0)
-			ctx->errmsg = "invalid ttl field match";
-		break;
-	default:
-		DEBUGP("unknown payload offset %d\n", sreg->payload.offset);
-		ctx->errmsg = "unknown payload offset";
-		break;
-	}
-}
-
 static void nft_ipv4_set_goto_flag(struct iptables_command_state *cs)
 {
 	cs->fw.ip.flags |= IPT_F_GOTO;
@@ -440,12 +338,6 @@ nft_ipv4_replace_entry(struct nft_handle *h,
 	return nft_cmd_rule_replace(h, chain, table, cs, rulenum, verbose);
 }
 
-static struct nft_ruleparse_ops nft_ruleparse_ops_ipv4 = {
-	.meta		= nft_ipv4_parse_meta,
-	.payload	= nft_ipv4_parse_payload,
-	.target		= nft_ipv46_parse_target,
-};
-
 struct nft_family_ops nft_family_ops_ipv4 = {
 	.add			= nft_ipv4_add,
 	.is_same		= nft_ipv4_is_same,
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 962aaf0d13831..693a1c87b997d 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -104,85 +104,6 @@ static bool nft_ipv6_is_same(const struct iptables_command_state *a,
 				  b->fw6.ipv6.outiface_mask);
 }
 
-static void nft_ipv6_parse_meta(struct nft_xt_ctx *ctx,
-				const struct nft_xt_ctx_reg *reg,
-				struct nftnl_expr *e,
-				struct iptables_command_state *cs)
-{
-	switch (reg->meta_dreg.key) {
-	case NFT_META_L4PROTO:
-		cs->fw6.ipv6.proto = nftnl_expr_get_u8(e, NFTNL_EXPR_CMP_DATA);
-		if (nftnl_expr_get_u32(e, NFTNL_EXPR_CMP_OP) == NFT_CMP_NEQ)
-			cs->fw6.ipv6.invflags |= XT_INV_PROTO;
-		return;
-	default:
-		break;
-	}
-
-	if (parse_meta(ctx, e, reg->meta_dreg.key, cs->fw6.ipv6.iniface,
-		   cs->fw6.ipv6.iniface_mask, cs->fw6.ipv6.outiface,
-		   cs->fw6.ipv6.outiface_mask, &cs->fw6.ipv6.invflags) == 0)
-		return;
-
-	ctx->errmsg = "unknown ipv6 meta key";
-}
-
-static void parse_mask_ipv6(const struct nft_xt_ctx_reg *reg,
-			    struct in6_addr *mask)
-{
-	memcpy(mask, reg->bitwise.mask, sizeof(struct in6_addr));
-}
-
-static void nft_ipv6_parse_payload(struct nft_xt_ctx *ctx,
-				   const struct nft_xt_ctx_reg *reg,
-				   struct nftnl_expr *e,
-				   struct iptables_command_state *cs)
-{
-	struct in6_addr addr;
-	uint8_t proto;
-	bool inv;
-
-	switch (reg->payload.offset) {
-	case offsetof(struct ip6_hdr, ip6_src):
-		get_cmp_data(e, &addr, sizeof(addr), &inv);
-		memcpy(cs->fw6.ipv6.src.s6_addr, &addr, sizeof(addr));
-		if (reg->bitwise.set)
-			parse_mask_ipv6(reg, &cs->fw6.ipv6.smsk);
-		else
-			memset(&cs->fw6.ipv6.smsk, 0xff,
-			       min(reg->payload.len, sizeof(struct in6_addr)));
-
-		if (inv)
-			cs->fw6.ipv6.invflags |= IP6T_INV_SRCIP;
-		break;
-	case offsetof(struct ip6_hdr, ip6_dst):
-		get_cmp_data(e, &addr, sizeof(addr), &inv);
-		memcpy(cs->fw6.ipv6.dst.s6_addr, &addr, sizeof(addr));
-		if (reg->bitwise.set)
-			parse_mask_ipv6(reg, &cs->fw6.ipv6.dmsk);
-		else
-			memset(&cs->fw6.ipv6.dmsk, 0xff,
-			       min(reg->payload.len, sizeof(struct in6_addr)));
-
-		if (inv)
-			cs->fw6.ipv6.invflags |= IP6T_INV_DSTIP;
-		break;
-	case offsetof(struct ip6_hdr, ip6_nxt):
-		get_cmp_data(e, &proto, sizeof(proto), &inv);
-		cs->fw6.ipv6.proto = proto;
-		if (inv)
-			cs->fw6.ipv6.invflags |= IP6T_INV_PROTO;
-	case offsetof(struct ip6_hdr, ip6_hlim):
-		if (nft_parse_hl(ctx, e, cs) < 0)
-			ctx->errmsg = "invalid ttl field match";
-		break;
-	default:
-		DEBUGP("unknown payload offset %d\n", reg->payload.offset);
-		ctx->errmsg = "unknown payload offset";
-		break;
-	}
-}
-
 static void nft_ipv6_set_goto_flag(struct iptables_command_state *cs)
 {
 	cs->fw6.ipv6.flags |= IP6T_F_GOTO;
@@ -409,12 +330,6 @@ nft_ipv6_replace_entry(struct nft_handle *h,
 	return nft_cmd_rule_replace(h, chain, table, cs, rulenum, verbose);
 }
 
-static struct nft_ruleparse_ops nft_ruleparse_ops_ipv6 = {
-	.meta		= nft_ipv6_parse_meta,
-	.payload	= nft_ipv6_parse_payload,
-	.target		= nft_ipv46_parse_target,
-};
-
 struct nft_family_ops nft_family_ops_ipv6 = {
 	.add			= nft_ipv6_add,
 	.is_same		= nft_ipv6_is_same,
diff --git a/iptables/nft-ruleparse-arp.c b/iptables/nft-ruleparse-arp.c
new file mode 100644
index 0000000000000..2538b04e676ce
--- /dev/null
+++ b/iptables/nft-ruleparse-arp.c
@@ -0,0 +1,168 @@
+/*
+ * (C) 2013 by Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2013 by Giuseppe Longo <giuseppelng@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
+ */
+
+#include <stddef.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <netdb.h>
+#include <net/if.h>
+#include <net/if_arp.h>
+#include <netinet/if_ether.h>
+
+#include <libnftnl/rule.h>
+#include <libnftnl/expr.h>
+
+#include "nft-shared.h"
+#include "nft-ruleparse.h"
+#include "xshared.h"
+
+static void nft_arp_parse_meta(struct nft_xt_ctx *ctx,
+			       const struct nft_xt_ctx_reg *reg,
+			       struct nftnl_expr *e,
+			       struct iptables_command_state *cs)
+{
+	struct arpt_entry *fw = &cs->arp;
+	uint8_t flags = 0;
+
+	if (parse_meta(ctx, e, reg->meta_dreg.key, fw->arp.iniface, fw->arp.iniface_mask,
+		   fw->arp.outiface, fw->arp.outiface_mask,
+		   &flags) == 0) {
+		fw->arp.invflags |= flags;
+		return;
+	}
+
+	ctx->errmsg = "Unknown arp meta key";
+}
+
+static void parse_mask_ipv4(const struct nft_xt_ctx_reg *reg, struct in_addr *mask)
+{
+	mask->s_addr = reg->bitwise.mask[0];
+}
+
+static bool nft_arp_parse_devaddr(const struct nft_xt_ctx_reg *reg,
+				  struct nftnl_expr *e,
+				  struct arpt_devaddr_info *info)
+{
+	uint32_t hlen;
+	bool inv;
+
+	nftnl_expr_get(e, NFTNL_EXPR_CMP_DATA, &hlen);
+
+	if (hlen != ETH_ALEN)
+		return false;
+
+	get_cmp_data(e, info->addr, ETH_ALEN, &inv);
+
+	if (reg->bitwise.set)
+		memcpy(info->mask, reg->bitwise.mask, ETH_ALEN);
+	else
+		memset(info->mask, 0xff,
+		       min(reg->payload.len, ETH_ALEN));
+
+	return inv;
+}
+
+static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
+				  const struct nft_xt_ctx_reg *reg,
+				  struct nftnl_expr *e,
+				  struct iptables_command_state *cs)
+{
+	struct arpt_entry *fw = &cs->arp;
+	struct in_addr addr;
+	uint16_t ar_hrd, ar_pro, ar_op;
+	uint8_t ar_hln, ar_pln;
+	bool inv;
+
+	switch (reg->payload.offset) {
+	case offsetof(struct arphdr, ar_hrd):
+		get_cmp_data(e, &ar_hrd, sizeof(ar_hrd), &inv);
+		fw->arp.arhrd = ar_hrd;
+		fw->arp.arhrd_mask = 0xffff;
+		if (inv)
+			fw->arp.invflags |= IPT_INV_ARPHRD;
+		break;
+	case offsetof(struct arphdr, ar_pro):
+		get_cmp_data(e, &ar_pro, sizeof(ar_pro), &inv);
+		fw->arp.arpro = ar_pro;
+		fw->arp.arpro_mask = 0xffff;
+		if (inv)
+			fw->arp.invflags |= IPT_INV_PROTO;
+		break;
+	case offsetof(struct arphdr, ar_op):
+		get_cmp_data(e, &ar_op, sizeof(ar_op), &inv);
+		fw->arp.arpop = ar_op;
+		fw->arp.arpop_mask = 0xffff;
+		if (inv)
+			fw->arp.invflags |= IPT_INV_ARPOP;
+		break;
+	case offsetof(struct arphdr, ar_hln):
+		get_cmp_data(e, &ar_hln, sizeof(ar_hln), &inv);
+		fw->arp.arhln = ar_hln;
+		fw->arp.arhln_mask = 0xff;
+		if (inv)
+			fw->arp.invflags |= IPT_INV_ARPOP;
+		break;
+	case offsetof(struct arphdr, ar_pln):
+		get_cmp_data(e, &ar_pln, sizeof(ar_pln), &inv);
+		if (ar_pln != 4 || inv)
+			ctx->errmsg = "unexpected ARP protocol length match";
+		break;
+	default:
+		if (reg->payload.offset == sizeof(struct arphdr)) {
+			if (nft_arp_parse_devaddr(reg, e, &fw->arp.src_devaddr))
+				fw->arp.invflags |= IPT_INV_SRCDEVADDR;
+		} else if (reg->payload.offset == sizeof(struct arphdr) +
+					   fw->arp.arhln) {
+			get_cmp_data(e, &addr, sizeof(addr), &inv);
+			fw->arp.src.s_addr = addr.s_addr;
+			if (reg->bitwise.set)
+				parse_mask_ipv4(reg, &fw->arp.smsk);
+			else
+				memset(&fw->arp.smsk, 0xff,
+				       min(reg->payload.len,
+					   sizeof(struct in_addr)));
+
+			if (inv)
+				fw->arp.invflags |= IPT_INV_SRCIP;
+		} else if (reg->payload.offset == sizeof(struct arphdr) +
+						  fw->arp.arhln +
+						  sizeof(struct in_addr)) {
+			if (nft_arp_parse_devaddr(reg, e, &fw->arp.tgt_devaddr))
+				fw->arp.invflags |= IPT_INV_TGTDEVADDR;
+		} else if (reg->payload.offset == sizeof(struct arphdr) +
+						  fw->arp.arhln +
+						  sizeof(struct in_addr) +
+						  fw->arp.arhln) {
+			get_cmp_data(e, &addr, sizeof(addr), &inv);
+			fw->arp.tgt.s_addr = addr.s_addr;
+			if (reg->bitwise.set)
+				parse_mask_ipv4(reg, &fw->arp.tmsk);
+			else
+				memset(&fw->arp.tmsk, 0xff,
+				       min(reg->payload.len,
+					   sizeof(struct in_addr)));
+
+			if (inv)
+				fw->arp.invflags |= IPT_INV_DSTIP;
+		} else {
+			ctx->errmsg = "unknown payload offset";
+		}
+		break;
+	}
+}
+
+struct nft_ruleparse_ops nft_ruleparse_ops_arp = {
+	.meta		= nft_arp_parse_meta,
+	.payload	= nft_arp_parse_payload,
+	.target		= nft_ipv46_parse_target,
+};
diff --git a/iptables/nft-ruleparse-bridge.c b/iptables/nft-ruleparse-bridge.c
new file mode 100644
index 0000000000000..50fb92833046a
--- /dev/null
+++ b/iptables/nft-ruleparse-bridge.c
@@ -0,0 +1,422 @@
+/*
+ * (C) 2014 by Giuseppe Longo <giuseppelng@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <stddef.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <netdb.h>
+#include <net/if.h>
+//#include <net/if_arp.h>
+#include <netinet/if_ether.h>
+
+#include <libnftnl/rule.h>
+#include <libnftnl/expr.h>
+#include <libnftnl/set.h>
+
+#include <xtables.h>
+
+#include "nft.h" /* just for nft_set_batch_lookup_byid? */
+#include "nft-bridge.h"
+#include "nft-cache.h"
+#include "nft-shared.h"
+#include "nft-ruleparse.h"
+#include "xshared.h"
+
+static void nft_bridge_parse_meta(struct nft_xt_ctx *ctx,
+				  const struct nft_xt_ctx_reg *reg,
+				  struct nftnl_expr *e,
+				  struct iptables_command_state *cs)
+{
+	struct ebt_entry *fw = &cs->eb;
+	uint8_t invflags = 0;
+	char iifname[IFNAMSIZ] = {}, oifname[IFNAMSIZ] = {};
+
+	switch (reg->meta_dreg.key) {
+	case NFT_META_PROTOCOL:
+		return;
+	}
+
+	if (parse_meta(ctx, e, reg->meta_dreg.key, iifname, NULL, oifname, NULL, &invflags) < 0) {
+		ctx->errmsg = "unknown meta key";
+		return;
+	}
+
+	switch (reg->meta_dreg.key) {
+	case NFT_META_BRI_IIFNAME:
+		if (invflags & IPT_INV_VIA_IN)
+			cs->eb.invflags |= EBT_ILOGICALIN;
+		snprintf(fw->logical_in, sizeof(fw->logical_in), "%s", iifname);
+		break;
+	case NFT_META_IIFNAME:
+		if (invflags & IPT_INV_VIA_IN)
+			cs->eb.invflags |= EBT_IIN;
+		snprintf(fw->in, sizeof(fw->in), "%s", iifname);
+		break;
+	case NFT_META_BRI_OIFNAME:
+		if (invflags & IPT_INV_VIA_OUT)
+			cs->eb.invflags |= EBT_ILOGICALOUT;
+		snprintf(fw->logical_out, sizeof(fw->logical_out), "%s", oifname);
+		break;
+	case NFT_META_OIFNAME:
+		if (invflags & IPT_INV_VIA_OUT)
+			cs->eb.invflags |= EBT_IOUT;
+		snprintf(fw->out, sizeof(fw->out), "%s", oifname);
+		break;
+	default:
+		ctx->errmsg = "unknown bridge meta key";
+		break;
+	}
+}
+
+static void nft_bridge_parse_payload(struct nft_xt_ctx *ctx,
+				     const struct nft_xt_ctx_reg *reg,
+				     struct nftnl_expr *e,
+				     struct iptables_command_state *cs)
+{
+	struct ebt_entry *fw = &cs->eb;
+	unsigned char addr[ETH_ALEN];
+	unsigned short int ethproto;
+	uint8_t op;
+	bool inv;
+	int i;
+
+	switch (reg->payload.offset) {
+	case offsetof(struct ethhdr, h_dest):
+		get_cmp_data(e, addr, sizeof(addr), &inv);
+		for (i = 0; i < ETH_ALEN; i++)
+			fw->destmac[i] = addr[i];
+		if (inv)
+			fw->invflags |= EBT_IDEST;
+
+		if (reg->bitwise.set)
+                        memcpy(fw->destmsk, reg->bitwise.mask, ETH_ALEN);
+                else
+			memset(&fw->destmsk, 0xff,
+			       min(reg->payload.len, ETH_ALEN));
+		fw->bitmask |= EBT_IDEST;
+		break;
+	case offsetof(struct ethhdr, h_source):
+		get_cmp_data(e, addr, sizeof(addr), &inv);
+		for (i = 0; i < ETH_ALEN; i++)
+			fw->sourcemac[i] = addr[i];
+		if (inv)
+			fw->invflags |= EBT_ISOURCE;
+		if (reg->bitwise.set)
+                        memcpy(fw->sourcemsk, reg->bitwise.mask, ETH_ALEN);
+                else
+			memset(&fw->sourcemsk, 0xff,
+			       min(reg->payload.len, ETH_ALEN));
+		fw->bitmask |= EBT_ISOURCE;
+		break;
+	case offsetof(struct ethhdr, h_proto):
+		__get_cmp_data(e, &ethproto, sizeof(ethproto), &op);
+		if (ethproto == htons(0x0600)) {
+			fw->bitmask |= EBT_802_3;
+			inv = (op == NFT_CMP_GTE);
+		} else {
+			fw->ethproto = ethproto;
+			inv = (op == NFT_CMP_NEQ);
+		}
+		if (inv)
+			fw->invflags |= EBT_IPROTO;
+		fw->bitmask &= ~EBT_NOPROTO;
+		break;
+	default:
+		DEBUGP("unknown payload offset %d\n", reg->payload.offset);
+		ctx->errmsg = "unknown payload offset";
+		break;
+	}
+}
+
+/* return 0 if saddr, 1 if daddr, -1 on error */
+static int
+lookup_check_ether_payload(uint32_t base, uint32_t offset, uint32_t len)
+{
+	if (base != 0 || len != ETH_ALEN)
+		return -1;
+
+	switch (offset) {
+	case offsetof(struct ether_header, ether_dhost):
+		return 1;
+	case offsetof(struct ether_header, ether_shost):
+		return 0;
+	default:
+		return -1;
+	}
+}
+
+/* return 0 if saddr, 1 if daddr, -1 on error */
+static int
+lookup_check_iphdr_payload(uint32_t base, uint32_t offset, uint32_t len)
+{
+	if (base != 1 || len != 4)
+		return -1;
+
+	switch (offset) {
+	case offsetof(struct iphdr, daddr):
+		return 1;
+	case offsetof(struct iphdr, saddr):
+		return 0;
+	default:
+		return -1;
+	}
+}
+
+/* Make sure previous payload expression(s) is/are consistent and extract if
+ * matching on source or destination address and if matching on MAC and IP or
+ * only MAC address. */
+static int lookup_analyze_payloads(struct nft_xt_ctx *ctx,
+				   enum nft_registers sreg,
+				   uint32_t key_len,
+				   bool *dst, bool *ip)
+{
+	const struct nft_xt_ctx_reg *reg;
+	int val, val2 = -1;
+
+	reg = nft_xt_ctx_get_sreg(ctx, sreg);
+	if (!reg)
+		return -1;
+
+	if (reg->type != NFT_XT_REG_PAYLOAD) {
+		ctx->errmsg = "lookup reg is not payload type";
+		return -1;
+	}
+
+	switch (key_len) {
+	case 12: /* ether + ipv4addr */
+		val = lookup_check_ether_payload(reg->payload.base,
+						 reg->payload.offset,
+						 reg->payload.len);
+		if (val < 0) {
+			DEBUGP("unknown payload base/offset/len %d/%d/%d\n",
+			       reg->payload.base, reg->payload.offset,
+			       reg->payload.len);
+			return -1;
+		}
+
+		sreg = nft_get_next_reg(sreg, ETH_ALEN);
+
+		reg = nft_xt_ctx_get_sreg(ctx, sreg);
+		if (!reg) {
+			ctx->errmsg = "next lookup register is invalid";
+			return -1;
+		}
+
+		if (reg->type != NFT_XT_REG_PAYLOAD) {
+			ctx->errmsg = "next lookup reg is not payload type";
+			return -1;
+		}
+
+		val2 = lookup_check_iphdr_payload(reg->payload.base,
+						  reg->payload.offset,
+						  reg->payload.len);
+		if (val2 < 0) {
+			DEBUGP("unknown payload base/offset/len %d/%d/%d\n",
+			       reg->payload.base, reg->payload.offset,
+			       reg->payload.len);
+			return -1;
+		} else if (val != val2) {
+			DEBUGP("mismatching payload match offsets\n");
+			return -1;
+		}
+		break;
+	case 6: /* ether */
+		val = lookup_check_ether_payload(reg->payload.base,
+						 reg->payload.offset,
+						 reg->payload.len);
+		if (val < 0) {
+			DEBUGP("unknown payload base/offset/len %d/%d/%d\n",
+			       reg->payload.base, reg->payload.offset,
+			       reg->payload.len);
+			return -1;
+		}
+		break;
+	default:
+		ctx->errmsg = "unsupported lookup key length";
+		return -1;
+	}
+
+	if (dst)
+		*dst = (val == 1);
+	if (ip)
+		*ip = (val2 != -1);
+	return 0;
+}
+
+static int set_elems_to_among_pairs(struct nft_among_pair *pairs,
+				    const struct nftnl_set *s, int cnt)
+{
+	struct nftnl_set_elems_iter *iter = nftnl_set_elems_iter_create(s);
+	struct nftnl_set_elem *elem;
+	size_t tmpcnt = 0;
+	const void *data;
+	uint32_t datalen;
+	int ret = -1;
+
+	if (!iter) {
+		fprintf(stderr, "BUG: set elems iter allocation failed\n");
+		return ret;
+	}
+
+	while ((elem = nftnl_set_elems_iter_next(iter))) {
+		data = nftnl_set_elem_get(elem, NFTNL_SET_ELEM_KEY, &datalen);
+		if (!data) {
+			fprintf(stderr, "BUG: set elem without key\n");
+			goto err;
+		}
+		if (datalen > sizeof(*pairs)) {
+			fprintf(stderr, "BUG: overlong set elem\n");
+			goto err;
+		}
+		nft_among_insert_pair(pairs, &tmpcnt, data);
+	}
+	ret = 0;
+err:
+	nftnl_set_elems_iter_destroy(iter);
+	return ret;
+}
+
+static struct nftnl_set *set_from_lookup_expr(struct nft_xt_ctx *ctx,
+					      const struct nftnl_expr *e)
+{
+	const char *set_name = nftnl_expr_get_str(e, NFTNL_EXPR_LOOKUP_SET);
+	uint32_t set_id = nftnl_expr_get_u32(e, NFTNL_EXPR_LOOKUP_SET_ID);
+	struct nftnl_set_list *slist;
+	struct nftnl_set *set;
+
+	slist = nft_set_list_get(ctx->h, ctx->table, set_name);
+	if (slist) {
+		set = nftnl_set_list_lookup_byname(slist, set_name);
+		if (set)
+			return set;
+
+		set = nft_set_batch_lookup_byid(ctx->h, set_id);
+		if (set)
+			return set;
+	}
+
+	return NULL;
+}
+
+static void nft_bridge_parse_lookup(struct nft_xt_ctx *ctx,
+				    struct nftnl_expr *e)
+{
+	struct xtables_match *match = NULL;
+	struct nft_among_data *among_data;
+	bool is_dst, have_ip, inv;
+	struct ebt_match *ematch;
+	struct nftnl_set *s;
+	size_t poff, size;
+	uint32_t cnt;
+
+	s = set_from_lookup_expr(ctx, e);
+	if (!s)
+		xtables_error(OTHER_PROBLEM,
+			      "BUG: lookup expression references unknown set");
+
+	if (lookup_analyze_payloads(ctx,
+				    nftnl_expr_get_u32(e, NFTNL_EXPR_LOOKUP_SREG),
+				    nftnl_set_get_u32(s, NFTNL_SET_KEY_LEN),
+				    &is_dst, &have_ip))
+		return;
+
+	cnt = nftnl_set_get_u32(s, NFTNL_SET_DESC_SIZE);
+
+	for (ematch = ctx->cs->match_list; ematch; ematch = ematch->next) {
+		if (!ematch->ismatch || strcmp(ematch->u.match->name, "among"))
+			continue;
+
+		match = ematch->u.match;
+		among_data = (struct nft_among_data *)match->m->data;
+
+		size = cnt + among_data->src.cnt + among_data->dst.cnt;
+		size *= sizeof(struct nft_among_pair);
+
+		size += XT_ALIGN(sizeof(struct xt_entry_match)) +
+			sizeof(struct nft_among_data);
+
+		match->m = xtables_realloc(match->m, size);
+		break;
+	}
+	if (!match) {
+		match = xtables_find_match("among", XTF_TRY_LOAD,
+					   &ctx->cs->matches);
+
+		size = cnt * sizeof(struct nft_among_pair);
+		size += XT_ALIGN(sizeof(struct xt_entry_match)) +
+			sizeof(struct nft_among_data);
+
+		match->m = xtables_calloc(1, size);
+		strcpy(match->m->u.user.name, match->name);
+		match->m->u.user.revision = match->revision;
+		xs_init_match(match);
+
+		if (ctx->h->ops->rule_parse->match != NULL)
+			ctx->h->ops->rule_parse->match(match, ctx->cs);
+	}
+	if (!match)
+		return;
+
+	match->m->u.match_size = size;
+
+	inv = !!(nftnl_expr_get_u32(e, NFTNL_EXPR_LOOKUP_FLAGS) &
+				    NFT_LOOKUP_F_INV);
+
+	among_data = (struct nft_among_data *)match->m->data;
+	poff = nft_among_prepare_data(among_data, is_dst, cnt, inv, have_ip);
+	if (set_elems_to_among_pairs(among_data->pairs + poff, s, cnt))
+		xtables_error(OTHER_PROBLEM,
+			      "ebtables among pair parsing failed");
+}
+
+static void parse_watcher(void *object, struct ebt_match **match_list,
+			  bool ismatch)
+{
+	struct ebt_match *m = xtables_calloc(1, sizeof(struct ebt_match));
+
+	if (ismatch)
+		m->u.match = object;
+	else
+		m->u.watcher = object;
+
+	m->ismatch = ismatch;
+	if (*match_list == NULL)
+		*match_list = m;
+	else
+		(*match_list)->next = m;
+}
+
+static void nft_bridge_parse_match(struct xtables_match *m,
+				   struct iptables_command_state *cs)
+{
+	parse_watcher(m, &cs->match_list, true);
+}
+
+static void nft_bridge_parse_target(struct xtables_target *t,
+				    struct iptables_command_state *cs)
+{
+	/* harcoded names :-( */
+	if (strcmp(t->name, "log") == 0 ||
+	    strcmp(t->name, "nflog") == 0) {
+		parse_watcher(t, &cs->match_list, false);
+		return;
+	}
+
+	cs->target = t;
+	cs->jumpto = t->name;
+}
+
+struct nft_ruleparse_ops nft_ruleparse_ops_bridge = {
+	.meta		= nft_bridge_parse_meta,
+	.payload	= nft_bridge_parse_payload,
+	.lookup		= nft_bridge_parse_lookup,
+	.match		= nft_bridge_parse_match,
+	.target		= nft_bridge_parse_target,
+};
diff --git a/iptables/nft-ruleparse-ipv4.c b/iptables/nft-ruleparse-ipv4.c
new file mode 100644
index 0000000000000..c87e159cc5fec
--- /dev/null
+++ b/iptables/nft-ruleparse-ipv4.c
@@ -0,0 +1,135 @@
+/*
+ * (C) 2012-2014 by Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2013 by Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
+ */
+
+#include <stddef.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <netdb.h>
+#include <net/if.h>
+#include <netinet/if_ether.h>
+#include <netinet/ip.h>
+
+#include <libnftnl/rule.h>
+#include <libnftnl/expr.h>
+
+#include "nft-shared.h"
+#include "nft-ruleparse.h"
+#include "xshared.h"
+
+static void nft_ipv4_parse_meta(struct nft_xt_ctx *ctx,
+				const struct nft_xt_ctx_reg *reg,
+				struct nftnl_expr *e,
+				struct iptables_command_state *cs)
+{
+	switch (reg->meta_dreg.key) {
+	case NFT_META_L4PROTO:
+		cs->fw.ip.proto = nftnl_expr_get_u8(e, NFTNL_EXPR_CMP_DATA);
+		if (nftnl_expr_get_u32(e, NFTNL_EXPR_CMP_OP) == NFT_CMP_NEQ)
+			cs->fw.ip.invflags |= XT_INV_PROTO;
+		return;
+	default:
+		break;
+	}
+
+	if (parse_meta(ctx, e, reg->meta_dreg.key, cs->fw.ip.iniface, cs->fw.ip.iniface_mask,
+		   cs->fw.ip.outiface, cs->fw.ip.outiface_mask,
+		   &cs->fw.ip.invflags) == 0)
+		return;
+
+	ctx->errmsg = "unknown ipv4 meta key";
+}
+
+static void parse_mask_ipv4(const struct nft_xt_ctx_reg *sreg, struct in_addr *mask)
+{
+	mask->s_addr = sreg->bitwise.mask[0];
+}
+
+static bool get_frag(const struct nft_xt_ctx_reg *reg, struct nftnl_expr *e)
+{
+	uint8_t op;
+
+	/* we assume correct mask and xor */
+	if (!reg->bitwise.set)
+		return false;
+
+	/* we assume correct data */
+	op = nftnl_expr_get_u32(e, NFTNL_EXPR_CMP_OP);
+	if (op == NFT_CMP_EQ)
+		return true;
+
+	return false;
+}
+
+static void nft_ipv4_parse_payload(struct nft_xt_ctx *ctx,
+				   const struct nft_xt_ctx_reg *sreg,
+				   struct nftnl_expr *e,
+				   struct iptables_command_state *cs)
+{
+	struct in_addr addr;
+	uint8_t proto;
+	bool inv;
+
+	switch (sreg->payload.offset) {
+	case offsetof(struct iphdr, saddr):
+		get_cmp_data(e, &addr, sizeof(addr), &inv);
+		cs->fw.ip.src.s_addr = addr.s_addr;
+		if (sreg->bitwise.set) {
+			parse_mask_ipv4(sreg, &cs->fw.ip.smsk);
+		} else {
+			memset(&cs->fw.ip.smsk, 0xff,
+			       min(sreg->payload.len, sizeof(struct in_addr)));
+		}
+
+		if (inv)
+			cs->fw.ip.invflags |= IPT_INV_SRCIP;
+		break;
+	case offsetof(struct iphdr, daddr):
+		get_cmp_data(e, &addr, sizeof(addr), &inv);
+		cs->fw.ip.dst.s_addr = addr.s_addr;
+		if (sreg->bitwise.set)
+			parse_mask_ipv4(sreg, &cs->fw.ip.dmsk);
+		else
+			memset(&cs->fw.ip.dmsk, 0xff,
+			       min(sreg->payload.len, sizeof(struct in_addr)));
+
+		if (inv)
+			cs->fw.ip.invflags |= IPT_INV_DSTIP;
+		break;
+	case offsetof(struct iphdr, protocol):
+		get_cmp_data(e, &proto, sizeof(proto), &inv);
+		cs->fw.ip.proto = proto;
+		if (inv)
+			cs->fw.ip.invflags |= IPT_INV_PROTO;
+		break;
+	case offsetof(struct iphdr, frag_off):
+		cs->fw.ip.flags |= IPT_F_FRAG;
+		inv = get_frag(sreg, e);
+		if (inv)
+			cs->fw.ip.invflags |= IPT_INV_FRAG;
+		break;
+	case offsetof(struct iphdr, ttl):
+		if (nft_parse_hl(ctx, e, cs) < 0)
+			ctx->errmsg = "invalid ttl field match";
+		break;
+	default:
+		DEBUGP("unknown payload offset %d\n", sreg->payload.offset);
+		ctx->errmsg = "unknown payload offset";
+		break;
+	}
+}
+
+struct nft_ruleparse_ops nft_ruleparse_ops_ipv4 = {
+	.meta		= nft_ipv4_parse_meta,
+	.payload	= nft_ipv4_parse_payload,
+	.target		= nft_ipv46_parse_target,
+};
diff --git a/iptables/nft-ruleparse-ipv6.c b/iptables/nft-ruleparse-ipv6.c
new file mode 100644
index 0000000000000..af55420b73766
--- /dev/null
+++ b/iptables/nft-ruleparse-ipv6.c
@@ -0,0 +1,112 @@
+/*
+ * (C) 2012-2014 by Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2013 by Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
+ */
+
+#include <stddef.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <netdb.h>
+#include <net/if.h>
+#include <netinet/if_ether.h>
+#include <netinet/ip6.h>
+
+#include <libnftnl/rule.h>
+#include <libnftnl/expr.h>
+
+#include "nft-shared.h"
+#include "nft-ruleparse.h"
+#include "xshared.h"
+
+static void nft_ipv6_parse_meta(struct nft_xt_ctx *ctx,
+				const struct nft_xt_ctx_reg *reg,
+				struct nftnl_expr *e,
+				struct iptables_command_state *cs)
+{
+	switch (reg->meta_dreg.key) {
+	case NFT_META_L4PROTO:
+		cs->fw6.ipv6.proto = nftnl_expr_get_u8(e, NFTNL_EXPR_CMP_DATA);
+		if (nftnl_expr_get_u32(e, NFTNL_EXPR_CMP_OP) == NFT_CMP_NEQ)
+			cs->fw6.ipv6.invflags |= XT_INV_PROTO;
+		return;
+	default:
+		break;
+	}
+
+	if (parse_meta(ctx, e, reg->meta_dreg.key, cs->fw6.ipv6.iniface,
+		   cs->fw6.ipv6.iniface_mask, cs->fw6.ipv6.outiface,
+		   cs->fw6.ipv6.outiface_mask, &cs->fw6.ipv6.invflags) == 0)
+		return;
+
+	ctx->errmsg = "unknown ipv6 meta key";
+}
+
+static void parse_mask_ipv6(const struct nft_xt_ctx_reg *reg,
+			    struct in6_addr *mask)
+{
+	memcpy(mask, reg->bitwise.mask, sizeof(struct in6_addr));
+}
+
+static void nft_ipv6_parse_payload(struct nft_xt_ctx *ctx,
+				   const struct nft_xt_ctx_reg *reg,
+				   struct nftnl_expr *e,
+				   struct iptables_command_state *cs)
+{
+	struct in6_addr addr;
+	uint8_t proto;
+	bool inv;
+
+	switch (reg->payload.offset) {
+	case offsetof(struct ip6_hdr, ip6_src):
+		get_cmp_data(e, &addr, sizeof(addr), &inv);
+		memcpy(cs->fw6.ipv6.src.s6_addr, &addr, sizeof(addr));
+		if (reg->bitwise.set)
+			parse_mask_ipv6(reg, &cs->fw6.ipv6.smsk);
+		else
+			memset(&cs->fw6.ipv6.smsk, 0xff,
+			       min(reg->payload.len, sizeof(struct in6_addr)));
+
+		if (inv)
+			cs->fw6.ipv6.invflags |= IP6T_INV_SRCIP;
+		break;
+	case offsetof(struct ip6_hdr, ip6_dst):
+		get_cmp_data(e, &addr, sizeof(addr), &inv);
+		memcpy(cs->fw6.ipv6.dst.s6_addr, &addr, sizeof(addr));
+		if (reg->bitwise.set)
+			parse_mask_ipv6(reg, &cs->fw6.ipv6.dmsk);
+		else
+			memset(&cs->fw6.ipv6.dmsk, 0xff,
+			       min(reg->payload.len, sizeof(struct in6_addr)));
+
+		if (inv)
+			cs->fw6.ipv6.invflags |= IP6T_INV_DSTIP;
+		break;
+	case offsetof(struct ip6_hdr, ip6_nxt):
+		get_cmp_data(e, &proto, sizeof(proto), &inv);
+		cs->fw6.ipv6.proto = proto;
+		if (inv)
+			cs->fw6.ipv6.invflags |= IP6T_INV_PROTO;
+	case offsetof(struct ip6_hdr, ip6_hlim):
+		if (nft_parse_hl(ctx, e, cs) < 0)
+			ctx->errmsg = "invalid ttl field match";
+		break;
+	default:
+		DEBUGP("unknown payload offset %d\n", reg->payload.offset);
+		ctx->errmsg = "unknown payload offset";
+		break;
+	}
+}
+
+struct nft_ruleparse_ops nft_ruleparse_ops_ipv6 = {
+	.meta		= nft_ipv6_parse_meta,
+	.payload	= nft_ipv6_parse_payload,
+	.target		= nft_ipv46_parse_target,
+};
diff --git a/iptables/nft-ruleparse.h b/iptables/nft-ruleparse.h
index 69e98817bb6e1..fd083c08ff343 100644
--- a/iptables/nft-ruleparse.h
+++ b/iptables/nft-ruleparse.h
@@ -109,6 +109,11 @@ struct nft_ruleparse_ops {
 		       struct iptables_command_state *cs);
 };
 
+extern struct nft_ruleparse_ops nft_ruleparse_ops_arp;
+extern struct nft_ruleparse_ops nft_ruleparse_ops_bridge;
+extern struct nft_ruleparse_ops nft_ruleparse_ops_ipv4;
+extern struct nft_ruleparse_ops nft_ruleparse_ops_ipv6;
+
 void *nft_create_match(struct nft_xt_ctx *ctx,
 		       struct iptables_command_state *cs,
 		       const char *name, bool reuse);
-- 
2.40.0

