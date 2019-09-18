Return-Path: <SRS0=T2b5=XN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E350C4CEC9
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Sep 2019 14:10:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58350218AF
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Sep 2019 14:10:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M3jLVqe4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730334AbfIROKw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Sep 2019 10:10:52 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:35099 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730420AbfIROKv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Sep 2019 10:10:51 -0400
Received: by mail-ot1-f67.google.com with SMTP id z6so6456921otb.2
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Sep 2019 07:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h28AzMRJMMcuOpeRh5JL4zJFj38hhX6PV+SFz6lY3y8=;
        b=M3jLVqe4VPKRtb+15La+Gja4HCZ5yzJPGSGo8+2dIY7FumnAQiKQbBGJy8XCpC0DGN
         BtbY+bHB5WNOMEdeJ1HUujhHjDttZp1xta8pkXD4Dx4t4kVh5FHkDOgWm3TDhKVqBeok
         X4WnlUGJQC1IsWStgmg2gthdGdlvczl/2G5S1LyhF2oMLJLK7RQair00r6/jNZxe0RHu
         tjeRZHYz4f56OkeyR5koWI1j+WQI7MVceXuL0CH3m8RBJU1ARzmcq5I9c5hoW1SJneJc
         6i3V3xnW22q/T/kVVLx7w6tJs2pdkdqNADyIzUOOhKyeyFWHvT1n0zdiKpDfWO8hkFwE
         cF1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h28AzMRJMMcuOpeRh5JL4zJFj38hhX6PV+SFz6lY3y8=;
        b=XxfZBf4KTNBT5t+6v9AGoqR/G675+7ewhmqFi8tDUCjKgH7hDTDOYScEJjAy8vMyqz
         /94b3iVUtG9JZZGCSHdf4dchDfRKis2lRQHeNcmZuQCbBhzcXywVWq+7pSvdP9jNNImi
         3lGk1TNmI+y7GAEEsXobODirasjn4/prWIR32FMRov6d1nme9NYeZoDyqq0B8hlYngs2
         bgY06KshZ3HXSptoFzVGDVoEZxkWaT8WmZNDvwUgQbFmpSHxR/RrZx8Cp61p/bW05BDy
         neg2CJQkStP/bHJL9LfCb/vSdfjYYjBUZeBwkxkntdo9EO+zng2ZeWUvBkGBpr7rQu4q
         F40A==
X-Gm-Message-State: APjAAAU7Vu9vVrknQculxs6kDqccLBncq/uWQuDovposAHptqUbi7cck
        6jhc5/ryKjHhbkvZRDhLDezk1+/W3PTLy+0pieeLRA==
X-Google-Smtp-Source: APXvYqyglWmriC+h0IviT0VcuaT9kG6MF3OxdVuSd9Bee8MBfmQswLFjRN8tVXeOmVzWzbKLRZ54LZqMV3KPKZ+CqkQ=
X-Received: by 2002:a9d:6355:: with SMTP id y21mr2880519otk.53.1568815851066;
 Wed, 18 Sep 2019 07:10:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190918115325.GM6961@breakpoint.cc>
In-Reply-To: <20190918115325.GM6961@breakpoint.cc>
From:   Laura Garcia <nevola@gmail.com>
Date:   Wed, 18 Sep 2019 16:10:35 +0200
Message-ID: <CAF90-WifdkWm5xu0utZqjoAtW9SW4JyFrVqyxf5EbD9vUZJucw@mail.gmail.com>
Subject: Re: What is 'dynamic' set flag supposed to mean?
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

On Wed, Sep 18, 2019 at 3:20 PM Florian Westphal <fw@strlen.de> wrote:
>
> Hi.
>
> Following example loads fine:
> table ip NAT {
>   set set1 {
>     type ipv4_addr
>     size 64
>     flags dynamic,timeout
>     timeout 1m
>   }
>
>   chain PREROUTING {
>      type nat hook prerouting priority -101; policy accept;
>   }
> }
>
> But adding/using this set doesn't work:
> nft -- add rule NAT PREROUTING tcp dport 80 ip saddr @set1 counter
> Error: Could not process rule: Operation not supported
>

If this set is only for matching, 'dynamic' is not required.

> This is because the 'dynamic' flag sets NFT_SET_EVAL.
>
> According to kernel comment, that flag means:
>  * @NFT_SET_EVAL: set can be updated from the evaluation path
>
> The rule add is rejected from the lookup expression (nft_lookup_init)
> which has:
>
> if (set->flags & NFT_SET_EVAL)
>     return -EOPNOTSUPP;
>
> From looking at the git history, the NFT_SET_EVAL flag means that the
> set contains expressions (i.e., a meter).
>
> And I can see why doing a lookup on meters isn't meaningful.
>
> Can someone please explain the exact precise meaning of 'dynamic'?
> Was it supposed to mean 'set can be updated from packet path'?
> Or was it supposed to mean 'set contains expressions'?
>

AFAIK, I traduce the 'dynamic' flag as a 'set that is updated from the
packet path using an expression', formerly 'meter'.

> If its the latter, do we need a new NFT_SET flag to convey 'set
> needs to support updates from packet path'?
>

In all use cases I have (mainly connection limits), 'update' is not
required so far.

> Thanks.
