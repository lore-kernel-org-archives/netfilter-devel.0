Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15226C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 22:45:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348927AbhKXWsp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:48:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243822AbhKXWso (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 17:48:44 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A60FC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 14:45:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bmER+1Hae1bUUjm5c2uJGCDLC9LwXZvjPZrUDf/xde0=; b=f9dWp6Gkc9GeoSzIh8D6iG+Y7y
        H6miPT+5e4FxlH7dmOTy+kVxYTQdOF7c+mdJUsFhtkbLR0yR4JQAmrlOpHPLZnVkfpxyGrSGfwTnm
        tvKBg1nCqMeJzYdSa7qxaeVHFMfYBuqVXG7DXTzkV1xFnr+BbX35MKXgFGEu3U/sPOOHPFy1kRIB/
        TtcmCMfnnLabfj3qwkFm3hNUs7TekWTyyVyuJreIcTtbMjH5KjIEIayojVvUsIpC+MyJmP/EXJ+gS
        B4quHouI+ZLAR5hIUv1Uu/mljCW+E/NvgS1//73kkE0rgvXt/T5H5mtv83vd1ePeV8pBeflD85ccH
        KFtk6VYg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mq0h7-00563U-GN
        for netfilter-devel@vger.kernel.org; Wed, 24 Nov 2021 22:24:49 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 14/32] output: DBI: fix configuration of DB connection
Date:   Wed, 24 Nov 2021 22:24:09 +0000
Message-Id: <20211124222444.2597311-15-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124222444.2597311-1-jeremy@azazel.net>
References: <20211124222444.2597311-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In `open_db_dbi`, we test whether various config-settings are defined
by comparing their string values to `NULL`.  However, the `u.string`
member of `struct config_entry` is an array, not a pointer, so it is
never `NULL`.  Instead, check whether the string is empty.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/dbi/ulogd_output_DBI.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/output/dbi/ulogd_output_DBI.c b/output/dbi/ulogd_output_DBI.c
index 57e3058036d9..5eee6b593b5b 100644
--- a/output/dbi/ulogd_output_DBI.c
+++ b/output/dbi/ulogd_output_DBI.c
@@ -175,10 +175,10 @@ static int close_db_dbi(struct ulogd_pluginstance *upi)
 static int open_db_dbi(struct ulogd_pluginstance *upi)
 {
 	struct dbi_instance *pi = (struct dbi_instance *) upi->private;
-	char *server = host_ce(upi->config_kset).u.string;
-	char *user = user_ce(upi->config_kset).u.string;
-	char *pass = pass_ce(upi->config_kset).u.string;
-	char *db = db_ce(upi->config_kset).u.string;
+	char *server = host_ce  (upi->config_kset).u.string;
+	char *user   = user_ce  (upi->config_kset).u.string;
+	char *pass   = pass_ce  (upi->config_kset).u.string;
+	char *db     = db_ce    (upi->config_kset).u.string;
 	char *dbtype = dbtype_ce(upi->config_kset).u.string;
 	dbi_driver driver;
 	int ret;
@@ -203,13 +203,13 @@ static int open_db_dbi(struct ulogd_pluginstance *upi)
 		return -1;
 	}
 
-	if (server)
+	if (server[0])
 		dbi_conn_set_option(pi->dbh, "host", server);
-	if (user)
+	if (user[0])
 		dbi_conn_set_option(pi->dbh, "username", user);
-	if (pass)
+	if (pass[0])
 		dbi_conn_set_option(pi->dbh, "password", pass);
-	if (db)
+	if (db[0])
 		dbi_conn_set_option(pi->dbh, "dbname", db);
 
 	ret = dbi_conn_connect(pi->dbh);
-- 
2.33.0

