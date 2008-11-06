From: Jan Engelhardt <jengelh@medozas.de>
Subject: libiptc: make sockfd a per-handle thing
Date: Thu, 6 Nov 2008 09:35:32 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811060935130.26551@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0811060933060.26551@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0811060934380.26551@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0811060935020.26551@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52643 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbYKFIfd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Nov 2008 03:35:33 -0500
In-Reply-To: <alpine.LNX.1.10.0811060935020.26551@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 976ee346f58ae69ee82fcd750813d2b4fb7379b1
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Thu Nov 6 09:23:06 2008 +0100

libiptc: make sockfd a per-handle thing

Get away from this singleton.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 libiptc/libiptc.c |   38 ++++++++++++++------------------------
 1 files changed, 14 insertions(+), 24 deletions(-)

diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 17c2f49..98780a6 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -47,8 +47,6 @@
 #define debug(x, args...)
 #endif
 
-static int sockfd = -1;
-static int sockfd_use = 0;
 static void *iptc_fn = NULL;
 
 static const char *hooknames[] = {
@@ -128,6 +126,7 @@ struct chain_head
 
 STRUCT_TC_HANDLE
 {
+	int sockfd;
 	int changed;			 /* Have changes been made? */
 
 	struct list_head chains;
@@ -1309,6 +1308,7 @@ TC_INIT(const char *tablename)
 	STRUCT_GETINFO info;
 	unsigned int tmp;
 	socklen_t s;
+	int sockfd;
 
 	iptc_fn = TC_INIT;
 
@@ -1316,22 +1316,17 @@ TC_INIT(const char *tablename)
 		errno = EINVAL;
 		return NULL;
 	}
-	
-	if (sockfd_use == 0) {
-		sockfd = socket(TC_AF, SOCK_RAW, IPPROTO_RAW);
-		if (sockfd < 0)
-			return NULL;
-	}
-	sockfd_use++;
+
+	sockfd = socket(TC_AF, SOCK_RAW, IPPROTO_RAW);
+	if (sockfd < 0)
+		return NULL;
+
 retry:
 	s = sizeof(info);
 
 	strcpy(info.name, tablename);
 	if (getsockopt(sockfd, TC_IPPROTO, SO_GET_INFO, &info, &s) < 0) {
-		if (--sockfd_use == 0) {
-			close(sockfd);
-			sockfd = -1;
-		}
+		close(sockfd);
 		return NULL;
 	}
 
@@ -1340,21 +1335,19 @@ retry:
 
 	if ((h = alloc_handle(info.name, info.size, info.num_entries))
 	    == NULL) {
-		if (--sockfd_use == 0) {
-			close(sockfd);
-			sockfd = -1;
-		}
+		close(sockfd);
 		return NULL;
 	}
 
 	/* Initialize current state */
+	h->sockfd = sockfd;
 	h->info = info;
 
 	h->entries->size = h->info.size;
 
 	tmp = sizeof(STRUCT_GET_ENTRIES) + h->info.size;
 
-	if (getsockopt(sockfd, TC_IPPROTO, SO_GET_ENTRIES, h->entries,
+	if (getsockopt(h->sockfd, TC_IPPROTO, SO_GET_ENTRIES, h->entries,
 		       &tmp) < 0)
 		goto error;
 
@@ -1388,10 +1381,7 @@ TC_FREE(struct xtc_handle *h)
 	struct chain_head *c, *tmp;
 
 	iptc_fn = TC_FREE;
-	if (--sockfd_use == 0) {
-		close(sockfd);
-		sockfd = -1;
-	}
+	close(h->sockfd);
 
 	list_for_each_entry_safe(c, tmp, &h->chains, list) {
 		struct rule_head *r, *rtmp;
@@ -2614,7 +2604,7 @@ TC_COMMIT(struct xtc_handle *handle)
 	}
 #endif
 
-	ret = setsockopt(sockfd, TC_IPPROTO, SO_SET_REPLACE, repl,
+	ret = setsockopt(handle->sockfd, TC_IPPROTO, SO_SET_REPLACE, repl,
 			 sizeof(*repl) + repl->size);
 	if (ret < 0)
 		goto out_free_newcounters;
@@ -2690,7 +2680,7 @@ TC_COMMIT(struct xtc_handle *handle)
 	}
 #endif
 
-	ret = setsockopt(sockfd, TC_IPPROTO, SO_SET_ADD_COUNTERS,
+	ret = setsockopt(handle->sockfd, TC_IPPROTO, SO_SET_ADD_COUNTERS,
 			 newcounters, counterlen);
 	if (ret < 0)
 		goto out_free_newcounters;
