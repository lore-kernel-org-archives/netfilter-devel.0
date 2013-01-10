From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables RFC PATCH 5/6] nft: Use the right payload parsing function when saving a rule
Date: Thu, 10 Jan 2013 16:29:38 +0200
Message-ID: <1357828179-18664-6-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1357828179-18664-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:10179 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219Ab3AJO3u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jan 2013 09:29:50 -0500
In-Reply-To: <1357828179-18664-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 47 insertions(+), 2 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index f12008a..7b36942 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1269,7 +1269,7 @@ static const char *mask_to_str(uint32_t mask)
 }
 
 static void
-nft_print_payload(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter)
+nft_print_payload_ipv4(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter)
 {
 	uint32_t offset;
 	bool inv;
@@ -1313,6 +1313,48 @@ nft_print_payload(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter)
 }
 
 static void
+nft_print_payload_ipv6(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter)
+{
+	uint32_t offset;
+	bool inv;
+
+	offset = nft_rule_expr_get_u32(e, NFT_EXPR_PAYLOAD_OFFSET);
+
+	switch (offset) {
+	char addr_str[INET6_ADDRSTRLEN];
+	struct in6_addr addr;
+	uint8_t proto;
+	case offsetof(struct ip6_hdr, ip6_src):
+		get_cmp_data(iter, &addr, sizeof(addr), &inv);
+		inet_ntop(AF_INET6, &addr, addr_str, INET6_ADDRSTRLEN);
+
+		if (inv)
+			printf("! -s %s ", addr_str);
+		else
+			printf("-s %s ", addr_str);
+
+		break;
+	case offsetof(struct ip6_hdr, ip6_dst):
+		get_cmp_data(iter, &addr, sizeof(addr), &inv);
+		inet_ntop(AF_INET6, &addr, addr_str, INET6_ADDRSTRLEN);
+
+		if (inv)
+			printf("! -d %s ", addr_str);
+		else
+			printf("-d %s ", addr_str);
+
+		break;
+	case offsetof(struct ip6_hdr, ip6_nxt):
+		get_cmp_data(iter, &proto, sizeof(proto), &inv);
+		print_proto(proto, inv);
+		break;
+	default:
+		DEBUGP("unknown payload offset %d\n", offset);
+		break;
+	}
+}
+
+static void
 nft_print_counters(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
 		   bool counters)
 {
@@ -1343,7 +1385,10 @@ static void nft_rule_print_save(struct nft_rule *r, bool counters)
 		if (strcmp(name, "counter") == 0) {
 			nft_print_counters(expr, iter, counters);
 		} else if (strcmp(name, "payload") == 0) {
-			nft_print_payload(expr, iter);
+			if (nft_rule_get_family(r) == AF_INET)
+				nft_print_payload_ipv4(expr, iter);
+			else
+				nft_print_payload_ipv6(expr, iter);
 		} else if (strcmp(name, "meta") == 0) {
 			nft_print_meta(expr, iter);
 		} else if (strcmp(name, "match") == 0) {
-- 
1.8.0.2

