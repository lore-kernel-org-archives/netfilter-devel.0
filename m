Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F390C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Mar 2022 14:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240655AbiC1OKS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Mar 2022 10:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239195AbiC1OKS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Mar 2022 10:10:18 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B55771FA40
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Mar 2022 07:08:36 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id p15so24955387lfk.8
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Mar 2022 07:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=dNaWoFBQl42JnurNbxUUGkEYzWS5L67+NKZmHA13DiM=;
        b=p26BC/kitbRSlNVw1wtGMU8zaoIONFzLLkAunJaH138GbQMMgP/W13lQYWBzPZ4fZz
         /5XzCQCRm0U//mE076Gu2TRdwZzTbmW/JkTvjjS/6os1yIqYtxvTrGT4iFWbcWRAZGfe
         /LicdmTDpkxUpqF9XWAnYsfPFErG2PZxlqWIFnyhgmwYka359eCUsqsgQVdBhxX1MEF3
         h9pM7ldvbSgZteK2Uq0LaNcOCaUhwkWORHt9U+19f3qK3ZncaJywdENxJdLsOo0TjqYR
         XEUQfzqme3W6TYLKEBcOjb0XUvCcgzqHwcNIqcz+S/NtLe8fbJzekllR0ufSil6S4Uay
         BTfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dNaWoFBQl42JnurNbxUUGkEYzWS5L67+NKZmHA13DiM=;
        b=PAvByS7/M5txWo/0mw6TbqKqXOs0Iuv3PljR9K2gEE+RqFfyia0QKfLfNfemaHs4Ly
         /KPNxENE8td4L6x8Z+4DAltdEKTVe8IFo+Ovh59uatr5uMxaspeKW+EIxmA5ej/2mJwa
         UEcqPF145tY0YVdLJu2oSwe/1EabLoZ4VTHueWxYjnf/lNkKU1pzbgK4lIK5nwUP7NwA
         Hnn3clE7oDvoWyIa8OoWVmljsIouhHqLub6tgdZ5RpCHP6gN2vLRKLfuUIuAl96qKBua
         6tST1YEbIn8vAHaTDybEvPWIpLtejvzdfrrHBNwJXoIMScJWdcnpy1T5qeAcxvkAVdF9
         PcFQ==
X-Gm-Message-State: AOAM533VPeMXzfdr+p1vJo9oqEMJg/jbTvT58tikTHxkog0QFW4PmxYh
        71GvDb7gP7HXlomVtH6owDCaf5+MNOY=
X-Google-Smtp-Source: ABdhPJyKISSC++DRTA1rd5fBXS+QnAOUWgtDBGuR63PUzDcffmimk3b4grRA1Hv8UFtv7TVMzkw90g==
X-Received: by 2002:a05:6512:1193:b0:44a:6936:49b1 with SMTP id g19-20020a056512119300b0044a693649b1mr17235645lfr.414.1648476514945;
        Mon, 28 Mar 2022 07:08:34 -0700 (PDT)
Received: from [192.168.1.40] (91-159-150-194.elisa-laajakaista.fi. [91.159.150.194])
        by smtp.gmail.com with ESMTPSA id u6-20020a2e9f06000000b002498bf439d1sm1720854ljk.134.2022.03.28.07.08.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Mar 2022 07:08:34 -0700 (PDT)
Message-ID: <418f6461-4504-4707-5ec2-61227af2ad27@gmail.com>
Date:   Mon, 28 Mar 2022 17:08:32 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: Support for loading firewall rules with cgroup(v2) expressions
 early
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <fabde324-383a-622c-7e69-32c9b2d06191@gmail.com>
 <YkDXwaPwYf8NgKT+@salvia>
From:   Topi Miettinen <toiwoton@gmail.com>
In-Reply-To: <YkDXwaPwYf8NgKT+@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 28.3.2022 0.31, Pablo Neira Ayuso wrote:
> Hi,
> 
> On Sat, Mar 26, 2022 at 12:09:26PM +0200, Topi Miettinen wrote:
>> Hi,
>>
>> I'd like to use cgroupv2 expressions in firewall rules. But since the rules
>> are loaded very early in the boot, the expressions are rejected since the
>> target cgroups are not realized until much later.
>>
>> Would it be possible to add new cgroupv2 expressions which defer the check
>> until actual use? For example, 'cgroupv2name' (like iifname etc.) would
>> check the cgroup path string at rule use time?
>>
>> Another possibility would be to hook into cgroup directory creation logic in
>> kernel so that when the cgroup is created, part of the path checks are
>> performed or something else which would allow non-existent cgroups to be
>> used. Then the NFT syntax would not need changing, but the expressions would
>> "just work" even when loaded early.
> 
> Could you use inotify/dnotify/eventfd to track these updates from
> userspace and update the nftables sets accordingly? AFAIK, this is
> available to cgroupsv2.

It's possible, there's for example:
https://github.com/mk-fg/systemd-cgroup-nftables-policy-manager
https://github.com/helsinki-systems/nft_cgroupv2/

But I think that with this approach, depending on system load, there 
could be a vulnerable time window where the rules aren't loaded yet but 
the process which is supposed to be protected by the rules has already 
started running. This isn't desirable for firewalls, so I'd like to have 
a way for loading the firewall rules as early as possible.

-Topi

> 
>> Indirection through sets ('socket cgroupv2 level @lvl @cgname drop') might
>> work in some cases, but it would need support from cgroup manager like
>> systemd which would manage the sets. This would also probably not be
>> scalable to unprivileged users or containers.
>>
>> This also applies to old cgroup (v1) expression but that's probably not
>> worth improving anymore.
>>
>> Related work on systemd side:
>> https://github.com/systemd/systemd/issues/22527
>>
>> -Topi

