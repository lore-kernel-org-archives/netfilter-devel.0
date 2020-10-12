Return-Path: <SRS0=LXG+=DT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DAD9C433E7
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Oct 2020 12:54:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24D3021BE5
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Oct 2020 12:54:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730092AbgJLMyz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Oct 2020 08:54:55 -0400
Received: from correo.us.es ([193.147.175.20]:50512 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729953AbgJLMyy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 08:54:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C1B5DD28C7
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Oct 2020 14:54:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AC145DA78B
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Oct 2020 14:54:52 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A17B6DA722; Mon, 12 Oct 2020 14:54:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 689FCDA73F;
        Mon, 12 Oct 2020 14:54:50 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 12 Oct 2020 14:54:50 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4B40842EE38E;
        Mon, 12 Oct 2020 14:54:50 +0200 (CEST)
Date:   Mon, 12 Oct 2020 14:54:50 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH 3/3] nft: Fix for concurrent noflush restore
 calls
Message-ID: <20201012125450.GA26934@salvia>
References: <20201005144858.11578-1-phil@nwl.cc>
 <20201005144858.11578-4-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201005144858.11578-4-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Oct 05, 2020 at 04:48:58PM +0200, Phil Sutter wrote:
> Transaction refresh was broken with regards to nft_chain_restore(): It
> created a rule flush batch object only if the chain was found in cache
> and a chain add object only if the chain was not found. Yet with
> concurrent ruleset updates, one has to expect both situations:
> 
> * If a chain vanishes, the rule flush job must be skipped and instead
>   the chain add job become active.
> 
> * If a chain appears, the chain add job must be skipped and instead
>   rules flushed.
> 
> Change the code accordingly: Create both batch objects and set their
> 'skip' field depending on the situation in cache and adjust both in
> nft_refresh_transaction().
> 
> As a side-effect, the implicit rule flush becomes explicit and all
> handling of implicit batch jobs is dropped along with the related field
> indicating such.
> 
> Reuse the 'implicit' parameter of __nft_rule_flush() to control the
> initial 'skip' field value instead.
> 
> A subtle caveat is vanishing of existing chains: Creating the chain add
> job based on the chain in cache causes a netlink message containing that
> chain's handle which the kernel dislikes. Therefore unset the chain's
> handle in that case.
> 
> Fixes: 58d7de0181f61 ("xtables: handle concurrent ruleset modifications")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  iptables/nft.c                                | 58 ++++++++++---------
>  .../ipt-restore/0016-concurrent-restores_0    | 53 +++++++++++++++++
>  2 files changed, 83 insertions(+), 28 deletions(-)
>  create mode 100755 iptables/tests/shell/testcases/ipt-restore/0016-concurrent-restores_0
> 
> diff --git a/iptables/nft.c b/iptables/nft.c
> index 70be9ba908edc..9424c181d17cc 100644
> --- a/iptables/nft.c
> +++ b/iptables/nft.c
> @@ -265,7 +265,6 @@ struct obj_update {
>  	struct list_head	head;
>  	enum obj_update_type	type:8;
>  	uint8_t			skip:1;
> -	uint8_t			implicit:1;
>  	unsigned int		seq;
>  	union {
>  		struct nftnl_table	*table;
> @@ -1634,7 +1633,7 @@ struct nftnl_set *nft_set_batch_lookup_byid(struct nft_handle *h,
>  
>  static void
>  __nft_rule_flush(struct nft_handle *h, const char *table,
> -		 const char *chain, bool verbose, bool implicit)
> +		 const char *chain, bool verbose, bool skip)
>  {
>  	struct obj_update *obj;
>  	struct nftnl_rule *r;
> @@ -1656,7 +1655,7 @@ __nft_rule_flush(struct nft_handle *h, const char *table,
>  		return;
>  	}
>  
> -	obj->implicit = implicit;
> +	obj->skip = skip;
>  }
>  
>  struct nft_rule_flush_data {
> @@ -1759,19 +1758,14 @@ int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *tabl
>  int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table)
>  {
>  	struct nftnl_chain_list *list;
> +	struct obj_update *obj;
>  	struct nftnl_chain *c;
>  	bool created = false;
>  
>  	nft_xt_builtin_init(h, table);
>  
>  	c = nft_chain_find(h, table, chain);
> -	if (c) {
> -		/* Apparently -n still flushes existing user defined
> -		 * chains that are redefined.
> -		 */
> -		if (h->noflush)
> -			__nft_rule_flush(h, table, chain, false, true);
> -	} else {
> +	if (!c) {
>  		c = nftnl_chain_alloc();
>  		if (!c)
>  			return 0;
> @@ -1779,20 +1773,26 @@ int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table
>  		nftnl_chain_set_str(c, NFTNL_CHAIN_TABLE, table);
>  		nftnl_chain_set_str(c, NFTNL_CHAIN_NAME, chain);
>  		created = true;
> -	}
>  
> -	if (h->family == NFPROTO_BRIDGE)
> -		nftnl_chain_set_u32(c, NFTNL_CHAIN_POLICY, NF_ACCEPT);
> +		list = nft_chain_list_get(h, table, chain);
> +		if (list)
> +			nftnl_chain_list_add(c, list);
> +	} else {
> +		/* If the chain should vanish meanwhile, kernel genid changes
> +		 * and the transaction is refreshed enabling the chain add
> +		 * object. With the handle still set, kernel interprets it as a
> +		 * chain replace job and errors since it is not found anymore.
> +		 */
> +		nftnl_chain_unset(c, NFTNL_CHAIN_HANDLE);
> +	}
>  
> -	if (!created)
> -		return 1;
> +	__nft_rule_flush(h, table, chain, false, created);

I like this trick.

If I understood correct, you always place an "add chain" command in
first place before the flush, whether the chain exists or not, so the
flush always succeeds.

> -	if (!batch_chain_add(h, NFT_COMPAT_CHAIN_USER_ADD, c))
> +	obj = batch_chain_add(h, NFT_COMPAT_CHAIN_USER_ADD, c);
> +	if (!obj)
>  		return 0;
>  
> -	list = nft_chain_list_get(h, table, chain);
> -	if (list)
> -		nftnl_chain_list_add(c, list);
> +	obj->skip = !created;
>  
>  	/* the core expects 1 for success and 0 for error */
>  	return 1;
> @@ -2649,11 +2649,6 @@ static void nft_refresh_transaction(struct nft_handle *h)
>  	h->error.lineno = 0;
>  
>  	list_for_each_entry_safe(n, tmp, &h->obj_list, head) {
> -		if (n->implicit) {
> -			batch_obj_del(h, n);
> -			continue;
> -		}
> -
>  		switch (n->type) {
>  		case NFT_COMPAT_TABLE_FLUSH:
>  			tablename = nftnl_table_get_str(n->table, NFTNL_TABLE_NAME);
> @@ -2679,14 +2674,22 @@ static void nft_refresh_transaction(struct nft_handle *h)
>  
>  			c = nft_chain_find(h, tablename, chainname);
>  			if (c) {
> -				/* -restore -n flushes existing rules from redefined user-chain */
> -				__nft_rule_flush(h, tablename,
> -						 chainname, false, true);
>  				n->skip = 1;
>  			} else if (!c) {
>  				n->skip = 0;
>  			}
>  			break;
> +		case NFT_COMPAT_RULE_FLUSH:
> +			tablename = nftnl_rule_get_str(n->rule, NFTNL_RULE_TABLE);
> +			if (!tablename)
> +				continue;
> +
> +			chainname = nftnl_rule_get_str(n->rule, NFTNL_RULE_CHAIN);
> +			if (!chainname)
> +				continue;
> +
> +			n->skip = !nft_chain_find(h, tablename, chainname);

So n->skip equals true if the chain does not exists in the cache, so
this flush does not fail (after this chain is gone because someone
else have remove it).

Patch LGTM, thanks Phil.

What I don't clearly see yet is what scenario is triggering the bug in
the existing code, if you don't mind to explain.
