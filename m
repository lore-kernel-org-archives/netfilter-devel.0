From: Stephen Hemminger <shemming@brocade.com>
Subject: [PATCH] netfilter: remove duplicate include
Date: Tue, 17 Nov 2015 13:45:53 -0800
Message-ID: <20151117134553.0e2c5344@samsung9>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:61582 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753964AbbKQVqC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Nov 2015 16:46:02 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>

--- a/net/ipv4/netfilter/nf_reject_ipv4.c	2015-11-17 13:34:27.073539571 -0800
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c	2015-11-17 13:34:45.833884092 -0800
@@ -14,7 +14,6 @@
 #include <net/netfilter/ipv4/nf_reject.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_bridge.h>
-#include <net/netfilter/ipv4/nf_reject.h>
 
 const struct tcphdr *nf_reject_ip_tcphdr_get(struct sk_buff *oldskb,
 					     struct tcphdr *_oth, int hook)
--- a/net/ipv6/netfilter/nf_reject_ipv6.c	2015-11-17 13:34:27.073539571 -0800
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c	2015-11-17 13:35:00.870163173 -0800
@@ -14,7 +14,6 @@
 #include <net/netfilter/ipv6/nf_reject.h>
 #include <linux/netfilter_ipv6.h>
 #include <linux/netfilter_bridge.h>
-#include <net/netfilter/ipv6/nf_reject.h>
 
 const struct tcphdr *nf_reject_ip6_tcphdr_get(struct sk_buff *oldskb,
 					      struct tcphdr *otcph,
