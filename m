From: Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH] extensions: libxt_quota.c: Support option negation
Date: Thu, 1 Jul 2010 11:35:07 +0200
Message-ID: <20100701093506.GA3309@sortiz-mobl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:52866 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616Ab0GAJfJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Jul 2010 05:35:09 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The xt_quota_info flags should be set properly for the --quota option negation
support.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 extensions/libxt_quota.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/extensions/libxt_quota.c b/extensions/libxt_quota.c
index 69d2746..bdfc92a 100644
--- a/extensions/libxt_quota.c
+++ b/extensions/libxt_quota.c
@@ -65,6 +65,10 @@ quota_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (!parse_quota(optarg, &info->quota))
 			xtables_error(PARAMETER_PROBLEM,
 				   "bad quota: '%s'", optarg);
+
+		if (invert)
+			info->flags |= XT_QUOTA_INVERT;
+
 		break;
 
 	default:
-- 
1.7.1

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
