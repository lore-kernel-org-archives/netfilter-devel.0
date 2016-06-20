From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH iptables] libxt_iprange: remove extra space in translation
Date: Mon, 20 Jun 2016 12:24:56 +0200
Message-ID: <20160620102456.31875-1-pablombg@gmail.com>
Cc: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33269 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbcFTKZl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jun 2016 06:25:41 -0400
Received: by mail-wm0-f66.google.com with SMTP id r201so12878246wme.0
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Jun 2016 03:25:40 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Extra space was printed by iprange_xlate:

  # iptables-translate -A INPUT -m iprange --src-range \
    192.168.25.149-192.168.25.151 -j ACCEPT

  nft add rule ip filter INPUT  ip saddr 192.168.25.149-192.168.25...
                              ^^

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 extensions/libxt_iprange.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index c2d51e9..8da7de1 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -322,14 +322,14 @@ static int iprange_xlate(const void *ip, const struct xt_entry_match *match,
 
 	if (info->flags & IPRANGE_SRC) {
 		if (info->flags & IPRANGE_SRC_INV)
-			xt_xlate_add(xl, " !=");
-		xt_xlate_add(xl, " ip saddr");
+			xt_xlate_add(xl, "!= ");
+		xt_xlate_add(xl, "ip saddr");
 		print_iprange_xlate(&info->src, xl);
 	}
 	if (info->flags & IPRANGE_DST) {
 		if (info->flags & IPRANGE_DST_INV)
-			xt_xlate_add(xl, " !=");
-		xt_xlate_add(xl, " ip daddr");
+			xt_xlate_add(xl, "!= ");
+		xt_xlate_add(xl, "ip daddr");
 		print_iprange_xlate(&info->dst, xl);
 	}
 
@@ -343,16 +343,16 @@ static int iprange_mt4_xlate(const void *ip, const struct xt_entry_match *match,
 
 	if (info->flags & IPRANGE_SRC) {
 		if (info->flags & IPRANGE_SRC_INV)
-			xt_xlate_add(xl, " !=");
-		xt_xlate_add(xl, " ip saddr %s",
+			xt_xlate_add(xl, "!= ");
+		xt_xlate_add(xl, "ip saddr %s",
 			   xtables_ipaddr_to_numeric(&info->src_min.in));
 		xt_xlate_add(xl, "-%s ",
 			   xtables_ipaddr_to_numeric(&info->src_max.in));
 	}
 	if (info->flags & IPRANGE_DST) {
 		if (info->flags & IPRANGE_DST_INV)
-			xt_xlate_add(xl, " !=");
-		xt_xlate_add(xl, " ip daddr %s",
+			xt_xlate_add(xl, "!= ");
+		xt_xlate_add(xl, "ip daddr %s",
 			   xtables_ipaddr_to_numeric(&info->dst_min.in));
 		xt_xlate_add(xl, "-%s ",
 			   xtables_ipaddr_to_numeric(&info->dst_max.in));
@@ -368,16 +368,16 @@ static int iprange_mt6_xlate(const void *ip, const struct xt_entry_match *match,
 
 	if (info->flags & IPRANGE_SRC) {
 		if (info->flags & IPRANGE_SRC_INV)
-			xt_xlate_add(xl, " !=");
-		xt_xlate_add(xl, " ip saddr %s",
+			xt_xlate_add(xl, "!= ");
+		xt_xlate_add(xl, "ip saddr %s",
 			   xtables_ip6addr_to_numeric(&info->src_min.in6));
 		xt_xlate_add(xl, "-%s ",
 			   xtables_ip6addr_to_numeric(&info->src_max.in6));
 	}
 	if (info->flags & IPRANGE_DST) {
 		if (info->flags & IPRANGE_DST_INV)
-			xt_xlate_add(xl, " !=");
-		xt_xlate_add(xl, " ip daddr %s",
+			xt_xlate_add(xl, "!= ");
+		xt_xlate_add(xl, "ip daddr %s",
 			   xtables_ip6addr_to_numeric(&info->dst_min.in6));
 		xt_xlate_add(xl, "-%s ",
 			   xtables_ip6addr_to_numeric(&info->dst_max.in6));
-- 
2.8.3

