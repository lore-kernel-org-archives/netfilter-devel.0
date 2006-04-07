From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/4] fix loading shared library of ICMPv6 match
Date: Fri, 07 Apr 2006 14:37:04 +0200
Message-ID: <44365CF0.4030304@trash.net>
References: <200604071131.k37BV2wB005845@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200604071131.k37BV2wB005845@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
> Date: Wed, 29 Mar 2006 16:25:27 +0900 (JST)
> 
> 
>>From: "Daniel De Graaf" <danieldegraaf@gmail.com>
>>Date: Sun, 26 Mar 2006 22:19:27 -0600
>>
>>
>>>libip6t_icmpv6.c registers a match called "icmp6", which means that
>>>ip6tables -vL and ip6tables-save cannot output the match correctly.
>>
>>There are 2 solutions.
>>
>>	1. just rename libip6t_icmpv6.c to libip6t_icmp6.c. This can
>>	   conform names of internal structure, library and kernel module.
>>	2. apply attached patch to fix find_match() so that ip6tables can
>>	   load libip6t_icmpv6.so.
>>
>>I like 1 but I'm not sure we can do it. Anyone knows any historical
>>problem about it ?
> 
> 
> No problem ? OK, then I take 1.

I'm not aware of any historical problems. I think it should be fine.
