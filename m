From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 6/6] Fix display of DESTROY event.
Date: Wed, 26 Mar 2008 23:49:11 +0100
Message-ID: <12065717523710-git-send-email-eric@inl.fr>
References: <12065717514081-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:36543 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754064AbYCZWtO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2008 18:49:14 -0400
In-Reply-To: <12065717514081-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

DESTROY event were not correctly displayed due to a problem in event type
detection.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
:100644 100644 272ee4f... d2ce952... M	util/printflow.c
 util/printflow.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/util/printflow.c b/util/printflow.c
index 272ee4f..d2ce952 100644
--- a/util/printflow.c
+++ b/util/printflow.c
@@ -153,7 +153,7 @@ int printflow_print(struct ulogd_key *res, char *buf)
 			case 2:
 				buf_cur += sprintf(buf_cur, "[UPDATE] ");
 				break;
-			case 3:
+			case 4:
 				buf_cur += sprintf(buf_cur, "[DESTROY] ");
 				break;
 		}
-- 
1.5.2.5

