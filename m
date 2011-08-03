From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/2] nfnl: avoid exit on large packet
Date: Wed,  3 Aug 2011 17:11:57 +0200
Message-ID: <1312384319-29980-2-git-send-email-jengelh@medozas.de>
References: <1312384319-29980-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59556 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754882Ab1HCPMC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Aug 2011 11:12:02 -0400
In-Reply-To: <1312384319-29980-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Using exit from shared libraries is unwelcome (automated build systems
flag it) and one should rather return gracefully. Looking at this
particular spot however, while a

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 src/libnfnetlink.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/src/libnfnetlink.c b/src/libnfnetlink.c
index 2f962fc..0234e6f 100644
--- a/src/libnfnetlink.c
+++ b/src/libnfnetlink.c
@@ -779,10 +779,8 @@ cont:
 			nfnl_error("Messages truncated\n");
 			continue;
 		}
-		if (status) {
+		if (status)
 			nfnl_error("Remnant of size %d\n", status);
-			exit(1);
-		}
 	}
 }
 
-- 
1.7.3.4

