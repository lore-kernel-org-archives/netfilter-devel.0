Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19D99C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Apr 2022 09:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbiDIJqQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Apr 2022 05:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbiDIJqP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Apr 2022 05:46:15 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E074B6E40
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Apr 2022 02:44:08 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id u19so4664195ljd.11
        for <netfilter-devel@vger.kernel.org>; Sat, 09 Apr 2022 02:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Aa0WMJDHXrgOffdEBwcMWFGr+eRTwZuf02RIunnI7aM=;
        b=YRJvt1FmYIM18kSlHufjKslBbriRpmUzwCRYiFNJz1fhIhaJ0hzmiuvjlnv8jIp9V3
         hwMyfSwvOoigc09Q8m+evZAAmA6aXQAD+rbARqYBe2Tb3Q+GI/4A7aLQB6N4yQS4RbcL
         GbHc817lP7E6vceKcwc/vtZpu2CrP/v2IANYfQilPM9BRYSNpPJWpkilLkIziaBqD/3T
         4mBxtU+mgaTikaf/QnasXHnsCzOL/ALil4F0GLTDjT4Iq8hoHrFzNc1sm3xKeo2wK0Lu
         D/FO0LZ4Ei74egdM2Rbsbgj34lh8Tu5/+TOVowUjFZQssMdsO1SWQJaNz2WYAACzoAkc
         M+9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Aa0WMJDHXrgOffdEBwcMWFGr+eRTwZuf02RIunnI7aM=;
        b=NsLT6seoHNwR+aqoojVFZomFonUmuRnnHiLlT1GAwPFEDz6fRnr9PG72Q+qub8rEL7
         gIq2G2bq4pLIsFS5cx59WJaOVBR75Z2RXtssg41KjP/5q6J9pQ4kfKuoJoQ68TTo4rJy
         kQ/ycHrYQGkbmQDgBkWRuWHg19n+s6TTMpdzsbEZWMDUekctLGVpKxJyrtcYbJa8rW0y
         z36aVk9eq0XYFSwlamqx96A9sa0mPpa6uEnU2cdx/AxJdprU8ase/mjsveOjMtZT1PMV
         IlFu2TMHD6sNypsif4hmLzAPVqAdfr/8Irg1x11ymuSMSPPKwSfU2hLvXshRIFgw66Rl
         gUBw==
X-Gm-Message-State: AOAM533LNPhU0jZpa8csLXe838fQ9RvW3eoL/KmNXt3xBRSoxYAXukl5
        L71wJaRvVssjYPP1GamD6/SfPOJKJNg=
X-Google-Smtp-Source: ABdhPJzEq40Eupo28hAC4nb0NTg0S/4e6MGrFYDbUhziQTeZdd7y/vW0U0xEkUMSGQgzxTyo2cxhAA==
X-Received: by 2002:a2e:90d6:0:b0:246:e44:bcf6 with SMTP id o22-20020a2e90d6000000b002460e44bcf6mr13743576ljg.501.1649497446088;
        Sat, 09 Apr 2022 02:44:06 -0700 (PDT)
Received: from localhost.localdomain (91-159-150-194.elisa-laajakaista.fi. [91.159.150.194])
        by smtp.gmail.com with ESMTPSA id u12-20020a19600c000000b0044a2e4ce20esm2680675lfb.193.2022.04.09.02.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Apr 2022 02:44:05 -0700 (PDT)
From:   Topi Miettinen <toiwoton@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Topi Miettinen <toiwoton@gmail.com>
Subject: [PATCH] doc: Document that kernel may accept unimplemented expressions
Date:   Sat,  9 Apr 2022 12:44:02 +0300
Message-Id: <20220409094402.22567-1-toiwoton@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Kernel silently accepts input chain filters using meta skuid, meta
skgid, meta cgroup or socket cgroupv2 expressions but they don't work
yet. Warn the users of this possibility.

Signed-off-by: Topi Miettinen <toiwoton@gmail.com>
---
 doc/nft.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/doc/nft.txt b/doc/nft.txt
index f7a53ac9..4820b4ae 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -932,6 +932,11 @@ filter output oif wlan0
 ^^^^^^^^^^^^^^^^^^^^^^^
 ---------------------------------
 
+Note that the kernel may accept expressions without errors even if it
+doesn't implement the feature. For example, input chain filters using
+*meta skuid*, *meta skgid*, *meta cgroup* or *socket cgroupv2*
+expressions are silently accepted but they don't work yet.
+
 EXIT STATUS
 -----------
 On success, nft exits with a status of 0. Unspecified errors cause it to exit

base-commit: 6fa4ff56385831f01bd9d993178969a4eddbcdbf
-- 
2.35.1

