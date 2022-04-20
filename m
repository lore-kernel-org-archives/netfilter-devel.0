Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2D0FC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Apr 2022 18:55:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346926AbiDTS6C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Apr 2022 14:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346847AbiDTS6B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Apr 2022 14:58:01 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBAA21E39
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Apr 2022 11:55:14 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id w5so3003097lji.4
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Apr 2022 11:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j5ZSOiWm0m0H2PpjC4dUux6GZf2hFFs4GBWKQJatK2M=;
        b=qSHL/wTBVZGj63cPCv8Kef5NZFj9PdI6FsXwAUPNGZbi1gkQCX7V7BGcuRLgD/H0hT
         NbpObKhVlQP3LrGTxbPR4muRBAYFfHASpzZdr1nkMxPVuZ95wxy2beyLU8ZB4VJsXS26
         oAgqctgpy/h7j+UPoX16muN/Q0qpTla4hfDb4K2ngVgt1f06zYYOIlSUj1Uyr+M1jMqk
         BHhlhVs6dcsWQRR8EcTsYDxeTJBbobMll27pEgv7k+RYkLd1JsW8HGrkJ5d/Wqt/KmEk
         y6pfDMGMx0Z4hN8N2d9QnE+NuVL6a9nuG2+C5rLnzjJmzna4NO63Zc8bVsxiPDvfRH6l
         Q86A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j5ZSOiWm0m0H2PpjC4dUux6GZf2hFFs4GBWKQJatK2M=;
        b=m36kpfmVAzE7uD3JhAzVOVk8ILQyeOdtNq9RCtdJXSWIgHbH5kWYT9AFVvtAT5WVJS
         HLlWWJMXYXiwMQoHS9RrXzgNAAyhDhHv+UJYKR5xvWdkF4gKN/gyt9zzTTqaOkv0KC6d
         wzURGpZv+rFJV5O/NeuuYzTi9SC9lAf/ktLkJ2w01iIEaTUktuYAYW7Thx/JNtNwHx6G
         yCsd10CLMjD+viYIFJGueViNXhw6B3LGQnUvvxQ+VtS5QB2ieOzAIu8YC+YJdsco5jpZ
         0iTwis+YOwUlEYd+oYwXU8rdL8KVzhzKNv7niOpUDdisZn2dqY0mx/6Ya6Nb5RGqmO4Y
         G66w==
X-Gm-Message-State: AOAM532/cZM1clQq+miaasCOgC//PT7e1KJuTixA+occXVasVnowsx8f
        Y2SGpueLejrTqRY1O9p8lqVN6mGLBeCdkQ==
X-Google-Smtp-Source: ABdhPJzA1KkUwOrcXjekMGWjuPM18upgvCeD6tZ0w+Zfr630pl49u8ppxh7/zMsG+FOPVedFFmuVFA==
X-Received: by 2002:a2e:bd09:0:b0:24b:9e3:30c6 with SMTP id n9-20020a2ebd09000000b0024b09e330c6mr13905058ljq.282.1650480912135;
        Wed, 20 Apr 2022 11:55:12 -0700 (PDT)
Received: from localhost.localdomain (91-159-150-194.elisa-laajakaista.fi. [91.159.150.194])
        by smtp.gmail.com with ESMTPSA id m1-20020a05651202e100b0046cd451b8easm1908108lfq.22.2022.04.20.11.55.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 11:55:11 -0700 (PDT)
From:   Topi Miettinen <toiwoton@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Topi Miettinen <toiwoton@gmail.com>
Subject: [PATCH] socket gid and socket uid
Date:   Wed, 20 Apr 2022 21:55:07 +0300
Message-Id: <20220420185507.10218-1-toiwoton@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add socket expressions for checking GID or UID of the originating
socket. These work also on input side, unlike meta skuid/skgid.

Signed-off-by: Topi Miettinen <toiwoton@gmail.com>
---
 doc/primary-expression.txt          |  8 +++++++-
 include/linux/netfilter/nf_tables.h |  4 ++++
 src/parser_bison.y                  |  4 ++++
 src/parser_json.c                   |  4 ++++
 src/scanner.l                       |  2 ++
 src/socket.c                        | 12 ++++++++++++
 6 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/doc/primary-expression.txt b/doc/primary-expression.txt
index f97778b9..70991208 100644
--- a/doc/primary-expression.txt
+++ b/doc/primary-expression.txt
@@ -195,7 +195,7 @@ raw prerouting meta ipsec exists accept
 SOCKET EXPRESSION
 ~~~~~~~~~~~~~~~~~
 [verse]
