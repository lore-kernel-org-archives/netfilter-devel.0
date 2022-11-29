Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 751D8C4708B
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Nov 2022 21:58:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236834AbiK2V6E (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:58:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236910AbiK2V5i (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2022 16:57:38 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2FB8BC1B
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2022 13:57:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dt9SHU/ICrC9rVS8P9C3Swsm92aiEbnhOGfh40ouLVo=; b=IMWWAcPOwTF2txyhkQyouDDGl2
        drBbyh+DBnMajMSL0kZ44Y8wHb3XsS/qUG3CaHffx9nNOhX1Tn+jg+NXBg9iuedTauhh32DtdazMJ
        TIV1b+erfAYlGFzAZLuP/DUv2CNM0sh5anDHNST70tcV2OnpcSTQqG0OIJTgWcR1WaLmiNVEIoi/W
        FQmQpAK8j5KG+q8+LnLXyTiZzeyEuf3J6zpfbgvFSp8F8WXO9WegcHOBSNEFKVnBL5J5FvjuRae7y
        xo9cmvTeeQ6taqUULAygm+ON4VDKDWGOWNjLPwgINrbX8xDpnYRufXNfr4C5kebG0Mtcu0+QcI+Kp
        ALPqncvw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1p08SL-00DjQp-7i
        for netfilter-devel@vger.kernel.org; Tue, 29 Nov 2022 21:47:57 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 v2 v2 22/34] db: refactor ring-buffer
Date:   Tue, 29 Nov 2022 21:47:37 +0000
Message-Id: <20221129214749.247878-23-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221129214749.247878-1-jeremy@azazel.net>
References: <20221129214749.247878-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

 * Rename some fields.
 * Use `uint32_t` consistently for all sizes and indices.
 * Move thread ID into the ring structure.
 * Replace status flag with a count of in-use elements.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/ulogd/db.h |  25 ++++++------
 util/db.c          | 100 +++++++++++++++++++++++++--------------------
 2 files changed, 68 insertions(+), 57 deletions(-)

diff --git a/include/ulogd/db.h b/include/ulogd/db.h
index 7c0649583f1d..ebf4f42917c3 100644
--- a/include/ulogd/db.h
+++ b/include/ulogd/db.h
@@ -27,22 +27,22 @@ struct db_driver {
 
 };
 
-enum {
-	RING_NO_QUERY,
-	RING_QUERY_READY,
-};
-
 struct db_stmt_ring {
-	/* Ring buffer: 1 status byte + string */
-	char *ring; /* pointer to the ring */
-	uint32_t size; /* size of ring buffer in element */
-	int length; /* length of one ring buffer element */
-	uint32_t wr_item; /* write item in ring buffer */
-	uint32_t rd_item; /* read item in ring buffer */
-	char *wr_place;
+
+	char *elems; /* Buffer containing `size` strings of `length` bytes */
+
+	uint32_t size; /* No. of elements in ring buffer */
+	uint32_t used; /* No. of elements in ring buffer in use */
+	uint32_t length; /* Length of one element in ring buffer */
+	uint32_t wr_idx; /* Index of next element to write in ring buffer */
+	uint32_t rd_idx; /* Index of next element to read in ring buffer */
+
+	pthread_t thread_id;
 	pthread_cond_t cond;
 	pthread_mutex_t mutex;
+
 	int full;
+
 };
 
 struct db_stmt {
@@ -60,7 +60,6 @@ struct db_instance {
 	struct db_driver *driver;
 	/* DB ring buffer */
 	struct db_stmt_ring ring;
-	pthread_t db_thread_id;
 	/* Backlog system */
 	unsigned int backlog_memcap;
 	unsigned int backlog_memusage;
diff --git a/util/db.c b/util/db.c
index ee6dfb6b5a2a..8a870846332b 100644
--- a/util/db.c
+++ b/util/db.c
@@ -63,8 +63,10 @@ static int _process_backlog(struct ulogd_pluginstance *upi);
 
 static int _configure_ring(struct ulogd_pluginstance *upi);
 static int _start_ring(struct ulogd_pluginstance *upi);
-static int _add_to_ring(struct ulogd_pluginstance *upi, struct db_instance *di);
+static int _add_to_ring(struct ulogd_pluginstance *upi);
 static void *_process_ring(void *arg);
+static char *_get_ring_elem(struct db_stmt_ring *r, uint32_t i);
+static void _incr_ring_used(struct db_stmt_ring *r, int incr);
 
 int
 ulogd_db_configure(struct ulogd_pluginstance *upi,
@@ -182,17 +184,16 @@ ulogd_db_signal(struct ulogd_pluginstance *upi, int signal)
 	case SIGTERM:
 	case SIGINT:
 		if (di->ring.size) {
-			int s = pthread_cancel(di->db_thread_id);
+			int s = pthread_cancel(di->ring.thread_id);
 			if (s != 0) {
 				ulogd_log(ULOGD_ERROR,
-					  "Can't cancel injection thread\n");
+					  "Can't cancel ring-processing thread\n");
 				break;
 			}
-			s = pthread_join(di->db_thread_id, NULL);
+			s = pthread_join(di->ring.thread_id, NULL);
 			if (s != 0) {
 				ulogd_log(ULOGD_ERROR,
-					  "Error waiting for injection thread"
-					  "cancelation\n");
+					  "Error waiting for ring-processing thread cancellation\n");
 			}
 		}
 		break;
@@ -293,7 +294,7 @@ _interp_db_main(struct ulogd_pluginstance *upi)
 	struct db_instance *di = (struct db_instance *) &upi->private;
 
 	if (di->ring.size) {
-		if (_add_to_ring(upi, di) < 0)
+		if (_add_to_ring(upi) < 0)
 			return ULOGD_IRET_ERR;
 		return ULOGD_IRET_OK;
 	}
@@ -372,11 +373,11 @@ _stop_db(struct ulogd_pluginstance *upi)
 		di->stmt = NULL;
 	}
 	if (di->ring.size > 0) {
-		pthread_cancel(di->db_thread_id);
-		free(di->ring.ring);
+		pthread_cancel(di->ring.thread_id);
 		pthread_cond_destroy(&di->ring.cond);
 		pthread_mutex_destroy(&di->ring.mutex);
-		di->ring.ring = NULL;
+		free(di->ring.elems);
+		di->ring.elems = NULL;
 	}
 }
 
