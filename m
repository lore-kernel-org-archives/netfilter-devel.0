From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/8] netfilter: nf_conntrack: Uses pr_fmt() for logging.
Date: Wed, 13 Apr 2016 01:02:39 +0200
Message-ID: <1460502166-20340-2-git-send-email-pablo@netfilter.org>
References: <1460502166-20340-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1460502166-20340-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Weongyo Jeong <weongyo.linux@gmail.com>

Uses pr_fmt() macro for debugging messages of nf_conntrack module.

Signed-off-by: Weongyo Jeong <weongyo.linux@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index afde5f5..2fd6074 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -12,6 +12,8 @@
  * published by the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/types.h>
 #include <linux/netfilter.h>
 #include <linux/module.h>
@@ -966,7 +968,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 
 	if (!l4proto->new(ct, skb, dataoff, timeouts)) {
 		nf_conntrack_free(ct);
-		pr_debug("init conntrack: can't track with proto module\n");
+		pr_debug("can't track with proto module\n");
 		return NULL;
 	}
 
@@ -988,7 +990,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 		spin_lock(&nf_conntrack_expect_lock);
 		exp = nf_ct_find_expectation(net, zone, tuple);
 		if (exp) {
-			pr_debug("conntrack: expectation arrives ct=%p exp=%p\n",
+			pr_debug("expectation arrives ct=%p exp=%p\n",
 				 ct, exp);
 			/* Welcome, Mr. Bond.  We've been expecting you... */
 			__set_bit(IPS_EXPECTED_BIT, &ct->status);
@@ -1053,7 +1055,7 @@ resolve_normal_ct(struct net *net, struct nf_conn *tmpl,
 	if (!nf_ct_get_tuple(skb, skb_network_offset(skb),
 			     dataoff, l3num, protonum, net, &tuple, l3proto,
 			     l4proto)) {
-		pr_debug("resolve_normal_ct: Can't get tuple\n");
+		pr_debug("Can't get tuple\n");
 		return NULL;
 	}
 
@@ -1079,14 +1081,13 @@ resolve_normal_ct(struct net *net, struct nf_conn *tmpl,
 	} else {
 		/* Once we've had two way comms, always ESTABLISHED. */
 		if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
-			pr_debug("nf_conntrack_in: normal packet for %p\n", ct);
+			pr_debug("normal packet for %p\n", ct);
 			*ctinfo = IP_CT_ESTABLISHED;
 		} else if (test_bit(IPS_EXPECTED_BIT, &ct->status)) {
-			pr_debug("nf_conntrack_in: related packet for %p\n",
-				 ct);
+			pr_debug("related packet for %p\n", ct);
 			*ctinfo = IP_CT_RELATED;
 		} else {
-			pr_debug("nf_conntrack_in: new packet for %p\n", ct);
+			pr_debug("new packet for %p\n", ct);
 			*ctinfo = IP_CT_NEW;
 		}
 		*set_reply = 0;
-- 
2.1.4
