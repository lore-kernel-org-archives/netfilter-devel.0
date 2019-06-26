Return-Path: <SRS0=TDc5=UZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 258C8C48BD3
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 09:24:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05CD820659
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 09:24:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfFZJYJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jun 2019 05:24:09 -0400
Received: from mail.us.es ([193.147.175.20]:36550 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbfFZJYJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 05:24:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9C2A5FB440
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jun 2019 11:24:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8D5B7114D70
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jun 2019 11:24:07 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8C39A114D6E; Wed, 26 Jun 2019 11:24:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 61910114D8C;
        Wed, 26 Jun 2019 11:24:05 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 26 Jun 2019 11:24:05 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3AF674265A31;
        Wed, 26 Jun 2019 11:24:05 +0200 (CEST)
Date:   Wed, 26 Jun 2019 11:24:04 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v4] netfilter: nf_tables: Add SYNPROXY support
Message-ID: <20190626092404.a6y2ixsyzfw3b3ez@salvia>
References: <20190625103711.751-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190625103711.751-1-ffmancera@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 25, 2019 at 12:37:11PM +0200, Fernando Fernandez Mancera wrote:
[...]
> +static int nft_synproxy_init(const struct nft_ctx *ctx,
> +			     const struct nft_expr *expr,
> +			     const struct nlattr * const tb[])
> +{
> +	struct synproxy_net *snet = synproxy_pernet(ctx->net);
> +	struct nft_synproxy *priv = nft_expr_priv(expr);
> +	u32 flags;
> +	int err;
> +
> +	if (tb[NFTA_SYNPROXY_MSS])
> +		priv->info.mss = ntohs(nla_get_be16(tb[NFTA_SYNPROXY_MSS]));
> +	if (tb[NFTA_SYNPROXY_WSCALE])
> +		priv->info.wscale = nla_get_u8(tb[NFTA_SYNPROXY_WSCALE]);
> +	if (tb[NFTA_SYNPROXY_FLAGS]) {
> +		flags = ntohl(nla_get_be32(tb[NFTA_SYNPROXY_FLAGS]));
> +		if (flags != 0 && (flags & NF_SYNPROXY_OPT_MASK) == 0)

Question: Is flag == 0 valid? If so, no need to return EINVAL in this
case.

> +			return -EINVAL;
> +		priv->info.options = flags;
> +	}
> +
> +	err = nf_ct_netns_get(ctx->net, ctx->family);
> +	if (err)
> +		return err;
> +
> +	switch (ctx->family) {
> +	case NFPROTO_IPV4:
> +		err = nf_synproxy_ipv4_init(snet, ctx->net);
> +		if (err)
> +			goto nf_ct_failure;
> +		snet->hook_ref4++;

nf_synproxy_ipv4_init() internally deals with bumping hook_ref4,
right?

> +		break;
> +#if IS_ENABLED(CONFIG_IPV6)
> +	case NFPROTO_IPV6:
> +		err = nf_synproxy_ipv6_init(snet, ctx->net);
> +		if (err)
> +			goto nf_ct_failure;
> +		snet->hook_ref6++;

Same here.

> +		break;

#endif /* CONFIG_IPV6 */

Note that #endif should finish here, NFPROTO_INET and NFPROTO_BRIDGE
should not be wrapper by this.

finishes here. You can probably replace this to CONFIG_NF_TABLES_IPV6
as above, right?

> +	case NFPROTO_INET:
> +	case NFPROTO_BRIDGE:
> +		err = nf_synproxy_ipv4_init(snet, ctx->net);
> +		if (err)
> +			goto nf_ct_failure;

Missing ifdef.

> +		err = nf_synproxy_ipv6_init(snet, ctx->net);
> +		if (err)
> +			goto nf_ct_failure;
> +		snet->hook_ref4++;
> +		snet->hook_ref6++;

Bumping refcnt manually?

> +		break;
> +#endif
> +	}
> +
> +	return 0;
> +
> +nf_ct_failure:
> +	nf_ct_netns_put(ctx->net, ctx->family);
> +	return err;
> +}
> +
> +static void nft_synproxy_destroy(const struct nft_ctx *ctx,
> +				 const struct nft_expr *expr)
> +{
> +	struct synproxy_net *snet = synproxy_pernet(ctx->net);
> +
> +	switch (ctx->family) {
> +	case NFPROTO_IPV4:
> +		nf_synproxy_ipv4_fini(snet, ctx->net);
> +		break;
> +#if IS_ENABLED(CONFIG_IPV6)
> +	case NFPROTO_IPV6:
> +		nf_synproxy_ipv6_fini(snet, ctx->net);
> +		break;
> +	case NFPROTO_INET:
> +	case NFPROTO_BRIDGE:
> +		nf_synproxy_ipv4_fini(snet, ctx->net);

We should allow bridge to run only with IPv4, if CONFIG_IPV6 is unset.

Just wrap this:

#ifdef IS_ENABLED(...)

> +		nf_synproxy_ipv6_fini(snet, ctx->net);

#endif

Or there's another trick you can do, in the header file, you add:

#ifdef IS_ENABLED(...)
void nf_synproxy_ipv6_fini(..., ...);
#else
static inline void nf_synproxy_ipv6_fini(..., ...) {}
#endid

so we don't need this #ifdef in the code.