@@ -743,18 +744,17 @@ _start_ring(struct ulogd_pluginstance *upi)
 		return 0;
 
 	/* allocate */
-	di->ring.ring = calloc(di->ring.size, sizeof(char) * di->ring.length);
-	if (di->ring.ring == NULL)
+	di->ring.elems = calloc(di->ring.size, di->ring.length);
+	if (di->ring.elems == NULL)
 		return -1;
-	di->ring.wr_place = di->ring.ring;
+	di->ring.wr_idx = di->ring.rd_idx = di->ring.used = 0;
 	ulogd_log(ULOGD_NOTICE,
-		  "Allocating %d elements of size %d for ring\n",
+		  "Allocating %" PRIu32 " elements of size %" PRIu32 " for ring\n",
 		  di->ring.size, di->ring.length);
 
 	/* init start of query for each element */
 	for(i = 0; i < di->ring.size; i++)
-		strcpy(di->ring.ring + di->ring.length * i + 1,
-		       di->stmt);
+		strcpy(_get_ring_elem(&di->ring, i), di->stmt);
 
 	/* init cond & mutex */
 	ret = pthread_cond_init(&di->ring.cond, NULL);
@@ -765,7 +765,7 @@ _start_ring(struct ulogd_pluginstance *upi)
 		goto cond_error;
 
 	/* create thread */
