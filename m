From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 32/51] netfilter: ebtables: remove EBT_MATCH and EBT_NOMATCH
Date: Mon,  7 May 2018 00:46:50 +0200
Message-ID: <20180506224709.29100-33-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

EBT_MATCH and EBT_NOMATCH are used to change return value.
match functions(ebt_xxx.c) return false when received frame is not matched
and returns true when received frame is matched.
but, EBT_MATCH_ITERATE understands oppositely.
so, to change return value, EBT_MATCH and EBT_NOMATCH are used.
but, we can use operation '!' simply.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_bridge/ebtables.h | 4 ----
 net/bridge/netfilter/ebtables.c           | 2 +-
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index 0773b5a032f1..c6935be7c6ca 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -17,10 +17,6 @@
 #include <linux/if_ether.h>
 #include <uapi/linux/netfilter_bridge/ebtables.h>
 
-/* return values for match() functions */
-#define EBT_MATCH 0
-#define EBT_NOMATCH 1
-
 struct ebt_match {
 	struct list_head list;
 	const char name[EBT_FUNCTION_MAXNAMELEN];
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 355410b13316..7c07221369c0 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -101,7 +101,7 @@ ebt_do_match(struct ebt_entry_match *m, const struct sk_buff *skb,
 {
 	par->match     = m->u.match;
 	par->matchinfo = m->data;
-	return m->u.match->match(skb, par) ? EBT_MATCH : EBT_NOMATCH;
+	return !m->u.match->match(skb, par);
 }
 
 static inline int
-- 
2.11.0
