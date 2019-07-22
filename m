Return-Path: <SRS0=3WFO=VT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE745C76188
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 08:31:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B820C2199C
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 08:31:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZOZpvJF1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbfGVIb6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jul 2019 04:31:58 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:39569 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727304AbfGVIb6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jul 2019 04:31:58 -0400
Received: by mail-io1-f66.google.com with SMTP id f4so72111812ioh.6
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jul 2019 01:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ryhckk+AP9BRmcgFRVEKP7WuIy4Y4V24+VcwTrJ56vQ=;
        b=ZOZpvJF1GARQ9NC1C4fgu/cNgsNBAL3C93R+pLEqt8JSPd43lLBNBp5EnCI3DN3MF5
         WLSmuyp3ko1bsUPfovrkRKTJoIqBBAhr52z1ilPvvXmdw5ZgY5bOupnmPMBekUtn7RXH
         L3mBLm60NbIBtQduivZqglS2q3s3di3oPD9PsmhAzaBbfYNJiRLy28uvaPVEEpKUsFtL
         nvIeuVWdnIdvL2/8DCn+0txv+icu0aai/cbc8CiPDMOXplbmwyC1wXO6xJ/rJBHi/Rse
         so8MnratCi5w7f0WeS5Ix0JPiPp9g90IG+WRNezbIwStV1qNeQ5fWUAonbIzlaW10Lgm
         4dEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ryhckk+AP9BRmcgFRVEKP7WuIy4Y4V24+VcwTrJ56vQ=;
        b=XGL6HfemBFxPg1b1oFJ20Z/Qn+YXYwrJWLMLYhwKJyJHkBg9U4/HhqlSe3jnZljVrH
         cLJDHsjIVrC5nU30M0rEQw2u8XBoFb5NDEp5qDj7001GG2BMFpcvfoU0T1q+hB2jf+QZ
         e22Bni2G94Ql4XLdhjfU07eyOD+ZgaSn2BA+Pkr+fxCYPB9bvFO1xoiLKC27Wo4reAQq
         Hg3tcm+BxKngzjS0rXz8NuYKEhwmVNHR3R4eQNY7OcMJFwuGH8tUBwm0ufTANwyRm1LT
         Di1xwvtf1+JzmIGVCloCKkwzBNCfPb9d+UeXJq3ISV+2XM+2kKbBslI30XlGo3WaeXJO
         24OQ==
X-Gm-Message-State: APjAAAUw6Cre+fyF5goQfUavsulZm9C6y+6PD2GcT3TRUjZthLsVOo8V
        3vtH1FR3Ym5NdfJxUB5Iysg53deHqH+LW03tApc=
X-Google-Smtp-Source: APXvYqygAkV3eRPaQwTvJxtH9xRUY7ZjN6nBVNj1w5YmnTQ080sYeg6IM0Ru/G7msGD7RujCIbvlYO2zcNzISGz03Hk=
X-Received: by 2002:a5d:8508:: with SMTP id q8mr63972685ion.31.1563784317073;
 Mon, 22 Jul 2019 01:31:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAK6Qs9k_bdU9ZL4WRXBGYdtfnP_qhot0hzC=uMQG6C_pkz3+2w@mail.gmail.com>
 <1561441324-19193-1-git-send-email-ibrahim.ercan@labristeknoloji.com>
 <20190627185744.ynxyes7an6gd7hlg@salvia> <20190627190019.hrlowm5lxw7grmsk@breakpoint.cc>
 <20190627190857.f6lwop54735wo6dg@salvia> <20190627192109.zpkn2vff3ykin6ya@breakpoint.cc>
 <20190627192705.eyy4aond5yl5jjrr@salvia> <20190701185825.32mmnw4jdtsj7avr@salvia>
In-Reply-To: <20190701185825.32mmnw4jdtsj7avr@salvia>
From:   =?UTF-8?Q?=C4=B0brahim_Ercan?= <ibrahim.metu@gmail.com>
Date:   Mon, 22 Jul 2019 11:31:45 +0300
Message-ID: <CAK6Qs9mp7E3Wr4Zo8mLgsbLMwZRCaQoy=3nRx3XDJP4mcgNSEA@mail.gmail.com>
Subject: Re: [PATCH v2] netfilter: synproxy: erroneous TCP mss option fixed.
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Ibrahim Ercan <ibrahim.ercan@labristeknoloji.com>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 1, 2019 at 9:58 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> Hi Ibrahim,
>
> On Thu, Jun 27, 2019 at 09:27:05PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Jun 27, 2019 at 09:21:09PM +0200, Florian Westphal wrote:
> > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > On Thu, Jun 27, 2019 at 09:00:19PM +0200, Florian Westphal wrote:
> > > > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> [...]
> > > > I see, probably place client_mss field into the synproxy_options
> > > > structure?
> > >
> > > I worked on a fix for this too (Ibrahim was faster), I
> > > tried to rename opts.mss so we have
> > >
> > > u16 mss_peer;
> > > u16 mss_configured;
> > >
> > > but I got confused myself as to where which mss is to be used.
> > >
> > > perhaps
> > > u16 mss_option;
> > > u16 mss_encode;
> > >
> > > ... would have been better.
> >
> > I would leave the opts.mss as is by now. Given there will be a
> > conflict between nf-next and nf, I was trying to minimize the number
> > of chunks for this fix, but that's just my preference (I'll have to
> > sort out this it seems).
> >
> > Then, adding follow up patches to rename fields would be great indeed
> > as you suggest.
>
> @Ibrahim: Would you follow up with patch v3?
>
> I'd name this 'mss_backend' to opts, instead of adding client_mss as
> parameter. Since this is the MSS that the server backend behind the
> proxy.
>
> I don't mind names, if you prefer Florian's, that's also fine. I'd
> just like not to add a new parameter to synproxy_send_client_synack().
>
> Thanks.

Sorry for late reply. I was offline for 3 weeks. I will send new patch asap.
