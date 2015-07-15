From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH nf] netfilter: bridge: fix IPv6 packets not being
 bridged with CONFIG_IPV6=n
Date: Wed, 15 Jul 2015 19:47:02 +0200
Message-ID: <20150715174702.GA7407@salvia>
References: <1436130933-17639-1-git-send-email-bernhard.thaler@wvnet.at>
 <20150705215334.GA16864@breakpoint.cc>
 <559AEC67.6020601@wvnet.at>
 <20150706214113.GG16864@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bernhard Thaler <bernhard.thaler@wvnet.at>,
	kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58586 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbbGORlV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jul 2015 13:41:21 -0400
Content-Disposition: inline
In-Reply-To: <20150706214113.GG16864@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 06, 2015 at 11:41:13PM +0200, Florian Westphal wrote:
> Bernhard Thaler <bernhard.thaler@wvnet.at> wrote:
[...]
> > > Might also make sense to not create the sysctl and sysfs entry in the
> > > first place if no ip6tables is available.
> > 
> > Totally agree, it would be the best solution.
> > 
> > My idea was that I do not know how admins and their existing scripts
> > react if sysctl and sysfs entry are gone entirely...and if everybody
> > assumes the default is 0 if these entry do not exist.
> > 
> > But scripts that do not check the return code of their write operations
> > on the sysctl and sysfs may not check for the existance of these entries
> > either...
> 
> Yes, thats the problem, a script checking the errors would break as
> well.
> 
> Fortunately its not really important since this only affects custom
> kernel builds.

Right. I think it would be good to have that patch to disable the
/proc interface when CONFIG_IPV6 is not built.

Would you please send us that patch Bernhard?

> > A message in dmesg log explaining that ip6tables sysctl and sysfs
> > entries are not exposed due to CONFIG_IPV6=n (and/or IP6_NF_IPTABLES)
> > may be more helpful to understand what is going on.
> 
> Hmm, not sure if there is any point in doing that.
> We don't do that in other cases either, the assumotion is that if you
> build your own kernels you better know what you're doing (also, in this
> case ip6tables doesn't work either which is hopefully the right clue...)

Agreed.
