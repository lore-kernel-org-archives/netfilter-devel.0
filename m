From: Eric Leblond <eric@regit.org>
Subject: [PATCH 01/11] ulogd: display stack during configuration
Date: Fri, 10 May 2013 08:48:48 +0200
Message-ID: <1368168538-29780-2-git-send-email-eric@regit.org>
References: <1368168538-29780-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:51450 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab3EJGtX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 May 2013 02:49:23 -0400
In-Reply-To: <1368168538-29780-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/ulogd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/ulogd.c b/src/ulogd.c
index b28d0f8..8f21cc2 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -830,7 +830,7 @@ static int create_stack(const char *option)
 	}
 	INIT_LLIST_HEAD(&stack->list);
 
-	ulogd_log(ULOGD_DEBUG, "building new pluginstance stack (%s):\n",
+	ulogd_log(ULOGD_NOTICE, "building new pluginstance stack: '%s'\n",
 		  option);
 
 	/* PASS 1: find and instanciate plugins of stack, link them together */
-- 
1.7.10.4

