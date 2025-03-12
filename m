Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24561E5729
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 14:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741789001; cv=none; b=PCfaOziQEDQHhW4ey+XEeVGncG+fF9hBJpCPn2H6XI4PNMLzFER27zssC24F/i7fp5McZTWoP6hmcV2RbrMkziTNeY7q2h1pDg1bk1KRbb8E/ukWlg1O0Rytk9Z3XOmfaYs41SUoUNtgTtqUV3cI5Kmf5g8k1apbDWiDcXpy/Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741789001; c=relaxed/simple;
	bh=Ev1+kCOkJ73XScOpSdoxAjP/LvjFftIGRv0ZS7xwv3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bebJSVetf7ayuke7+f1VpJl5SkVaRSizV7GO28VsSgM2hYCyBf9gC5Uws8yo0iaH1XmAPJ30x/VMbXFVMxAxqZybt8BiJbEFtzTaCwwOGkJHiblBNnz3tte4FoI1E4b5LOd/Z9ZwhTyJL0SbuLdxv9caT/ZKMf7/Wca3/HDxvDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tsMsp-0006oR-1p; Wed, 12 Mar 2025 15:16:31 +0100
Date: Wed, 12 Mar 2025 15:16:31 +0100
From: Florian Westphal <fw@strlen.de>
To: Alexey Kashavkin <akashavkin@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nft_exthdr: fix offset with ipv4_find_option()
Message-ID: <20250312141631.GA17121@breakpoint.cc>
References: <20250301211436.2207-1-akashavkin@gmail.com>
 <20250312091540.GA15366@breakpoint.cc>
 <297363AA-9DF3-47C6-9DA8-BC60E7BC8CA8@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <297363AA-9DF3-47C6-9DA8-BC60E7BC8CA8@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Alexey Kashavkin <akashavkin@gmail.com> wrote:
> > This is wrong, the array should be aligned to fit struct
> > requirements, so u32 is needed, or __aligned annotation is needed
> > for optbuf.
> 
> This is the old common case of initialising the variable structure ip_options, as in ip_sockglue.c or cipso_ipv4.c. But I don't understand how best to do it, because if we change the optbuf type to u32, it might be redundant if we don't change the array size, and therefore I have no idea what boundary to align it on.

Then lets leave it as-is.

> > Can you make a second patch that places optbuf in the
> > stack frame of the calling function instead?
> 
> Into the ipv4_find_option() function?

Never mind, its fine, nft_exthdr_ipv4_eval refetches data from skb data.

