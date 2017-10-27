From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 1/8] tests: adjust output to silence warnings
Date: Fri, 27 Oct 2017 12:29:06 +0200
Message-ID: <20171027102906.GA14147@salvia>
References: <20171026230611.14269-1-fw@strlen.de>
 <20171026230611.14269-2-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40704 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752151AbdJ0K3M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Oct 2017 06:29:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 175D426E26
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Oct 2017 12:29:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 06990BAC34
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Oct 2017 12:29:10 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171026230611.14269-2-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Fri, Oct 27, 2017 at 01:06:04AM +0200, Florian Westphal wrote:
> silence following (correct but harmless) warnings:
> bridge/icmpX.t: WARNING: line: 6: 'src/nft add rule --debug=netlink bridge test-bridge input icmp type echo-request': 'icmp type echo-request' mismatches 'ether type ip icmp type echo-request'
> bridge/icmpX.t: WARNING: line: 8: 'src/nft add rule --debug=netlink bridge test-bridge input icmpv6 type echo-request': 'icmpv6 type echo-request' mismatches 'ether type ip6 icmpv6 type echo-request'
> inet/icmpX.t: WARNING: line: 6: 'src/nft add rule --debug=netlink inet test-inet input icmp type echo-request': 'icmp type echo-request' mismatches 'meta nfproto ipv4 icmp type echo-request'
> inet/icmpX.t: WARNING: line: 8: 'src/nft add rule --debug=netlink inet test-inet input icmpv6 type echo-request': 'icmpv6 type echo-request' mismatches 'meta nfproto ipv6 icmpv6 type echo-request'

Hm, I'm not hitting this here, probably there's a bug in test
infrastructure.

> in all of these cases, we *could* remove the dependency, it can
> be correctly re-built using icmp/icmpv6.
> 
> However, at this time, nft dependency removal does not have the needed
> information to do this correctly.  In order to remove the ll dependency
> (ether type, meta nfproto) we would need to know if the layer 4 protocol
> is icmp (implies ipv4) or icmpv6 (implies ipv6).
> 
> Access to the next expression (meta l4proto) is NOT enough, for example:
> ether type ip meta l4proto tcp
> 
> does not imply ip, we would need access to the rhs (the layer 4
> protocol number) to know if the layer 2 check is (was) implied by another
> statement later on.
> 
> To do that we would need two passes over a rule, or we would need to
> track dependencies per-base.
> 
> So for now just accept that we don't handle it.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  tests/py/bridge/icmpX.t | 4 ++--
>  tests/py/inet/icmpX.t   | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tests/py/bridge/icmpX.t b/tests/py/bridge/icmpX.t
> index 4d7b9b0637aa..58e366c00712 100644
> --- a/tests/py/bridge/icmpX.t
> +++ b/tests/py/bridge/icmpX.t
> @@ -3,6 +3,6 @@
>  *bridge;test-bridge;input
>  
>  ip protocol icmp icmp type echo-request;ok;icmp type echo-request
> -icmp type echo-request;ok
> +icmp type echo-request;ok;ether type ip icmp type echo-request
>  ip6 nexthdr icmpv6 icmpv6 type echo-request;ok;ip6 nexthdr 58 icmpv6 type echo-request
> -icmpv6 type echo-request;ok
> +icmpv6 type echo-request;ok;ether type ip6 icmpv6 type echo-request
> diff --git a/tests/py/inet/icmpX.t b/tests/py/inet/icmpX.t
> index 43ac0909195f..91f7b9e1c472 100644
> --- a/tests/py/inet/icmpX.t
> +++ b/tests/py/inet/icmpX.t
> @@ -3,8 +3,8 @@
>  *inet;test-inet;input
>  
>  ip protocol icmp icmp type echo-request;ok;icmp type echo-request
> -icmp type echo-request;ok
> +icmp type echo-request;ok;meta nfproto ipv4 icmp type echo-request

I read a couple of times your description above and I must be
overlooking anything.

To me, "icmp type echo-request" in bridge/inet/netdev should result in
two implicit dependencies, so this ends up looking like this:

1) check for IPv4, then...
2) check for ICMP in iph->protocol, then...
3) check for ICMP type.

This would be the default reasonable behaviour.

Then, we have to deal with specific corner cases, where we should
cancel dependencies.

Am I missing anything?
