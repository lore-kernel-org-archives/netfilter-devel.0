Return-Path: <SRS0=NOIG=XP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAF5CC49ED7
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Sep 2019 11:57:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A860E2086A
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Sep 2019 11:57:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406083AbfITL5R (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 07:57:17 -0400
Received: from correo.us.es ([193.147.175.20]:53058 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404368AbfITL5Q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 07:57:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7F57B18CDC3
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2019 13:57:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 66B85A7DA9
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2019 13:57:12 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5A01CA7E3C; Fri, 20 Sep 2019 13:57:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F2822DA840;
        Fri, 20 Sep 2019 13:57:02 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 20 Sep 2019 13:57:02 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [5.182.56.138])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 9EA1E42EE38F;
        Fri, 20 Sep 2019 13:57:02 +0200 (CEST)
Date:   Fri, 20 Sep 2019 13:57:02 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 08/14] xtables-restore: Avoid cache population
 when flushing
Message-ID: <20190920115702.tn4xp5gltcejk6sy@salvia>
References: <20190916165000.18217-1-phil@nwl.cc>
 <20190916165000.18217-9-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916165000.18217-9-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Mon, Sep 16, 2019 at 06:49:54PM +0200, Phil Sutter wrote:
> When called without --noflush, don't fetch full ruleset from kernel but
> merely list of tables and the current genid. Locally, initialize chain
> lists and set have_cache to simulate an empty ruleset.
> 
> Doing so reduces execution time significantly if a large ruleset exists
> in kernel space. A simple test case consisting of a dump with 100,000
> rules can be restored within 15s on my testing VM. Restoring it a second
> time took 21s before this patch and only 17s after it.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  iptables/nft.c             | 27 ++++++++++++++++++++++++++-
>  iptables/nft.h             |  1 +
>  iptables/xtables-restore.c |  7 +++++--
>  3 files changed, 32 insertions(+), 3 deletions(-)
> 
> diff --git a/iptables/nft.c b/iptables/nft.c
> index 7f0f9e1234ae4..820f3392dd495 100644
> --- a/iptables/nft.c
> +++ b/iptables/nft.c
> @@ -882,7 +882,8 @@ static int flush_cache(struct nft_cache *c, const struct builtin_table *tables,
>  		nftnl_chain_list_free(c->table[i].chains);
>  		c->table[i].chains = NULL;
>  	}
> -	nftnl_table_list_free(c->tables);
> +	if (c->tables)
> +		nftnl_table_list_free(c->tables);
>  	c->tables = NULL;
>  
>  	return 1;
> @@ -1617,6 +1618,30 @@ void nft_build_cache(struct nft_handle *h)
>  		__nft_build_cache(h);
>  }
>  
> +void nft_fake_cache(struct nft_handle *h)
> +{
> +	int i;
> +
> +	if (h->have_cache)
> +		return;
> +
> +	/* fetch tables so conditional table delete logic works */
> +	if (!h->cache->tables)
> +		fetch_table_cache(h);
> +
> +	for (i = 0; i < NFT_TABLE_MAX; i++) {
> +		enum nft_table_type type = h->tables[i].type;
> +
> +		if (!h->tables[i].name ||
> +		    h->cache->table[type].chains)
> +			continue;
> +
> +		h->cache->table[type].chains = nftnl_chain_list_alloc();
> +	}
> +	mnl_genid_get(h, &h->nft_genid);
> +	h->have_cache = true;
> +}

Looking at patches from 8/24 onwards, I think it's time to introduce
cache flags logic to iptables.

In patch 9/14 there is a new field have_chain_cache.

In patch 10/14 there is have_rule_cache.

Then moving on, the logic is based on checking for this booleans and
then checking if the caches are initialized or not.

I think if we move towards cache flags logic (the flags tell us what
if we need no cache, partial cache (only tables, tables + chains) or
full cache.

This would make this logic easier to understand and more maintainable.
