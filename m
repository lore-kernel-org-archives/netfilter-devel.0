From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [RFC][PATCH 0/7]: ct_extend
Date: Thu, 31 May 2007 18:02:00 +0900 (JST)
Message-ID: <200705310902.l4V920k8010786@toshiba.co.jp>
References: <200705071200.l47C0UoM006287@toshiba.co.jp>
	<e6af3bc80705301643w37922773ge6beab27d229718b@mail.gmail.com>
	<465E5159.4050604@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: mmohsenz@gmail.com, rusty@rustcorp.com.au,
	netfilter-devel@lists.netfilter.org,
	yasuyuki.kozakai@toshiba.co.jp, kadlec@blackhole.kfki.hu
To: kaber@trash.net, pablo@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <465E5159.4050604@trash.net>
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


From: Patrick McHardy <kaber@trash.net>
Date: Thu, 31 May 2007 06:38:49 +0200

> Mohammad Mohsenzadeh wrote:
> > Thanks for the patches, applied and works just fine. I was just
> > wondering if you would ever consider including these in the main
> > release of netfilter??
> 
> 
> Thanks for testing. I'm also hoping we can get this ready ASAP
> to get rid of the overhead of searching the expectations/helpers
> twice. I'm even considering switching to worst-case allocations
> for the time being since it costs us quite a bit of performance.

I've revisited the issue of competition between NAT referring
extension area for NAT and nfctnetlink trying to assign helper (which might
result in reallocating extension area for NAT).

And I've found that the current nfctnetlink has similar but different
problem. It is possible to change helper infomations while helper referring
them.

After all, if we don't want to introduce rwlock for such competition,
we'd better to limit nfctnetlink so that it doesn't assign, change, or
remove helper of confirmed conntrack.

If people agree to remove ctnetlink_change_helper(), I'll submit the latest
pactchset of ct_extend.

-- Yasuyuki Kozakai
