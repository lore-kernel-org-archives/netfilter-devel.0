From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH iptables 4/8] extensions: libxt_devgroup: handle the invert flag properly in translation
Date: Fri,  7 Oct 2016 19:08:52 +0800
Message-ID: <1475838536-28816-5-git-send-email-zlpnobody@163.com>
References: <1475838536-28816-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:59342 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752243AbcJGLKB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Oct 2016 07:10:01 -0400
In-Reply-To: <1475838536-28816-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

We forgot to put "!=" when devgroup can be mapped to name, so translation
is wrong:
  # iptables-translate -A OUTPUT -m devgroup ! --dst-group 0
  nft add rule ip filter OUTPUT oifgroup default counter

Apply this patch:
  # iptables-translate -A OUTPUT -m devgroup ! --dst-group 0
  nft add rule ip filter OUTPUT oifgroup != default counter

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 extensions/libxt_devgroup.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_devgroup.c b/extensions/libxt_devgroup.c
index d155680..2ec3905 100644
--- a/extensions/libxt_devgroup.c
+++ b/extensions/libxt_devgroup.c
@@ -163,11 +163,12 @@ print_devgroup_xlate(unsigned int id, uint32_t op,  unsigned int mask,
 	else {
 		if (numeric == 0)
 			name = xtables_lmap_id2name(devgroups, id);
+
+		xt_xlate_add(xl, "%s", op == XT_OP_EQ ? "" : "!= ");
 		if (name)
 			xt_xlate_add(xl, "%s", name);
 		else
-			xt_xlate_add(xl, "%s0x%x",
-				   op == XT_OP_EQ ? "" : "!= ", id);
+			xt_xlate_add(xl, "0x%x", id);
 	}
 }
 
-- 
2.5.5


