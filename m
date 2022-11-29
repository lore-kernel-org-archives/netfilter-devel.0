Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD4FC4708A
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Nov 2022 21:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236878AbiK2V6g (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:58:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236732AbiK2V6M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2022 16:58:12 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F236F0E1
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2022 13:58:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=siqED/1CHnBajSfA8J66f7ue7A425WILCYaAqWXVGuI=; b=ndu8vcQS8YE2RuDDEvfPuKYPkd
        +cyfHLmKZT9T098S8LcwLbNzYiRJuEjkqqI9Be9r9xtWbeDX86iXSwd/DJStdJ/rclfFwoIPSSggo
        IdJ0XFDiacjsowLSuO8MSBkHld1I6WfFUw2L/S2Hwst+xwm9gqN9++6ED9pu6kuQapEBWK9r8QrSI
        DPg1XcSs6PMwUU+Rg3yOQncyIhIFy3L4vO9t6Es8rQ8+m4w4Fc1bTof5AVfmNL5fA+1DQc3ctTFCW
        451mnBHvd/zTBu7ptP27u+eTDbf9T4W1UskAFA7k3ZqNIF78TUfT8IrkRCGwlhZPtV0FqieBUmVzb
        5Oydvf+Q==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1p08SL-00DjQp-BO
        for netfilter-devel@vger.kernel.org; Tue, 29 Nov 2022 21:47:57 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 v2 v2 23/34] db: refactor backlog
Date:   Tue, 29 Nov 2022 21:47:38 +0000
Message-Id: <20221129214749.247878-24-jeremy@azazel.net>
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

Move the backlog fields into a separate structure along the same lines
as the ring-buffer.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/ulogd/db.h | 18 +++++++++++++-----
 util/db.c          | 44 ++++++++++++++++++++++----------------------
 2 files changed, 35 insertions(+), 27 deletions(-)

diff --git a/include/ulogd/db.h b/include/ulogd/db.h
index ebf4f42917c3..fc3b15ef0e0f 100644
--- a/include/ulogd/db.h
+++ b/include/ulogd/db.h
@@ -45,6 +45,18 @@ struct db_stmt_ring {
 
 };
 
