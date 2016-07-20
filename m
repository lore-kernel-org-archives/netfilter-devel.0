From: Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables] connlabel: clarify default config path
Date: Wed, 20 Jul 2016 11:58:24 +0200
Message-ID: <1469008704-22989-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55250 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753172AbcGTJ6H (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jul 2016 05:58:07 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo suggested to print full config file path for connlabel.conf
parsing errors.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Pablo,

 I could also add the suggested nfct_labels_get_path() to lnf_conntrack
 but that means next iptables-release depends on a new library version.
 Given this name is set in stone anyway I would prefer this patch instead.

 Let me know, thanks.
 I will send a separate patch to change nftables location.

diff --git a/extensions/libxt_connlabel.c b/extensions/libxt_connlabel.c
index 7e4ff26..728f6ac 100644
--- a/extensions/libxt_connlabel.c
+++ b/extensions/libxt_connlabel.c
@@ -34,6 +34,8 @@ static const struct xt_option_entry connlabel_mt_opts[] = {
  */
 static void connlabel_open(void)
 {
+	static const char fname[]="/etc/xtables/connlabel.conf";
+
 	if (map)
 		return;
 
@@ -43,10 +45,10 @@ static void connlabel_open(void)
 
 	if (errno) {
 		xtables_error(RESOURCE_PROBLEM,
-			"cannot open connlabel.conf: %s", strerror(errno));
+			"cannot open %s: %s", fname, strerror(errno));
 	} else {
 		xtables_error(RESOURCE_PROBLEM,
-			"cannot parse label, maybe valid label map is empty");
+			"cannot parse %s: no labels found", fname);
 	}
 }
 
-- 
2.7.3

