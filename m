From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER] early_drop() imrovement (v4)
Date: Tue, 03 Jul 2007 13:42:54 +0200
Message-ID: <468A363E.7070700@trash.net>
References: <4615FE1D.80206@sw.ru>	
	<20070406102433.d3a670a5.dada1@cosmosbay.com>	<4616203A.80203@sw.ru>	
	<4616626C.9020100@trash.net>	<4617845F.7080203@sw.ru>	
	<461789CF.8000106@cosmosbay.com>	<46187770.1070106@sw.ru>	
	<46417137.5080501@sw.ru>	<467FC8D2.5070102@trash.net>	
	<46811292.1010501@sw.ru>	<468223D0.90305@sw.ru>	
	<46822540.2010004@trash.net>	<4682523F.6000002@trash.net>	
	<4682582D.7080501@sw.ru>	<46825D63.3060500@trash.net>	
	<46825FE0.7060306@sw.ru>	<4682638F.40507@trash.net>	
	<46826566.2060304@sw.ru>	<46826607.4060201@trash.net>	
	<468267B5.5000308@trash.net> <46826C2C.4060600@trash.net>
	<1183406199.16922.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>, Vasily Averin <vvs@sw.ru>,
	netfilter-devel@lists.netfilter.org, devel@openvz.org,
	Eric Dumazet <dada1@cosmosbay.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1183406199.16922.10.camel@localhost.localdomain>
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

Rusty Russell wrote:
> On Wed, 2007-06-27 at 15:54 +0200, Patrick McHardy wrote:
> 
>>[NETFILTER]: nf_conntrack: early_drop improvement
>
> This looks good.  The randomness in the hash means we no longer need the
> "hit the same hash bucket" heuristic to avoid hashbombing.
> 
> I still wonder if we should batch up the drops a little while we're
> doing all this work?  Should reduce stress under serious flood load.


Good point, I didn't think of that. Its a bit tricky though, we can't
destroy them while holding nf_conntrack_lock, so we'd either have to
release and re-grab it for every conntrack we want to kill or write
lock it from the beginning, clean them from the lists immediately and
put them on a temporary destruction queue. Or split death_by_timeout
so it can deal with callers already holding nf_conntrack_lock ..

I'll see if I can come up with a halfway decent looking patch :)
