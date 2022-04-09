Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB795C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Apr 2022 10:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235155AbiDIKMM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Apr 2022 06:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233129AbiDIKML (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Apr 2022 06:12:11 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985971F630
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Apr 2022 03:10:04 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 17so14327761lji.1
        for <netfilter-devel@vger.kernel.org>; Sat, 09 Apr 2022 03:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=13kNLrpcb9bB8R2CSI8RfGW9kWrMJ+C26IherGyLOaw=;
        b=Yu21RRSynlpcb3p6OsUW/xgQDYqShzn6ykubq97jXZ8wdHDJ81M5wTmIF7HKXUWQQg
         hLiuLcOpcc+sSqWdxOxOQ6+9wKeOpo1ERL/LqzvP+/N/m6MN6DqFtHW50TiqzqKdz9/i
         dxyGSeCnrH/xEgKwgffzAP0Wk3eIk0ZSY+yL1+9BW+Omp7mprWZqdA64TCJ8ArPeZDro
         7hSlgofl2FwZs7kutX9PZhNHJeQCnQ65dp3ej0EmhUqgkMt51EsLZOkvL3u5ZmSxLuXz
         LdbbJvlZL0hEWygCmJAQSVhS6bInW9hfPZSkSpKUmmW2c7BWjtvVDqeBDMTj2wuwC+Vf
         cdzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=13kNLrpcb9bB8R2CSI8RfGW9kWrMJ+C26IherGyLOaw=;
        b=KTdr05Ejc58CS3UJw3Fn2NbIgIg+4Fsqd3ELiADXqyy/9Rq0tsSBtEBgzOV3xBKKgE
         G9qvQTXtEhSL8bjCwik9XG8QhIcaavB/llUe1HaWGGwpuo4rsB92evFGSkYScAOJsLqA
         fOkyKnlmhDOJHmejeDGZoKv6W++MEjTrSHXZolymGCwnjI1vUme1aY0srOSHSD7pdcx4
         0+DTh7K5ggoCtz4EAKc/mISG07MC/F+9VibEmep0czrSBapoiv69GcD1uBqPJLfrTov4
         6CvNmnvF3VE2ixkbcxipcV0WinFxK2MztK8jXJmRHfNo6M+WYvURzTHTfp29UzYWhTqx
         /Oqw==
X-Gm-Message-State: AOAM530Fmf2VAHjOs1q5bADOZbxbXcUCffbmoTrERr0fy8DUY8pBPiF3
        Oa45m4EzIjd86dscXfTI1n0Abis+UYQ=
X-Google-Smtp-Source: ABdhPJwXBba6iN1A1jfc+4x3rb+Vbcog+6+vQOoO06/0T/ODzwuHed+2N9QTa7EcVYsU3OaG9H3nYA==
X-Received: by 2002:a05:651c:198d:b0:24b:4b3f:b859 with SMTP id bx13-20020a05651c198d00b0024b4b3fb859mr5854152ljb.228.1649499002748;
        Sat, 09 Apr 2022 03:10:02 -0700 (PDT)
Received: from [192.168.1.38] (91-159-150-194.elisa-laajakaista.fi. [91.159.150.194])
        by smtp.gmail.com with ESMTPSA id j15-20020a056512108f00b0044a3cc8769dsm2691764lfg.123.2022.04.09.03.10.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Apr 2022 03:10:02 -0700 (PDT)
Message-ID: <9277ac40-4175-62b3-d777-bdfa9434d187@gmail.com>
Date:   Sat, 9 Apr 2022 13:10:00 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] doc: Document that kernel may accept unimplemented
 expressions
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
References: <20220409094402.22567-1-toiwoton@gmail.com>
 <20220409095152.GA19371@breakpoint.cc>
From:   Topi Miettinen <toiwoton@gmail.com>
In-Reply-To: <20220409095152.GA19371@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 9.4.2022 12.51, Florian Westphal wrote:
> Topi Miettinen <toiwoton@gmail.com> wrote:
>> Kernel silently accepts input chain filters using meta skuid, meta
>> skgid, meta cgroup or socket cgroupv2 expressions but they don't work
>> yet. Warn the users of this possibility.
>>
>> Signed-off-by: Topi Miettinen <toiwoton@gmail.com>
>> ---
>>   doc/nft.txt | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/doc/nft.txt b/doc/nft.txt
>> index f7a53ac9..4820b4ae 100644
>> --- a/doc/nft.txt
>> +++ b/doc/nft.txt
>> @@ -932,6 +932,11 @@ filter output oif wlan0
>>   ^^^^^^^^^^^^^^^^^^^^^^^
>>   ---------------------------------
>>   
>> +Note that the kernel may accept expressions without errors even if it
>> +doesn't implement the feature. For example, input chain filters using
>> +*meta skuid*, *meta skgid*, *meta cgroup* or *socket cgroupv2*
>> +expressions are silently accepted but they don't work yet.
> 
> Thats not correct.
> 
> Those expressions load values from skb->sk, i.e. the socket associated
> with the packet.
> 
> In input, such socket may exist, either because of tproxy rules, early
> demux, or bpf programs.

Thanks. How about:
Note that the kernel may accept expressions without errors even if it
doesn't implement the feature. For example, input chain filters using
*meta skuid*, *meta skgid*, *meta cgroup* or *socket cgroupv2*
expressions are silently accepted but they don't work yet, except when 
used with *tproxy* rules, early demultiplexing or BPF programs.

Could you please explain this 'early demux' concept? Is this something 
that can be triggered with NFT rules, kernel configuration etc? I can't 
find any documentation.

-Topi

