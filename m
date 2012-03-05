From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2] bridge: netfilter: don't call iptables on vlan
 packets if sysctl is off
Date: Mon, 5 Mar 2012 22:02:35 +0100
Message-ID: <20120305210235.GF11311@Chamillionaire.breakpoint.cc>
References: <1330946020-25748-1-git-send-email-fw@strlen.de>
 <4F54F19C.2050507@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:33482 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750993Ab2CEVCg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Mar 2012 16:02:36 -0500
Content-Disposition: inline
In-Reply-To: <4F54F19C.2050507@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bart De Schuymer <bdschuym@pandora.be> wrote:
> Op 5/03/2012 12:13, Florian Westphal schreef:
> > When net.bridge.bridge-nf-filter-vlan-tagged is 0 (default), vlan packets
> > arriving should not be sent to ip(6)tables by bridge netfilter.
> 
> > +#define IS_ARP(skb) \
> > +	(!vlan_tx_tag_present(skb)&&  skb->protocol == htons(ETH_P_ARP))
> > +
> 
> I could nitpick on the lack of a space before the && (it's also in other 
> places in your patch). Is that intentional?

No; but I can't see where this is coming from.  The space shows up
at the right place here.  It also seems to be correct in marc.info
archives.

Pablo, please yell at me if the patch doesn't work for you.

Thanks,
Florian
