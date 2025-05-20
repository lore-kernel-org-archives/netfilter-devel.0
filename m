Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A61256C71
	for <netfilter-devel@vger.kernel.org>; Tue, 20 May 2025 10:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747737297; cv=none; b=Md9xL6prqIrirAQgaT/i7xNXuyCFI7zOdCFk7kEzCzZSBf9wKuO75dR0tnFRcbiAtQFFB9NFN3nAISOIyx6C+6+BgiwoJmF+exjxJawCPuTCNuSW4eVz/ZtePFjCYIQEuNyvP5N0SMdEjg/E+d/vOXyiG4at7cPK5SUHyN5kT2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747737297; c=relaxed/simple;
	bh=Ftv0zJTWuJRMJt9dafNexdbAcn2SeOEdU2UMG1IoG08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jUeOla7Y46ubS7L9DwcesVOMxE7QFjSWhVuOPZY8z4O3/wazPkyJ2yl5rtjW4K0z6FbvjGxmpNRRw147eAnwpebTHd7i3x/eOIAQNsUPuL7tmC08+UAzzYo5m3pAXQHX8I4zkomSob0C7RzN6wEcyvBPn4jPl1/5FJbWfQJ3U7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B039E60164; Tue, 20 May 2025 12:34:53 +0200 (CEST)
Date: Tue, 20 May 2025 12:34:00 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next,v2 2/2] netfilter: nf_tables: honor validation
 state in preparation phase
Message-ID: <aCxamGnvNai00dwU@strlen.de>
References: <20250520092029.190588-1-pablo@netfilter.org>
 <20250520092029.190588-2-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250520092029.190588-2-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>  static int nft_table_validate(struct net *net, const struct nft_table *table)
> @@ -4044,6 +4060,7 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
>  	struct nft_chain *chain;
>  	struct nft_ctx ctx = {
>  		.net	= net,
> +		.table	= (struct nft_table *)table,

Patch LGTM but I think it would make more sense to remove the const
qualifier from nft_table_validate() rather than this un-do.

Aside from that:
Reviewed-by: Florian Westphal <fw@strlen.de>

