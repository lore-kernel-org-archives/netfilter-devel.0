From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2,v2] netfilter: nfnetlink_cthelper: fix runtime expectation policy updates
Date: Tue, 21 Mar 2017 14:12:28 +0100
Message-ID: <1490101948-13537-1-git-send-email-pablo@netfilter.org>
Cc: zlpnobody@gmail.com, jeffy.chen@rock-chips.com,
        dianders@chromium.org, briannorris@chromium.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48972 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932499AbdCUNXs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 09:23:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D9BCA16B282
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 14:12:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CAAC6DA870
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 14:12:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E2A10DA872
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 14:12:35 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We only allow runtime updates of expectation policies for timeout and
maximum number of expectations, otherwise reject the update.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: While at this, make sure we don't break atomicity in case of malformed
    netlink attributes. So we fully apply the policy update or not at all.

 net/netfilter/nfnetlink_cthelper.c | 86 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 84 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index de8782345c86..73ec861b90d5 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -254,6 +254,89 @@ nfnl_cthelper_create(const struct nlattr * const tb[],
 }
 
 static int
+nfnl_cthelper_update_policy_one(const struct nf_conntrack_expect_policy *policy,
+				struct nf_conntrack_expect_policy *new_policy,
+				const struct nlattr *attr)
+{
+	struct nlattr *tb[NFCTH_POLICY_MAX + 1];
+	int err;
+
+	err = nla_parse_nested(tb, NFCTH_POLICY_MAX, attr,
+			       nfnl_cthelper_expect_pol);
+	if (err < 0)
+		return err;
+
+	if (!tb[NFCTH_POLICY_NAME] ||
+	    !tb[NFCTH_POLICY_EXPECT_MAX] ||
+	    !tb[NFCTH_POLICY_EXPECT_TIMEOUT])
+		return -EINVAL;
+
+	if (nla_strcmp(tb[NFCTH_POLICY_NAME], policy->name))
+		return -EBUSY;
+
+	new_policy->max_expected =
+		ntohl(nla_get_be32(tb[NFCTH_POLICY_EXPECT_MAX]));
+	new_policy->timeout =
+		ntohl(nla_get_be32(tb[NFCTH_POLICY_EXPECT_TIMEOUT]));
+
+	return 0;
+}
+
+static int nfnl_cthelper_update_policy_all(struct nlattr *tb[],
+					   struct nf_conntrack_helper *helper)
+{
+	struct nf_conntrack_expect_policy new_policy[helper->expect_class_max];
+	struct nf_conntrack_expect_policy *policy;
+	int i, err;
+
+	/* Check first that all policy attributes are well-formed, so we don't
+	 * leave things in inconsistent state on errors.
+	 */
+	for (i = 0; i < helper->expect_class_max; i++) {
+
+		if (!tb[NFCTH_POLICY_SET + i])
+			return -EINVAL;
+
+		err = nfnl_cthelper_update_policy_one(&helper->expect_policy[i],
+						      &new_policy[i],
+						      tb[NFCTH_POLICY_SET + i]);
+		if (err < 0)
+			return err;
+	}
+	/* Now we can safely update them. */
+	for (i = 0; i < helper->expect_class_max; i++) {
+		policy = (struct nf_conntrack_expect_policy *)
+				&helper->expect_policy[i];
+		policy->max_expected = new_policy->max_expected;
+		policy->timeout	= new_policy->timeout;
+	}
+
+	return 0;
+}
+
+static int nfnl_cthelper_update_policy(struct nf_conntrack_helper *helper,
+				       const struct nlattr *attr)
+{
+	struct nlattr *tb[NFCTH_POLICY_SET_MAX + 1];
+	unsigned int class_max;
+	int err;
+
+	err = nla_parse_nested(tb, NFCTH_POLICY_SET_MAX, attr,
+			       nfnl_cthelper_expect_policy_set);
+	if (err < 0)
+		return err;
+
+	if (!tb[NFCTH_POLICY_SET_NUM])
+		return -EINVAL;
+
+	class_max = ntohl(nla_get_be32(tb[NFCTH_POLICY_SET_NUM]));
+	if (helper->expect_class_max != class_max)
+		return -EBUSY;
+
+	return nfnl_cthelper_update_policy_all(tb, helper);
+}
+
+static int
 nfnl_cthelper_update(const struct nlattr * const tb[],
 		     struct nf_conntrack_helper *helper)
 {
@@ -263,8 +346,7 @@ nfnl_cthelper_update(const struct nlattr * const tb[],
 		return -EBUSY;
 
 	if (tb[NFCTH_POLICY]) {
-		ret = nfnl_cthelper_parse_expect_policy(helper,
-							tb[NFCTH_POLICY]);
+		ret = nfnl_cthelper_update_policy(helper, tb[NFCTH_POLICY]);
 		if (ret < 0)
 			return ret;
 	}
-- 
2.1.4

