From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Get icmp ratelimit from sysctl in ipt_REJECT.c
Date: Fri, 11 Feb 2005 20:05:06 +0100
Message-ID: <420D01E2.5000008@trash.net>
References: <20050211075222.63979.qmail@web60608.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Duncan Palmer <dunk_palmer@yahoo.com>
In-Reply-To: <20050211075222.63979.qmail@web60608.mail.yahoo.com>
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

Duncan Palmer wrote:

>Is there anywhere that sends icmp pkts apart from
>icmp.c and ipt_REJECT.c? (a quick look suggests not).
>If not, then one problem I can see with removing
>xrlim_allow() from ipt_REJECT is that its behaviour
>will become inconsistent with that of icmp.c, in that
>it doesn't use sysctl for setting rlimit (not that it
>ever has...)
>
It doesn't has to be consistent with icmp.c, but it should be
consistent with the remainder of iptables, this means to do as
the ruleset says.

>After reading the relevant bits of the RFC and a bit
>more code, I agree that xrlim_allow() is indeed
>buggered...
>
>I'm far from being an expert on linux's networking
>internals, but it seems to me that many aspects of the
>operation of network stacks are configurable using
>sysctl variables. Not calling icmpv4_xrlim_allow()
>will make the icmp ratelimit parameter a bit of an odd
>one out as far as ipv4 is concerned, as I think there
>are other ipv4 sysctl parameters who's functionality
>could similarly be replaced by iptables...
>
ipt_REJECT is different from icmp.c, it doesn't send ICMP messages
in response to error conditions but because the admin said so in
his ruleset. If he wants to limit it he can use the limit match.

>I'll be happy do do up a patch on whatever is decided
>upon anyway...
>
I already removed it in my tree, but haven't committed it yet.

Regards
Patrick
