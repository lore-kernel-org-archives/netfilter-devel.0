Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69407C11F67
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Jul 2021 00:53:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49AD261410
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Jul 2021 00:53:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234564AbhGBAz5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Jul 2021 20:55:57 -0400
Received: from mail.netfilter.org ([217.70.188.207]:41918 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbhGBAz5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Jul 2021 20:55:57 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 56D5260705;
        Fri,  2 Jul 2021 02:53:18 +0200 (CEST)
Date:   Fri, 2 Jul 2021 02:53:22 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, kadlec@netfilter.org
Subject: Re: [PATCH nf-next 0/2] netfilter: conntrack: do not renew timeout
 while in tcp SYN_SENT state
Message-ID: <20210702005322.GA29635@salvia>
References: <20210624103642.29087-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210624103642.29087-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 24, 2021 at 12:36:40PM +0200, Florian Westphal wrote:
> Antonio Ojea reported a problem with a container environment where
> connection retries prevent expiry of a SYN_SENT conntrack entry.
> 
> This in turn prevents a NAT rule from becoming active.
> 
> Consider:
>   client -----> conntrack ---> Host
> 
> client sends a SYN, but $Host is unreachable/silent.
> 
> In the reported case, $host address doesn't exist at all --
> its a 'virtual' ip that is made accessible via dnat/redirect.
> 
> The routing table even passes the packet back via the same interface
> it arrived on.
> 
> In the mean time, a NAT rule has been added to the conntrack
> namespace, but it has no effect until the existing conntrack
> entry times out.
> 
> Unfortunately, in the above scenario, the client retries reconnects
> faster than the SYN default timeout (60 seconds), i.e. the entry
> never expires and the 'virtual' ip never becomes active.
> 
> First patch adds a test case:
>  3 namespaces, one sender, one receiver.
>  sender connects to non-existent/virtual ip.
>  Then a dnat rule gets added.
> 
>  The test case succeeds once conntrack tool shows that the nat rule
>  was evaluated.
> 
> Second patch prevents timeout refresh for entries stuck in
> SYN_SENT state.
> 
> Without second patch the test case doesn't pass even though syn
> timeout is set to 10 seconds.

Series applied, thanks.
