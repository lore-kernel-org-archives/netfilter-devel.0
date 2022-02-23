Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D51FC433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Feb 2022 14:03:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233339AbiBWOEV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Feb 2022 09:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241337AbiBWOET (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Feb 2022 09:04:19 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DFA5B12F5
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Feb 2022 06:03:51 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id i19so13806046wmq.5
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Feb 2022 06:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=zLtVcmFkmmZWPSUUMbouV4mZ1BR3JBvi21d4wzaaWeg=;
        b=HclJnQtK5E5D2I6vLgnXxiz+Ky4uRj2vYnur1VJ3DmfeaaBjG9QRK2GsypH909VCJa
         LZb1Qg0Ptx48QqBsvikZ5nPrz++I7pCzeIf2HefIF13Xvbe/SmZ2mDHSjASQBvy/f43+
         peJsW0BVuODWZkLjmh5eLdHdeq1reObZg9u6DIWaT2Xfts/9ZAx/KkJ/2Yo/nFVeJEXg
         SgX7BLkNTcsSLFwXMhjTpl7gZU6gAX2e7Zob/OReE2dT4c/bYQi+25ZXVbKqOhch4ZGq
         ZTBQ8OFD52s+jXL0peo5OZ1RESVeVQtN8sr62VfQ9tG5eeKRKDXHTUGmRWDqM5lU05xG
         kFFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:organization
         :in-reply-to:content-transfer-encoding;
        bh=zLtVcmFkmmZWPSUUMbouV4mZ1BR3JBvi21d4wzaaWeg=;
        b=q92+KyU+xA12RxGDvAkEVph0Mpt41IFvq0BVjTBmeDlAutYsOfMUPOQPBDFFunDHQI
         IuEZOoBB8JySJ4E8DuBJmGRNIzUFQ9ZCPCCxBMHDH5+JMohjXTqjPs2ksrOnvNe/2Nqn
         7BwE2F6iqbpwdIcWBhrOkwBk36mSv2SiHcBLC8O59eVRnJC3dUg8K7tfAUFpFKSvwEKD
         k22BByXP1NyeV8VF34xJGgAXL5firnzV+NfjAH0tnaGVhwx6xkWH5ZpowG/Dg24BR1up
         J6aS6CXrvhTSwm2OtJEONCOPJSDeEa/xZ0w4EQIau+ulZppCrfatTkkmCNzqxouBh9mY
         s29A==
X-Gm-Message-State: AOAM530SBUYrj6ug+7O6OvcWBYRfOFQZcE+viXjuxyWkyxSkCrtLz82h
        /6ScUA9IRAKxHQxfUe4x76tP+VZOitGFRA==
X-Google-Smtp-Source: ABdhPJxsEW8QxKj8w9zTWFiMZ4n7p0rpBVsN7QNQmftHr3Uw6P6iTZfKtlFbRpz/Xprx8r2v4KGILg==
X-Received: by 2002:a1c:a942:0:b0:380:ead5:c4e2 with SMTP id s63-20020a1ca942000000b00380ead5c4e2mr3365248wme.100.1645625030068;
        Wed, 23 Feb 2022 06:03:50 -0800 (PST)
Received: from ?IPV6:2a01:e0a:b41:c160:5d35:a5e8:9cb4:e326? ([2a01:e0a:b41:c160:5d35:a5e8:9cb4:e326])
        by smtp.gmail.com with ESMTPSA id e9sm2853530wrx.3.2022.02.23.06.03.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 06:03:49 -0800 (PST)
Message-ID: <5ec208c6-fd92-afcf-1ff3-5c973025d385@6wind.com>
Date:   Wed, 23 Feb 2022 15:03:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH libnetfilter_queue] libnetfilter_queue: add support of
 skb->priority
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
References: <Yfy2YxiwvDLtLvTo@salvia>
 <20220204102637.4272-1-nicolas.dichtel@6wind.com>
 <8c08a4e0-83a0-9fc1-798b-dbd6a53f7231@6wind.com>
 <20220204120126.GB15954@breakpoint.cc> <Yf02PG/793enEF4r@salvia>
 <e926bd60-7653-f528-ec15-2758a4ffc89a@6wind.com> <YhYLRLl9pJrdgsq1@salvia>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <YhYLRLl9pJrdgsq1@salvia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


Le 23/02/2022 à 11:24, Pablo Neira Ayuso a écrit :
[snip]
>> If I understand well, libnetfilter_queue is deprecated?
> 
> This library is not deprecated.
Oh ok, sorry for my misunderstanding.
So my patch is relevant?
