From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH iptables 1/8] extensions: libipt_realm: add a missing space in translation
Date: Fri,  7 Oct 2016 19:08:49 +0800
Message-ID: <1475838536-28816-2-git-send-email-zlpnobody@163.com>
References: <1475838536-28816-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:59146 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751222AbcJGLKC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Oct 2016 07:10:02 -0400
In-Reply-To: <1475838536-28816-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

We missed a blank space when do translate to nft, so if rt_realm can be
mapped to name, the result looks ugly:
  # iptables-translate -A OUTPUT -m realm --realm 0
  nft add rule ip filter OUTPUT rtclassidcosmos counter
                                         ^

Apply this patch:
  # iptables-translate -A OUTPUT -m realm --realm 0
  nft add rule ip filter OUTPUT rtclassid cosmos counter

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 extensions/libipt_realm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libipt_realm.c b/extensions/libipt_realm.c
index fd0622a..8eea787 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -121,7 +121,7 @@ print_realm_xlate(unsigned long id, unsigned long mask,
 		if (numeric == 0)
 			name = xtables_lmap_id2name(realms, id);
 		if (name)
-			xt_xlate_add(xl, "%s%s",
+			xt_xlate_add(xl, " %s%s",
 				   op == XT_OP_EQ ? "" : "!= ", name);
 		else
 			xt_xlate_add(xl, " %s0x%lx",
-- 
2.5.5


