Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 890DDC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Jan 2022 13:56:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347022AbiAaN4H (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 31 Jan 2022 08:56:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245129AbiAaN4G (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Jan 2022 08:56:06 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725B9C061714
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jan 2022 05:56:06 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id j16so12390465plx.4
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jan 2022 05:56:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=oViNWJgyGHeSX3j/iZTubDLC0HiCr8LNpamMAqF56no=;
        b=HdaTwCJJZDhY2E9wda1DDaixI63ZEnBPd9RBwHKQEVBlT2CT8itKtNZLazqOsgMi/e
         VQzBOhi58OLcmhshf8nlCmuzMQYl63UOGzH4tBskLIL8hYPt/qqfg0qahn9/eCv37skV
         VxzpeH7q1/gqVJlxSfqGTCJDN38xrpF2nATIiJeMnhHpmRXJe8PgpXHKaxG3tzhyUZHn
         1mumGwqvcphbAUCcGXFc83sDfLp7qlklTNw/QRoftnP7YWPKgrxDR3kUQpfE4eebBF6o
         V3z+KVAveMhB7qSriYYr/shSYNmJV7zPKIQUBoGk9od1touzrHLG5iD0e6sX++eRIHPa
         Og4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=oViNWJgyGHeSX3j/iZTubDLC0HiCr8LNpamMAqF56no=;
        b=HBnbYX2IGMPqspQGKaDVVLYRqTQts9t1O8Uds1v4ztr+/jUU0WXhDfyC+19HgI0jew
         uLITowDWCSxsBy7p4XG1gNSbYboj9TuglKYRGVt7VWYOWWwO1TupoIZhKJj7U4EQLIEr
         cU1WRqAJD2ar//Yll7eTWaDU+mra7P8Q1zrPu/PIh5cDVZm5U20PR+UFhR2Z6C58Oypf
         Nrr3D63oEHHtVJIwGEvfFgdnAaNprWM++Ykm9u0iO1Lscfc5vJnabnYDI0NVGu7MFFbF
         Vz4y2YkgwZ36njmZWudfnr7XBSrT/4WQaf/jUhZiwrFiEY1AB1s+ou2Bp1vYUaswzrs2
         qzBA==
X-Gm-Message-State: AOAM532qLcdDbbciAOGtpAMRdErPArs+CKx6WmP2ilSeQclJuN7yg4qL
        ciS2gaX1+AvxhNZ2Mk64j5ZkbKJBVlM=
X-Google-Smtp-Source: ABdhPJwQEzQHOVutweT6+kDAPqjfwEnCLsxw4m7aqXp2R2wvxXoyGEBDdr3aH9gnIlV2nUL5q8i7Og==
X-Received: by 2002:a17:90b:1d0a:: with SMTP id on10mr34132642pjb.79.1643637365987;
        Mon, 31 Jan 2022 05:56:05 -0800 (PST)
Received: from [192.168.1.6] ([14.166.72.108])
        by smtp.gmail.com with ESMTPSA id oc17sm12393359pjb.12.2022.01.31.05.56.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 05:56:05 -0800 (PST)
Message-ID: <a99d71b5-6d25-491c-3285-70dac3e2954b@gmail.com>
Date:   Mon, 31 Jan 2022 20:55:44 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: PROBLEM: Injected conntrack lost helper
Content-Language: en-US
From:   Pham Thanh Tuyen <phamtyn@gmail.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
References: <f9fb5616-0b37-d76b-74e5-53751d473432@gmail.com>
 <3f416429-b1be-b51a-c4ef-6274def33258@iogearbox.net>
 <0f4edf58-7b4e-05e8-3f13-d34819b8d5db@gmail.com>
 <20220131112050.GQ25922@breakpoint.cc>
 <43a50970-a08f-3956-7ff1-a2ad0ac51694@gmail.com>
In-Reply-To: <43a50970-a08f-3956-7ff1-a2ad0ac51694@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

1. Make sure to disable automatic helper assignment using the command 
'sudo sysctl -w net.netfilter.nf_conntrack_helper=0'
2. Use NAT
3. Set up a fault tolerant firewall system and then make the active 
firewall machine to fail. The backup firewall machine will recover the 
connection but lose the helper. (Simpler way is to use conntrack -I to 
inject the conntrack).

On 1/31/22 20:47, Pham Thanh Tuyen wrote:
> 1. Make sure to disable automatic helper assignment using the command 
> 'sudo sysctl net.netfilter.nf_conntrack_helper=0'
> 2. Use NAT
> 3. Set up a fault tolerant firewall system and then make the active 
> firewall machine to fail. The backup firewall machine will recover the 
> connection but lose the helper. (Simpler way is to use conntrack -I to 
> inject the conntrack).
>
>
> On 1/31/22 18:20, Florian Westphal wrote:
>> Pham Thanh Tuyen <phamtyn@gmail.com> wrote:
>>
>> [ moving to netfilter-devel ]
>>
>>>>> My name is Pham Thanh Tuyen. I found a bug related to the ctnetlink
>>>>> and conntrack subsystems. Details are as follows:
>>>>>
>>>>> 1. Summary: Injected conntrack lost helper
>>>>>
>>>>> 2. Description: When a conntrack whose helper is injected from
>>>>> userspace, the ctnetlink creates helper for it but NAT then loses
>>>>> the helper in case the user defined helper explicitly with CT
>>>>> target.
>> Hmm.  If you insert a conntrack entry from userspace, it will already
>> be confirmed, so nat rules will have no effect, and template CT rules
>> are irrelevant wrt. to the helper, as extension can only be created if
>> the conntrack is not in the hash yet.
>>
>> Can you describe the steps to reproduce this bug?
