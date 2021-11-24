Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F209C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 22:25:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344301AbhKXW2I (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:28:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344015AbhKXW2B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 17:28:01 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA2CC061757
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 14:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9AaCwKhf/8WXt3aHXm5YHlqv+yrik9kN+c5wP1QrShY=; b=eCiJIBBSMwyHGI/5kGRJyg1oMh
        t2hIlwERnvRw9JU0DsTAQGMl19e/YoOxwldePgNvANkf0MJvmfx7qWCFvdhW5iqYiZXkw0crL4NoZ
        oCjy9AGXSwSiGlgJh5KqSQPIrHSnorIRrZUPld8dz5K9TpN6NXOY8pEfOg7FU+cYOCBnhz9PLKWn5
        oMQz0W3WDu/j4EqF5WDi7Ixo+lZXtxEArPgYlcndSb9ukVKR9R4pKWT46/wSE6b08friBKVjOZQ2Y
        mnyI+sH1tEcxsBKFbbEao5q1BnQqFOAwMPjLGTfe3laNNKGj/zIE1bIeFkMjGxKoQoZTe84SesRTK
        VSGz3OpA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mq0h6-00563U-Pf
        for netfilter-devel@vger.kernel.org; Wed, 24 Nov 2021 22:24:48 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 06/32] Replace malloc+memset with calloc
Date:   Wed, 24 Nov 2021 22:24:01 +0000
Message-Id: <20211124222444.2597311-7-jeremy@azazel.net>
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

There are a number of places where we `malloc` some memory and then
`memset` it to zero.  Use `calloc` instead.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/dbi/ulogd_output_DBI.c     | 6 +-----
 output/ipfix/ipfix.c              | 4 +---
 output/mysql/ulogd_output_MYSQL.c | 6 +-----
 output/pgsql/ulogd_output_PGSQL.c | 6 +-----
 src/ulogd.c                       | 3 +--
 5 files changed, 5 insertions(+), 20 deletions(-)

diff --git a/output/dbi/ulogd_output_DBI.c b/output/dbi/ulogd_output_DBI.c
index d2a968293314..23cc9c8fb492 100644
--- a/output/dbi/ulogd_output_DBI.c
+++ b/output/dbi/ulogd_output_DBI.c
@@ -129,8 +129,7 @@ static int get_columns_dbi(struct ulogd_pluginstance *upi)
 	upi->input.num_keys = dbi_result_get_numfields(pi->result);
 	ulogd_log(ULOGD_DEBUG, "%u fields in table\n", upi->input.num_keys);
 
-	upi->input.keys = malloc(sizeof(struct ulogd_key) *
-						upi->input.num_keys);
+	upi->input.keys = calloc(upi->input.num_keys, sizeof(*upi->input.keys));
 	if (!upi->input.keys) {
 		upi->input.num_keys = 0;
 		ulogd_log(ULOGD_ERROR, "ENOMEM\n");
@@ -138,9 +137,6 @@ static int get_columns_dbi(struct ulogd_pluginstance *upi)
 		return -ENOMEM;
 	}
 
-	memset(upi->input.keys, 0, sizeof(struct ulogd_key) *
-						upi->input.num_keys);
-
 	for (ui=1; ui<=upi->input.num_keys; ui++) {
 		char buf[ULOGD_MAX_KEYLEN+1];
 		char *underscore;
diff --git a/output/ipfix/ipfix.c b/output/ipfix/ipfix.c
index 4bb432a73d14..b2719fd1d8a3 100644
--- a/output/ipfix/ipfix.c
+++ b/output/ipfix/ipfix.c
@@ -85,8 +85,7 @@ struct ipfix_msg *ipfix_msg_alloc(size_t len, uint32_t oid, int tid)
 	    (len < IPFIX_HDRLEN + IPFIX_SET_HDRLEN))
 		return NULL;
 
