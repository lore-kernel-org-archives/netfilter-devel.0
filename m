Return-Path: <SRS0=DeQi=DK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53E42C41604
	for <netfilter-devel@archiver.kernel.org>; Sat,  3 Oct 2020 12:58:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9937206C9
	for <netfilter-devel@archiver.kernel.org>; Sat,  3 Oct 2020 12:58:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QPFEmcUJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725782AbgJCM66 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 3 Oct 2020 08:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgJCM66 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 3 Oct 2020 08:58:58 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24027C0613D0
        for <netfilter-devel@vger.kernel.org>; Sat,  3 Oct 2020 05:58:58 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id 144so3410368pfb.4
        for <netfilter-devel@vger.kernel.org>; Sat, 03 Oct 2020 05:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7U6Do4jlTLaXngcY0khdAhW63GQZcy6y2lLuBI0tkbA=;
        b=QPFEmcUJIJK9YCU/ZdP3i1kbprU5+T+TeK2GBzVCkoH6u6vj1eNpoFNI20eNAm59jB
         /afHGPyD//GY8G0xQv3qes1G/w2pjrkTwjBzPB0qGg1ci85zsqJLEqto4jaSGklukDJ3
         ZM9ObBLI2XuXrfHRGz1BWnGbAUXtlZKniYAWM+UwAMSV5Fbm65BCYhj9HOj/H11SOP+P
         LBx0ZU+vA+lH6rYjO6IVpt/mgzrMWFK9tE75XcVP2HBUgaXe0TPBPdtrpXVBtvmfmUsh
         efkdOhkHUwkbtorsmuXFWNn7RxFqeRBWTkGy78HEhoBuLBDkEvYKDVxvOZK2WWdLFaJT
         /w+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7U6Do4jlTLaXngcY0khdAhW63GQZcy6y2lLuBI0tkbA=;
        b=pe0UkzkEp5BJkuxUmzNtkvEY1IX1HNtH/eriJWg0ABCZFxfvwBQ/4QG7wOs6YGkFxB
         lARuz1uADjYi2kAwXo0DAWn19lmO6Pwtf/q0jqBkPxU0uT7VfRiUp606ppPt5otIMdi4
         vT7FPsP/JMYZ3TjO0IIX3ipKqler7WsWtUbdeWLkxkdUuQK2iPfnIE/imvY/4HCIgE5c
         C0tVSqKkTzfarccNYTSIBoJs4CQ3Vr7CztoS+4LOjLACKZmM5o5cE0jmeaSn72HjfO03
         bOQlm/CLYUQYUCBkUshg/x1icfTG2pSKnZQI6w6d95wFWOuQiMDfXNvqT+6wazeAZhTX
         12/Q==
X-Gm-Message-State: AOAM530kBv6MFGYDBpTfIoQcZWCjmfrR68Cy8HVrKzvL7GPO4ePy3ezO
        O/5EgqYvnhZ7nzRV9rv6R9D5CejFz+M=
X-Google-Smtp-Source: ABdhPJxXXGk0rMybRmGofcHHBKdSIVB+V5ROa+A0PzfKjiXxbmeBJKWvxRDOSG+RedbPuP0sV7Rwxg==
X-Received: by 2002:a65:4642:: with SMTP id k2mr6260278pgr.41.1601729937567;
        Sat, 03 Oct 2020 05:58:57 -0700 (PDT)
Received: from localhost.localdomain ([183.83.43.207])
        by smtp.googlemail.com with ESMTPSA id a11sm1950703pju.22.2020.10.03.05.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2020 05:58:57 -0700 (PDT)
From:   Gopal Yadav <gopunop@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Gopal Yadav <gopunop@gmail.com>
Subject: [PATCH 1/1] Solves Bug 1462 - `nft -j list set` does not show counters
Date:   Sat,  3 Oct 2020 18:28:41 +0530
Message-Id: <20201003125841.5138-1-gopunop@gmail.com>
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
index 5856f9fc..6ad48fdd 100644
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
+		if(expr->stmt) {
+			tmp = expr->stmt->ops->json(expr->stmt, octx);
+			json_object_update(root, tmp);
+		}
 		return json_pack("{s:o}", "elem", root);
 	}
 
-- 
2.17.1

