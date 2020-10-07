Return-Path: <SRS0=fUKQ=DO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4DC4C4363D
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Oct 2020 14:03:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 474FE205F4
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Oct 2020 14:03:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tib/o6a5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgJGODv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Oct 2020 10:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728469AbgJGODv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Oct 2020 10:03:51 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70B2C061755
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Oct 2020 07:03:51 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id h2so1040603pll.11
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Oct 2020 07:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=h3ZAonb118O0d/Lcv9VCRzcfU78H6+ewqmcz0JFfLkg=;
        b=Tib/o6a5DO/+ZVc34OUGyVGHihjV2a/0R2AWl84iaQq22TunfSmrmWtUx0T2ZllR4r
         9ItMetAkTUaSxsRshpneGitsL7nFBzXWExT8mUS6990Gp6lAPcvwYHrGDfbUPnlsCzLN
         Pq3FBd4RYBdrX4B6csiNF9P9QA7aWTi38urroLhDbUyanFKjvkpsYSBrH9K+hvqiVlvK
         x0juVLqIjPJvGHqGu+25neGsSqxVCwZztm65v3OP2DQCNjWkUedzFEui9b8Xh0b4X7gm
         bAKxIPLhpYNqzx4Eu9YaMXZRu5P8XG+2sEC0MX3F+NO8ZWw8X7HGkwBXaVZX/A7KKJ7j
         3Zmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=h3ZAonb118O0d/Lcv9VCRzcfU78H6+ewqmcz0JFfLkg=;
        b=uag1Q/zdhdtxzcjCupjV7OQ00phIZK7sjKY5L+AmKeTL6Xm0UnKZqfNku3xtpkmkFD
         6B/2EXwYuP6faf36aRK/jqtlJHembgWWfOeXg9rGQdj4yCvPE698cuLfPxl6qXCBAQqK
         1Z0HNvhAy0DbQArCNdUtUH4Iao4QCY0dHtpoSD9xHH4aPg+D8BkhMXdPI3/sZ2oGLAA5
         1MEemM7fs1s5oszrrOXkNnv3B5ljXqk293JK2RKu6cec0MqRFrR6Qo7bubu3+wgxqkNB
         /qIHEzGjqP2y38Go44yoSA+Jqq8UuzAGidmgdwJFWZmIi4pr9ZUI6Oz0qDyGiLBq7qMJ
         tlfw==
X-Gm-Message-State: AOAM533wgVutY4Ybd295Z1rtzb6pfcRYtQVlWgG0Gwik7uUmEon6Wi2d
        X4SXnIuB2LpCaOr4zKYd/VwqbVEZJqKOmg==
X-Google-Smtp-Source: ABdhPJwgJrMfIYfMYo60ugUZ4aWUC3nWkDAqIRWtzI9iXwXaLqQ6K02oyTos96ESkrbMO7/BCxMMqA==
X-Received: by 2002:a17:902:a9cc:b029:d3:77f7:3ca9 with SMTP id b12-20020a170902a9ccb02900d377f73ca9mr3049145plr.75.1602079430841;
        Wed, 07 Oct 2020 07:03:50 -0700 (PDT)
Received: from localhost.localdomain ([183.83.42.133])
        by smtp.googlemail.com with ESMTPSA id a15sm3489664pgi.69.2020.10.07.07.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 07:03:50 -0700 (PDT)
From:   Gopal Yadav <gopunop@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Gopal Yadav <gopunop@gmail.com>
Subject: [PATCH v2] Solves Bug 1462 - `nft -j list set` does not show counters
Date:   Wed,  7 Oct 2020 19:33:37 +0530
Message-Id: <20201007140337.21218-1-gopunop@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Solves Bug 1462 - `nft -j list set` does not show counters

Signed-off-by: Gopal Yadav <gopunop@gmail.com>
---
 src/json.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/src/json.c b/src/json.c
index 5856f9fc..ea6e392c 100644
--- a/src/json.c
+++ b/src/json.c
@@ -589,7 +589,7 @@ json_t *set_elem_expr_json(const struct expr *expr, struct output_ctx *octx)
 		return NULL;
 
 	/* these element attributes require formal set elem syntax */
-	if (expr->timeout || expr->expiration || expr->comment) {
+	if (expr->timeout || expr->expiration || expr->comment || expr->stmt) {
 		root = json_pack("{s:o}", "val", root);
 
 		if (expr->timeout) {
@@ -604,6 +604,11 @@ json_t *set_elem_expr_json(const struct expr *expr, struct output_ctx *octx)
 			tmp = json_string(expr->comment);
 			json_object_set_new(root, "comment", tmp);
 		}
+		if (expr->stmt) {
+			tmp = stmt_print_json(expr->stmt, octx);
+			json_object_update_missing(root, tmp);
+			json_decref(tmp);
+		}
 		return json_pack("{s:o}", "elem", root);
 	}
 
-- 
2.17.1

