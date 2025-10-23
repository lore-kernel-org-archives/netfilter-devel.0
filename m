Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0FA30E82E
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 13:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761227472; cv=none; b=pfwyMZuWUJL2DuZgA0Blowa2NSpiYNqP51AZTezNP9tFH9pMCLYm7CJPf0top37utXSWet+lT7Mgo9DlAwynFOYknawDdGZ8iwlgChy4ln1H5ksBXv563TEA9oSymQQx9d0gyX75j4evNokc2KHUlHSFsbPkQMdKdULE6/76YCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761227472; c=relaxed/simple;
	bh=Khv+TxIPkmpnrg5zOYIEwq+R5T6cJNNqssPxlT4UfmE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iGC+Ibn7+FDZ+7u+Llla2S7zy70m97RDyNfj5bHXXdPB3MdxlhrTrk3IDbFEdaDti5SBitcpwwTu/2DGW+5z6iKuOz43he8R6OscLXcQNhC3uWip/KEr17rXwOBZ6ZkEic/KriRGgtM0Ikdm4Ht5LFvnoKDN7nS//vk5gMJamFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 945396046B; Thu, 23 Oct 2025 15:51:08 +0200 (CEST)
Date: Thu, 23 Oct 2025 15:51:08 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fmancera@suse.de
Subject: Re: [PATCH nf] netfilter: nf_tables: limit maximum number of
 jumps/gotos per netns
Message-ID: <aPoyzCLGA6XFJ1wU@strlen.de>
References: <20251021234039.2505-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021234039.2505-1-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> +		tbl = kmemdup(tbl, sizeof(nf_tables_sysctl_table), GFP_KERNEL);
> +		if (!tbl)
> +			return -ENOMEM;

[..]

> +static void nf_tables_sysctl_exit(struct net *net)
> +{
> +	struct nftables_pernet *nft_net = nft_pernet(net);
> +
> +	unregister_net_sysctl_table(nft_net->nf_tables_dir_header);

I think this is missing something like:

	const struct ctl_table *table = ft_net->nf_tables_dir_header->ctl_table_arg;

	unregister_net_sysctl_table(nft_net->nf_tables_dir_header);
	if (!net_eq(net, &init_net))
		kfree(table);
}

netfilter_log_sysctl_exit() et. al do this, so I don't think
unregister_net_sysctl_table() takes care of the arg.
