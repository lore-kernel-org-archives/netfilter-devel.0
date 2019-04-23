Return-Path: <SRS0=M2Uw=SZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86E9EC282DD
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Apr 2019 20:19:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E18B21850
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Apr 2019 20:19:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=untangle.com header.i=@untangle.com header.b="ksMSOe9t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfDWUTB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Apr 2019 16:19:01 -0400
Received: from mail-qt1-f179.google.com ([209.85.160.179]:33181 "EHLO
        mail-qt1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfDWUTA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Apr 2019 16:19:00 -0400
Received: by mail-qt1-f179.google.com with SMTP id g7so10251750qtc.0
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Apr 2019 13:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=untangle.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=w3OvMBR/fbL2hwYy9Z7ZHl7JvyZZAfttmhqcQR5GtS0=;
        b=ksMSOe9tQb+6QwE4qqmCu78L0bbsDvxWKKBvHXU+v7dpw+zfXY99zBjYjGykSQR5no
         VXa9BicRvrqF5QsObpeqoeH5cwJJR33pJISz1Ws1sExtglCXajhai8wjYTht4flfQKUl
         1GKcpbeYwXMSz2aPOcDCl1Z3tB6J6D5/zZqfs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=w3OvMBR/fbL2hwYy9Z7ZHl7JvyZZAfttmhqcQR5GtS0=;
        b=FAod0CZaAU2Wk6EE2rJt9Qe1I9WSk1O1sNz7HF1419gbBAw33YYn0zKlSNaAvfxgUB
         w1mg2Q4w+nx14P69B/DqnS/pcKSCr9yuLH3inR+PDZz8W8wBWSn9kzvT7s/eAx0pIv9U
         NwKgHUwR6i/wfE2400MzZfqwZuSBYxyXtQj+cGwSmHjfZQ+jH2fB4PeyCojW1JSWM6/x
         YuCbD+NY/D9uGTft0HLwuMaB3LzdT5T54uR1WAaRsj0qLHxM5go6w4Zn8mSVMXJAY0L0
         KHCCSlMX5G8yY9GfMlyZVC6ztB7PLLDEqG5snaFE6mqIDotYrRERUvBANXa3o/WwIdYC
         jVXw==
X-Gm-Message-State: APjAAAWauXT1zfgfZhzWxvAyb7mEuSE/o55KHuHD6yOIv0sQ7j118FiI
        Q9RSiIcji4trlMdWmhZAQKdnObic13g=
X-Google-Smtp-Source: APXvYqzd2lm8+oJC8gaYTd4hWjjJPXe4dMSLTu0VEg/PoE5ej4tlUBJnwIgKCkvcapm62auket4ZsA==
X-Received: by 2002:a0c:b64c:: with SMTP id q12mr22660806qvf.50.1556050739874;
        Tue, 23 Apr 2019 13:18:59 -0700 (PDT)
Received: from pinebook (cpe-74-137-94-90.kya.res.rr.com. [74.137.94.90])
        by smtp.gmail.com with ESMTPSA id n21sm2883226qkk.30.2019.04.23.13.18.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Apr 2019 13:18:59 -0700 (PDT)
Date:   Tue, 23 Apr 2019 16:18:57 -0400
From:   Brett Mastbergen <bmastbergen@untangle.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, dmorris@untangle.com
Subject: Re: dict: A netfilter expression for dictionary lookups
Message-ID: <20190423201857.GA3116@pinebook>
References: <20190328195857.GA24011@pinebook>
 <20190411192248.7harez523hlkhh3e@breakpoint.cc>
 <20190412141834.GA25271@pinebook>
 <20190415230830.jsmatvfyn3fjrtec@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190415230830.jsmatvfyn3fjrtec@breakpoint.cc>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 16-04-19, Florian Westphal wrote:
> Brett Mastbergen <bmastbergen@untangle.com> wrote:
> > This patch looks great.  That would greatly improve the usefulness of keying
> > off of the conntrack id.  If it gets accepted I can send a kernel patch and
> > an nft patch to support the ct id key.
> 
> That would be really nice to have.
> 

I've just sent the kernel, libnftnl, and nft patches that add support for the
ct id key to the list.  Take a look, see what you think.

> > > > For a more in depth description of how things work I suggest reading the doc 
> > > > in the first link I posted, but below are a few simple examples of what is 
> > > > possible using dict expressions:
> > > > 
> > > > nft add rule ip filter forward dict sessions ct id application long_string 
> > > > NETFLIX reject 
> > > > 
> > > > If I were to describe that rule in plain English it would be:
> > > > 
> > > > For traffic passing through the ip filter table forward hook, use the 
> > > > conntrack id as a key to lookup an entry in the sessions table.  For that
> > > > entry check if it has an application field set to a string value of NETFLIX,
> > > > if so, reject the traffic.
> > > > 
> > > > How did that field get set to NETFLIX?  That is up to some other entity.  In 
> > > 
> > > Why isn't it possible to use the existing nftables set infrastructure
> > > for this?
> > > 
> > > The nft sets store arbitrary octets/bytes as keys, so we could at least
> > > from kernel side store arbitrary identifiers (strings, integers etc).
> > > 
> > 
> > I wanted to use the existing set infrastructure, but I ran into two issues
> > wrt to what we were trying to acheive:
> > 
> > 1.  As far as I can tell the current sets are only set up to hold elements
> > of a particular data type, where as we are storing elements of many different
> > types in a particular dictionary.
> 
> Yes, a set is only one data type (They support combining types though).
> 
> > 2.  sets are associated with a particular table and therefore can only be
> > accessed by rules in that table.  If you want to associate some piece of
> > information with a particular connection and use it from rules in multiple
> > different tables, you'd have to populate it in a set in each of those tables.
> 
> Yes, but thats intentional, a table forms a namespace; so
> crossing it is not desireable.
> 
> The idea is that different entities each can manage their own tables
> without clashing with chain or set names of another table.
> 
> Still looking at dicts code, I am trying to understand where normal nft
> set infra can't be used (or is too cumbersome) to best understand how we
> can fit dicts ideas into nftables' architecture.
