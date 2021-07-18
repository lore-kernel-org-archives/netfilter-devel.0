Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D4D9C636C8
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Jul 2021 04:29:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FB5761176
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Jul 2021 04:29:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbhGREbs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 18 Jul 2021 00:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbhGREbr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Jul 2021 00:31:47 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753B1C061762
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Jul 2021 21:28:49 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id j199so13089835pfd.7
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Jul 2021 21:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=+9dKQBOGrECZgqIVNPMm8n9n4P1SgQRQezNLqtL9DWo=;
        b=P7MpVwbZZXdBaSoDK4dv5rlgQ+XYfngikH+bzP9NkP0Dpogp3b3HlhfvK9w4g3g5RV
         vBGaj6PzxK8je1c/Xxjgh2aOIrMivFYVztMZVr2juAga3uUcG+VeTKQ6eBj6iy3Gzrck
         1x+iGrakGitjl4+P4c/Mce8iG8306ey5DXCyFQCpRHIAaa67DP7hFQCDh0jDivFYh4t/
         A28WRvFhdMwoiFANM9o9T3xHHt7cI9gyICcqQnyRhUxEuT0qkxikzM9J5QypADfX2irs
         JfY/SHqfazijrUIh3V5AAlcCwKRUfjFx60BmeWh9UYxwoyIUs3bHlLo//HEO7dcUugAa
         DuWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=+9dKQBOGrECZgqIVNPMm8n9n4P1SgQRQezNLqtL9DWo=;
        b=A78k+mH0Z+Z62PffFhhKRkpTshmUlOmV+lUHqi3c16rvpt3IOC8hgJgiNVeuoZdH/u
         4ZzxFVlCYHsxSyGRz38nW/o2BiOd6INxP6pBoTkrCZtO2JLOMho2Qu2MFhC1AZ4qSMYW
         Z8oiXMDtSqDWNGVSGHhx2grdIRPbSEZA5qR1brJToXUiIlUdkKu+AILrwQvx3DLwfh2x
         GUzz9IUEQSrRtqiFA4zcXMcjO0KmAkqkywSEWwNzp9pk5DEm1ugDB3qSiiornVVOEScO
         vVigZgunWNw4+yS1QeClr6MCMqnPLAWu+XjRHO4SF6YfchSWXaxl6+JwZOoVPftHU5vB
         hXug==
X-Gm-Message-State: AOAM530asqx2XfdljFy+MTmkKXcFUqsjcfMZIg+0GMV9NIPV1Nt8krQG
        uq2sPNpkimK5R5YJApulz4Y=
X-Google-Smtp-Source: ABdhPJzhazYlyrmqs0ceRpmnrWneb7Lc59E7XQpvIfPIv0YY9xDwaFEQUKtTptnZQl2vcXhkHp0CEQ==
X-Received: by 2002:a63:4e5d:: with SMTP id o29mr11489700pgl.379.1626582527522;
        Sat, 17 Jul 2021 21:28:47 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id o184sm16770704pga.18.2021.07.17.21.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jul 2021 21:28:47 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Sun, 18 Jul 2021 14:28:42 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v2 1/1] Eliminate packet copy when
 constructing struct pkt_buff
Message-ID: <YPOt+geUUmZef2Nt@slk1.local.net>
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

On Thu, May 27, 2021 at 10:23:15PM +0200, Pablo Neira Ayuso wrote:
> On Tue, May 18, 2021 at 01:08:48PM +1000, Duncan Roe wrote:
> > To avoid a copy, the new code takes advantage of the fact that the netfilter
> > netlink queue never returns multipart messages.
> > This means that the buffer space following that callback data is available for
> > packet expansion when mangling.
> >
> > nfq_cb_run() is a new nfq-specific callback runqueue for netlink messages.
> > The principal function of nfq_cb_run() is to pass to the called function what is
> > the length of free space after the packet.
> > As a side benefit, nfq_cb_run() also gives the called functio a pointer to a
> > zeroised struct pkt_buff, avoiding the malloc / free that was previously needed.
> >
> > nfq_cb_t is a new typedef for the function called by nfq_cb_run()
> > [c.f. mnl_cb_t / mnl_cb_run].
>
> Interesting idea: let me get back to you with a proposal based on this
> patch.
>
[...]

It occurred to me there is no real need to use a callback any more.

However, mnl_cb_run() does some checks before and after invoking the cb.
Some of these checks may still be valid, so leave it as_is?

This patch has been on the table for a while, any idea when you might find time
to respond?

Cheers ... Duncan.
