From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables - PATCH 6/9] nft: Print chains in right order
 when listing rules
Date: Tue, 16 Jul 2013 22:57:43 +0200
Message-ID: <20130716205743.GA17208@localhost>
References: <1373978333-17427-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1373978333-17427-7-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58490 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933954Ab3GPU5s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jul 2013 16:57:48 -0400
Content-Disposition: inline
In-Reply-To: <1373978333-17427-7-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 16, 2013 at 03:38:50PM +0300, Tomasz Bursztyka wrote:
> Fixes an output bug, it was:
> Chain OUTPUT (policy ACCEPT)
> target     prot opt source               destination
> 
> Chain FORWARD (policy ACCEPT)
> target     prot opt source               destination
> 
> Chain INPUT (policy ACCEPT)
> target     prot opt source               destination
>
> where it should be:
> Chain INPUT (policy ACCEPT)
> target     prot opt source               destination
> 
> Chain FORWARD (policy ACCEPT)
> target     prot opt source               destination
> 
> Chain OUTPUT (policy ACCEPT)
> target     prot opt source               destination

I have just checked this. The order is fine except by the nat table,
that one has been corrected it here:

http://git.netfilter.org/iptables-nftables/commit/?id=990b5aec1df02450545b57b94d3c960d9b7b1188

However, if the xtables.conf file is used, the order was reversed so I
could reproduce exactly the same output that you posted here.

I have fixed that by fixing the semantically of nft_*_list_add in
libnftables to prepend, instead of appending. Now we have
nft_*_list_add_tail, I have adapted iptables-nftables to use add_tail
when needed:

http://git.netfilter.org/iptables-nftables/commit/?id=5e6ed2aae9e4a8ec0a340036f485c2567635eca9

Those should be enough to resolve this issue.

Thanks for the initial patch to address this issue.
