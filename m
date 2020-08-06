Return-Path: <SRS0=eBSQ=BQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38858C4363D
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Aug 2020 11:05:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DBE52310F
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Aug 2020 11:05:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L6IrUGFJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728742AbgHFHsv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Aug 2020 03:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728334AbgHFHsd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Aug 2020 03:48:33 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95EABC061574
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Aug 2020 00:48:33 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id i92so4363041pje.0
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Aug 2020 00:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=08qLsaI6vohEdWZkXPCKIFAJ7DABtT8dEhdXuL0vSTU=;
        b=L6IrUGFJS+PFewnruXU3cmoeQ271fjgGPmF/KHXZwWUvoN6Jror4rKYGUuIHw2/8T0
         vBXNnRouvf5gyXXAIULAI0dnLqgKNAVMUkCGN690qgkRWnh+16rZW5DMD4xC9oOC0XrZ
         ZlDoJwGVANl5/K/BkBY0PlyTF3XRASarw5HWBvoVXWYDC9Q8zNpvY2y8oQ5gNmMzbefD
         AqhaYW7C/Mw9CTyy0Yd/FyHRlLWvVcYSCb2yU7XklJVI78KkdRYNgU866kc5eXbXE9hq
         FhcwT/tn7jFrDV7GoTbQwf4B0xL8XDydT2k1/pOBchF+k41h+YW2NSE8W2YdLnUI2oTs
         gqBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=08qLsaI6vohEdWZkXPCKIFAJ7DABtT8dEhdXuL0vSTU=;
        b=d5DNDsMamQibGS4ZjCGW0Y/EFIXKB1pKVIiYNxRZj/iON0Fc3wMV9cDZwPZLqepDvY
         WouCDIN6qXfonvMpMrt7ZzUSthMHP6PT7/cW1mpy3U2bsawuKS+GpbCQrdTFL3Lf5DK0
         NZurF5UDvNVx1CAQaxn0NmJpORyE9UhcYOrnYv0T1O2kVTZa9PxKf0IxGOo36KVB2vmC
         nYTWeA7U220pSSqUSo9Dwf5dQ7Q19yWbGF1Ymp/In/Z8vlGo4N2CG09waDvAKrzkf+6e
         OW13ifdw3bNS4Fvwx0kehu0M6PfQ2qQiBjonGT5Z8sHfJ8PVHW3LeyMv/fq7mZXi7Iv+
         WIbg==
X-Gm-Message-State: AOAM5302voeCgFp2fu/zkg2dPeG4sJkJQDjFz2/7WYK0qx4eCrBGf8jQ
        tmbNjU887Z9wPWPpD01PiePvc+TX
X-Google-Smtp-Source: ABdhPJzZSXBHrmGG6A4jrQ0QQ+8qVJDKh6XJKqr+foKDLaaocVclVbqEFXDEyHTp4rrh6cLdTjfZMQ==
X-Received: by 2002:a17:90a:24e6:: with SMTP id i93mr7098003pje.231.1596700112330;
        Thu, 06 Aug 2020 00:48:32 -0700 (PDT)
Received: from [192.168.1.5] ([120.63.33.213])
        by smtp.gmail.com with ESMTPSA id js19sm5719003pjb.33.2020.08.06.00.48.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 00:48:31 -0700 (PDT)
Subject: Re: xtables-addon official website changed from sourceforge to
 inai.de?
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org
References: <2634a5e8-9eba-1c00-8d59-7ad24a4af803@gmail.com>
 <nycvar.YFH.7.77.849.2008060912350.9330@n3.vanv.qr>
From:   Amish <anon.amish@gmail.com>
Message-ID: <a763c01e-e2cc-bd00-b4d9-f0a77c041d24@gmail.com>
Date:   Thu, 6 Aug 2020 13:18:26 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <nycvar.YFH.7.77.849.2008060912350.9330@n3.vanv.qr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 06/08/20 12:44 pm, Jan Engelhardt wrote:
> On Thursday 2020-08-06 07:28, Amish wrote:
>> I see no mention of shifting the website on netfilter-devel mailing list.
> https://www.spinics.net/lists/netfilter-devel/msg68255.html

Ah ok! Thank you very much.

The announcement was kind of hidden under another thread as a reply.

I think new release announcement should be started as separate thread. I 
must have overlooked because of word PATCH in subject, thinking that it 
is a patch and not an announcement.

Thanks again and regards,

Amish.

