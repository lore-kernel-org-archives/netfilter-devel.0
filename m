Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3C4AC63703
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Nov 2022 21:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236828AbiK2V5d (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:57:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237058AbiK2V50 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2022 16:57:26 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4AC6C733
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2022 13:57:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=mQrFep5sKWAG8HUScr55RhZYOzT7eUBYwq6pSODMglg=; b=HMKfHTECk7Wwj9ZjD4maFbnuMY
        Pcgjb7ZNug8D7G+afRcNqwpYzQfMB+HFOadMJUctRYGzWbZU040MTLdh/DxDYwy8I/bD0iIJVgYFD
        8WkoEOsQYlmm1qi/bPSuAjWxyAWJ7vJd9if1MlnU5NQmE2D9rLy1a9AWNzFqiBNFZbLx8w4qExntB
        M3qeMis5x5vpQwm3Kd3dB/6HrdsmRFoNxlkU8NZfDZvXFBvK8TQcROcjpDygPSvNzC5VqCK1LawgP
        64SQ6+Z7Vum0IEEK+Wy93E0PqaAkj9c3ohXZeEO9INSmeizh29RNAnUdxymFAduyKueOT2TdrNpXQ
        ZSdMFg6w==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1p08SL-00DjQp-3M
        for netfilter-devel@vger.kernel.org; Tue, 29 Nov 2022 21:47:57 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 v2 v2 21/34] db: refactor ring-buffer initialization
Date:   Tue, 29 Nov 2022 21:47:36 +0000
Message-Id: <20221129214749.247878-22-jeremy@azazel.net>
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

Move the code to initialize and start the thread that manages the ring-buffer
into a separate function.

No functional changes.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 util/db.c | 87 +++++++++++++++++++++++++++++++++----------------------
 1 file changed, 53 insertions(+), 34 deletions(-)

diff --git a/util/db.c b/util/db.c
index a633257b5929..ee6dfb6b5a2a 100644
--- a/util/db.c
+++ b/util/db.c
@@ -62,6 +62,7 @@ static int _add_to_backlog(struct ulogd_pluginstance *upi,
 static int _process_backlog(struct ulogd_pluginstance *upi);
 
 static int _configure_ring(struct ulogd_pluginstance *upi);
+static int _start_ring(struct ulogd_pluginstance *upi);
 static int _add_to_ring(struct ulogd_pluginstance *upi, struct db_instance *di);
 static void *_process_ring(void *arg);
 
@@ -132,7 +133,6 @@ ulogd_db_start(struct ulogd_pluginstance *upi)
 {
 	struct db_instance *di = (struct db_instance *) upi->private;
 	int ret;
-	unsigned int i;
 
 	ulogd_log(ULOGD_NOTICE, "starting\n");
 
@@ -144,43 +144,13 @@ ulogd_db_start(struct ulogd_pluginstance *upi)
 	if (ret < 0)
 		goto db_error;
 
-	if (di->ring.size > 0) {
-		/* allocate */
-		di->ring.ring = calloc(di->ring.size, sizeof(char) * di->ring.length);
-		if (di->ring.ring == NULL)
-			goto db_error;
-		di->ring.wr_place = di->ring.ring;
-		ulogd_log(ULOGD_NOTICE,
-			  "Allocating %d elements of size %d for ring\n",
-			  di->ring.size, di->ring.length);
-		/* init start of query for each element */
-		for(i = 0; i < di->ring.size; i++) {
-			strcpy(di->ring.ring + di->ring.length * i + 1,
-			       di->stmt);
-		}
-		/* init cond & mutex */
-		ret = pthread_cond_init(&di->ring.cond, NULL);
-		if (ret != 0)
-			goto alloc_error;
-		ret = pthread_mutex_init(&di->ring.mutex, NULL);
-		if (ret != 0)
-			goto cond_error;
-		/* create thread */
-		ret = pthread_create(&di->db_thread_id, NULL, _process_ring, upi);
-		if (ret != 0)
-			goto mutex_error;
-	}
+	ret = _start_ring(upi);
+	if (ret < 0)
+		goto db_error;
 
 	di->interp = &_interp_db_init;
-
 	return 0;
 
-mutex_error:
-	pthread_mutex_destroy(&di->ring.mutex);
-cond_error:
-	pthread_cond_destroy(&di->ring.cond);
-alloc_error:
-	free(di->ring.ring);
 db_error:
 	di->driver->close_db(upi);
 	return -1;
@@ -762,6 +732,55 @@ _configure_ring(struct ulogd_pluginstance *upi)
 	return 0;
 }
 
+static int
+_start_ring(struct ulogd_pluginstance *upi)
+{
+	struct db_instance *di = (struct db_instance *) &upi->private;
+	unsigned int i;
+	int ret;
+
+	if (di->ring.size == 0)
+		return 0;
+
+	/* allocate */
+	di->ring.ring = calloc(di->ring.size, sizeof(char) * di->ring.length);
+	if (di->ring.ring == NULL)
+		return -1;
+	di->ring.wr_place = di->ring.ring;
+	ulogd_log(ULOGD_NOTICE,
+		  "Allocating %d elements of size %d for ring\n",
+		  di->ring.size, di->ring.length);
+
+	/* init start of query for each element */
+	for(i = 0; i < di->ring.size; i++)
+		strcpy(di->ring.ring + di->ring.length * i + 1,
+		       di->stmt);
+
+	/* init cond & mutex */
+	ret = pthread_cond_init(&di->ring.cond, NULL);
+	if (ret != 0)
+		goto alloc_error;
+	ret = pthread_mutex_init(&di->ring.mutex, NULL);
+	if (ret != 0)
+		goto cond_error;
+
+	/* create thread */
+	ret = pthread_create(&di->db_thread_id, NULL, _process_ring, upi);
+	if (ret != 0)
+		goto mutex_error;
+
+	return 0;
+
+mutex_error:
+	pthread_mutex_destroy(&di->ring.mutex);
+cond_error:
+	pthread_cond_destroy(&di->ring.cond);
+alloc_error:
+	free(di->ring.ring);
+
+	return -1;
+}
+
 static int
 _add_to_ring(struct ulogd_pluginstance *upi, struct db_instance *di)
 {
-- 
2.35.1

