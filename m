Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0523C4338F
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Jul 2021 02:28:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A69936103A
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Jul 2021 02:28:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233297AbhG2C2M (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 22:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233256AbhG2C2M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 22:28:12 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE915C061757;
        Wed, 28 Jul 2021 19:28:09 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id d18so7806177lfb.6;
        Wed, 28 Jul 2021 19:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZiFuRn3UE8R4w3uIIXV4HugCKOA0UGhYmzbbJQgIxcg=;
        b=SkDKe3cUZ/eHl9JQ6CSsP5+mQnFnkJIIZVgNo8qhtWvsBFoShGlQCU1MfraDTMeDdO
         njkn1zfU1r3YhYjrp6Q8VkGt2rqYl/GiFov/cWXH+GhDr2Co0+rzix5FUrEQGGTr97nF
         xYEkGlIjvuwZU12mA6nHHvrueeWSnpOWNu6MflKtCtrkqDcMR+EShMyM1jE7DOI5bN96
         jGvUasU2bNYw+mkVLtN8L4lhpapgszkw7MGRaWpbvcDLdwOTwRFQhqU/PI4yNYc/VUhI
         s0xcPhTMrXKkal+rwQQL2gnW4yk6onpwKC9FeYgqQ4FfUu9T7oLSGu5EJcyKJt75pcz4
         N1jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZiFuRn3UE8R4w3uIIXV4HugCKOA0UGhYmzbbJQgIxcg=;
        b=WUT2EnCGFhL2gpMpdQ5IQkWx01tiYH0TkMqfOJfFVG7nW4sNjj9iCcpngVISGAOqkl
         PBWW+Py7rma9HeiEwbD89WaKT2oJTFiZLLxkJuXmfzjAgj3FNuOs5hs0ALMnpC8308Sb
         dX+jxdaBKpYPMyo78eqlCi9ON0wwuMrVAEHu6+1Cgl/EaQimpxnAoi+Fj67rs2FiaTN0
         fTpEbN/OXmOW6f0cWXtfTXyWX69DJ7bHrezvJ3tI3tuezUJQHgMq73NluFeSThH4pAah
         aErdh+qxZkj01zbB4xC0zBieUZz8v8zt2/t+4pjTAZ/mgwqzBEtS7bY340rQcLMgVOqZ
         A0VQ==
X-Gm-Message-State: AOAM531Ubdqtk4ePagmU4p3OHxBPVVf9gIr8RpUMuEFvIPO9sYIL34e+
        ddKF+ryqo79H9IFC7Vv/GL2nYNCAPv0W9wYf3IE=
X-Google-Smtp-Source: ABdhPJwpLDJP63479IChnwiwvCPjjByMgHiumGWz8KFISOKrSEe0oMnp16gNp1AIdX30Be54Y0UQbVo1Y2KYY8aqEJo=
X-Received: by 2002:a05:6512:1145:: with SMTP id m5mr485273lfg.37.1627525688241;
 Wed, 28 Jul 2021 19:28:08 -0700 (PDT)
MIME-Version: 1.0
References: <CAGnHSEkt4xLAO_T9KNw2xGjjvC4y=E0LjX-iAACUktuCy0J7gw@mail.gmail.com>
 <CAGnHSEncHuO2BduzGx1L9eVtAozdGb-XabQyrS7S+CO2swa1dw@mail.gmail.com> <20210727211116.GA13897@salvia>
In-Reply-To: <20210727211116.GA13897@salvia>
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Thu, 29 Jul 2021 10:27:57 +0800
Message-ID: <CAGnHSEknUAcg=bk1D43oZNMt=4GOZUcqh5Vt6=FU+ebRKtqcWw@mail.gmail.com>
Subject: Re: [nft] Regarding `tcp flags` (and a potential bug)
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Well, same problem as what I mentioned in the last reply from me for
your patch: inconsistent / unexpected meaning of the syntax.

As of the current code (or even according to what you said / implied
"should and would still be right"), `tcp flags syn` checks and checks
only whether the syn bit is on:

# nft --debug=netlink add rule meh tcp_flags 'tcp flags syn'
ip
  [ meta load l4proto => reg 1 ]
  [ cmp eq reg 1 0x00000006 ]
  [ payload load 1b @ transport header + 13 => reg 1 ]
  [ bitwise reg 1 = ( reg 1 & 0x00000002 ) ^ 0x00000000 ]
  [ cmp neq reg 1 0x00000000 ]

which I consider to be a really bad (or even wrong) "shortcut",
because it is so unexpected that it is not the same as this:

# nft --debug=netlink add rule meh tcp_flags 'tcp flags { syn }'
__set%d meh 3
__set%d meh 0
    element 00000002  : 0 [end]
ip
  [ meta load l4proto => reg 1 ]
  [ cmp eq reg 1 0x00000006 ]
  [ payload load 1b @ transport header + 13 => reg 1 ]
  [ lookup reg 1 set __set%d ]

Probably because `{ }` implies a `==`. And as per what you've written
in your other reply to me, apparently a mask implies one as well. So
many things implied. So "neat". But no one (at least not me) knows
what the different syntaxes mean anymore until they --debug=netlink...



On Wed, 28 Jul 2021 at 05:11, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Tue, Jul 27, 2021 at 10:52:39PM +0800, Tom Yan wrote:
> > Just noticed something that is even worse:
> >
> > # nft add rule meh tcp_flags 'tcp flags { fin, rst, ack }'
> > # nft add rule meh tcp_flags 'tcp flags == { fin, rst, ack }'
> > # nft add rule meh tcp_flags 'tcp flags & ( fin | rst | ack ) != 0'
> > # nft add rule meh tcp_flags 'tcp flags & ( fin | rst | ack ) == 0'
> > # nft list table meh
> > table ip meh {
> >     chain tcp_flags {
> >         tcp flags { fin, rst, ack }
> >         tcp flags { fin, rst, ack }
> >         tcp flags fin,rst,ack
> >         tcp flags ! fin,rst,ack
> >     }
> > }
>
> Could you develop the issue you're seeing here?
