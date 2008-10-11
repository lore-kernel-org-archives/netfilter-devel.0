From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/6] [PATCH] bump the expectation helper name
Date: Sat, 11 Oct 2008 17:22:23 +0200
Message-ID: <20081011152223.6436.37293.stgit@Decadence>
References: <20081011152116.6436.17277.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45780 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753807AbYJKPWi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Oct 2008 11:22:38 -0400
In-Reply-To: <20081011152116.6436.17277.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Include the expectation helper name at expectation dumping.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 net/netfilter/nf_conntrack_netlink.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 3d0e9f0..1c459a8 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1446,6 +1446,7 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 			  const struct nf_conntrack_expect *exp)
 {
 	struct nf_conn *master = exp->master;
+	struct nf_conn_help *help = nfct_help(master);
 	long timeout = (exp->timeout.expires - jiffies) / HZ;
 
 	if (timeout < 0)
@@ -1463,6 +1464,14 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
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

