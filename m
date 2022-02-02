Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1B12C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Feb 2022 01:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243715AbiBBBny (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Feb 2022 20:43:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243698AbiBBBnx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Feb 2022 20:43:53 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BF3C061714
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Feb 2022 17:43:53 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id d1so16871604plh.10
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Feb 2022 17:43:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Wd4ci6fAfiw4TqzpxVuzsxbcho4ZndrYYHPf811o/UU=;
        b=LPcDNkbQAPJQvOfkF3Kh50+phW7Sd2G3xI7L3AkqpREadou5s8wK0G98xv0/uPv/xq
         HTGGl0cdPmov7KEx40CtjsDC8DJ1HwGfiMcwNNbDPLrqhxM9wDd2Zuk+cx1onRPwfobY
         PUOuqMRaE0uybIzf9P6M+UFvsOqHs54tw9LwxX+2QV0XI4/1vXq4DMR693fMG2L4Tvdy
         fYvqVnRXWXBt/RmSwuiOjUWmtVAusi7Hg9s63W5zMNmzM7+4nuLXFjEoWbDiW8qxQEL5
         IReCO1ET9P08pV6QDT3xdevUzBGGyrkZYWayrzcdhswfCMcLjbeXviYV7QGCfeo80AFs
         j9hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Wd4ci6fAfiw4TqzpxVuzsxbcho4ZndrYYHPf811o/UU=;
        b=X0SHu4jU9RVPzBdfIFkbVVNaEN8rH+Yw+j5Q7bCP4VUD0ottoGRJCPR8vqbEI7/gV0
         qWaoXcQPX+azr90PsqHVoBeTBB0Lvz1HC68pgB4vTI//BrOnMa+VeKLnDiuvRuqE2YBT
         yU2eCZQJxDUgnoQvf1KXiJpIrIDkDtTxsuv3zvo6u/q63Fp4rbEYrdKXe4iB79s3I7B7
         NSEaRkZ+5+x5uNyi2QSrpu45qey3gx72Yzix7f6jbrR+TdwG957chzW6TqolUZtBa4iu
         OZOc3kKvjCJ99btYpBV4z2fi0JIBMO4VmpFc6OhdyyeujbxtVYiX2BOm9aRV1PDd6BJE
         yhvw==
X-Gm-Message-State: AOAM530YjZFGgsrpCjTxjrJaASqwymkdXf9T/kBn1vAPDxDSHFO+LlRA
        7+FURXqjdpICo6pIQpp4JXYyO/RKblg=
X-Google-Smtp-Source: ABdhPJwRGxOaegyPypkTyWHQHWNymAnIRfmLySN0DQjLrQ8+guKa5DEry/Yco7VRgEiHEy+sDo4iMw==
X-Received: by 2002:a17:902:8205:: with SMTP id x5mr17948773pln.29.1643766232931;
        Tue, 01 Feb 2022 17:43:52 -0800 (PST)
Received: from ?IPV6:2001:ee0:48be:3c40:a6c3:f0ff:fecf:f70b? ([2001:ee0:48be:3c40:a6c3:f0ff:fecf:f70b])
        by smtp.gmail.com with ESMTPSA id a125sm15206088pfa.205.2022.02.01.17.43.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Feb 2022 17:43:52 -0800 (PST)
Message-ID: <ead65119-a212-9abe-f69e-0e7e3c5baed2@gmail.com>
Date:   Wed, 2 Feb 2022 08:43:31 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: PROBLEM: Injected conntrack lost helper
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
References: <f9fb5616-0b37-d76b-74e5-53751d473432@gmail.com>
 <3f416429-b1be-b51a-c4ef-6274def33258@iogearbox.net>
 <0f4edf58-7b4e-05e8-3f13-d34819b8d5db@gmail.com>
 <20220131112050.GQ25922@breakpoint.cc>
 <2ea7f9da-22be-17db-88d7-10738b95faf3@gmail.com> <YfkLnyQopoKnRU17@salvia>
 <20220201120454.GB18351@breakpoint.cc>
 <bca957db-0774-e337-fc3a-ada0c4325fe9@gmail.com>
 <20220201141443.GC18351@breakpoint.cc>
From:   Pham Thanh Tuyen <phamtyn@gmail.com>
In-Reply-To: <20220201141443.GC18351@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

That's okay, so fix it like you ct->status |= IPS_HELPER;

On 2/1/22 21:14, Florian Westphal wrote:
> Pham Thanh Tuyen <phamtyn@gmail.com> wrote:
>> Previously I also thought ct->status |= IPS_HELPER; is ok, but after
>> internal pointer assigning with RCU_INIT_POINTER() need external pointer
>> assigning with rcu_assign_pointer() in __nf_ct_try_assign_helper() function.
> I'm not following.
>
> __nf_ct_try_assign_helper() doesn't do anything once that flag is set,
> so how could the helper get lost later?
