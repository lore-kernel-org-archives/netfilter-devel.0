Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4153BC77B77
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Apr 2023 14:54:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbjDNOyR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Apr 2023 10:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbjDNOyP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Apr 2023 10:54:15 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE1D56E81
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2023 07:54:12 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id n42-20020a05600c3baa00b003f0b12814aaso1201500wms.0
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2023 07:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent.com; s=google; t=1681484051; x=1684076051;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1A7ZSVf1BhK+9yewFxnkXX4VoW3YFa+MPkogSUd0yk0=;
        b=NFmoc3guYz1AgkKQeiNBB3iVKKxrOlqz4selXLgRkwIXXKXLObcpH1O1sBJTw7L1dP
         cUpAS939JAF5ixSWu/HAo9V1INYeV0259CBHmleDLWx2kIvZq1tbSMrMKPHFg+omSlOI
         cw8JxlV+LjeEu0nhVW7cV7yXuQqvqiHNrdDS5wlgr9hHnCQB4ijeCC6kTmcMaEbunrnh
         laJ9mNgE38sgpj3Ql1fCWssPqFytub9y6Nx2cX5Ii6YnjulKp49parb5FC+7Hn7riTwL
         6mDc5NjgQ5qt2lRzeCoxxdr6VthKFGkscIb9NGMF89zFn5N0BJdxrC6hrVEzSgG7Qev/
         UCWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681484051; x=1684076051;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1A7ZSVf1BhK+9yewFxnkXX4VoW3YFa+MPkogSUd0yk0=;
        b=G+/dJHKbr6EOH4QJ3K6bTf+FLMRFGnYm2FeeOKI7FxqJNQ4f/HDmMtfB3cPxTYwohw
         /IA2X4+ig7JzWk4SfTZaxP4dFMbor9NZbiO1agEP/2VyGYXp/WdG1VF0tk/Qkh1huKqF
         bHkSVtlJ2ZmDckKxIrcJPIchJAkm7WrE4OrrphIRVO+tAczPNwKKbpcfCC0obYFM1UbB
         0T2IjvYoPfIWxjN/edj2TmbixAKoa6nwBgiT7xfmqZg2TcOmIhIiKBWLhEU6ikma6fes
         UJyodyQFQuLVDjCaHSF6ex+zvX829IdJdyOvRvkiV3n0Aup9XSH0Jyv8tXHYiHjQ9FiA
         pYnw==
X-Gm-Message-State: AAQBX9dr+edlH1AqHrIAJE9bZGXSLDfNunxKnLuMksBRS+4flWSfWMJ/
        a2fQoN6Wtj/tZ7/phb3hKE3cSw==
X-Google-Smtp-Source: AKy350b4U7kut2mxBwLdHFOTz07KnhVYQpSLrCaf5C6bGYVVi/j6tkwTgDVzfQzylL58f43X36N7iQ==
X-Received: by 2002:a05:600c:c5:b0:3ed:93de:49ff with SMTP id u5-20020a05600c00c500b003ed93de49ffmr4754573wmm.0.1681484051219;
        Fri, 14 Apr 2023 07:54:11 -0700 (PDT)
Received: from ?IPV6:2a02:8011:e80c:0:d040:969c:6e8e:e95d? ([2a02:8011:e80c:0:d040:969c:6e8e:e95d])
        by smtp.gmail.com with ESMTPSA id w16-20020a5d6810000000b002e5ff05765esm3749528wru.73.2023.04.14.07.54.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Apr 2023 07:54:10 -0700 (PDT)
Message-ID: <f4c7eaff-b0d9-0797-71bd-8766ae9e9eb5@isovalent.com>
Date:   Fri, 14 Apr 2023 15:54:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH bpf-next v2 5/6] tools: bpftool: print netfilter link info
Content-Language: en-GB
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        bpf@vger.kernel.org, dxu@dxuuu.xyz, qde@naccy.de
References: <20230413133228.20790-1-fw@strlen.de>
 <20230413133228.20790-6-fw@strlen.de>
 <CACdoK4LRjNsDY6m2fvUGY_C9gMvUdX9QpEetr9RtGuR8xb8pmg@mail.gmail.com>
 <20230414104121.GB5889@breakpoint.cc>
 <eeeaac99-9053-90c2-aa33-cc1ecb1ae9ca@isovalent.com>
 <20230414144927.GA5927@breakpoint.cc>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <20230414144927.GA5927@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

