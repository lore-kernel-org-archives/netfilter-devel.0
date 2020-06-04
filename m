Return-Path: <SRS0=RJ5t=7R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB384C433DF
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Jun 2020 16:08:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B54EA2072E
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Jun 2020 16:08:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=wifirst-fr.20150623.gappssmtp.com header.i=@wifirst-fr.20150623.gappssmtp.com header.b="jBx5tYif"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729703AbgFDQIT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Jun 2020 12:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbgFDQIT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Jun 2020 12:08:19 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA544C08C5C0
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Jun 2020 09:08:18 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id l11so6780565wru.0
        for <netfilter-devel@vger.kernel.org>; Thu, 04 Jun 2020 09:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=wifirst-fr.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GRq+aOe+/mx/LiWb1lSB4IKpySFMSbYgDqHH/X7f2bg=;
        b=jBx5tYifunnnPWxPH8yTv0GC88MklYftHHvqDafitz63Ao4epO4iwOIiON5Go1A91+
         vKr/dAJqH/SW00qZ6HDSrqgkP7nOHdHUD5TjTuSPFtOcf08R6zG8DSHeUb4tnv/W9YPW
         PpnwecmtzHNr1gHc1YAmZ4v5gqAo8Y9eEF4EFv4jocDiHjXSddqIbhm2gL3TyDswyzcg
         CH//0Qowammm/Zca9AXGAsk/uZpVLvV2utU66fOoIbXnloHb1Vk5oqIFvjJx1rClA3Kz
         PZ9g4k4oMgugyeBdobckjiFdFbXnGn/Wyitih9a6jYNsd3R5Qek2XmC+Axc/m7daMTfg
         zwIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GRq+aOe+/mx/LiWb1lSB4IKpySFMSbYgDqHH/X7f2bg=;
        b=c/Zmzxidjl0EXyNlogfTPeFjBvb5ASPy/0GozkVYwQPxBJZJ945ETkzsU2FeE9MNAe
         hf/MeqW5jTdaUQCmuPeHZZ6Okibi6LFfJhxQdEfDqpUpeR2Fp57uBVepe+u0m4WnLYQ3
         gmLTlhqgZWa4f9ZWVUjOhxESvnHxRZxotSc3yl5r/B3jR35yxqYtjgrEEwof66GtsQjY
         wboo5wDag/snOXnKzYyAY47XQFcOOAEovx2lgf4aYTraKYl78uCITEqireN7JVSqcaO/
         VqGDuBBqQoJcUCCbI/cC2KnHAFEnB97m2MuhdO31qIAu1oMot+jPT+PC/VnjsquRZD1i
         XmPQ==
X-Gm-Message-State: AOAM530m3ILOkL3Zpf5CaiQg835dSoHW6oFZ5lmcuSMwt/OqVxqdJVdw
        P94xPyK/Aj0k8In9c3c5BQGlKRF0+VA=
X-Google-Smtp-Source: ABdhPJxx4oaW4+I3btz6pNXS0RdY7TvOM/SKB9mZMxQmO5+E1Atm9F24tpaNfa189zuvqMYC3Q8zig==
X-Received: by 2002:adf:de0b:: with SMTP id b11mr5111923wrm.346.1591286896712;
        Thu, 04 Jun 2020 09:08:16 -0700 (PDT)
Received: from [10.4.59.138] (wifirst-46-193-244.20.cust.wifirst.net. [46.193.244.20])
        by smtp.gmail.com with ESMTPSA id d5sm9140816wrb.14.2020.06.04.09.08.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 09:08:15 -0700 (PDT)
Subject: Re: [PATCH nf-next v5 1/1] netfilter: ctnetlink: add kernel side
 filtering for dump
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Romain Bellan <romain.bellan@wifirst.fr>,
        netfilter-devel@vger.kernel.org
References: <20200330204637.11472-1-romain.bellan@wifirst.fr>
 <20200426214338.GA2276@salvia>
 <66100a4b-a879-a8f4-f684-2b098a89cdc8@wifirst.fr>
 <20200529180425.GA30992@salvia>
From:   Florent Fourcot <florent.fourcot@wifirst.fr>
Message-ID: <7b5d9844-45d4-02df-42a0-6b1220b479a0@wifirst.fr>
Date:   Thu, 4 Jun 2020 18:08:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200529180425.GA30992@salvia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Dear Pablo,


> 
> I think you already mentioned, but it should be possible to extend
> the conntrack utility to support for kernel side filtering seamlessly.
> 
> The idea is to keep the userspace filtering as a fallback, regardless
> the kernel supports for CTA_FILTER or not.
> 

We agree, and we are currently working on a transparent implementation 
for another netlink userspace library (pyroute2).

About our patches on libnetfilter_conntrack, first step is probably one 
small refresh, since kernel part change a little bit. And we saw a first 
issue. Definitions of CTA_FILTER_* are now in nf_internals.h in kernel, 
so synchronization of linux_nfnetlink_conntrack.h will not be enough to 
export FILTER_FLAGS values. What do you think about the best way to 
synchronize flags values between userspace and kernel?

After this refresh, we can extend code of the submitted example for a 
full support.


> I'm missing one feature in the CTA_FILTER, that is the netmask
> filtering for IP addresses. It would be also good to make this fit
> into libnetfilter_conntrack.
> 

Yes, but it needs some extensions in kernel before. It's in our 
planning, but not done yet.


> 
> Probably rename NFCT_FILTER_DUMP_TUPLE to NFCT_FILTER_DUMP, which
> would provide the most generic version to request kernel side
> filtering.
> 

Ok, we will do that.

Thanks for the follow-up,

-- 
Florent.
