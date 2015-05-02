From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 30/34] netfilter: ipset: Improve preprocessor macros checks
Date: Sat,  2 May 2015 19:28:19 +0200
Message-ID: <1430587703-3387-31-git-send-email-kadlec@blackhole.kfki.hu>
References: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:36720 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbbEBR2K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2015 13:28:10 -0400
In-Reply-To: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Sergey Popovich <popovich_sergei@mail.ua>

Check if mandatory MTYPE, HTYPE and HOST_MASK macros
defined.

Signed-off-by: Sergey Popovich <popovich_sergei@mail.ua>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_gen.h    | 13 ++++++++++++-
 net/netfilter/ipset/ip_set_hash_ipmark.c |  6 +++---
 net/netfilter/ipset/ip_set_hash_ipport.c |  6 +++---
 3 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index b00b44b..453849e 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -243,6 +243,14 @@ htable_bits(u32 hashsize)
 #define mtype_variant		IPSET_TOKEN(MTYPE, _variant)
 #define mtype_data_match	IPSET_TOKEN(MTYPE, _data_match)
 
+#ifndef MTYPE
+#error "MTYPE is not defined!"
+#endif
+
+#ifndef HOST_MASK
+#error "HOST_MASK is not defined!"
+#endif
+
 #ifndef HKEY_DATALEN
 #define HKEY_DATALEN		sizeof(struct mtype_elem)
 #endif
@@ -252,6 +260,9 @@ htable_bits(u32 hashsize)
 	& jhash_mask(htable_bits))
 
 #ifndef htype
+#ifndef HTYPE
+#error "HTYPE is not defined!"
+#endif /* HTYPE */
 #define htype			HTYPE
 
 /* The generic hash structure */
@@ -275,7 +286,7 @@ struct htype {
 	struct net_prefixes nets[0]; /* book-keeping of prefixes */
 #endif
 };
-#endif
+#endif /* htype */
 
 #ifdef IP_SET_HASH_WITH_NETS
 /* Network cidr size book keeping when the hash stores different
diff --git a/net/netfilter/ipset/ip_set_hash_ipmark.c b/net/netfilter/ipset/ip_set_hash_ipmark.c
index c7d61f3..6e0324d 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -76,8 +76,8 @@ hash_ipmark4_data_next(struct hash_ipmark4_elem *next,
 	next->ip = d->ip;
 }
 
-#define MTYPE           hash_ipmark4
-#define HOST_MASK       32
+#define MTYPE		hash_ipmark4
+#define HOST_MASK	32
 #include "ip_set_hash_gen.h"
 
 static int
@@ -203,7 +203,7 @@ hash_ipmark6_data_next(struct hash_ipmark4_elem *next,
 
 #define MTYPE		hash_ipmark6
 #define HOST_MASK	128
-#define	IP_SET_EMIT_CREATE
+#define IP_SET_EMIT_CREATE
 #include "ip_set_hash_gen.h"
 
 
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
index 702882b..7a83109 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -83,8 +83,8 @@ hash_ipport4_data_next(struct hash_ipport4_elem *next,
 	next->port = d->port;
 }
 
-#define MTYPE           hash_ipport4
-#define HOST_MASK       32
+#define MTYPE		hash_ipport4
+#define HOST_MASK	32
 #include "ip_set_hash_gen.h"
 
 static int
@@ -241,7 +241,7 @@ hash_ipport6_data_next(struct hash_ipport4_elem *next,
 
 #define MTYPE		hash_ipport6
 #define HOST_MASK	128
-#define	IP_SET_EMIT_CREATE
+#define IP_SET_EMIT_CREATE
 #include "ip_set_hash_gen.h"
 
 static int
-- 
1.8.5.1

