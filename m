From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 10/34] netfilter: ipset: Missing rcu protection in mtype_list() fixed
Date: Sat,  2 May 2015 19:27:59 +0200
Message-ID: <1430587703-3387-11-git-send-email-kadlec@blackhole.kfki.hu>
References: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:51355 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbbEBR2E (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2015 13:28:04 -0400
In-Reply-To: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 91e5327..69f2b25 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1095,10 +1095,12 @@ mtype_list(const struct ip_set *set,
 
 	pr_debug("list hash set %s\n", set->name);
 	t = (const struct htable *) cb->args[IPSET_CB_PRIVATE];
+	/* Expire may replace a hbucket with another one */
+	rcu_read_lock();
 	for (; cb->args[IPSET_CB_ARG0] < jhash_size(t->htable_bits);
 	     cb->args[IPSET_CB_ARG0]++) {
 		incomplete = skb_tail_pointer(skb);
-		n = hbucket(t, cb->args[IPSET_CB_ARG0]);
+		n = rcu_dereference(hbucket(t, cb->args[IPSET_CB_ARG0]));
 		pr_debug("cb->arg bucket: %lu, t %p n %p\n",
 			 cb->args[IPSET_CB_ARG0], t, n);
 		if (n == NULL)
@@ -1144,6 +1146,7 @@ nla_put_failure:
 	} else
 		ipset_nest_end(skb, atd);
 out:
+	rcu_read_unlock();
 	return ret;
 }
 
-- 
1.8.5.1

