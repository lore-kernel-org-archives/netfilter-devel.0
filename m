Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC754C4338F
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 14:52:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9107B61AFD
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 14:52:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237038AbhG0Owy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Jul 2021 10:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237008AbhG0Owx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jul 2021 10:52:53 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87779C061760;
        Tue, 27 Jul 2021 07:52:52 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id h2so22203125lfu.4;
        Tue, 27 Jul 2021 07:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=bqgjWx1Khk9QvAsm2yAY1e/t4WthR/WGDWEo5wxT6Mg=;
        b=hKtnlGBa5MettR0jyAoTJctx+DWjODE6NXsvBsJ6bqG3/i/qJImdr1A6g0v8K3bs4u
         SbSBLKSw+/LjZnaMg/Y6n0RLlDbQsCHG6XAKfDDUMy9R7OHmneL7l1vDv4Z/80Fk/Idt
         cXzIyNCLzqFNB5SQP9xQnjJjoJPr/RpStIibCKK7QF4hv3uBfQsZMjRpK22MP3rlzo2o
         GpvvPh7dt3nAgVKcKoxtG5f5CIL30n2e+GkTiOPkUcdePpJYusXqN1mN53rzDKm66eWH
         1VATVWRiVha/G6WXGMi8WoaxuuRhQtMzdoCd7P44BwYZendhk2fs33aStg/mgA+KrD1y
         xLCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=bqgjWx1Khk9QvAsm2yAY1e/t4WthR/WGDWEo5wxT6Mg=;
        b=Z2MA3t97iM02KiGKllAbFBs5J1PqcUMpEzebcrCiWod6nq38kw9wuSxsW5F/+ery4O
         +mphy5gxp01yhIsAS5xktDFaytPlHg1JwSjAPepQyPFaf/urwpYDwgdyu3XiNCgvcEVx
         cHuD6DEeethKkKezPvMidG5rIG0Lv5Te6txKqyRBl9akysJSctR4068Moxbl6KkrWN1O
         UL1QrtnLBfOsIv/pvNSHVQNVJrB8xt1SpsoqNfGHVnQxMwUN5+3K3xoOMqVw0HipSvJI
         P6MH2NB9dkhvaiEA5Z4GLTlqh+4x77+5u655AvSuusUrjArEfA1cHXNUWjiZ8knHWJ14
         PzCg==
X-Gm-Message-State: AOAM530laptfSPvQxjirXYCAeb+QaYNDORFzv7KCxnaa21RIeLszJvQo
        qMh5uGjP6hvehwDSWgM1hSs0Zr41xN2WNUM2KxSNVKlAy/Jb/A==
X-Google-Smtp-Source: ABdhPJzvDAKGVekcax5VOaw9edr1EhcRzQWrAjevmoI7OqZkR2MeynB2G87Fvx8hz98uOpjHfqpFgX6VRt23Nmnkl/c=
X-Received: by 2002:a05:6512:20e:: with SMTP id a14mr12170212lfo.112.1627397570821;
 Tue, 27 Jul 2021 07:52:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAGnHSEkt4xLAO_T9KNw2xGjjvC4y=E0LjX-iAACUktuCy0J7gw@mail.gmail.com>
In-Reply-To: <CAGnHSEkt4xLAO_T9KNw2xGjjvC4y=E0LjX-iAACUktuCy0J7gw@mail.gmail.com>
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Tue, 27 Jul 2021 22:52:39 +0800
Message-ID: <CAGnHSEncHuO2BduzGx1L9eVtAozdGb-XabQyrS7S+CO2swa1dw@mail.gmail.com>
Subject: Re: [nft] Regarding `tcp flags` (and a potential bug)
To:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Just noticed something that is even worse:

