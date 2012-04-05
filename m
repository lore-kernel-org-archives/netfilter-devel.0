From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH -next] netfilter: bridge: optionally set indev to vlan
Date: Thu, 5 Apr 2012 09:30:59 +0200
Message-ID: <20120405073059.GD23461@Chamillionaire.breakpoint.cc>
References: <20120404195729.GC23461@Chamillionaire.breakpoint.cc>
 <20120405010909.GA6081@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53187 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752329Ab2DEHbA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Apr 2012 03:31:00 -0400
Content-Disposition: inline
In-Reply-To: <20120405010909.GA6081@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Apr 04, 2012 at 09:57:29PM +0200, Florian Westphal wrote:
> > if net.bridge.bridge-nf-filter-vlan-tagged sysctl is enabled, bridge
> > netfilter removes the vlan header temporarily and then feeds the packet
> > to ip(6)tables.
> > 
> > When the new "bridge-nf-pass-vlan-input-device" sysctl is on
> > (default off), then bridge netfilter will also change the in/out
> > interface to the vlan interface; if such an interface exists.
> > 
> > This is needed to make iptables REDIRECT target work with
> > "vlan-on-top-of-bridge" setups. Also, 'iptables -i' can then be used
> > to match the vlan device name.
> > 
> > Also update Documentation with current brnf default settings.
> 
> Better to implement a vlan device match for iptables?

That would mean that REDIRECT target is unsupported in vlan-on-bridge
case.
If so, would you accept a man page update that documents this?

Thanks,
Florian
