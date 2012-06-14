From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 2/4] psd: add basic validation of userspace matchinfo data
Date: Thu, 14 Jun 2012 22:13:32 +0200
Message-ID: <1339704814-1605-3-git-send-email-fw@strlen.de>
References: <1339704814-1605-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41692 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756347Ab2FNUOv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jun 2012 16:14:51 -0400
In-Reply-To: <1339704814-1605-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

psd multiplies weight_thresh by HZ, so it could overflow.

Userspace libxt_psd refuses values exceeding PSD_MAX_RATE,
so check that on kernel side, too.

Also, setting 0 weight for both privileged and highports
will cause psd to never match at all.

Reject 0 weight threshold, too because it makes no sense
(triggers match for every initial packet).
---
 doc/changelog.txt   |    3 ++-
 extensions/xt_psd.c |   32 ++++++++++++++++++++++++++------
 2 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/doc/changelog.txt b/doc/changelog.txt
index 2fe752b..d266550 100644
--- a/doc/changelog.txt
+++ b/doc/changelog.txt
@@ -3,7 +3,8 @@ HEAD
 ====
 Fixes:
 - xt_psd: avoid crash due to curr->next corruption
-
+Changes:
+- xt_psd: reject invalid match options
 
 v1.42 (2012-04-05)
 ==================
diff --git a/extensions/xt_psd.c b/extensions/xt_psd.c
index c044c25..f3fa336 100644
--- a/extensions/xt_psd.c
+++ b/extensions/xt_psd.c
@@ -278,13 +278,33 @@ out_match:
 	return true;
 }
 
+static int psd_mt_check(const struct xt_mtchk_param *par)
+{
+	const struct xt_psd_info *info = par->matchinfo;
+
+	if (info->weight_threshold == 0) /* 0 would match on every 1st packet */
+		return -EINVAL;
+
+	if ((info->lo_ports_weight|info->hi_ports_weight) == 0) /* would never match */
+		return -EINVAL;
+
+	if (info->delay_threshold > PSD_MAX_RATE ||
+	    info->weight_threshold > PSD_MAX_RATE ||
+	    info->lo_ports_weight > PSD_MAX_RATE ||
+	    info->hi_ports_weight > PSD_MAX_RATE)
+		return -EINVAL;
+
+	return 0;
+}
+
 static struct xt_match xt_psd_reg __read_mostly = {
-	.name		= "psd",
-	.family    = NFPROTO_IPV4,
-	.revision  = 1,
-	.match		= xt_psd_match,
-	.matchsize	= sizeof(struct xt_psd_info),
-	.me			= THIS_MODULE,
+	.name       = "psd",
+	.family     = NFPROTO_IPV4,
+	.revision   = 1,
+	.checkentry = psd_mt_check,
+	.match      = xt_psd_match,
+	.matchsize  = sizeof(struct xt_psd_info),
+	.me         = THIS_MODULE,
 };
 
 static int __init xt_psd_init(void)
-- 
1.7.3.4

