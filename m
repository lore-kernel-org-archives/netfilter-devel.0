From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: [PATCH v2 2/2] conntrack: Remove nf_ct_conntrack_flush_report
Date: Wed, 24 Dec 2014 09:57:11 +0100
Message-ID: <1419411431-24715-3-git-send-email-kristian.evensen@gmail.com>
References: <1419411431-24715-1-git-send-email-kristian.evensen@gmail.com>
Cc: Kristian Evensen <kristian.evensen@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:37536 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbaLXI5Y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Dec 2014 03:57:24 -0500
Received: by mail-wi0-f173.google.com with SMTP id r20so12965793wiv.12
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Dec 2014 00:57:23 -0800 (PST)
In-Reply-To: <1419411431-24715-1-git-send-email-kristian.evensen@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The only user of nf_ct_conntrack_flush_report() was ctnetlink_del_conntrack().
After adding support for flushing connections with a given mark, this function
is no longer called.

Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
---
 include/net/netfilter/nf_conntrack.h | 2 --
 net/netfilter/nf_conntrack_core.c    | 6 ------
 2 files changed, 8 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index f0daed2..74f271a 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -191,8 +191,6 @@ __nf_conntrack_find(struct net *net, u16 zone,
 int nf_conntrack_hash_check_insert(struct nf_conn *ct);
 bool nf_ct_delete(struct nf_conn *ct, u32 pid, int report);
 
-void nf_conntrack_flush_report(struct net *net, u32 portid, int report);
-
 bool nf_ct_get_tuplepr(const struct sk_buff *skb, unsigned int nhoff,
 		       u_int16_t l3num, struct nf_conntrack_tuple *tuple);
 bool nf_ct_invert_tuplepr(struct nf_conntrack_tuple *inverse,
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index a116748..9f31938 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1426,12 +1426,6 @@ void nf_ct_free_hashtable(void *hash, unsigned int size)
 }
 EXPORT_SYMBOL_GPL(nf_ct_free_hashtable);
 
-void nf_conntrack_flush_report(struct net *net, u32 portid, int report)
-{
-	nf_ct_iterate_cleanup(net, kill_all, NULL, portid, report);
-}
-EXPORT_SYMBOL_GPL(nf_conntrack_flush_report);
-
 static int untrack_refs(void)
 {
 	int cnt = 0, cpu;
-- 
2.1.0

