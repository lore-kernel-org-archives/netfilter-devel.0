From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-next] netfilter: acct: add support to accounters in nftables
Date: Mon, 12 Jan 2015 13:27:54 +0100
Message-ID: <20150112122754.GA4326@salvia>
References: <cover.1421059771.git.ana@soleta.eu>
 <99c6e9b457ccc93fb761f6fa7f87fb9e6affc4ee.1421059771.git.ana@soleta.eu>
 <20150112113135.GA3279@salvia>
 <20150112114539.GD3491@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ana@soleta.eu, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35802 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbbALMZa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2015 07:25:30 -0500
Content-Disposition: inline
In-Reply-To: <20150112114539.GD3491@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 12, 2015 at 11:45:39AM +0000, Patrick McHardy wrote:
> On 12.01, Pablo Neira Ayuso wrote:
> > > +/**
> > > + * struct nft_acct - nf_tables acct instance
> > > + *
> > > + * @list: table acct list node
> > > + * @name: name of the acct
> > > + * @pkts:  number of packets
> > > + * @bytes:  number of bytes
> > > + * use: number of rule references to this acct
> > > + */
> > > +struct nft_acct {
> > > +	struct list_head	list;
> > > +	char                    name[NFT_ACCT_MAXNAMELEN];
> > 
> > NFT_ACCT_MAXNAMELEN needs to be limited to 16 bytes, so we can easily
> > use acct objects from mappings.
> 
> Not saying that we need more than 16 bytes, but we'd hopefully use
> references instead of runtime resolved lookups in mappings :)

I just noticed Ana have to replace NFTA_ACCT_EXPR_NAME by
NFTA_ACCT_EXPR_SREG to support mappings.

What's your idea behind the references? Use some unique id to identify
the object instead of the name?
