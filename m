Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2781C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:10:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB9FA60F38
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:10:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhJ3RNS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 13:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbhJ3RNR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 13:13:17 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BABC061570
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 10:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rl9Ng6/fsfB1HtYGDanNwYE8DCScCc3tLNQwZ+wqbzk=; b=j+3TGv4SDgYIhAsqqNslSXPtRx
        zpNh191zNtaHd3OahzPz0nRqzYSnDvWav4X6OsZKrhbBRnZ7wNB5nSzsC1Bc0SU2Z1phi0aIl20aA
        h7FIk44QBr0GrDkNxrfeS+EYLLRZtkJv548giYc7IJd98dtSNIv0N+AuGT4hwevbVqDJo4K7bJcKo
        wyW9Yr3I/h7FpZ+lRhhcmWDmLKi10KYZDfkoStpPItC0tYOGxbXPgdiBqpO8aCmcfF09PsLQe9vcP
        GwdY0lzntwgJOdwbJD/TmSKN6cHtKvw1rWivZTPWVn/WKiB5EEBkHjgSkWgPp4liUxWlRN7QcIm5O
        bF5fhCTg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgrTA-00AFgT-Rp
        for netfilter-devel@vger.kernel.org; Sat, 30 Oct 2021 17:44:36 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 22/26] util: db: fix possible string truncation.
Date:   Sat, 30 Oct 2021 17:44:28 +0100
Message-Id: <20211030164432.1140896-23-jeremy@azazel.net>
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

Correct buffer size to match that of key-name.

We can now replace strncpy with strcpy.

Don't start strchr from the beginning every time.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 util/db.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/util/db.c b/util/db.c
index f0711146867f..0f8eb7057436 100644
--- a/util/db.c
+++ b/util/db.c
@@ -10,7 +10,7 @@
  *           (C) 2008,2013 Eric Leblond <eric@regit.org>
  *
  *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2 
+ *  it under the terms of the GNU General Public License version 2
  *  as published by the Free Software Foundation
  *
  *  This program is distributed in the hope that it will be useful,
@@ -21,7 +21,7 @@
  *  You should have received a copy of the GNU General Public License
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- * 
+ *
  */
 
 #include <unistd.h>
@@ -96,8 +96,6 @@ static int sql_createstmt(struct ulogd_pluginstance *upi)
 	if (strncasecmp(procedure,"INSERT", strlen("INSERT")) == 0 &&
 	    (procedure[strlen("INSERT")] == '\0' ||
 			procedure[strlen("INSERT")] == ' ')) {
-		char buf[ULOGD_MAX_KEYLEN];
-		char *underscore;
 
 		if(procedure[6] == '\0') {
 			/* procedure == "INSERT" */
@@ -112,11 +110,13 @@ static int sql_createstmt(struct ulogd_pluginstance *upi)
 		stmt_val = mi->stmt + strlen(mi->stmt);
 
 		for (i = 0; i < upi->input.num_keys; i++) {
+			char buf[sizeof(upi->input.keys[0].name)], *underscore = buf;
+
 			if (upi->input.keys[i].flags & ULOGD_KEYF_INACTIVE)
 				continue;
 
-			strncpy(buf, upi->input.keys[i].name, ULOGD_MAX_KEYLEN);	
-			while ((underscore = strchr(buf, '.')))
+			strcpy(buf, upi->input.keys[i].name);
+			while ((underscore = strchr(underscore, '.')))
 				*underscore = '_';
 			sprintf(stmt_val, "%s,", buf);
 			stmt_val = mi->stmt + strlen(mi->stmt);
@@ -168,7 +168,7 @@ int ulogd_db_configure(struct ulogd_pluginstance *upi,
 	ret = di->driver->get_columns(upi);
 	if (ret < 0)
 		ulogd_log(ULOGD_ERROR, "error in get_columns\n");
-	
+
 	/* Close database, since ulogd core could just call configure
 	 * but abort during input key resolving routines.  configure
 	 * doesn't have a destructor... */
@@ -215,7 +215,7 @@ int ulogd_db_start(struct ulogd_pluginstance *upi)
 
 	if (di->ring.size > 0) {
 		/* allocate */
-		di->ring.ring = calloc(di->ring.size, sizeof(char) * di->ring.length);
+		di->ring.ring = calloc(di->ring.size, di->ring.length);
 		if (di->ring.ring == NULL) {
 			ret = -1;
 			goto db_error;
@@ -226,9 +226,8 @@ int ulogd_db_start(struct ulogd_pluginstance *upi)
 			  di->ring.size, di->ring.length);
 		/* init start of query for each element */
 		for(i = 0; i < di->ring.size; i++) {
-			strncpy(di->ring.ring + di->ring.length * i + 1,
-				di->stmt,
-				strlen(di->stmt));
+			strcpy(di->ring.ring + di->ring.length * i + 1,
+			       di->stmt);
 		}
 		/* init cond & mutex */
 		ret = pthread_cond_init(&di->ring.cond, NULL);
@@ -314,7 +313,7 @@ static int _init_reconnect(struct ulogd_pluginstance *upi)
 	/* Disable plugin permanently */
 	ulogd_log(ULOGD_ERROR, "permanently disabling plugin\n");
 	di->interp = &disabled_interp_db;
-	
+
 	return 0;
 }
 
-- 
2.33.0

