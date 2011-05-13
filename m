From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 10/12] libxt_conntrack: fix assignment to wrong member
Date: Fri, 13 May 2011 02:47:34 +0200
Message-ID: <1305247657-29158-11-git-send-email-jengelh@medozas.de>
References: <1305247657-29158-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54346 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759040Ab1EMAth (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 May 2011 20:49:37 -0400
In-Reply-To: <1305247657-29158-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Of course the range end ought to be set, not doing the start value
twice.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_conntrack.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 6d16ccf..0262b01 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -480,32 +480,28 @@ static void conntrack_mt_parse(struct xt_option_call *cb, uint8_t rev)
 		break;
 	case O_CTORIGSRCPORT:
 		info->origsrc_port = cb->val.port_range[0];
-		info->origsrc_port = (cb->nvals == 2) ? cb->val.port_range[1] :
-		                     cb->val.port_range[0];
+		info->origsrc_port_high = cb->val.port_range[cb->nvals >= 2];
 		info->match_flags |= XT_CONNTRACK_ORIGSRC_PORT;
 		if (cb->invert)
 			info->invert_flags |= XT_CONNTRACK_ORIGSRC_PORT;
 		break;
 	case O_CTORIGDSTPORT:
 		info->origdst_port = cb->val.port_range[0];
-		info->origdst_port = (cb->nvals == 2) ? cb->val.port_range[1] :
-		                     cb->val.port_range[0];
+		info->origdst_port_high = cb->val.port_range[cb->nvals >= 2];
 		info->match_flags |= XT_CONNTRACK_ORIGDST_PORT;
 		if (cb->invert)
 			info->invert_flags |= XT_CONNTRACK_ORIGDST_PORT;
 		break;
 	case O_CTREPLSRCPORT:
 		info->replsrc_port = cb->val.port_range[0];
-		info->replsrc_port = (cb->nvals == 2) ? cb->val.port_range[1] :
-		                     cb->val.port_range[0];
+		info->replsrc_port_high = cb->val.port_range[cb->nvals >= 2];
 		info->match_flags |= XT_CONNTRACK_REPLSRC_PORT;
 		if (cb->invert)
 			info->invert_flags |= XT_CONNTRACK_REPLSRC_PORT;
 		break;
 	case O_CTREPLDSTPORT:
 		info->repldst_port = cb->val.port_range[0];
-		info->repldst_port = (cb->nvals == 2) ? cb->val.port_range[1] :
-		                     cb->val.port_range[0];
+		info->repldst_port_high = cb->val.port_range[cb->nvals >= 2];
 		info->match_flags |= XT_CONNTRACK_REPLDST_PORT;
 		if (cb->invert)
 			info->invert_flags |= XT_CONNTRACK_REPLDST_PORT;
-- 
1.7.1

