From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl 1/3] expr: add dup expression support
Date: Mon, 17 Aug 2015 17:18:23 +0200
Message-ID: <20150817151823.GA4209@salvia>
References: <1439778258-7546-1-git-send-email-pablo@netfilter.org>
 <20150817132417.GA7964@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57384 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755571AbbHQPMR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Aug 2015 11:12:17 -0400
Content-Disposition: inline
In-Reply-To: <20150817132417.GA7964@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 17, 2015 at 02:24:20PM +0100, Patrick McHardy wrote:
> On 17.08, Pablo Neira Ayuso wrote:
> > index a99e6a9..cf4a1ce 100644
> > --- a/include/linux/netfilter/nf_tables.h
> > +++ b/include/linux/netfilter/nf_tables.h
> > @@ -936,6 +936,20 @@ enum nft_redir_attributes {
> >  #define NFTA_REDIR_MAX		(__NFTA_REDIR_MAX - 1)
> >  
> >  /**
> > + * enum nft_tee_attributes - nf_tables tee expression netlink attributes
> > + *
> > + * @NFTA_DUP_SREG_ADDR: source register of destination (NLA_U32: nft_registers)
> > + * @NFTA_DUP_SREG_DEV: output interface name (NLA_U32: nft_register)
> > + */
> > +enum nft_tee_attributes {
> 
> Shouldn't these be called nft_dup_attributes?

Yes, this is a leftover from previous kernel patches, will resync this
headers and will push this into master after that is fixed. Thanks!
