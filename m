From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 7/7] netfilter: restart search if moved to other chain
Date: Wed, 24 Aug 2016 13:55:55 +0200
Message-ID: <1472039755-14267-8-git-send-email-fw@strlen.de>
References: <1472039755-14267-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:45526 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932790AbcHXL4F (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Aug 2016 07:56:05 -0400
In-Reply-To: <1472039755-14267-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In case nf_conntrack_tuple_taken did not find a conflicting entry
check that all entries in this hash slot were tested and restart
in case an entry was moved to another chain.

Reported-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 2f7f759..4dda1ec 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -837,6 +837,7 @@ nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
 	zone = nf_ct_zone(ignored_conntrack);
 
 	rcu_read_lock();
+ begin:
 	nf_conntrack_get_ht(&ct_hash, &hsize);
 	hash = __hash_conntrack(net, tuple, hsize);
 
@@ -858,6 +859,12 @@ nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
 		}
 		NF_CT_STAT_INC_ATOMIC(net, searched);
 	}
+
+	if (get_nulls_value(n) != hash) {
+		NF_CT_STAT_INC_ATOMIC(net, search_restart);
+		goto begin;
+	}
+
 	rcu_read_unlock();
 
 	return 0;
-- 
2.7.3

