From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 03/14] netfilter: ipset: Indicate when /0 networks are supported
Date: Sun, 30 Nov 2014 19:56:54 +0100
Message-ID: <1417373825-3734-4-git-send-email-kadlec@blackhole.kfki.hu>
References: <1417373825-3734-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:57562 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbaK3S4J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Nov 2014 13:56:09 -0500
In-Reply-To: <1417373825-3734-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_gen.h      | 2 +-
 net/netfilter/ipset/ip_set_hash_netiface.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index a12ee04..9428fa5 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -156,7 +156,7 @@ hbucket_elem_add(struct hbucket *n, u8 ahash_max, size_t dsize)
 
 #define SET_HOST_MASK(family)	(family == AF_INET ? 32 : 128)
 
-#ifdef IP_SET_HASH_WITH_MULTI
+#ifdef IP_SET_HASH_WITH_NET0
 #define NLEN(family)		(SET_HOST_MASK(family) + 1)
 #else
 #define NLEN(family)		SET_HOST_MASK(family)
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index 35dd358..758b002 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -115,6 +115,7 @@ iface_add(struct rb_root *root, const char **iface)
 #define IP_SET_HASH_WITH_NETS
 #define IP_SET_HASH_WITH_RBTREE
 #define IP_SET_HASH_WITH_MULTI
+#define IP_SET_HASH_WITH_NET0
 
 #define STREQ(a, b)	(strcmp(a, b) == 0)
 
-- 
1.8.5.1

