Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5629B56450
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Mar 2024 14:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710252339; cv=none; b=Kn+YYkwZXZ2obsQnxLx0pj/FyIkNgm486XlVIwHrsKbX0i0ZJ7VvwWTzsg3Q/6+Br5vyB89fH7+ApBL2CTiCKpXb5y/LntuLFBNQM5KvFAm5djTQEaFJGhndeVD7vgZt03tpcQlm+12kdOZvu0+dAzhwXZB1mbHFVnS3cuelPFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710252339; c=relaxed/simple;
	bh=pFJ/qVKxEGxHyDa4ud3acqZlLdwAA4/KM11nDV1X9vc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TgBfqdzkturEsEUq2u13eiIWw+vjFCXWwWA0sbE2kz8KGvLZrM5Ad3+q8rc+xia0eobRpR+oHEVm4tPK6NGOcBZ3wXAvPjAmTSPzbXw8Qq74sD64aWjB7LPlT8b+Q8oxp+UiJvzSWEX5VJAS52AU6LpACWZuIkIllmvmMjv1BS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rk2l5-0001CI-HO; Tue, 12 Mar 2024 15:05:35 +0100
Date: Tue, 12 Mar 2024 15:05:35 +0100
From: Florian Westphal <fw@strlen.de>
To: Quan Tian <tianquan23@gmail.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	kadlec@netfilter.org, fw@strlen.de
Subject: Re: [PATCH v3 nf-next 1/2] netfilter: nf_tables: use struct nlattr *
 to store userdata for nft_table
Message-ID: <20240312140535.GC1529@breakpoint.cc>
References: <20240311141454.31537-1-tianquan23@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240311141454.31537-1-tianquan23@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Quan Tian <tianquan23@gmail.com> wrote:
>  	u32				nlpid;
>  	char				*name;
> -	u16				udlen;
> -	u8				*udata;
> +	struct nlattr			*udata;

I missed this detail.  As Pablo pointed out this pointer
now needs a __rcu annotation.

And this needs something like:

struct nlattr *udata = rcu_dereference(table->udata);

if (udata) {
 	if (nla_put(skb, NFTA_TABLE_USERDATA, nla_len(udata), nla_data(udata)))

> +		if (nla_put(skb, NFTA_TABLE_USERDATA, nla_len(table->udata),
> +			    nla_data(table->udata)))

... because this version can observe different table->udata for
nla_len() and nla_data() calls if the swap() has the "right" / "wrong"
timing.
