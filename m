Return-Path: <SRS0=bgPs=S7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7E1CC43219
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Apr 2019 15:39:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B613A20675
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Apr 2019 15:39:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b="ibYJ3gPs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbfD2Pjs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 29 Apr 2019 11:39:48 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46954 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728394AbfD2Pjr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Apr 2019 11:39:47 -0400
Received: by mail-wr1-f68.google.com with SMTP id t17so16672856wrw.13
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Apr 2019 08:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dGFkoTu0Keh5FErbv2jHaILuGkugGYnVDjqnoguNPM4=;
        b=ibYJ3gPsKZ1B4W8dM/PLKaWNyb4BBULchwqZh7iwHh0ATtxXFtWqjVgfnhQsNeAM4e
         NgMYzalB1tl3v5qMhwIL0INC3LJFoNMxo3JPMF9M2E39Jtx0m3HQWp+HAYpqDRroX+Sc
         fwgZxlf2Hdy01suXXk9PkiGrzJ7lBHYZiMbpT+Bzbist2gaLI/HYTiNVlLmN6GHsSEV4
         pLzijMjRNif3Zt8Yhixo+NGsrG3AJAmHL4SK1nNJaxwRSdlWtXT7/AboCq4GM3aCxD0A
         22bnRjmmuYafAnOXPx7kTMp8gn4OWN8KVm6ZiveyCCRmZ1S0FAVrw1lGhUtGfJ5wBgcs
         YiBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=dGFkoTu0Keh5FErbv2jHaILuGkugGYnVDjqnoguNPM4=;
        b=mDYPe4U/R1irrV/fDxbg9rjfOSPrzhr/bwgUP2wFtNdcDNt9pgQnHHTuqu1T5PdjLE
         W+Ri9tvgobQENme/+ADqRfuSCb8U6MEev/6AmU7esa3IACmpNbAao1K/zEKUW4Rpq3E4
         gBURlj1afkdLvQasWUcAN2wn2LGm/xau8auL2Qdkgyv9RcGCfg1UAwMlLl5Cifv2V7jW
         blBKKDdNbGyPAI0+n9zluJTljB3HJvDLfQ+rycCvKccKBWgSsIZfbJGzIIYOcFxYG5np
         uhLyjHN0zE2KxAb9SKX3VjMwBczuaM7Py+AEXdNLkWSkz4JsG+OE5+0ngwpuZ723URen
         2wHw==
X-Gm-Message-State: APjAAAUYMMqgdbAbaMfTPJNQNmVNLpzwW1uuuATv6wGxYCuTA4wF3MV5
        Dy7i66dun3dw8AcuzEnfST717Q==
X-Google-Smtp-Source: APXvYqzSaD5tWV67H+tmILOKQi7XkkbdL99mWq6/GBV5/V+WJDLJRpEiBZNvGM2fP61sYTc2krQmKw==
X-Received: by 2002:adf:edc8:: with SMTP id v8mr11132484wro.206.1556552386144;
        Mon, 29 Apr 2019 08:39:46 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:a94e:84d3:3ed8:cdcd? ([2a01:e35:8b63:dc30:a94e:84d3:3ed8:cdcd])
        by smtp.gmail.com with ESMTPSA id a4sm44590924wmf.45.2019.04.29.08.39.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 08:39:45 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH 07/31] netfilter: ctnetlink: Support L3 protocol-filter on
 flush
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Kristian Evensen <kristian.evensen@gmail.com>,
        davem@davemloft.net, netdev@vger.kernel.org
References: <20181008230125.2330-1-pablo@netfilter.org>
 <20181008230125.2330-8-pablo@netfilter.org>
 <33d60747-7550-1fba-a068-9b78aaedbc26@6wind.com>
 <09d0cd50-b64d-72c3-0aa1-82eb461bfa19@6wind.com>
 <20190426192529.yxzpunyenmk4yfk3@salvia>
 <2dc9a105-930b-83b1-130f-891d941dc09b@6wind.com>
 <20190429152357.kwah6tvdwax6ae7p@salvia>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <fbafb8db-4a07-9836-5765-afd9ca683cb8@6wind.com>
Date:   Mon, 29 Apr 2019 17:39:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190429152357.kwah6tvdwax6ae7p@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Le 29/04/2019 à 17:23, Pablo Neira Ayuso a écrit :
> On Mon, Apr 29, 2019 at 04:53:38PM +0200, Nicolas Dichtel wrote:
>> Le 26/04/2019 à 21:25, Pablo Neira Ayuso a écrit :
>>> On Thu, Apr 25, 2019 at 05:41:45PM +0200, Nicolas Dichtel wrote:
>>>> Le 25/04/2019 à 12:07, Nicolas Dichtel a écrit :
>>>> [snip]
>>>>> In fact, the conntrack tool set by default the family to AF_INET and forbid to
>>>>> set the family to something else (the '-f' option is not allowed for the command
>>>>> 'flush').
>>>>
>>>> 'conntrack -D -f ipv6' will do the job, but this is still a regression.
>>>
>>> You mean, before this patch, flush was ignoring the family, and after
>>> Kristian's patch, it forces you to use NFPROTO_UNSPEC to achieve the
>>> same thing, right?
>>>
>> Before the patch, flush was ignoring the family, and after the patch, the flush
>> takes care of the family.
>> The conntrack tool has always set the family to AF_INET by default, thus, since
>> this patch, only ipv4 conntracks are flushed with 'conntrack -F':
>> https://git.netfilter.org/conntrack-tools/tree/src/conntrack.c#n2565
>> https://git.netfilter.org/conntrack-tools/tree/src/conntrack.c#n2796
> 
> Thanks for explaining, what fix would you propose for this?
> 
The least bad fix I see is adding a new attribute, something like
CTA_FLUSH_FAMILY, to be used by the flush filter (and ignoring struct
nfgenmsg->nfgen_family in this flush filter).
The drawback is that it will break the (relatively new) users of this feature
(the patch has been pushed in v4.20).


Regards,
Nicolas
