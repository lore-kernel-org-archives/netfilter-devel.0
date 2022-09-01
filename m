Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF28DECAAD2
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Sep 2022 07:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbiIAHNN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Sep 2022 03:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233514AbiIAHM7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Sep 2022 03:12:59 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C281243EC
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Sep 2022 00:12:40 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id n65-20020a17090a5ac700b001fbb4fad865so1658950pji.1
        for <netfilter-devel@vger.kernel.org>; Thu, 01 Sep 2022 00:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=+62vKKdOWU4HT/68CsGjJSAqpptlLd13iGzU1vu3Cho=;
        b=V9rAXkNWBAOv6EFqhEXBr6Um74ZiqRFJ0j7+N3/0N6Vjv0gRctwhEFd2eS7oEB59sp
         S1rNHYRJZjvuTq+ob2GNcyMxv3K2ycg2GRaKq+Uyf60Ws5WKxM4dybETDycKY/uBKSOL
         v8/7yvIqDQbSii/iNXNEjGNRMK23OZL4ps8os=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=+62vKKdOWU4HT/68CsGjJSAqpptlLd13iGzU1vu3Cho=;
        b=x40ANTzN3uPWb9o5Ikwg329wiPeev8TWelWImmGspKGhRghZR2/N9Xbg+yZadkRz2y
         x3qNVPGwJtja/wMq8WE24QRZDf9cNynzDzV2FzQwfr29E/RCSyOlhKpUOGlY9mXkEpUq
         TriaX6UGmOR2zcmyYVSHAA1Kub7CV6mb0nWMB3cKKicpqjAg/69n4mqfejbhQOalkZ9p
         oBGKFib3nN0IxuJDcTz5En24A84Ej93KouuvmGuvv612r/ySPto7wjoxdLq/FSAixTIb
         kuGtUgYI9T933ruAo2EaQsRZfZ536NXBKONmek/mMi8wmRz58W9yPbzsBVgqECR8zHRb
         l9Fw==
X-Gm-Message-State: ACgBeo2ImsgFmhsrS/7INcusj3pW+jrb45eozxaKJltWeVv/BpT+FJEL
        vLEhy65zPhQ2dmSv0I/J1ZDvqPCyY+wjtA==
X-Google-Smtp-Source: AA6agR6lqSNmsXlecqs5/BwPbM7JHXhyGGcmWLul0aYun+6avfFe7U/OISjle+0r0+66NJ33d60+cQ==
X-Received: by 2002:a17:903:1c4:b0:175:2c12:6e46 with SMTP id e4-20020a17090301c400b001752c126e46mr9984143plh.145.1662016359696;
        Thu, 01 Sep 2022 00:12:39 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h9-20020a170902680900b0015e8d4eb26esm12881885plk.184.2022.09.01.00.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 00:12:38 -0700 (PDT)
Date:   Thu, 1 Sep 2022 00:12:37 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        syzbot <syzkaller@googlegroups.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Petr Machata <petrm@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] netlink: Bounds-check struct nlmsgerr creation
Message-ID: <202209010012.777DAE2@keescook>
References: <20220901064858.1417126-1-keescook@chromium.org>
 <5aad4860-b1c3-d78f-583d-26281626a49@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5aad4860-b1c3-d78f-583d-26281626a49@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Sep 01, 2022 at 09:06:03AM +0200, Jozsef Kadlecsik wrote:
> Hi,
> 
> On Wed, 31 Aug 2022, Kees Cook wrote:
> 
> > For 32-bit systems, it might be possible to wrap lnmsgerr content
> > lengths beyond SIZE_MAX. Explicitly test for all overflows, and mark the
> > memcpy() as being unable to internally diagnose overflows.
> > 
> > This also excludes netlink from the coming runtime bounds check on
> > memcpy(), since it's an unusual case of open-coded sizing and
> > allocation. Avoid this future run-time warning:
> > 
> >   memcpy: detected field-spanning write (size 32) of single field "&errmsg->msg" at net/netlink/af_netlink.c:2447 (size 16)
> > 
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> > Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
> > Cc: Florian Westphal <fw@strlen.de>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Paolo Abeni <pabeni@redhat.com>
> > Cc: syzbot <syzkaller@googlegroups.com>
> > Cc: netfilter-devel@vger.kernel.org
> > Cc: coreteam@netfilter.org
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> > v2: Rebased to -next
> > v1: https://lore.kernel.org/lkml/20220901030610.1121299-3-keescook@chromium.org
> > ---
> >  net/netlink/af_netlink.c | 81 +++++++++++++++++++++++++---------------
> >  1 file changed, 51 insertions(+), 30 deletions(-)
> 
> Could you add back the net/netfilter/ipset/ip_set_core.c part? Thanks!

*face palm* Yes, thank you. v3 on the way.

-- 
Kees Cook
