From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH iptables 3/8] extensions: libxt_iprange: handle the invert flag properly in translation
Date: Fri,  7 Oct 2016 19:08:51 +0800
Message-ID: <1475838536-28816-4-git-send-email-zlpnobody@163.com>
References: <1475838536-28816-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:59228 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752215AbcJGLKC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Oct 2016 07:10:02 -0400
In-Reply-To: <1475838536-28816-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

If we specify the invert flag, we should put "!=" after "ip saddr/daddr",
so the current translation is wrong:
  # iptables-translate -A OUTPUT -m iprange ! --dst-range 1.1.1.1-1.1.1.2
  nft add rule ip filter OUTPUT != ip daddr 1.1.1.1-1.1.1.2 counter

  # ip6tables-translate -A OUTPUT -m iprange ! --src-range 2003::1-2003::3
  nft add rule ip6 filter OUTPUT != ip6 saddr 2003::1-2003::3 counter

Apply this patch:
  # iptables-translate -A OUTPUT -m iprange ! --dst-range 1.1.1.1-1.1.1.2
  nft add rule ip filter OUTPUT ip daddr != 1.1.1.1-1.1.1.2 counter

  # ip6tables-translate -A OUTPUT -m iprange ! --src-range 2003::1-2003::3
  nft add rule ip6 filter OUTPUT ip6 saddr != 2003::1-2003::3 counter

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 extensions/libxt_iprange.c | 52 ++++++++++++++++++----------------------------
 1 file changed, 20 insertions(+), 32 deletions(-)

diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index a76f1e9..8be2481 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -322,18 +322,14 @@ static int iprange_xlate(struct xt_xlate *xl,
 	char *space = "";
 
 	if (info->flags & IPRANGE_SRC) {
-		if (info->flags & IPRANGE_SRC_INV)
-			xt_xlate_add(xl, "!= ");
-		xt_xlate_add(xl, "ip saddr");
+		xt_xlate_add(xl, "ip saddr%s",
+			     info->flags & IPRANGE_SRC_INV ? " !=" : "");
 		print_iprange_xlate(&info->src, xl);
 		space = " ";
 	}
 	if (info->flags & IPRANGE_DST) {
-		if (info->flags & IPRANGE_DST_INV) {
-			xt_xlate_add(xl, "%s!= ", space);
-			space = "";
-		}
-		xt_xlate_add(xl, "%sip daddr", space);
+		xt_xlate_add(xl, "%sip daddr%s", space,
+			     info->flags & IPRANGE_DST_INV ? " !=" : "");
 		print_iprange_xlate(&info->dst, xl);
 	}
 
@@ -348,23 +344,19 @@ static int iprange_mt4_xlate(struct xt_xlate *xl,
 	char *space = "";
 
 	if (info->flags & IPRANGE_SRC) {
-		if (info->flags & IPRANGE_SRC_INV)
-			xt_xlate_add(xl, "!= ");
-		xt_xlate_add(xl, "ip saddr %s",
-			   xtables_ipaddr_to_numeric(&info->src_min.in));
+		xt_xlate_add(xl, "ip saddr%s %s",
+			     info->flags & IPRANGE_SRC_INV ? " !=" : "",
+			     xtables_ipaddr_to_numeric(&info->src_min.in));
 		xt_xlate_add(xl, "-%s",
-			   xtables_ipaddr_to_numeric(&info->src_max.in));
+			     xtables_ipaddr_to_numeric(&info->src_max.in));
 		space = " ";
 	}
 	if (info->flags & IPRANGE_DST) {
-		if (info->flags & IPRANGE_DST_INV) {
-			xt_xlate_add(xl, "%s!= ", space);
-			space = "";
-		}
-		xt_xlate_add(xl, "%sip daddr %s", space,
-			   xtables_ipaddr_to_numeric(&info->dst_min.in));
+		xt_xlate_add(xl, "%sip daddr%s %s", space,
+			     info->flags & IPRANGE_DST_INV ? " !=" : "",
+			     xtables_ipaddr_to_numeric(&info->dst_min.in));
 		xt_xlate_add(xl, "-%s",
-			   xtables_ipaddr_to_numeric(&info->dst_max.in));
+			     xtables_ipaddr_to_numeric(&info->dst_max.in));
 	}
 
 	return 1;
@@ -378,23 +370,19 @@ static int iprange_mt6_xlate(struct xt_xlate *xl,
 	char *space = "";
 
 	if (info->flags & IPRANGE_SRC) {
-		if (info->flags & IPRANGE_SRC_INV)
-			xt_xlate_add(xl, "!= ");
-		xt_xlate_add(xl, "ip6 saddr %s",
-			   xtables_ip6addr_to_numeric(&info->src_min.in6));
+		xt_xlate_add(xl, "ip6 saddr%s %s",
+			     info->flags & IPRANGE_SRC_INV ? " !=" : "",
+			     xtables_ip6addr_to_numeric(&info->src_min.in6));
 		xt_xlate_add(xl, "-%s",
-			   xtables_ip6addr_to_numeric(&info->src_max.in6));
+			     xtables_ip6addr_to_numeric(&info->src_max.in6));
 		space = " ";
 	}
 	if (info->flags & IPRANGE_DST) {
-		if (info->flags & IPRANGE_DST_INV) {
-			xt_xlate_add(xl, "%s!= ", space);
-			space = "";
-		}
-		xt_xlate_add(xl, "%sip6 daddr %s", space,
-			   xtables_ip6addr_to_numeric(&info->dst_min.in6));
+		xt_xlate_add(xl, "%sip6 daddr%s %s", space,
+			     info->flags & IPRANGE_DST_INV ? " !=" : "",
+			     xtables_ip6addr_to_numeric(&info->dst_min.in6));
 		xt_xlate_add(xl, "-%s",
-			   xtables_ip6addr_to_numeric(&info->dst_max.in6));
+			     xtables_ip6addr_to_numeric(&info->dst_max.in6));
 	}
 
 	return 1;
-- 
2.5.5


