From: Jan Engelhardt <jengelh@medozas.de>
Subject: netfilter: xt_CT: provide info on why a rule was rejected
Date: Mon, 18 Apr 2011 03:17:30 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1104180317140.2703@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44531 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985Ab1DRBRb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 Apr 2011 21:17:31 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

parent 653393692ac5b0baabf707bb94d20e5c661a27c0 (v2.6.38-rc1-195-g6533936)
commit acbba5911da72a6a4df17c508b332b89c87efe7f
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Mar 1 14:16:12 2011 +0100

netfilter: xt_CT: provide info on why a rule was rejected

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/xt_CT.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 782e519..0221d10 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -5,7 +5,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/module.h>
 #include <linux/gfp.h>
 #include <linux/skbuff.h>
@@ -95,8 +95,11 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par)
 	if (info->helper[0]) {
 		ret = -ENOENT;
 		proto = xt_ct_find_proto(par);
-		if (!proto)
+		if (!proto) {
+			pr_info("You must specify a L4 protocol, "
+				"and not use inversions on it.\n");
 			goto err3;
+		}
 
 		ret = -ENOMEM;
 		help = nf_ct_helper_ext_add(ct, GFP_KERNEL);
@@ -107,8 +110,10 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par)
 		help->helper = nf_conntrack_helper_try_module_get(info->helper,
 								  par->family,
 								  proto);
-		if (help->helper == NULL)
+		if (help->helper == NULL) {
+			pr_info("No such helper \"%s\"\n", info->helper);
 			goto err3;
+		}
 	}
 
 	__set_bit(IPS_TEMPLATE_BIT, &ct->status);
-- 
# Created with git-export-patch

