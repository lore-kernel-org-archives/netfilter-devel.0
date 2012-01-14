From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 8/8] netfilter: ipset: hash:net,iface timeout bug fixed
Date: Sat, 14 Jan 2012 17:39:01 +0100
Message-ID: <1326559141-26783-9-git-send-email-kadlec@blackhole.kfki.hu>
References: <1326559141-26783-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:60293 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755551Ab2ANQjW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Jan 2012 11:39:22 -0500
In-Reply-To: <1326559141-26783-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Timed out entries were still matched till the garbage collector
purged them out. The fix is verified in the testsuite.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
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
1.7.0.4

