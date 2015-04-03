From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next] netfilter: x_tables: don't bail out on mismatching revision
Date: Fri,  3 Apr 2015 13:22:04 +0200
Message-ID: <1428060124-7710-1-git-send-email-pablo@netfilter.org>
Cc: zhangcy@cn.fujitsu.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33079 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbbDCLSK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Apr 2015 07:18:10 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We have to give a chance to find the match/target that is registered using the
NFPROTO_UNSPEC family. This is causing us problems to add MARK target support to
arptables since we need to register an explicit struct xt_target for the
NFPROTO_ARP family.

Remove the -EPROTOTYPE error that was introduced long time ago in 2e4e6a1
("[NETFILTER] x_tables: Abstraction layer for {ip,ip6,arp}_tables"). I cannot
find any userspace code relying on this error code. So let's just instead bail
out with -ENOENT.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
@Zhang: please, give a test to this and let me know if this resolves the
problem for you, so we avoid to register the redundant xt_target structure for
MARK. Thanks.

 net/netfilter/x_tables.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 51a459c..a7baf90 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -182,7 +182,6 @@ EXPORT_SYMBOL(xt_unregister_matches);
 struct xt_match *xt_find_match(u8 af, const char *name, u8 revision)
 {
 	struct xt_match *m;
-	int err = -ENOENT;
 
 	mutex_lock(&xt[af].mutex);
 	list_for_each_entry(m, &xt[af].match, list) {
@@ -192,8 +191,7 @@ struct xt_match *xt_find_match(u8 af, const char *name, u8 revision)
 					mutex_unlock(&xt[af].mutex);
 					return m;
 				}
-			} else
-				err = -EPROTOTYPE; /* Found something. */
+			}
 		}
 	}
 	mutex_unlock(&xt[af].mutex);
@@ -202,7 +200,7 @@ struct xt_match *xt_find_match(u8 af, const char *name, u8 revision)
 		/* Try searching again in the family-independent list */
 		return xt_find_match(NFPROTO_UNSPEC, name, revision);
 
-	return ERR_PTR(err);
+	return ERR_PTR(-ENOENT);
 }
 EXPORT_SYMBOL(xt_find_match);
 
@@ -225,7 +223,6 @@ EXPORT_SYMBOL_GPL(xt_request_find_match);
 struct xt_target *xt_find_target(u8 af, const char *name, u8 revision)
 {
 	struct xt_target *t;
-	int err = -ENOENT;
 
 	mutex_lock(&xt[af].mutex);
 	list_for_each_entry(t, &xt[af].target, list) {
@@ -235,8 +232,7 @@ struct xt_target *xt_find_target(u8 af, const char *name, u8 revision)
 					mutex_unlock(&xt[af].mutex);
 					return t;
 				}
-			} else
-				err = -EPROTOTYPE; /* Found something. */
+			}
 		}
 	}
 	mutex_unlock(&xt[af].mutex);
@@ -245,7 +241,7 @@ struct xt_target *xt_find_target(u8 af, const char *name, u8 revision)
 		/* Try searching again in the family-independent list */
 		return xt_find_target(NFPROTO_UNSPEC, name, revision);
 
-	return ERR_PTR(err);
+	return ERR_PTR(-ENOENT);
 }
 EXPORT_SYMBOL(xt_find_target);
 
-- 
1.7.10.4

