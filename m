Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B19E79B6F
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Mar 2024 12:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710246482; cv=none; b=dKc1IXax8VGWW32ujt4RDl7ziAckzX7xsKOmdFBAZYeiOk0I20ekMAjGF1JCyHSZUo6kUlKNjH1Pj5R1dUxW/2UZyqG9ppKMscabQXGaH2UEtFttNe/7qoSMLo9mPG4/h0XQ+dp5SXjJpkHPMoqeJX6bvQOrFWS9Y3bhI+KCFbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710246482; c=relaxed/simple;
	bh=NcvJZtta1P5mQB6KBsax9fN822gYLUWyqHG3BXkgJ5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BOaOMr50tYC2mQJkrdMjmaZmiwFf7XRvT4ciPtLuWVS5gSZCkNyYCXt0yCYX0yc8nVEiED6A9OEXSetGCT34aCvf65I48lvOlqjcOZHEf9r7W0f5TObJyVV75Qmc51/LG9ndxSq3KUXogLtPOGg47riHf2e2QcXqkYbKuqCQ8eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rk1Ec-0000nl-Ie; Tue, 12 Mar 2024 13:27:58 +0100
Date: Tue, 12 Mar 2024 13:27:58 +0100
From: Florian Westphal <fw@strlen.de>
To: Quan Tian <tianquan23@gmail.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	kadlec@netfilter.org, fw@strlen.de
Subject: Re: [PATCH v3 nf-next 2/2] netfilter: nf_tables: support updating
 userdata for nft_table
Message-ID: <20240312122758.GB2899@breakpoint.cc>
References: <20240311141454.31537-1-tianquan23@gmail.com>
 <20240311141454.31537-2-tianquan23@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240311141454.31537-2-tianquan23@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Quan Tian <tianquan23@gmail.com> wrote:
> The NFTA_TABLE_USERDATA attribute was ignored on updates. The patch adds
> handling for it to support table comment updates.

One generic API question below.  Pablo, please look at this too.

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
> +				nf_tables_table_notify(&trans->ctx, NFT_MSG_NEWTABLE

AFAICS this means that if the table as udata attached, and userspace
makes an update request without a UDATA netlink attribute, we will
delete the existing udata.

Is that right?

My question is, should we instead leave the existing udata as-is and not
support removal, only replace?
