Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CDA1C4338F
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Aug 2021 01:38:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C8B360F43
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Aug 2021 01:38:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233816AbhHDBif (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 21:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233389AbhHDBie (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 21:38:34 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E44C06175F
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Aug 2021 18:38:22 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id q2so1203362plr.11
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Aug 2021 18:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=bHcMI3PaOMix9FtjOxoFmY0+6dYhKPLDC5bns4pnGU4=;
        b=bKpPVvcKQABO00gvksZuYrClDxMFdn7+t9aedN+i3xwOeZirMKpAGAV0+gy0q79Yt2
         ZBEU5zUJ6svs5/I0oTI6grvcnIpX5Quga3E9XuYnR13tM/ZiOFavFQzNzaoNuoEaKw/F
         MF7xJOcT2RmJNIGN6mrS1pu5JrCedhJ8U7VV2V/mCBQLebVY05HHUftv9KsS7UGgO6Fp
         7RtLNSH1zQ+1blFLZXd/xA617whiByvu/ILvYl2tG6rN1/CauU656FF3yGlSnYG07jHN
         YYtw8AtXevvy1vcsyksN4TOocDWGHCY2+9CabcGSS2M4S8XalMIrsLBuBS5dAjYcU5Li
         NRIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=bHcMI3PaOMix9FtjOxoFmY0+6dYhKPLDC5bns4pnGU4=;
        b=jypLlOrB5yQiLuC9pxihHRbTuJpROr/kw4a5diM2kQF/V12zyIoQGesv+4edp8pGVC
         8qVp3mAl9XC3lhdF/t2E1A4sI1RD2+hYlobYbL52ZpvfcDaK9ya1K3c/NiO8JZlFMVG4
         bcdlVpZIjdYoAhR0i3g/f3kcULOC+W8QWTUkhabtA9VadJvrg0nyUpi9/5NTtevKfzUc
         eeNOh4Esn9QAZhYFchpRD/QOfmrXYqQi7rFWny/CAyvk/EH/fZQSEZ/x9I8GYLysvz9j
         FCV3jORvxLmGe1ygGCQGG051eTxk55H/A2kJs0gPZgw6lMwL3XnSxzEorYB79F5hilqv
         Qqgg==
X-Gm-Message-State: AOAM531NHTT2C1t9ZzLX67YIz9mgs6H0GNUAPNZt2QJ2YgkUPZjRnqGr
        371jyZGtxHMFrgUiy5VF0bs=
X-Google-Smtp-Source: ABdhPJwRPK2YWSD7YIHVF1h1JmIKtnsPmpfLFgo8ulyFkdJMQPka1moq7+9Gwqfpe8d4fNzz++klEA==
X-Received: by 2002:a17:90b:14e:: with SMTP id em14mr25445713pjb.208.1628041101761;
        Tue, 03 Aug 2021 18:38:21 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id n123sm442912pga.69.2021.08.03.18.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 18:38:21 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Wed, 4 Aug 2021 11:38:16 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v2 1/1] Eliminate packet copy when
 constructing struct pkt_buff
Message-ID: <YQnviH43jzei3lL9@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210504023431.19358-2-duncan_roe@optusnet.com.au>
 <20210518030848.17694-2-duncan_roe@optusnet.com.au>
 <20210527202315.GA11531@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527202315.GA11531@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Thu, May 27, 2021 at 10:23:15PM +0200, Pablo Neira Ayuso wrote:
> On Tue, May 18, 2021 at 01:08:48PM +1000, Duncan Roe wrote:
> > To avoid a copy, the new code takes advantage of the fact that the netfilter
> > netlink queue never returns multipart messages.
[...]
>
> Interesting idea: let me get back to you with a proposal based on this
> patch.
>
> Meanwhile, I have pushed out the __pktb_setup() function which is
> going to be needed:
>
> http://git.netfilter.org/libnetfilter_queue/commit/?id=710f891c8a6116f520948f5cf448489947fb7d78
>
> Thanks.

It also occurred to me to wonder what is the benefit of having struct pkt_buff
be opaque? It's never going to have a buffer tacked on the end of it any more,
so can simply be declared to be sizeof(struct pkt_buff).

Users could read the values of struct members directly rather than having to
learn and use the current procedural interface. That would have to use less
instructions to achieve, but I have yet to benchmark to see if the improvement
is measureable.

We could document when (if ever) the structure may be written to directly but
even if developers break the rules, what damage can they do? This is a userspace
program: they're not going to crash the kernel.

I sidestepped this question in the code by passing down pktb_instance from
local_cb().

Regardless of the above, do you think you might have a proposal for me some time
soon?

Cheers ... Duncan.
