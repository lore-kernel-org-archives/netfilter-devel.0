Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8795C433FE
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Nov 2022 22:57:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbiKUW5F (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 17:57:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiKUW5E (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 17:57:04 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A63FDC72EF
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2022 14:57:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1jVGbrRA2hFfo2dFiRcu920YM47p+i601W6q6pCoRnw=; b=BOk7+rlf824rfaAtrrTd/dOXVs
        OmTnhkArZ5xB0gqECeuRfZSISVRWcSXWsQyPBT05WZNNEPMj80AX9Q6Yqj+77jt+FHrKCpRRz6Tkm
        aoMf5/UL+NgcR6IqQJ5KOEw/tS3N/KIONITu/y9hCcdYqjZBcgmBRfvZccoelVhJlp35xdb2mBr9s
        oxSYLAgsHK1vfgHI0be8kEYRTAdlP4oIZnujv5XK9BhPErdaKJ+ZdUgL8qZVauX2omTRypKamrkZs
        6tKr1zHsD+lElZGOdmBPdg7ruNDDrI34CT1qMmsGIgkIp55LJOeAXgovrZ8koXzveQmBrzrxKlFE9
        B/hEEmsw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oxFGD-005LgP-7L
        for netfilter-devel@vger.kernel.org; Mon, 21 Nov 2022 22:27:29 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 11/34] src: remove superfluous casts
Date:   Mon, 21 Nov 2022 22:25:48 +0000
Message-Id: <20221121222611.3914559-12-jeremy@azazel.net>
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

We're not writing C++, we don't need to cast void pointers.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 cftest/cftest.c       | 2 +-
 libipulog/libipulog.c | 2 +-
 libipulog/ulog_test.c | 2 +-
 src/conffile.c        | 2 +-
 src/hash.c            | 4 ++--
 src/ulogd.c           | 2 +-
 util/db.c             | 4 ++--
 7 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/cftest/cftest.c b/cftest/cftest.c
index b99882be5840..b16e75a5a451 100644
--- a/cftest/cftest.c
+++ b/cftest/cftest.c
@@ -19,7 +19,7 @@ int main()
 	strcpy(f.key, "spalte");
 	f.type = CONFIG_TYPE_STRING;
 	f.options |= CONFIG_OPT_MANDATORY;
-	f.u.str.string = (char *) malloc(100);
+	f.u.str.string = malloc(100);
 	f.u.str.maxlen = 99;
 	config_register_key(&f);
 
diff --git a/libipulog/libipulog.c b/libipulog/libipulog.c
index b49f7f2cbd79..371c0d7622d6 100644
--- a/libipulog/libipulog.c
+++ b/libipulog/libipulog.c
@@ -129,7 +129,7 @@ struct ipulog_handle *ipulog_create_handle(uint32_t gmask,
 	struct ipulog_handle *h;
 	int status;
 
-	h = (struct ipulog_handle *) malloc(sizeof(struct ipulog_handle));
+	h = malloc(sizeof(*h));
 	if (h == NULL)
 	{
 		ipulog_errno = IPULOG_ERR_HANDLE;
diff --git a/libipulog/ulog_test.c b/libipulog/ulog_test.c
index 06657172a0cd..6b796d064992 100644
--- a/libipulog/ulog_test.c
+++ b/libipulog/ulog_test.c
@@ -51,7 +51,7 @@ int main(int argc, char *argv[])
 	}
 
 	/* allocate a receive buffer */
-	buf = (unsigned char *) malloc(MYBUFSIZ);
+	buf = malloc(MYBUFSIZ);
 	
 	/* create ipulog handle */
 	h = ipulog_create_handle(ipulog_group2gmask(atoi(argv[2])));
diff --git a/src/conffile.c b/src/conffile.c
index 66769decc93c..8a208d6d8cfe 100644
--- a/src/conffile.c
+++ b/src/conffile.c
@@ -104,7 +104,7 @@ int config_register_file(const char *file)
 
 	pr_debug("%s: registered config file '%s'\n", __func__, file);
 
-	fname = (char *) malloc(strlen(file)+1);
+	fname = malloc(strlen(file)+1);
 	if (!fname)
 		return -ERROOM;
 
diff --git a/src/hash.c b/src/hash.c
index 1d991309734f..2f7f5deebece 100644
--- a/src/hash.c
+++ b/src/hash.c
@@ -34,9 +34,9 @@ hashtable_create(int hashsize, int limit,
 	int i;
 	struct hashtable *h;
 	int size = sizeof(struct hashtable)
-		   + hashsize * sizeof(struct llist_head);
+		 + sizeof(struct llist_head) * hashsize;
 
-	h = (struct hashtable *) calloc(size, 1);
+	h = calloc(size, 1);
 	if (h == NULL) {
 		errno = ENOMEM;
 		return NULL;
diff --git a/src/ulogd.c b/src/ulogd.c
index ec0745e63169..82f936168ebc 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -720,7 +720,7 @@ static int load_plugin(const char *file)
 		return -1;
 	}
 
-	ph = (struct ulogd_plugin_handle *) calloc(1, sizeof(*ph));
+	ph = calloc(1, sizeof(*ph));
 	ph->handle = handle;
 	llist_add(&ph->list, &ulogd_plugins_handle);
 	return 0;
diff --git a/util/db.c b/util/db.c
index fb41266648d5..6749079697dc 100644
--- a/util/db.c
+++ b/util/db.c
@@ -85,7 +85,7 @@ static int sql_createstmt(struct ulogd_pluginstance *upi)
 
 	ulogd_log(ULOGD_DEBUG, "allocating %u bytes for statement\n", size);
 
-	mi->stmt = (char *) malloc(size);
+	mi->stmt = malloc(size);
 	if (!mi->stmt) {
 		ulogd_log(ULOGD_ERROR, "OOM!\n");
 		return -ENOMEM;
@@ -575,7 +575,7 @@ static int __loop_reconnect_db(struct ulogd_pluginstance * upi) {
 
 static void *__inject_thread(void *gdi)
 {
-	struct ulogd_pluginstance *upi = (struct ulogd_pluginstance *) gdi;
+	struct ulogd_pluginstance *upi = gdi;
 	struct db_instance *di = (struct db_instance *) &upi->private;
 	char *wr_place;
 
-- 
2.35.1

