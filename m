From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 0/4] restrict meta nfproto to inet family
Date: Sun, 18 Jun 2017 11:35:53 +0200
Message-ID: <20170618093553.GA19741@salvia>
References: <20170616203411.16408-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46140 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751070AbdFRJgS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Jun 2017 05:36:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B9944E1229
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Jun 2017 11:36:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A990C202A2
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Jun 2017 11:36:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AC6B28F48
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Jun 2017 11:36:00 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170616203411.16408-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 16, 2017 at 10:34:07PM +0200, Florian Westphal wrote:
> Pablo reports following test case failure:
> 
> any/ct.t: ERROR: line 94: src/nft add rule --debug=netlink ip6
> test-ip6 output meta nfproto ipv4 ct original saddr 1.2.3.4: This rule should not have failed.
> 
> We can't find upper layer protocol in this case, but even if we'd
> "fix" this it is still non-sensical, as
> 
>   meta nfproto ipv4
> 
> will never match except in the inet family and the
> ip family, but in the latter case it will always match so it
> has no effect).
> 
> So, first step is to move this to an inet specific test to
> get rid of the test case failure.
> 
> The followup changes then get rid of meta nfproto tests or
> move them to inet-family-only tests.
> 
> The last patch makes nft reject 'meta nfproto' in all families
> except inet, where this expression is needed in case one wants to
> explicitly restrict a rule to only ipv4 or ipv6.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks Florian.

Can we probably get rid of meta nfproto at some point? IIRC it's only
needed because skb->protocol is not set in the output hook, but it is
indeed available in postrouting. Can you find any reason for this
behaviour?
