From: Eric Leblond <eric@regit.org>
Subject: [PATCH 10/11] db: disable SIGHUP if ring buffer is used.
Date: Fri, 10 May 2013 08:48:57 +0200
Message-ID: <1368168538-29780-11-git-send-email-eric@regit.org>
References: <1368168538-29780-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:51567 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab3EJHF2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 May 2013 03:05:28 -0400
In-Reply-To: <1368168538-29780-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The handling of signal when using threads can be complicated. When
ring buffer is used for query, this means ulogd will have to follow
some sort of mutex. Thus, it is easier and better performance wise
to disable the reload via SIGHUP when the ring buffer is used.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 util/db.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/util/db.c b/util/db.c
index 4050f0f..c23c362 100644
--- a/util/db.c
+++ b/util/db.c
@@ -607,11 +607,16 @@ static void *__inject_thread(void *gdi)
 
 void ulogd_db_signal(struct ulogd_pluginstance *upi, int signal)
 {
+	struct db_instance *di = (struct db_instance *) &upi->private;
 	switch (signal) {
 	case SIGHUP:
-		/* reopen database connection */
-		ulogd_db_instance_stop(upi);
-		ulogd_db_start(upi);
+		if (!di->ring.size) {
+			/* reopen database connection */
+			ulogd_db_instance_stop(upi);
+			ulogd_db_start(upi);
+		} else
+			ulogd_log(ULOGD_ERROR,
+				  "No SIGHUP handling if ring buffer is used\n");
 		break;
 	default:
 		break;
-- 
1.7.10.4

