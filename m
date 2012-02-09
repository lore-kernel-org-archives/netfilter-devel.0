From: pablo@netfilter.org
Subject: [PATCH 1/6] netfilter: ctnetlink: allow to set helper for new expectations
Date: Thu,  9 Feb 2012 20:33:02 +0100
Message-ID: <1328815987-28020-2-git-send-email-pablo@netfilter.org>
References: <1328815987-28020-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57795 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758422Ab2BITdY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Feb 2012 14:33:24 -0500
In-Reply-To: <1328815987-28020-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch allow you to set the helper for newly created
expectations based of the CTA_EXPECT_HELP_NAME attribute.
Before this, the helper set was NULL.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 9307b03..8338d67 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2017,6 +2017,7 @@ ctnetlink_create_expect(struct net *net, u16 zone,
 	struct nf_conntrack_expect *exp;
 	struct nf_conn *ct;
 	struct nf_conn_help *help;
+	struct nf_conntrack_helper *helper = NULL;
 	int err = 0;
 
 	/* caller guarantees that those three CTA_EXPECT_* exist */
@@ -2035,6 +2036,28 @@ ctnetlink_create_expect(struct net *net, u16 zone,
 	if (!h)
 		return -ENOENT;
 	ct = nf_ct_tuplehash_to_ctrack(h);
+
+	/* Look for helper of this expectation */
+	if (cda[CTA_EXPECT_HELP_NAME]) {
+		const char *helpname = nla_data(cda[CTA_EXPECT_HELP_NAME]);
+
+		helper = __nf_conntrack_helper_find(helpname, nf_ct_l3num(ct),
+						    nf_ct_protonum(ct));
+		if (helper == NULL) {
+#ifdef CONFIG_MODULES
+			if (request_module("nfct-helper-%s", helpname) < 0)
+				return -EOPNOTSUPP;
+
+			helper = __nf_conntrack_helper_find(helpname,
+							    nf_ct_l3num(ct),
+							    nf_ct_protonum(ct));
+			if (helper)
+				return -EAGAIN;
+#endif
+			return -EOPNOTSUPP;
+		}
+	}
+
 	exp = nf_ct_expect_alloc(ct);
 	if (!exp) {
 		err = -ENOMEM;
@@ -2065,7 +2088,7 @@ ctnetlink_create_expect(struct net *net, u16 zone,
 	exp->class = 0;
 	exp->expectfn = NULL;
 	exp->master = ct;
-	exp->helper = NULL;
+	exp->helper = helper;
 	memcpy(&exp->tuple, &tuple, sizeof(struct nf_conntrack_tuple));
 	memcpy(&exp->mask.src.u3, &mask.src.u3, sizeof(exp->mask.src.u3));
 	exp->mask.src.u.all = mask.src.u.all;
-- 
1.7.7.3

