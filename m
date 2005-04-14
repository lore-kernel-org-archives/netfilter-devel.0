From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: About matching (also was: Multiple Targets)
Date: Thu, 14 Apr 2005 03:03:09 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0504140301270.16405@filer.marasystems.com>
References: <20050413084249.0309.LARK@linux.net.cn>
	<425C6D58.3090002@outerspace.dyndns.org>
	<20050413085911.030C.LARK@linux.net.cn>
	<20050413065248.GB16534@oknodo.bof.de>
	<Pine.LNX.4.58.0504130857010.10437@blackhole.kfki.hu>
	<20050413071427.GC16534@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20050413071427.GC16534@oknodo.bof.de>
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

On Wed, 13 Apr 2005, Patrick Schaaf wrote:

> BTW, I do find the general idea of '--previous' / '! --previous'
> sensible and appealing, because it wouldn't cost much to implement,
> and would give a tool to the ruleset writer to at least express
> _some_ commonality.

imho you have this with jumps to a sub-chain today.. The jump rule is the 
condition, and the sub-chain has the list of actions to execute when this 
condition is true (and maybe more detailed conditions).

Regards
Henrik
