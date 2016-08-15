From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2 v2 libnftnl] test: Use libnftnl comparators in all
 tests
Date: Mon, 15 Aug 2016 14:27:32 +0200
Message-ID: <20160815122732.GA14674@salvia>
References: <fea97d91-a7b1-6287-e368-0615eb8b94b5@riseup.net>
 <20160815122343.29329-1-carlosfg@riseup.net>
 <20160815122343.29329-2-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51028 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785AbcHOM1i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Aug 2016 08:27:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 12B61A4188
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Aug 2016 14:27:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F0742DA7E5
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Aug 2016 14:27:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E56CDDA7FC
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Aug 2016 14:27:33 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160815122343.29329-2-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 15, 2016 at 02:23:43PM +0200, Carlos Falgueras García wrote:
> Use 'nftnl_expr_cmp' and 'nftnl_rule_cmp' in all tests instead of custom
> comparator for each one. If objects differ both are printed.
>
[...] 
> diff --git a/tests/nft-chain-test.c b/tests/nft-chain-test.c
> index b42fb86..1b6672a 100644
> --- a/tests/nft-chain-test.c
> +++ b/tests/nft-chain-test.c
> @@ -19,43 +19,56 @@
>  
>  static void cmp_nftnl_chain(struct nftnl_chain *a, struct nftnl_chain *b)
>  {
> +	bool test_ok = true;
> +	bool ret;
>  
> -	if (strcmp(nftnl_chain_get_str(a, NFTNL_CHAIN_NAME),
> -		   nftnl_chain_get_str(b, NFTNL_CHAIN_NAME)) != 0)
> -		print_err("Chain name mismatches");
> -	if (strcmp(nftnl_chain_get_str(a, NFTNL_CHAIN_TABLE),
> -		   nftnl_chain_get_str(b, NFTNL_CHAIN_TABLE)) != 0)
> -		print_err("Chain table mismatches");
> -	if (nftnl_chain_get_u32(a, NFTNL_CHAIN_FAMILY) !=
> -	    nftnl_chain_get_u32(b, NFTNL_CHAIN_FAMILY))
> -		print_err("Chain family mismatches");
> -	if (nftnl_chain_get_u32(a, NFTNL_CHAIN_POLICY) !=
> -	    nftnl_chain_get_u32(b, NFTNL_CHAIN_POLICY))
> -		print_err("Chain policy mismatches");
> -	if (nftnl_chain_get_u32(a, NFTNL_CHAIN_HOOKNUM) !=
> -	    nftnl_chain_get_u32(b, NFTNL_CHAIN_HOOKNUM))
> -		print_err("Chain hooknum mismatches");
> -	if (nftnl_chain_get_s32(a, NFTNL_CHAIN_PRIO) !=
> -	    nftnl_chain_get_s32(b, NFTNL_CHAIN_PRIO))
> -		print_err("Chain Prio mismatches");
> -	if (nftnl_chain_get_u32(a, NFTNL_CHAIN_USE) !=
> -	    nftnl_chain_get_u32(b, NFTNL_CHAIN_USE))
> -		print_err("Chain use mismatches");
> -	if (nftnl_chain_get_u64(a, NFTNL_CHAIN_PACKETS) !=
> -	    nftnl_chain_get_u64(b, NFTNL_CHAIN_PACKETS))
> -		print_err("Chain packets mismatches");
> -	if (nftnl_chain_get_u64(a, NFTNL_CHAIN_BYTES) !=
> -	    nftnl_chain_get_u64(b, NFTNL_CHAIN_BYTES))
> -		print_err("Chain bytes mismatches");
> -	if (nftnl_chain_get_u64(a, NFTNL_CHAIN_HANDLE) !=
> -	    nftnl_chain_get_u64(b, NFTNL_CHAIN_HANDLE))
> -		print_err("Chain handle mismatches");
> -	if (strcmp(nftnl_chain_get_str(a, NFTNL_CHAIN_TYPE),
> -		   nftnl_chain_get_str(b, NFTNL_CHAIN_TYPE)) != 0)
> -		print_err("Chain type mismatches");
> -	if (strcmp(nftnl_chain_get_str(a, NFTNL_CHAIN_DEV),
> -		   nftnl_chain_get_str(b, NFTNL_CHAIN_DEV)) != 0)
> -		print_err("Chain device mismatches");

You description says your our aiming at expressions and rules, but
this is also modifying chain.

Please, check this chunk out of this patch, same for other objects
that are not expression and rules. This patch is already quite large
so not need to get this more complicated.

Thanks.
