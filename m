From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/2] netlink_linearize: skip NFTNL_EXPR_DYNSET_TIMEOUT attribute if timeout is unset
Date: Tue, 12 Jul 2016 17:11:00 +0200
Message-ID: <1468336260-1766-2-git-send-email-pablo@netfilter.org>
References: <1468336260-1766-1-git-send-email-pablo@netfilter.org>
Cc: akp@akp.dk
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36728 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754974AbcGLPLT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Jul 2016 11:11:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 848A6392E0C
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Jul 2016 17:11:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 75667AD6F
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Jul 2016 17:11:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5E0CFFAB48
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Jul 2016 17:11:09 +0200 (CEST)
In-Reply-To: <1468336260-1766-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Otherwise kernel bails out with EINVAL in case that the sets got no
timeout flag.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_linearize.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 01a85d0..f4db685 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1027,8 +1027,9 @@ static void netlink_gen_set_stmt(struct netlink_linearize_ctx *ctx,
 
 	nle = alloc_nft_expr("dynset");
 	netlink_put_register(nle, NFTNL_EXPR_DYNSET_SREG_KEY, sreg_key);
-	nftnl_expr_set_u64(nle, NFTNL_EXPR_DYNSET_TIMEOUT,
-			   stmt->set.key->timeout);
+	if (stmt->set.key->timeout > 0)
+		nftnl_expr_set_u64(nle, NFTNL_EXPR_DYNSET_TIMEOUT,
+				   stmt->set.key->timeout);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_DYNSET_OP, stmt->set.op);
 	nftnl_expr_set_str(nle, NFTNL_EXPR_DYNSET_SET_NAME, set->handle.set);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_DYNSET_SET_ID, set->handle.set_id);
-- 
2.1.4

