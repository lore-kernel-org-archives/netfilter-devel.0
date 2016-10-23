From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 13/22] netfilter: ipset: Make sure element data size is a multiple of u32
Date: Sun, 23 Oct 2016 22:37:46 +0200
Message-ID: <1477255075-15255-14-git-send-email-kadlec@blackhole.kfki.hu>
References: <1477255075-15255-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:50860 "EHLO smtp2.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756733AbcJWUiC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Oct 2016 16:38:02 -0400
In-Reply-To: <1477255075-15255-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Data for hashing required to be array of u32. Make sure that
element data always multiple of u32.

Ported from a patch proposed by Sergey Popovich <popovich_sergei@mail.ua>.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index ab5b57c..e2f4925 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -262,8 +262,14 @@ struct net_prefixes {
 #endif
 
 #define HKEY(data, initval, htable_bits)			\
-(jhash2((u32 *)(data), HKEY_DATALEN / sizeof(u32), initval)	\
-	& jhash_mask(htable_bits))
+({								\
+	const u32 *__k = (const u32 *)data;			\
+	u32 __l = HKEY_DATALEN / sizeof(u32);			\
+								\
+	BUILD_BUG_ON(HKEY_DATALEN % sizeof(u32) != 0);		\
+								\
+	jhash2(__k, __l, initval) & jhash_mask(htable_bits);	\
+})
 
 #ifndef htype
 #ifndef HTYPE
-- 
1.8.5.1

