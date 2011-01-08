From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 10/13] libxt_sctp: fix a typo
Date: Sat,  8 Jan 2011 16:20:11 +0100
Message-ID: <1294500015-10691-11-git-send-email-jengelh@medozas.de>
References: <1294500015-10691-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:32908 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827Ab1AHPU1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Jan 2011 10:20:27 -0500
In-Reply-To: <1294500015-10691-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_sctp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index ad26076..016a9f9 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -394,7 +394,7 @@ print_chunks(const struct xt_sctp_info *einfo, int numeric)
 		case SCTP_CHUNK_MATCH_ANY:	printf("any "); break;
 		case SCTP_CHUNK_MATCH_ALL:	printf("all "); break;
 		case SCTP_CHUNK_MATCH_ONLY:	printf("only "); break;
-		default:	printf("Never reach herer\n"); break;
+		default:	printf("Never reach here\n"); break;
 	}
 
 	if (SCTP_CHUNKMAP_IS_CLEAR(einfo->chunkmap)) {
-- 
1.7.1

