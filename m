Return-Path: <SRS0=MXnI=C7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD13EC4727D
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Sep 2020 08:25:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 756802076E
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Sep 2020 08:25:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b369LyGN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgIVIZr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Sep 2020 04:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbgIVIZr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Sep 2020 04:25:47 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996BEC0613CF
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2020 01:25:47 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id y1so11349098pgk.8
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2020 01:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=cKTOGpQvm/Mav3sQnOKqDxMNIuFoRAvyEmM3poa50Vg=;
        b=b369LyGN+VdC1cYkHRgVjzkUJjDPALZWwTIGVdO03FKuSECSGCI61iZxSJxzoQOKbE
         cPncnH1wwVEVABMJ86cVv/lsuzd3juLGN3oiQRK6jUvKBEex+yKYBvUOsR16PytQxcLB
         jUBdjLRPhgXgTeRBofyalQVo2JPFafYsoFfbTtqOO09hgDc64F3WQ3NxOA4Z0/B6B9qr
         3hK/IkKbbuqyrUUvO25/XAAZmVpC6esrr05vVbSPc9AJk5TyOlet9PTSuNTGdCB2F/0f
         rd9BmbVMMSKmVCG3v5/BizThPwOtkT2GTO2q6XHE3r6CWXkUrKn/B5dzGnAovPVJkaZW
         YmbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=cKTOGpQvm/Mav3sQnOKqDxMNIuFoRAvyEmM3poa50Vg=;
        b=GZf8hehcie8mVJsb9LUj9JBL4OTbfmmqP94NnGUFEO63EkEtgsw0zH3HCKCvExtmNc
         7Ck8EMtuTC0QMRQjN+AuQnN4TDYnCgeAs81EIgl9ucRBqPvE3VFM1SFoLNd3BkcXvKq/
         G7BxYqHeclWDGwlTXoFSgDVpf6VQTjQ8wCeOYrcW/P3P4zJNt6Mx2/DBHxg3HwHVC4ur
         PnyRUsLeUo/Fmtsxh2LOLw3Kgyd0g9jLLaXIIYQ2TKEkKeMjH4K7n25q/qiYxqsAzG78
         0Wljs1Mvp/rkEsmNPL5MuirBsjuF63EdUSrLMG/8EhrS6TfXK43sz6ZFFcV/MXQnQXOL
         AYkg==
X-Gm-Message-State: AOAM53040nUHYJuyUO3SCWPd+DZ17+CveUQsk0sJVg3pHkidJ7SA+R9b
        b/Z+dewyx5naC0gwmDi8yG9d2Th295E=
X-Google-Smtp-Source: ABdhPJySQsAPKJnER2N489aXfYjUIAU5ubg/Q2CbMaMdXWyF3PzJ9IDGliGCEFHVJWREKLFiaZUwaA==
X-Received: by 2002:a63:b47:: with SMTP id a7mr2683892pgl.57.1600763146354;
        Tue, 22 Sep 2020 01:25:46 -0700 (PDT)
Received: from localhost.localdomain ([183.83.42.252])
        by smtp.googlemail.com with ESMTPSA id f18sm15608267pfe.153.2020.09.22.01.25.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 01:25:45 -0700 (PDT)
From:   Gopal <gopunop@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Gopal Yadav <gopunop@gmail.com>
Subject: [PATCH] Solves Bug 1388 - Combining --terse with --json has no effect (with test)
Date:   Tue, 22 Sep 2020 13:55:33 +0530
Message-Id: <20200922082533.20920-1-gopunop@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Gopal Yadav <gopunop@gmail.com>

Solves Bug 1388 - Combining --terse with --json has no effect (with test)

Signed-off-by: Gopal Yadav <gopunop@gmail.com>
---
 src/json.c                                             | 2 +-
 tests/shell/testcases/listing/0021ruleset_json_terse_0 | 9 +++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)
 create mode 100644 tests/shell/testcases/listing/0021ruleset_json_terse_0

diff --git a/src/json.c b/src/json.c
index a9f5000f..5856f9fc 100644
--- a/src/json.c
+++ b/src/json.c
@@ -140,7 +140,7 @@ static json_t *set_print_json(struct output_ctx *octx, const struct set *set)
 		json_object_set_new(root, "gc-interval", tmp);
 	}
 
-	if (set->init && set->init->size > 0) {
+	if (!nft_output_terse(octx) && set->init && set->init->size > 0) {
 		json_t *array = json_array();
 		const struct expr *i;
 
diff --git a/tests/shell/testcases/listing/0021ruleset_json_terse_0 b/tests/shell/testcases/listing/0021ruleset_json_terse_0
new file mode 100644
index 00000000..3fa22565
--- /dev/null
+++ b/tests/shell/testcases/listing/0021ruleset_json_terse_0
@@ -0,0 +1,9 @@
+#!/bin/bash
+
+$NFT flush ruleset
+$NFT add table ip test
+$NFT add chain ip test c
+$NFT add set ip test s { type ipv4_addr\; }
+$NFT add element ip test s { 192.168.3.4, 192.168.3.5 }
+
+test $($NFT -j -t list ruleset | grep 192) || exit 0
-- 
2.17.1

