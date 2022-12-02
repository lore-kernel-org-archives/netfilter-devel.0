Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F629C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Dec 2022 03:38:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbiLBDiS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Dec 2022 22:38:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232183AbiLBDhy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Dec 2022 22:37:54 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4691D2931
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2022 19:35:24 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id c129so4219925oia.0
        for <netfilter-devel@vger.kernel.org>; Thu, 01 Dec 2022 19:35:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WO0rZFjQd5ypQ9SpHh9Qd12TChQoeP2Sbu8DnNm3Nk8=;
        b=rUu5jZhGcuGOmHryHSdSRAknlp3g8d75xtB71Xe+KZmFX/hGbVb2shgsAD0FD8CmoC
         FMcvanjESM8WVr35jkBixdgMRhi3N0ZQIkHHyQb5LFLTgKE3lVbGWI6gytJ5GcsBICoJ
         7MDV1q76B2d6DKig2iHppzJZeALFkJGkS4PB8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WO0rZFjQd5ypQ9SpHh9Qd12TChQoeP2Sbu8DnNm3Nk8=;
        b=2cl3pSvVqdFwAiY4lZaWk7l/u/5Vuub0cFcEQ7ac2mHTMWNYSXOdZyCZwC8RxuaFgo
         frSXElTfFrY5n9QULc0QtNI/aKAgkTxTJe/Dhs5HU+MhwT5XY56I8zo5Qb7YkzLynLiD
         Kgz7aU3IR36QELX/DCwzi4D0qJMWgkXiYqxFw2wT1kgjYZtbb3/F3xzEQ9yUlBO+3Zso
         WFf3uJFnKxCnMC38QyNXMwwdu6H5NI7UQsDZ9CO+im4/QstldNrsgs2ZVMDENvlTVJFp
         /l+b9AtNJPeCetwzpv+/vbURZTgPFcsVZWQt91E4/v0b/SUN+cmx4p6xtW18Cd4m/oPD
         dbRA==
X-Gm-Message-State: ANoB5pkFEj6F9BUlN8GzSXkeQrz7xXPIXJQBOAUrzEv7sDEx40CO73hd
        1jyFz/p01pDP1TYctynRyTs8hTOKWczlMa41
X-Google-Smtp-Source: AA0mqf4Zf6ffrJ5oSLpQZZ+glLVWwYWeyLdTWB7PFnJ9W9/CMYVrpMpg6O3xkrdX+YbuG5glfWPePg==
X-Received: by 2002:aca:4243:0:b0:35a:7300:7208 with SMTP id p64-20020aca4243000000b0035a73007208mr36017134oia.75.1669952116315;
        Thu, 01 Dec 2022 19:35:16 -0800 (PST)
Received: from localhost.localdomain (2603-8080-1300-8fe5-08b3-ba76-b470-1f87.res6.spectrum.com. [2603:8080:1300:8fe5:8b3:ba76:b470:1f87])
        by smtp.gmail.com with ESMTPSA id o16-20020a056870969000b001428eb454e9sm3604333oaq.13.2022.12.01.19.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 19:35:16 -0800 (PST)
From:   Alex Forster <aforster@cloudflare.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Alex Forster <aforster@cloudflare.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH] json: fix 'add flowtable' command
Date:   Thu,  1 Dec 2022 21:35:01 -0600
Message-Id: <20221202033501.48129-1-aforster@cloudflare.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In `json_parse_cmd_add_flowtable`, the format arguments passed to `json_unpack` are incorrect: the object key name ("dev") is not provided.

Fixes: 586ad2103 ("parser_json: permit empty device list")
Signed-off-by: Alex Forster <aforster@cloudflare.com>
Cc: Florian Westphal <fw@strlen.de>
---
 src/parser_json.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 76c268f8..aa00e9ec 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3253,7 +3253,7 @@ static struct cmd *json_parse_cmd_add_flowtable(struct json_ctx *ctx,
 		return NULL;
 	}
 
-	json_unpack(root, "{s:o}", &devs);
+	json_unpack(root, "{s:o}", "dev", &devs);
 
 	hookstr = chain_hookname_lookup(hook);
 	if (!hookstr) {
-- 
2.38.1

