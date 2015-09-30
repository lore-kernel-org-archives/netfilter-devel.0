From: Flavio Leitner <fbl@sysclose.org>
Subject: [PATCH] netfilter: remove dead code
Date: Wed, 30 Sep 2015 10:23:50 -0300
Message-ID: <1443619430-5302-1-git-send-email-fbl@sysclose.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sender163-mail.zoho.com ([74.201.84.163]:25195 "EHLO
	sender163-mail.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932774AbbI3NYK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Sep 2015 09:24:10 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove __nf_conntrack_find() from headers.
Fixes: dcd93ed4cd1 ("netfilter: nf_conntrack: remove dead code"

Signed-off-by: Flavio Leitner <fbl@sysclose.org>
---
 include/net/netfilter/nf_conntrack.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index d642f68..fde4068 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -183,10 +183,6 @@ void *nf_ct_alloc_hashtable(unsigned int *sizep, int nulls);
 
 void nf_ct_free_hashtable(void *hash, unsigned int size);
 
-struct nf_conntrack_tuple_hash *
-__nf_conntrack_find(struct net *net, u16 zone,
-		    const struct nf_conntrack_tuple *tuple);
-
 int nf_conntrack_hash_check_insert(struct nf_conn *ct);
 bool nf_ct_delete(struct nf_conn *ct, u32 pid, int report);
 
-- 
2.4.3


