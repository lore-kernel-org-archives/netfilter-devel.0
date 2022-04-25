Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 807BCC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Apr 2022 14:55:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242614AbiDYO6w (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Apr 2022 10:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242504AbiDYO6q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Apr 2022 10:58:46 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB4637AB8
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Apr 2022 07:55:40 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-2f7b90e8b37so73506227b3.6
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Apr 2022 07:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kl87WtqLYYNPleZLxRS3P0uqxgNsKNEd+smPcsgnMNQ=;
        b=p9hpJ17mqZMjUR67mk2FljRctgicSbnBl9Pk1lGjRVxHk4pCKDKySpR3raU9Lwry/K
         2sfiwB3MEwGJjdAs16h1KVpUUccV7PfHQ/RfzMtCYSWm+eA4Fgu7SrQGRj5JN60Rr52l
         O4dW7Un6Yu0bdIcab8GuRYWiUewbmykf15rkzbzGKBvVnBY0x7t9Sg8eznF5Yn4GtprC
         ibc4J8NVY9jSipg/Ol93qdjrIWuX1AONd3FNbmOF2qyGQVdkUP+f+uJVVmBM7ANq06sn
         c8acfcHt1ttSLYzSIOlVJE0kKwC7kya1Pf+Y1Q9E42vc3y1AGGRA3UrOS+3XtWfSAaf4
         taIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kl87WtqLYYNPleZLxRS3P0uqxgNsKNEd+smPcsgnMNQ=;
        b=gMlc8zqGEVa+2xmQMT61YV3OSG2L00hWIXyHPcS2gBLwTH8r/JqeyWsYbc0NuUza9G
         /cDZDrDelPxsDXxkLfRDRAA3Ad8vZiV6UXMpu89s3MUEfQIOzdXBo1cVLfzdeRkOLiT6
         HGlOh/A5IHIyGt6i8OWSCMLqMrgzyElrmJaJA00LPeL7LRq2NmLftZDqOv4lNPXqrUJ0
         LZ0oHoIj+7SpZuSRTBvd022+m+hhdgXrXQ7oPj9TataRpoGAoNj8CKa3dUv+g8oAVYDn
         UhX1ATILuruP4tIWKby2sPiMZhkxd1My5CszKbfknVZSkdUFR+BGXnu1EU1sdY2a28bN
         5iKA==
X-Gm-Message-State: AOAM533tosojOiiZm1zW88qte2QeMopjllgwSkhMdSwRbllRS8YwI9yW
        R9ijM7+2Y0myGg4NSg7B9xK9QscIUyvJLG/qmsqYok+RV/iGg6fc
X-Google-Smtp-Source: ABdhPJx60Spo1QImNbBMiLXdLQP0IGNTBqyEt0XHsxOPABxzAl27C68hw3CeBSCghFvbf/mss9I7YsJETzc5tORdzog=
X-Received: by 2002:a81:1d4e:0:b0:2f7:be8b:502e with SMTP id
 d75-20020a811d4e000000b002f7be8b502emr12507440ywd.278.1650898539595; Mon, 25
 Apr 2022 07:55:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220425094711.6255-1-fw@strlen.de> <b46b713f-6ba8-38ab-bb22-d3fd9c6c8ec9@netfilter.org>
In-Reply-To: <b46b713f-6ba8-38ab-bb22-d3fd9c6c8ec9@netfilter.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 25 Apr 2022 07:55:28 -0700
Message-ID: <CANn89i+7zYCnMrDROjz76f9Esm4hxnFkm2c9cAZUFjtsybydQA@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_conntrack_tcp: re-init for syn packets only
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Neal Cardwell <ncardwell@google.com>,
        Jaco Kroon <jaco@uls.co.za>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Apr 25, 2022 at 6:41 AM Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
>
> On Mon, 25 Apr 2022, Florian Westphal wrote:
>
> > Jaco Kroon reported tcp problems that Eric Dumazet and Neal Cardwell
> > pinpointed to nf_conntrack tcp_in_window() bug.
> >
> > tcp trace shows following sequence:
> >
> > I > R Flags [S], seq 3451342529, win 62580, options [.. tfo [|tcp]>
> > R > I Flags [S.], seq 2699962254, ack 3451342530, win 65535, options [..]
> > R > I Flags [P.], seq 1:89, ack 1, [..]
> >
> > Note 3rd ACK is from responder to initiator so following branch is taken:
> >     } else if (((state->state == TCP_CONNTRACK_SYN_SENT
> >                && dir == IP_CT_DIR_ORIGINAL)
> >                || (state->state == TCP_CONNTRACK_SYN_RECV
> >                && dir == IP_CT_DIR_REPLY))
> >                && after(end, sender->td_end)) {
> >
> > ... because state == TCP_CONNTRACK_SYN_RECV and dir is REPLY.
> > This causes the scaling factor to be reset to 0: window scale option
> > is only present in syn(ack) packets.  This in turn makes nf_conntrack
> > mark valid packets as out-of-window.
> >
> > This was always broken, it exists even in original commit where
> > window tracking was added to ip_conntrack (nf_conntrack predecessor)
> > in 2.6.9-rc1 kernel.
> >
> > Restrict to 'tcph->syn', just like the 3rd condtional added in
> > commit 82b72cb94666 ("netfilter: conntrack: re-init state for retransmitted syn-ack").
> >
> > Upon closer look, those conditionals/branches can be merged:
> >
> > Because earlier checks prevent syn-ack from showing up in
> > original direction, the 'dir' checks in the conditional quoted above are
> > redundant, remove them. Return early for pure syn retransmitted in reply
> > direction (simultaneous open).
> >
> > Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
> > Reported-by: Jaco Kroon <jaco@uls.co.za>
> > Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
> > Signed-off-by: Florian Westphal <fw@strlen.de>
>
> Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
>
> [Sorry, I was away whole last week as well.]
>

Thanks a lot Florian and Jozsef !

> Best regards,
> Jozsef
>
> > ---
> >  net/netfilter/nf_conntrack_proto_tcp.c | 21 ++++++---------------
> >  1 file changed, 6 insertions(+), 15 deletions(-)
> >
> > diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> > index 8ec55cd72572..204a5cdff5b1 100644
> > --- a/net/netfilter/nf_conntrack_proto_tcp.c
> > +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> > @@ -556,24 +556,14 @@ static bool tcp_in_window(struct nf_conn *ct,
> >                       }
> >
> >               }
> > -     } else if (((state->state == TCP_CONNTRACK_SYN_SENT
> > -                  && dir == IP_CT_DIR_ORIGINAL)
> > -                || (state->state == TCP_CONNTRACK_SYN_RECV
> > -                  && dir == IP_CT_DIR_REPLY))
> > -                && after(end, sender->td_end)) {
> > +     } else if (tcph->syn &&
> > +                after(end, sender->td_end) &&
> > +                (state->state == TCP_CONNTRACK_SYN_SENT ||
> > +                 state->state == TCP_CONNTRACK_SYN_RECV)) {
> >               /*
> >                * RFC 793: "if a TCP is reinitialized ... then it need
> >                * not wait at all; it must only be sure to use sequence
> >                * numbers larger than those recently used."
> > -              */
> > -             sender->td_end =
> > -             sender->td_maxend = end;
> > -             sender->td_maxwin = (win == 0 ? 1 : win);
> > -
> > -             tcp_options(skb, dataoff, tcph, sender);
> > -     } else if (tcph->syn && dir == IP_CT_DIR_REPLY &&
> > -                state->state == TCP_CONNTRACK_SYN_SENT) {
> > -             /* Retransmitted syn-ack, or syn (simultaneous open).
> >                *
> >                * Re-init state for this direction, just like for the first
> >                * syn(-ack) reply, it might differ in seq, ack or tcp options.
> > @@ -581,7 +571,8 @@ static bool tcp_in_window(struct nf_conn *ct,
> >               tcp_init_sender(sender, receiver,
> >                               skb, dataoff, tcph,
> >                               end, win);
> > -             if (!tcph->ack)
> > +
> > +             if (dir == IP_CT_DIR_REPLY && !tcph->ack)
> >                       return true;
> >       }
> >
> > --
> > 2.35.1
> >
> >
>
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
> Address : Wigner Research Centre for Physics
>           H-1525 Budapest 114, POB. 49, Hungary
