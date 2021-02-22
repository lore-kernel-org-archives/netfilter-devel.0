Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D76D6C433E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Feb 2021 20:54:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A6A764E25
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Feb 2021 20:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhBVUyQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Feb 2021 15:54:16 -0500
Received: from correo.us.es ([193.147.175.20]:44796 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229934AbhBVUyP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Feb 2021 15:54:15 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 14E97B4977
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Feb 2021 21:53:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 01C41DA72F
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Feb 2021 21:53:29 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EA9DBDA722; Mon, 22 Feb 2021 21:53:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 766D1DA730
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Feb 2021 21:53:26 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 22 Feb 2021 21:53:26 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 61A2B42DF560
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Feb 2021 21:53:26 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] table: rework flags printing
Date:   Mon, 22 Feb 2021 21:53:23 +0100
Message-Id: <20210222205323.22189-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Simplify routine to print the table flags. Add table_flag_name() and use
it from json too.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h |  2 +-
 src/json.c     |  2 +-
 src/rule.c     | 37 ++++++++++++++++++++++++-------------
 3 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 330a09aa77fa..87b6828edca4 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -134,7 +134,7 @@ enum table_flags {
 };
 #define TABLE_FLAGS_MAX 1
 
-extern const char *table_flags_name[TABLE_FLAGS_MAX];
+const char *table_flag_name(uint32_t flag);
 
 /**
  * struct table - nftables table
diff --git a/src/json.c b/src/json.c
index 0ccbbe8a75d2..defbc8fb44df 100644
--- a/src/json.c
+++ b/src/json.c
@@ -444,7 +444,7 @@ static json_t *table_flags_json(const struct table *table)
 
 	while (flags) {
 		if (flags & 0x1) {
-			tmp = json_string(table_flags_name[i]);
+			tmp = json_string(table_flag_name(i));
 			json_array_append_new(root, tmp);
 		}
 		flags >>= 1;
diff --git a/src/rule.c b/src/rule.c
index e4bb6bae276a..d22ab5009790 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1405,29 +1405,40 @@ struct table *table_lookup_fuzzy(const struct handle *h,
 	return st.obj;
 }
 
-const char *table_flags_name[TABLE_FLAGS_MAX] = {
+static const char *table_flags_name[TABLE_FLAGS_MAX] = {
 	"dormant",
 };
 
-static void table_print_options(const struct table *table, const char **delim,
-				struct output_ctx *octx)
+const char *table_flag_name(uint32_t flag)
+{
+	if (flag >= TABLE_FLAGS_MAX)
+		return "unknown";
+
+	return table_flags_name[flag];
+}
+
+static void table_print_flags(const struct table *table, const char **delim,
+			      struct output_ctx *octx)
 {
 	uint32_t flags = table->flags;
+	bool comma = false;
 	int i;
 
-	if (flags) {
-		nft_print(octx, "\tflags ");
+	if (!table->flags)
+		return;
 
-		for (i = 0; i < TABLE_FLAGS_MAX; i++) {
-			if (flags & 0x1)
-				nft_print(octx, "%s", table_flags_name[i]);
-			flags >>= 1;
-			if (flags)
+	nft_print(octx, "\tflags ");
+	for (i = 0; i < TABLE_FLAGS_MAX; i++) {
+		if (flags & (1 << i)) {
+			if (comma)
 				nft_print(octx, ",");
+
+			nft_print(octx, "%s", table_flag_name(i));
+			comma = true;
 		}
-		nft_print(octx, "\n");
-		*delim = "\n";
 	}
+	nft_print(octx, "\n");
+	*delim = "\n";
 }
 
 static void table_print(const struct table *table, struct output_ctx *octx)
@@ -1443,7 +1454,7 @@ static void table_print(const struct table *table, struct output_ctx *octx)
 	if (nft_output_handle(octx))
 		nft_print(octx, " # handle %" PRIu64, table->handle.handle.id);
 	nft_print(octx, "\n");
-	table_print_options(table, &delim, octx);
+	table_print_flags(table, &delim, octx);
 
 	if (table->comment)
 		nft_print(octx, "\tcomment \"%s\"\n", table->comment);
-- 
2.20.1

