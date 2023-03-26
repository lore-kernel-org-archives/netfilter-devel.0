Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F22BC74A5B
	for <netfilter-devel@archiver.kernel.org>; Sun, 26 Mar 2023 21:01:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjCZVBW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 26 Mar 2023 17:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCZVBW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Mar 2023 17:01:22 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0E7D03C12
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Mar 2023 14:01:21 -0700 (PDT)
Date:   Sun, 26 Mar 2023 23:01:18 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Florian Westphal <fw@strlen.de>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next] netfilter: nft_exthdr: add boolean DCCP option
 matching
Message-ID: <ZCCynoBkBfy+SXu3@salvia>
References: <20230312143714.158943-1-jeremy@azazel.net>
 <20230316092334.GE4072@breakpoint.cc>
 <20230317223143.GA80565@celephais.dreamlands>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230317223143.GA80565@celephais.dreamlands>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Mar 17, 2023 at 10:31:43PM +0000, Jeremy Sowden wrote:
> On 2023-03-16, at 10:23:34 +0100, Florian Westphal wrote:
> > Jeremy Sowden <jeremy@azazel.net> wrote:
> > > The xt_dccp iptables module supports the matching of DCCP packets based
> > > on the presence or absence of DCCP options.  Extend nft_exthdr to add
> > > this functionality to nftables.
> > > 
> > > Link: https://bugzilla.netfilter.org/show_bug.cgi?id=930
> > > Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> > > ---
> > >  include/uapi/linux/netfilter/nf_tables.h |   2 +
> > >  net/netfilter/nft_exthdr.c               | 105 +++++++++++++++++++++++
> > > +struct nft_exthdr_dccp {
> > > +	struct nft_exthdr exthdr;
> > > +	/* A buffer into which to copy the DCCP packet options for parsing.  The
> > > +	 * options are located between the packet header and its data.  The
> > > +	 * offset of the data from the start of the header is stored in an 8-bit
> > > +	 * field as the number of 32-bit words, so the options will definitely
> > > +	 * be shorter than `4 * U8_MAX` bytes.
> > > +	 */
> > > +	u8 optbuf[4 * U8_MAX];
> > > +};
> > > +
> > >  static unsigned int optlen(const u8 *opt, unsigned int offset)
> > >  {
> > >  	/* Beware zero-length options: make finite progress */
> > > @@ -406,6 +418,70 @@ static void nft_exthdr_sctp_eval(const struct nft_expr *expr,
> > >  		regs->verdict.code = NFT_BREAK;
> > >  }
> > >  
> > > +static void nft_exthdr_dccp_eval(const struct nft_expr *expr,
> > > +				 struct nft_regs *regs,
> > > +				 const struct nft_pktinfo *pkt)
> > > +{
> > > +	struct nft_exthdr_dccp *priv_dccp = nft_expr_priv(expr);
> > > +	struct nft_exthdr *priv = &priv_dccp->exthdr;
> > > +	u32 *dest = &regs->data[priv->dreg];
> > > +	unsigned int optoff, optlen, i;
> > > +	const struct dccp_hdr *dh;
> > > +	struct dccp_hdr _dh;
> > > +	const u8 *options;
> > > +
> > > +	if (pkt->tprot != IPPROTO_DCCP || pkt->fragoff)
> > > +		goto err;
> > > +
> > > +	dh = skb_header_pointer(pkt->skb, nft_thoff(pkt), sizeof(_dh), &_dh);
> > > +	if (!dh)
> > > +		goto err;
> > > +
> > > +	if (dh->dccph_doff * 4 < __dccp_hdr_len(dh))
> > > +		goto err;
> > > +
> > > +	optoff = __dccp_hdr_len(dh);
> > > +	optlen = dh->dccph_doff * 4 - optoff;
> > 
> > Perhaps reorder this slightly:
> > 
> >      optoff = __dccp_hdr_len(dh);
> >      if (dh->dccph_doff * 4 <= optoff)
> > 	     goto err;
> > 
> >      optlen = dh->dccph_doff * 4 - optoff;
> > 
> >      options = skb_header_pointer(pkt->skb, nft_thoff(pkt) + optoff, optlen,
> > 				     priv_dccp->optbuf);
> > 
> > This isn't safe.  priv_dccp->optbuf is neither percpu nor is there
> > something that prevents a softinterrupt from firing.
> > 
> > I suggest you have a look at 'pipapo' set type which uses percpu scratch
> > maps.
> > 
> > Yet another alternative is to provide a small onstack scratch buffer,
> > say 256 byte, and fall back to kmalloc for larger spaces.
> > 
> > Or, always use a on-stack buffer that gets re-used for each of the
> > parsed options.
> 
> On giving it some more thought, it occurred to me that there would be no
> need to read the option data, only the type and length, so one could do
> something like this:
> 
> 	optoff = __dccp_hdr_len(dh);
> 	if (dh->dccph_doff * 4 <= optoff)
> 		goto err;
> 
> 	optlen = dh->dccph_doff * 4 - optoff;
> 
> 	for (i = 0; i < optlen; ) {
> 		u8 buf[2], *ptr, type, len;
> 
> 		ptr = skb_header_pointer(pkt->skb, thoff + optoff + i,
> 					 optlen - i > 1 ? 2 : 1, &buf);
> 		if (!ptr)
> 			goto err;
> 
> 		type = ptr[0];
> 
> 		if (type <= 31)
> 			len = 1;
> 		else {
> 			if (optlen - i < 2)
> 				goto err;
> 
> 			len = ptr[1];
> 
> 			if (len < 2)
> 				goto err;
> 		}
> 
> 		if (type == priv->type) {
> 			*dest = 1;
> 			return;
> 		}
> 
> 		i += len;
> 	}

I believe this should be fine.
