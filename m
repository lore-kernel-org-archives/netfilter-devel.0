From: Duncan Palmer <dunk_palmer@yahoo.com>
Subject: Re: [PATCH] Get icmp ratelimit from sysctl in ipt_REJECT.c
Date: Thu, 10 Feb 2005 23:52:22 -0800 (PST)
Message-ID: <20050211075222.63979.qmail@web60608.mail.yahoo.com>
References: <42094C8D.1030009@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42094C8D.1030009@trash.net>
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


--- Patrick McHardy <kaber@trash.net> wrote:

> I was never convinced of using xrlim_allow in
> ipt_REJECT. We
> already have the limit match, which allows to set
> limits in
> the ruleset. 

Is there anywhere that sends icmp pkts apart from
icmp.c and ipt_REJECT.c? (a quick look suggests not).
If not, then one problem I can see with removing
xrlim_allow() from ipt_REJECT is that its behaviour
will become inconsistent with that of icmp.c, in that
it doesn't use sysctl for setting rlimit (not that it
ever has...)

> that shouldn't be limited. So we can either remove
> it entirely
> or use icmpv4_xrlim_allow. If there are no
> objections I would prefer to remove it.

After reading the relevant bits of the RFC and a bit
more code, I agree that xrlim_allow() is indeed
buggered...

I'm far from being an expert on linux's networking
internals, but it seems to me that many aspects of the
operation of network stacks are configurable using
sysctl variables. Not calling icmpv4_xrlim_allow()
will make the icmp ratelimit parameter a bit of an odd
one out as far as ipv4 is concerned, as I think there
are other ipv4 sysctl parameters who's functionality
could similarly be replaced by iptables...

I'll be happy do do up a patch on whatever is decided
upon anyway...

Dunk



		
__________________________________ 
Do you Yahoo!? 
The all-new My Yahoo! - Get yours free! 
http://my.yahoo.com 
 
