From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/9] xtoptions: respect return value in xtables_getportbyname
Date: Sun,  1 May 2011 13:50:23 +0200
Message-ID: <1304250630-6150-4-git-send-email-jengelh@medozas.de>
References: <1304250630-6150-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50004 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab1EALuh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 May 2011 07:50:37 -0400
In-Reply-To: <1304250630-6150-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If ret was negative, ntohs may make it positive, which is undesired.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 xtoptions.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/xtoptions.c b/xtoptions.c
index c3cc40e..8478d26 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -379,6 +379,8 @@ static int xtables_getportbyname(const char *name)
 		}
 	}
 	freeaddrinfo(res);
+	if (ret < 0)
+		return ret;
 	return ntohs(ret);
 }
 
-- 
1.7.1

