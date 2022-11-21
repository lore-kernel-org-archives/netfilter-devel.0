Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED90CC4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Nov 2022 22:58:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiKUW6e (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 17:58:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbiKUW6c (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 17:58:32 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6459D2F383
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2022 14:58:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9xKiG4mgpimyVTtcFIX3nn5K/iS+s5c3TT6MXmMC15E=; b=iAZifQi7piJ4rC8sJVKlCfOu4C
        +bpiSH0lM77omx6ghhV0xPoG2fZsqVxKQyAguyX8aZCXa2iDmyiX35wIqefGjIkMW2mpNCNbjVP3Z
        OoGUW9p4Z0IbrFDs05kq1BYZHrT6Kj6P/FsslUuWtHLSynrrBlS5EEJx0wDADM74UpoLA8AdFmnnO
        isE6cOh+/qRanxtkZ9nyKPgKlY0lL+Lh+XnVgq+03E7T/y8zhzWI5pq74nZTpKWq57mzqsry+ordl
        ke6+NO9mC5I0OxsTRXm3jYklA9p5wZc7MrjFt8ixaySI3kgEAiccWVR1Rmgu8CaR4o9j/9Y0F7Zca
        IppudOVQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oxFGE-005LgP-GI
        for netfilter-devel@vger.kernel.org; Mon, 21 Nov 2022 22:27:30 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 20/34] db: refactor configuration
Date:   Mon, 21 Nov 2022 22:25:57 +0000
Message-Id: <20221121222611.3914559-21-jeremy@azazel.net>
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

Move DB, back-log and ring-buffer config code into separate functions.

No functional changes.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 util/db.c | 118 ++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 83 insertions(+), 35 deletions(-)

diff --git a/util/db.c b/util/db.c
index ce1273638ae0..a633257b5929 100644
--- a/util/db.c
+++ b/util/db.c
@@ -40,6 +40,7 @@
 
 /* generic db layer */
 
+static int _configure_db(struct ulogd_pluginstance *upi);
 static int _interp_db_init(struct ulogd_pluginstance *upi);
 static int _interp_db_main(struct ulogd_pluginstance *upi);
 static int _interp_db_disabled(struct ulogd_pluginstance *upi);
@@ -55,10 +56,12 @@ static unsigned int _calc_sql_stmt_size(const char *procedure,
 static void _bind_sql_stmt(struct ulogd_pluginstance *upi,
 			   char *stmt);
 
+static int _configure_backlog(struct ulogd_pluginstance *upi);
 static int _add_to_backlog(struct ulogd_pluginstance *upi,
 			   const char *stmt, unsigned int len);
 static int _process_backlog(struct ulogd_pluginstance *upi);
 
+static int _configure_ring(struct ulogd_pluginstance *upi);
 static int _add_to_ring(struct ulogd_pluginstance *upi, struct db_instance *di);
 static void *_process_ring(void *arg);
 
@@ -66,53 +69,23 @@ int
 ulogd_db_configure(struct ulogd_pluginstance *upi,
 		   struct ulogd_pluginstance_stack *stack)
 {
-	struct db_instance *di = (struct db_instance *) upi->private;
 	int ret;
 
 	ulogd_log(ULOGD_NOTICE, "(re)configuring\n");
 
-	/* First: Parse configuration file section for this instance */
-	ret = config_parse_file(upi->id, upi->config_kset);
+	ret = _configure_db(upi);
 	if (ret < 0) {
-		ulogd_log(ULOGD_ERROR, "error parsing config file\n");
 		return ret;
 	}
 
-	/* Second: Open Database */
-	ret = di->driver->open_db(upi);
+	ret = _configure_backlog(upi);
 	if (ret < 0) {
-		ulogd_log(ULOGD_ERROR, "error in open_db\n");
 		return ret;
 	}
 
-	/* Third: Determine required input keys for given table */
-	ret = di->driver->get_columns(upi);
-	if (ret < 0)
-		ulogd_log(ULOGD_ERROR, "error in get_columns\n");
-
-	/* Close database, since ulogd core could just call configure
-	 * but abort during input key resolving routines.  configure
-	 * doesn't have a destructor... */
-	di->driver->close_db(upi);
-
-	INIT_LLIST_HEAD(&di->backlog);
-	di->backlog_memusage = 0;
-
-	di->ring.size = ringsize_ce(upi->config_kset).u.value;
-	di->backlog_memcap = backlog_memcap_ce(upi->config_kset).u.value;
-
-	if (di->ring.size && di->backlog_memcap) {
-		ulogd_log(ULOGD_ERROR, "Ring buffer has precedence over backlog\n");
-		di->backlog_memcap = 0;
-	} else if (di->backlog_memcap > 0) {
-		di->backlog_oneshot = backlog_oneshot_ce(upi->config_kset).u.value;
-		if (di->backlog_oneshot <= 2) {
-			ulogd_log(ULOGD_ERROR,
-				  "backlog_oneshot_requests must be > 2 to hope"
-				  " cleaning. Setting it to 3.\n");
-			di->backlog_oneshot = 3;
-		}
-		di->backlog_full = 0;
+	ret = _configure_ring(upi);
+	if (ret < 0) {
+		return ret;
 	}
 
 	return 0;
@@ -274,6 +247,40 @@ ulogd_db_stop(struct ulogd_pluginstance *upi)
 
 /******************************************************************************/
 
+static int
+_configure_db(struct ulogd_pluginstance *upi)
+{
+	struct db_instance *di = (struct db_instance *) upi->private;
+	int ret;
+
+	/* First: Parse configuration file section for this instance */
+	ret = config_parse_file(upi->id, upi->config_kset);
+	if (ret < 0) {
+		ulogd_log(ULOGD_ERROR, "error parsing config file\n");
+		return ret;
+	}
+
+	/* Second: Open Database */
+	ret = di->driver->open_db(upi);
+	if (ret < 0) {
+		ulogd_log(ULOGD_ERROR, "error in open_db\n");
+		return ret;
+	}
+
+	/* Third: Determine required input keys for given table */
+	ret = di->driver->get_columns(upi);
+	if (ret < 0)
+		ulogd_log(ULOGD_ERROR, "error in get_columns\n");
+
+	/* Close database, since ulogd core could just call configure
+	 * but abort during input key resolving routines.  configure
+	 * doesn't have a destructor... */
+	di->driver->close_db(upi);
+
+	return ret;
+
+}
+
 static int
 _interp_db_init(struct ulogd_pluginstance *upi)
 {
@@ -640,6 +647,37 @@ _bind_sql_stmt(struct ulogd_pluginstance *upi, char *start)
 
 /******************************************************************************/
 
+static int
+_configure_backlog(struct ulogd_pluginstance *upi)
+{
+	struct db_instance *di = (struct db_instance *) &upi->private;
+
+	INIT_LLIST_HEAD(&di->backlog);
+
+	di->backlog_memusage = 0;
+	di->backlog_memcap = backlog_memcap_ce(upi->config_kset).u.value;
+	di->backlog_full = 0;
+
+	if (di->backlog_memcap == 0)
+		return 0;
+
+	if (ringsize_ce(upi->config_kset).u.value) {
+		ulogd_log(ULOGD_ERROR,
+			  "Ring buffer has precedence over backlog\n");
+		di->backlog_memcap = 0;
+		return 0;
+	}
+
+	di->backlog_oneshot = backlog_oneshot_ce(upi->config_kset).u.value;
+	if (di->backlog_oneshot <= 2) {
+		ulogd_log(ULOGD_ERROR,
+			  "backlog_oneshot_requests must be > 2 to be effective. Setting it to 3.\n");
+		di->backlog_oneshot = 3;
+	}
+
+	return 0;
+}
+
 static int
 _add_to_backlog(struct ulogd_pluginstance *upi,
 		const char *stmt, unsigned int len)
@@ -714,6 +752,16 @@ _process_backlog(struct ulogd_pluginstance *upi)
 
 /******************************************************************************/
 
+static int
+_configure_ring(struct ulogd_pluginstance *upi)
+{
+	struct db_instance *di = (struct db_instance *) &upi->private;
+
+	di->ring.size = ringsize_ce(upi->config_kset).u.value;
+
+	return 0;
+}
+
 static int
 _add_to_ring(struct ulogd_pluginstance *upi, struct db_instance *di)
 {
-- 
2.35.1

