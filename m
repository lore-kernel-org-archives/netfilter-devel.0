Return-Path: <SRS0=E6gp=UJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C37EFC31E41
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jun 2019 15:34:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6557206C3
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jun 2019 15:34:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390508AbfFJPe5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Jun 2019 11:34:57 -0400
Received: from mail.us.es ([193.147.175.20]:36178 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390415AbfFJPe5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jun 2019 11:34:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4968820A52A
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jun 2019 17:34:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3A102DA707
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jun 2019 17:34:55 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2FAB8DA708; Mon, 10 Jun 2019 17:34:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 31DDBDA707
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jun 2019 17:34:53 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 10 Jun 2019 17:34:53 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1957F4265A31
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jun 2019 17:34:53 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] netlink_delinearize: release expression before calling netlink_parse_concat_expr()
Date:   Mon, 10 Jun 2019 17:34:49 +0200
Message-Id: <20190610153449.9199-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190610153449.9199-1-pablo@netfilter.org>
References: <20190610153449.9199-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

netlink_get_register() clones the expression in the register. Release
this expression before calling netlink_parse_concat_expr() to
deconstruct the concatenation.

==15069==    at 0x4C2BBAF: malloc (vg_replace_malloc.c:299)
==15069==    by 0x4E79508: xmalloc (utils.c:36)
==15069==    by 0x4E795ED: xzalloc (utils.c:65)
==15069==    by 0x4E6029B: dtype_alloc (datatype.c:1073)
==15069==    by 0x4E6029B: concat_type_alloc (datatype.c:1127)
==15069==    by 0x4E6D3B3: netlink_delinearize_set (netlink.c:578)
==15069==    by 0x4E6D68E: list_set_cb (netlink.c:648)
==15069==    by 0x5F34023: nftnl_set_list_foreach (set.c:780)
==15069==    by 0x4E6D6F3: netlink_list_sets (netlink.c:669)
==15069==    by 0x4E5A7A3: cache_init_objects (rule.c:159)
==15069==    by 0x4E5A7A3: cache_init (rule.c:216)
==15069==    by 0x4E5A7A3: cache_update (rule.c:266)
==15069==    by 0x4E7E09E: nft_evaluate (libnftables.c:388)
==15069==    by 0x4E7E85B: nft_run_cmd_from_buffer (libnftables.c:428)

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index a1c775e679e4..0270e1fd7067 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -293,6 +293,7 @@ static void netlink_parse_cmp(struct netlink_parse_ctx *ctx,
 	    expr_basetype(left) != &string_type) {
 		return netlink_error(ctx, loc, "Relational expression size mismatch");
 	} else if (left->len > 0 && left->len < right->len) {
+		expr_free(left);
 		left = netlink_parse_concat_expr(ctx, loc, sreg, right->len);
 		if (left == NULL)
 			return;
@@ -329,6 +330,7 @@ static void netlink_parse_lookup(struct netlink_parse_ctx *ctx,
 				     "Lookup expression has no left hand side");
 
 	if (left->len < set->key->len) {
+		expr_free(left);
 		left = netlink_parse_concat_expr(ctx, loc, sreg, set->key->len);
 		if (left == NULL)
 			return;
@@ -1317,6 +1319,7 @@ static void netlink_parse_dynset(struct netlink_parse_ctx *ctx,
 				     "Dynset statement has no key expression");
 
 	if (expr->len < set->key->len) {
+		expr_free(expr);
 		expr = netlink_parse_concat_expr(ctx, loc, sreg, set->key->len);
 		if (expr == NULL)
 			return;
@@ -1408,6 +1411,7 @@ static void netlink_parse_objref(struct netlink_parse_ctx *ctx,
 					     "objref expression has no left hand side");
 
 		if (left->len < set->key->len) {
+			expr_free(left);
 			left = netlink_parse_concat_expr(ctx, loc, sreg, set->key->len);
 			if (left == NULL)
 				return;
-- 
2.11.0

