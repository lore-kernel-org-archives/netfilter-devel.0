From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH netfilter: nft] netfilter: nf_tables Add set op to nft_ct
 module
Date: Tue, 7 Jan 2014 16:32:10 +0100
Message-ID: <20140107153210.GG9894@breakpoint.cc>
References: <1389107719-24280-1-git-send-email-kristian.evensen@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55916 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751632AbaAGPcL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:32:11 -0500
Content-Disposition: inline
In-Reply-To: <1389107719-24280-1-git-send-email-kristian.evensen@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Kristian Evensen <kristian.evensen@gmail.com> wrote:
> +static void nft_ct_set_eval(const struct nft_expr *expr,
> +			    struct nft_data data[NFT_REG_MAX + 1],
> +			    const struct nft_pktinfo *pkt)
> +{
> +	const struct nft_ct *priv = nft_expr_priv(expr);
> +	struct sk_buff *skb = pkt->skb;
> +	u32 value = data[priv->sreg].data[0];
> +	enum ip_conntrack_info ctinfo;
> +	struct nf_conn *ct;
> +
> +	ct = nf_ct_get(skb, &ctinfo);
> +
> +	if (ct == NULL)
> +		return;
> +
> +	switch (priv->key) {
> +#ifdef CONFIG_NF_CONNTRACK_MARK
> +	case NFT_CT_MARK:
> +		ct->mark = value;
> +		nf_conntrack_event_cache(IPCT_MARK, ct);

I think the event should only be raised when the mark value
is altered, else one might get nfct event storm.
