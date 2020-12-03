Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ABC3C6369E
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Dec 2020 00:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F3B3221FB
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Dec 2020 00:47:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbgLCArl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Dec 2020 19:47:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56115 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726689AbgLCArl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Dec 2020 19:47:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606956374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tn3Df7eygk6Izda6RvZQkxxok8dSHVZu45DeLEEIxTY=;
        b=JNNnsjpPRpzWMukQ02KGolgJDyiLN0Sm1FvNeHtufC8c2SR0Kbe50ML7tmXEQ0U3j4yCtn
        n5gkTWRXa76QTzAIgRqyFku13I1UpZ/RJ3iBYTxn61RvodoSwrwu2aum7Qu6JNAAaSytjZ
        RQhXp8hm0Q8cXEw5wCe47rvwcjqyhnQ=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-qi0VInFuPWCnZAgeIX434A-1; Wed, 02 Dec 2020 19:46:10 -0500
X-MC-Unique: qi0VInFuPWCnZAgeIX434A-1
Received: by mail-qk1-f198.google.com with SMTP id d132so565772qke.5
        for <netfilter-devel@vger.kernel.org>; Wed, 02 Dec 2020 16:46:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=tn3Df7eygk6Izda6RvZQkxxok8dSHVZu45DeLEEIxTY=;
        b=s4cLAzxg93klrBpqNImNU9CQ3T6Mg72OsBr+ZKfdU4SgnsU42q8emwnpUQrz3Cb4L4
         VltjgMUH1TJBcsX++7o/Qz+/Le42xNW+asz4LwURAaixwuj6oioVM9/oYBJd9iWz8gZT
         nI/2KvannRXY3tKZA26796vlwfZfexy57C4dK85vTHbhkCN4CsLzFR7ZclAIK8flyOWh
         X9f5usXkMz1EtCKubWA/ba66Z7a6qVm5slG2l1xf2Sj0mwJklFAH75o/wW2EO07HzktY
         IOSTOq9iBG05K1j85HlTCrztthtoUgZblY9V2zrasiDWNmIcRusbVHFMdvdn/TBPQNEk
         PxtA==
X-Gm-Message-State: AOAM531OGcf9OzusVihuPK/3l/0uX/B7WF7CDhn4ap+ji0hJ1J09L0C8
        1f9IJXkYTUDNeQvCDBoat7lLIHkpmM8mYo9IJtr759Sp9a+aj/1IPNoW2Oyn/3CU399awJg6Nqk
        akN3akup2coamXyFNBH+ZeN8je4rT
X-Received: by 2002:a37:7145:: with SMTP id m66mr516130qkc.396.1606956369587;
        Wed, 02 Dec 2020 16:46:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzaQv8hATwzHtFhNcgeEgzuieWjSpIuQkb2SlVf60UIlQ0qMAa0FWuaYoO5eZoFUPJPsB6hRw==
X-Received: by 2002:a37:7145:: with SMTP id m66mr515968qkc.396.1606956367260;
        Wed, 02 Dec 2020 16:46:07 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id a6sm347081qkg.136.2020.12.02.16.46.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Dec 2020 16:46:06 -0800 (PST)
Subject: Re: [PATCH] netfilter: conntrack: fix -Wformat
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Joe Perches <joe@perches.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
References: <20201107075550.2244055-1-ndesaulniers@google.com>
 <4910042649a4f3ab22fac93191b8c1fa0a2e17c3.camel@perches.com>
 <CAKwvOdn50VP4h7tidMnnFeMA1M-FevykP+Y0ozieisS7Nn4yoQ@mail.gmail.com>
 <26052c5a0a098aa7d9c0c8a1d39cc4a8f7915dd2.camel@perches.com>
 <CAKwvOdkv6W_dTLVowEBu0uV6oSxwW8F+U__qAsmk7vop6U8tpw@mail.gmail.com>
From:   Tom Rix <trix@redhat.com>
Message-ID: <7ca84085-f8e1-6792-7d1c-455815986572@redhat.com>
Date:   Wed, 2 Dec 2020 16:46:04 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <CAKwvOdkv6W_dTLVowEBu0uV6oSxwW8F+U__qAsmk7vop6U8tpw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 12/2/20 2:34 PM, Nick Desaulniers wrote:
> On Tue, Nov 10, 2020 at 2:04 PM Joe Perches <joe@perches.com> wrote:
>> On Tue, 2020-11-10 at 14:00 -0800, Nick Desaulniers wrote:
>>
>>> Yeah, we could go through and remove %h and %hh to solve this, too, right?
>> Yup.
>>
>> I think one of the checkpatch improvement mentees is adding
>> some suggestion and I hope an automated fix mechanism for that.
>>
>> https://lore.kernel.org/lkml/5e3265c241602bb54286fbaae9222070daa4768e.camel@perches.com/
> + Tom, who's been looking at leveraging clang-tidy to automate such
> treewide mechanical changes.
> ex. https://reviews.llvm.org/D91789

This looks like a good one to automate.

If you don't mind, I'll give it a try next.

Need a break from semicolons ;)

Tom

>
> See also commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging
> use of unnecessary %h[xudi] and %hh[xudi]") for a concise summary of
> related context.

