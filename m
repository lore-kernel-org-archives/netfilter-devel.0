From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: target, match and checkentry functions
Date: Thu, 29 Apr 2004 01:33:53 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404290128020.17188-100000@filer.marasystems.com>
References: <408F7388.5010704@aiqa.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ozgur AKAN <akan@aiqa.com>
In-Reply-To: <408F7388.5010704@aiqa.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 28 Apr 2004, Ozgur AKAN wrote:

> Hi,
> 
> I am reading ip_tables.h. There is a structure called  ipt_target. In it 
> there is pointer to a function which is below.
> 
> unsigned int (*target)(struct sk_buff  **pskb, .......)
> 
> I can not find the original function that this function pointer(*target)
> points. When I search for target, I see that it is defined in 6 files.
> Which one is used and when?

You can not find the original "target" function as there is none. It is 
all dependent on which iptables target you are looking at.

This pointer is a pointer to the target function of the target defined by 
this ipt_target structure instance. Each target has it's own ipt_target 
instance with it's unique function pointer in the target field of 
ipt_target.

> How can I understand it? (this is same for match and checkentry
> functions)

Same thing but for matches.

both targets and matches have checkentry functions.


> 6 files in which target is defined;
> 
>     * net/ipv4/netfilter/ipt_ECN.c, line 104
>       <http://lxr.linux.no/source/net/ipv4/netfilter/ipt_ECN.c#L104>
>     * net/ipv4/netfilter/ipt_DSCP.c, line 25
>       <http://lxr.linux.no/source/net/ipv4/netfilter/ipt_DSCP.c#L25>
>     * net/ipv4/netfilter/ipt_MARK.c, line 11
>       <http://lxr.linux.no/source/net/ipv4/netfilter/ipt_MARK.c#L11>
>     * net/ipv4/netfilter/ipt_TOS.c, line 11
>       <http://lxr.linux.no/source/net/ipv4/netfilter/ipt_TOS.c#L11>
>     * net/ipv6/netfilter/ip6t_MARK.c, line 11
>       <http://lxr.linux.no/source/net/ipv6/netfilter/ip6t_MARK.c#L11>

Actually it is defined in a whole lot more files. Each 
ip(6)t_[capital_letters].c defines a ipt_target instance with a 
unique target function.

Each ip(6)t_[lowercase_letters].c defines a ipt_match instance with a 
unique match function.

There is very many of them.

Regards
Henrik
