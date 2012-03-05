From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] bridge: netfilter: don't call iptables on vlan
 packets if sysctl is off
Date: Mon, 5 Mar 2012 23:35:58 +0100
Message-ID: <20120305223558.GA30357@1984>
References: <1330946020-25748-1-git-send-email-fw@strlen.de>
 <4F54F19C.2050507@pandora.be>
 <20120305210235.GF11311@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bart De Schuymer <bdschuym@pandora.be>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48680 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757024Ab2CEWgB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Mar 2012 17:36:01 -0500
Content-Disposition: inline
In-Reply-To: <20120305210235.GF11311@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 05, 2012 at 10:02:35PM +0100, Florian Westphal wrote:
> Bart De Schuymer <bdschuym@pandora.be> wrote:
> > Op 5/03/2012 12:13, Florian Westphal schreef:
> > > When net.bridge.bridge-nf-filter-vlan-tagged is 0 (default), vlan packets
> > > arriving should not be sent to ip(6)tables by bridge netfilter.
> > 
> > > +#define IS_ARP(skb) \
> > > +	(!vlan_tx_tag_present(skb)&&  skb->protocol == htons(ETH_P_ARP))
> > > +
> > 
> > I could nitpick on the lack of a space before the && (it's also in other 
> > places in your patch). Is that intentional?
> 
> No; but I can't see where this is coming from.  The space shows up
> at the right place here.  It also seems to be correct in marc.info
> archives.
> 
> Pablo, please yell at me if the patch doesn't work for you.

Interesting, that space doesn't show up here.

Applied, thanks guys.
