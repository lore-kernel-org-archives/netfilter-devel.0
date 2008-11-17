From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 8/8] [PATCH] bump the expectation helper name
Date: Mon, 17 Nov 2008 09:42:05 +0100
Message-ID: <20081117084205.11368.15974.stgit@Decadence>
References: <20081117083924.11368.38741.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56062 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752705AbYKQImM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Nov 2008 03:42:12 -0500
In-Reply-To: <20081117083924.11368.38741.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Include the expectation helper name at expectation dumping.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 net/netfilter/nf_conntrack_netlink.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 0205ae6..7756d29 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1517,6 +1517,7 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 			  const struct nf_conntrack_expect *exp)
 {
 	struct nf_conn *master = exp->master;
+	struct nf_conn_help *help = nfct_help(master);
 	long timeout = (exp->timeout.expires - jiffies) / HZ;
 
 	if (timeout < 0)
@@ -1534,6 +1535,14 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 	NLA_PUT_BE32(skb, CTA_EXPECT_TIMEOUT, htonl(timeout));
 	NLA_PUT_BE32(skb, CTA_EXPECT_ID, htonl((unsigned long)exp));
 
+	if (help) {
+		struct nf_conntrack_helper *helper;
+
+		helper = rcu_dereference(help->helper);
+		if (helper)
+			NLA_PUT_STRING(skb, CTA_EXPECT_HELP_NAME, helper->name);
+	}
+
 	return 0;
 
 nla_put_failure:

