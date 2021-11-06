Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F96CC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 17:15:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87CAA61360
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 17:15:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234642AbhKFRRm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 13:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234657AbhKFRRl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 13:17:41 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535D7C061570
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 10:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=f39ym8luh+rm6LBp0IoSBcs9OC7a4hkrT1F7OEz1C0E=; b=GPZL+b7o57SV8I3W7916D8eCe/
        apP+4jdzZ+/BvKPVbPDUgDWlwjW7uMablrz1u4lFlKxh0O8HTbk1QgMHQwmk1TFE8mbrCcqG6AeT0
        Cl0a5Qt7HDGQ5+na4oBH6/NZZWUlQqX54fKHOalSeUGtfYfOXxJttDg4UpLxGbK8lXwHALyoD2I0+
        0x/bDDu7Ihj0EVoWCOGtcqkpo5wYP1d4BikQ3yWDf06lZv4rsRuAVoYV0pUicWKaaNNehmeWoUFNk
        QwavNnpVsyklsawojIZSpT8Hzt4s042DgGiLxwKmYoE7QKpfPmSkimX++Ubfc1HYPEg7UXTwk7BfT
        2BD8lhfw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjOtK-004m1E-Fx
        for netfilter-devel@vger.kernel.org; Sat, 06 Nov 2021 16:50:06 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v2 16/27] output: DBI: fix deprecation warnings
Date:   Sat,  6 Nov 2021 16:49:42 +0000
Message-Id: <20211106164953.130024-17-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211106164953.130024-1-jeremy@azazel.net>
References: <20211106164953.130024-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Switch to re-entrant libdbi functions.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/dbi/ulogd_output_DBI.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/output/dbi/ulogd_output_DBI.c b/output/dbi/ulogd_output_DBI.c
index 23cc9c8fb492..461aed4bddb6 100644
--- a/output/dbi/ulogd_output_DBI.c
+++ b/output/dbi/ulogd_output_DBI.c
@@ -29,6 +29,8 @@
 #define DEBUGP(x, args...)
 #endif
 
+static dbi_inst libdbi_instance;
+
 struct dbi_instance {
 	struct db_instance db_inst;
 
@@ -195,14 +197,14 @@ static int open_db_dbi(struct ulogd_pluginstance *upi)
 
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
@@ -320,7 +322,7 @@ void __attribute__ ((constructor)) init(void);
 
 void init(void)
 {
-	dbi_initialize(NULL);
+	dbi_initialize_r(NULL, &libdbi_instance);
 
 	ulogd_register_plugin(&dbi_plugin);
 }
-- 
2.33.0

