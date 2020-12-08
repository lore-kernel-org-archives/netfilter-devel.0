Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14ECAC4361B
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Dec 2020 14:46:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D96E323A6A
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Dec 2020 14:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729817AbgLHOqT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Dec 2020 09:46:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729441AbgLHOqS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Dec 2020 09:46:18 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A833C061749
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Dec 2020 06:45:38 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id l9so7348528wrt.13
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Dec 2020 06:45:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3XNO/f3By/6slfoGMEGF4/3HOHm+FDzXIGSmzjkSrZw=;
        b=Oto9br1Ol3WYYN1kUebJjI9+/z+umS0HIbUUg81KaxP1wgvLD21TIOPeja62VGkkGB
         ViMRfj++ZRNkzZurKxVRdTQu4F+Sa3jOl1aqTvm4BSXb6hbaUCLMPF7snQg0VrCjSKzc
         d/eYcgfEnnnK108pPWr1+2KYsD/X52FdQIeM6IsdwEldQFnuIt1W6uHWGuaFmg0Pvn8y
         wML+hvI7c/QRLGUUgk7AOKeGj/vy/yCNfjDeVMrg1+zGCdOp/9Q35aPj0vBElkAluJcM
         yT+Ge5rt4gcGPYJyREgYUfh1gTh4Skmvlb5hfO2mnKeEiik2AOzUeK1+16G4z4tGE2d9
         vjdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=3XNO/f3By/6slfoGMEGF4/3HOHm+FDzXIGSmzjkSrZw=;
        b=tbaiFfLnwSNrZMgfWzjt+QWi+GSb7r1c+BohfmOpzWmQCMI9Z9SIY4f1+D+LR8icST
         9NiX/qksl28d3hC34hhsG1MErCAmKJNjGlAGlUh/s4HqfYfV2VfIFAPQeJSzzYsDCp+B
         nmGmCejpYjPJ/asqSKGlsbrtf1Xd11Przh7RJQEZwiBhZDDnzi4iQxKr50CxRD+vj4QN
         mDrr7mR9yr+2YdVaruw0vSLHOcDMFRPeX5iRfmI5mIoBQGF0j1LHoEI4pmYTyKImeWAb
         mct7iRW9DYTZSWL+4+lWyEin3XGIm5QSAs6ZhitWVt41mRFp7/UdJrH5Q68LRqt1cZRC
         Eljw==
X-Gm-Message-State: AOAM5317U16vPSD9m51tcCBDgDUydV6Bz2XMweQWEtRGcNsDv5Cb5fBV
        wSHlR2YujovyKd5zbTE97rzzY5F0LegG0g==
X-Google-Smtp-Source: ABdhPJwMXhZb2++JoFDAW/+YsPNXB0a4RXFXkQzYYCrz/OIcTAVUzwIXTkXfl4XRqAm1PplwexqNcQ==
X-Received: by 2002:a5d:504d:: with SMTP id h13mr4570094wrt.246.1607438736991;
        Tue, 08 Dec 2020 06:45:36 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:c0bd:aca3:59fd:a9c1? ([2a01:e0a:410:bb00:c0bd:aca3:59fd:a9c1])
        by smtp.gmail.com with ESMTPSA id n12sm10710949wrg.76.2020.12.08.06.45.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 06:45:36 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH v2] xfrm: interface: Don't hide plain packets from
 netfilter
To:     Phil Sutter <phil@nwl.cc>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20201207134309.16762-1-phil@nwl.cc>
 <9d9cb6dc-32a3-ff1a-5111-7688ce7a2897@6wind.com>
 <20201208140013.GX4647@orbyte.nwl.cc>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <29cef7a5-ca02-d07a-4f6f-c029cd32cbb6@6wind.com>
Date:   Tue, 8 Dec 2020 15:45:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201208140013.GX4647@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Le 08/12/2020 à 15:00, Phil Sutter a écrit :
> Hi Nicolas,
> 
> On Tue, Dec 08, 2020 at 10:02:16AM +0100, Nicolas Dichtel wrote:
>> Le 07/12/2020 à 14:43, Phil Sutter a écrit :
> [...]
>>> diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
>>> index aa4cdcf69d471..24af61c95b4d4 100644
>>> --- a/net/xfrm/xfrm_interface.c
>>> +++ b/net/xfrm/xfrm_interface.c
>>> @@ -317,7 +317,8 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
>>>  	skb_dst_set(skb, dst);
>>>  	skb->dev = tdev;
>>>  
>>> -	err = dst_output(xi->net, skb->sk, skb);
>>> +	err = NF_HOOK(skb_dst(skb)->ops->family, NF_INET_LOCAL_OUT, xi->net,
>> skb->protocol must be correctly set, maybe better to use it instead of
>> skb_dst(skb)->ops->family?
> 
> skb->protocol holds ETH_P_* values in network byte order, NF_HOOK()
> expects an NFPROTO_* value, so this would at least not be a simple
Yes, right. I forgot that.

> 
>>> +		      skb->sk, skb, NULL, skb_dst(skb)->dev, dst_output);
>> And here, tdev instead of skb_dst(skb)->dev ?
> 
> Well yes, tdev was set to dst->dev earlier. Likewise I could use dst
> directly instead of skb_dst(skb) to simplify the call a bit further.
> OTOH I like how in the version above it is clear that skb's dst should
> be used, irrespective of the code above (and any later changes that may
> receive). No strong opinion though, so if your version is regarded the
> preferred one, I'm fine with that.
I would vote for tdev, because:
 - the reader don't have to wonder why tdev is used for dst->dev and not
   for NF_HOOK();
 - tdev has probably been declared so that dst->dev is dereferenced only once;
 - using the same variable everywhere in the function eases code reading.


Thank you,
Nicolas
