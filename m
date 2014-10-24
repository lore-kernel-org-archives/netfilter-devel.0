From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 2/2 v3] evaluate: reject: check in bridge and inet
 the network context in reject
Date: Fri, 24 Oct 2014 12:04:56 +0200
Message-ID: <20141024100456.GD4806@salvia>
References: <1413984353-16029-1-git-send-email-alvaroneay@gmail.com>
 <1413984353-16029-2-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42471 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932142AbaJXKDV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:03:21 -0400
Content-Disposition: inline
In-Reply-To: <1413984353-16029-2-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 22, 2014 at 03:25:53PM +0200, Alvaro Neira Ayuso wrote:
> In Inet tables, we have to check the network context in rules that we use
> icmp or icmpv6 reason in reject. To be sure that the context is the correct.
> However, for icmpx and tcp reject, we don't need to check it.
> 
> In Bridge tables, ee have vlan and arp traffic and they are not supported.
> For this things, we have to check the network context. For example:
> 
>   nft add rule bridge test-bridge input \
> 			ether type arp reject with icmp type host-unreachable
> or
>   nft add rule bridge test-bridge input \
>   			ether type vlan reject with tcp reset
> 
> In that cases, we have to throw an error. Moreover, we have to accept rules
> that the network context is Ipv4 and Ipv6. For example:
> 
>   nft add rule -nnn bridge test-bridge input \
> 			ip protocol tcp reject with tcp reset
> 
> Moreover, this patch refactor the code for check the family for bridge and inet
> tables.

Applied, thanks.
