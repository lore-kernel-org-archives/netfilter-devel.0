Return-Path: <SRS0=Tpyl=XZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8730EC32792
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Sep 2019 20:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66033224FE
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Sep 2019 20:51:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729171AbfI3UvI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Sep 2019 16:51:08 -0400
Received: from correo.us.es ([193.147.175.20]:56576 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726425AbfI3UvH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Sep 2019 16:51:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C9BDEE8E8D
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2019 19:12:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BC617B7FFB
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2019 19:12:14 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B21E0B7FF6; Mon, 30 Sep 2019 19:12:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 986A4D2B1F;
        Mon, 30 Sep 2019 19:12:12 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Sep 2019 19:12:12 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7542F42EF9E0;
        Mon, 30 Sep 2019 19:12:12 +0200 (CEST)
Date:   Mon, 30 Sep 2019 19:12:14 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v2 08/24] nft: Fetch only chains in
 nft_chain_list_get()
Message-ID: <20190930171214.nq52s4tkac3vp6qr@salvia>
References: <20190925212605.1005-1-phil@nwl.cc>
 <20190925212605.1005-9-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925212605.1005-9-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 25, 2019 at 11:25:49PM +0200, Phil Sutter wrote:
> The function is used to return the given table's chains, so fetching
> chain cache is enough.
> 
> This requires a bunch of manual rule cache updates in different places.
> To still support the fake cache logic from xtables-restore, make
> fetch_rule_cache() do nothing in case have_cache is set.
> 
> Accidental double rule cache updates for the same chain need to be
> prevented. This is complicated by the fact that chain's rule list is
> managed by libnftnl. Hence the same logic as used for table list, namely
> checking list pointer value, can't be used. Instead, simply fetch rules
> only if the given chain's rule list is empty. If it isn't, rules have
> been fetched before; if it is, a second rule fetch won't hurt.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  iptables/nft.c | 29 ++++++++++++++++++++++++++++-
>  1 file changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/iptables/nft.c b/iptables/nft.c
> index 7c974af8b4141..729b88d990f9f 100644
> --- a/iptables/nft.c
> +++ b/iptables/nft.c
> @@ -1264,6 +1264,7 @@ err:
>  
>  static struct nftnl_chain *
>  nft_chain_find(struct nft_handle *h, const char *table, const char *chain);
> +static int fetch_rule_cache(struct nft_handle *h, struct nftnl_chain *c);
>  
>  int
>  nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
> @@ -1275,6 +1276,14 @@ nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
>  
>  	nft_xt_builtin_init(h, table);
>  
> +	/* Since ebtables user-defined chain policies are implemented as last
> +	 * rule in nftables, rule cache is required here to treat them right. */
> +	if (h->family == NFPROTO_BRIDGE) {
> +		c = nft_chain_find(h, table, chain);
> +		if (c && !nft_chain_builtin(c))
> +			fetch_rule_cache(h, c);
> +	}
> +
>  	nft_fn = nft_rule_append;
>  
>  	r = nft_rule_new(h, chain, table, data);
> @@ -1550,6 +1559,9 @@ static int nft_rule_list_update(struct nftnl_chain *c, void *data)
>  	struct nftnl_rule *rule;
>  	int ret;
>  
> +	if (nftnl_rule_lookup_byindex(c, 0))
> +		return 0;
> +
>  	rule = nftnl_rule_alloc();
>  	if (!rule)
>  		return -1;
> @@ -1579,6 +1591,9 @@ static int fetch_rule_cache(struct nft_handle *h, struct nftnl_chain *c)
>  {
>  	int i;
>  
> +	if (h->have_cache)
> +		return 0;
> +
>  	if (c)
>  		return nft_rule_list_update(c, h);
>  
> @@ -1670,7 +1685,8 @@ struct nftnl_chain_list *nft_chain_list_get(struct nft_handle *h,
>  	if (!t)
>  		return NULL;
>  
> -	nft_build_cache(h);
> +	if (!h->have_cache && !h->cache->table[t->type].chains)
> +		fetch_chain_cache(h);

Could we extend nft_build_cache(...) to be used from everywhere in
this code?

Or add something like:

        nft_build_table_cache(...)
        nft_build_chain_cache(...)
        nft_build_rule_cache(...)

that actually call __nft_build_cache(...) with many parameters to
specify what table/chain/... specifically you need.

I don't have any specific design in mind for this API. However, I
would like to see a single routine to build a cache the way you need.
That single routine will ensure cache consistency, no matter what
configuration of partial cache you need.

While speeding up things, cache consistency needs to be guaranteed.
