From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 1/2] Fix bug: sometimes valid entries in hash:* types of sets were evicted
Date: Sun, 19 Feb 2017 19:24:15 +0100
Message-ID: <1487528656-21961-2-git-send-email-kadlec@blackhole.kfki.hu>
References: <1487528656-21961-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:37855 "EHLO smtp1.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750938AbdBSSY6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Feb 2017 13:24:58 -0500
In-Reply-To: <1487528656-21961-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Wrong index was used and therefore when shrinking a hash bucket at
deleting an entry, valid entries could be evicted as well.
Thanks to Eric Ewanco for the thorough bugreport.

Fixes netfilter bugzilla #1119

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 1b05d4a..f236c0b 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -897,7 +897,7 @@ struct htype {
 					continue;
 				data = ahash_data(n, j, dsize);
 				memcpy(tmp->value + k * dsize, data, dsize);
-				set_bit(j, tmp->used);
+				set_bit(k, tmp->used);
 				k++;
 			}
 			tmp->pos = k;
-- 
1.8.5.1

