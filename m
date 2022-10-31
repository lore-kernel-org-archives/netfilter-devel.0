Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 431E6FA3740
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Oct 2022 08:39:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiJaIjE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 31 Oct 2022 04:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiJaIjE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Oct 2022 04:39:04 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 458902BB
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Oct 2022 01:39:01 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1opQJu-0004yF-CR; Mon, 31 Oct 2022 09:38:58 +0100
Date:   Mon, 31 Oct 2022 09:38:58 +0100
From:   Florian Westphal <fw@strlen.de>
To:     sriram.yagnaraman@est.tech
Cc:     netfilter-devel@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2 1/2] netfilter: conntrack: introduce no_random_port
 proc entry
Message-ID: <20221031083858.GB5040@breakpoint.cc>
References: <20221030122541.31354-1-sriram.yagnaraman@est.tech>
 <20221030122541.31354-2-sriram.yagnaraman@est.tech>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221030122541.31354-2-sriram.yagnaraman@est.tech>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

sriram.yagnaraman@est.tech <sriram.yagnaraman@est.tech> wrote:
> From: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
> 
> This patch introduces a new proc entry to disable source port
> randomization for SCTP connections.

Hmm.  Can you elaborate?  The sport is never randomized, unless either
1. User explicitly requested it via "random" flag passed to snat rule, or
2. the is an existing connection, using the *same* sport:saddr -> daddr:dport
   quadruple as the new request.

In 2), this new toggle prevents communication.  So I wonder why ...

> As specified in RFC9260 all transport addresses used by an SCTP endpoint
> MUST use the same port number but can use multiple IP addresses. That
> means that all paths taken within an SCTP association should have the
> same port even if they pass through different NAT/middleboxes in the
> network.

... the rfc mandates this, especially given the fact that endpoints have
0 control on middlebox behaviour.

This flag will completely prevent communication in case another
middlebox does sport randomization, so I wonder why its needed -- I see
no advantages but I see a downside.

> Disabling source port randomization provides a deterministic source port
> for the remote SCTP endpoint for all paths used in the SCTP association.
> On NAT/middlebox restarts we will always end up with the same port after
> the restart, and the SCTP endpoints involved in the SCTP association can
> remain transparent to restarts.

Can you elaborate? If we're the middlebox and we restarted, we have no
record of the "old" incarnation so there is no sport reallocation.

> Of course, there is a downside as this makes it impossible to have
> multiple SCTP endpoints behind NAT that use the same source port.

Hmm?  Not following.

1.2.3.4:12345 -> 5.6.7.8:42
1.2.3.4:12345 -> 5.6.7.8:43

... should work fine. Same for
1.2.3.4:12345 -> 5.6.7.8:42
1.2.3.4:12345 -> 5.6.7.9:42

> But, this is a lesser of a problem than losing an existing association
> altogether.

Can you elaborate?  How is an existing assocation lost?
For example, what sequence of events is needed to result in loss of
an existing association?
