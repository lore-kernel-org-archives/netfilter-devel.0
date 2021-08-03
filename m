Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58538C4320A
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Aug 2021 23:27:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38DE860E78
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Aug 2021 23:27:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbhHCX1n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 19:27:43 -0400
Received: from mail.netfilter.org ([217.70.188.207]:54550 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbhHCX1m (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 19:27:42 -0400
Received: from salvia.lan (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id B967F60044;
        Wed,  4 Aug 2021 01:26:52 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nf 2/2] netfilter: nfnetlink_hook: Use same family as request message
Date:   Wed,  4 Aug 2021 01:27:20 +0200
Message-Id: <20210803232720.25833-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210803232720.25833-1-pablo@netfilter.org>
References: <20210803232720.25833-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use the same family as the request message, for consistency. The
netlink payload provides sufficient information to describe the hook
object, including the family.

This makes it easier to userspace to correlate the hooks are that
visited by the packets for a certain family.

Fixes: e2cf17d3774c ("netfilter: add new hook nfnl subsystem")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_hook.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
index f204752ba4a4..52324ca26d9b 100644
--- a/net/netfilter/nfnetlink_hook.c
+++ b/net/netfilter/nfnetlink_hook.c
@@ -113,7 +113,7 @@ static int nfnl_hook_put_nft_chain_info(struct sk_buff *nlskb,
 static int nfnl_hook_dump_one(struct sk_buff *nlskb,
 			      const struct nfnl_dump_hook_data *ctx,
 			      const struct nf_hook_ops *ops,
-			      unsigned int seq)
+			      int family, unsigned int seq)
 {
 	u16 event = nfnl_msg_type(NFNL_SUBSYS_HOOK, NFNL_MSG_HOOK_GET);
 	unsigned int portid = NETLINK_CB(nlskb).portid;
@@ -124,7 +124,7 @@ static int nfnl_hook_dump_one(struct sk_buff *nlskb,
 	char *module_name;
 #endif
 	nlh = nfnl_msg_put(nlskb, portid, seq, event,
-			   NLM_F_MULTI, ops->pf, NFNETLINK_V0, 0);
+			   NLM_F_MULTI, family, NFNETLINK_V0, 0);
 	if (!nlh)
 		goto nla_put_failure;
 
@@ -262,7 +262,7 @@ static int nfnl_hook_dump(struct sk_buff *nlskb,
 	ops = nf_hook_entries_get_hook_ops(e);
 
 	for (; i < e->num_hook_entries; i++) {
-		err = nfnl_hook_dump_one(nlskb, ctx, ops[i],
+		err = nfnl_hook_dump_one(nlskb, ctx, ops[i], family,
 					 cb->nlh->nlmsg_seq);
 		if (err)
 			break;
-- 
2.20.1

