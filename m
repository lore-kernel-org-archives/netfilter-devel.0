From: Eric Leblond <eric@regit.org>
Subject: [PATCH] ulogd: use strncpy instead of memcpy
Date: Tue, 21 Mar 2017 21:56:57 +0100
Message-ID: <20170321205657.9945-1-eric@regit.org>
References: <1490129693.2157.21.camel@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: Alexandru Ardelean <ardeleanalex@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:54462 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933223AbdCUU5E (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 16:57:04 -0400
In-Reply-To: <1490129693.2157.21.camel@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On some architecture, ulogd is not starting due to a
crash in memcpy. This patch switches to strncpy to
avoid the problem.

Reported-by: Alexandru Ardelean <ardeleanalex@gmail.com>
Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/ulogd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/ulogd.c b/src/ulogd.c
index 5b9a586..919a317 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -668,7 +668,7 @@ pluginstance_alloc_init(struct ulogd_plugin *pl, char *pi_id,
 	INIT_LLIST_HEAD(&pi->plist);
 	pi->plugin = pl;
 	pi->stack = stack;
-	memcpy(pi->id, pi_id, sizeof(pi->id));
+	strncpy(pi->id, pi_id, ULOGD_MAX_KEYLEN);
 
 	ptr = (void *)pi + sizeof(*pi);
 
-- 
2.11.0

