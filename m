Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 555D4C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Apr 2022 11:55:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244673AbiDZL6Z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Apr 2022 07:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239701AbiDZL6V (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Apr 2022 07:58:21 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F388EDEDC
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Apr 2022 04:55:13 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id e12so3640922ybc.11
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Apr 2022 04:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N2BkINbzjFHfJOEzCr84LpvPBiQy96TIThqeM1mCi9E=;
        b=ToZ0Iq4eE8iEKoCNA5zyjQrmvkL5RMstlY1rRBTS9KkZIP/3jWqP5iIAAOW/DsLJul
         mKe+k4amfJIiF5r3VGblzouwWzQHRT3qiTw1zmpkCpBnSNvWR8EovqbfADYrut9uF3am
         ohjm4AFg5s6gNi1IEuRKqbw7hEY4aA616VwN9Zpw23BqWsXtZ8Cco39yEO+q+wNjnFwE
         9Ums4R3thVXk607J72tvB7ip58Oht24Z5oE53XhVTwfikLK6S27S2WM2HHnweikwvxkL
         7AYwbTUrVu0setmC06gsdntyFdpYEDVEmkQ8wqAcvM9i8VHkyKByvo651p+ch2iKKB7F
         y+3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N2BkINbzjFHfJOEzCr84LpvPBiQy96TIThqeM1mCi9E=;
        b=Kl9kdPLORfqC5CXcmCm0eCmG3ZQAcxVGUYfW1XrBIubo8OELnRIo1MME1aVKnAWJoX
         avJY+lmQdFWczMW1ZPMalUxoYFmgiQsuHoaNzP3uaahJTnTJ7/FfoUhBNvp/JW8euB9c
         iQXgH2C5vvqixsx/MpTk6lXlSCbfGNCWEF+TpwWN3Lmz2tRKdLSaH//w989F/QHZbUfC
         JjIzt+n3xfY4q2Zj3Ftu+YB0XekD+CINoMsaUGDqU9Tk2uwwb0iMMP/jKvfnmAffuymv
         BjWCGsy5cJGuFUsOJ3p1q/nwimTnkj3MgghEJLfvah0EtnQOWMEM89DlfDXhgKQRklR9
         kjZw==
X-Gm-Message-State: AOAM532iv7mI3T5BDQvx1sYB5oY5NAacD+ogcTexKNMpUFsKXhJeFjOj
        9krc/hm/xHnsuB/ppNn+FKHMPGnGkKgbyZEuOpIMOeqqIJ8=
X-Google-Smtp-Source: ABdhPJxYx0jIaBwDxGNiYuFm5ezw42whPmd3hbxCQQ9rlriP9/mPDqULDcu73f1+M9NxqLf2LRTYJ9+a8RcK7isORJs=
X-Received: by 2002:a25:d155:0:b0:648:757d:57b5 with SMTP id
 i82-20020a25d155000000b00648757d57b5mr7169498ybg.540.1650974113225; Tue, 26
 Apr 2022 04:55:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220425080835.5765-1-ritarot634@gmail.com> <YmfVpecE2UuiP6p8@salvia>
In-Reply-To: <YmfVpecE2UuiP6p8@salvia>
From:   =?UTF-8?B?44KK44Gf44KN44GG?= <ritarot634@gmail.com>
Date:   Tue, 26 Apr 2022 20:55:02 +0900
Message-ID: <CAL_Gmbaf_usL2+sayLVcGK_MaA2OaMaZi=fa2R6fp8TFVNZokQ@mail.gmail.com>
Subject: Re: [PATCH] nf_flowtable: ensure dst.dev is not blackhole
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thanks for your reply.

> In 5.4, this check is only enabled for xfrm.
Packet loss occurs with xmit_neigh (xfrm is not confirmed).
I also experienced packet loss with 5.10, which runs dst_check() periodically.
Route GC and flowtable GC are not synchronized, so it is necessary to check
each packet.

> dst_check() should deal with this.
When dst_check() is used, the performance degradation is not negligible.
From 940 Mbps to 700 Mbps with QCA9563 simple firewall.

On Tue, Apr 26, 2022 at 8:21 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> Hi,
>
> On Mon, Apr 25, 2022 at 05:08:38PM +0900, Ritaro Takenaka wrote:
> > Fixes sporadic IPv6 packet loss when flow offloading is enabled.
> > IPv6 route GC calls dst_dev_put() which makes dst.dev blackhole_netdev
> > even if dst is cached in flow offload. If a packet passes through this
> > invalid flow, packet loss will occur.
> > This is from Commit 227e1e4d0d6c (netfilter: nf_flowtable: skip device
> > lookup from interface index), as outdev was cached independently before.
> > Packet loss is reported on OpenWrt with Linux 5.4 and later.
>
> dst_check() should deal with this.
>
> In 5.4, this check is only enabled for xfrm.
>
> > Signed-off-by: Ritaro Takenaka <ritarot634@gmail.com>
> > ---
> >  net/netfilter/nf_flow_table_ip.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> > index 32c0eb1b4..12f81661d 100644
> > --- a/net/netfilter/nf_flow_table_ip.c
> > +++ b/net/netfilter/nf_flow_table_ip.c
> > @@ -624,6 +624,11 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
> >       if (nf_flow_state_check(flow, ip6h->nexthdr, skb, thoff))
> >               return NF_ACCEPT;
> >
> > +     if (unlikely(tuplehash->tuple.dst_cache->dev == blackhole_netdev)) {
> > +             flow_offload_teardown(flow);
> > +             return NF_ACCEPT;
> > +     }
> > +
> >       if (skb_try_make_writable(skb, thoff + hdrsize))
> >               return NF_DROP;
> >
> > --
> > 2.25.1
> >
