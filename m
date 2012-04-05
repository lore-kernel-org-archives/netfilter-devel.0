From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next] netfilter: bridge: optionally set indev to vlan
Date: Thu, 5 Apr 2012 13:09:36 +0200
Message-ID: <20120405110936.GA8098@1984>
References: <20120404195729.GC23461@Chamillionaire.breakpoint.cc>
 <20120405010909.GA6081@1984>
 <20120405073059.GD23461@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40643 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab2DELJn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Apr 2012 07:09:43 -0400
Content-Disposition: inline
In-Reply-To: <20120405073059.GD23461@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 05, 2012 at 09:30:59AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Wed, Apr 04, 2012 at 09:57:29PM +0200, Florian Westphal wrote:
> > > if net.bridge.bridge-nf-filter-vlan-tagged sysctl is enabled, bridge
> > > netfilter removes the vlan header temporarily and then feeds the packet
> > > to ip(6)tables.
> > > 
> > > When the new "bridge-nf-pass-vlan-input-device" sysctl is on
> > > (default off), then bridge netfilter will also change the in/out
> > > interface to the vlan interface; if such an interface exists.
> > > 
> > > This is needed to make iptables REDIRECT target work with
> > > "vlan-on-top-of-bridge" setups. Also, 'iptables -i' can then be used
> > > to match the vlan device name.
> > > 
> > > Also update Documentation with current brnf default settings.
> > 
> > Better to implement a vlan device match for iptables?
> 
> That would mean that REDIRECT target is unsupported in vlan-on-bridge
> case.

I see, it would not support any other targets that relies on skb->dev
either.

Let me think if I can come with a better solution. If not, I'll take
your patch.

Thanks Florian.
