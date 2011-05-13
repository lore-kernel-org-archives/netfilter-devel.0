From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 09/12] libxt_conntrack: correct printed module name
Date: Fri, 13 May 2011 02:47:33 +0200
Message-ID: <1305247657-29158-10-git-send-email-jengelh@medozas.de>
References: <1305247657-29158-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54342 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759038Ab1EMAtd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 May 2011 20:49:33 -0400
In-Reply-To: <1305247657-29158-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_conntrack.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 2fb3644..6d16ccf 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -545,7 +545,7 @@ static void conntrack1_mt_parse(struct xt_option_call *cb)
 	    up.replsrc_port != up.replsrc_port_high ||
 	    up.repldst_port != up.repldst_port_high)
 		xtables_error(PARAMETER_PROBLEM,
-			"connlimit rev 1 does not support port ranges");
+			"conntrack rev 1 does not support port ranges");
 	cinfo_transform(info, &up);
 	cb->data = info;
 }
@@ -567,7 +567,7 @@ static void conntrack2_mt_parse(struct xt_option_call *cb)
 	    up.replsrc_port != up.replsrc_port_high ||
 	    up.repldst_port != up.repldst_port_high)
 		xtables_error(PARAMETER_PROBLEM,
-			"connlimit rev 2 does not support port ranges");
+			"conntrack rev 2 does not support port ranges");
 	memcpy(info, &up, sizeof(*info));
 	cb->data = info;
 #undef cinfo2_transform
-- 
1.7.1

