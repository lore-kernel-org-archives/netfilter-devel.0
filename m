Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 741CCC636F8
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Nov 2022 21:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236290AbiK2V5c (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:57:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236987AbiK2V5U (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2022 16:57:20 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3AA6C733
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2022 13:57:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NcR8P1UVxs7CiQPu46xw1pmJnznEx0JYTUDnx1jP+tg=; b=fCdK7jjWgbIMtFjCOHx0ABmMob
        jTI2mQ+mQmRhALteYxX+oDsK01+LjKQb+C9Yh3O2SF+CPTUMDsnAeoVw/ShK0JzRjEuNE9Hhve6EB
        8eiXu/wnITzG5RXO4wy/PDO5jBGgAucW26bN5C919CKqg4HS/fCBwNue970wacllWCtNy8V5CPdmu
        cHJlMmK+JRmixTODZYRg15plXgFIAtJzn1IRJnTNu6dTO4X9V6IRyrxs2rNSqB1D7fbuA/RN2WLd1
        uANclMK9eWv0CMHqp7nVRhQEEYS4BI1HBaWQAiZV3PnZY4YOt5uYYDlXLGHNAj+iDfeglxYb2+A8k
        6ggWgXXw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1p08SK-00DjQp-G7
        for netfilter-devel@vger.kernel.org; Tue, 29 Nov 2022 21:47:56 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 v2 v2 16/34] db: use consistent integer return values to indicate errors
Date:   Tue, 29 Nov 2022 21:47:31 +0000
Message-Id: <20221129214749.247878-17-jeremy@azazel.net>
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

Internally, we use `-1` for error and `0` for success.  The `interp`
functions that return to `ulogd_propagate_results` return
`ULOGD_IRET_ERR` and `ULOGD_IRET_OK`.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/dbi/ulogd_output_DBI.c     |  2 +-
 output/pgsql/ulogd_output_PGSQL.c |  8 ++---
 util/db.c                         | 59 +++++++++++++++++--------------
 3 files changed, 38 insertions(+), 31 deletions(-)

diff --git a/output/dbi/ulogd_output_DBI.c b/output/dbi/ulogd_output_DBI.c
index 5c10c787fb6a..3b8d8c325131 100644
--- a/output/dbi/ulogd_output_DBI.c
+++ b/output/dbi/ulogd_output_DBI.c
@@ -96,7 +96,7 @@ static int get_columns_dbi(struct ulogd_pluginstance *upi)
 
 	if (!pi->dbh) {
 		ulogd_log(ULOGD_ERROR, "no database handle\n");
-		return 1;
+		return -1;
 	}
 
 	snprintf(query, 256, "SELECT * FROM %s", table);
diff --git a/output/pgsql/ulogd_output_PGSQL.c b/output/pgsql/ulogd_output_PGSQL.c
index c5bbc966d66d..70a4d48459ff 100644
--- a/output/pgsql/ulogd_output_PGSQL.c
+++ b/output/pgsql/ulogd_output_PGSQL.c
@@ -92,7 +92,7 @@ static int pgsql_namespace(struct ulogd_pluginstance *upi)
 		   strlen(schema_ce(upi->config_kset).u.string) + 1];
 
 	if (!pi->dbh)
-		return 1;
+		return -1;
 
 	sprintf(pgbuf, PGSQL_HAVE_NAMESPACE_TEMPLATE,
 		schema_ce(upi->config_kset).u.string);
