Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58294C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Nov 2022 22:58:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbiKUW6p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 17:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiKUW6o (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 17:58:44 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99141C72EF
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2022 14:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vR1fpUF+yPWCqyrCy1m36KmHOvOPbhajvL0mJ6LqN1c=; b=RTdVCSfCUF0GO5reUwNGUqxCxd
        Md2UdSPTZcHu1fsRjqhezugrL/XqLTlFAVsm81fl0rew85+u8VFUlkxGEtq2PBsNIuqoOGCT8tNzj
        8kgonscYsREhaEWLmXJmcQGYsmXc9At050/rLLCFFRJxFUlL6zSUEwHRF44tS9xCQdzM/MDK9+Pd4
        ya2qVPunZvidbWyemf2GdL0W/iYugSyjjlldmXQRmEkZ9paTkk4Lzqr6bSgCcLXbJE+fb7NOMKGW/
        jxvvteCErMAN0MKgqKj7tl+3/1JVvdXjWHXWNUK7NckxbMCSL9GOx/owPioUAxZefCD0S7YH6Dnxh
        3NmeVUcg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oxFGF-005LgP-29
        for netfilter-devel@vger.kernel.org; Mon, 21 Nov 2022 22:27:31 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 25/34] db: synchronize access to ring-buffer
Date:   Mon, 21 Nov 2022 22:26:02 +0000
Message-Id: <20221121222611.3914559-26-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221121222611.3914559-1-jeremy@azazel.net>
References: <20221121222611.3914559-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There are a mutex and condition-variable associated with the
ring-buffer.  However, they are not used to synchronize access to the
buffer, but only to wake the thread that processes the buffer when new
statements are added to it.  Thus there is nothing to prevent concurrent
modifications of the buffer.

Instead, acquire the mutex before adding to the buffer, and, in the
processing thread, copy the statement we're about to execute out of the
buffer and release the mutex while processing it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/ulogd/db.h |  2 ++
 util/db.c          | 63 +++++++++++++++++++++++++++++++++++++---------
 2 files changed, 53 insertions(+), 12 deletions(-)

diff --git a/include/ulogd/db.h b/include/ulogd/db.h
index 6c2e3d07f463..bf4a19dea150 100644
--- a/include/ulogd/db.h
+++ b/include/ulogd/db.h
@@ -34,6 +34,8 @@ struct db_stmt_ring {
 	struct db_stmt *elems; /* Buffer containing `size` statements of
 				* `length` bytes */
 
+	struct db_stmt *stmt; /* Currently executing statement */
+
 	uint32_t size; /* No. of elements in ring buffer */
 	uint32_t used; /* No. of elements in ring buffer in use */
 	uint32_t length; /* Length of one element in ring buffer */
diff --git a/util/db.c b/util/db.c
index 487eaed26153..6cfbcbc16791 100644
--- a/util/db.c
+++ b/util/db.c
@@ -372,10 +372,15 @@ _stop_db(struct ulogd_pluginstance *upi)
 	}
 	if (di->ring.size > 0) {
 		pthread_cancel(di->ring.thread_id);
+
 		pthread_cond_destroy(&di->ring.cond);
 		pthread_mutex_destroy(&di->ring.mutex);
+
 		free(di->ring.elems);
+		free(di->ring.stmt);
+
 		di->ring.elems = NULL;
+		di->ring.stmt = NULL;
 	}
 }
 
@@ -737,14 +742,22 @@ _start_ring(struct ulogd_pluginstance *upi)
 		return 0;
 
 	/* allocate */
+
 	stmt_size = sizeof(*di->stmt) + di->stmt->size;
 	stmt_align = __alignof__(*di->stmt);
 	di->ring.length = stmt_size % stmt_align != 0
 		? (1 + stmt_size / stmt_align) * stmt_align
 		: stmt_size;
+
+	di->ring.stmt = malloc(di->ring.length);
+	if (di->ring.stmt == NULL)
+		return -1;
+
 	di->ring.elems = calloc(di->ring.size, di->ring.length);
-	if (di->ring.elems == NULL)
+	if (di->ring.elems == NULL) {
+		free(di->ring.stmt);
 		return -1;
+	}
 	di->ring.wr_idx = di->ring.rd_idx = di->ring.used = 0;
 	ulogd_log(ULOGD_NOTICE,
 		  "Allocating %" PRIu32 " elements of size %" PRIu32 " for ring\n",
@@ -775,6 +788,7 @@ cond_error:
 	pthread_cond_destroy(&di->ring.cond);
 alloc_error:
 	free(di->ring.elems);
+	free(di->ring.stmt);
 
 	return -1;
 }
@@ -784,12 +798,14 @@ _add_to_ring(struct ulogd_pluginstance *upi)
 {
 	struct db_instance *di = (struct db_instance *) &upi->private;
 
+	pthread_mutex_lock(&di->ring.mutex);
+
 	if (di->ring.used == di->ring.size) {
 		if (!di->ring.full) {
 			ulogd_log(ULOGD_ERROR, "No place left in ring\n");
 			di->ring.full = 1;
 		}
-		return ULOGD_IRET_OK;
+		goto unlock_mutex;
 	}
 
 	if (di->ring.full) {
@@ -801,6 +817,9 @@ _add_to_ring(struct ulogd_pluginstance *upi)
 	_incr_ring_used(&di->ring, 1);
 
 	pthread_cond_signal(&di->ring.cond);
+unlock_mutex:
+	pthread_mutex_unlock(&di->ring.mutex);
+
 	return ULOGD_IRET_OK;
 }
 
@@ -809,27 +828,47 @@ _process_ring(void *arg)
 {
 	struct ulogd_pluginstance *upi = arg;
 	struct db_instance *di = (struct db_instance *) &upi->private;
+	struct db_stmt *stmt = di->ring.stmt;
 
 	pthread_mutex_lock(&di->ring.mutex);
+
 	while(1) {
-		/* wait cond */
+
 		pthread_cond_wait(&di->ring.cond, &di->ring.mutex);
+
 		while (di->ring.used > 0) {
-			struct db_stmt *stmt = _get_ring_elem(&di->ring,
-							      di->ring.rd_idx);
-
-			if (di->driver->execute(upi, stmt) < 0) {
-				di->driver->close_db(upi);
-				while (di->driver->open_db(upi) < 0)
-					sleep(1);
-				/* try to re-run statement */
+
+			memcpy(stmt, _get_ring_elem(&di->ring, di->ring.rd_idx),
+			       di->ring.length);
+
+			pthread_mutex_unlock(&di->ring.mutex);
+
+exec_stmt:
+			if (di->driver->execute(upi, stmt) == 0) {
+
+				pthread_mutex_lock(&di->ring.mutex);
+
+				_incr_ring_used(&di->ring, -1);
+
 				continue;
+
 			}
 
-			_incr_ring_used(&di->ring, -1);
+			/* If the exec fails, close the DB connexion and try to
+			 * open it again.  Once the connexion is made, retry the
+			 * statement.
+			 */
+			di->driver->close_db(upi);
+			while (di->driver->open_db(upi) < 0)
+				sleep(1);
+			goto exec_stmt;
+
 		}
+
 	}
 
+	pthread_mutex_unlock(&di->ring.mutex);
+
 	return NULL;
 }
 
-- 
2.35.1

