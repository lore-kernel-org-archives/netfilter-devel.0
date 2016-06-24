From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next] netfilter: x_tables: simplify ip{6}table_mangle_hook()
Date: Fri, 24 Jun 2016 19:48:30 +0200
Message-ID: <1466790510-8368-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45836 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbcFXRsi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Jun 2016 13:48:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C380B2B50E0
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Jun 2016 19:48:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B51CA9EBA5
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Jun 2016 19:48:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9399D9EBAA
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Jun 2016 19:48:33 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

No need for a special case for NF_INET_POST_ROUTING.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/iptable_mangle.c  | 4 ----
 net/ipv6/netfilter/ip6table_mangle.c | 4 ----
 2 files changed, 8 deletions(-)

diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index 57fc97c..aebdb33 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -87,10 +87,6 @@ iptable_mangle_hook(void *priv,
 {
 	if (state->hook == NF_INET_LOCAL_OUT)
 		return ipt_mangle_out(skb, state);
-	if (state->hook == NF_INET_POST_ROUTING)
-		return ipt_do_table(skb, state,
-				    state->net->ipv4.iptable_mangle);
-	/* PREROUTING/INPUT/FORWARD: */
 	return ipt_do_table(skb, state, state->net->ipv4.iptable_mangle);
 }
 
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index cb2b288..2b1a9dc 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -83,10 +83,6 @@ ip6table_mangle_hook(void *priv, struct sk_buff *skb,
 {
 	if (state->hook == NF_INET_LOCAL_OUT)
 		return ip6t_mangle_out(skb, state);
-	if (state->hook == NF_INET_POST_ROUTING)
-		return ip6t_do_table(skb, state,
-				     state->net->ipv6.ip6table_mangle);
-	/* INPUT/FORWARD */
 	return ip6t_do_table(skb, state, state->net->ipv6.ip6table_mangle);
 }
 
-- 
2.1.4

