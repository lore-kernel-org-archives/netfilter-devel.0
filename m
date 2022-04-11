Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E631C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Apr 2022 08:17:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343658AbiDKIT0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Apr 2022 04:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343647AbiDKITW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Apr 2022 04:19:22 -0400
X-Greylist: delayed 509 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 11 Apr 2022 01:17:07 PDT
Received: from mxout01.bytecamp.net (mxout01.bytecamp.net [212.204.60.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C272A33A05
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Apr 2022 01:17:07 -0700 (PDT)
Received: by mxout01.bytecamp.net (Postfix, from userid 1001)
        id 6B4B82F7AC; Mon, 11 Apr 2022 10:08:36 +0200 (CEST)
Received: from mail.bytecamp.net (mail.bytecamp.net [212.204.60.9])
        by mxout01.bytecamp.net (Postfix) with ESMTP id 2F1C92F7AA
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Apr 2022 10:08:36 +0200 (CEST)
Received: (qmail 67755 invoked from network); 11 Apr 2022 10:08:36 +0200
Received: from unknown (HELO j7.lan) (jo%wwsnet.net@77.22.166.48)
  by mail.bytecamp.net with ESMTPS (DHE-RSA-AES256-GCM-SHA384 encrypted); 11 Apr 2022 10:08:36 +0200
From:   Jo-Philipp Wich <jo@mein.io>
To:     netfilter-devel@vger.kernel.org
Cc:     Jo-Philipp Wich <jo@mein.io>
Subject: [RFC PATCH] datatype: accept abbrevs and ignore case on parsing symbolic constants
Date:   Mon, 11 Apr 2022 10:08:22 +0200
Message-Id: <20220411080822.1801117-1-jo@mein.io>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently nftables does not accept abbreviated or lowercased weekday
names as claimed in the nftables wiki [1]. This is due to the fact that
symbolic_constant_parse() performs a strict equality check of the given
constant value against the list of potential choices.

In order to implement the behaviour described by the wiki - which seems
useful and intuitive in general - adjust the constant parsing function
to to perform a case-insensitive prefix match of the user supplied value
against the choice list.

The modified code does not check uniqueness of the prefix value, it will
simply return the first matching item, but it will ensure to reject an
empty string value.

1: https://wiki.nftables.org/wiki-nftables/index.php/Matching_packet_metainformation#Matching_by_time

Signed-off-by: Jo-Philipp Wich <jo@mein.io>
---
 src/datatype.c              |  5 +++--
 tests/py/any/meta.t         |  4 ++++
 tests/py/any/meta.t.payload | 18 ++++++++++++++++++
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index 2e31c858..ce4a8aa8 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -149,9 +149,10 @@ struct error_record *symbolic_constant_parse(struct parse_ctx *ctx,
 	const struct symbolic_constant *s;
 	const struct datatype *dtype;
 	struct error_record *erec;
+	size_t idlen;
 
-	for (s = tbl->symbols; s->identifier != NULL; s++) {
-		if (!strcmp(sym->identifier, s->identifier))
+	for (s = tbl->symbols, idlen = strlen(sym->identifier); s->identifier != NULL; s++) {
+		if (idlen > 0 && !strncasecmp(sym->identifier, s->identifier, idlen))
 			break;
 	}
 
diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index 12fabb79..4f130e7d 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -212,7 +212,11 @@ meta time < "2022-07-01 11:00:00" accept;ok
 meta time > "2022-07-01 11:00:00" accept;ok
 meta day "Saturday" drop;ok
 meta day 6 drop;ok;meta day "Saturday" drop
+meta day "saturday" drop;ok;meta day "Saturday" drop
+meta day "Sat" drop;ok;meta day "Saturday" drop
+meta day "sat" drop;ok;meta day "Saturday" drop
 meta day "Satturday" drop;fail
+meta day "" drop;fail
 meta hour "17:00" drop;ok
 meta hour "17:00:00" drop;ok;meta hour "17:00" drop
 meta hour "17:00:01" drop;ok
diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
index 16dc1211..b43c43c4 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -1023,6 +1023,24 @@ ip test-ip4 input
   [ cmp eq reg 1 0x00000006 ]
   [ immediate reg 0 drop ]
 
+# meta day "saturday" drop
+ip test-ip4 input
+  [ meta load day => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ immediate reg 0 drop ]
+
+# meta day "Sat" drop
+ip test-ip4 input
+  [ meta load day => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ immediate reg 0 drop ]
+
+# meta day "sat" drop
+ip test-ip4 input
+  [ meta load day => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ immediate reg 0 drop ]
+
 # meta day 6 drop
 ip test-ip4 input
   [ meta load day => reg 1 ]
-- 
2.35.1

