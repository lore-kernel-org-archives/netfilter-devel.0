Return-Path: <SRS0=+9KY=7U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 823E1C433DF
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Jun 2020 21:37:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52F0E206D5
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Jun 2020 21:37:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mNQlxVYF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgFGVhC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 7 Jun 2020 17:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726093AbgFGVhB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 Jun 2020 17:37:01 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 190CBC08C5C3
        for <netfilter-devel@vger.kernel.org>; Sun,  7 Jun 2020 14:37:00 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id q11so15358390wrp.3
        for <netfilter-devel@vger.kernel.org>; Sun, 07 Jun 2020 14:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=koI9Pnw3TTzqylYwZM4+3p6W+8Mj23kz6r2pyimPul0=;
        b=mNQlxVYF+kFt+x1PxgGOmZxy1GLEyuxS00msQa9FMctieF0hO3pT/mopP1K7JLhoxV
         8uvFbLphcjcMBLtks2nzIXyJ9rogl2a/ozQhhIESZpi55PpCx557hbwstJLmiHrTC8+P
         MQx/Vrm/dAn8Me5NVSY5eY3+FX2pzHHs6DYIVOIKqHNAxbmNfacJg/Pe2wMal6r35xIm
         0HdILJ7savJvxgujKNT31qxqgO9jyP8u1uqDUpw4kehlAE6yQB87EaB16cmblZvC0K+X
         ncd7l+Xyf5H5DOvSI0ZFNBZsdyTkwJUE8evMFzPMZPv+fGwZMY0uCw05TljWeVFV9xL6
         V7XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=koI9Pnw3TTzqylYwZM4+3p6W+8Mj23kz6r2pyimPul0=;
        b=JHnaVLU+womhDWET1r3o/HOzV/+jPUnTgQb+MuujQclwNQopgjvSlIMTNOAN2Trwc6
         7djHxCThRx5FFClzlvQjPWw+NZscy+V5K31u8omPQdvoo2lwoLBxixfl2QAEVVOXytJm
         MyQ9cVHZJoIdPk90sYn1eBsPLEciUr7DGpKLjH68DF9OU7os80tYGsd3O0L9Hy2WxMEy
         tEvzfSvvvvRd6Amiy7FR8Dsb29Jdzkhi52rwiDDJMGsacnH3etIl+7qRylFBywN99Oto
         WIlV4s4yDsiHCsizGYmhGUolw2+E/TIsT58piW4DFEIGATN1fdIbyZaE7PTDLthUhihj
         BP1A==
X-Gm-Message-State: AOAM531pl9MK5Ap91+Y77EJawC0R8pTeKIYNvM3O2rvlyN6RGtGrc9+v
        U750rteeg3N+Labr4GLUwH9bD/DH
X-Google-Smtp-Source: ABdhPJyMlPnNd8HOAH/eps7uONke3KBEaeTBrzNuHjXJjmqsryIavWtz6Dm0ZIdmJjrOi3Bc033E+w==
X-Received: by 2002:adf:fe8d:: with SMTP id l13mr19770789wrr.282.1591565818438;
        Sun, 07 Jun 2020 14:36:58 -0700 (PDT)
Received: from kali.home (lfbn-ren-1-590-36.w81-53.abo.wanadoo.fr. [81.53.168.36])
        by smtp.gmail.com with ESMTPSA id o20sm22080289wra.29.2020.06.07.14.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2020 14:36:57 -0700 (PDT)
From:   Fabrice Fontaine <fontaine.fabrice@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Fabrice Fontaine <fontaine.fabrice@gmail.com>
Subject: [PATCH nftables] src/main.c: fix build with gcc <= 4.8
Date:   Sun,  7 Jun 2020 23:36:47 +0200
Message-Id: <20200607213647.4107234-1-fontaine.fabrice@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since commit 719e44277f8e89323a87219b4d4bc7abac05b051, build with
gcc <= 4.8 fails on:

main.c:186:2: error: 'for' loop initial declarations are only allowed in C99 mode
  for (size_t i = IDX_INTERACTIVE + 1; i < NR_NFT_OPTIONS; ++i)
  ^

Fixes:
 - http://autobuild.buildroot.org/results/cf2359b8311fe91f9335c91f2bb4a730c9f4c9dc

Signed-off-by: Fabrice Fontaine <fontaine.fabrice@gmail.com>
---
 src/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/main.c b/src/main.c
index d830c7a2..e248a347 100644
--- a/src/main.c
+++ b/src/main.c
@@ -169,6 +169,7 @@ static void print_option(const struct nft_opt *opt)
 
 static void show_help(const char *name)
 {
+	size_t i;
 	printf("Usage: %s [ options ] [ cmds... ]\n"
 	       "\n"
 	       "Options:\n", name);
@@ -185,7 +186,7 @@ static void show_help(const char *name)
 
 	fputs("\n", stdout);
 
-	for (size_t i = IDX_INTERACTIVE + 1; i < NR_NFT_OPTIONS; ++i)
+	for (i = IDX_INTERACTIVE + 1; i < NR_NFT_OPTIONS; ++i)
 		print_option(&nft_options[i]);
 
 	fputs("\n", stdout);
-- 
2.26.2

