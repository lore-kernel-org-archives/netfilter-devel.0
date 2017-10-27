From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 0/8] rework dependency removal
Date: Fri, 27 Oct 2017 12:39:16 +0200
Message-ID: <20171027103916.GA21822@salvia>
References: <20171026230611.14269-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48772 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751158AbdJ0KjX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Oct 2017 06:39:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 716DA24926
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Oct 2017 12:39:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 57F77DA382
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Oct 2017 12:39:22 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171026230611.14269-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 27, 2017 at 01:06:03AM +0200, Florian Westphal wrote:
> This series resolves a few shortcomings with the current dependency
> removal.
> 
> Problem is that the current approach sometimes can remove dependencies
> that are required, i.e. where the removal does change the rule.
> 
> Examples:
> inet t .. meta nfproto ipv6 tcp dport 22 or
> inet t .. ip protocol tcp tcp dport 22
> are reduced to 'tcp dport 22'.

OK, this is wrong, indeed.

> ip6 nexthdr icmpv6 icmpv6 type echo-request
> becomes 'ipv6 type echo-request' (which is not exactly the same,
> the implicit dependency nft adds is 'meta l4proto', which skips
> most extension headers).

This dependency removal is wrong too indeed and I agree it needs to be
fixed.

What I don't still is why patch 1/8 is expanding icmp type
echo-request to show explicit "ether type ip icmp type echo-request"
when listing the ruleset.

I mean:

-icmp type echo-request;ok
+icmp type echo-request;ok;ether type ip icmp type echo-request
