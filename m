Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ACDAC4338F
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Aug 2021 10:48:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 104CD60E78
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Aug 2021 10:48:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245050AbhHFKsT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Aug 2021 06:48:19 -0400
Received: from mail.netfilter.org ([217.70.188.207]:33128 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244773AbhHFKsT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Aug 2021 06:48:19 -0400
Received: from salvia.lan (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9F3A66003B;
        Fri,  6 Aug 2021 12:47:21 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nf] netfilter: nfnetlink_hook: translate inet ingress to netdev
Date:   Fri,  6 Aug 2021 12:47:34 +0200
Message-Id: <20210806104734.13177-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The NFPROTO_INET pseudofamily is not exposed through this new netlink
interface. The netlink dump either shows NFPROTO_IPV4 or NFPROTO_IPV6
for NFPROTO_INET prerouting/input/forward/output/postrouting hooks.
The NFNLA_CHAIN_FAMILY attribute provides the family chain, which
specifies if this hook applies to inet traffic only (either IPv4 or
IPv6).

Translate the inet/ingress hook to netdev/ingress to fully hide the
NFPROTO_INET implementation details.

Fixes: e2cf17d3774c ("netfilter: add new hook nfnl subsystem")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_hook.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
index 52324ca26d9b..4e0788b1c11e 100644
--- a/net/netfilter/nfnetlink_hook.c
+++ b/net/netfilter/nfnetlink_hook.c
@@ -119,6 +119,7 @@ static int nfnl_hook_dump_one(struct sk_buff *nlskb,
 	unsigned int portid = NETLINK_CB(nlskb).portid;
 	struct nlmsghdr *nlh;
 	int ret = -EMSGSIZE;
+	u32 hooknum;
 #ifdef CONFIG_KALLSYMS
 	char sym[KSYM_SYMBOL_LEN];
 	char *module_name;
@@ -156,7 +157,12 @@ static int nfnl_hook_dump_one(struct sk_buff *nlskb,
 		goto nla_put_failure;
 #endif
 
-	ret = nla_put_be32(nlskb, NFNLA_HOOK_HOOKNUM, htonl(ops->hooknum));
+	if (ops->pf == NFPROTO_INET && ops->hooknum == NF_INET_INGRESS)
+		hooknum = NF_NETDEV_INGRESS;
+	else
+		hooknum = ops->hooknum;
+
+	ret = nla_put_be32(nlskb, NFNLA_HOOK_HOOKNUM, htonl(hooknum));
 	if (ret)
 		goto nla_put_failure;
 
-- 
2.20.1

