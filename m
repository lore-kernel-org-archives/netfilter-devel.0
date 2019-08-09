Return-Path: <SRS0=FL4W=WF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21C53C433FF
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Aug 2019 13:56:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E720321783
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Aug 2019 13:56:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=untangle.com header.i=@untangle.com header.b="BYZcOKoP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406732AbfHIN4g (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Aug 2019 09:56:36 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41355 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406680AbfHIN4g (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Aug 2019 09:56:36 -0400
Received: by mail-qt1-f194.google.com with SMTP id d17so16891044qtj.8
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Aug 2019 06:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=untangle.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JSunLfk+vXn1LJEH3c0+L9Lheukq2w5dgjUg0QrHjC4=;
        b=BYZcOKoPD0TAB7VUJLwLxSymr4vdwacF6VSbr5bipQke4yV4597/qjhbLanGh3M6wy
         e5qbM+0SOK9F1qgx4W/k8EJXAxCTNfobuhykWVyov1x2vmZZzV3KCByQ1xxtMI/ssfOu
         VasEq6aDLfkSPSOYX43L9DCFeM1dBgSJscZBQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JSunLfk+vXn1LJEH3c0+L9Lheukq2w5dgjUg0QrHjC4=;
        b=czLCfmth1OZmxr++Mi2QnhqQH5ad98pcl3YBqay3OCtRSEoKE6XcLmVrBGmn14ZBzF
         Kw4hKO5iO9gHVxJQle/iEplQYtZldH8xtKoEG6x1c+CSlKRntBKG5p+bZYp7ZK0PWG2/
         wbMhm8UhyuZzinrAkBoJddg4+GjsIoYjDgVtkZM7aEM6PNXM2n8GmY5VPcHAGT6Xpw7O
         /TcTxu0nsaPGF1nU2M7nt1hZqtqe1ek0dX16OnGNg2ZdQ049UyXzIK0laSWxi2RNhWBJ
         2nU3unKDY9uVrzOgMgYoI+flmpg4kpxYlO5dDHw6TVI496bRV6I1QxV9lZLC6wGtmx+a
         1tuA==
X-Gm-Message-State: APjAAAWV9cjGBe5cqS90hE8R+zGS5cKxU06KlxLSeV4toF/QtSxn+QVd
        tS6GCuMdI6VkstC/kKPZutfSbUD8mrkKaA==
X-Google-Smtp-Source: APXvYqzdb+hAVIyldQivs1Gwhsh+dF+vtifkdgVxBIEL9i0qU2FsdEHf0cJSCRAUK+qogMy2G8rBTg==
X-Received: by 2002:aed:3ee9:: with SMTP id o38mr17866189qtf.193.1565358995348;
        Fri, 09 Aug 2019 06:56:35 -0700 (PDT)
Received: from pinebook (cpe-74-137-94-90.kya.res.rr.com. [74.137.94.90])
        by smtp.gmail.com with ESMTPSA id m10sm40715831qka.43.2019.08.09.06.56.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 09 Aug 2019 06:56:34 -0700 (PDT)
Date:   Fri, 9 Aug 2019 09:56:21 -0400
From:   Brett Mastbergen <bmastbergen@untangle.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2] src: Support maps as left side expressions
Message-ID: <20190809135621.GA8680@pinebook>
References: <20190730122818.2032-1-bmastbergen@untangle.com>
 <20190808111634.quczq7ajnaobscab@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808111634.quczq7ajnaobscab@salvia>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 08-08-19, Pablo Neira Ayuso wrote:
> Hi brett,
> 
> On Tue, Jul 30, 2019 at 08:28:18AM -0400, Brett Mastbergen wrote:
> > This change allows map expressions on the left side of comparisons:
> > 
> > nft add rule foo bar ip saddr map @map_a == 22 counter
> > 
> > It also allows map expressions as the left side expression of other
> > map expressions:
> > 
> > nft add rule foo bar ip saddr map @map_a map @map_b == 22 counter
> 
> This is an interesting usage of the maps from the left-hand side of an
> expression.
> 
> I have a fundamental question, that is, how this will be used from
> rulesets? My impression is that this will result in many rules, e.g.
> 
>         ip saddr map @map_a map @map_b == 22 accept
>         ip saddr map @map_a map @map_b == 21 drop
>         ip saddr map @map_a map @map_b == 20 jump chain_0
>         ...
> 
> This means that we need one rule per map lookup.
> 
> I think this feature will be more useful if this can be combined with
> verdict maps, so the right hand side could be used to look up for an
> action.
>

Thats a good point.  I bet a map expression could feed into a verdict
map without too much trouble.  I'll take a look.

> Thanks.
