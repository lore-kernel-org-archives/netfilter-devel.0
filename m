From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 28/32] netfilter: return booleans instead of integers
Date: Fri, 19 Jan 2018 20:10:37 +0100
Message-ID: <20180119191041.25804-29-pablo@netfilter.org>
References: <20180119191041.25804-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45156 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756275AbeASTL1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jan 2018 14:11:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id ED3A32EFEBC
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 20:11:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D9AE0DA858
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 20:11:11 +0100 (CET)
In-Reply-To: <20180119191041.25804-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>

Return statements in functions returning bool should use
true/false instead of 1/0.

These issues were detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conncount.c | 2 +-
 net/netfilter/xt_hashlimit.c | 2 +-
 net/netfilter/xt_ipcomp.c    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index a95518261168..6d65389e308f 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -71,7 +71,7 @@ static inline bool already_closed(const struct nf_conn *conn)
 		return conn->proto.tcp.state == TCP_CONNTRACK_TIME_WAIT ||
 		       conn->proto.tcp.state == TCP_CONNTRACK_CLOSE;
 	else
-		return 0;
+		return false;
 }
 
 static int key_diff(const u32 *a, const u32 *b, unsigned int klen)
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 5da8746f7b88..ec51d9a9512d 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -353,7 +353,7 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
 static bool select_all(const struct xt_hashlimit_htable *ht,
 		       const struct dsthash_ent *he)
 {
-	return 1;
+	return true;
 }
 
 static bool select_gc(const struct xt_hashlimit_htable *ht,
diff --git a/net/netfilter/xt_ipcomp.c b/net/netfilter/xt_ipcomp.c
index 000e70377f85..7ca64a50db04 100644
--- a/net/netfilter/xt_ipcomp.c
+++ b/net/netfilter/xt_ipcomp.c
@@ -58,7 +58,7 @@ static bool comp_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		 */
 		pr_debug("Dropping evil IPComp tinygram.\n");
 		par->hotdrop = true;
-		return 0;
+		return false;
 	}
 
 	return spi_match(compinfo->spis[0], compinfo->spis[1],
-- 
2.11.0