-*socket* {*transparent* | *mark* | *wildcard*}
+*socket* {*transparent* | *mark* | *wildcard* | *gid* | *uid* }
 *socket* *cgroupv2* *level* 'NUM'
 
 Socket expression can be used to search for an existing open TCP/UDP socket and
@@ -219,6 +219,12 @@ boolean (1 bit)
 |cgroupv2|
 cgroup version 2 for this socket (path from /sys/fs/cgroup)|
 cgroupv2
+|gid|
+GID associated with originating socket|
+gid
+|uid|
+UID associated with originating socket|
+uid
 |==================
 
 .Using socket expression
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 75df968d..ba0415e5 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1029,12 +1029,16 @@ enum nft_socket_attributes {
  * @NFT_SOCKET_TRANSPARENT: Value of the IP(V6)_TRANSPARENT socket option
  * @NFT_SOCKET_MARK: Value of the socket mark
  * @NFT_SOCKET_WILDCARD: Whether the socket is zero-bound (e.g. 0.0.0.0 or ::0)
+ * @NFT_SOCKET_GID: Match on GID of socket owner
+ * @NFT_SOCKET_GID: Match on UID of socket owner
  */
 enum nft_socket_keys {
 	NFT_SOCKET_TRANSPARENT,
 	NFT_SOCKET_MARK,
 	NFT_SOCKET_WILDCARD,
 	NFT_SOCKET_CGROUPV2,
+	NFT_SOCKET_GID,
+	NFT_SOCKET_UID,
 	__NFT_SOCKET_MAX
 };
 #define NFT_SOCKET_MAX	(__NFT_SOCKET_MAX - 1)
diff --git a/src/parser_bison.y b/src/parser_bison.y
index ca5c488c..7ad5d8dc 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -232,6 +232,8 @@ int nft_lex(void *, void *, void *);
 %token TRANSPARENT		"transparent"
 %token WILDCARD			"wildcard"
 %token CGROUPV2			"cgroupv2"
+%token GID			"gid"
+%token UID			"uid"
 
 %token TPROXY			"tproxy"
 
@@ -5046,6 +5048,8 @@ socket_expr		:	SOCKET	socket_key	close_scope_socket
 socket_key 		: 	TRANSPARENT	{ $$ = NFT_SOCKET_TRANSPARENT; }
 			|	MARK		{ $$ = NFT_SOCKET_MARK; }
 			|	WILDCARD	{ $$ = NFT_SOCKET_WILDCARD; }
+			|	GID		{ $$ = NFT_SOCKET_GID; }
+			|	UID		{ $$ = NFT_SOCKET_UID; }
 			;
 
 offset_opt		:	/* empty */	{ $$ = 0; }
diff --git a/src/parser_json.c b/src/parser_json.c
index fb401009..a69d695a 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -421,6 +421,10 @@ static struct expr *json_parse_socket_expr(struct json_ctx *ctx,
 		keyval = NFT_SOCKET_MARK;
 	else if (!strcmp(key, "wildcard"))
 		keyval = NFT_SOCKET_WILDCARD;
+	else if (!strcmp(key, "gid"))
+		keyval = NFT_SOCKET_GID;
+	else if (!strcmp(key, "uid"))
+		keyval = NFT_SOCKET_UID;
 
 	if (keyval == -1) {
 		json_error(ctx, "Invalid socket key value.");
diff --git a/src/scanner.l b/src/scanner.l
index 2154281e..bd2841af 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -330,6 +330,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"wildcard"		{ return WILDCARD; }
 	"cgroupv2"		{ return CGROUPV2; }
 	"level"			{ return LEVEL; }
+	"gid"			{ return GID; }
+	"uid"			{ return UID; }
 }
 "tproxy"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_TPROXY); return TPROXY; }
 
diff --git a/src/socket.c b/src/socket.c
index eb075153..7cfdd066 100644
--- a/src/socket.c
+++ b/src/socket.c
@@ -38,6 +38,18 @@ const struct socket_template socket_templates[] = {
 		.len		= 8 * BITS_PER_BYTE,
 		.byteorder	= BYTEORDER_HOST_ENDIAN,
 	},
+	[NFT_SOCKET_GID] = {
+		.token		= "gid",
+		.dtype		= &gid_type,
+		.len		= 4 * BITS_PER_BYTE,
+		.byteorder	= BYTEORDER_HOST_ENDIAN,
+	},
+	[NFT_SOCKET_UID] = {
+		.token		= "uid",
+		.dtype		= &uid_type,
+		.len		= 4 * BITS_PER_BYTE,
+		.byteorder	= BYTEORDER_HOST_ENDIAN,
+	},
 };
 
 static void socket_expr_print(const struct expr *expr, struct output_ctx *octx)

base-commit: d1289bff58e1878c3162f574c603da993e29b113
-- 
2.35.1

