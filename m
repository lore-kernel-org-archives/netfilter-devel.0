Return-Path: <SRS0=CgNT=DN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59A1EC4363D
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Oct 2020 12:39:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D7DE206F7
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Oct 2020 12:39:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FXk37v9d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbgJFMjV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Oct 2020 08:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgJFMjV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Oct 2020 08:39:21 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984F2C061755
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Oct 2020 05:39:21 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id t18so1155297plo.1
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Oct 2020 05:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=/l0SK7ObsRHUYbeX2IHNYC8C85z1B6AkRvOgJKMjEds=;
        b=FXk37v9d6zpafAsWnpk/OeV/pLSDgMrn16hq4AxW2pU8gdU8GKK1joRoLtnlrFyrpL
         X3dkFhXApEYOlGYi4Lu/c+2OdRQPuiWcs4jE8AUlCNY5kW/XmYpZU13UVZxlJ2Zq0M6j
         nNoYq2DLPT0PXTHfdfHIe3eU78vv9emey+S9ja7H+Z4TM0rjrQ3Coqm5z3eGhW8l8g61
         gi5wXnkqO3iE4UyCTrSCRQkcVLagy5/YiZg0ah0R7lzX3r3/sBlKrgj1FZhDyAf4l8Q9
         TNsTea15qMiQ3t1Y/Fq2OxlOUHyAFC1PPb/sKiMRSJiGp/t7uuw1X2uLFgO0tHZvvHpE
         U0PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/l0SK7ObsRHUYbeX2IHNYC8C85z1B6AkRvOgJKMjEds=;
        b=c3FSCTn7uaYTbaEPgWR6/UjkyaOlXLh9ZTNQ+5KGAyzr+lqQ7jaHSda6F18HizMTUC
         QExWV08RdzbfdIaud3s3XgQUuQvsP7sPAE8YZ5/rGTi0ya2S6rb0oCUnRiBupIZAYMx5
         A2e71fEQ+TiuuS0XobB6NozQzAszmMUR0BDGvUszhPZwVIfazEoXeeywsn9sGaxpn+q4
         C+mY3wB8B/d3ljmLC+l9pHkD9t+28gr6z3itlYTz7EqAlhgLG49MgvhodCp0IKk3kAT4
         yTpBpiY7nYnJtiS2ICme7Rns7DGaoj70mIiPV8g7YFG+qsycinQSgm4eA4SNdfNUEMsU
         zXfg==
X-Gm-Message-State: AOAM531LI75uUPz6AmwzVGNvSFAqrNndm9/AWczB/68X5HPh7uM8/jgg
        2qJnpUp5Bxd5InESBkl+TxmXLzSzDWmmnQ==
X-Google-Smtp-Source: ABdhPJxz87b8SLYIlgzSXmJSfFMuMAAht6mJXtId605cbSM7YN+ywyDDMco46A75LBEOR0clLomb7A==
X-Received: by 2002:a17:90a:d57:: with SMTP id 23mr4047563pju.232.1601987960894;
        Tue, 06 Oct 2020 05:39:20 -0700 (PDT)
Received: from localhost.localdomain ([183.83.42.133])
        by smtp.googlemail.com with ESMTPSA id gi20sm2759405pjb.28.2020.10.06.05.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 05:39:20 -0700 (PDT)
From:   Gopal Yadav <gopunop@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Gopal Yadav <gopunop@gmail.com>
Subject: [PATCH] Solves Bug 1462 - `nft -j list set` does not show counters
Date:   Tue,  6 Oct 2020 18:09:01 +0530
Message-Id: <20201006123901.19742-1-gopunop@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Solves Bug 1462 - `nft -j list set` does not show counters

Signed-off-by: Gopal Yadav <gopunop@gmail.com>
---
 src/json.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/src/json.c b/src/json.c
index 5856f9fc..205b4b24 100644
--- a/src/json.c
+++ b/src/json.c
@@ -589,7 +589,7 @@ json_t *set_elem_expr_json(const struct expr *expr, struct output_ctx *octx)
 		return NULL;
 
 	/* these element attributes require formal set elem syntax */
-	if (expr->timeout || expr->expiration || expr->comment) {
+	if (expr->timeout || expr->expiration || expr->comment || expr->stmt) {
 		root = json_pack("{s:o}", "val", root);
 
 		if (expr->timeout) {
@@ -604,6 +604,10 @@ json_t *set_elem_expr_json(const struct expr *expr, struct output_ctx *octx)
 			tmp = json_string(expr->comment);
 			json_object_set_new(root, "comment", tmp);
 		}
+		if (expr->stmt) {
+			tmp = stmt_print_json(expr->stmt, octx);
+			json_object_update_missing(root, tmp);
+		}
 		return json_pack("{s:o}", "elem", root);
 	}
 
-- 
2.17.1

