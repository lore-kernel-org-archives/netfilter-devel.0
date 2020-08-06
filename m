Return-Path: <SRS0=eBSQ=BQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2975AC433FE
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Aug 2020 11:01:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 128AF22D74
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Aug 2020 11:01:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EpiM7bij"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725535AbgHFF20 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Aug 2020 01:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725271AbgHFF2Z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Aug 2020 01:28:25 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400D6C061574
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Aug 2020 22:28:25 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id e4so6065142pjd.0
        for <netfilter-devel@vger.kernel.org>; Wed, 05 Aug 2020 22:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=6r7JhHqtDojVy9MKvux42glAKhjCagRSi/0fW2CoYCA=;
        b=EpiM7bij63yytK1eXibB5CDO8njUm6Se004+mYMC+A3mIRueZyYZYwCVi/w5sHxlCh
         6ZQ+KvHPxiHdr3pyondyJffM2O829HPG13j08Ty+F8XC4YPKzkJv4FQlIZey/X+zidEJ
         wx7ZoD79q08VouG4/7Sq7QMf77wPzcBtObxia69jDu9ABPA7A8tbsnlXwkQAyPCN6e5e
         R1YKbJsCjtc8b8CPnnB0IuXTaA1lgA4/6EQj7WG61UUfQZQBZVYqod0wLaIwaIghNLKo
         l0YUE3xdyEyPfLFWCi52sp9IlP8f22TXmdDbv0cWRPhiSCZwQ90SURfev6sAaY1Ca7h5
         o+9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=6r7JhHqtDojVy9MKvux42glAKhjCagRSi/0fW2CoYCA=;
        b=OxnHmVB3hXYmL9j//CKYc1/81joOev7Mh8wBTuGFrOkhd8jcCt79o9iRfLFlVxhfIZ
         mL0r2oUgnr9FDHkFP9fqlnWMpaBaKYQZqIoy9V3cTFInuYieB69tlSBbYyS6FAkxPzoh
         Eq3aS1OWUMq30/C73A1cdJ7sQ5gqyOQE0MjFjc+UT2TOPbhR/OQt4/YPelMfG15pgtYM
         5qI3zrgxMpcfyASfQvmXCCLhrtelWlzVOIuKCOUYnalPh6m+Q+Dl+8a43t+nuIZaWlh3
         Dd4Rl0XB8e99aAe1DB3veLYXGXsceELu/AtiDmKA+LgY+vQ/ij0x7lajbVf2J39gAHKl
         6+CQ==
X-Gm-Message-State: AOAM533uvoaXrtZuGhKgX3Ylglsqdu1NSX1cAPc6pj5ChIIBM0Ymd1wN
        fSlb2SCD2qzNSZZNchqbojLTlwlY
X-Google-Smtp-Source: ABdhPJyFC02hs8X31//KGeEb/NcOVAaOl7U5V2AnKqRAtZi29ZUfx/KFUsS2wq7ZbAJu+ZSQBAqAZw==
X-Received: by 2002:a17:90b:349:: with SMTP id fh9mr6444096pjb.73.1596691703679;
        Wed, 05 Aug 2020 22:28:23 -0700 (PDT)
Received: from [192.168.1.5] ([120.63.0.153])
        by smtp.gmail.com with ESMTPSA id t19sm6181763pfq.179.2020.08.05.22.28.21
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2020 22:28:22 -0700 (PDT)
To:     netfilter-devel@vger.kernel.org
From:   Amish <anon.amish@gmail.com>
Subject: xtables-addon official website changed from sourceforge to inai.de?
Message-ID: <2634a5e8-9eba-1c00-8d59-7ad24a4af803@gmail.com>
Date:   Thu, 6 Aug 2020 10:58:18 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello

Earlier xtables-addons was hosted at http://xtables-addons.sourceforge.net/

But now it redirects to https://inai.de/projects/xtables-addons/

Sourceforge still has version 3.9 whereas the inai.de has version 3.10 
(released recently)

Sourceforge git last commit is on 26 April 2020 whereas 3.10 version on 
inai.de shows release date as 28 July 2020

Is this correct and legit? Whois data is not easy to obtain for that domain.

I see no mention of shifting the website on netfilter-devel mailing list.

Please confirm,

Thank you

Amish.