# nft add rule meh tcp_flags 'tcp flags { fin, rst, ack }'
# nft add rule meh tcp_flags 'tcp flags == { fin, rst, ack }'
# nft add rule meh tcp_flags 'tcp flags & ( fin | rst | ack ) != 0'
# nft add rule meh tcp_flags 'tcp flags & ( fin | rst | ack ) == 0'
# nft list table meh
table ip meh {
    chain tcp_flags {
        tcp flags { fin, rst, ack }
        tcp flags { fin, rst, ack }
        tcp flags fin,rst,ack
        tcp flags ! fin,rst,ack
    }
}

On Tue, 27 Jul 2021 at 19:18, Tom Yan <tom.ty89@gmail.com> wrote:
>
> Hi all,
>
> I'm a bit uncertain how `tcp flags` works exactly. I once thought `tcp
> flags syn` checks whether "syn and only syn is set", but after tests,
> it looks more like it checks only whether "syn is set" (and it appears
> that the right expression for the former is `tcp flags == syn`):
>
> # nft add rule meh tcp_flags 'tcp flags syn'
> # nft add rule meh tcp_flags 'tcp flags ! syn'
> # nft add rule meh tcp_flags 'tcp flags == syn'
> # nft add rule meh tcp_flags 'tcp flags != syn'
> # nft list table meh
> table ip meh {
>     chain tcp_flags {
>         tcp flags syn
>         tcp flags ! syn
>         tcp flags == syn
>         tcp flags != syn
>     }
> }
>
> Then I test the above respectively with a flag mask:
>
> # nft add rule meh tcp_flags 'tcp flags & (fin | syn | rst | ack) syn'
> # nft add rule meh tcp_flags 'tcp flags & (fin | syn | rst | ack) ! syn'
> # nft add rule meh tcp_flags 'tcp flags & (fin | syn | rst | ack) == syn'
> # nft add rule meh tcp_flags 'tcp flags & (fin | syn | rst | ack) != syn'
> # nft list table meh
> table ip meh {
>     chain tcp_flags {
>         tcp flags & (fin | syn | rst | ack) syn
>         tcp flags & (fin | syn | rst | ack) ! syn
>         tcp flags syn / fin,syn,rst,ack
>         tcp flags syn / fin,syn,rst,ack
>     }
> }
>
> I don't suppose the mask in the first two rules would matter. And with
> `tcp flags syn / fin,syn,rst,ack`, I assume it would be false when
> "syn is cleared and/or any/all of fin/rst/ack is/are set"?
>
> Also, as you can see, for the last two rules, `nft` interpreted them
> as an identical rule, which I assume to be a bug. These does NOT seem
> to workaround it either:
>
> # nft flush chain meh tcp_flags
> # nft add rule meh tcp_flags 'tcp flags == syn / fin,syn,rst,ack'
> # nft add rule meh tcp_flags 'tcp flags != syn / fin,syn,rst,ack'
> # nft list table meh
> table ip meh {
>     chain tcp_flags {
>         tcp flags syn / fin,syn,rst,ack
>         tcp flags syn / fin,syn,rst,ack
>     }
> }
>
> I'm not sure if `! --syn` in iptables (legacy) is affected by this as
> well. Anyway, I'm doing the following for now as a workaround:
>
> # nft flush chain meh tcp_flags
> # nft add rule meh tcp_flags 'tcp flags ! syn reject with tcp reset'
> # nft add rule meh tcp_flags 'tcp flags { fin, rst, ack } reject with tcp reset'
> # nft list table meh
> table ip meh {
>     chain tcp_flags {
>         tcp flags ! syn reject with tcp reset
>         # syn: 1, other bits: not checked
>         tcp flags { fin, rst, ack } reject with tcp reset
>         # syn: 1, fin: 0, rst: 0, ack: 0, other bits: not checked
>         ct state != invalid accept
>     }
> }
>
> Are the comments in above correct? Are any of the assumptions in this
> email incorrect?
>
> As a side question, is it even possible that any packet will be
> considered `invalid` with (syn: 1, fin: 0, rst: 0, ack: 0)?
>
> Thanks in advance!
>
> Regards,
> Tom
