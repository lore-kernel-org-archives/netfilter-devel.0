Return-Path: <SRS0=l6lg=33=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1B0AC352A2
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Feb 2020 11:43:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBBE120720
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Feb 2020 11:43:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbgBGLnX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Feb 2020 06:43:23 -0500
Received: from a3.inai.de ([88.198.85.195]:36640 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726897AbgBGLnX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Feb 2020 06:43:23 -0500
Received: by a3.inai.de (Postfix, from userid 65534)
        id AF4A15872B9CB; Fri,  7 Feb 2020 12:43:21 +0100 (CET)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id 3910E58728700;
        Fri,  7 Feb 2020 12:43:21 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: compute mnemonic port name much easier
Date:   Fri,  7 Feb 2020 12:43:21 +0100
Message-Id: <20200207114321.29709-1-jengelh@inai.de>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 src/datatype.c | 34 ++++++----------------------------
 src/json.c     | 20 +++++---------------
 2 files changed, 11 insertions(+), 43 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index 189e1b48..e4ef51e8 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -657,34 +657,12 @@ const struct datatype inet_protocol_type = {
 
 static void inet_service_print(const struct expr *expr, struct output_ctx *octx)
 {
-	struct sockaddr_in sin = { .sin_family = AF_INET };
-	char buf[NI_MAXSERV];
-	uint16_t port;
-	int err;
-
-	sin.sin_port = mpz_get_be16(expr->value);
-	err = getnameinfo((struct sockaddr *)&sin, sizeof(sin), NULL, 0,
-			  buf, sizeof(buf), 0);
-	if (err != 0) {
-		nft_print(octx, "%u", ntohs(sin.sin_port));
-		return;
-	}
-	port = atoi(buf);
-	/* We got a TCP service name string, display it... */
-	if (htons(port) != sin.sin_port) {
-		nft_print(octx, "\"%s\"", buf);
-		return;
-	}
-
-	/* ...otherwise, this might be a UDP service name. */
-	err = getnameinfo((struct sockaddr *)&sin, sizeof(sin), NULL, 0,
-			  buf, sizeof(buf), NI_DGRAM);
-	if (err != 0) {
-		/* No service name, display numeric value. */
-		nft_print(octx, "%u", ntohs(sin.sin_port));
-		return;
-	}
-	nft_print(octx, "\"%s\"", buf);
+	uint16_t port = mpz_get_be16(expr->value);
+	const struct servent *s = getservbyport(port, NULL);
+	if (s == NULL)
+		nft_print(octx, "%hu", ntohs(port));
+	else
+		nft_print(octx, "\"%s\"", s->s_name);
 }
 
 void inet_service_type_print(const struct expr *expr, struct output_ctx *octx)
diff --git a/src/json.c b/src/json.c
index 1906e7db..7be13e6e 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1021,23 +1021,13 @@ json_t *inet_protocol_type_json(const struct expr *expr,
 
 json_t *inet_service_type_json(const struct expr *expr, struct output_ctx *octx)
 {
-	struct sockaddr_in sin = {
-		.sin_family = AF_INET,
-		.sin_port = mpz_get_be16(expr->value),
-	};
-	char buf[NI_MAXSERV];
+	uint16_t port = mpz_get_be16(expr->value);
+	const struct servent *s = NULL;
 
 	if (!nft_output_service(octx) ||
-	    getnameinfo((struct sockaddr *)&sin, sizeof(sin),
-		        NULL, 0, buf, sizeof(buf), 0))
-		return json_integer(ntohs(sin.sin_port));
-
-	if (htons(atoi(buf)) == sin.sin_port ||
-	    getnameinfo((struct sockaddr *)&sin, sizeof(sin),
-			NULL, 0, buf, sizeof(buf), NI_DGRAM))
-		return json_integer(ntohs(sin.sin_port));
-
-	return json_string(buf);
+	    (s = getservbyport(port, NULL)) == NULL)
+		return json_integer(ntohs(port));
+	return json_string(s->s_name);
 }
 
 json_t *mark_type_json(const struct expr *expr, struct output_ctx *octx)
-- 
2.25.0

