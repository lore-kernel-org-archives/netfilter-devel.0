Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873D6158555
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Nov 2024 10:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731321524; cv=none; b=rkDmfBELNo6GE+/CbkgCcoyKaj7Amti93seA0OBxPZGALuTwy3iGPXVfVrtBzlFq51E3A3Or8DXudwti2HA818ar01XXX8+8mYFEYkybCc8hwfNMgtLqJxYsrpMIRuPqXN2OoKKn1e4N7c5SYm7ZnJyg38rwsr3ztXkC/alAy/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731321524; c=relaxed/simple;
	bh=hI7J5zF4MRRRJorEoOvrTdT0CgLpNMzOiuWoYT9nntU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tRkxSVmCzgkVj/DbYAr8VTJ2n0Mi3mziDORPvXP7oK3Y1vl2YP9teR2JMYy2JEHgYfGIlzHcboWA0cbJA0TbHwxB2WK4yZZWkXh9FrxZv7M+2hsETTb5WiPcpItIQnVfiEaaedkbG0yCHEY7DUUyF6TMT5muSH+gEojffXAq+1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=42308 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tARoZ-001bgf-Ut; Mon, 11 Nov 2024 11:38:38 +0100
Date: Mon, 11 Nov 2024 11:38:35 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: allow to map key to nfqueue number
Message-ID: <ZzHeq3qclcVgQZgE@calendula>
References: <20241025074729.12412-1-fw@strlen.de>
 <Zytu_YJeGyF-RaxI@calendula>
 <20241106135244.GA11098@breakpoint.cc>
 <20241106143253.GA12653@breakpoint.cc>
 <ZyuTa9lmkXRAvSfn@calendula>
 <Zyv3tBgF9jW5D0v-@calendula>
 <Zyv9D385olTWUv1k@calendula>
 <20241108120854.GA23569@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241108120854.GA23569@breakpoint.cc>
X-Spam-Score: -1.8 (-)

On Fri, Nov 08, 2024 at 01:08:54PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Thu, Nov 07, 2024 at 12:11:53AM +0100, Pablo Neira Ayuso wrote:
> > > On Wed, Nov 06, 2024 at 05:03:55PM +0100, Pablo Neira Ayuso wrote:
> > > > I can take a look later today based on your patch, I think I can reuse
> > > > 90% of it, it is just a subtle detail what I am referring to.
> > > 
> > > See attachment, not better than your proposal, just a different focus.
> > 
> > Actually, this attachment.
> 
> Just apply this.

Done.
