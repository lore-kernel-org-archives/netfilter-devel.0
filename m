Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E9AEC4708A
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Nov 2022 21:58:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236789AbiK2V6C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236860AbiK2V5e (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2022 16:57:34 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A6CBDA
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2022 13:57:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=AQeLBcBbLJO7wdNQt6WhlIZcWfI6NNeDPzNZA0EJlrM=; b=hQUYz4uppEW2+bcRrt50euXycN
        uDD78oyc36/ovrAZ2PJShUdtxgJfiPloEjHMQsO4ktZ4eOsyjV96VzNSMWzm6eCsD92fqdjoitYC8
        97BsYnDWMEEx5Lg3jHHhNhVi1D2hIcYX5ZvpxiInUuAnAzV6RUhC6FTwJ4t1J3eF5+7dVSWiaxVTN
        Xnmd9hGmlhEEnb7R5CTOR3ecvrxCfjv8pLDgPHN9OvdLU31UbaVYE7JgD6UZ8aHZcH5EubGOIpQLP
        vGoTRTm4HwSIIA43xrX3EXdnUuTr2+fBkRaUXXP5uL+1FQ5CZv9xegWNZJAXzxm+Pa2+Ls4RoZlQN
        /FF6wPeg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1p08SJ-00DjQp-N3
        for netfilter-devel@vger.kernel.org; Tue, 29 Nov 2022 21:47:55 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 v2 v2 10/34] src: remove `TIME_ERR` macro
Date:   Tue, 29 Nov 2022 21:47:25 +0000
Message-Id: <20221129214749.247878-11-jeremy@azazel.net>
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

The `TIME_ERR` macro is used to check the return value of time(2).
However, two of the definitions of it are never used.  The third is used
to check the return value of `time(NULL)`.  However, time(2) with a
`NULL` argument can never fail, so we don't need to perform the check.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/ulogd/db.h                |  2 +-
 output/dbi/ulogd_output_DBI.c     |  1 -
 output/pgsql/ulogd_output_PGSQL.c |  1 -
 util/db.c                         | 14 ++++++--------
 4 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/include/ulogd/db.h b/include/ulogd/db.h
index 50925a69f240..a6fd25b4c043 100644
--- a/include/ulogd/db.h
+++ b/include/ulogd/db.h
@@ -62,7 +62,7 @@ struct db_instance {
 	unsigned char backlog_full;
 	struct llist_head backlog;
 };
-#define TIME_ERR		((time_t)-1)	/* Be paranoid */
+
 #define RECONNECT_DEFAULT	2
 #define MAX_ONESHOT_REQUEST	10
 #define RING_BUFFER_DEFAULT_SIZE	0
diff --git a/output/dbi/ulogd_output_DBI.c b/output/dbi/ulogd_output_DBI.c
index 7f42c08efc2b..88b530ead034 100644
--- a/output/dbi/ulogd_output_DBI.c
+++ b/output/dbi/ulogd_output_DBI.c
@@ -37,7 +37,6 @@ struct dbi_instance {
 	dbi_conn dbh;
 	dbi_result result;
 };
-#define TIME_ERR	((time_t)-1)
 
 /* our configuration directives */
 static struct config_keyset dbi_kset = {
diff --git a/output/pgsql/ulogd_output_PGSQL.c b/output/pgsql/ulogd_output_PGSQL.c
index a508f9cf75a1..b798555b5ade 100644
--- a/output/pgsql/ulogd_output_PGSQL.c
+++ b/output/pgsql/ulogd_output_PGSQL.c
@@ -34,7 +34,6 @@ struct pgsql_instance {
 	PGresult *pgres;
 	unsigned char pgsql_have_schemas;
 };
-#define TIME_ERR	((time_t)-1)
 
 /* our configuration directives */
 static struct config_keyset pgsql_kset = {
diff --git a/util/db.c b/util/db.c
index dab66216e07d..fb41266648d5 100644
--- a/util/db.c
+++ b/util/db.c
@@ -302,14 +302,12 @@ static int _init_reconnect(struct ulogd_pluginstance *upi)
 		if (time(NULL) < di->reconnect)
 			return -1;
 		di->reconnect = time(NULL);
-		if (di->reconnect != TIME_ERR) {
-			ulogd_log(ULOGD_ERROR, "no connection to database, "
-				  "attempting to reconnect after %u seconds\n",
-				  reconnect_ce(upi->config_kset).u.value);
-			di->reconnect += reconnect_ce(upi->config_kset).u.value;
-			di->interp = &_init_db;
-			return -1;
-		}
+		ulogd_log(ULOGD_ERROR,
+			  "no connection to database, attempting to reconnect after %u seconds\n",
+			  reconnect_ce(upi->config_kset).u.value);
+		di->reconnect += reconnect_ce(upi->config_kset).u.value;
+		di->interp = &_init_db;
+		return -1;
 	}
 
 	/* Disable plugin permanently */
-- 
2.35.1

