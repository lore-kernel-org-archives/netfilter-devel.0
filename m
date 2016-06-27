From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH iptables] extensions: libipt_realm: fix order of mask and id when do nft translation
Date: Mon, 27 Jun 2016 21:57:25 +0800
Message-ID: <1467035845-28485-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>,
	Shivani Bhardwaj <shivanib134@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:34213 "EHLO m12-17.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbcF0N61 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Jun 2016 09:58:27 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Before:
  # iptables-translate -A INPUT -m realm --realm 1/0xf
  nft add rule ip filter INPUT rtclassid and 0x1 == 0xf counter

Apply this patch:
  # iptables-translate -A INPUT -m realm --realm 1/0xf
  nft add rule ip filter INPUT rtclassid and 0xf == 0x1 counter

Cc: Shivani Bhardwaj <shivanib134@gmail.com>
Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 extensions/libipt_realm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libipt_realm.c b/extensions/libipt_realm.c
index beb2491..0a4bc3b 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -115,8 +115,8 @@ print_realm_xlate(unsigned long id, unsigned long mask,
 	const char *name = NULL;
 
 	if (mask != 0xffffffff)
-		xt_xlate_add(xl, " and 0x%lx %s 0x%lx ", id,
-			   op == XT_OP_EQ ? "==" : "!=", mask);
+		xt_xlate_add(xl, " and 0x%lx %s 0x%lx ", mask,
+			   op == XT_OP_EQ ? "==" : "!=", id);
 	else {
 		if (numeric == 0)
 			name = xtables_lmap_id2name(realms, id);
-- 
2.5.5


