Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8947C6FD1F
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Mar 2023 09:23:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbjCPJXk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Mar 2023 05:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbjCPJXj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Mar 2023 05:23:39 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A797B1A75
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Mar 2023 02:23:36 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pcjpe-0005gb-Db; Thu, 16 Mar 2023 10:23:34 +0100
Date:   Thu, 16 Mar 2023 10:23:34 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next] netfilter: nft_exthdr: add boolean DCCP option
 matching
Message-ID: <20230316092334.GE4072@breakpoint.cc>
References: <20230312143714.158943-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230312143714.158943-1-jeremy@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jeremy Sowden <jeremy@azazel.net> wrote:
> The xt_dccp iptables module supports the matching of DCCP packets based
> on the presence or absence of DCCP options.  Extend nft_exthdr to add
> this functionality to nftables.
> 
> Link: https://bugzilla.netfilter.org/show_bug.cgi?id=930
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |   2 +
>  net/netfilter/nft_exthdr.c               | 105 +++++++++++++++++++++++
> +struct nft_exthdr_dccp {
> +	struct nft_exthdr exthdr;
> +	/* A buffer into which to copy the DCCP packet options for parsing.  The
> +	 * options are located between the packet header and its data.  The
> +	 * offset of the data from the start of the header is stored in an 8-bit
> +	 * field as the number of 32-bit words, so the options will definitely
> +	 * be shorter than `4 * U8_MAX` bytes.
> +	 */
> +	u8 optbuf[4 * U8_MAX];
> +};
> +
>  static unsigned int optlen(const u8 *opt, unsigned int offset)
>  {
>  	/* Beware zero-length options: make finite progress */
> @@ -406,6 +418,70 @@ static void nft_exthdr_sctp_eval(const struct nft_expr *expr,
>  		regs->verdict.code = NFT_BREAK;
>  }
>  
> +static void nft_exthdr_dccp_eval(const struct nft_expr *expr,
> +				 struct nft_regs *regs,
> +				 const struct nft_pktinfo *pkt)
> +{
> +	struct nft_exthdr_dccp *priv_dccp = nft_expr_priv(expr);
> +	struct nft_exthdr *priv = &priv_dccp->exthdr;
> +	u32 *dest = &regs->data[priv->dreg];
> +	unsigned int optoff, optlen, i;
> +	const struct dccp_hdr *dh;
> +	struct dccp_hdr _dh;
> +	const u8 *options;
> +
> +	if (pkt->tprot != IPPROTO_DCCP || pkt->fragoff)
> +		goto err;
> +
> +	dh = skb_header_pointer(pkt->skb, nft_thoff(pkt), sizeof(_dh), &_dh);
> +	if (!dh)
> +		goto err;
> +
> +	if (dh->dccph_doff * 4 < __dccp_hdr_len(dh))
> +		goto err;
> +
> +	optoff = __dccp_hdr_len(dh);
> +	optlen = dh->dccph_doff * 4 - optoff;

Perhaps reorder this slightly:

     optoff = __dccp_hdr_len(dh);
     if (dh->dccph_doff * 4 <= optoff)
	     goto err;

     optlen = dh->dccph_doff * 4 - optoff;

     options = skb_header_pointer(pkt->skb, nft_thoff(pkt) + optoff, optlen,
				     priv_dccp->optbuf);

This isn't safe.  priv_dccp->optbuf is neither percpu nor is there
something that prevents a softinterrupt from firing.

I suggest you have a look at 'pipapo' set type which uses percpu scratch
maps.

Yet another alternative is to provide a small onstack scratch buffer,
say 256 byte, and fall back to kmalloc for larger spaces.

Or, always use a on-stack buffer that gets re-used for each of the
parsed options.

> +	for (i = 0; i < optlen; ) {
> +		/* Options 0 - 31 are 1B in the length.  Options 32 et seq. are
> +		 * at least 2B long.  In all cases, the first byte contains the
> +		 * option type.  In multi-byte options, the second byte contains
> +		 * the option length, which must be at least two; if it is
> +		 * greater than two, there are `len - 2` following bytes of
> +		 * option data.
> +		 */
> +		unsigned int len;
> +
> +		if (options[i] > 31 && (optlen - i < 2 || options[i + 1] < 2))
> +			goto err;
> +
> +		len = options[i] > 31 ? options[i + 1] : 1;
> +
> +		if (optlen - i < len)
> +			goto err;
> +
> +		if (options[i] != priv->type) {
> +			i += len;

I think this needs to guard against len == 0?