2023-04-14 16:49 UTC+0200 ~ Florian Westphal <fw@strlen.de>
> Quentin Monnet <quentin@isovalent.com> wrote:
>> 2023-04-14 12:41 UTC+0200 ~ Florian Westphal <fw@strlen.de>
>>> Quentin Monnet <quentin@isovalent.com> wrote:
>>>> On Thu, 13 Apr 2023 at 14:36, Florian Westphal <fw@strlen.de> wrote:
>>>>>
>>>>> Dump protocol family, hook and priority value:
>>>>> $ bpftool link
>>>>> 2: type 10  prog 20
>>>>
>>>> Could you please update link_type_name in libbpf (libbpf.c) so that we
>>>> display "netfilter" here instead of "type 10"?
>>>
>>> Done.
>>
>> Thanks!
>>
>> I'm just thinking we could also maybe print something nicer for the pf
>> and the hook, "NF_INET_LOCAL_IN" would be more user-friendly than "hook 1"?
> 
> Done.  I've also made the first patch more restrictive wrt. allowed
> attachment points and priorities.
> 
> Better safe than sorry, we can be more liberal later if there are
> use-cases.
> 
> v3 will be coming next week.
> 
>>> I don't know how to make it work to actually attach it, because
>>> the hook is unregistered when the link fd is closed.
>>>
>>> So either bpftool would have to fork and auto-daemon (maybe
>>> unexpected...) or wait/block until CTRL-C.
>>>
>>> This also needs new libbpf api AFAICS because existing bpf_link
>>> are specific to the program type, so I'd have to add something like:
>>>
>>> struct bpf_link *
>>> bpf_program__attach_netfilter(const struct bpf_program *prog,
>>> 			      const struct bpf_netfilter_opts *opts)
>>>
>>> Advice welcome.
>>
>> OK, yes we'd need something like this if we wanted to load and attach
>> from bpftool. If you already have the tooling elsewhere, it's maybe not
>> necessary to add it here. Depends if you want users to be able to attach
>> netfilter programs with bpftool or even libbpf.
> 
> [..]
> 
>> I'd say let's keep this out of the current patchset anyway. If we have a
>> use case for attaching via libbpf/bpftool we can do this as a follow-up.
> 
> Sounds good to me.
> 
> Quentin Deslandes or Daniel Xu might want/need libbpf support for their
> projects.
> 
>> The way I see it, "bpftool net" should provide a more structured
>> overview of the different programs affecting networking, in particular
>> for JSON. The idea would be to display all BPF programs that can affect
>> packet processing. See what we have for XDP for example:
>>
>>
>>     # bpftool net -p
>>     [{
>>             "xdp": [{
>>                     "devname": "eni88np1",
>>                     "ifindex": 12,
>>                     "multi_attachments": [{
>>                             "mode": "driver",
>>                             "id": 1238
>>                         },{
>>                             "mode": "offload",
>>                             "id": 1239
>>                         }
>>                     ]
>>                 }
>>             ],
>>             "tc": [{
>>                     "devname": "eni88np1",
>>                     "ifindex": 12,
>>                     "kind": "clsact/ingress",
>>                     "name": "sample_ret0.o:[.text]",
>>                     "id": 1241
>>                 },{
>>                     "devname": "eni88np1",
>>                     "ifindex": 12,
>>                     "kind": "clsact/ingress",
>>                     "name": "sample_ret0.o:[.text]",
>>                     "id": 1240
>>                 }
>>             ],
>>             "flow_dissector": [
>>                 "id": 1434
>>             ]
>>         }
>>     ]
>>
>> This gives us all the info about XDP programs at once, grouped by device
>> when relevant. By contrast, listing them in "bpftool link" would likely
>> only show one at a time, in an uncorrelated manner. Similarly, we could
>> have netfilter sorted by pf then hook in "bpftool net". If there's more
>> relevant info that we get from program info and not from the netfilter
>> link, this would also be a good place to have it (but not sure there's
>> any info we're missing from "bpftool link"?).
> 
> Currently 'bpftool link' shows everything wrt. netfilter bpf programs.
> 
>> But given that the info will be close, or identical, if not for the JSON
>> structure, I don't mean to impose this to you - it's also OK to just
>> skip "bpftool net" for now if you prefer.
> 
> I'll probably make 'bpftool net' and 'bpftool link' print identical
> netfilter output, I'll check this on Monday (to make sure the formatting
> doesn't seem out of place).
> 
> Its kinda silly to not have anything netfilter related in 'bpftool
> net', this thing isn't named 'linkfilter' after all 8-)

Sounds all good to me :) Thanks!
