From: Lutz Jaenicke <ljaenicke@innominate.com>
Subject: [PATCH] libxt_devgroup: actually set XT_DEVGROUP_OPT_???GROUP flags
Date: Wed, 18 May 2011 18:47:37 +0200
Message-ID: <1305737257-31464-1-git-send-email-ljaenicke@innominate.com>
Cc: Lutz Jaenicke <ljaenicke@innominate.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.innominate.com ([77.245.32.75]:39387 "EHLO
	home.innominate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932984Ab1ERQro (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 May 2011 12:47:44 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Lutz Jaenicke <ljaenicke@innominate.com>
---
 extensions/libxt_devgroup.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/extensions/libxt_devgroup.c b/extensions/libxt_devgroup.c
index a925dd0..4487c83 100644
--- a/extensions/libxt_devgroup.c
+++ b/extensions/libxt_devgroup.c
@@ -70,6 +70,7 @@ static void devgroup_parse(struct xt_option_call *cb)
 			info->src_group = id;
 			info->src_mask  = 0xffffffff;
 		}
+		info->flags |= XT_DEVGROUP_MATCH_SRC;
 		if (cb->invert)
 			info->flags |= XT_DEVGROUP_INVERT_SRC;
 		break;
@@ -93,6 +94,7 @@ static void devgroup_parse(struct xt_option_call *cb)
 			info->dst_group = id;
 			info->dst_mask  = 0xffffffff;
 		}
+		info->flags |= XT_DEVGROUP_MATCH_DST;
 		if (cb->invert)
 			info->flags |= XT_DEVGROUP_INVERT_DST;
 		break;
-- 
1.7.2.5

