From: Patrick McHardy <kaber@trash.net>
Subject: Re: Request: including tproxy patch to official iptables/kernel.
Date: Thu, 19 Oct 2006 16:58:23 +0200
Message-ID: <4537928F.1060900@trash.net>
References: <20061016114331.AF36.TSUNEO.YOSHIOKA@f-secure.com>
	<45331D32.5070209@trash.net> <200610171638.25425@nienna>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Yoshioka Tsuneo <tsuneo.yoshioka@f-secure.com>,
	netfilter-devel@lists.netfilter.org, tproxy@lists.balabit.hu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
In-Reply-To: <200610171638.25425@nienna>
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

KOVACS Krisztian wrote:
>   Yes, there was significant progress since then, we're testing the 
> patches at the moment. There still are a couple of problems with the new 
> approach, but it certainly looks promising. I'll post the patches on 
> netfilter-devel for review and comments as soon as things have settled 
> down a bit.

Great.

>   Instead of trying to get the 2.0 branch of tproxy merged into mainline 
> we're concentrating our efforts on getting the new code working. As the 
> maintainer of the current tproxy patchset, I do not consider it clean and 
> safe enough to have it merged upstream.

Yes, the old patches are a bit risky I think. But the new approach
(in case its still the same) looked like a nice way.

>   Moreover, I think there's no general consensus between networking 
> maintainers whether or not the features tproxy provides are worth the 
> hassles. Transparent proxying features have been removed during the 2.3 
> development as there seemed little interest in those. Of course there are 
> a handful of companies interested in having the feature in mainline, but 
> let's face the facts: the majority of users do not care about tproxy. 
> That's why I don't even try to get it merged.

I have no problem with that if it doesn't affect users not using it.
