Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 207C6CA0EC3
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Sep 2023 06:20:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjILGUM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Sep 2023 02:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjILGUL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Sep 2023 02:20:11 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563AFE79
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Sep 2023 23:20:07 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-68fb46f38f9so1891891b3a.1
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Sep 2023 23:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694499607; x=1695104407; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RS7+jLODvzxADj9eQis8o3ousHgdj6aH8QlnUMJFzyw=;
        b=TN3kWViPXaVjwmssscNyseIMyorAqWuCpdW90mV6MCQMcadKXdMOwtyFqqWhA+m8tn
         Mww+tHHqW+k/7PNEx0yXAjuGMSrJgbhHQ8M1AnLanT8ccaLdkOeb7qXXlcUxDsd82A8J
         uwmXGdwLj6D4bwIUdxtPQqCBpWF9jlfEyzRubXr+FWMuLqjpp0TR3v90glIUCA7zlTkN
         5SOZ8AyHKWxyegjloOJt90HdqsxzEwsjGVoxtgOqWv3sNS60m7BjO0RPcYbaw0i6GSr9
         60HJndpGsXW4VwIE6YNzIKRpGY/MNRuIw9JHWqi6YbBidOVne36fq7EO00Q7AyNRuFKS
         nqrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694499607; x=1695104407;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RS7+jLODvzxADj9eQis8o3ousHgdj6aH8QlnUMJFzyw=;
        b=cZyB5Rw4HUUzKLABw2lgSvnAP2moE1A4sgHBEbDPnDJpgLzRt8cIUvsGMNM1FxGOgq
         BTFMwTp4rUTIAm+vnLx94sjyV//va/iJZcsDM8f3M8TAMQWSvk9r06H9iiadJRZohlbt
         cvVKdhH9RQWNfLIQUQkx6K7olAcg1z/M6GzMTdhowJVLRGiqbO7z/jXfPuGM/JSsQaia
         FcreK2Ek7Cjpxfca1gOZvBpx8mSseIESSUlxsidP2p7M4vwexXTT/sKYwdawal9HnRle
         tGkJGGuWkNPp4eTLhJnBnEhJmUhy5gDN+k450rVOCBk8B/yQa0BmU+EKPAOlZgci3JoE
         Rd2Q==
X-Gm-Message-State: AOJu0YzN/cYZVSsWE74u5+TguGz8xthlRz+fcOBrIE/Jr7UljoSCcjcq
        eAGwE5fiJp+YVCA2oz4qdI+iIygmwxY=
X-Google-Smtp-Source: AGHT+IGJkJEPymxayOTMfp4cbZmABoJ1Wb0xK/60TsPlxDZHgcFAbQUgfu/KnC9brNKkXQh+0+vENg==
X-Received: by 2002:a05:6a00:2386:b0:68b:f529:a329 with SMTP id f6-20020a056a00238600b0068bf529a329mr11147849pfc.5.1694499606668;
        Mon, 11 Sep 2023 23:20:06 -0700 (PDT)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id c21-20020aa78c15000000b0068bade042besm6627363pfd.48.2023.09.11.23.20.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 23:20:06 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date:   Tue, 12 Sep 2023 16:20:03 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH RFC libnetfilter_queue] doc: Get rid of DEPRECATED tag
 (Work In Progress)
Message-ID: <ZQADE0GDMLN/xDDr@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20230911055425.8524-1-duncan_roe@optusnet.com.au>
 <ZP7G68U/HKxIkUmp@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZP7G68U/HKxIkUmp@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Sep 11, 2023 at 09:51:07AM +0200, Pablo Neira Ayuso wrote:
> On Mon, Sep 11, 2023 at 03:54:25PM +1000, Duncan Roe wrote:
> > This is a call for comments on how we want the documentation to look.
> > In conjunction with the git diff, readers may find it helpful to apply the patch
> > in a temporary branch and check how the web page / man pages look.
> > To get web & man pages, do something like
> >
> > ./configure --enable-html-doc; make -j; firefox doxygen/html/index.html
> > MANPATH=$PWD/doxygen/man:$MANPATH
> >
> > Some changes are documented below - I'll post more later
> >
> > --- Preparation for man 7 libnetfilter_queue
> > The /anchor / <h1> ... </h1> combo is in preparation for making
> > libnetfilter_queue.7 from the main page. mainpage is morphed to a group
> > (temporarily) so all \section lines have to be changed to <h1> because \section
> > doesn't work in a group. The appearance stays the same.
> >
> > ---1st stab at commit message for finished patch
**                 ^^^^^^
> > libnetfilter_queue effectively supports 2 ABIs, the older being based on
> > libnfnetlink and the newer on libmnl.
>
> Yes, there are two APIs, same thing occurs in other existing
> libnetfilter_* libraries, each of these APIs are based on libnfnetlink
> and libmnl respectively.
>
> > The libnetfilter_queue-based functions were tagged DEPRECATED but
** s/libnetfilter_queue/libnfnetlink
> > there is a fading hope to re-implement these functions using libmnl.
> > So change DEPRECATED to "OLD API" and update the main page to
> > explain stuff.
>
> libnfnetlink will go away sooner or later. We are steadily replacing
> all client of this library for netfilter.org projects. Telling that
> this is not deprecated without providing a compatible "old API" for
> libmnl adds more confusion to this subject.

I suggest there's bound to be confusion whilstever libnetfilter_queue and the
other libraries support two APIs. The question is how to minimise this
confusion. 3 suggestions:

1. Split out the old API functions to their own library, say libnfnetlink_queue.

2. Don't tag functions at all, but put something very obvious at the head of
mainpage(*) explaining thare are 2 ABIs and the pros & cons of each.

3. Tag the libnfnetlink-based functions with something other than DEPRECATED.
"OLD API" was my suggestion, do you have another?

How about this re-worded paragraph (in the COMMIT message, *not* the
documentation!):

The libnfnetlink-based functions were tagged DEPRECATED but they are not. Change
DEPRECATED to "OLD API" and update the main page to explain the difference.

I was really hoping for comments on the rest of the patch. Would you find time
to take a look?
>
> If you want to explore providing a patch that makes the
> libnfnetlink-based API work over libmnl, then go for it.

Others have tried. Recall this conversation:

On Thu, Jan 20, 2022 at 01:15:22PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Jan 20, 2022 at 01:01:45PM +0100, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >
> > > The documentation is tagging the old API as deprecated which is not,
> > > this needs to be reverted.
> >
> > Hmm, IIRC i tried to reimplement it on top of libmnl but there were too
> > many libnfnetlink implementation details leaked into the old api.
>
> I guess these two are the problematic ones to move to libmnl:
>
> - nfq_open_nfnl()
> - nfq_nfnlh()

With regard to nfq_open_nfnl() and nfq_nfnlh(): neither of these are documented.
Anyone using them has found them in the source. They are also using libnfnetlink
directly.

My first step in moving to libmnl would to to make those two static, or at least
remove EXPORT_SYMBOL for them. If anyone complains, tell them to copy from
source into their application.

(*) Soon to double as libnetfilter_queue.7, if you apply that patch once I've
finished it.

Cheers ... Duncan.
