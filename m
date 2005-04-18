From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] goto port to ipv6
Date: Mon, 18 Apr 2005 16:17:38 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0504181602570.14603@filer.marasystems.com>
References: <425CD235.7060909@outerspace.dyndns.org>
	<4262E109.2010804@trash.net>
	<Pine.LNX.4.61.0504180304580.4321@filer.marasystems.com>
	<426310E5.2030207@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <426310E5.2030207@trash.net>
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

On Mon, 18 Apr 2005, Patrick McHardy wrote:

> But it's a useful feature. If this was the only reason, I think we
> should submit it for both IPv4 and IPv6.

I am not against this.

I wrote the patch because someone asked if it was possible, and if people 
find good uses of it then I am very happy B)

>From what I remember the patch is very non-intrusive and shouldn't cost 
more than tree more instruction bytes in the kernel.. Only note of caution 
is that I don't remember if old kernels rejects rulesets with goto or 
silently accepts the goto as a jump. I think it is silently accepted 
reading the goto as a jump, but hopefully the ruleset is rejected when the 
kernel does not support goto (depends on how good the iptables kernel 
verifies the content of the flags field)

Regards
Henrik
