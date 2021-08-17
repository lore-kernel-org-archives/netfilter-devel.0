Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6026C4338F
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Aug 2021 04:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B36660E09
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Aug 2021 04:03:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbhHQEE2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Aug 2021 00:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229466AbhHQEE2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Aug 2021 00:04:28 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D94C061764
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Aug 2021 21:03:55 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id j1so29904297pjv.3
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Aug 2021 21:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=kK72pRpuYbOBv6LsxSnqxYQBmPEEuy2Ao7CTaTtCLK4=;
        b=jAEb8oQ79ZEUjCs7+DL/uoueOdqnYXaepao/yOZGTOeDfQdG9oVjDzOwmHChCKqw4j
         4P4XnNRf14BeoU/xm9+YzEtegdsQLIiI+XXajau41PeD6WXi5DI+yLRtV8OpEMVIKmf1
         RuPfwgn/q7PXNvUbAVPvsSySIKP07NXFSSJ3YiZoxQAT87T+91YjBfcdmyxTX8LAJsVp
         gpy/JP7wjSBXK8wim6BYLeZKJEFv+KMAw0ox6Na543zt5vu+auyREncboJWM7xufADzt
         tsF6FsJaleTiHgxOeyhtYppeijzr8gGXlWuu/a3zYDfRqkuMBlCnhxw6waknckfgvJ0J
         iLXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=kK72pRpuYbOBv6LsxSnqxYQBmPEEuy2Ao7CTaTtCLK4=;
        b=dT4GXZZ3WDDKziGZ8DTVvVshhb8yEQk/ZQvo5NFUL7TIpeoWBbSdBpknYIJk7oSDRP
         RlpGEsXD1Vhtm/du7dif2jrTGG42YFtDculflxwOT23Q9JkvsADT2FiLE9BOzwRpCAjc
         wGGutnK9XjWaJGgjC2MEgZw3sr7vmQzN7mG0/dud6byfKJCxTmTMUlpGCvXa2UPbpjZQ
         4N6xe/2eV4Xvt0XjBBkIu6s16hS43BITZwWc9TrKrVklAgWJXIgcFUQv9lp3QqVHsTvY
         sWQ96O9m3ohjzaaCVK5bfe6zSUPx/LtQb2iVElwjWqJ1A43GWYtUGqQ2hFdi25UEvbux
         Yeew==
X-Gm-Message-State: AOAM531ZvRZ8zD8aRGgOyLoi+KvcVyuPHOMuJZCNz/bxma8mkVE81bqE
        GhKlB9YOjheAhFaibiEtCjpD5x5gtS++Iw==
X-Google-Smtp-Source: ABdhPJw/aVNe550zXM68zJ115N6iGV5YOta6l5PqHYGq43kR32Fr0idbzFI8waC2LyVqeRRHUiXWPQ==
X-Received: by 2002:a17:90a:2ac4:: with SMTP id i4mr1489138pjg.157.1629173035252;
        Mon, 16 Aug 2021 21:03:55 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id y8sm688626pfe.162.2021.08.16.21.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 21:03:54 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Tue, 17 Aug 2021 14:03:50 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: nfnetlink_queue -- why linear lookup ?
Message-ID: <YRs1JqWeW7XBrkKV@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <11790_1628855682_61165D82_11790_25_1_3f865faa-9fd8-40aa-6e49-5d85dd596b5b@orange.com>
 <20210814210103.GG607@breakpoint.cc>
 <14552_1628975094_61182FF6_14552_82_1_d4901cb2-0852-a524-436c-62bf06f95d0e@orange.com>
 <20210814211238.GH607@breakpoint.cc>
 <27263_1629029795_611905A3_27263_246_1_ddbb7a24-d843-9985-5833-c7c8c1aa8d29@orange.com>
 <20210815130716.GA21655@salvia>
 <4942_1629034317_6119174D_4942_150_1_d69d3f05-89f7-63b5-4759-ef1987aca476@orange.com>
 <20210815141204.GA22946@salvia>
 <YRpUauSav1HMS+hw@slk1.local.net>
 <20210816161009.GA2258@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816161009.GA2258@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Aug 16, 2021 at 06:10:09PM +0200, Pablo Neira Ayuso wrote: [...]
>
> BTW, leading and trailing netlink message blocks to the kernel are not
> required for nfnetlink_queue.

Sorry, sloppy explanation on my part. This had nothing to do with batches.

The idea was to attain a zero-copy nfq program by using sendmsg with an iov
pointing at the mangled packet, wherever it is. A previous iov has to point to
the struct nlmsghdr that starts the message.

That first buffer ends with the struct nlattr for the packet data addressed by
the next iov.

If padding was required, I was sending a 3rd buffer. It's almost certainly fine
to append the padding to the packet buffer instead, and for sure fine if check
`pktb_tailroom > pad` first.

Then I was sending the ACCEPT verdict in a 4th buffer. As you point out, I could
have sent that earlier, before the trailing struct nlattr.

When I originally started writing nfq programs I was concerned that the kernel
might accept the original packet as soon as it encountered the ACCEPT, and miss
that there was an updated packet following.

I now realise it doesn't work that way, but got stuck with the old order of
doing thins.

So the code would be down to trading 1 kernel user buffer validate against 2
userland data copies. Which method is faster might well depend on packet length.

I don't plan to pursue this further for now.

Cheers ... Duncan.
