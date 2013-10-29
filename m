From: Florian Westphal <fw@strlen.de>
Subject: Re: IPV6 nf defrag does not work
Date: Tue, 29 Oct 2013 12:56:17 +0100
Message-ID: <20131029115617.GA16615@breakpoint.cc>
References: <20131029105208.GA18526@minipsycho.orion>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, pablo@netfilter.org,
	netfilter-devel@vger.kernel.org, yoshfuji@linux-ipv6.org,
	kadlec@blackhole.kfki.hu, kaber@trash.net
To: Jiri Pirko <jiri@resnulli.us>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:57271 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751237Ab3J2L4W (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Oct 2013 07:56:22 -0400
Content-Disposition: inline
In-Reply-To: <20131029105208.GA18526@minipsycho.orion>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jiri Pirko <jiri@resnulli.us> wrote:
> On the current net-next if you on HOSTA do:
> ip6tables -I INPUT -p icmpv6 -j DROP
> ip6tables -I INPUT -p icmpv6 -m icmp6 --icmpv6-type 128 -j ACCEPT
> 
> and on HOSTB you do:
> ping6 HOSTA -s2000    (MTU is 1500)
> 
> Only the first ICMP echo request will be passed through, the rest is not
> passed on HOSTA. This issue does not occur with smaller packets than MTU (where
> fragmentation does not happen).
>
> I'm trying to find out where the problem is.

Are you sure this is new behaviour? As far back as I can remember
it was always like this.

in ip6tables, the individual fragments are sent through the ruleset,
iow. you'll need to make use of '-m conntrack' to match the fragments
belonging to an existing connection.

I don't know why this is, and I don't like this either.
But this is how it was implemented, see

net/ipv6/netfilter/nf_defrag_ipv6_hooks.c, ipv6_defrag() ->
nf_ct_frag6_output()
