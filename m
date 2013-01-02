From: Ulrich Weber <ulrich.weber@sophos.com>
Subject: [PATCH] iptables: allow IPv6 port NAT without address NAT
Date: Wed, 2 Jan 2013 16:52:44 +0100
Message-ID: <20130102155244.GB5133@uweber-WS>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx2.sophos.com ([145.253.124.138]:59750 "EHLO mx2.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978Ab3ABPwr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jan 2013 10:52:47 -0500
Received: from mx2.sophos.com (localhost.localdomain [127.0.0.1])
	by localhost (Postfix) with SMTP id 98EB618831D
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Jan 2013 15:52:46 +0000 (GMT)
Received: from de-wie-exch3b.green.sophos (de-wie-exch3b.green.sophos [10.60.70.62])
	by mx2.sophos.com (Postfix) with ESMTPS id 6368918831C
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Jan 2013 15:52:46 +0000 (GMT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

correct parsing of IPv6 port NAT without address NAT
and also print brackets for port only IPv6 NAT.

Signed-off-by: Ulrich Weber <ulrich.weber@sophos.com>
---
 extensions/libip6t_DNAT.c | 12 +++++-------
 extensions/libip6t_SNAT.c | 12 +++++-------
 2 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/extensions/libip6t_DNAT.c b/extensions/libip6t_DNAT.c
index a5969c3..6f11d52 100644
--- a/extensions/libip6t_DNAT.c
+++ b/extensions/libip6t_DNAT.c
@@ -105,8 +105,8 @@ parse_to(const char *orig_arg, int portok, struct nf_nat_range *range)
 			range->min_proto.tcp.port = htons(port);
 			range->max_proto.tcp.port = htons(maxport);
 		}
-		/* Starts with a colon? No IP info...*/
-		if (colon == arg) {
+		/* Starts with [] colon? No IP info...*/
+		if (colon == arg+2) {
 			free(arg);
 			return;
 		}
@@ -183,18 +183,16 @@ static void DNAT_fcheck(struct xt_fcheck_call *cb)
 
 static void print_range(const struct nf_nat_range *range)
 {
+	if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED)
+		printf("[");
 	if (range->flags & NF_NAT_RANGE_MAP_IPS) {
-		if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED)
-			printf("[");
 		printf("%s", xtables_ip6addr_to_numeric(&range->min_addr.in6));
 		if (memcmp(&range->min_addr, &range->max_addr,
 			   sizeof(range->min_addr)))
 			printf("-%s", xtables_ip6addr_to_numeric(&range->max_addr.in6));
-		if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED)
-			printf("]");
 	}
 	if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
-		printf(":");
+		printf("]:");
 		printf("%hu", ntohs(range->min_proto.tcp.port));
 		if (range->max_proto.tcp.port != range->min_proto.tcp.port)
 			printf("-%hu", ntohs(range->max_proto.tcp.port));
diff --git a/extensions/libip6t_SNAT.c b/extensions/libip6t_SNAT.c
index 307be70..8d2c87e 100644
--- a/extensions/libip6t_SNAT.c
+++ b/extensions/libip6t_SNAT.c
@@ -105,8 +105,8 @@ parse_to(const char *orig_arg, int portok, struct nf_nat_range *range)
 			range->min_proto.tcp.port = htons(port);
 			range->max_proto.tcp.port = htons(maxport);
 		}
-		/* Starts with a colon? No IP info...*/
-		if (colon == arg) {
+		/* Starts with [] colon? No IP info...*/
+		if (colon == arg+2) {
 			free(arg);
 			return;
 		}
@@ -183,18 +183,16 @@ static void SNAT_fcheck(struct xt_fcheck_call *cb)
 
 static void print_range(const struct nf_nat_range *range)
 {
+	if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED)
+		printf("[");
 	if (range->flags & NF_NAT_RANGE_MAP_IPS) {
-		if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED)
-			printf("[");
 		printf("%s", xtables_ip6addr_to_numeric(&range->min_addr.in6));
 		if (memcmp(&range->min_addr, &range->max_addr,
 			   sizeof(range->min_addr)))
 			printf("-%s", xtables_ip6addr_to_numeric(&range->max_addr.in6));
-		if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED)
-			printf("]");
 	}
 	if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
-		printf(":");
+		printf("]:");
 		printf("%hu", ntohs(range->min_proto.tcp.port));
 		if (range->max_proto.tcp.port != range->min_proto.tcp.port)
 			printf("-%hu", ntohs(range->max_proto.tcp.port));
-- 
1.8.0.2

