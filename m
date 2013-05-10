From: Eric Leblond <eric@regit.org>
Subject: [PATCH 11/11] db: db ring has precedence over backlog.
Date: Fri, 10 May 2013 08:48:58 +0200
Message-ID: <1368168538-29780-12-git-send-email-eric@regit.org>
References: <1368168538-29780-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:51566 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab3EJHF1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 May 2013 03:05:27 -0400
In-Reply-To: <1368168538-29780-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Eric Leblond <eric@regit.org>
---
 util/db.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/util/db.c b/util/db.c
index c23c362..6be06e6 100644
--- a/util/db.c
+++ b/util/db.c
@@ -177,9 +177,14 @@ int ulogd_db_configure(struct ulogd_pluginstance *upi,
 
 	INIT_LLIST_HEAD(&di->backlog);
 	di->backlog_memusage = 0;
-	
+
+	di->ring.size = ringsize_ce(upi->config_kset).u.value;
 	di->backlog_memcap = backlog_memcap_ce(upi->config_kset).u.value;
-	if (di->backlog_memcap > 0) {
+
+	if (di->ring.size && di->backlog_memcap) {
+		ulogd_log(ULOGD_ERROR, "Ring buffer has precedence over backlog\n");
+		di->backlog_memcap = 0;
+	} else if (di->backlog_memcap > 0) {
 		di->backlog_oneshot = backlog_oneshot_ce(upi->config_kset).u.value;
 		if (di->backlog_oneshot <= 2) {
 			ulogd_log(ULOGD_ERROR,
@@ -190,9 +195,6 @@ int ulogd_db_configure(struct ulogd_pluginstance *upi,
 		di->backlog_full = 0;
 	}
 
-	/* check ring option */
-	di->ring.size = ringsize_ce(upi->config_kset).u.value;
-
 	return ret;
 }
 
-- 
1.7.10.4

