Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D3EAC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Feb 2022 23:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbiB1XbD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Feb 2022 18:31:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiB1XbC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Feb 2022 18:31:02 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6128613F37
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Feb 2022 15:30:22 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id a6so14732503oid.9
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Feb 2022 15:30:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cilium-io.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vNkt/XoEl2MXJVVOJpcclMn93M2urv+lS6gKrq9pNuc=;
        b=Wvtm2NfjLnmmNMSHlbyu3fnWRlvWGsOul4I5H7ZgtZ+dhaKYo6fsodi0Nd81RcdH+k
         7+FfkgAVaVMiAAge8HUzFQ3UJh3M9NOw7hspZzWxSw/gaQNpcFcg2mLzW5RXqLWzKgDZ
         +nO8Vy/R48bnjsQHr7DbCEwOv7azuf1XIpkR8CZmfRy84p66mcKbWqn0Jri12lm+78wK
         p1FleXhJgLI0rEjH2C1bCFLMkM6eTvYuT7xhYrOCoqhH7YvomCCzu41Ax3xIIUlyX6b8
         XFazmnyY8o+jwMsucRydPcY0IZlFAc8rmzPHatcSyHRj3E9GQbETMbIexpRRurSFdT1h
         HSYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vNkt/XoEl2MXJVVOJpcclMn93M2urv+lS6gKrq9pNuc=;
        b=x8ZsafovZr/DqppkCdAR8+1Y6WYERvQrgT8enbUBcMPKvjPUnR/F50xV+rLbvCQBfh
         gNtNjN0xxnI2k9HPz3F4gdj4D9qB+E7MnOTulpnckbsinH5e2imSHRIefVTGIAnvHaj/
         7p+LgwknykDYd6YCYRvA+DS0CZ348hvrvWex68KUAXgIEoWmEz0hfkR9W1I0ztZ3bK9r
         xaBgMjfvmz2K+glgFspi3uBzORMGkmkM6f62xMwW2UYi41k9eOCadGX1VnNRXvJL9v76
         Ix1pPC9/1FX350GYlaAPOCZMCU08XId/OVJVvqowp2ZpZnEwLnamlxp4NefFYo5fAgc6
         y2ZQ==
X-Gm-Message-State: AOAM531rZZksHZ1UaVcLBxOgmMOACG28RBVJn4MyCaHgdBuGc2COCsdu
        sYl/0rQPRzED7FHxZh1ONFtf4/85lcm8/GSo3rj7aAj266k=
X-Google-Smtp-Source: ABdhPJyBHbNR/bdz2vbRU049NDawZ45Rq//x1dww+vcVqB9zFctuKMDsCpUOE0lPXgrlMXn3+yjnGSmrtq4dG78PTZI=
X-Received: by 2002:a05:6808:1247:b0:2d3:5181:449a with SMTP id
 o7-20020a056808124700b002d35181449amr10573865oiv.83.1646091021699; Mon, 28
 Feb 2022 15:30:21 -0800 (PST)
MIME-Version: 1.0
References: <20220228162918.23327-1-fw@strlen.de>
In-Reply-To: <20220228162918.23327-1-fw@strlen.de>
From:   Joe Stringer <joe@cilium.io>
Date:   Mon, 28 Feb 2022 15:30:11 -0800
Message-ID: <CADa=Ryx0-A6TmXjSDUO0V-6arMjbOhO6MXV6emNhugAm+F_oLg@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_queue: be more careful with sk refcounts
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, Joe Stringer <joe@cilium.io>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Feb 28, 2022 at 8:29 AM Florian Westphal <fw@strlen.de> wrote:
>
> Eric Dumazet says:
>   The sock_hold() side seems suspect, because there is no guarantee
>   that sk_refcnt is not already 0.
>
> Also, there is a way to wire up skb->sk in a way that skb doesn't hold
> a reference on the socket, so we need to check for that as well.
>
> For refcount-less skb->sk case, try to increment the reference count
> and then override the destructor.
>
> On failure, we cannot queue the packet and need to indicate an
> error.  THe packet will be dropped by the caller.
>
> Cc: Joe Stringer <joe@cilium.io>
> Fixes: 271b72c7fa82c ("udp: RCU handling for Unicast packets.")

Hi Florian, thanks for the fix.

skb_sk_is_prefetched() was introduced in commit cf7fbe660f2d ("bpf:
Add socket assign support"). You may want to split the hunk below into
a dedicated patch for this reason.

> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Eric, does that look sane to you?
>  Joe, it would be nice if you could check the 'skb_sk_is_prefetched' part.

<snip>

> @@ -178,6 +180,18 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
>                 break;
>         }
>
> +       if (skb_sk_is_prefetched(skb)) {
> +               struct sock *sk = skb->sk;
> +
> +               if (!sk_is_refcounted(sk)) {
> +                       if (!refcount_inc_not_zero(&sk->sk_refcnt))
> +                               return -ENOTCONN;
> +
> +                       /* drop refcount on skb_orphan */
> +                       skb->destructor = sock_edemux;
> +               }
> +       }
> +
>         entry = kmalloc(sizeof(*entry) + route_key_size, GFP_ATOMIC);
>         if (!entry)
>                 return -ENOMEM;

I've never heard of someone trying to use socket prefetch /
bpf_sk_assign in conjunction with nf_queue, bit of an unusual case.
Given that `skb_sk_is_prefetched()` relies on the skb->destructor
pointing towards sock_pfree, and this code would change that to
sock_edemux, the difference the patch would make is this: if the
packet is queued and then accepted, the socket prefetch selection
could be ignored. That said, it seems potentially dangerous to fail to
hold the socket reference during the nfqueue operation, so this
proposal is preferable to the alternative. There's possibly ways for
someone to still get such a use case to work even with this patch (eg
via iptables TPROXY target rules), or worse case they could iterate on
this code a little further to ensure this case works (eg by coming up
with a new free func that takes this case into account). More likely,
they would find an alternative solution to their problem that doesn't
involve combining these particular features in the same setup.

I looked closely at this hunk, I didn't look closely at the rest of
the patch. Assuming you split just this hunk into a dedicated patch,
you can add my Ack:

Acked-by: Joe Stringer <joe@cilium.io>
