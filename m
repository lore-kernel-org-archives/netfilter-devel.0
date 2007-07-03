From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [NETFILTER] early_drop() imrovement (v4)
Date: Tue, 3 Jul 2007 08:39:53 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0707030830580.16251@wlug.westbo.se>
References: <4615FE1D.80206@sw.ru>
	<20070406102433.d3a670a5.dada1@cosmosbay.com>
	<4616203A.80203@sw.ru> <4616626C.9020100@trash.net>
	<4617845F.7080203@sw.ru>
	<461789CF.8000106@cosmosbay.com> <46187770.1070106@sw.ru>
	<46417137.5080501@sw.ru>
	<467FC8D2.5070102@trash.net> <46811292.1010501@sw.ru>
	<468223D0.90305@sw.ru>
	<46822540.2010004@trash.net> <4682523F.6000002@trash.net>
	<4682582D.7080501@sw.ru>
	<46825D63.3060500@trash.net> <46825FE0.7060306@sw.ru>
	<4682638F.40507@trash.net>
	<46826566.2060304@sw.ru> <46826607.4060201@trash.net>
	<468267B5.5000308@trash.net> <46826C2C.4060600@trash.net>
	<1183406199.16922.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Vasily Averin <vvs@sw.ru>, netfilter-devel@lists.netfilter.org,
	Eric Dumazet <dada1@cosmosbay.com>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	Patrick McHardy <kaber@trash.net>, devel@openvz.org
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

On Tue, 3 Jul 2007, Rusty Russell wrote:

> This looks good.  The randomness in the hash means we no longer need the
> "hit the same hash bucket" heuristic to avoid hashbombing.
>
> I still wonder if we should batch up the drops a little while we're
> doing all this work?  Should reduce stress under serious flood load.

Yes we should really do that, going searching for something to evict 
for each new connection attempt is really painful and in this 
overload situation we need all the cpu we can get.

/Martin
