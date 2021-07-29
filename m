Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DBBEC4338F
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Jul 2021 02:57:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CFCC60F12
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Jul 2021 02:57:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233384AbhG2C5v (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 22:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233341AbhG2C5v (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 22:57:51 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7516C061757
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Jul 2021 19:57:47 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id u3so7899241lff.9
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Jul 2021 19:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kDcF7Pt3rigL3EYCrO3rM1a2FQemEe42xaPrUnIIROE=;
        b=k8rdizijj1zI4ZXuh9VTf9d7WStfQiRJWrmxUB1oG5C6AVzJ2UoOU3g4XmLg8mqRfp
         YkIhIFA3Gft2h2fx2k1fU04pgvJjsggYJGaLYOBf4a8U6tRB/4/DuXQn0JSipRyWy0oK
         rkypB0wO53mlue3AlOCvBM6p3JjyEM1kTEqxl279nKXc+mBWJap9uMs2qMCuA7JeKjGG
         8YZn770j6uLtliKc4mqVDRGn58vBNwW6AkkCUL7uxDRTR51tkStKAdP/TAcKZQKMgpIB
         wkZeYwhnRMOdBdPvy0li2G3xbFZPE9hDs7PXEomauBpm5XpEorQMVgn2lt+03Y16cPFj
         ROnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kDcF7Pt3rigL3EYCrO3rM1a2FQemEe42xaPrUnIIROE=;
        b=DAhh5W2I083LGmlGFGjUhnDAev1HDGxStHcgbcvhMaVKybQ33PhgFWz2k+fB+T0Wur
         ig9FLnwAxvO14X+98CfvLBS4gVmlP7v1vBmnCtI+kh2Cd7wnUsqQSUiH/Eep22V7oPlB
         JqBWRMaVamsMOR/FfpvPB7Vc6jfr2pxY0OHugs1j1C4SzZs9d3SGhkjFeEjrPQPZaK1F
         Z5dJf6cR6K70mpze8bQ7rsXXdWlDgi1Nn5mevl3eNhSVwgDTizg4mVTUnBfYQndXxE0I
         BR6eB8VLnVLhpf56AvuxIK7jfzgCwrX/7SAFKA01gOSozJF6kU0eNMxtV+1PBTmB6aXh
         RTFw==
X-Gm-Message-State: AOAM533PP+qas9A5UcBL6RBV0/TuYGHBwx9aXVS4TzSqfSbZ0Y5c3Cmj
        RnL+ymnlhnZvSaT0Whpe+o4/OwZZumye3mlAyUg=
X-Google-Smtp-Source: ABdhPJw6N+BeTO2AucPaZIp94mtZW6ftYkhxHaQ8VNJPnUkdugmGFqHlsKC+57e26vEcVUaS8LdaeZvf881W5wrO4hE=
X-Received: by 2002:ac2:59db:: with SMTP id x27mr1967863lfn.547.1627527466095;
 Wed, 28 Jul 2021 19:57:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210727153741.14406-1-pablo@netfilter.org> <20210727153741.14406-2-pablo@netfilter.org>
 <CAGnHSE=e-iYaz3KOMBq1JSVRd0HTL=TKQ_HHMadfyd2Nr8__yg@mail.gmail.com> <20210727210503.GA15429@salvia>
In-Reply-To: <20210727210503.GA15429@salvia>
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Thu, 29 Jul 2021 10:57:35 +0800
Message-ID: <CAGnHSEnxcVjN2etN-LNCgpb1h_hmSWMMh3Zm-GqbkZ0XOxCN-w@mail.gmail.com>
Subject: Re: [PATCH nft 2/3] netlink_linearize: incorrect netlink bytecode
 with binary operation and flags
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 28 Jul 2021 at 05:05, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Wed, Jul 28, 2021 at 02:36:18AM +0800, Tom Yan wrote:
> > Hmm, that means `tcp flags & (fin | syn | rst | ack) syn` is now
> > equivalent to 'tcp flags & (fin | syn | rst | ack) == syn'.
>
> Yes, those two are equivalent.
>
> > Does that mean `tcp flags syn` (was supposed to be and) is now
> > equivalent to `tcp flags == syn`
>
> tcp flag syn
>
> is a shortcut to match on the syn bit regarless other bit values, it's
> a property of the bitmask datatypes.
>
> tcp flags == syn
>
> is an exact match, it checks that the syn bit is set on.
>
> > instead of `tcp flags & syn == syn` / `tcp flags & syn != 0`?
>
> these two above are equivalent, I just sent a patch to fix the
> tcp flags & syn == syn case.
>
> > Suppose `tcp flags & syn != 0` should then be translated to `tcp flags
> > syn / syn` instead, please note that while nft translates `tcp flags &
> > syn == syn` to `tcp flags syn / syn`, it does not accept the
> > translation as input (when the mask is not a comma-separated list):
> >
> > # nft --debug=netlink add rule meh tcp_flags 'tcp flags syn / syn'
> > Error: syntax error, unexpected newline, expecting comma
> > add rule meh tcp_flags tcp flags syn / syn
> >                                           ^
>
> The most simple way to express this is: tcp flags == syn.
>
> > Also, does that mean `tcp flags & (fin | syn | rst | ack) fin,syn,ack`
> > will now be equivalent to `tcp flags & (fin | syn | rst | ack) = (fin
> > | syn | ack)`
>
> Yes, those two are equivalent. This is the same example as the one you
> have used at the beginning of this email.
>
> > instead of (ultimately) `tcp flags & (fin | syn | ack)  != 0`?
>
> That's equivalent to:
>
> tcp flags fin,syn,ack
>
> A quick summary:
>
> - If you want an exact match:
>
> tcp flags == fin,syn,ack
>
> - If you want to check that those three bits are set on (regardless
>   the remaining bits):
>
> tcp flags fin,syn,ack / fin,syn,ack
>
> - If you want to check that any of these three bits is set on:
>
> tcp flags fin,syn,ack

This is exactly what I find absurd btw. IMHO it's much better if the
latter just means `tcp flags == (fin | syn | ack)`. I'd rather we keep
`tcp flags & (fin | syn | ack) != 0` and so "unsimplified" or accept
something like `tcp flags { fin / fin, syn / syn, ack / ack }`, if
necessary at all. I think being "obvious" / "unambiguous" /
"straight-forward" enough is much more important than being (too)
"neat".

>
> > Which means `tcp flags & (fin | syn | ack) != 0` should not be
> > translated to `tcp flags fin,syn,ack`?
>
> tcp flags & (fin | syn | ack) != 0 is checking for any of these three
> bits to be set on, this translation is correct.
