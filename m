From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 2/4] netfilter: conntrack: introduce nf_ct_acct_update()
Date: Tue,  3 May 2016 12:51:55 +0200
Message-ID: <1462272716-23603-2-git-send-email-pablo@netfilter.org>
References: <1462272716-23603-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50997 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755546AbcECKwZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 May 2016 06:52:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C589013C0D9
	for <netfilter-devel@vger.kernel.org>; Tue,  3 May 2016 12:52:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B2F4CA864
	for <netfilter-devel@vger.kernel.org>; Tue,  3 May 2016 12:52:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A452FB5045
	for <netfilter-devel@vger.kernel.org>; Tue,  3 May 2016 12:52:18 +0200 (CEST)
In-Reply-To: <1462272716-23603-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Introduce a helper function to update conntrack counters.
__nf_ct_kill_acct() was unnecessarily subtracting skb_network_offset()
that is expected to be zero from the ipv4/ipv6 hooks.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 42 ++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 32fba4f..8462b54 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -601,6 +601,21 @@ out:
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_hash_check_insert);
 
+static inline void nf_ct_acct_update(struct nf_conn *ct,
+				     enum ip_conntrack_info ctinfo,
+				     unsigned int len)
+{
+	struct nf_conn_acct *acct;
+
+	acct = nf_conn_acct_find(ct);
+	if (acct) {
+		struct nf_conn_counter *counter = acct->counter;
+
+		atomic64_inc(&counter[CTINFO2DIR(ctinfo)].packets);
+		atomic64_add(len, &counter[CTINFO2DIR(ctinfo)].bytes);
+	}
+}
+
 /* Confirm a connection given skb; places it in hash table */
 int
 __nf_conntrack_confirm(struct sk_buff *skb)
@@ -1251,17 +1266,8 @@ void __nf_ct_refresh_acct(struct nf_conn *ct,
 	}
 
 acct:
-	if (do_acct) {
-		struct nf_conn_acct *acct;
-
-		acct = nf_conn_acct_find(ct);
-		if (acct) {
-			struct nf_conn_counter *counter = acct->counter;
-
-			atomic64_inc(&counter[CTINFO2DIR(ctinfo)].packets);
-			atomic64_add(skb->len, &counter[CTINFO2DIR(ctinfo)].bytes);
-		}
-	}
+	if (do_acct)
+		nf_ct_acct_update(ct, ctinfo, skb->len);
 }
 EXPORT_SYMBOL_GPL(__nf_ct_refresh_acct);
 
@@ -1270,18 +1276,8 @@ bool __nf_ct_kill_acct(struct nf_conn *ct,
 		       const struct sk_buff *skb,
 		       int do_acct)
 {
-	if (do_acct) {
-		struct nf_conn_acct *acct;
-
-		acct = nf_conn_acct_find(ct);
-		if (acct) {
-			struct nf_conn_counter *counter = acct->counter;
-
-			atomic64_inc(&counter[CTINFO2DIR(ctinfo)].packets);
-			atomic64_add(skb->len - skb_network_offset(skb),
-				     &counter[CTINFO2DIR(ctinfo)].bytes);
-		}
-	}
+	if (do_acct)
+		nf_ct_acct_update(ct, ctinfo, skb->len);
 
 	if (del_timer(&ct->timeout)) {
 		ct->timeout.function((unsigned long)ct);
-- 
2.1.4

