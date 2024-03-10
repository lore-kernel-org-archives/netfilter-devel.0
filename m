Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995F51E504
	for <netfilter-devel@vger.kernel.org>; Sun, 10 Mar 2024 13:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710078674; cv=none; b=V47yUt/OkgDsqlIEi3vINxCYBrR2k8ajC/a8HCvS8f44GW5JRZ1kUUqpFyAtfe6/OWL+mU3iyiukWNrH0GRFLZZNXRlrwscWGH4YkaM/B6UXcD9iOXy7JMMkiNJnYO4H3H/ViqN8I9kwTJvfytTkd8ZPcgL9qDgQyP8D100n3oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710078674; c=relaxed/simple;
	bh=2wcRMsE+IG0w4qklRWWpsXJXFvgzP602Um+L/1EEywA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ca6J6HtYpsu37JdW6bs5uo1dSiLMHADW5XQpzbUrDuTKOQu4GVPVWUKfisWBQEXWfJU0OtPbDMnTcK+9qTlj93tua0vhMpsBwgY6dIO+yv389GI52tlPcGex9v2juMMpklzoGlm92kd6Liuz1Z3HZB0RDFaAbfk8bXPzRDpnrOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rjJZv-0003ef-PV; Sun, 10 Mar 2024 14:51:03 +0100
Date: Sun, 10 Mar 2024 14:51:03 +0100
From: Florian Westphal <fw@strlen.de>
To: Quan Tian <tianquan23@gmail.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	kadlec@netfilter.org, fw@strlen.de
Subject: Re: [PATCH nf-next] netfilter: nf_tables: support updating userdata
 for nft_table
Message-ID: <20240310135103.GB28153@breakpoint.cc>
References: <20240310130810.54904-1-tianquan23@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240310130810.54904-1-tianquan23@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Quan Tian <tianquan23@gmail.com> wrote:
> -				if (!(trans->ctx.table->flags & __NFT_TABLE_F_UPDATE)) {
> -					nft_trans_destroy(trans);
> -					break;
> +				if (trans->ctx.table->flags & __NFT_TABLE_F_UPDATE) {
> +					if (trans->ctx.table->flags & NFT_TABLE_F_DORMANT)
> +						nf_tables_table_disable(net, trans->ctx.table);
> +					trans->ctx.table->flags &= ~__NFT_TABLE_F_UPDATE;
>  				}
> -				if (trans->ctx.table->flags & NFT_TABLE_F_DORMANT)
> -					nf_tables_table_disable(net, trans->ctx.table);
> -
> -				trans->ctx.table->flags &= ~__NFT_TABLE_F_UPDATE;
> +				kfree(trans->ctx.table->udata);

This kfree() needs to happen in nft_commit_release().

Otherwise netlink dumps (which run without a lock) results in
use-after-free.

Second issue is that ->udata and ->udlen would have to be
updated atomically so that async dump doesn't observe old/new
pointer with a larger udlen.

I suggest a preparation patch that replaces

   u16  udlen;
   u8   *udata;

in struct nft_table with

	struct nlattr *udata;

so its enough to swap() ctx.table->udata with nft_trans_table_udata(),
then kfree() the old udata from nft_commit_release().

At _release time we can be sure no other cpu is referencing the old
udata.
