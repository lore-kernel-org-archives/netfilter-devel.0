Return-Path: <SRS0=TDc5=UZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65BFBC48BD3
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 10:07:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42F46204EC
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 10:07:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfFZKHa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jun 2019 06:07:30 -0400
Received: from mail.us.es ([193.147.175.20]:37454 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbfFZKHa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 06:07:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8C13F1031A5
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jun 2019 12:07:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7D4D2DA4D1
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jun 2019 12:07:28 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 72FFDDA7B6; Wed, 26 Jun 2019 12:07:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6E95CDA3F4;
        Wed, 26 Jun 2019 12:07:26 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 26 Jun 2019 12:07:26 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4A3DA4265A2F;
        Wed, 26 Jun 2019 12:07:26 +0200 (CEST)
Date:   Wed, 26 Jun 2019 12:07:25 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v4] netfilter: nf_tables: Add SYNPROXY support
Message-ID: <20190626100725.nrlg3uxjpasvriqm@salvia>
References: <20190625103711.751-1-ffmancera@riseup.net>
 <20190626092404.a6y2ixsyzfw3b3ez@salvia>
 <0d2a0f4e-b9c8-d691-95d7-43b1ee0c1b41@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d2a0f4e-b9c8-d691-95d7-43b1ee0c1b41@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 26, 2019 at 11:47:50AM +0200, Fernando Fernandez Mancera wrote:
> On 6/26/19 11:24 AM, Pablo Neira Ayuso wrote:
[...]
> >> +		break;
> >> +#if IS_ENABLED(CONFIG_IPV6)
> >> +	case NFPROTO_IPV6:
> >> +		err = nf_synproxy_ipv6_init(snet, ctx->net);
> >> +		if (err)
> >> +			goto nf_ct_failure;
> >> +		snet->hook_ref6++;
> > 
> > Same here.
> > 
> >> +		break;
> > 
> > #endif /* CONFIG_IPV6 */
> > 
> > Note that #endif should finish here, NFPROTO_INET and NFPROTO_BRIDGE
> > should not be wrapper by this.
> > 
> > finishes here. You can probably replace this to CONFIG_NF_TABLES_IPV6
> > as above, right?
> 
> Yes. In this case we can replace it with CONFIG_NF_TABLES_IPV6.
> 
> > 
> >> +	case NFPROTO_INET:
> >> +	case NFPROTO_BRIDGE:
> >> +		err = nf_synproxy_ipv4_init(snet, ctx->net);
> >> +		if (err)
> >> +			goto nf_ct_failure;
> > 
> > Missing ifdef.
> > 
> >> +		err = nf_synproxy_ipv6_init(snet, ctx->net);
> >> +		if (err)
> >> +			goto nf_ct_failure;
> >> +		snet->hook_ref4++;
> >> +		snet->hook_ref6++;
> > 
> > Bumping refcnt manually?
> > 
> >> +		break;
> >> +#endif
> >> +	}
> >> +
> >> +	return 0;
> >> +
> >> +nf_ct_failure:
> >> +	nf_ct_netns_put(ctx->net, ctx->family);
> >> +	return err;
> >> +}
> >> +
> >> +static void nft_synproxy_destroy(const struct nft_ctx *ctx,
> >> +				 const struct nft_expr *expr)
> >> +{
> >> +	struct synproxy_net *snet = synproxy_pernet(ctx->net);
> >> +
> >> +	switch (ctx->family) {
> >> +	case NFPROTO_IPV4:
> >> +		nf_synproxy_ipv4_fini(snet, ctx->net);
> >> +		break;
> >> +#if IS_ENABLED(CONFIG_IPV6)
> >> +	case NFPROTO_IPV6:
> >> +		nf_synproxy_ipv6_fini(snet, ctx->net);
> >> +		break;
> >> +	case NFPROTO_INET:
> >> +	case NFPROTO_BRIDGE:
> >> +		nf_synproxy_ipv4_fini(snet, ctx->net);
> > 
> > We should allow bridge to run only with IPv4, if CONFIG_IPV6 is unset.
> > 
> > Just wrap this:
> > 
> > #ifdef IS_ENABLED(...)
> > 
> >> +		nf_synproxy_ipv6_fini(snet, ctx->net);
> > 
> > #endif
> > 
> > Or there's another trick you can do, in the header file, you add:
> > 
> > #ifdef IS_ENABLED(...)
> > void nf_synproxy_ipv6_fini(..., ...);
> > #else
> > static inline void nf_synproxy_ipv6_fini(..., ...) {}
> > #endid
> > 
> > so we don't need this #ifdef in the code.
> > 
> 
> If there is no problem to have an inline definition with an empty body
> then this is a good trick to avoid the #ifdef.

This is fine, but use this only from .h file.

Thanks.
