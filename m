From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables 0/3] ebtables patchset
Date: Mon, 24 Mar 2014 16:09:56 +0100
Message-ID: <20140324150956.GA32546@localhost>
References: <1394220805-18021-1-git-send-email-giuseppelng@gmail.com>
 <531D98DF.5070507@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Giuseppe Longo <giuseppelng@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52651 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306AbaCXPKB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Mar 2014 11:10:01 -0400
Content-Disposition: inline
In-Reply-To: <531D98DF.5070507@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 10, 2014 at 12:50:07PM +0200, Tomasz Bursztyka wrote:
> Hi Pablo and Giuseppe,
> 
> >As you can see, a minor issue have to be fixed when printing rules.
> >I have no idea how to handle --logical-in/out interfaces currently,
> >so please let me know if you have an idea or an advice.
> 
> As far as I know, there is nothing in nftables's side to differentiate
> between interfaces origin, right? (like a proper hw tight 'eth0' vs
> a bridge 'br0')
> Unless I miss something, it has no real meaning in nftables to
> support such differentiation,
> but for the sake of ebtables compat layer we might need a solution here.
> 
> Any idea how this issue could be fixed?

I think you have to extend nft_meta to support that. See
ebt_basic_match(), the net_bridge_port information is obtained via
br_port_get_rcu(dev) given that dev != NULL.

Beware that you have to make sure that the new meta types IIFBRNAME
and OIFBRNAME can only be used from the bridge family.  I think you
have to do something similar to what Patrick did with nft_reject, by
adding a specific flavour of nft_meta for the bridge family.

Giuseppe, what other remaining issues you have with the ebtables
compat layer? Could you summarize them, please? Thanks.
