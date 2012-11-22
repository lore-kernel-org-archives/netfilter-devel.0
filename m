From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 2/2] netfilter: nla_policy updates
Date: Thu, 22 Nov 2012 12:32:46 +0100
Message-ID: <1353583966-12402-2-git-send-email-fw@strlen.de>
References: <1353583966-12402-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37260 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757146Ab2KVTfk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:35:40 -0500
In-Reply-To: <1353583966-12402-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add stricter checking for a few attributes.
Note that these changes don't fix any bug in the current code base.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Sending these patches separate, so you
 could add the first (bug fix) to net and this one to -next.

 In case you would like to apply both to the same
 tree, feel free to squash them into a single commit.

 net/netfilter/nf_conntrack_netlink.c   |    8 ++++++--
 net/netfilter/nf_conntrack_proto_tcp.c |    2 ++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 7bbfb3d..4f41128 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -898,7 +898,8 @@ ctnetlink_parse_zone(const struct nlattr *attr, u16 *zone)
 }
 
 static const struct nla_policy help_nla_policy[CTA_HELP_MAX+1] = {
-	[CTA_HELP_NAME]		= { .type = NLA_NUL_STRING },
+	[CTA_HELP_NAME]		= { .type = NLA_NUL_STRING,
+				    .len = NF_CT_HELPER_NAME_LEN - 1 },
 };
 
 static inline int
@@ -932,6 +933,8 @@ static const struct nla_policy ct_nla_policy[CTA_MAX+1] = {
 	[CTA_ID]		= { .type = NLA_U32 },
 	[CTA_NAT_DST]		= { .type = NLA_NESTED },
 	[CTA_TUPLE_MASTER]	= { .type = NLA_NESTED },
+	[CTA_NAT_SEQ_ADJ_ORIG]  = { .type = NLA_NESTED },
+	[CTA_NAT_SEQ_ADJ_REPLY] = { .type = NLA_NESTED },
 	[CTA_ZONE]		= { .type = NLA_U16 },
 	[CTA_MARK_MASK]		= { .type = NLA_U32 },
 };
@@ -2216,7 +2219,8 @@ static const struct nla_policy exp_nla_policy[CTA_EXPECT_MAX+1] = {
 	[CTA_EXPECT_MASK]	= { .type = NLA_NESTED },
 	[CTA_EXPECT_TIMEOUT]	= { .type = NLA_U32 },
 	[CTA_EXPECT_ID]		= { .type = NLA_U32 },
-	[CTA_EXPECT_HELP_NAME]	= { .type = NLA_NUL_STRING },
+	[CTA_EXPECT_HELP_NAME]	= { .type = NLA_NUL_STRING,
+				    .len = NF_CT_HELPER_NAME_LEN - 1 },
 	[CTA_EXPECT_ZONE]	= { .type = NLA_U16 },
 	[CTA_EXPECT_FLAGS]	= { .type = NLA_U32 },
 	[CTA_EXPECT_CLASS]	= { .type = NLA_U32 },
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 61f9285..83876e9 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1353,6 +1353,8 @@ static const struct nla_policy tcp_timeout_nla_policy[CTA_TIMEOUT_TCP_MAX+1] = {
 	[CTA_TIMEOUT_TCP_TIME_WAIT]	= { .type = NLA_U32 },
 	[CTA_TIMEOUT_TCP_CLOSE]		= { .type = NLA_U32 },
 	[CTA_TIMEOUT_TCP_SYN_SENT2]	= { .type = NLA_U32 },
+	[CTA_TIMEOUT_TCP_RETRANS]	= { .type = NLA_U32 },
+	[CTA_TIMEOUT_TCP_UNACK]		= { .type = NLA_U32 },
 };
 #endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
 
-- 
1.7.8.6

