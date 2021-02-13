Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.2 required=3.0 tests=BAYES_20,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D828C433DB
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Feb 2021 09:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB80264DE3
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Feb 2021 09:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhBMJzi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 13 Feb 2021 04:55:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbhBMJzh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Feb 2021 04:55:37 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12EB0C061756
        for <netfilter-devel@vger.kernel.org>; Sat, 13 Feb 2021 01:54:57 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id g20so1128750plo.2
        for <netfilter-devel@vger.kernel.org>; Sat, 13 Feb 2021 01:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding:thread-index:content-language;
        bh=zFfduRurD8LOBio9pgNgbF9wtXIM++0hciUpCxBLtN0=;
        b=LM1NzTbYyzP3amnmnhCUSYPZ6JwQ7E53ZEtuvuSpJAviLrmgegP8KG2avBwAviyDOu
         ev34mPpAtGyJlg3IrGRk2IW89tmpRFszqXIGxNvZNxQdWovHMQ7orE4SsS9E0VKt2q7W
         g1daLKhfNC/qngLgh2x2/vuBMYFP/My9nVB6RFh7utKIm7D+6yIGziNurH4NvdLILDsk
         xUqcfuim8ZXoIxp8HEfxI9tPsWwiJpO0IaBdkdl5023iZ+T73ZL6vcwnEjMz9XQGVy14
         cZWmPYsj7b1rviz2j15a4rN4ARwH9OQOD2JYiYn1eryxRDF6DiuB0YoK0bxPoOYY7g4j
         Lhcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding:thread-index:content-language;
        bh=zFfduRurD8LOBio9pgNgbF9wtXIM++0hciUpCxBLtN0=;
        b=GAVaucDek45bEA1EuNOam5oNZa8jq549U+Il9rT9G3ZtjZ8yr39me2gH/l0kIpQ41d
         x+QdRa1CH848ewjY0n2IMZ0w37DHwizDRuOMk6cO2Ruo6dzdJVae3if9xoZ0a1EbRf5w
         RoQjq8ZEoBw7IycJm7H/5en/EQP/XpCgrcfEz5o1Yo19zDGe2m5C8zk+PjZWL2zr4kxK
         CHFRsG0EaMqSIhK3cvT+MMF8XduSLTbm5uh7SxmuEO/Fae2gdl4MJdo7byhO11hw8F7a
         V2R5BkxrmQrM1yhUo0pZDOCuykcte8IdohQCiBTyoDoIgCGtz36T5YJ3wDcLBBDLupfu
         dZJw==
X-Gm-Message-State: AOAM530nr+GA0cdoqlUow1VoznapQWPxXuPVUAPINlZvvBoIBV8c3FQ6
        VMb4a7FvFb1jfVqOM59JPjeXxmDoTdc=
X-Google-Smtp-Source: ABdhPJzTdeMc9zJFaspjo8DSwE2yqChH1O23X7f/nj8vPKxd77U4b+YG2lzspxeISACSbTS+lCt75A==
X-Received: by 2002:a17:903:20d1:b029:e2:bc1c:2840 with SMTP id i17-20020a17090320d1b02900e2bc1c2840mr6415441plb.43.1613210096378;
        Sat, 13 Feb 2021 01:54:56 -0800 (PST)
Received: from DESKTOP ([124.170.54.239])
        by smtp.gmail.com with ESMTPSA id k11sm10664166pfc.22.2021.02.13.01.54.55
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 13 Feb 2021 01:54:56 -0800 (PST)
From:   "Bob @ gmail" <bob.zscharnagk@gmail.com>
To:     <netfilter-devel@vger.kernel.org>
Subject: Question about using NFT_GOTO in kernel module
Date:   Sat, 13 Feb 2021 17:54:53 +0800
Message-ID: <008001d701ee$486aec10$d940c430$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AdcB7kaZeBxajHeiShWcuwMvcksaHA==
Content-Language: en-au
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I'm hoping this is the correct place to ask questions about nftables. I'm
developing an extension module using "Tutorial Extending nftables by Xiang
Gao" in your external links.

I find I would like to return a NFT_GOTO result in my "static void
nft_extension_eval(const struct nft_expr *expr, struct nft_regs *regs, const
struct nft_pktinfo *pkt)" finction.

I was previously setting "regs->verdict.code = NFT_CONTINUE" and
"regs->verdict.code = NF_DROP" successfully and getting the desired results.

I'd like to set NFT_GOTO and I can see that "nft_regs->verdict' has a chain
entry.

My question is how do I populate that?

Thanks.  

