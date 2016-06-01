From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH] extensions: libxt_mark: fix a wrong translation to nft when mask is specified
Date: Wed,  1 Jun 2016 20:07:17 +0800
Message-ID: <1464782837-40104-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>,
	Shivani Bhardwaj <shivanib134@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:43299 "EHLO m12-16.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbcFAMIk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Jun 2016 08:08:40 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

The mask and mark's order is reversed, so when we specify the mask, we will
get the wrong translation result:
  # iptables-translate -A INPUT -m mark --mark 0x1/0xff
  nft add rule ip filter INPUT mark and 0x1 == 0xff counter

Apply this patch, translation will become:
  # iptables-translate -A INPUT -m mark --mark 0x1/0xff
  nft add rule ip filter INPUT mark and 0xff == 0x1 counter

Cc: Shivani Bhardwaj <shivanib134@gmail.com>
Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 extensions/libxt_mark.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index 939b4ac..6eccd5b 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -107,8 +107,8 @@ print_mark_xlate(struct xt_xlate *xl, unsigned int mark,
 		 unsigned int mask, uint32_t op)
 {
 	if (mask != 0xffffffffU)
-		xt_xlate_add(xl, " and 0x%x %s 0x%x ", mark,
-			   op == XT_OP_EQ ? "==" : "!=", mask);
+		xt_xlate_add(xl, " and 0x%x %s 0x%x ", mask,
+			   op == XT_OP_EQ ? "==" : "!=", mark);
 	else
 		xt_xlate_add(xl, " %s0x%x ",
 			   op == XT_OP_EQ ? "" : "!= ", mark);
-- 
2.5.5


