Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30370C433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jan 2022 16:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1587195AbiAYQ6i (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jan 2022 11:58:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356301AbiAYQz7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jan 2022 11:55:59 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC314C061782
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jan 2022 08:53:28 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nCP4R-0001ds-GP; Tue, 25 Jan 2022 17:53:27 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables-nft 5/7] nft: prefer native expressions instead of tcp match
Date:   Tue, 25 Jan 2022 17:52:59 +0100
Message-Id: <20220125165301.5960-6-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220125165301.5960-1-fw@strlen.de>
References: <20220125165301.5960-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Instead of using nft_compat+xtables tcp match, prefer to
emit payload+cmp or payload+range expression.

Unlike udp, tcp has flag bits that can be matched too but
we have to fall back to the xt expression for now.
We also don't support tcp option match, but thats a rarely
used feature anyway.

Delinearization support for ports was added in previous patches.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/nft.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/iptables/nft.c b/iptables/nft.c
index 9f181de53678..4b5c4332c7c1 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1346,6 +1346,36 @@ static int add_nft_udp(struct nftnl_rule *r, struct xt_entry_match *m)
 			      udp->dpts, udp->invflags & XT_UDP_INV_DSTPT);
 }
 
+static bool tcp_all_zero(const struct xt_tcp *t)
+{
+	static const struct xt_tcp zero = {
+		.spts[1] = 0xffff,
+		.dpts[1] = 0xffff,
+	};
+
+	return memcmp(t, &zero, sizeof(*t)) == 0;
+}
+
+static int add_nft_tcp(struct nftnl_rule *r, struct xt_entry_match *m)
+{
+	static const uint8_t supported = XT_TCP_INV_SRCPT | XT_TCP_INV_DSTPT;
+	struct xt_tcp *tcp = (void *)m->data;
+
+	if (tcp->invflags & ~supported || tcp->option ||
+	    tcp->flg_mask || tcp->flg_cmp ||
+	    tcp_all_zero(tcp)) {
+		struct nftnl_expr *expr = nftnl_expr_alloc("match");
+		int ret;
+
+		ret = __add_match(expr, m);
+		nftnl_rule_add_expr(r, expr);
+		return ret;
+	}
+
+	return add_nft_tcpudp(r, tcp->spts, tcp->invflags & XT_TCP_INV_SRCPT,
+			      tcp->dpts, tcp->invflags & XT_TCP_INV_DSTPT);
+}
+
 int add_match(struct nft_handle *h,
 	      struct nftnl_rule *r, struct xt_entry_match *m)
 {
@@ -1358,6 +1388,8 @@ int add_match(struct nft_handle *h,
 		return add_nft_among(h, r, m);
 	else if (!strcmp(m->u.user.name, "udp"))
 		return add_nft_udp(r, m);
+	else if (!strcmp(m->u.user.name, "tcp"))
+		return add_nft_tcp(r, m);
 
 	expr = nftnl_expr_alloc("match");
 	if (expr == NULL)
-- 
2.34.1

