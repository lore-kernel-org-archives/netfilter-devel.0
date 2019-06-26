Return-Path: <SRS0=TDc5=UZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 063F0C48BD6
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 09:47:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C49702082F
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 09:47:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="QWAgnvXy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbfFZJrk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jun 2019 05:47:40 -0400
Received: from mx1.riseup.net ([198.252.153.129]:48428 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726131AbfFZJrk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 05:47:40 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 78CB91B9335;
        Wed, 26 Jun 2019 02:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1561542459; bh=c63idb/ZELR9ZEqZ0eNwZ1J+nEwxfcECgNel3bN5U44=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=QWAgnvXycAvtPWar5TyyONbku7tZ2aBmUyiM2ok7iQUwQMVYfX1P38WuP9d28tCH3
         5yQmydOCvusm3mSnZrhCjoCBhzMukf374hl7CfEfxFcczzmB1WWsPyV26+SuotvIhu
         eSgnHr+S9RUBx4L3lAWnMiA9AGdkuawQ2Z23if5I=
X-Riseup-User-ID: 80810288EB5A84728E85D16EFA371F69D7E042F418D99E0DB361DDC204DC7C0F
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 795C5223C2F;
        Wed, 26 Jun 2019 02:47:38 -0700 (PDT)
Subject: Re: [PATCH nf-next v4] netfilter: nf_tables: Add SYNPROXY support
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <20190625103711.751-1-ffmancera@riseup.net>
 <20190626092404.a6y2ixsyzfw3b3ez@salvia>
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <0d2a0f4e-b9c8-d691-95d7-43b1ee0c1b41@riseup.net>
Date:   Wed, 26 Jun 2019 11:47:50 +0200
MIME-Version: 1.0
In-Reply-To: <20190626092404.a6y2ixsyzfw3b3ez@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On 6/26/19 11:24 AM, Pablo Neira Ayuso wrote:
> On Tue, Jun 25, 2019 at 12:37:11PM +0200, Fernando Fernandez Mancera wrote:
> [...]
>> +static int nft_synproxy_init(const struct nft_ctx *ctx,
>> +			     const struct nft_expr *expr,
>> +			     const struct nlattr * const tb[])
>> +{
>> +	struct synproxy_net *snet = synproxy_pernet(ctx->net);
>> +	struct nft_synproxy *priv = nft_expr_priv(expr);
>> +	u32 flags;
>> +	int err;
>> +
>> +	if (tb[NFTA_SYNPROXY_MSS])
>> +		priv->info.mss = ntohs(nla_get_be16(tb[NFTA_SYNPROXY_MSS]));
>> +	if (tb[NFTA_SYNPROXY_WSCALE])
>> +		priv->info.wscale = nla_get_u8(tb[NFTA_SYNPROXY_WSCALE]);
>> +	if (tb[NFTA_SYNPROXY_FLAGS]) {
>> +		flags = ntohl(nla_get_be32(tb[NFTA_SYNPROXY_FLAGS]));
>> +		if (flags != 0 && (flags & NF_SYNPROXY_OPT_MASK) == 0)
> 
> Question: Is flag == 0 valid? If so, no need to return EINVAL in this
> case.

Yes, following the iptables behavior, in nftables we can set something
like this:

table ip x {
	chain y {
        	type filter hook prerouting priority raw; policy accept;
                tcp flags syn notrack
        }

        chain z {
        	type filter hook input priority filter; policy accept;
                ct state { invalid, untracked } synproxy
                ct state invalid drop
        }
}

In this case, flags == 0 because there is anything set.

> 
>> +			return -EINVAL;
>> +		priv->info.options = flags;
>> +	}
>> +
>> +	err = nf_ct_netns_get(ctx->net, ctx->family);
>> +	if (err)
>> +		return err;
>> +
>> +	switch (ctx->family) {
>> +	case NFPROTO_IPV4:
>> +		err = nf_synproxy_ipv4_init(snet, ctx->net);
>> +		if (err)
>> +			goto nf_ct_failure;
>> +		snet->hook_ref4++;
> 
> nf_synproxy_ipv4_init() internally deals with bumping hook_ref4,
> right?
> 

Yes, sorry I forgot to remove it. Same for the IPv6 bump.

>> +		break;
>> +#if IS_ENABLED(CONFIG_IPV6)
>> +	case NFPROTO_IPV6:
>> +		err = nf_synproxy_ipv6_init(snet, ctx->net);
>> +		if (err)
>> +			goto nf_ct_failure;
>> +		snet->hook_ref6++;
> 
> Same here.
> 
>> +		break;
> 
> #endif /* CONFIG_IPV6 */
> 
> Note that #endif should finish here, NFPROTO_INET and NFPROTO_BRIDGE
> should not be wrapper by this.
> 
> finishes here. You can probably replace this to CONFIG_NF_TABLES_IPV6
> as above, right?

Yes. In this case we can replace it with CONFIG_NF_TABLES_IPV6.

> 
>> +	case NFPROTO_INET:
>> +	case NFPROTO_BRIDGE:
>> +		err = nf_synproxy_ipv4_init(snet, ctx->net);
>> +		if (err)
>> +			goto nf_ct_failure;
> 
> Missing ifdef.
> 
>> +		err = nf_synproxy_ipv6_init(snet, ctx->net);
>> +		if (err)
>> +			goto nf_ct_failure;
>> +		snet->hook_ref4++;
>> +		snet->hook_ref6++;
> 
> Bumping refcnt manually?
> 
>> +		break;
>> +#endif
>> +	}
>> +
>> +	return 0;
>> +
>> +nf_ct_failure:
>> +	nf_ct_netns_put(ctx->net, ctx->family);
>> +	return err;
>> +}
>> +
>> +static void nft_synproxy_destroy(const struct nft_ctx *ctx,
>> +				 const struct nft_expr *expr)
>> +{
>> +	struct synproxy_net *snet = synproxy_pernet(ctx->net);
>> +
>> +	switch (ctx->family) {
>> +	case NFPROTO_IPV4:
>> +		nf_synproxy_ipv4_fini(snet, ctx->net);
>> +		break;
>> +#if IS_ENABLED(CONFIG_IPV6)
>> +	case NFPROTO_IPV6:
>> +		nf_synproxy_ipv6_fini(snet, ctx->net);
>> +		break;
>> +	case NFPROTO_INET:
>> +	case NFPROTO_BRIDGE:
>> +		nf_synproxy_ipv4_fini(snet, ctx->net);
> 
> We should allow bridge to run only with IPv4, if CONFIG_IPV6 is unset.
> 
> Just wrap this:
> 
> #ifdef IS_ENABLED(...)
> 
>> +		nf_synproxy_ipv6_fini(snet, ctx->net);
> 
> #endif
> 
> Or there's another trick you can do, in the header file, you add:
> 
> #ifdef IS_ENABLED(...)
> void nf_synproxy_ipv6_fini(..., ...);
> #else
> static inline void nf_synproxy_ipv6_fini(..., ...) {}
> #endid
> 
> so we don't need this #ifdef in the code.
> 

If there is no problem to have an inline definition with an empty body
then this is a good trick to avoid the #ifdef.
