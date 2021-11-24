Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3928C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 22:45:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345074AbhKXWsP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:48:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344361AbhKXWsO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 17:48:14 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C75CC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 14:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ids3tharwDnGFr8EgGRa+2RBHaTQDBczz1AaWQO23U8=; b=OGgrHowY4+J6zMuwNLRhON+LC8
        f3ipxMkZi26CcQXN+q6wcxd7f/CdOg+sJwD11BwPbVnLX0yAxFpX/rV2/6noZsZ84GB8mWszJbDzA
        x8WbPLeYahYt4LpBoSHQHA84q1TMNRuEGlTZ58DO8+mVcH2M2jHHYYJyfcJZT4F+toa2ePFHqnP5o
        GTjNU8NyXVi7eTQNfyJxcHVEHlD4rROaCWRHSi6LuXOvcJmmUKsH8oy4MhlcESOCg9klIYOtnHQHK
        e5rVZoqgr6wP5kdXmLJklXXDljp+OebJW4zWIh0KWu+9WJpJIMqH38aswod/iBKfp/CyBzPdGpowT
        hcdRJwHw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mq0h7-00563U-81
        for netfilter-devel@vger.kernel.org; Wed, 24 Nov 2021 22:24:49 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 11/32] output: DBI: fix deprecation warnings
Date:   Wed, 24 Nov 2021 22:24:06 +0000
Message-Id: <20211124222444.2597311-12-jeremy@azazel.net>
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

