From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] goto port to ipv6
Date: Sun, 24 Apr 2005 18:41:35 +0200
Message-ID: <426BCC3F.8040807@trash.net>
References: <425CD235.7060909@outerspace.dyndns.org>
	<4262E109.2010804@trash.net>
	<Pine.LNX.4.61.0504180304580.4321@filer.marasystems.com>
	<426310E5.2030207@trash.net>
	<Pine.LNX.4.61.0504181602570.14603@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0504181602570.14603@filer.marasystems.com>
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

Henrik Nordstrom wrote:
> From what I remember the patch is very non-intrusive and shouldn't cost 
> 
> more than tree more instruction bytes in the kernel.. Only note of 
> caution is that I don't remember if old kernels rejects rulesets with 
> goto or silently accepts the goto as a jump. I think it is silently 
> accepted reading the goto as a jump, but hopefully the ruleset is 
> rejected when the kernel does not support goto (depends on how good the 
> iptables kernel verifies the content of the flags field)

It verifies that all unknown bits are set to 0, so old kernels should
reject rulesets with goto.

Regards
Patrick
