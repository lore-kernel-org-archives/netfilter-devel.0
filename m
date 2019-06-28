Return-Path: <SRS0=rhnh=U3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B25C4321A
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jun 2019 16:10:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2395620645
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jun 2019 16:10:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fjsNKdon"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbfF1QKf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Jun 2019 12:10:35 -0400
Received: from mail-io1-f41.google.com ([209.85.166.41]:34528 "EHLO
        mail-io1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726696AbfF1QKf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Jun 2019 12:10:35 -0400
Received: by mail-io1-f41.google.com with SMTP id k8so13716484iot.1
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jun 2019 09:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=e/2vYePBhZ4FMF/CAdDzRkqpPCDrfsSptclTeUn+gVE=;
        b=fjsNKdonpVdBepchHl5CZ6Z60cDaIE84cj9hdj/gtKPvBThLSYbQCxCEYNYGVAn4X5
         2KFKwcmZ+LFgw9UM7mWqbna95hhIXSETCxfVs1mGfDsdIaqTtbc5fMNVuseEa1mO3ohQ
         pS0mNFdOnEollqBxiPyQyuAy01xcFNzsQB8So3lumItLaDoPqsr2/Dld9l0CytNvXgdN
         vb2mAqNJCiRnW9AjIYeRcDy/b7Be1l8GTbEn5J+4LxgkmxtHtTv7XfUyvc7AHYgNpKHC
         UukdvaAD7yy6YJkg6Q/3cjJb4mVGAs28o9tUNBlPmfUhgzroHrt9kf9Q9vKfohV2vRhZ
         Kn2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=e/2vYePBhZ4FMF/CAdDzRkqpPCDrfsSptclTeUn+gVE=;
        b=Sy08Vn4XAP76qbh8tbhU6dIygdm64CRCCXPljGNcIKSAIxtsV+3pTsVlAg/ynZZ06H
         oY7WGZYdMtj/d0x+8iWidZXQKrq8j6Fcuv9UTz+sGpVOrrfZveJSQIx+Ge90YetyTc5U
         VHpNU+gmixscrfzMrIrh+qHxDqjYfHjf0W1kqA5bMGndfSI+AiEjVEZglhopNxXiV5VO
         tzLMyAelbaCnMERNBFxrYhb2qphxm7pK5mzzTzyzBfORfI5Z0/zqGJLncilF/Cf/0UFo
         jRWPMDVlzVgxlFt5k4EQbje9n5+EEbaPJE0Y/awz6rMkurvkMim1MQPm7KAGptNFCqIe
         6bIA==
X-Gm-Message-State: APjAAAXp/ytY7qGvBooHLpCUWLnxs5rJKX88NeyaPSaPjf10v3e9P7V7
        hcPZAttc0IGlahLWPheoTxDaWltORXDgwHIYkmNGcA==
X-Google-Smtp-Source: APXvYqyhqxVDrrJF3RT8jEYiGbDzkev0GlKrkn85II6//HV8eagA8bSGcoBsHmvbd0gZVTWPymzi5KWNHkmnZitUj+U=
X-Received: by 2002:a6b:4f15:: with SMTP id d21mr11737770iob.210.1561738234598;
 Fri, 28 Jun 2019 09:10:34 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a02:3b60:0:0:0:0:0 with HTTP; Fri, 28 Jun 2019 09:10:34
 -0700 (PDT)
In-Reply-To: <20190628114957.jf4n7d53ppp6mieh@breakpoint.cc>
References: <CAF1SjT56zfq9VeUwqwe+vVfB6wija76Ldpa_dhY96x_eo4JU5A@mail.gmail.com>
 <20190628114957.jf4n7d53ppp6mieh@breakpoint.cc>
From:   Valeri Sytnik <valeri.sytnik@gmail.com>
Date:   Fri, 28 Jun 2019 20:10:34 +0400
Message-ID: <CAF1SjT4u932Yu5EFkOdhE8NJVKVzvXNZiLTVT2grEqVzFsA_Gw@mail.gmail.com>
Subject: Re: if nfqnl_test utility (libnetfilter_queue) drops a packet the
 utility receives the packet again
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florian, thanks a lot.
I see that a selected tcp packet can not be dropped at all.
If a selected tcp packet is dropped that blocks passing
of next tcp packets via this tcp connection.
Is there way to bypass that?
Thanks a lot.


On 6/28/19, Florian Westphal <fw@strlen.de> wrote:
> Valeri Sytnik <valeri.sytnik@gmail.com> wrote:
>> I apply NF_DROP (instead NF_ACCEPT) to some tcp packet which
>> contains some specific string known to me (say, hhhhh)
>> that packet comes back to the queue again but with different id.
>
> Yes, TCP retransmits data that is not received by the peer.
>
