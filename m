From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 08/23] netfilter: remove duplicate include
Date: Fri, 18 Dec 2015 21:26:34 +0100
Message-ID: <1450470409-31427-9-git-send-email-pablo@netfilter.org>
References: <1450470409-31427-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57993 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965191AbbLRUeH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Dec 2015 15:34:07 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 779EE120B7D
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2015 21:34:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2D199DA80C
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2015 21:34:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B67EBDA876
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2015 21:33:46 +0100 (CET)
In-Reply-To: <1450470409-31427-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: stephen hemminger <shemming@brocade.com>

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_reject_ipv4.c | 1 -
 net/ipv6/netfilter/nf_reject_ipv6.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index c747b2d..b6ea57e 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -14,7 +14,6 @@
 #include <net/netfilter/ipv4/nf_reject.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_bridge.h>
-#include <net/netfilter/ipv4/nf_reject.h>
 
 const struct tcphdr *nf_reject_ip_tcphdr_get(struct sk_buff *oldskb,
 					     struct tcphdr *_oth, int hook)
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index e0f922b..4709f65 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -14,7 +14,6 @@
 #include <net/netfilter/ipv6/nf_reject.h>
 #include <linux/netfilter_ipv6.h>
 #include <linux/netfilter_bridge.h>
-#include <net/netfilter/ipv6/nf_reject.h>
 
 const struct tcphdr *nf_reject_ip6_tcphdr_get(struct sk_buff *oldskb,
 					      struct tcphdr *otcph,
-- 
2.1.4

