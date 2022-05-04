Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9537C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 May 2022 15:45:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352693AbiEDPtc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 May 2022 11:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352697AbiEDPta (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 May 2022 11:49:30 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38B040E54
        for <netfilter-devel@vger.kernel.org>; Wed,  4 May 2022 08:45:53 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id t25so3042554lfg.7
        for <netfilter-devel@vger.kernel.org>; Wed, 04 May 2022 08:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XZVcjt4ocC2dVaabeZj2C0+Py+1YYA3/Q0DXf3p2avA=;
        b=EgbEeuZr4zqRzq23rW/YM3LljUKVMbZT6cI+zWplvbT8w8yLCIQp9qhO8OJ9blVoXU
         zcBxURpbHBDXkJpukE+ORxkZp+sGDd6WxtFwy+ptMfKSlLaD7+40sS/CTfANqwi8G9+n
         dZ15j1BycaFSxSx5FuFPFdhiUw1DIu2IAxNNk3odI8trSMuwtJ/gEQiETSRBdS/7f91y
         CqRmBAdRG+/sAQwktcatGHJpyqL118qNh6uKQDX15Lh1eib7+SF+9dQ1t6hOYXgH01XO
         Z4klTiOeMmZL5WqwbUaw7wXwq0DHbX/OwDQZ5Wsik+1Sqn2HrD6AjMPXhmd/u2iJWphX
         Y7Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XZVcjt4ocC2dVaabeZj2C0+Py+1YYA3/Q0DXf3p2avA=;
        b=37KLS9U4UpRq+gVjL1KL3fiAY+KXT1Q8tX1N1F8nZYDBzasC/Z9gSm7SpsTu8c2Bnw
         PdFXM2xWQhT/7UvDv90te1gLc8Qnu2RjooxK4qQt2SOOpqxODWQyBw8HkwiOd5ELDqLB
         40VtPvdpM1h/ZeiN/FcS1ntummujnzuSzho9+Dfwc/enA2IKxX6fDYVzbLKYDOajJ4A5
         jHhwWjoLMOftAtZAuE2Ax63ha/paaZyjeM6OdZkFH+OZAxtEtJtiRfCYgpCg4qd/xHqb
         7lBjYFCUmQg5voeHHmLBZsW4e+BC9urX2K3ppKV0tGXVPreJw6XUvBfGnyHqMVRT2wZY
         4Aww==
X-Gm-Message-State: AOAM530aAi+//YAm+nAQFkCNQOht0vTzKtt6IHhTIFB1NPq6e2PMpPVm
        Vo/C6pPxtWJTzvUzeYx6vzGnXVW/7Z3u0+uPXoI=
X-Google-Smtp-Source: ABdhPJy5kw2yhjVt648MsBvAl/TtqRmQfUbd1NdoaBsVc2ADIOf5HVKhTztSMuPa5aZPE72cUvj5o0+0pTZCtWg1C68=
X-Received: by 2002:a05:6512:2613:b0:448:5164:689d with SMTP id
 bt19-20020a056512261300b004485164689dmr14403155lfb.526.1651679151938; Wed, 04
 May 2022 08:45:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220503215237.98485-1-u9012063@gmail.com> <20220504060745.GB32684@breakpoint.cc>
In-Reply-To: <20220504060745.GB32684@breakpoint.cc>
From:   William Tu <u9012063@gmail.com>
Date:   Wed, 4 May 2022 08:45:15 -0700
Message-ID: <CALDO+SZuyOLki1_tKk0L+-2Jh7ME-_pG0Z6_18jc1mB5-ZCdNA@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nf_conncount: reduce unnecessary GC
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        Yifeng Sun <pkusunyifeng@gmail.com>,
        Greg Rose <gvrose8192@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 3, 2022 at 11:07 PM Florian Westphal <fw@strlen.de> wrote:
>
> William Tu <u9012063@gmail.com> wrote:
> > @@ -231,6 +236,12 @@ bool nf_conncount_gc_list(struct net *net,
> >       if (!spin_trylock(&list->list_lock))
> >               return false;
> >
> > +     /* don't bother if we just done GC */
> > +     if (time_after_eq(list->last_gc, jiffies)) {
> > +             spin_unlock(&list->list_lock);
>
> Minor nit, I think you could place the time_after_eq test before
> the spin_trylock if you do wrap the list->last_gc read with READ_ONCE().

Thanks! will do in v2.

>
> You could also check if changing last_gc to u32 and placing it after
> the "list_lock" member prevents growth of the list structure.

make sense, will use u32.
William