+struct db_stmt_backlog {
+
+	struct llist_head items;
+
+	unsigned int memcap;
+	unsigned int memusage;
+	unsigned int oneshot;
+
+	int full;
+
+};
+
 struct db_stmt {
 	char *stmt;
 	int len;
@@ -61,11 +73,7 @@ struct db_instance {
 	/* DB ring buffer */
 	struct db_stmt_ring ring;
 	/* Backlog system */
-	unsigned int backlog_memcap;
-	unsigned int backlog_memusage;
-	unsigned int backlog_oneshot;
-	unsigned char backlog_full;
-	struct llist_head backlog;
+	struct db_stmt_backlog backlog;
 };
 
 #define RECONNECT_DEFAULT	2
diff --git a/util/db.c b/util/db.c
index 8a870846332b..89c81d8d1dc5 100644
--- a/util/db.c
+++ b/util/db.c
@@ -259,7 +259,7 @@ _interp_db_init(struct ulogd_pluginstance *upi)
 
 	if (di->reconnect && di->reconnect > time(NULL)) {
 		/* store entry to backlog if it is active */
-		if (di->backlog_memcap && !di->backlog_full) {
+		if (di->backlog.memcap && !di->backlog.full) {
 			_bind_sql_stmt(upi, di->stmt);
 			_add_to_backlog(upi, di->stmt, strlen(di->stmt));
 		}
@@ -268,7 +268,7 @@ _interp_db_init(struct ulogd_pluginstance *upi)
 
 	if (di->driver->open_db(upi) < 0) {
 		ulogd_log(ULOGD_ERROR, "can't establish database connection\n");
-		if (di->backlog_memcap && !di->backlog_full) {
+		if (di->backlog.memcap && !di->backlog.full) {
 			_bind_sql_stmt(upi, di->stmt);
 			_add_to_backlog(upi, di->stmt, strlen(di->stmt));
 		}
@@ -302,7 +302,7 @@ _interp_db_main(struct ulogd_pluginstance *upi)
 	_bind_sql_stmt(upi, di->stmt);
 
 	/* if backup log is not empty we add current query to it */
-	if (!llist_empty(&di->backlog)) {
+	if (!llist_empty(&di->backlog.items)) {
 		int ret = _add_to_backlog(upi, di->stmt, strlen(di->stmt));
 		if (ret == 0) {
 			if (_process_backlog(upi) < 0)
@@ -623,27 +623,27 @@ _configure_backlog(struct ulogd_pluginstance *upi)
 {
 	struct db_instance *di = (struct db_instance *) &upi->private;
 
-	INIT_LLIST_HEAD(&di->backlog);
+	INIT_LLIST_HEAD(&di->backlog.items);
 
-	di->backlog_memusage = 0;
-	di->backlog_memcap = backlog_memcap_ce(upi->config_kset).u.value;
-	di->backlog_full = 0;
+	di->backlog.memusage = 0;
+	di->backlog.memcap = backlog_memcap_ce(upi->config_kset).u.value;
+	di->backlog.full = 0;
 
-	if (di->backlog_memcap == 0)
+	if (di->backlog.memcap == 0)
 		return 0;
 
 	if (ringsize_ce(upi->config_kset).u.value) {
 		ulogd_log(ULOGD_ERROR,
 			  "Ring buffer has precedence over backlog\n");
-		di->backlog_memcap = 0;
+		di->backlog.memcap = 0;
 		return 0;
 	}
 
-	di->backlog_oneshot = backlog_oneshot_ce(upi->config_kset).u.value;
-	if (di->backlog_oneshot <= 2) {
+	di->backlog.oneshot = backlog_oneshot_ce(upi->config_kset).u.value;
+	if (di->backlog.oneshot <= 2) {
 		ulogd_log(ULOGD_ERROR,
 			  "backlog_oneshot_requests must be > 2 to be effective. Setting it to 3.\n");
-		di->backlog_oneshot = 3;
+		di->backlog.oneshot = 3;
 	}
 
 	return 0;
@@ -658,17 +658,17 @@ _add_to_backlog(struct ulogd_pluginstance *upi,
 	struct db_stmt *query;
 
 	/* check if we are using backlog */
-	if (di->backlog_memcap == 0)
+	if (di->backlog.memcap == 0)
 		return 0;
 
 	query_size = sizeof(*query) + len + 1;
 
 	/* check len against backlog */
-	if (query_size + di->backlog_memcap - di->backlog_memusage) {
-		if (di->backlog_full == 0)
+	if (query_size + di->backlog.memcap - di->backlog.memusage) {
+		if (!di->backlog.full)
 			ulogd_log(ULOGD_ERROR,
 				  "Backlog is full starting to reject events.\n");
-		di->backlog_full = 1;
+		di->backlog.full = 1;
 		return -1;
 	}
 
@@ -684,10 +684,10 @@ _add_to_backlog(struct ulogd_pluginstance *upi,
 		return -1;
 	}
 
-	di->backlog_memusage += query_size;
-	di->backlog_full = 0;
+	di->backlog.memusage += query_size;
+	di->backlog.full = 0;
 
-	llist_add_tail(&query->list, &di->backlog);
+	llist_add_tail(&query->list, &di->backlog.items);
 
 	return 0;
 }
@@ -696,7 +696,7 @@ static int
 _process_backlog(struct ulogd_pluginstance *upi)
 {
 	struct db_instance *di = (struct db_instance *) &upi->private;
-	int i = di->backlog_oneshot;
+	int i = di->backlog.oneshot;
 	struct db_stmt *query;
 	struct db_stmt *nquery;
 
@@ -704,13 +704,13 @@ _process_backlog(struct ulogd_pluginstance *upi)
 	if (di->reconnect && di->reconnect > time(NULL))
 		return 0;
 
-	llist_for_each_entry_safe(query, nquery, &di->backlog, list) {
+	llist_for_each_entry_safe(query, nquery, &di->backlog.items, list) {
 		if (di->driver->execute(upi, query->stmt, query->len) < 0) {
 			/* error occur, database connexion need to be closed */
 			di->driver->close_db(upi);
 			return _reconnect_db(upi);
 		} else {
-			di->backlog_memusage -= sizeof(*query) + query->len + 1;
+			di->backlog.memusage -= sizeof(*query) + query->len + 1;
 			llist_del(&query->list);
 			free(query->stmt);
 			free(query);
-- 
2.35.1

