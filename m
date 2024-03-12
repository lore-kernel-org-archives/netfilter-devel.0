Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A75DF58AD4
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Mar 2024 14:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710253070; cv=none; b=qDhOIhDWtjHvfk56z+1Tk2xufd7eXDjsHrLyVliRKoCVKLlLc2La3ZjlAt6uCxx+NjGY0MEVxQh/9D44YwULlCWOjDHJByQp6+TaFiYojhJOH7Glg702Y/7gwihdAE9p6Xx/f7x2D62u5loYz7cVq5mxov4IjVbk1rSzzcYTUN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710253070; c=relaxed/simple;
	bh=UQOasBgRMVT7is50IlgnGw+GrgOZVakWwQpznXKl9Os=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cl9ZcfBUkyLGxj7Q9jnNVhv11mdfVxIksow+1RTs4cavJJjnJXbf0VUpsc/XQOObvSadB7odJFB1NG8ou4T8cJbgcJashcSUz5sgzb0ElSwe1C8GDyl3EsND8Hnk09GuE/mSmn8VqGhbMLHpOdibHTC4vL31b7PIcdcFv47zJug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Tue, 12 Mar 2024 15:17:43 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Quan Tian <tianquan23@gmail.com>, netfilter-devel@vger.kernel.org,
	kadlec@netfilter.org
Subject: Re: [PATCH v3 nf-next 1/2] netfilter: nf_tables: use struct nlattr *
 to store userdata for nft_table
Message-ID: <ZfBkB3VcbfzZe0fw@calendula>
References: <20240311141454.31537-1-tianquan23@gmail.com>
 <20240312140535.GC1529@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240312140535.GC1529@breakpoint.cc>

On Tue, Mar 12, 2024 at 03:05:35PM +0100, Florian Westphal wrote:
> Quan Tian <tianquan23@gmail.com> wrote:
> >  	u32				nlpid;
> >  	char				*name;
> > -	u16				udlen;
> > -	u8				*udata;
> > +	struct nlattr			*udata;

May I suggest to use our own data structure, instead of using nlattr?
It is just a bit misleading to the reader.

But maybe I need to get used to this and that's all, your call.

Thanks.
