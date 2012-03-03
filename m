From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] bridge: netfilter: don't call iptables on vlan packets
 if sysctl is off
Date: Sat, 3 Mar 2012 11:20:21 +0100
Message-ID: <20120303102021.GE11311@Chamillionaire.breakpoint.cc>
References: <1330638154-1142-1-git-send-email-fw@strlen.de>
 <4F51376F.3050704@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Jiri Pirko <jpirko@redhat.com>, Jesse Gross <jesse@nicira.com>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:36006 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752136Ab2CCKUW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 3 Mar 2012 05:20:22 -0500
Content-Disposition: inline
In-Reply-To: <4F51376F.3050704@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bart De Schuymer <bdschuym@pandora.be> wrote:
> Op 1/03/2012 22:42, Florian Westphal schreef:
> > When net.bridge.bridge-nf-filter-vlan-tagged is 0 (default), vlan packets
> > arriving should not be sent to ip(6)tables by bridge netfilter.
> >
> > However, it turns out that we currently always send VLAN packets to
> > netfilter, if ..
> > a), CONFIG_VLAN_8021Q is enabled ; or
> > b), CONFIG_VLAN_8021Q is not set but rx vlan offload is enabled
> >     on the bridge port.
> >
> > This is because bridge netfilter treats skb with
> > skb->protocol == ETH_P_IP{V6} as "non-vlan packet".
> 
> > -	else if (skb->protocol == htons(ETH_P_IPV6) || IS_VLAN_IPV6(skb) ||
> > -		 IS_PPPOE_IPV6(skb))
> > +	else if (IS_IPV6(skb) || IS_PPPOE_IPV6(skb))
> 
> > -	if (skb->protocol != htons(ETH_P_ARP)) {
> > -		if (!IS_VLAN_ARP(skb))
> > -			return NF_ACCEPT;
> > -		nf_bridge_pull_encap_header(skb);
> > -	}
> > +	if (!IS_ARP(skb))
> > +		return NF_ACCEPT;
> > +	nf_bridge_pull_encap_header(skb);
> 
> > -	if (skb->protocol == htons(ETH_P_IP) || IS_VLAN_IP(skb) ||
> > -	    IS_PPPOE_IP(skb))
> > +	if (IS_IP(skb) || IS_PPPOE_IP(skb))
> 
> I think the above is quite unclear to read. I would prefer something 
> like this:
> if (IS_IP(skb) || IS_VLAN_IP(skb) || IS_PPPOE_IP(skb))

I disagree.  But fair enough, I'll change it & respin on monday, if...

> The compiler should easily remove any redundant checks that this would 
> produce.

... gcc removes the redundant checks (I expect it to).

> Apart from that the patch looks fine to me.

Thanks for reviewing!

Regards,
Florian
