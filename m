Return-Path: <SRS0=M1Ox=YC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57C46C47404
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Oct 2019 09:37:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3523820673
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Oct 2019 09:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730506AbfJIJh2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Oct 2019 05:37:28 -0400
Received: from correo.us.es ([193.147.175.20]:34644 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbfJIJh2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Oct 2019 05:37:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 524C5E8643
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2019 11:37:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 42C28BAACC
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2019 11:37:24 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3FBE14C3BF; Wed,  9 Oct 2019 11:37:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E844ADA8E8;
        Wed,  9 Oct 2019 11:37:21 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 09 Oct 2019 11:37:21 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C45C342EE38E;
        Wed,  9 Oct 2019 11:37:21 +0200 (CEST)
Date:   Wed, 9 Oct 2019 11:37:23 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v3 04/11] nft-cache: Introduce cache levels
Message-ID: <20191009093723.snbyd6xvtd5gpnto@salvia>
References: <20191008161447.6595-1-phil@nwl.cc>
 <20191008161447.6595-5-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191008161447.6595-5-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Tue, Oct 08, 2019 at 06:14:40PM +0200, Phil Sutter wrote:
> Replace the simple have_cache boolean by a cache level indicator
> defining how complete the cache is. Since have_cache indicated full
> cache (including rules), make code depending on it check for cache level
> NFT_CL_RULES.
> 
> Core cache fetching routine __nft_build_cache() accepts a new level via
> parameter and raises cache completeness to that level.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  iptables/nft-cache.c | 51 +++++++++++++++++++++++++++++++-------------
>  iptables/nft.h       |  9 +++++++-
>  2 files changed, 44 insertions(+), 16 deletions(-)
> 
> diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
> index 5444419a5cc3b..22a87e94efd76 100644
> --- a/iptables/nft-cache.c
> +++ b/iptables/nft-cache.c
> @@ -224,30 +224,49 @@ static int fetch_rule_cache(struct nft_handle *h)
>  	return 0;
>  }
>  
> -static void __nft_build_cache(struct nft_handle *h)
> +static void __nft_build_cache(struct nft_handle *h, enum nft_cache_level level)
>  {
>  	uint32_t genid_start, genid_stop;
>  
> +	if (level <= h->cache_level)
> +		return;
>  retry:
>  	mnl_genid_get(h, &genid_start);
> -	fetch_table_cache(h);
> -	fetch_chain_cache(h);
> -	fetch_rule_cache(h);
> -	h->have_cache = true;
> -	mnl_genid_get(h, &genid_stop);
>  
> +	switch (h->cache_level) {
> +	case NFT_CL_NONE:
> +		fetch_table_cache(h);
> +		if (level == NFT_CL_TABLES)
> +			break;
> +		/* fall through */
> +	case NFT_CL_TABLES:

If the existing level is TABLES and use wants chains, then you have to
invalidate the existing table cache, then fetch the tables and chains
to make sure cache is consistent. I mean, extending an existing cache
might lead to inconsistencies.

Am I missing anything?

> +		fetch_chain_cache(h);
> +		if (level == NFT_CL_CHAINS)
> +			break;
> +		/* fall through */
> +	case NFT_CL_CHAINS:
> +		fetch_rule_cache(h);
> +		if (level == NFT_CL_RULES)
> +			break;
> +		/* fall through */
> +	case NFT_CL_RULES:
> +		break;
> +	}
> +
> +	mnl_genid_get(h, &genid_stop);
>  	if (genid_start != genid_stop) {
>  		flush_chain_cache(h, NULL);
>  		goto retry;
>  	}
>  
> +	h->cache_level = level;
>  	h->nft_genid = genid_start;
>  }
