From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf 4/5] netfilter: nfnl_cthelper: fix memory leak when do update
Date: Sun, 19 Mar 2017 22:36:01 +0800
Message-ID: <1489934162-7415-5-git-send-email-zlpnobody@163.com>
References: <1489934162-7415-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:38606 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751763AbdCSOyM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Mar 2017 10:54:12 -0400
In-Reply-To: <1489934162-7415-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

When invoke nfnl_cthelper_update, we will malloc a new expect_policy,
then only point the helper->expect_policy to the new one but ignore
the old one, so it will be leaked forever.

Another issue is that the user can modify the expect_class_max to a
new value, for example, decrease the expect_class_max from 3 to 0.
Then, exp->class created by ctnetlink_alloc_expect may become invalid,
and out of bound access will happen.

So keep it simple, when update the cthelper, reject to modify the
expect_class_max, and we can modify the struct nf_conntrack_expect_policy
directly instead of allocing a new object, then memory leak does not
exist anymore.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/netfilter/nfnetlink_cthelper.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index cc70dd5..fc4733f 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -156,7 +156,7 @@ nfnl_cthelper_expect_policy_set[NFCTH_POLICY_SET_MAX+1] = {
 
 static int
 nfnl_cthelper_parse_expect_policy(struct nf_conntrack_helper *helper,
-				  const struct nlattr *attr)
+				  const struct nlattr *attr, bool update)
 {
 	int i, ret;
 	struct nf_conntrack_expect_policy *expect_policy;
@@ -172,15 +172,23 @@ nfnl_cthelper_parse_expect_policy(struct nf_conntrack_helper *helper,
 		return -EINVAL;
 
 	class_max = ntohl(nla_get_be32(tb[NFCTH_POLICY_SET_NUM]));
-	if (class_max == 0)
-		return -EINVAL;
-	if (class_max > NF_CT_MAX_EXPECT_CLASSES)
-		return -EOVERFLOW;
 
-	expect_policy = kzalloc(sizeof(struct nf_conntrack_expect_policy) *
-				class_max, GFP_KERNEL);
-	if (expect_policy == NULL)
-		return -ENOMEM;
+	if (update) {
+		if (helper->expect_class_max + 1 != class_max)
+			return -EINVAL;
+
+		expect_policy = helper->expect_policy;
+	} else {
+		if (class_max == 0)
+			return -EINVAL;
+		if (class_max > NF_CT_MAX_EXPECT_CLASSES)
+			return -EOVERFLOW;
+
+		expect_policy = kcalloc(class_max, sizeof(*expect_policy),
+					GFP_KERNEL);
+		if (expect_policy == NULL)
+			return -ENOMEM;
+	}
 
 	for (i = 0; i < class_max; i++) {
 		if (!tb[NFCTH_POLICY_SET+i])
@@ -196,7 +204,8 @@ nfnl_cthelper_parse_expect_policy(struct nf_conntrack_helper *helper,
 	helper->expect_policy = expect_policy;
 	return 0;
 err:
-	kfree(expect_policy);
+	if (!update)
+		kfree(expect_policy);
 	return -EINVAL;
 }
 
@@ -214,7 +223,8 @@ nfnl_cthelper_create(const struct nlattr * const tb[],
 	if (helper == NULL)
 		return -ENOMEM;
 
-	ret = nfnl_cthelper_parse_expect_policy(helper, tb[NFCTH_POLICY]);
+	ret = nfnl_cthelper_parse_expect_policy(helper, tb[NFCTH_POLICY],
+						false);
 	if (ret < 0)
 		goto err1;
 
@@ -269,7 +279,8 @@ nfnl_cthelper_update(const struct nlattr * const tb[],
 
 	if (tb[NFCTH_POLICY]) {
 		ret = nfnl_cthelper_parse_expect_policy(helper,
-							tb[NFCTH_POLICY]);
+							tb[NFCTH_POLICY],
+							true);
 		if (ret < 0)
 			return ret;
 	}
-- 
2.5.5


