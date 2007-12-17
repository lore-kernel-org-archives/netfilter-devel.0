From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 56/64]: nf_nat: properly use RCU for ip_nat_decode_session
Date: Tue, 18 Dec 2007 00:47:29 +0100 (MET)
Message-ID: <20071217234729.23601.9507.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39055 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933284AbXLQXrb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:47:31 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_nat: properly use RCU for ip_nat_decode_session

We need to use rcu_assign_pointer/rcu_dereference to avoid races.
Also remove an obsolete CONFIG_IP_NAT_NEEDED ifdef.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 47ebc04c5a75d528fe66549793aec32cb2d9e444
tree 2389cf3412db22b99402ef249e0978e4c902f5e3
parent 6ca04829cbe594b37035da22f809445c31d58f8a
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:58:49 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:59 +0100

 include/linux/netfilter.h              |   11 ++++++++---
 net/ipv4/netfilter/nf_nat_standalone.c |    6 +++---
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 0947424..1a84873 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -256,11 +256,16 @@ extern void (*ip_nat_decode_session)(struct sk_buff *, struct flowi *);
 static inline void
 nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl, int family)
 {
-#if defined(CONFIG_IP_NF_NAT_NEEDED) || defined(CONFIG_NF_NAT_NEEDED)
+#ifdef CONFIG_NF_NAT_NEEDED
 	void (*decodefn)(struct sk_buff *, struct flowi *);
 
-	if (family == AF_INET && (decodefn = ip_nat_decode_session) != NULL)
-		decodefn(skb, fl);
+	if (family == AF_INET) {
+		rcu_read_lock();
+		decodefn = rcu_dereference(ip_nat_decode_session);
+		if (decodefn)
+			decodefn(skb, fl);
+		rcu_read_unlock();
+	}
 #endif
 }
 
diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index a2b02f0..99b2c78 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -332,7 +332,7 @@ static int __init nf_nat_standalone_init(void)
 
 #ifdef CONFIG_XFRM
 	BUG_ON(ip_nat_decode_session != NULL);
-	ip_nat_decode_session = nat_decode_session;
+	rcu_assign_pointer(ip_nat_decode_session, nat_decode_session);
 #endif
 	ret = nf_nat_rule_init();
 	if (ret < 0) {
@@ -350,7 +350,7 @@ static int __init nf_nat_standalone_init(void)
 	nf_nat_rule_cleanup();
  cleanup_decode_session:
 #ifdef CONFIG_XFRM
-	ip_nat_decode_session = NULL;
+	rcu_assign_pointer(ip_nat_decode_session, NULL);
 	synchronize_net();
 #endif
 	return ret;
@@ -361,7 +361,7 @@ static void __exit nf_nat_standalone_fini(void)
 	nf_unregister_hooks(nf_nat_ops, ARRAY_SIZE(nf_nat_ops));
 	nf_nat_rule_cleanup();
 #ifdef CONFIG_XFRM
-	ip_nat_decode_session = NULL;
+	rcu_assign_pointer(ip_nat_decode_session, NULL);
 	synchronize_net();
 #endif
 	/* Conntrack caches are unregistered in nf_conntrack_cleanup */
