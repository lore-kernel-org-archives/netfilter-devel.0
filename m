Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EABCC49361
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Jun 2021 13:06:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 526696148E
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Jun 2021 13:06:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhFONIi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Jun 2021 09:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbhFONIi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Jun 2021 09:08:38 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E585C0A88FE
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Jun 2021 06:06:33 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lt8lz-0008Ki-GC; Tue, 15 Jun 2021 15:06:31 +0200
Date:   Tue, 15 Jun 2021 15:06:31 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jake Owen <jake.owen@superloop.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: nfqueue hashing on TCP/UDP port
Message-ID: <20210615130631.GC1425@breakpoint.cc>
References: <CAD353mmiYns6u5tb3XQz3Rfh_23EMES-4FX1d4pJrQwBd3NvGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD353mmiYns6u5tb3XQz3Rfh_23EMES-4FX1d4pJrQwBd3NvGQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jake Owen <jake.owen@superloop.com> wrote:
> Hello!
> 
> tl;dr Is there a technical reason why nfqueue balance as implemented
> does not use TCP/UDP ports as well as source/destination IP addresses?

To keep host-to-host comunication on the same queue, for ftp, sip and
other highlevel protocols where a logical connection consists of
multiple tcp/udp flows.

> We've been having trouble with the queue hashing algorithm used by
> iptable's `--queue-balance` for traffic generated on-box (e.g. by a
> squid proxy) where a large percentage of traffic would be TCP, source
> IP of the proxy, and one google/microsoft/apple destination IP. This
> is made worse if the random seed causes two or more of these high
> traffic services to hash to the same queue. We are working on
> preserving the original client IP as the source IP to provide
> sufficient randomness to balance accurately, but in the meantime have
> wondered if balancing by port was not implemented because it was
> deemed unnecessary, or because of some technical reason which escapes
> me.

The latter.  I will add arbitrary hash keying to nft, its currently
only missing from the frontend.

Will put you in CC when its done.

> I'm willing to propose a solution for
> the latest 5.x kernel if other people think that this is a valid
> solution/use case.

With nft this will soon be possible:

queue num jhash ip daddr . tcp sport . tcp dport mod 16

... which will queue to 0-15.

I don't think we need code changes to the xtables backend.
