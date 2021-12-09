Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F10CC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Dec 2021 16:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236564AbhLIQJo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Dec 2021 11:09:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236712AbhLIQJn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Dec 2021 11:09:43 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD12C061746
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Dec 2021 08:06:09 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id b1so12810715lfs.13
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Dec 2021 08:06:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ns1.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HE13dzJVfee2GhrRaz3GvbrFLCJMuPAJHX2uhGH0rTo=;
        b=Bf3nbWEkG5VkGdDJdrTvcrsAUlEpH3262BRvAZrAryLehrxu968ek46KRENPb6/M0l
         01NDMJN+MVxD/CqHCwB0GB+FYzFg0icixNoxqxgVQ2UswhZbzcw8YQiE1pjycDHG5wxW
         bH5eo9Z9MXirx6mEg8uiOns+kIzgkwCFMHkiCx7cEnqb7+xW5Z4YdwsMy7lz++bs6ft1
         sp9DxkmkP/Mstf/gg/xNWAoUk1s4eQl8p1YV02jHx6J8PSZgzl0JopurHpaxZlOOX+I0
         shlXl2kcyvGQjwByftWoLN2goaDScbWJ0vhVW5e3ae25uw4o7AIaDO9BT/qrUtZUHS+k
         Ar6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HE13dzJVfee2GhrRaz3GvbrFLCJMuPAJHX2uhGH0rTo=;
        b=5G3mbVKD9mJatvXc8gE5vlM5D24aES+1Yt6ro8819IJdS4f6sSsTkLllm34O/T4/oH
         WW0GWlwHUIUDN2k6uL3JG0rFjxFq4laEwIvmalJfs+dgmhje9WsGZctNiu4vP28q+LPi
         VuIc4FWzS2toesu2OF2amhYTVMQRidQ9SwhQgB83NpYlUK1y+AiZBhBPkkJU4rQ4kGIm
         /mKS1bnD1cI7PVrTwHuIxdD3QyRyI2R/Pam+LEyTWZathMuj0C8bbJYUJNjGABMZuv15
         WJIFAsOU6wONQ5B4QM8bF+L5AGhsBpawTNATGoXG2vWQuNFl6BGFimW8p6YxY4b7CX/B
         FxCg==
X-Gm-Message-State: AOAM530vrKNDobn1OMDgxKReeXVeLFTCkIF5tpuRvvwDhkYjMRmJEaw4
        EGEupisf4jKMFPTKwarkB3aVhcEA7lJaAmBtsDDlkhBc8C4BjlsJ
X-Google-Smtp-Source: ABdhPJwhJ7QY1+7E1I4hkXPDtr3ZOejxsje8qT1sNumFZ4q9TekRcS8A7MdBmHsTZMcrdz+UQ2Oh/d3VMFVWwjTe0sI=
X-Received: by 2002:a05:6512:3d10:: with SMTP id d16mr6525410lfv.78.1639065968054;
 Thu, 09 Dec 2021 08:06:08 -0800 (PST)
MIME-Version: 1.0
References: <CA+PiBLyAYMBw-TgdaqVZ_a2agbRcdKnpZjS9OvP02oPAGPb=+Q@mail.gmail.com>
 <CA+PiBLx2PKt68im24s1wHD7dcyHK-f0pBEhPWQTHsrvenT1f9w@mail.gmail.com> <20211209102628.GF30918@breakpoint.cc>
In-Reply-To: <20211209102628.GF30918@breakpoint.cc>
From:   Vitaly Zuevsky <vzuevsky@ns1.com>
Date:   Thu, 9 Dec 2021 16:05:57 +0000
Message-ID: <CA+PiBLxeboPcbGp0ajcG+BCZAF+ComL0dnsOS4tL9ES52jOSoQ@mail.gmail.com>
Subject: Re: Fwd: conntrack -L does not show the full table
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

> Vitaly Zuevsky <vzuevsky@ns1.com> wrote:
> > Hi
> >
> > I have many conntrack entries:
> > # conntrack -C
> > 85380
> > However, I can't see them all:
> > # conntrack -L
> > ...
> > conntrack v1.4.4 (conntrack-tools): 7315 flow entries have been shown.
> >
> > It is not in the man conntrack how to get the rest (85380-7315)
> > entries. Will it be a bug?
>
> Maybe.  What happens if you do
>
> conntrack -C
> wc -l < /proc/net/nf_conntrack
> conntrack -C
> ?

File /proc/net/nf_conntrack does not exist. Default in latest kernels
is to not expose conntrack table via /proc
5.4.0-67-generic #75~18.04.1-Ubuntu SMP
