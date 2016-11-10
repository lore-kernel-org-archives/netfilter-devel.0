From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 15/22] netfilter: ipset: Make sure element data size is a multiple of u32
Date: Thu, 10 Nov 2016 13:57:49 +0100
Message-ID: <1478782676-9770-16-git-send-email-kadlec@blackhole.kfki.hu>
References: <1478782676-9770-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:36187 "EHLO smtp1.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933012AbcKJM6C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Nov 2016 07:58:02 -0500
In-Reply-To: <1478782676-9770-1-git-send-email-kadlec@blackhole.kfki.hu>
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
index 6c88c20..34f115f 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -260,8 +260,14 @@ struct net_prefixes {
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

