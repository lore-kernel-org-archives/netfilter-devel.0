From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 iptables] connlabel: clarify default config path
Date: Thu, 21 Jul 2016 00:23:13 +0200
Message-ID: <1469053393-11397-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:56451 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754700AbcGTWW7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jul 2016 18:22:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo suggested to print full config file path for connlabel.conf
parsing errors.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/libxt_connlabel.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_connlabel.c b/extensions/libxt_connlabel.c
index 7e4ff26..2af5eca 100644
--- a/extensions/libxt_connlabel.c
+++ b/extensions/libxt_connlabel.c
@@ -34,6 +34,8 @@ static const struct xt_option_entry connlabel_mt_opts[] = {
  */
 static void connlabel_open(void)
 {
+	const char *fname;
+
 	if (map)
 		return;
 
@@ -41,12 +43,13 @@ static void connlabel_open(void)
 	if (map != NULL)
 		return;
 
+	fname = nfct_labels_get_path();
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

