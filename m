From: pablo@netfilter.org
Subject: [PATCH 2/6] netfilter: ctnetlink: allow to set expectation class
Date: Thu,  9 Feb 2012 20:33:03 +0100
Message-ID: <1328815987-28020-3-git-send-email-pablo@netfilter.org>
References: <1328815987-28020-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57798 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758422Ab2BITd0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Feb 2012 14:33:26 -0500
In-Reply-To: <1328815987-28020-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch allows you to set the expectation class.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nfnetlink_conntrack.h |    1 +
 net/netfilter/nf_conntrack_netlink.c          |   10 +++++++++-
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_conntrack.h b/include/linux/netfilter/nfnetlink_conntrack.h
index debf1ae..40d7c19 100644
--- a/include/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/linux/netfilter/nfnetlink_conntrack.h
@@ -172,6 +172,7 @@ enum ctattr_expect {
 	CTA_EXPECT_HELP_NAME,
 	CTA_EXPECT_ZONE,
 	CTA_EXPECT_FLAGS,
+	CTA_EXPECT_CLASS,
 	__CTA_EXPECT_MAX
 };
 #define CTA_EXPECT_MAX (__CTA_EXPECT_MAX - 1)
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 8338d67..f185301 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1668,6 +1668,7 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 	NLA_PUT_BE32(skb, CTA_EXPECT_TIMEOUT, htonl(timeout));
 	NLA_PUT_BE32(skb, CTA_EXPECT_ID, htonl((unsigned long)exp));
 	NLA_PUT_BE32(skb, CTA_EXPECT_FLAGS, htonl(exp->flags));
+	NLA_PUT_BE32(skb, CTA_EXPECT_CLASS, htonl(exp->class));
 	help = nfct_help(master);
 	if (help) {
 		struct nf_conntrack_helper *helper;
@@ -1833,6 +1834,7 @@ static const struct nla_policy exp_nla_policy[CTA_EXPECT_MAX+1] = {
 	[CTA_EXPECT_HELP_NAME]	= { .type = NLA_NUL_STRING },
 	[CTA_EXPECT_ZONE]	= { .type = NLA_U16 },
 	[CTA_EXPECT_FLAGS]	= { .type = NLA_U32 },
+	[CTA_EXPECT_CLASS]	= { .type = NLA_U32 },
 };
 
 static int
@@ -2018,6 +2020,7 @@ ctnetlink_create_expect(struct net *net, u16 zone,
 	struct nf_conn *ct;
 	struct nf_conn_help *help;
 	struct nf_conntrack_helper *helper = NULL;
+	u_int32_t class = 0;
 	int err = 0;
 
 	/* caller guarantees that those three CTA_EXPECT_* exist */
@@ -2058,6 +2061,11 @@ ctnetlink_create_expect(struct net *net, u16 zone,
 		}
 	}
 
+	if (cda[CTA_EXPECT_CLASS] && helper) {
+		class = ntohl(nla_get_be32(cda[CTA_EXPECT_CLASS]));
+		if (class > helper->expect_class_max)
+			return -EINVAL;
+	}
 	exp = nf_ct_expect_alloc(ct);
 	if (!exp) {
 		err = -ENOMEM;
@@ -2085,7 +2093,7 @@ ctnetlink_create_expect(struct net *net, u16 zone,
 			exp->flags = 0;
 	}
 
-	exp->class = 0;
+	exp->class = class;
 	exp->expectfn = NULL;
 	exp->master = ct;
 	exp->helper = helper;
-- 
1.7.7.3

