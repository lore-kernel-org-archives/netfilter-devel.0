Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8ECD22318
	for <netfilter-devel@vger.kernel.org>; Sun, 10 Mar 2024 17:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710092879; cv=none; b=nR1CcaIL7dFCMpSmKTtvvkdFMTv6YfrKGToJa1kExJHGWf/uswxFZsTMLWBU+SvNwHcwtUW7qvdW+Er8kPXyHOEOw1RxlmHXaFaAZHmxTSfC3tPPXau6F4mk8WfPQP/h8bL59b6QRYEO4JqS5jYjHPGW8Y5N5h2t2iYrra+FNqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710092879; c=relaxed/simple;
	bh=t4lbLBytsSwInUVIsIkjwOUHl1w0Oml94U4I3Jfp1L8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mZdlYARI/ONrTycuowQyOpw61wJFNAqmpTxlcRZCJbBidUlmvIwng4YVMCq+pgh6TmZCY0bHPNe+8vBYRs7jFcItGqYwSKMLtypm93Q3SkGNEaP6pc4clMk85V82HFwmkbbe4cjMU5Ui/gjGfvJpCKDUOzJxdrxyY4W7nx5Spjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rjNH8-0004RQ-Od; Sun, 10 Mar 2024 18:47:54 +0100
Date: Sun, 10 Mar 2024 18:47:54 +0100
From: Florian Westphal <fw@strlen.de>
To: Quan Tian <tianquan23@gmail.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	kadlec@netfilter.org, fw@strlen.de
Subject: Re: [PATCH v2 nf-next 2/2] netfilter: nf_tables: support updating
 userdata for nft_table
Message-ID: <20240310174754.GA16724@breakpoint.cc>
References: <20240310172825.10582-1-tianquan23@gmail.com>
 <20240310172825.10582-2-tianquan23@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240310172825.10582-2-tianquan23@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Quan Tian <tianquan23@gmail.com> wrote:
> @@ -10129,14 +10154,12 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
>  		switch (trans->msg_type) {
>  		case NFT_MSG_NEWTABLE:
>  			if (nft_trans_table_update(trans)) {
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
> +				swap(trans->ctx.table->udata, nft_trans_table_udata(trans));
>  			} else {
>  				nft_clear(net, trans->ctx.table);
>  			}

There is a call to nft_trans_destroy() below here.
You could add a "break" after the swap() to avoid it.

Otherwise kmemleak should report old udata being lost
on update.
