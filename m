Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66E6BC352A1
	for <netfilter-devel@archiver.kernel.org>; Sat,  3 Dec 2022 19:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbiLCTCY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 3 Dec 2022 14:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiLCTCW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 3 Dec 2022 14:02:22 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD6191C929
        for <netfilter-devel@vger.kernel.org>; Sat,  3 Dec 2022 11:02:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OZ8e+NfGIm89uhtC7dDlw7sTS4HAvDeXqkPebhXim/I=; b=omQL7PG55OWAwhIPMWN7x3OsK0
        3EOse7KzbWBqB9F3X6cO0V6rtGtUuR50Olf6gDUxgQvPn/7sSwGeUoc/6OtQmvhRs5TViC8arRbOk
        C/JLXXNvJpGxrq+29vqPo4VfybXjqpGfDrARJ7OLKFk+jxSdBo+h/5iRLA8BoFnWJGUY+nAntyEOr
        F/7ojuRJTGD4tY75/LTR1D/Ws3qf241xeytBILJ1rjCmbpuD9qHvZoJf57G2MOvPtXL5e/87lnvis
        5m/yDJUw9q1PD7XtP9/uqHobUdVAGFqiJ+H0yfvxjQQOsrOrQ/lpfMi/Lj3EdEv8RvugUDngAa6AH
        OCbP/nUQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1p1XmE-000B5v-NT
        for netfilter-devel@vger.kernel.org; Sat, 03 Dec 2022 19:02:18 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 4/4] db: fix back-log capacity checks
Date:   Sat,  3 Dec 2022 19:02:12 +0000
Message-Id: <20221203190212.346490-5-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221203190212.346490-1-jeremy@azazel.net>
References: <20221203190212.346490-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hitherto, when adding queries to the back-log, the memory usage has been
incremented and decremented by the size of the query structure and the
length of the SQL statement, `sizeof(struct db_stmt) + len`.  However,
when checking whether there is available capacity to add a new query,
the struct size has been ignored.  Amend the check to include the struct
size, and also account for the NUL that terminates the SQL.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 util/db.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/util/db.c b/util/db.c
index c1d24365239f..ebd9f152ed83 100644
--- a/util/db.c
+++ b/util/db.c
@@ -404,14 +404,17 @@ static void __format_query_db(struct ulogd_pluginstance *upi, char *start)
 static int __add_to_backlog(struct ulogd_pluginstance *upi, const char *stmt, unsigned int len)
 {
 	struct db_instance *di = (struct db_instance *) &upi->private;
+	unsigned int query_size;
 	struct db_stmt *query;
 
 	/* check if we are using backlog */
 	if (di->backlog_memcap == 0)
 		return 0;
 
+	query_size = sizeof(*query) + len + 1;
+
 	/* check len against backlog */
-	if (len + di->backlog_memusage > di->backlog_memcap) {
+	if (query_size + di->backlog_memcap - di->backlog_memusage) {
 		if (di->backlog_full == 0)
 			ulogd_log(ULOGD_ERROR,
 				  "Backlog is full starting to reject events.\n");
@@ -419,7 +422,7 @@ static int __add_to_backlog(struct ulogd_pluginstance *upi, const char *stmt, un
 		return -1;
 	}
 
-	query = malloc(sizeof(struct db_stmt));
+	query = malloc(sizeof(*query));
 	if (query == NULL)
 		return -1;
 
@@ -431,7 +434,7 @@ static int __add_to_backlog(struct ulogd_pluginstance *upi, const char *stmt, un
 		return -1;
 	}
 
-	di->backlog_memusage += len + sizeof(struct db_stmt);
+	di->backlog_memusage += query_size;
 	di->backlog_full = 0;
 
 	llist_add_tail(&query->list, &di->backlog);
@@ -489,7 +492,7 @@ static int __treat_backlog(struct ulogd_pluginstance *upi)
 			di->driver->close_db(upi);
 			return _init_reconnect(upi);
 		} else {
-			di->backlog_memusage -= query->len + sizeof(struct db_stmt);
+			di->backlog_memusage -= sizeof(*query) + query->len + 1;
 			llist_del(&query->list);
 			free(query->stmt);
 			free(query);
-- 
2.35.1

