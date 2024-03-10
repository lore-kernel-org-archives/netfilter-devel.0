Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D25F3A1CD
	for <netfilter-devel@vger.kernel.org>; Sun, 10 Mar 2024 23:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710112168; cv=none; b=PrY37CXeKAjig2yGKJkEUjIrYXhm85BHvjrkUDewgQA1nox4gUqVwZsQm+Qrpxvjnvl2xzRzjj+0DQWxVgy594ZFK8gZrVO5ABqb5w4dNTS++rXY0QW3zo3V/JZiWSW+PvwVXeY4ckm6EZVknB4itL8nUHjeSavYubyYkAKfK+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710112168; c=relaxed/simple;
	bh=wvJ8HOobDAN1fpYVoiAMyGnHWloWwSKoKoSafVt7+88=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X2+XgEzKegn/l5VaDJ+hf7TNAhAdSzMI12L8YbW2LRWDpzIFymscz0OR/g+F/2Y9yDYQnCoPRpZMbBWsP8UYarfEMsQEwlzLNtGnfxNUsyBZJ8/8pg33J+bzTc7VsrgHFoFNK7WZiNDg+9dePogdszqaUOwly+j2HpIBsIQEy4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rjSIF-0005ZZ-BW; Mon, 11 Mar 2024 00:09:23 +0100
Date: Mon, 11 Mar 2024 00:09:23 +0100
From: Florian Westphal <fw@strlen.de>
To: Quan Tian <tianquan23@gmail.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	kadlec@netfilter.org, fw@strlen.de
Subject: Re: [PATCH v2 nf-next 1/2] netfilter: nf_tables: use struct nlattr *
 to store userdata for nft_table
Message-ID: <20240310230923.GA20853@breakpoint.cc>
References: <20240310172825.10582-1-tianquan23@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240310172825.10582-1-tianquan23@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Quan Tian <tianquan23@gmail.com> wrote:
> To prepare for the support for table comment updates, the patch changes
> to store userdata in struct nlattr *, which can be updated atomically on
> updates.
> 
> Signed-off-by: Quan Tian <tianquan23@gmail.com>
> ---
> v2: Change to store userdata in struct nlattr * to ensure atomical update

Looks good, one minor nit below.

>  	if (nla[NFTA_TABLE_USERDATA]) {
> -		table->udata = nla_memdup(nla[NFTA_TABLE_USERDATA], GFP_KERNEL_ACCOUNT);
> +		table->udata = kmemdup(nla[NFTA_TABLE_USERDATA],
> +				       nla_total_size(nla_len(nla[NFTA_TABLE_USERDATA])),
> +				       GFP_KERNEL_ACCOUNT);

I think its correct but it might make sense to add a small helper for
this kmemdup so we don't need to copypaste in case this should get
extended to e.g. chain udata update support.
