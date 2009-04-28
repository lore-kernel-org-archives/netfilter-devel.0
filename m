From: Christoph Paasch <christoph.paasch@gmail.com>
Subject: [PATCH] netfilter: fix: support ipv6header match on packets ending with NEXTHDR_NONE
Date: Tue, 28 Apr 2009 19:05:11 +0200
Message-ID: <1240938311-22978-1-git-send-email-christoph.paasch@gmail.com>
Cc: Christoph Paasch <christoph.paasch@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:49284 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933021AbZD1RFR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Apr 2009 13:05:17 -0400
Received: by ewy24 with SMTP id 24so722027ewy.37
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2009 10:05:14 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As packets ending with NEXTHDR_NONE don't have a last extension header,
the check for the length needs to be after the check for NEXTHDR_NONE.

Signed-off-by: Christoph Paasch <christoph.paasch@gmail.com>
---
 net/ipv6/netfilter/ip6t_ipv6header.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_ipv6header.c b/net/ipv6/netfilter/ip6t_ipv6header.c
index 14e6724..91490ad 100644
--- a/net/ipv6/netfilter/ip6t_ipv6header.c
+++ b/net/ipv6/netfilter/ip6t_ipv6header.c
@@ -50,14 +50,14 @@ ipv6header_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 		struct ipv6_opt_hdr _hdr;
 		int hdrlen;
 
-		/* Is there enough space for the next ext header? */
-		if (len < (int)sizeof(struct ipv6_opt_hdr))
-			return false;
 		/* No more exthdr -> evaluate */
 		if (nexthdr == NEXTHDR_NONE) {
 			temp |= MASK_NONE;
 			break;
 		}
+		/* Is there enough space for the next ext header? */
+		if (len < (int)sizeof(struct ipv6_opt_hdr))
+			return false;
 		/* ESP -> evaluate */
 		if (nexthdr == NEXTHDR_ESP) {
 			temp |= MASK_ESP;
-- 
1.6.0.4

