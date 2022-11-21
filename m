Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB96CC4321E
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Nov 2022 22:27:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbiKUW1o (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 17:27:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbiKUW1k (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 17:27:40 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38FB8F5B9
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2022 14:27:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jG4vU6x+Lbbsbc2n/bNmUM7B/fewdV/zv7RDoVEpwso=; b=kcJz2TWWQMTvZsPA2d7IJKaXWF
        H709T9Empjz0FEbsKfx/aIS37KaX/7GMLKTBxKglrQzWIFDLYZsIghQBvS2zEg32hbqRLrz9swqqo
        ozM4dRffhhWN3I2UM3PtFashlOReqTdjEupTARlgc9hNyuiE0w/dE/4rJ88IhsuFyC9DBGgnBtn8u
        IrSf84qSiMWHrjzrjvmJ+aqKXK0mUskaDQLE0znMZUyu5t3gPapdCm+t9GLyb7db3nkNOoo2aqvw4
        49fIuZ4tyLlFqH9KZFL92j0Hy7lZXozg40VMJgiTflIwZuSUQwTlUueyZSP2QcPC6KcWeeDOson0J
        OdGJKc3A==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oxFGC-005LgP-Ab
        for netfilter-devel@vger.kernel.org; Mon, 21 Nov 2022 22:27:28 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 04/34] db: fix back-log capacity checks
Date:   Mon, 21 Nov 2022 22:25:41 +0000
Message-Id: <20221121222611.3914559-5-jeremy@azazel.net>
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

Previously, when adding queries to the back-log, the memory usage is
incremented and decremented by the size of the query structure and the
length of the SQL statement, `sizeof(struct db_stmt) + len`.  However,
when checking whether there was available capacity to add a new query,
the struct size was ignored.  Amend the check to include the struct
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

