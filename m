From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER] early_drop() imrovement (v4)
Date: Wed, 27 Jun 2007 15:23:00 +0200
Message-ID: <468264B4.80202@trash.net>
References: <4615FE1D.80206@sw.ru>	<20070406102433.d3a670a5.dada1@cosmosbay.com>	<4616203A.80203@sw.ru>	<4616626C.9020100@trash.net>	<4617845F.7080203@sw.ru>	<461789CF.8000106@cosmosbay.com>	<46187770.1070106@sw.ru>	<46417137.5080501@sw.ru>	<467FC8D2.5070102@trash.net>	<46811292.1010501@sw.ru>	<468223D0.90305@sw.ru>	<46822540.2010004@trash.net>
	<4682523F.6000002@trash.net>	<4682582D.7080501@sw.ru>
	<46825D63.3060500@trash.net>	<46825FE0.7060306@sw.ru>
	<4682638F.40507@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Vasily Averin <vvs@sw.ru>, netfilter-devel@lists.netfilter.org,
	rusty@rustcorp.com.au, Eric Dumazet <dada1@cosmosbay.com>,
	Jan Engelhardt <jengelh@computergmbh.de>, devel@openvz.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4682638F.40507@trash.net>
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

[Dropping a few CCs since I supect its beginning to be annoying :)]

Patrick McHardy wrote:
> Vasily Averin wrote:
> 
> Indeed, thanks. Fixed now. Also changed it to leave the loop
> if we found an entry within a chain (we want the last one of
> the chain, so we still walk it entirely) and replaced
> 
> hash = (hash + 1) % nf_conntrack_htable_size
> 
> by
> 
> hash = (hash + 1) & (nf_conntrack_htable_size - 1)
> 
> since one of my queued patches makes sure that its always
> a power of two.


Damn it .. it doesn't, it just makes sure it always uses pages
entirely. So I fixed that again.
