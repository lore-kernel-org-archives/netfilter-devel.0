From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V2 nf-next] netfilter: meta: add support for setting
 skb->pkttype
Date: Mon, 14 Dec 2015 12:45:25 +0100
Message-ID: <20151214114525.GA3469@salvia>
References: <1449767047-15389-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55826 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932203AbbLNLpd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Dec 2015 06:45:33 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A03B8B6B9C
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2015 12:45:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 89522DA808
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2015 12:45:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A4099DA808
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2015 12:45:29 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1449767047-15389-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Cc'ing Patrick, I would like to hear him, this is bringing up again
the datatype issue that we discussed before.

On Thu, Dec 10, 2015 at 06:04:07PM +0100, Florian Westphal wrote:
> This allows to redirect bridged packets to local machine:
> 
> ether type ip ether daddr set aa:53:08:12:34:56 meta pkttype set unicast
> Without 'set unicast', ip stack discards PACKET_OTHERHOST skbs.
> 
> It is also useful to add support for a '-m cluster like' nft rule
> (where switch floods packets to several nodes, and each cluster node
>  node processes a subset of packets for load distribution).
> 
> Mangling is restricted to HOST/OTHER/BROAD/MULTICAST, i.e. you cannot set
> skb->pkt_type to PACKET_KERNEL or change PACKET_LOOPBACK to PACKET_HOST.
> @@ -190,6 +192,13 @@ err:
>  }
>  EXPORT_SYMBOL_GPL(nft_meta_get_eval);
>  
> +/* don't change or set _LOOPBACK, _USER, etc. */
> +static bool pkt_type_ok(u32 p)
> +{
> +	return p == PACKET_HOST || p == PACKET_BROADCAST ||
> +	       p == PACKET_MULTICAST || p == PACKET_OTHERHOST;
> +}

I think we should make use of the datatypes in the kernel side, ie.
add NFT_DATA_PKTTYPE. Currently we are using the raw NFT_DATA_VALUE
which doesn't semantically tell us anything on the kind of data.

The datatype will allow to perform validation from the configuration
plane on correct value that we support, otherwise return -EOPNOTSUPP.
This approach above seems a bit sloppy to me as the validation happens
from the packet path.

Then, we should enhance the validation code to make sure the
expression get the expected datatypes when passing data from one to
another.

I think we will need something similar for Tejun's cgroups2 since
PATH_MAX doesn't fit into our 128-bit register and copying 4096 bytes
for each packet is not an option through an immediate.

I already discussed this with Patrick. His concerns go in the
direction we didn't come up with a design for to optimization at
ruleset-level (eg. avoid fetching the same packet field several times
from different rules) and this validation at rule level may introduce
problems to this.

Using this datatypes will result in making the validation at (global)
ruleset level a bit more complicated. But after thinking a while on
this, such scenario will require a new 'constant' flag for the table
ruleset as making dynamic updates with an optimized ruleset would be
complicated.

I also have a patch to add a NFT_DATA_IFACE type to maintain the
mapping between index and device names from the kernel.

That makes three possible use cases of this datatype + validation at
rule level.
