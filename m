From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] goto port to ipv6
Date: Mon, 18 Apr 2005 16:41:24 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0504181618390.14603@filer.marasystems.com>
References: <425CD235.7060909@outerspace.dyndns.org>
	<4262E109.2010804@trash.net>
	<Pine.LNX.4.61.0504180304580.4321@filer.marasystems.com>
	<426310E5.2030207@trash.net>
	<42635378.6050002@outerspace.dyndns.org>
	<20050418072715.GE10801@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20050418072715.GE10801@oknodo.bof.de>
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

On Mon, 18 Apr 2005, Patrick Schaaf wrote:

>> What's your opinion of my fix included in this IPv6 port (which I fixed
>> for IPv4 separately and Harald accepted last friday) to indicate "goto"
>> targets in iptables -L listings with a [goto] in the match extension part?
>>
>> One alternative could be adding some special character(s) around the
>> jump target itself, like *SUBCHAIN or SUBCHAIN* or ->SUBCHAIN or
>> something.. Also I have no idea whether one should consider the output
>> possibly being used by scripts etc, so I'd appreciate if people could
>> give their opinion on this (before it goes upstream :) ...
>
> Hmm. Isn't iptables-save considered the parse-this-in-scripts format?

He is talking about iptables -L, not iptables-save.

iptable-save already prints it proper as a -g.

> Now, what magic character to use...
>
> imap_in*    tcp  --  anywhere             anywhere            tcp dpt:imap
> ssh_in)    tcp  --  anywhere             anywhere            tcp dpt:ssh
> smtp_in.   tcp  --  anywhere             anywhere            tcp dpt:smtp
> pop3_in!   tcp  --  anywhere             anywhere            tcp dpt:pop3

Unfortunately all of these is swallowed as chain names.. but hopefully 
this should not be a problem. Nobody in his sane mind uses such chain 
names, righth?

I think I prefer the *. Or maybe #. Much better than having a goto flag at 
the end of the line.

! is not a good choice as this looks like a negation of some form..

. may be confusing as I suspect there is many already using . in chain 
names..

) feels like the chain got isolated somehow, which isn't really what it is 
aout. Goto is about terminating this chain.

The > symbol is better than ) I think if this type of "isolation" symbol 
is desired. > indicates to me some form of direction which is closer to 
what the goto is about.

Regards
Henrik
