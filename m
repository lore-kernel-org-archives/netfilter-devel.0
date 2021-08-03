Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBDCDC4338F
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Aug 2021 18:36:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D29E360725
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Aug 2021 18:36:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236989AbhHCSg3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 14:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234078AbhHCSg2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 14:36:28 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961D4C061757
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Aug 2021 11:36:17 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id t128so29300132oig.1
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Aug 2021 11:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HOoKoF6lVsYsZW51hlGRMZoQASxypRGLpQUaBPRHma4=;
        b=MOr5z4EhDspbNpcgqR+rNg8VOp4jy0vztXDrJhy/0ZlAAuWuNGcBixDtx53oVE5MSR
         3zqLULHlKbLhPOpxSPJz6wiiMd7zjrdQXK+Rw7PHFZx4omigT1K0bBkoN9T6yJfebYbk
         yg8On1rBMEcRFdphMwvJr1ljR8ryShVfTJ7FY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HOoKoF6lVsYsZW51hlGRMZoQASxypRGLpQUaBPRHma4=;
        b=EXCbeZicHHVX8JSQTYCfQPqZ8DJVzxblBDiqTKbdZ/OgR71QhoF5y7b1TON+HkyBub
         OJQaEB0fnGUYgLRYJyUl3hZ4uk+BT7qmX/eF7Mk3GDEb9f7ukwpt/4ad+MIuGyTZRNOJ
         taWI+gTrfao6gFNsMZ/30pP5MPpc6fsgYBjFljncmMjEOifAKuRbJDD4l4axWU1zt/u/
         fdZN0FkVB57KA8nYNv6ImwPSlwlNJiI2PYKRS8Bz8P3URS+bwUFm15rQ7ix7W3L/AQtY
         dNfGValzH12S9kEf4Dm67Ejd5vDS+U6J8nsgjB+GXF23QGNoq0haUOo5kMJONWB6iE3T
         Jrdg==
X-Gm-Message-State: AOAM533SvxNDF06KO6xFK1Y+0xJreQfEiztYETE7xhK6G5C8au9fGhbn
        zasjXUKfsD6qPqLxbVLm/vDHLA==
X-Google-Smtp-Source: ABdhPJzFzEaETs9E0TtBbK5eiwXthohf4SYE2mxcw7b2hLCj7c+8w/LIqOs39Af04qWg/msyaHARGg==
X-Received: by 2002:a54:4806:: with SMTP id j6mr15670767oij.66.1628015776953;
        Tue, 03 Aug 2021 11:36:16 -0700 (PDT)
Received: from C02XR1NRJGH8 (65-36-81-87.static.grandenetworks.net. [65.36.81.87])
        by smtp.gmail.com with ESMTPSA id bg9sm2578725oib.26.2021.08.03.11.36.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 11:36:16 -0700 (PDT)
Date:   Tue, 3 Aug 2021 13:36:04 -0500
From:   Kyle Bowman <kbowman@cloudflare.com>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Phil Sutter <phil@nwl.cc>, Alex Forster <aforster@cloudflare.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        coreteam@netfilter.org, netfilter-devel@vger.kernel.org
Subject: Re: [netfilter-core] [PATCH] netfilter: xt_NFLOG: allow 128
 character log prefixes
Message-ID: <YQmMlAheX6Tmg2qJ@C02XR1NRJGH8>
References: <20210727212730.GA20772@salvia>
 <CAKxSbF3ZLjFo2TaWATCA8L-xQOEppUOhveybgtQrma=SjVoCeg@mail.gmail.com>
 <20210727215240.GA25043@salvia>
 <CAKxSbF1cxKOLTFNZG40HLN-gAYnYM+8dXH_04vQ8+v3KXdAq8Q@mail.gmail.com>
 <20210728014347.GM3673@orbyte.nwl.cc>
 <YQREpVNFRUKtBliI@C02XR1NRJGH8>
 <YQasUsvJpML6CAsy@azazel.net>
 <YQfU8km0t3clPVhl@azazel.net>
 <YQggBDBruNxkscoi@azazel.net>
 <YQkHIamDpqBzmNrO@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQkHIamDpqBzmNrO@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 03, 2021 at 10:06:41AM +0100, Jeremy Sowden wrote:
> 
> Right, take three.  Firstly, use udata as I previously suggested, and
> then use a new struct with a layout compatible with struct xt_nflog_info
> just for printing and saving iptables-nft targets.
> 
> Seems to work.  Doesn't break iptables-legacy.
> 
> Patches attached.
> 
> J.

Hey Jeremy,
Thanks for writing in and helping with this, I appreciate it. I
actually was trying to make this work last night in a similar way to
how you've solved it but I gave up after a few hours. I'll go ahead and
organize this together and send the patches in a separate thread.

Kyle
