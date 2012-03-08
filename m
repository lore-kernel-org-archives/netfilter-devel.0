From: pablo@netfilter.org
Subject: [PATCH 05/23] netfilter: ipset: hash:net,iface timeout bug fixed
Date: Thu,  8 Mar 2012 02:00:54 +0100
Message-ID: <1331168472-5820-6-git-send-email-pablo@netfilter.org>
References: <1331168472-5820-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56089 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344Ab2CHBB0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Mar 2012 20:01:26 -0500
In-Reply-To: <1331168472-5820-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Timed out entries were still matched till the garbage collector
purged them out. The fix is verified in the testsuite.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/ipset/ip_set_ahash.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set_ahash.h b/include/linux/netfilter/ipset/ip_set_ahash.h
index 0e5c3cf..05a5d72 100644
--- a/include/linux/netfilter/ipset/ip_set_ahash.h
+++ b/include/linux/netfilter/ipset/ip_set_ahash.h
@@ -1005,9 +1005,17 @@ type_pf_ttest_cidrs(struct ip_set *set, struct type_pf_elem *d, u32 timeout)
 		n = hbucket(t, key);
 		for (i = 0; i < n->pos; i++) {
 			data = ahash_tdata(n, i);
+#ifdef IP_SET_HASH_WITH_MULTI
+			if (type_pf_data_equal(data, d, &multi)) {
+				if (!type_pf_data_expired(data))
+					return type_pf_data_match(data);
+				multi = 0;
+			}
+#else
 			if (type_pf_data_equal(data, d, &multi) &&
 			    !type_pf_data_expired(data))
 				return type_pf_data_match(data);
+#endif
 		}
 	}
 	return 0;
-- 
1.7.7.3

