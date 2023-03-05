Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2AD7C6FA8E
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Mar 2023 10:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjCEKaH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Mar 2023 05:30:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjCEKaG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Mar 2023 05:30:06 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE80CDFF
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Mar 2023 02:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IDH7mdRQXnt60IONd6+Tu7cSAGQgeBx9E/LMAK1zgF4=; b=GLOLS9DrFAmNH34wbau+CFIqos
        Q9gVAm694KGO8oEjWYSBDLA6kY3tdodMDbUZFTWwwqMhgSmRhi9RPfpM+Io8LdV+o5XKCHKTbeHxK
        n2z/CTW7wtH+iapFXEZRGiUKW7mNh7TvvhUNWUQ07SbIRQrNrqsnDdXsM0k1qFAxDjwH1JFZLogZk
        98yMmU7xMLe41BlPSQT2FRqYTwBCSUC9dbzpNPuHbLvBKwXxXt5RMFsA0eB+wy86zHYz4TQ6crlh1
        QH/x3e3dacUyvrFFKWeZy0Xh/UKTYHfXHES4BKUiedDBjdC68E0mUcKyjuclE4StLEHTAzxGiK010
        DQYLWgBw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pYlcv-00DzC0-BB
        for netfilter-devel@vger.kernel.org; Sun, 05 Mar 2023 10:30:01 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nftables 5/8] json: add support for shifted nat port-ranges
Date:   Sun,  5 Mar 2023 10:14:15 +0000
Message-Id: <20230305101418.2233910-6-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230305101418.2233910-1-jeremy@azazel.net>
References: <20230305101418.2233910-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/json.c        | 4 ++++
 src/parser_json.c | 8 ++++++++
 2 files changed, 12 insertions(+)

diff --git a/src/json.c b/src/json.c
index f15461d33894..f6874b94c7ec 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1407,6 +1407,10 @@ json_t *nat_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 		json_object_set_new(root, "port",
 				    expr_print_json(stmt->nat.proto, octx));
 
+	if (stmt->nat.proto_base)
+		json_object_set_new(root, "base_port",
+				    expr_print_json(stmt->nat.proto_base, octx));
+
 	nat_stmt_add_array(root, "flags", array);
 
 	if (stmt->nat.type_flags) {
diff --git a/src/parser_json.c b/src/parser_json.c
index d8d4f1b79e6e..fca9645c7e57 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2153,6 +2153,14 @@ static struct stmt *json_parse_nat_stmt(struct json_ctx *ctx,
 			return NULL;
 		}
 	}
+	if (!json_unpack(value, "{s:o}", "base_port", &tmp)) {
+		stmt->nat.proto_base = json_parse_stmt_expr(ctx, tmp);
+		if (!stmt->nat.proto) {
+			json_error(ctx, "Invalid nat base port.");
+			stmt_free(stmt);
+			return NULL;
+		}
+	}
 	if (!json_unpack(value, "{s:o}", "flags", &tmp)) {
 		int flags = json_parse_nat_flags(ctx, tmp);
 
-- 
2.39.2

