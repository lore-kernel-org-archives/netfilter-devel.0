From: Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [tproxy] Re: Request: including tproxy patch to official
	iptables/kernel.
Date: Tue, 17 Oct 2006 17:01:47 +0200
Message-ID: <20061017150147.GD1598@xi.wantstofly.org>
References: <20061016114331.AF36.TSUNEO.YOSHIOKA@f-secure.com>
	<45331D32.5070209@trash.net> <200610171638.25425@nienna>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yoshioka Tsuneo <tsuneo.yoshioka@f-secure.com>,
	netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>, tproxy@lists.balabit.hu
To: KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

On Tue, Oct 17, 2006 at 04:38:24PM +0200, KOVACS Krisztian wrote:

>   Moreover, I think there's no general consensus between networking 
> maintainers whether or not the features tproxy provides are worth the 
> hassles. Transparent proxying features have been removed during the 2.3 
> development as there seemed little interest in those. Of course there are 
> a handful of companies interested in having the feature in mainline, but 
> let's face the facts: the majority of users do not care about tproxy. 

There's other features and drivers in Linux where a similar thing
applies.  If tproxy doesn't get into the way when it's not used or
turned off, why shouldn't it be merged?


cheers,
Lennert
