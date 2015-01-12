From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nf-next] netfilter: acct: add support to accounters in nftables
Date: Mon, 12 Jan 2015 11:45:39 +0000
Message-ID: <20150112114539.GD3491@acer.localdomain>
References: <cover.1421059771.git.ana@soleta.eu>
 <99c6e9b457ccc93fb761f6fa7f87fb9e6affc4ee.1421059771.git.ana@soleta.eu>
 <20150112113135.GA3279@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ana@soleta.eu, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34574 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbbALLpn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:45:43 -0500
Content-Disposition: inline
In-Reply-To: <20150112113135.GA3279@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12.01, Pablo Neira Ayuso wrote:
> > +/**
> > + * struct nft_acct - nf_tables acct instance
> > + *
> > + * @list: table acct list node
> > + * @name: name of the acct
> > + * @pkts:  number of packets
> > + * @bytes:  number of bytes
> > + * use: number of rule references to this acct
> > + */
> > +struct nft_acct {
> > +	struct list_head	list;
> > +	char                    name[NFT_ACCT_MAXNAMELEN];
> 
> NFT_ACCT_MAXNAMELEN needs to be limited to 16 bytes, so we can easily
> use acct objects from mappings.

Not saying that we need more than 16 bytes, but we'd hopefully use
references instead of runtime resolved lookups in mappings :)
