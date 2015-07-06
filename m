From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC PATCH nf] netfilter: bridge: fix IPv6 packets not being
 bridged with CONFIG_IPV6=n
Date: Mon, 6 Jul 2015 23:41:13 +0200
Message-ID: <20150706214113.GG16864@breakpoint.cc>
References: <1436130933-17639-1-git-send-email-bernhard.thaler@wvnet.at>
 <20150705215334.GA16864@breakpoint.cc>
 <559AEC67.6020601@wvnet.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, pablo@netfilter.org,
	kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org
To: Bernhard Thaler <bernhard.thaler@wvnet.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:59994 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753563AbbGFVlW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jul 2015 17:41:22 -0400
Content-Disposition: inline
In-Reply-To: <559AEC67.6020601@wvnet.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bernhard Thaler <bernhard.thaler@wvnet.at> wrote:
> >> index d89f4fa..db0d038 100644
> >> --- a/net/bridge/br_netfilter_hooks.c
> >> +++ b/net/bridge/br_netfilter_hooks.c
> >> @@ -47,14 +47,22 @@
> >>  #ifdef CONFIG_SYSCTL
> >>  static struct ctl_table_header *brnf_sysctl_header;
> >>  static int brnf_call_iptables __read_mostly = 1;
> >> +#if IS_ENABLED(CONFIG_IPV6)
> > 
> > IS_ENABLED(IP6_NF_IPTABLES) ?
> > 
> 
> br_netfilter_ipv6.o is dependent on CONFIG_IPV6 and contains
> br_nf_pre_routing_ipv6()...for this reason I sticked with CONFIG_IPV6 to
> stay consistent. Maybe we should check for both here?

Hmmm, good point.  I think br_netfilter_ipv6.o should depend
on IP6_NF_IPTABLES (which depends on IPV6) too.

The entire point of that thing is to push skbs into ip6tables...

> > Might also make sense to not create the sysctl and sysfs entry in the
> > first place if no ip6tables is available.
> 
> Totally agree, it would be the best solution.
> 
> My idea was that I do not know how admins and their existing scripts
> react if sysctl and sysfs entry are gone entirely...and if everybody
> assumes the default is 0 if these entry do not exist.
> 
> But scripts that do not check the return code of their write operations
> on the sysctl and sysfs may not check for the existance of these entries
> either...

Yes, thats the problem, a script checking the errors would break as
well.

Fortunately its not really important since this only affects custom
kernel builds.

> A message in dmesg log explaining that ip6tables sysctl and sysfs
> entries are not exposed due to CONFIG_IPV6=n (and/or IP6_NF_IPTABLES)
> may be more helpful to understand what is going on.

Hmm, not sure if there is any point in doing that.
We don't do that in other cases either, the assumotion is that if you
build your own kernels you better know what you're doing (also, in this
case ip6tables doesn't work either which is hopefully the right clue...)
