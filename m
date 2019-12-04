Return-Path: <SRS0=sEEs=Z2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E753C43603
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 17:31:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32AF42077B
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 17:31:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbfLDRbI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 12:31:08 -0500
Received: from mail-wm1-f54.google.com ([209.85.128.54]:36522 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbfLDRbH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 12:31:07 -0500
Received: by mail-wm1-f54.google.com with SMTP id p17so640514wma.1
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Dec 2019 09:31:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt:cc
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=tcEtemrxI2lV3zUur11gG0jvrt+L8O40rV42+goQkjg=;
        b=Ysk1pt3Sl03BGDJrtavjuWji58o4g31ld2DERwokgnyTWoIwNGUdIuMNQ9BJvRyQSH
         j1ISA5xD6jlJbpcSqdm6KMg8Z66sDQO4go3Lyc/eLrSLdse+XWXvUuwdz50Z0UU66teY
         voJFd7dHp0esbCyDYexlYtvX986XDmuEjGYfyP1eILhRHPsoXTCRn2I/8dZ50cdIAbMr
         52exCGDdaE9AdCRQ1AqltWZXh2nhQjaGdlB3SxJHPVl4GCMrtFY6WSFh9Uu+ml7e90B+
         Odn2j4bdZRfLlw6qgA+D5u0JAmJyMSZ0Ho08pRNMJOPtKyEiKgGH0V/8mlTFk7ncvn0e
         eevQ==
X-Gm-Message-State: APjAAAUD/hSu9dm/L7NkdulJ4R4Q3Z3IHE3QRPBQZqH3WXJ5hhnvJEp6
        AAbvlDTW5PST0I7WGyALD7ovRT9c3T0=
X-Google-Smtp-Source: APXvYqwEd5Jx6OvibZuAAufydN4s20O4bP/ob8MRKUpZW4CiJZclUdkco7DusBboMiirgTEI+BIGBg==
X-Received: by 2002:a7b:c318:: with SMTP id k24mr704539wmj.54.1575480664294;
        Wed, 04 Dec 2019 09:31:04 -0800 (PST)
Received: from [192.168.1.156] ([213.194.138.68])
        by smtp.gmail.com with ESMTPSA id d8sm8984293wre.13.2019.12.04.09.31.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2019 09:31:03 -0800 (PST)
Subject: Re: Numen with reference to vmap
To:     Phil Sutter <phil@nwl.cc>,
        "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
References: <EC8889A1-27E2-4DC9-B752-514689982085@cisco.com>
 <20191204101819.GN8016@orbyte.nwl.cc>
 <AFC93A41-C4DD-4336-9A62-6B9C6817D198@cisco.com>
 <20191204151738.GR14469@orbyte.nwl.cc>
 <5337E60B-E81D-46ED-912F-196E23C76701@cisco.com>
 <20191204155619.GU14469@orbyte.nwl.cc>
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
Openpgp: preference=signencrypt
Autocrypt: addr=arturo@netfilter.org; keydata=
 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
 EXgmBmyUKrJkh/zvupp9t9Y2ioPbcMObRIEXio4=
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Message-ID: <624cc1ac-126e-8ad3-3faa-f7869f7d2d5b@netfilter.org>
Date:   Wed, 4 Dec 2019 18:31:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191204155619.GU14469@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 12/4/19 4:56 PM, Phil Sutter wrote:
> OK, static load-balancing between two services - no big deal. :)
> 
> What happens if config changes? I.e., if one of the endpoints goes down
> or a third one is added? (That's the thing we're discussing right now,
> aren't we?)

if the non-anon map for random numgen was allowed, then only elements would need
to be adjusted:

dnat numgen random mod 100 map { 0-49 : 1.1.1.1, 50-99 : 2.2.2.2 }

You could always use mod 100 (or 10000 if you want) and just play with the map
probabilities by updating map elements. This is a valid use case I think.
The mod number can just be the max number of allowed endpoints per service in
kubernetes.

@Phil,

I'm not sure if the typeof() thingy will work in this case, since the integer
length would depend on the mod value used.
What about introducing something like an explicit u128 integer datatype. Perhaps
it's useful for other use cases too...

@Serguei,

kubernetes implements a complex chain of mechanisms to deal with traffic. What
happens if endpoints for a given svc have different ports? I don't know if
that's supported or not, but then this approach wouldn't work either: you can't
use dnat numgen randmo { 0-49 : <ip>:<port> }.

Also, we have the masquerade/drop thing going on too, which needs to be deal
with and that currently is done by yet another chain jump + packet mark.

I'm not sure in which state of the development you are, but this is my
suggestion: Try to don't over-optimize in the first iteration. Just get a
working nft ruleset with the few optimization that make sense and are easy to
use (and understand). For iteration #2 we can do better optimizations, including
patching missing features we may have in nftables.
I really want a ruleset with very little rules, but we are still comparing with
the iptables ruleset. I suggest we leave the hard optimization for a later point
when we are comparing nft vs nft rulesets.
