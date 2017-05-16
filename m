From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 04/10] tests: fix up meta l4proto change for ip6
 family
Date: Tue, 16 May 2017 12:22:25 +0200
Message-ID: <20170516102225.GA19858@salvia>
References: <20170509155122.26356-1-fw@strlen.de>
 <20170509155122.26356-5-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:33634 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751219AbdEPKWa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 May 2017 06:22:30 -0400
Content-Disposition: inline
In-Reply-To: <20170509155122.26356-5-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 09, 2017 at 05:51:16PM +0200, Florian Westphal wrote:
> After previous commit nft generates meta l4proto for ipv6 dependencies
> instead of checking the (first) nexthdr value.
> 
> This fixes up all tests cases accordingly except one which fails with
> 
> ip6/reject.t: ... 12: 'ip6 nexthdr 6 reject with tcp reset' mismatches 'meta l4proto 6 reject with tcp reset'
> This will be fixed by removing the implicit dependency in a followup patch.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  tests/py/bridge/icmpX.t.payload       |   4 +-
>  tests/py/inet/ah.t.payload.ip6        |  60 +++++++-------
>  tests/py/inet/comp.t.payload.ip6      |  34 ++++----
>  tests/py/inet/dccp.t.payload.ip6      |  36 ++++----
>  tests/py/inet/esp.t.payload.ip6       |  30 +++----
>  tests/py/inet/ether.t.payload.ip6     |   6 +-
>  tests/py/inet/icmpX.t.payload         |   4 +-
>  tests/py/inet/sctp.t.payload.ip6      |  64 +++++++-------
>  tests/py/inet/tcp.t.payload.ip6       | 152 +++++++++++++++++-----------------
>  tests/py/inet/udp.t.payload.ip6       |  72 ++++++++--------
>  tests/py/inet/udplite.t.payload.ip6   |  52 ++++++------
>  tests/py/ip6/dnat.t.payload.ip6       |   6 +-
>  tests/py/ip6/ether.t.payload          |   6 +-
>  tests/py/ip6/icmpv6.t.payload.ip6     | 132 ++++++++++++++---------------
>  tests/py/ip6/masquerade.t.payload.ip6 |  28 +++----
>  tests/py/ip6/redirect.t.payload.ip6   |  38 ++++-----
>  tests/py/ip6/reject.t.payload.ip6     |   2 +-
>  tests/py/ip6/snat.t.payload.ip6       |   4 +-
>  tests/py/ip6/tcpopt.t.payload         |  52 ++++++------
>  19 files changed, 389 insertions(+), 393 deletions(-)
> 
> diff --git a/tests/py/bridge/icmpX.t.payload b/tests/py/bridge/icmpX.t.payload
> index 19efdd85c43b..b351f7b008b7 100644
> --- a/tests/py/bridge/icmpX.t.payload
> +++ b/tests/py/bridge/icmpX.t.payload
> @@ -27,9 +27,7 @@ bridge test-bridge input
>  
>  # icmpv6 type echo-request
>  bridge test-bridge input
> -  [ payload load 2b @ link header + 12 => reg 1 ]
> -  [ cmp eq reg 1 0x0000dd86 ]
> -  [ payload load 1b @ network header + 6 => reg 1 ]
> +  [ meta load l4proto => reg 1 ]
>    [ cmp eq reg 1 0x0000003a ]
>    [ payload load 1b @ transport header + 0 => reg 1 ]
>    [ cmp eq reg 1 0x00000080 ]

I think this is not correct.

Before this patch, we restricted this to match on IPv6 traffic.

Now, we can match an IPv4 packet carrying an ICMPv6 protocol, this is
obviously handcrafted (incorrect) packet, but this rule would match.

So I think the implicit check for IPv6 via ethertype should still
remain there, right?

What patch are these test updates related to? Is it 1/10?