-	ret = pthread_create(&di->db_thread_id, NULL, _process_ring, upi);
+	ret = pthread_create(&di->ring.thread_id, NULL, _process_ring, upi);
 	if (ret != 0)
 		goto mutex_error;
 
@@ -776,66 +776,78 @@ mutex_error:
 cond_error:
 	pthread_cond_destroy(&di->ring.cond);
 alloc_error:
-	free(di->ring.ring);
+	free(di->ring.elems);
 
 	return -1;
 }
 
 static int
-_add_to_ring(struct ulogd_pluginstance *upi, struct db_instance *di)
+_add_to_ring(struct ulogd_pluginstance *upi)
 {
-	if (*di->ring.wr_place == RING_QUERY_READY) {
-		if (di->ring.full == 0) {
+	struct db_instance *di = (struct db_instance *) &upi->private;
+
+	if (di->ring.used == di->ring.size) {
+		if (!di->ring.full) {
 			ulogd_log(ULOGD_ERROR, "No place left in ring\n");
 			di->ring.full = 1;
 		}
 		return ULOGD_IRET_OK;
-	} else if (di->ring.full) {
+	}
+
+	if (di->ring.full) {
 		ulogd_log(ULOGD_NOTICE, "Recovered some place in ring\n");
 		di->ring.full = 0;
 	}
-	_bind_sql_stmt(upi, di->ring.wr_place + 1);
-	*di->ring.wr_place = RING_QUERY_READY;
+
+	_bind_sql_stmt(upi, _get_ring_elem(&di->ring, di->ring.wr_idx));
+	_incr_ring_used(&di->ring, 1);
+
 	pthread_cond_signal(&di->ring.cond);
-	di->ring.wr_item ++;
-	di->ring.wr_place += di->ring.length;
-	if (di->ring.wr_item == di->ring.size) {
-		di->ring.wr_item = 0;
-		di->ring.wr_place = di->ring.ring;
-	}
 	return ULOGD_IRET_OK;
 }
 
 static void *
-_process_ring(void *gdi)
+_process_ring(void *arg)
 {
-	struct ulogd_pluginstance *upi = gdi;
+	struct ulogd_pluginstance *upi = arg;
 	struct db_instance *di = (struct db_instance *) &upi->private;
-	char *wr_place;
 
-	wr_place = di->ring.ring;
 	pthread_mutex_lock(&di->ring.mutex);
 	while(1) {
 		/* wait cond */
 		pthread_cond_wait(&di->ring.cond, &di->ring.mutex);
-		while (*wr_place == RING_QUERY_READY) {
-			if (di->driver->execute(upi, wr_place + 1,
-						strlen(wr_place + 1)) < 0) {
+		while (di->ring.used > 0) {
+			char *stmt = _get_ring_elem(&di->ring, di->ring.rd_idx);
+
+			if (di->driver->execute(upi, stmt,
+						strlen(stmt)) < 0) {
+
 				di->driver->close_db(upi);
 				while (di->driver->open_db(upi) < 0)
 					sleep(1);
 				/* try to re run query */
 				continue;
 			}
-			*wr_place = RING_NO_QUERY;
-			di->ring.rd_item++;
-			if (di->ring.rd_item == di->ring.size) {
-				di->ring.rd_item = 0;
-				wr_place = di->ring.ring;
-			} else
-				wr_place += di->ring.length;
+
+			_incr_ring_used(&di->ring, -1);
 		}
 	}
 
 	return NULL;
 }
+
+static char *
+_get_ring_elem(struct db_stmt_ring *r, uint32_t i)
+{
+	return &r->elems[i * r->length];
+}
+
+static void
+_incr_ring_used(struct db_stmt_ring *r, int incr)
+{
+	uint32_t *idx = incr > 0 ? &r->wr_idx : &r->rd_idx;
+
+	*idx = (*idx + 1) % r->size;
+
+	r->used += incr;
+}
-- 
2.35.1

