From: Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH] netfilter: xt_ecn: Add missing hotdrop mark.
Date: Sat, 29 Jul 2017 19:33:00 +0900
Message-ID: <20170729103300.30447-1-ap420073@gmail.com>
Cc: ap420073@gmail.com
To: pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35698 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752516AbdG2KdI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Jul 2017 06:33:08 -0400
Received: by mail-pg0-f66.google.com with SMTP id d193so25856545pgc.2
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Jul 2017 03:33:08 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If the netfilter can't get L4 header, the netfilter
marks hotdrop value. then {ip, ip6, arp, eb}t_do_table() drops
that packet immediately. but xt_ecn doesn't mark hotdrop value.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/netfilter/xt_ecn.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/xt_ecn.c b/net/netfilter/xt_ecn.c
index 3c831a8..c58db1d 100644
--- a/net/netfilter/xt_ecn.c
+++ b/net/netfilter/xt_ecn.c
@@ -37,8 +37,10 @@ static bool match_tcp(const struct sk_buff *skb, struct xt_action_param *par)
 	 * be good citizens.
 	 */
 	th = skb_header_pointer(skb, par->thoff, sizeof(_tcph), &_tcph);
-	if (th == NULL)
+	if (!th) {
+		par->hotdrop = true;
 		return false;
+	}
 
 	if (einfo->operation & XT_ECN_OP_MATCH_ECE) {
 		if (einfo->invert & XT_ECN_OP_MATCH_ECE) {
-- 
2.9.3

