Return-Path: <SRS0=hXfx=ZH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A905EC432C3
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Nov 2019 09:47:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EF8C20740
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Nov 2019 09:47:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfKOJre (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Nov 2019 04:47:34 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:54734 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbfKOJre (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Nov 2019 04:47:34 -0500
Received: from localhost ([::1]:39592 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iVYCT-0008Ea-4x; Fri, 15 Nov 2019 10:47:33 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/2] nft: Fix -Z for rules with NFTA_RULE_COMPAT
Date:   Fri, 15 Nov 2019 10:47:25 +0100
Message-Id: <20191115094725.19756-3-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191115094725.19756-1-phil@nwl.cc>
References: <20191115094725.19756-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The special nested attribute NFTA_RULE_COMPAT holds information about
any present l4proto match (given via '-p' parameter) in input. The match
is contained as meta expression as well, but some xtables extensions
explicitly check it's value (see e.g. xt_TPROXY).

This nested attribute is input only, the information is lost after
parsing (and initialization of compat extensions). So in order to feed a
rule back to kernel with zeroed counters, the attribute has to be
reconstructed based on the rule's expressions.

Other code paths are not affected since rule_to_cs() callback will
populate respective fields in struct iptables_command_state and 'add'
callback (which is the inverse to rule_to_cs()) calls add_compat() in
any case.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/iptables/nft.c b/iptables/nft.c
index 83cf5fb703d3e..599c2f7e4c087 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2897,6 +2897,44 @@ const char *nft_strerror(int err)
 	return strerror(err);
 }
 
+static int recover_rule_compat(struct nftnl_rule *r)
+{
+	struct nftnl_expr_iter *iter;
+	struct nftnl_expr *e;
+	uint32_t reg;
+	int ret = -1;
+
+	iter = nftnl_expr_iter_create(r);
+	if (!iter)
+		return -1;
+
+next_expr:
+	e = nftnl_expr_iter_next(iter);
+	if (!e)
+		goto out;
+
+	if (strcmp("meta", nftnl_expr_get_str(e, NFTNL_EXPR_NAME)) ||
+	    nftnl_expr_get_u32(e, NFTNL_EXPR_META_KEY) != NFT_META_L4PROTO)
+		goto next_expr;
+
+	reg = nftnl_expr_get_u32(e, NFTNL_EXPR_META_DREG);
+
+	e = nftnl_expr_iter_next(iter);
+	if (!e)
+		goto out;
+
+	if (strcmp("cmp", nftnl_expr_get_str(e, NFTNL_EXPR_NAME)) ||
+	    reg != nftnl_expr_get_u32(e, NFTNL_EXPR_CMP_SREG))
+		goto next_expr;
+
+	add_compat(r, nftnl_expr_get_u8(e, NFTNL_EXPR_CMP_DATA),
+		   nftnl_expr_get_u32(e, NFTNL_EXPR_CMP_OP) == NFT_CMP_NEQ);
+	ret = 0;
+out:
+	nftnl_expr_iter_destroy(iter);
+	return ret;
+}
+
 struct chain_zero_data {
 	struct nft_handle	*handle;
 	bool			verbose;
@@ -2961,6 +2999,7 @@ static int __nft_chain_zero_counters(struct nftnl_chain *c, void *data)
 			 * Unset RULE_POSITION for older kernels, we want to replace
 			 * rule based on its handle only.
 			 */
+			recover_rule_compat(r);
 			nftnl_rule_unset(r, NFTNL_RULE_POSITION);
 			if (!batch_rule_add(h, NFT_COMPAT_RULE_REPLACE, r)) {
 				nftnl_rule_iter_destroy(iter);
-- 
2.24.0

