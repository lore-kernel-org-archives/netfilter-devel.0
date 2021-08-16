Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92DC3C4320A
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Aug 2021 12:05:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78B0C63244
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Aug 2021 12:05:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbhHPMFh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Aug 2021 08:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbhHPMFg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Aug 2021 08:05:36 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC58AC061764
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Aug 2021 05:05:05 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id nt11so26159084pjb.2
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Aug 2021 05:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=IYyl10unXYus3dM3CwNnNj7eV4KMRl9CF+ZQj4+ALr0=;
        b=QkPk8KqxVWWkUkv6C0q7JYRswq8wT+XQdbEkGtiyzXE4DyhD+PQq/yHxZMmblosfT1
         2mBr4SGDvlM4TElKjhCrA9cYGXKGmWRRsfMqtIHEIkHr1AVOjFCda9VajlV140oQlJTf
         42Yhp656VNamuPYFlGzHXzyEKnMclhkVyZF8NgHXwPn8Ras1Uhhp+qcYDbqyMQrrjFyo
         Q7bPrcMZyM4d2b6WnA8OWb1+FiAkTH4RUz85cIrzg/oyXMYRg0XfnkZJ+7/QoSD1Gtm9
         SOr7OVfFsiakR4dTiMtbCizegygu5Z2obq36o/dQb48Oo2ShXelNQxuG8avcfvJx31lk
         hzwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=IYyl10unXYus3dM3CwNnNj7eV4KMRl9CF+ZQj4+ALr0=;
        b=OBtXvB27n/MzwSf4GRBiMyo9Dl9UlizoeBSHk0axd2doMpiCm0kWfcGlMGcyiQ0A+p
         dxszAvlJLQeBH5M4fVIcofIeOibu48xqehwe3aI3a1mZ0PkMyMMlmv3EgMm7F7jMdq7L
         KQNssubH7woE9/iVtTr427la7yCJRBYXljrw3PRHzbTm+pUEXuhXHit5BZoJqgh4JMXz
         R02bp1IzELsqiNN4h66mfj83jqbpY9KcKM5f831c1ZWNGR2k+zbbo9sx3ChjFPz1Dncd
         Rzk1rtnJYouZ9jlJmZl9nZ9zHzf9BID3R3dG34GIzYnKjSrvD2mdZeB5ioNYP6oTI9qJ
         QdaA==
X-Gm-Message-State: AOAM533KPQAeeCD1TYC0x9QvfGjQTuLz77tWwPetcHn/CJcesHrTKcSa
        /FHDMHgdpIowqwQmxq3oZac=
X-Google-Smtp-Source: ABdhPJw3m9pMgKL5hzr280KTYOJkHGTVGm92mdiyrYsU980Mhr5ywqg4p6z8PoCLRiDJgF9xh6nvHQ==
X-Received: by 2002:a17:902:b612:b029:12c:e9e5:b1bf with SMTP id b18-20020a170902b612b029012ce9e5b1bfmr13169211pls.54.1629115505191;
        Mon, 16 Aug 2021 05:05:05 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id 73sm4288442pfz.73.2021.08.16.05.05.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 05:05:04 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Mon, 16 Aug 2021 22:04:58 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     alexandre.ferrieux@orange.com, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: nfnetlink_queue -- why linear lookup ?
Message-ID: <YRpUauSav1HMS+hw@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        alexandre.ferrieux@orange.com, Florian Westphal <fw@strlen.de>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <11790_1628855682_61165D82_11790_25_1_3f865faa-9fd8-40aa-6e49-5d85dd596b5b@orange.com>
 <20210814210103.GG607@breakpoint.cc>
 <14552_1628975094_61182FF6_14552_82_1_d4901cb2-0852-a524-436c-62bf06f95d0e@orange.com>
 <20210814211238.GH607@breakpoint.cc>
 <27263_1629029795_611905A3_27263_246_1_ddbb7a24-d843-9985-5833-c7c8c1aa8d29@orange.com>
 <20210815130716.GA21655@salvia>
 <4942_1629034317_6119174D_4942_150_1_d69d3f05-89f7-63b5-4759-ef1987aca476@orange.com>
 <20210815141204.GA22946@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210815141204.GA22946@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Aug 15, 2021 at 04:12:04PM +0200, Pablo Neira Ayuso wrote:
> On Sun, Aug 15, 2021 at 03:32:30PM +0200, alexandre.ferrieux@orange.com wrote:
> > On 8/15/21 3:07 PM, Pablo Neira Ayuso wrote:
> > > On Sun, Aug 15, 2021 at 02:17:08PM +0200, alexandre.ferrieux@orange.com wrote:
> > > [...]
> > > > So, the only way forward would be a separate hashtable on ids.
> > >
> > > Using the rhashtable implementation is fine for this, it's mostly
> > > boilerplate code that is needed to use it and there are plenty of
> > > examples in the kernel tree if you need a reference.
> >
> > Thanks, that's indeed pretty simple. I was just worried that people would
> > object to adding even the slightest overhead (hash_add/hash_del) to the
> > existing code path, that satisfies 99% of uses (LIFO). What do you think ?
>
> It should be possible to maintain both the list and the hashtable,
> AFAICS, the batch callback still needs the queue_list.
>
> > > > PS: what is the intended dominant use case for batch verdicts ?
> > >
> > > Issuing a batch containing several packets helps to amortize the
> > > cost of the syscall.
> >
> > Yes, but that could also be achieved by passing an array of ids.
>
> You mean, one single sendmsg() with several netlink messages, that
> would also work to achieve a similar batching effect.

sendmsg() can actually be slower. I gave up on a project to send verdicts using
sendmsg() (especially with large mangled packets), because benchmarking showed:

1. on a 3YO laptop, no discernable difference.

2. On a 1YO Ryzen desktop, sendmsg() significantly slower.

sendmsg() sent 3 or 4 buffers: 1. leading netlink message blocks; 2. the packet;
3. padding to 4 bytes (if required); last: trailing netlink message blocks.

sendmsg() saved moving these data blocks into a single buffer. But it introduced
the overhead of the kernel's having to validate 4 userland buffers instead of 1.

A colleague suggested the Ryzen result is because of having 128-bit registers to
move data. I guess that must be it.

The spreadsheets from the tests are up on GitHub:
https://github.com/duncan-roe/nfq6/blob/main/laptop_timings.ods
https://github.com/duncan-roe/nfq6/blob/main/timings.ods

Cheers ... Duncan.