-	msg = malloc(sizeof(struct ipfix_msg) + len);
-	memset(msg, 0, sizeof(struct ipfix_msg));
+	msg = calloc(1, sizeof(struct ipfix_msg) + len);
 	msg->tid = tid;
 	msg->end = msg->data + len;
 	msg->tail = msg->data + IPFIX_HDRLEN;
@@ -95,7 +94,6 @@ struct ipfix_msg *ipfix_msg_alloc(size_t len, uint32_t oid, int tid)
 
 	/* Initialize message header */
 	hdr = ipfix_msg_hdr(msg);
-	memset(hdr, 0, IPFIX_HDRLEN);
 	hdr->version = htons(IPFIX_VERSION);
 	hdr->oid = htonl(oid);
 
diff --git a/output/mysql/ulogd_output_MYSQL.c b/output/mysql/ulogd_output_MYSQL.c
index 643320ce724c..66151feb4939 100644
--- a/output/mysql/ulogd_output_MYSQL.c
+++ b/output/mysql/ulogd_output_MYSQL.c
@@ -127,16 +127,12 @@ static int get_columns_mysql(struct ulogd_pluginstance *upi)
 
 	upi->input.num_keys = mysql_num_fields(result);
 	ulogd_log(ULOGD_DEBUG, "%u fields in table\n", upi->input.num_keys);
-	upi->input.keys = malloc(sizeof(struct ulogd_key) * 
-						upi->input.num_keys);
+	upi->input.keys = calloc(upi->input.num_keys, sizeof(*upi->input.keys));
 	if (!upi->input.keys) {
 		upi->input.num_keys = 0;
 		ulogd_log(ULOGD_ERROR, "ENOMEM\n");
 		return -ENOMEM;
 	}
-	
-	memset(upi->input.keys, 0, sizeof(struct ulogd_key) *
-						upi->input.num_keys);
 
 	for (i = 0; (field = mysql_fetch_field(result)); i++) {
 		char buf[ULOGD_MAX_KEYLEN+1];
diff --git a/output/pgsql/ulogd_output_PGSQL.c b/output/pgsql/ulogd_output_PGSQL.c
index fda289eca776..f5a2823a7e1d 100644
--- a/output/pgsql/ulogd_output_PGSQL.c
+++ b/output/pgsql/ulogd_output_PGSQL.c
@@ -181,8 +181,7 @@ static int get_columns_pgsql(struct ulogd_pluginstance *upi)
 
 	upi->input.num_keys = PQntuples(pi->pgres);
 	ulogd_log(ULOGD_DEBUG, "%u fields in table\n", upi->input.num_keys);
-	upi->input.keys = malloc(sizeof(struct ulogd_key) *
-						upi->input.num_keys);
+	upi->input.keys = calloc(upi->input.num_keys, sizeof(*upi->input.keys));
 	if (!upi->input.keys) {
 		upi->input.num_keys = 0;
 		ulogd_log(ULOGD_ERROR, "ENOMEM\n");
@@ -190,9 +189,6 @@ static int get_columns_pgsql(struct ulogd_pluginstance *upi)
 		return -ENOMEM;
 	}
 
-	memset(upi->input.keys, 0, sizeof(struct ulogd_key) *
-						upi->input.num_keys);
-
 	for (i = 0; i < PQntuples(pi->pgres); i++) {
 		char buf[ULOGD_MAX_KEYLEN+1];
 		char *underscore;
diff --git a/src/ulogd.c b/src/ulogd.c
index 97da4fc0018f..b02f2602a895 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -661,12 +661,11 @@ pluginstance_alloc_init(struct ulogd_plugin *pl, char *pi_id,
 	}
 	size += pl->input.num_keys * sizeof(struct ulogd_key);
 	size += pl->output.num_keys * sizeof(struct ulogd_key);
-	pi = malloc(size);
+	pi = calloc(1, size);
 	if (!pi)
 		return NULL;
 
 	/* initialize */
-	memset(pi, 0, size);
 	INIT_LLIST_HEAD(&pi->list);
 	INIT_LLIST_HEAD(&pi->plist);
 	pi->plugin = pl;
-- 
2.33.0

