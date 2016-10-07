From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH iptables 2/8] extensions: libxt_iprange: rename "ip saddr" to "ip6 saddr" in ip6tables-xlate
Date: Fri,  7 Oct 2016 19:08:50 +0800
Message-ID: <1475838536-28816-3-git-send-email-zlpnobody@163.com>
References: <1475838536-28816-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:59186 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752447AbcJGLKB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Oct 2016 07:10:01 -0400
In-Reply-To: <1475838536-28816-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

nft will complain the syntax error if we use "ip saddr" or "ip daddr" in
ip6 family, so the current translation is wrong:
  # ip6tables-translate -A OUTPUT -m iprange --src-range 2003::1-2003::3
  nft add rule ip6 filter OUTPUT ip saddr 2003::1-2003::3 counter
                                 ^^

Apply this patch:
  # ip6tables-translate -A OUTPUT -m iprange --src-range 2003::1-2003::3
  nft add rule ip6 filter OUTPUT ip6 saddr 2003::1-2003::3 counter

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 extensions/libxt_iprange.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index 9e6f555..a76f1e9 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -380,7 +380,7 @@ static int iprange_mt6_xlate(struct xt_xlate *xl,
 	if (info->flags & IPRANGE_SRC) {
 		if (info->flags & IPRANGE_SRC_INV)
 			xt_xlate_add(xl, "!= ");
-		xt_xlate_add(xl, "ip saddr %s",
+		xt_xlate_add(xl, "ip6 saddr %s",
 			   xtables_ip6addr_to_numeric(&info->src_min.in6));
 		xt_xlate_add(xl, "-%s",
 			   xtables_ip6addr_to_numeric(&info->src_max.in6));
@@ -391,7 +391,7 @@ static int iprange_mt6_xlate(struct xt_xlate *xl,
 			xt_xlate_add(xl, "%s!= ", space);
 			space = "";
 		}
-		xt_xlate_add(xl, "%sip daddr %s", space,
+		xt_xlate_add(xl, "%sip6 daddr %s", space,
 			   xtables_ip6addr_to_numeric(&info->dst_min.in6));
 		xt_xlate_add(xl, "-%s",
 			   xtables_ip6addr_to_numeric(&info->dst_max.in6));
-- 
2.5.5


