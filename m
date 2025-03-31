Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA9F1E51F1
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Mar 2025 12:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743424641; cv=none; b=Ml36dD+o2pAPIy1qafp3DdfZEQD+A6BEvqnCaTIuKKifhQEQlm6GoNyc79TTPjBRlJ9cVfpzyPJbIzCip+okyDACVS+S90SzEQRGVRT8T2sQclA3YpQ07c+HK0VCxMTPOmKuy9YvNjhkmlIxtdrLL5EgD7e9B/04pb4dddKOZ6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743424641; c=relaxed/simple;
	bh=mhR/fSEG+8klG+WLQh/hPDSwiV0fCU1uUBK+sygrc+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=szuNfQiPwfBo2EPbWNJ+PRAOaUUnSXMl6kH4k8YwfyvxgZFiSE3a2G/Osys4i/GBUCu4TbbjqbzloKuiOrXMW0cKxYxb1BOz3GFTlSVPlUhz/QJvqLXKSRMdOQx1vVywHzy0PoLGArfA6i+pylZq3YynuJRRU/FcQv3SBg9uW0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tzEOB-0003N0-US; Mon, 31 Mar 2025 14:37:15 +0200
Date: Mon, 31 Mar 2025 14:37:15 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] expression: don't try to import empty string
Message-ID: <20250331123715.GA12883@breakpoint.cc>
References: <20250327151720.17204-1-fw@strlen.de>
 <Z-p7BmD6RqC9-IN4@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-p7BmD6RqC9-IN4@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Florian,
> 
> On Thu, Mar 27, 2025 at 04:17:11PM +0100, Florian Westphal wrote:
> > The bogon will trigger the assertion in mpz_import_data:
> > src/expression.c:418: constant_expr_alloc: Assertion `(((len) + (8) - 1) / (8)) > 0' failed.
> 
> I took a quick look searching for {s:s} in src/parser_json.c
> 
> The common idiom is json_parse_err() then a helper parser function to
> validate the string.
> 
> It seems it is missing in this case. Maybe tigthen json parser instead?
> 
> Caller invoking constant_expr_alloc() with data != NULL but no len
> looks broken to me.

        return constant_expr_alloc(int_loc, &string_type, BYTEORDER_HOST_ENDIAN,
                                   strlen(chain) * BITS_PER_BYTE, chain);

chain name is '""'.

There are other spots where we possibly call into constant_expr_alloc()
with a 0 argument.

I think it would be a lot more work and bloat to add all the checks on
the json side while its a one-liner in constant_expr_alloc().

I could also add json_constant_expr_alloc() but it seems kinda silly to me.
