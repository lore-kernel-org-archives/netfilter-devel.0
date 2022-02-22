Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDDBAC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Feb 2022 01:39:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbiBVBkU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Feb 2022 20:40:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiBVBkT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Feb 2022 20:40:19 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FBF2559E
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Feb 2022 17:39:53 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id j10-20020a17090a94ca00b001bc2a9596f6so917942pjw.5
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Feb 2022 17:39:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:date:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=gpIzKeVHyejvkXFT/K+CQO84m4FK4G0ogmsBCo9DuOg=;
        b=Qure99vumOyy3PsF76ICpK/u4NMKW5AlpsDbsLYoBTDZ9561F8PkxzDHRV7ZYjvwcC
         s2P56a4nrrRoldBJZfUce0X50TBrKueV2E6Oj5/ud6jnEQhKzU6HjBorHYZ7yTmB94v+
         AykpuvJgBS1oodaeWGkOwSzpby0DKVHR2OfKEgkraQaelNmvFJtF82C4qWYnbcWJ7V2g
         7ybz4O60DouC1hyYe6EiT3i7QJW5wZmCtCxddTNhwUAVMlsGiJP8SKOT10F+HKdTKvTD
         vVSw8T1jgVWvCroLpGDjQ/lbkufPIVGiuMVRI98iSMR12DLlLQNq1kV7+xlhEQ2zG+b9
         Gdwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :reply-to:mail-followup-to:references:mime-version
         :content-disposition:in-reply-to;
        bh=gpIzKeVHyejvkXFT/K+CQO84m4FK4G0ogmsBCo9DuOg=;
        b=MiGK05jEbTHf91+GDdcDLiVt2OTv3e9IUmIw3pQYSn7ONLbaMO1SjCGajdrQ7WR+yd
         xFuGOsYkr+O11PEpN7DzspTr0gbz2gmvLmmWNX0k3IMZLFwPRYbSJxLzaw4WtDl45k4k
         PIT7HTbHhGoZzCmnJ3r+WzHNuoNFJII0Qsjp7T9tET7UaVzlh+0P6MDceup7aDjCwnlu
         eUsEFRAa3oJdmSk/03ZYuF2wnS6vPWccDEZ+4s27wWRtm33ECrEdd00UpvfyN2+XromS
         4Sw4ZFd2I/WhRZ/LuLO8TbHVJ2raSIO9DRwmqFD2NNq27pKnFiFt4hJOnvYy9uN26OS2
         froA==
X-Gm-Message-State: AOAM530mZBoxFACy1ulb8fOeI8jNJyxQ+UQHh6Ak8i+egdZ7OJVpteU/
        PzFpxsPn8dENzp8QWZGyI+G5Wy69cxT0Yg==
X-Google-Smtp-Source: ABdhPJygsJ2FZqIM/NsdizeV7LW81NIO/ep2FQC/mHO7T8QuRyZUH9A82iIe+EEWfNpvtb4YwgE3fg==
X-Received: by 2002:a17:902:7786:b0:14d:51c6:21a8 with SMTP id o6-20020a170902778600b0014d51c621a8mr21497231pll.75.1645493993110;
        Mon, 21 Feb 2022 17:39:53 -0800 (PST)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id f7sm10537878pfv.93.2022.02.21.17.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 17:39:52 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Tue, 22 Feb 2022 12:39:48 +1100
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v3 1-5/5] src: Speed-up
Message-ID: <YhQ+5NNO8o2753Hs@slk1.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20220109031653.23835-1-duncan_roe@optusnet.com.au>
 <20220109031653.23835-6-duncan_roe@optusnet.com.au>
 <YeYClrLxYGDeD8ua@slk1.local.net>
 <YeYTzwpxiqLz8ulb@salvia>
 <YejdVZaoUz+t1qRU@slk1.local.net>
 <20220120120458.GF31905@breakpoint.cc>
 <YelYKewDL7UkeQZf@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YelYKewDL7UkeQZf@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jan 20, 2022 at 01:40:09PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Jan 20, 2022 at 01:04:58PM +0100, Florian Westphal wrote:
> > Duncan Roe <duncan_roe@optusnet.com.au> wrote:
> > > On Tue, Jan 18, 2022 at 02:11:43AM +0100, Pablo Neira Ayuso wrote:
> > > >
> > > > This patch have a number of showstoppers such as exposing structure
> > > > layout on the header files.
> > > >
> > > That's only in patch 5. You could apply 1-4. There are actually no other
> > > showstoppers, right?
> >
> > Regarding patch 5, I think its ok except the pkt_buff layout freeze.
> >
> > From a quick glance, there is no assumption that the data area resides
> > after the pktbuff head, so it should be possible to keep pkt_buff
> > private, allocate an empty packet and then associate a new buffer with
> > it.
>
> Or allocate pktbuff offline and recycle it (re-setup) on new packets
> coming from the kernel, it does not need to be allocated in the
> stack and exposing the layout is also therefore not requireed.

I put it on the stack to get thread locality w/out the (admittedly small)
overhead of using thread_local. We could have a pktbuff_size() to dimension it
and keep the struct opaque.

It's 48 bytes (64 bit) so I thought it was OK on the stack but you could
malloc() it and only have a pointer (again on the stack for thread locality).

Cheers ... Duncan.