@@ -101,7 +101,7 @@ static int pgsql_namespace(struct ulogd_pluginstance *upi)
 	pi->pgres = PQexec(pi->dbh, pgbuf);
 	if (!pi->pgres) {
 		ulogd_log(ULOGD_DEBUG, "\n result false");
-		return 1;
+		return -1;
 	}
 
 	if (PQresultStatus(pi->pgres) == PGRES_TUPLES_OK) {
@@ -141,7 +141,7 @@ static int get_columns_pgsql(struct ulogd_pluginstance *upi)
 
 	if (!pi->dbh) {
 		ulogd_log(ULOGD_ERROR, "no database handle\n");
-		return 1;
+		return -1;
 	}
 
 	if (pi->db_inst.schema) {
@@ -228,7 +228,7 @@ static int open_db_pgsql(struct ulogd_pluginstance *upi)
 
 		cp = connstr = malloc(len);
 		if (!connstr)
-			return -ENOMEM;
+			return -1;
 
 		if (server[0])
 			cp += sprintf(cp, "host=%s ", server);
diff --git a/util/db.c b/util/db.c
index 7a6401f73609..cd9ebef077dd 100644
--- a/util/db.c
+++ b/util/db.c
@@ -111,7 +111,7 @@ ulogd_db_configure(struct ulogd_pluginstance *upi,
 		di->backlog_full = 0;
 	}
 
-	return ret;
+	return 0;
 }
 
 int
@@ -131,7 +131,7 @@ ulogd_db_alloc_input_keys(struct ulogd_pluginstance *upi,
 	if (!upi->input.keys) {
 		upi->input.num_keys = 0;
 		ulogd_log(ULOGD_ERROR, "ENOMEM\n");
-		return -ENOMEM;
+		return -1;
 	}
 
 	for (i = 0; i < num_keys; i++) {
@@ -170,10 +170,8 @@ ulogd_db_start(struct ulogd_pluginstance *upi)
 	if (di->ring.size > 0) {
 		/* allocate */
 		di->ring.ring = calloc(di->ring.size, sizeof(char) * di->ring.length);
-		if (di->ring.ring == NULL) {
-			ret = -1;
+		if (di->ring.ring == NULL)
 			goto db_error;
-		}
 		di->ring.wr_place = di->ring.ring;
 		ulogd_log(ULOGD_NOTICE,
 			  "Allocating %d elements of size %d for ring\n",
@@ -198,7 +196,7 @@ ulogd_db_start(struct ulogd_pluginstance *upi)
 
 	di->interp = &_interp_db_init;
 
-	return ret;
+	return 0;
 
 mutex_error:
 	pthread_mutex_destroy(&di->ring.mutex);
@@ -208,7 +206,7 @@ alloc_error:
 	free(di->ring.ring);
 db_error:
 	di->driver->close_db(upi);
-	return ret;
+	return -1;
 }
 
 /* this is a wrapper that just calls the current real interp function */
@@ -283,16 +281,18 @@ _interp_db_init(struct ulogd_pluginstance *upi)
 			_bind_sql_stmt(upi, di->stmt);
 			_add_to_backlog(upi, di->stmt, strlen(di->stmt));
 		}
-		return 0;
+		return ULOGD_IRET_OK;
 	}
 
-	if (di->driver->open_db(upi)) {
+	if (di->driver->open_db(upi) < 0) {
 		ulogd_log(ULOGD_ERROR, "can't establish database connection\n");
 		if (di->backlog_memcap && !di->backlog_full) {
 			_bind_sql_stmt(upi, di->stmt);
 			_add_to_backlog(upi, di->stmt, strlen(di->stmt));
 		}
-		return _reconnect_db(upi);
+		if (_reconnect_db(upi) < 0)
+			return ULOGD_IRET_ERR;
+		return ULOGD_IRET_OK;
 	}
 
 	/* enable 'real' logging */
@@ -311,40 +311,48 @@ _interp_db_main(struct ulogd_pluginstance *upi)
 {
 	struct db_instance *di = (struct db_instance *) &upi->private;
 
-	if (di->ring.size)
-		return _add_to_ring(upi, di);
+	if (di->ring.size) {
+		if (_add_to_ring(upi, di) < 0)
+			return ULOGD_IRET_ERR;
+		return ULOGD_IRET_OK;
+	}
 
 	_bind_sql_stmt(upi, di->stmt);
 
 	/* if backup log is not empty we add current query to it */
 	if (!llist_empty(&di->backlog)) {
 		int ret = _add_to_backlog(upi, di->stmt, strlen(di->stmt));
-		if (ret == 0)
-			return _process_backlog(upi);
-		else {
-			ret = _process_backlog(upi);
-			if (ret)
-				return ret;
-			/* try adding once the data to backlog */
-			return _add_to_backlog(upi, di->stmt, strlen(di->stmt));
+		if (ret == 0) {
+			if (_process_backlog(upi) < 0)
+				return ULOGD_IRET_ERR;
+			return ULOGD_IRET_OK;
 		}
+		ret = _process_backlog(upi);
+		if (ret < 0)
+			return ULOGD_IRET_ERR;
+		/* try adding once the data to backlog */
+		if (_add_to_backlog(upi, di->stmt, strlen(di->stmt)) < 0)
+			return ULOGD_IRET_ERR;
+		return ULOGD_IRET_OK;
 	}
 
 	if (di->driver->execute(upi, di->stmt, strlen(di->stmt)) < 0) {
 		_add_to_backlog(upi, di->stmt, strlen(di->stmt));
 		/* error occur, database connexion need to be closed */
 		di->driver->close_db(upi);
-		return _reconnect_db(upi);
+		if (_reconnect_db(upi) < 0)
+			return ULOGD_IRET_ERR;
+		return ULOGD_IRET_OK;
 	}
 
-	return 0;
+	return ULOGD_IRET_OK;
 }
 
 /* no connection, plugin disabled */
 static int
 _interp_db_disabled(struct ulogd_pluginstance *upi)
 {
-	return 0;
+	return ULOGD_IRET_OK;
 }
 
 static int
@@ -367,7 +375,6 @@ _reconnect_db(struct ulogd_pluginstance *upi)
 	/* Disable plugin permanently */
 	ulogd_log(ULOGD_ERROR, "permanently disabling plugin\n");
 	di->interp = &_interp_db_disabled;
-
 	return 0;
 }
 
@@ -438,7 +445,7 @@ _create_sql_stmt(struct ulogd_pluginstance *upi)
 	di->stmt = malloc(size);
 	if (!di->stmt) {
 		ulogd_log(ULOGD_ERROR, "OOM!\n");
-		return -ENOMEM;
+		return -1;
 	}
 	di->ring.length = size + 1;
 
@@ -717,7 +724,7 @@ _loop_reconnect_db(struct ulogd_pluginstance * upi)
 
 	di->driver->close_db(upi);
 	while (1) {
-		if (di->driver->open_db(upi)) {
+		if (di->driver->open_db(upi) < 0) {
 			sleep(1);
 		} else {
 			return 0;
-- 
2.35.1

