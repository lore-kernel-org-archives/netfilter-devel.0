Return-Path: <SRS0=y7H9=ZE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED9F6C43331
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Nov 2019 11:02:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2131214E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Nov 2019 11:02:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbfKLLCl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Nov 2019 06:02:41 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55438 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbfKLLCl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Nov 2019 06:02:41 -0500
Received: by mail-wm1-f65.google.com with SMTP id b11so2611942wmb.5
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Nov 2019 03:02:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=K1Rjtd8hzYzt88L8ay6H1/TKPrpSt78Hp90wyb5r7xw=;
        b=bWXM5NwmWs5SBsu8UVeHHw/f4VgSOnbxTQVIACgfCOMyCUQFrYFmbz4BIeFbWIDslq
         ZKS84ee9QHLeAKQ/k2HaI1ijEGyqxfjENPUfXr8JCUosS0xZ54pbNVby+hmUCQ9YjQgJ
         ZciByxSpdPL1j/c0H5AiToUnII20uKc601VoKwx4XCDQDH6GYd686PrMZzm5TQYjPvQy
         3Ma6gYi2xuWIy+3N1fp5OduOARn/yk3zfsPfCEdjXMoopRyYIjBJzYhbOgQpFWD721yp
         FQvC7SsJUWaDoGPv0fyUJuZSyj8NHEGs7ctgt/hEUfYNJdcQqkjhKHzMQB8kEeNoFI77
         IU2w==
X-Gm-Message-State: APjAAAUL7rToROW6k1iEqprzHPefqs5o9CdzHQYWsdvuXnTzEcTGtDD8
        hS1YFo9lUyEesCa+VWb/55s=
X-Google-Smtp-Source: APXvYqwXGBuMR8wwTyZadVIS+hA+pbZWhOd/uqw9EGSBE82RnhwBsQFg8nonDDehOVJ26sFQiz9R3A==
X-Received: by 2002:a7b:c748:: with SMTP id w8mr3569846wmk.114.1573556558735;
        Tue, 12 Nov 2019 03:02:38 -0800 (PST)
Received: from [192.168.1.156] ([213.194.137.137])
        by smtp.gmail.com with ESMTPSA id a16sm2942245wmd.11.2019.11.12.03.02.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2019 03:02:38 -0800 (PST)
Subject: Re: [PATCH] netfilter: xtables: Add snapshot of hardidletimer target
To:     Manoj Basapathi <manojbm@codeaurora.org>,
        netfilter-devel@vger.kernel.org
Cc:     subashab@quicinc.com, sharathv@qti.qualcomm.com,
        ssaha@qti.qualcomm.com, vidulak@qti.qualcomm.com,
        bryanh@quicinc.com, jovanar@qti.qualcomm.com,
        manojbm@qti.qualcomm.com
References: <20191111065617.GA29048@manojbm-linux.ap.qualcomm.com>
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
Openpgp: preference=signencrypt
Autocrypt: addr=arturo@netfilter.org; keydata=
 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
 EXgmBmyUKrJkh/zvupp9t9Y2ioPbcMObRIEXio4=
Message-ID: <4fac187b-3a13-c762-a619-d09585ecd718@netfilter.org>
Date:   Tue, 12 Nov 2019 12:02:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191111065617.GA29048@manojbm-linux.ap.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 11/11/19 7:56 AM, Manoj Basapathi wrote:
> This is a snapshot of hardifletimer netfilter target as of msm-4.4
> commit 469a150b7426 ("netfilter: xtables: hardidletimer target implementation")
> 
> This patch implements a hardidletimer Xtables target that can be
> used to identify when interfaces have been idle for a certain period
> of time.
> 
> Timers are identified by labels and are created when a rule is set
> with a new label. The rules also take a timeout value (in seconds) as
> an option. If more than one rule uses the same timer label, the timer
> will be restarted whenever any of the rules get a hit.
> 
> One entry for each timer is created in sysfs. This attribute contains
> the timer remaining for the timer to expire. The attributes are
> located under the xt_idletimer class:
> 
> /sys/class/xt_hardidletimer/timers/<label>
> 
> When the timer expires, the target module sends a sysfs notification
> to the userspace, which can then decide what to do (eg. disconnect to
> save power)
> 
> Compared to xt_IDLETIMER, xt_HARDIDLETIMER can send notifications when
> CPU is in suspend too, to notify the timer expiry.
> 
> Change-Id: Ib2e05af7267f3c86d1967f149f7e7e782c59807e
> Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
> Signed-off-by: Manoj Basapathi <manojbm@codeaurora.org>
> ---
>  .../uapi/linux/netfilter/xt_HARDIDLETIMER.h   |  51 +++
>  net/netfilter/Kconfig                         |  14 +
>  net/netfilter/Makefile                        |   1 +
>  net/netfilter/xt_HARDIDLETIMER.c              | 381 ++++++++++++++++++
>  net/netfilter/xt_IDLETIMER.c                  |   2 +
>  5 files changed, 449 insertions(+)
>  create mode 100644 include/uapi/linux/netfilter/xt_HARDIDLETIMER.h
>  create mode 100644 net/netfilter/xt_HARDIDLETIMER.c

I have nothing to comment on the patch itself.

But I wonder what would it take to implement this in the nf_tables framework.
