From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6/8] [PATCH] bump the expectation helper name
Date: Thu, 09 Oct 2008 10:35:33 +0200
Message-ID: <20081009083533.9824.21751.stgit@Decadence>
References: <20081009083339.9824.24056.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58789 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752279AbYJIIho (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Oct 2008 04:37:44 -0400
In-Reply-To: <20081009083339.9824.24056.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Include the expectation helper name at expectation dumping.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 net/netfilter/nf_conntrack_netlink.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index a115d78..01ed29c 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1443,6 +1443,7 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 			  const struct nf_conntrack_expect *exp)
 {
 	struct nf_conn *master = exp->master;
+	struct nf_conn_help *help = nfct_help(master);
 	long timeout = (exp->timeout.expires - jiffies) / HZ;
 
 	if (timeout < 0)
@@ -1460,6 +1461,14 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
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

