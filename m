Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E667EC433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Nov 2021 11:15:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236423AbhK3LS0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 06:18:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235176AbhK3LSZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 06:18:25 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6519C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Nov 2021 03:15:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ids3tharwDnGFr8EgGRa+2RBHaTQDBczz1AaWQO23U8=; b=j72raCUhbG3xCLlEpK0JPksw3s
        eFKgsbM7OoCdDAoH9S1JMg4A45rQUHvuGFfQZ7iYrNstMiYhaFNE7UwyYz8TejMGk5iUipKUnM1v9
        XC8tHh4yoNdGTfhfJizgxH9Jx9MqC5K4s6kDSxoOtFdlqrYuznReN5iXW2a1K03CKiiRxDd4sHl1y
        1hAIWdAtbDY7eh+hhtJ7bpD62FA2N00PZbP+R7pdKjk0fBssFa7cBFbfEENRVPb8pv0Cg5joRD66G
        eJ/ypvKSXILuwElQYwUPTtyj7bcthg8AqKCEbTZFVEOkVO9xRx/v4CBcqFeJA3mCEaoUbTyMNN+p6
        BgcjYb5w==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1ms0nr-00Awwr-UA
        for netfilter-devel@vger.kernel.org; Tue, 30 Nov 2021 10:56:04 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v4 11/32] output: DBI: fix deprecation warnings
Date:   Tue, 30 Nov 2021 10:55:39 +0000
Message-Id: <20211130105600.3103609-12-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130105600.3103609-1-jeremy@azazel.net>
References: <20211130105600.3103609-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The DBI output plugin uses some libdbi functions which have been
deprecated in favour of re-entrant equivalents.  Switch to the
re-entrant functions.

Remove superfluous `init` declaration.

Add destructor to clean up DBI instance on exit.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/dbi/ulogd_output_DBI.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/output/dbi/ulogd_output_DBI.c b/output/dbi/ulogd_output_DBI.c
index 23cc9c8fb492..b4a5bacd156f 100644
--- a/output/dbi/ulogd_output_DBI.c
+++ b/output/dbi/ulogd_output_DBI.c
@@ -29,6 +29,8 @@
 #define DEBUGP(x, args...)
 #endif
 
+static dbi_inst libdbi_instance;
+
 struct dbi_instance {
 	struct db_instance db_inst;
 
@@ -173,7 +175,6 @@ static int close_db_dbi(struct ulogd_pluginstance *upi)
 	ulogd_log(ULOGD_DEBUG, "dbi: closing connection\n");
 	dbi_conn_close(pi->dbh);
 	pi->dbh = NULL;
-	//dbi_shutdown();
 
 	return 0;
 }
@@ -195,14 +196,14 @@ static int open_db_dbi(struct ulogd_pluginstance *upi)
 
 	ulogd_log(ULOGD_ERROR, "Opening connection for db type %s\n",
 		  dbtype);
-	driver = dbi_driver_open(dbtype);
+	driver = dbi_driver_open_r(dbtype, libdbi_instance);
 	if (driver == NULL) {
 		ulogd_log(ULOGD_ERROR, "unable to load driver for db type %s\n",
 			  dbtype);
 		close_db_dbi(upi);
 		return -1;
 	}
-	pi->dbh = dbi_conn_new(dbtype);
+	pi->dbh = dbi_conn_new_r(dbtype, libdbi_instance);
 	if (pi->dbh == NULL) {
 		ulogd_log(ULOGD_ERROR, "unable to initialize db type %s\n",
 			  dbtype);
@@ -316,11 +317,14 @@ static struct ulogd_plugin dbi_plugin = {
 	.version	= VERSION,
 };
 
-void __attribute__ ((constructor)) init(void);
-
-void init(void)
+void __attribute__ ((constructor)) init(void)
 {
-	dbi_initialize(NULL);
+	dbi_initialize_r(NULL, &libdbi_instance);
 
 	ulogd_register_plugin(&dbi_plugin);
 }
+
+void __attribute__ ((destructor)) fini(void)
+{
+	dbi_shutdown_r(libdbi_instance);
+}
-- 
2.33.0

