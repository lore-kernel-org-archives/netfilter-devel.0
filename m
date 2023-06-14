Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB31FEB64D8
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Jun 2023 16:25:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbjFNQYo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Jun 2023 12:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233343AbjFNQYn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Jun 2023 12:24:43 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257261FFF
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Jun 2023 09:24:40 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-4f62b552751so8955710e87.3
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Jun 2023 09:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686759879; x=1689351879;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yhpxNwXsxFmZGiHexFBgh80kegaTzGGvCyiMZBFeUiA=;
        b=p5Nzo9wXEu5Bnmocd/82xenHMvkQZBFUnBMQ2MbfG4T3t1YuNbp3pp7NQA6Dzkazyb
         G22fWbcx+ZlWF6a9UI5vIhNdUhhD0i1NerrcFsVo/o0jwdFUeWC55Q3dxt6N0wB+ZiAA
         lCfHvKuFXktRIP2wOqfOSKwNg+pr9A+2Ll+m3kCrQ0PL+KM7zeKNkSJPZd6Nvl8D75eF
         otTzAEmBNSbkXD540U6CERDyJhT9iH+cjvBfOAxNXAZ8GJ9n/+4w92txcnDVyMdXs1EW
         sIEF6o2tZFdqQyCybqJXOga3LPxSvJbZKUfRjqda+4WWK+iGCN/LP2AESWmaXSZybCRH
         w+cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686759879; x=1689351879;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yhpxNwXsxFmZGiHexFBgh80kegaTzGGvCyiMZBFeUiA=;
        b=UF9fNrNPfCuwwm3mPv3d/IHUh/FfQEff6bERxFTlaTSf0T2TLHtcl/XZpRxCvU10ie
         2jsCOd9rrpovilJ+Wu78cLRpnBiEMCeem68RwaleWIg+MNmSUz2ZzjDaFZEjNcptswSv
         HWWwVlC7Q/bNemJOfpER2DRabORQnBOisLUxV3TzqCMVJJUaugQkSXW9xsicr1OkMwgI
         3XQFRRB2JPPvvucsv6h7VnPyV1PVzXqWymBRQrZiqA4wqaZRJz+8wTmPGE4UsLFWkYRW
         SvJq5UzO6umvks+AZjFs4ZcGqsNnqbr5l9Hl58ksWjb6ZMqyPpEL5z1BoT7SqpNvVLNL
         ZvSQ==
X-Gm-Message-State: AC+VfDyGM1zcY881SqL+9F5a5+0NagW3AHZVfs1QD7a8+7xwWT3g4t54
        J6ZvZL9nZghdEEZ+5PsjKKHpFf0CNKE=
X-Google-Smtp-Source: ACHHUZ5Rx15PQ0tQXpf7zWnxIbk0KE50/NtvIo/alJH3wWHGZ4OxoQ+Q6sGTYrrpFl5muCDWn0ToVw==
X-Received: by 2002:a19:7b13:0:b0:4f7:deef:456d with SMTP id w19-20020a197b13000000b004f7deef456dmr200325lfc.59.1686759878673;
        Wed, 14 Jun 2023 09:24:38 -0700 (PDT)
Received: from linux-ti96.home.skz-net.net ([80.68.235.246])
        by smtp.gmail.com with ESMTPSA id x12-20020a19f60c000000b004efe8991806sm2174466lfe.6.2023.06.14.09.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 09:24:38 -0700 (PDT)
From:   Jacek Tomasiak <jacek.tomasiak@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Jacek Tomasiak <jacek.tomasiak@gmail.com>,
        Jacek Tomasiak <jtomasiak@arista.com>
Subject: [conntrack-tools PATCH] conntrack: Don't override mark in non-list mode
Date:   Wed, 14 Jun 2023 18:24:05 +0200
Message-Id: <20230614162405.30885-1-jacek.tomasiak@gmail.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When creating new rules with (e.g. with `conntrack -I -m 123 -u UNSET ...`),
the mark from `-m` was overriden by value from `-u`. Additional
condition ensures that this happens only in list mode.

This behavior was introduced in 1a5828f491c6a1593f30cb5f1551fe9f9cf76a8d
("conntrack: enable kernel-based status filtering with -L -u STATUS") for
filtering the output of `-L` option but caused a regression in other cases.

Signed-off-by: Jacek Tomasiak <jtomasiak@arista.com>
Signed-off-by: Jacek Tomasiak <jacek.tomasiak@gmail.com>
---
 src/conntrack.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index bf72739..78d3a07 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -3007,7 +3007,9 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 			if (tmpl->filter_status_kernel.mask == 0)
 				tmpl->filter_status_kernel.mask = status;
 
-			tmpl->mark.value = status;
+			// set mark only in list mode to not override value from -m
+			if (command & CT_LIST)
+				tmpl->mark.value = status;
 			tmpl->filter_status_kernel.val = tmpl->mark.value;
 			tmpl->filter_status_kernel_set = true;
 			break;
-- 
2.35.3

