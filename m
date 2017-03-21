From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2 nf] netfilter: nfnetlink_cthelper: fix runtime expectation policy updates
Date: Tue, 21 Mar 2017 13:41:33 +0100
Message-ID: <1490100094-32269-1-git-send-email-pablo@netfilter.org>
Cc: zlpnobody@gmail.com, jeffy.chen@rock-chips.com,
        dianders@chromium.org, briannorris@chromium.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52206 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932547AbdCUMsn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 08:48:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E60701324F0
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 13:41:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D7F7CDA86E
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 13:41:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B4E37DA2D3
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 13:41:36 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We only allow runtime updates of expectation policies for timeout and
maximum number of expectations, otherwise reject the update.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_cthelper.c | 68 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 66 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index de8782345c86..ffb51b91e646 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -254,6 +254,71 @@ nfnl_cthelper_create(const struct nlattr * const tb[],
 }
 
 static int
+nfnl_cthelper_update_policy_one(struct nf_conntrack_expect_policy *expect_policy,
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
+	if (nla_strcmp(tb[NFCTH_POLICY_NAME], expect_policy->name))
+		return -EBUSY;
+
+	expect_policy->max_expected =
+		ntohl(nla_get_be32(tb[NFCTH_POLICY_EXPECT_MAX]));
+	expect_policy->timeout =
+		ntohl(nla_get_be32(tb[NFCTH_POLICY_EXPECT_TIMEOUT]));
+
+	return 0;
+}
+
+static int
+nfnl_cthelper_update_policy(struct nf_conntrack_helper *helper,
+			    const struct nlattr *attr)
+{
+	struct nf_conntrack_expect_policy *expect_policy;
+	struct nlattr *tb[NFCTH_POLICY_SET_MAX + 1];
+	unsigned int class_max;
+	int i, err;
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
+	for (i = 0; i < helper->expect_class_max; i++) {
+		if (!tb[NFCTH_POLICY_SET + i])
+			return -EINVAL;
+
+		expect_policy =
+			(struct nf_conntrack_expect_policy *)
+				&helper->expect_policy[i];
+		err = nfnl_cthelper_update_policy_one(expect_policy,
+						      tb[NFCTH_POLICY_SET + i]);
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+
+static int
 nfnl_cthelper_update(const struct nlattr * const tb[],
 		     struct nf_conntrack_helper *helper)
 {
@@ -263,8 +328,7 @@ nfnl_cthelper_update(const struct nlattr * const tb[],
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

