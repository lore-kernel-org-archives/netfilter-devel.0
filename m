From: Patrick Schaaf <bof@bof.de>
Subject: Re: [PATCH] info file for ROUTE target
Date: Fri, 10 Dec 2004 10:14:45 +0100
Message-ID: <20041210091445.GC4121@oknodo.bof.de>
References: <1102603380.7528.98.camel@descartes.info.ucl.ac.be>
	<20041209195706.GA4121@oknodo.bof.de> <41B8EB72.50502@trash.net>
	<1102669404.11255.29.camel@descartes.info.ucl.ac.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netfilter-devel@lists.netfilter.org"
	<netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>, Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Cedric de Launois <delaunois@info.ucl.ac.be>
Content-Disposition: inline
In-Reply-To: <1102669404.11255.29.camel@descartes.info.ucl.ac.be>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

> Thanks to conntrack, we can avoid flooding ourself with duplicated
> packets.

NOTE: due to no IPv6 conntrack, the (completely untested :) IPv6 --tee
patch does _not_ contain the recursion detection I made for v4.

I'd love to do this in a different way, but don't know how.
What is needed, is simply an efficient function that, given
a (gateway) IP address, or even the already resolved route,
tells us whether it will reenter the local IP stack.

> My fear is that you could still have something like this :
> 
>           PC1                                    PC2
> 
>       orig packet     
>            |
>            v                  dup pkt 1
>    [ROUTE --tee --gw PC2] -------------------------.
>          | |   ^                                   |
>          | |   |                                   v
>          | |   '-----dup pkt 2 ---------- [ROUTE --tee --gw PC1]
>          | |                                      | |
>          v v                                      v v
>  Flood of duplicated packets            Flood of duplicated packets

This is easily possible. There are lots of other failure scenarios.

For example, when the chosen --gw resolves through our defaul route,
chances are good all duplicate packets will come back to us almost
immediately. We saw this in our testing, already. TTL should always
be properly decremented, so this is a bit self-limiting, but
nevertheless it's certainly a dangerous thing.

> So we cannot make sure that people don't shoot themself. But anyway,
> people using the ROUTE target are warned enough by pom...
> Maybe I'm too paranoid ?

If ROUTE were in the base kernel (which it isn't going to be, according
to the last workshop results I've seen), I would be against including
the --tee functionality, and would have made a separate target TEE for
our needs.

I'm certainly open to doing that, anyway, if this helps alleviate
some paranoia.

all the best
  Patrick
