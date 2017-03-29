From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/8] netfilter: nfnl_cthelper: fix incorrect helper->expect_class_max
Date: Wed, 29 Mar 2017 14:14:03 +0200
Message-ID: <1490789650-7294-2-git-send-email-pablo@netfilter.org>
References: <1490789650-7294-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43116 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755908AbdC2MOm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Mar 2017 08:14:42 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 25D08EBAC3
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 14:14:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 166CEDA848
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 14:14:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9DD79DA862
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 14:14:35 +0200 (CEST)
In-Reply-To: <1490789650-7294-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

The helper->expect_class_max must be set to the total number of
expect_policy minus 1, since we will use the statement "if (class >
helper->expect_class_max)" to validate the CTA_EXPECT_CLASS attr in
ctnetlink_alloc_expect.

So for compatibility, set the helper->expect_class_max to the
NFCTH_POLICY_SET_NUM attr's value minus 1.

Also: it's invalid when the NFCTH_POLICY_SET_NUM attr's value is zero.
1. this will result "expect_policy = kzalloc(0, GFP_KERNEL);";
2. we cannot set the helper->expect_class_max to a proper value.

So if nla_get_be32(tb[NFCTH_POLICY_SET_NUM]) is zero, report -EINVAL to
the userspace.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_cthelper.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index de8782345c86..3cd41d105407 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -161,6 +161,7 @@ nfnl_cthelper_parse_expect_policy(struct nf_conntrack_helper *helper,
 	int i, ret;
 	struct nf_conntrack_expect_policy *expect_policy;
 	struct nlattr *tb[NFCTH_POLICY_SET_MAX+1];
+	unsigned int class_max;
 
 	ret = nla_parse_nested(tb, NFCTH_POLICY_SET_MAX, attr,
 			       nfnl_cthelper_expect_policy_set);
@@ -170,19 +171,18 @@ nfnl_cthelper_parse_expect_policy(struct nf_conntrack_helper *helper,
 	if (!tb[NFCTH_POLICY_SET_NUM])
 		return -EINVAL;
 
-	helper->expect_class_max =
-		ntohl(nla_get_be32(tb[NFCTH_POLICY_SET_NUM]));
-
-	if (helper->expect_class_max != 0 &&
-	    helper->expect_class_max > NF_CT_MAX_EXPECT_CLASSES)
+	class_max = ntohl(nla_get_be32(tb[NFCTH_POLICY_SET_NUM]));
+	if (class_max == 0)
+		return -EINVAL;
+	if (class_max > NF_CT_MAX_EXPECT_CLASSES)
 		return -EOVERFLOW;
 
 	expect_policy = kzalloc(sizeof(struct nf_conntrack_expect_policy) *
-				helper->expect_class_max, GFP_KERNEL);
+				class_max, GFP_KERNEL);
 	if (expect_policy == NULL)
 		return -ENOMEM;
 
-	for (i=0; i<helper->expect_class_max; i++) {
+	for (i = 0; i < class_max; i++) {
 		if (!tb[NFCTH_POLICY_SET+i])
 			goto err;
 
@@ -191,6 +191,8 @@ nfnl_cthelper_parse_expect_policy(struct nf_conntrack_helper *helper,
 		if (ret < 0)
 			goto err;
 	}
+
+	helper->expect_class_max = class_max - 1;
 	helper->expect_policy = expect_policy;
 	return 0;
 err:
@@ -377,10 +379,10 @@ nfnl_cthelper_dump_policy(struct sk_buff *skb,
 		goto nla_put_failure;
 
 	if (nla_put_be32(skb, NFCTH_POLICY_SET_NUM,
-			 htonl(helper->expect_class_max)))
+			 htonl(helper->expect_class_max + 1)))
 		goto nla_put_failure;
 
-	for (i=0; i<helper->expect_class_max; i++) {
+	for (i = 0; i < helper->expect_class_max + 1; i++) {
 		nest_parms2 = nla_nest_start(skb,
 				(NFCTH_POLICY_SET+i) | NLA_F_NESTED);
 		if (nest_parms2 == NULL)
-- 
2.1.4

