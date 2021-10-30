Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21562C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:11:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DE1460F9B
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:11:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhJ3RNp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 13:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbhJ3RNo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 13:13:44 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64193C061570
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 10:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=f39ym8luh+rm6LBp0IoSBcs9OC7a4hkrT1F7OEz1C0E=; b=lA6uRypkutOo34yb7F+inelg9a
        14Aplb+73VYaHGbmFv9vxbMp8P5hH8FU7OiuUkOFzdWYs/7rWFhsTjsvS7So0oDn9s1/GuMOsXP38
        tJvhx/O4UgjPtyhqBDo2KtackDKBgfbuiI0vSynL+ZnGYKxQHbFLR22MeaZMiWQc1YQkxMi/UNxUt
        UlWTGA3RqFxXnSBSzCMSEtO5r/HU9sErSurI8CRhxaffifv82Dob1rpypJMCRMgWA/j2Ee7CvM+WG
        /gH2lLjMxAnsRJ4k7IS/+c1sly0SReer4m1UAoArgTAux+VaHGi6lUfX63r/1zcs3HANTg+L72yzK
        XB8aP1jQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgrTA-00AFgT-4D
        for netfilter-devel@vger.kernel.org; Sat, 30 Oct 2021 17:44:36 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 16/26] output: DBI: fix deprecation warnings.
Date:   Sat, 30 Oct 2021 17:44:22 +0100
Message-Id: <20211030164432.1140896-17-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211030164432.1140896-1-jeremy@azazel.net>
References: <20211030164432.1140896-1-jeremy@azazel.net>
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

