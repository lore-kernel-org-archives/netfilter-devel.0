Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DA7EAC7
	for <netfilter-devel@vger.kernel.org>; Fri,  9 May 2025 13:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746797821; cv=none; b=mFcRtHUFMcuySQfw2t6RMC/FymNfl/1v9zgchE1rw52D/XxKaizAJ+SzfZduPFA25Cdne8vahVX+QxNBNKTNJ6O1HWxKo/Xq5WDTvtwkMhKh93PnZ2j49f7ZcvyOMjDGSJcjPEA2zjP1S73o1/JpLl1iTbtxNCF2vOacxBVja/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746797821; c=relaxed/simple;
	bh=VFT32Nl64HxUS73uwvt4MplyLWV0/4QhokZfRc29eMI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P6M7FOLuHbcKevlCpk+3HSXJ3Cl/cHQIyjnIOCyyRqIpsy9KMpwtB/SYHQDKhysE6QTpnjsVKUH2P9W6mSpzXzT3fzA1MoN30pp1FeLxKihKmLif9b3Vl6EsUpJcuI4SoX4YWB+OHi7GTg0zeUSYsemOLaUmQU+2huxF3tRPN8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1uDNuK-0004Pq-0c; Fri, 09 May 2025 15:36:56 +0200
Date: Fri, 9 May 2025 15:36:56 +0200
From: Florian Westphal <fw@strlen.de>
To: Shaun Brady <brady.1345@gmail.com>
Cc: netfilter-devel@vger.kernel.org, ppwaskie@kernel.org, fw@strlen.de
Subject: Re: [PATCH v2] netfilter: nf_tables: Implement jump limit for
 nft_table_validate
Message-ID: <20250509133656.GA16703@breakpoint.cc>
References: <20250506024900.1568391-1-brady.1345@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250506024900.1568391-1-brady.1345@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Shaun Brady <brady.1345@gmail.com> wrote:
> +	if (!net_eq(net, &init_net)) {
> +		list_for_each_entry(sibling_table, &nft_net->tables, list) {
> +			if (sibling_table == table) /* ourselves */
> +				continue;
> +			if (sibling_table->family == table->family ||
> +			    sibling_table->family == NFPROTO_NETDEV){

You will also need to handle the NFPROTO_INET pseudo-family, those
register hooks for both NFPROTO_IPV4 and NFPROTO_IPV6 internally.

Perhaps a selftest script would also be good to have.
(tools/testing/selftests/net/netfilter/).

>  static int __net_init nf_tables_init_net(struct net *net)
>  {
>  	struct nftables_pernet *nft_net = nft_pernet(net);
> @@ -12003,6 +12109,10 @@ static int __init nf_tables_module_init(void)
>  	if (err < 0)
>  		return err;
>  
> +	err = register_pernet_subsys(&nf_limit_control_net_ops);
> +	if (err < 0)
> +		return err;
> +

Why does this need a new pernet subsys? Can't you hook into &nf_tables_net_ops ?

Other than this I think the patch looks good.
