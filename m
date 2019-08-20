Return-Path: <SRS0=ly5L=WQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D7ADC3A589
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Aug 2019 19:22:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B64722DA7
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Aug 2019 19:22:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="NB1jHGW3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730273AbfHTTWW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Aug 2019 15:22:22 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:38559 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728185AbfHTTWW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Aug 2019 15:22:22 -0400
Received: by mail-qk1-f195.google.com with SMTP id u190so5497815qkh.5
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2019 12:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=UxntnfUhoyfJtCVV8rivLfmU6f8XilX6XjYLYMrrx5k=;
        b=NB1jHGW3AC8XEU0X0M4MEWLljIPAucw1LyO0zPMU/BaLmYL8rqH32Ygv6DtluhA2Wc
         +kJpeQV148DYsYUf1NeTU1KHEbBoMgIkpjmeJl9rDmKzInPNqNIMN0/x0HwIcRE4Z5lk
         FsSrYhY3kBXzJpmPRG7wmwCe/Q/RHY3MwrtzbU9+c2o1sGgY3YVGCGQcjpQlByhlD8L9
         q6QD8447pCe5MEEZMLXDjPUCO3GWH7SoUNu67LvJk+HE3zqECpLWls15XZIK0Cov3rIP
         9Zo6OZnbV3TLcFR2BkXs7y9eQye/fqJgax7TH583KgFcRpV++eoTkGAfTsukoBwvQIdB
         oDxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=UxntnfUhoyfJtCVV8rivLfmU6f8XilX6XjYLYMrrx5k=;
        b=Jo/x1J15u3k5wgdSxAD6CIcqUQBWKjVGFqCOjx5R+oltnMZyEdZ2AL6HlKV0Ncf8UJ
         WUsbDfeEKA4O4/XTkBP4RBh2vKIA+SCDysMCfTHncGmt32RStSGP0N+XzGmMvcyPjnE+
         ZIgve/TUID6lfR6G6/T6bPkWeECteliINcvIJ6TCABup6hXID2tHyJNjiCgkZIxJjbiI
         ICXaAFaTurDC6m6NPL9efRwu8d5J66uDB1CdpBFn0FX7peLyxsjrNa/obxkymPqNpTZK
         NvLQSZIdGyzoV5hGvyaaUvOej55rs26zxSdTjCeHz6/vhWk+zTubsoya/RVj7mLQWMgk
         b42w==
X-Gm-Message-State: APjAAAXQPPomXbScLlLkpsUh/pJcZ6Ty4eYHlpI200i0T0ZfZAtyNTBS
        tqyDfmiZiEMz1YlCzWnStDxU0w==
X-Google-Smtp-Source: APXvYqxAdhriNfgclkhutoA76ENPDWPTnCr4/+6N7ogosLbY09gYfGp0x57+ZDCDTfwFOkvHBzGkgg==
X-Received: by 2002:a05:620a:112b:: with SMTP id p11mr28580891qkk.146.1566328941748;
        Tue, 20 Aug 2019 12:22:21 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o43sm10499059qto.63.2019.08.20.12.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 12:22:21 -0700 (PDT)
Date:   Tue, 20 Aug 2019 12:22:14 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jiri@resnulli.us, vladbu@mellanox.com
Subject: Re: [PATCH net-next 0/2] netfilter: payload mangling offload
 support
Message-ID: <20190820122214.702476ff@cakuba.netronome.com>
In-Reply-To: <20190820104807.13843-1-pablo@netfilter.org>
References: <20190820104807.13843-1-pablo@netfilter.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 20 Aug 2019 12:48:05 +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> This patchset adds payload mangling offload support for Netfilter:
> 
> 1) Adapt existing drivers to allow for mangling up to four 32-bit words
>    with one single flow_rule action. Hence, once single action can be
>    used to mangle an IPv6 address.
> 
> 2) Add support for netfilter packet mangling.

Why pick 128b as a unit, because that's nftables' word size? :/

Reality is unless core coalesces _all_ consecutive rewrites drivers 
will have to do their own coalescing, anyway.

We suffered through enough haphazard "updates", I don't like this either.
