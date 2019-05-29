Return-Path: <SRS0=BqdC=T5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DF93C28CC0
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 13:40:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68E8521902
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 13:40:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AyDyTMzL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbfE2Nkr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 May 2019 09:40:47 -0400
Received: from mail-ed1-f42.google.com ([209.85.208.42]:46569 "EHLO
        mail-ed1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726612AbfE2Nkq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 May 2019 09:40:46 -0400
Received: by mail-ed1-f42.google.com with SMTP id f37so3786186edb.13
        for <netfilter-devel@vger.kernel.org>; Wed, 29 May 2019 06:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=72kVUPrOIs42tgqc/Oc/yI3LFul5IAVlANHTWAC3si8=;
        b=AyDyTMzLafC0ZMayrM5UtGGLSE9gtYonn19hO4yiaK90UJbNLBCBig+jMNhd0svEGa
         IJDHDmP/46V9o8DmLMo1DrQiKlHDO/95OsPKOZ6UQDRHm3S+opRWTWAYaWBo1X5kdBmU
         TKim0tWVtUx+fa7Mz/nXFI1edga/YQKEDyOVTqbV/ZJYycbQSg/nORmQHOfttLFyV4OT
         ZnjdL0KhDtYoyFqHu+R/9oNtc1dU1MHR/EWEja2zMAbm1T3Bg6eobcpWrBG5JVIyMF3M
         ut5D3W+G1+gwst7jO8HZlPThStz+dv9TMu+xUKROiA6ez1+mG5h3lw1iQeebXKLmH6tc
         76UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=72kVUPrOIs42tgqc/Oc/yI3LFul5IAVlANHTWAC3si8=;
        b=d4GfVW6VMY/J+cCttuHVWJFsx+K8vcLeHDbxxs+X0An3mz/QWvgkqXtSqtk1d5ECOD
         cy/SDrmpVJB4/Vf/YwAPt40w75eqqAcZ9B4Xh55t+7Zkwkz78t5piL0a9Crm/ryZrOai
         HrYEqcKT4vHF2Bo1ZYr6zC47YnJcA3n2AZ9g2jCksUlCG4+/oDAxT58JtQd3lnN2KMz8
         sVgG14lLoXymXJvfqnhXpdu8Iff1LIWi5q7Lwm5KQ/WXVx9hb2HmRtHGHcoE0uPW0Aol
         rrYJ3yBzHJ0P6neo1wxtcbKzPS2ROJ99xwvwdXhC9rDjYpj5MUFhSXDnckVQTkunjLRF
         HhXg==
X-Gm-Message-State: APjAAAXV6pg7UEwNXBagjroKucIc3mExinbhc89DEBb2M3GGo0AEyix2
        JJCCwpOe1WuJcmkIh9e0h2/Ej828KWPKIUFXb5wV
X-Google-Smtp-Source: APXvYqxfsY3kOuAKSTRMJk0QXb0FwofNuwYisqTD1cGg+/rZKaKDOMO97PPw61Dkulo5AAwN6Z6+lUpWLb0FyBBNwPI=
X-Received: by 2002:a50:9d43:: with SMTP id j3mr81926073edk.59.1559137245312;
 Wed, 29 May 2019 06:40:45 -0700 (PDT)
MIME-Version: 1.0
References: <65ec483a-b8d7-530b-373f-6dcdd5f668c6@6wind.com>
In-Reply-To: <65ec483a-b8d7-530b-373f-6dcdd5f668c6@6wind.com>
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
Date:   Wed, 29 May 2019 09:40:34 -0400
Message-ID: <CAHapkUibzOmZ15gMKgh=8Q9kk=vbduZJadtJCL3=akBeGYN94A@mail.gmail.com>
Subject: Re: nftables release
To:     nicolas.dichtel@6wind.com
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Chiming in on this. Is there a cadence on release for both the utility
and the libraries? It's useful for planning on using approved patches.

Thanks,
Stephen.

On Wed, May 29, 2019 at 9:00 AM Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
>
> Hi,
>
> is there any plan to release an official version of the nftables user-space utility?
> The last one (v0.9.0) is now one year old ;-)
>
>
> Regards,
> Nicolas
