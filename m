From: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH net-next] ipset: remove unused code
Date: Mon, 30 Dec 2013 17:13:10 -0800
Message-ID: <20131230171310.1fbbe4b0@nehalam.linuxnetplumber.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:62332 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932365Ab3LaBNQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Dec 2013 20:13:16 -0500
Received: by mail-pd0-f181.google.com with SMTP id p10so11862818pdj.12
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2013 17:13:15 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Function never used in current upstream code.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>


--- a/include/linux/netfilter/ipset/ip_set.h	2013-12-30 15:37:28.704768854 -0800
+++ b/include/linux/netfilter/ipset/ip_set.h	2013-12-30 16:59:22.806917895 -0800
@@ -331,7 +331,6 @@ extern ip_set_id_t ip_set_get_byname(str
 				     const char *name, struct ip_set **set);
 extern void ip_set_put_byindex(struct net *net, ip_set_id_t index);
 extern const char *ip_set_name_byindex(struct net *net, ip_set_id_t index);
-extern ip_set_id_t ip_set_nfnl_get(struct net *net, const char *name);
 extern ip_set_id_t ip_set_nfnl_get_byindex(struct net *net, ip_set_id_t index);
 extern void ip_set_nfnl_put(struct net *net, ip_set_id_t index);
 
--- a/net/netfilter/ipset/ip_set_core.c	2013-12-30 15:37:28.704768854 -0800
+++ b/net/netfilter/ipset/ip_set_core.c	2013-12-30 16:59:22.810917833 -0800
@@ -625,34 +625,6 @@ EXPORT_SYMBOL_GPL(ip_set_name_byindex);
  */
 
 /*
- * Find set by name, reference it once. The reference makes sure the
- * thing pointed to, does not go away under our feet.
- *
- * The nfnl mutex is used in the function.
- */
-ip_set_id_t
-ip_set_nfnl_get(struct net *net, const char *name)
-{
-	ip_set_id_t i, index = IPSET_INVALID_ID;
-	struct ip_set *s;
-	struct ip_set_net *inst = ip_set_pernet(net);
-
-	nfnl_lock(NFNL_SUBSYS_IPSET);
-	for (i = 0; i < inst->ip_set_max; i++) {
-		s = nfnl_set(inst, i);
-		if (s != NULL && STREQ(s->name, name)) {
-			__ip_set_get(s);
-			index = i;
-			break;
-		}
-	}
-	nfnl_unlock(NFNL_SUBSYS_IPSET);
-
-	return index;
-}
-EXPORT_SYMBOL_GPL(ip_set_nfnl_get);
-
-/*
  * Find set by index, reference it once. The reference makes sure the
  * thing pointed to, does not go away under our feet.
  *
