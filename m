Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6F93C43460
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 May 2021 12:18:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89C1461222
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 May 2021 12:18:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbhEEMTu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 May 2021 08:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbhEEMSa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 May 2021 08:18:30 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0472C061350
        for <netfilter-devel@vger.kernel.org>; Wed,  5 May 2021 05:17:00 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 81D42588A36D9; Wed,  5 May 2021 14:16:57 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 765B06167A36C;
        Wed,  5 May 2021 14:16:57 +0200 (CEST)
Date:   Wed, 5 May 2021 14:16:57 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Florian Westphal <fw@strlen.de>
cc:     Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>,
        pablo@netfilter.org, kadlec@netfilter.org, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_conntrack: Add conntrack helper for
 ESP/IPsec
In-Reply-To: <20210414154021.GE14932@breakpoint.cc>
Message-ID: <pq161666-47s-p680-552o-58poo05onr86@vanv.qr>
References: <20210414035327.31018-1-Cole.Dishington@alliedtelesis.co.nz> <20210414154021.GE14932@breakpoint.cc>
User-Agent: Alpine 2.24 (LSU 510 2020-10-10)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Wednesday 2021-04-14 17:40, Florian Westphal wrote:
>
>Preface: AFAIU this tracker aims to 'soft-splice' two independent ESP
>connections, i.e.: saddr:spi1 -> daddr, daddr:spi2 <- saddr. [...] This can't
>be done as-is, because we don't know spi2 at the time the first ESP packet is
>received. The solution implemented here is introduction of a 'virtual esp id',
>computed when first ESP packet is received,[...]

I can't imagine this working reliably.

1. The IKE daemons could do an exchange whereby just one ESP flow is set up (from
daddr to saddr). It's unusual to do a one-way tunnel, but it's a possibility.
Then you only ever have ESP packets going from daddr to saddr.

2. Even if the IKE daemons set up what we would consider a normal tunnel,
i.e. one ESP flow per direction, there is no obligation that saddr has to
send anything. daddr could be contacting saddr solely with a protocol
that is both connectionless at L4 and which does not demand any L7 responses
either. Like ... syslog-over-udp?

3. Even under best conditions, what if two clients on the saddr network
simultaneously initiate a connection to daddr, how will you decide
which of the daddr ESP SPIs belongs to which saddr?
