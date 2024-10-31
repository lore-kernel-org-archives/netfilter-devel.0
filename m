Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760E31BD9DC
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2024 23:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730417162; cv=none; b=d7dCM/rv07R0O+mXg628+mGfPIIpGcGunyBcR4+MdHP7DeLDL1w+tyOod/41E6CgtSvHeDN0McHck+Ro/FvtEsMje4l58Wq99cyDvgB//7churxpiSaVZMkKGek8+s7TzxqhuMGvN7inqULYsLIVcHNwjRUw4pFseDzi08WEzJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730417162; c=relaxed/simple;
	bh=q1k1jkT/4jirAJrH1/2TobiXksyqhLxBBb1kgG2nn4E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rHsKK1kFAPB8uDBVsvjnZAEKUV7Lr2WDu9lnWtCcYZ3/rmBLIvPDYsJ16b1ZlAkbql7bGmex4fnMjK0q+yPZXZT6ao/ndvSQGilmhnwHFEF0dAbDlHLiHIC1bLBWf2m00469b1SLL9iS7LkVi2VaYHuynxfavS6FG1SSrS95UXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=33726 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t6eY0-00HMZA-MP; Fri, 01 Nov 2024 00:25:54 +0100
Date: Fri, 1 Nov 2024 00:25:47 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 nf-next 0/7] netfilter: nf_tables: avoid
 PROVE_RCU_LIST splats
Message-ID: <ZyQR-4X_hw6ZRpRI@calendula>
References: <20241030094053.13118-1-fw@strlen.de>
 <ZyP7Q94DCbwBmobU@calendula>
 <20241031215645.GB4460@breakpoint.cc>
 <ZyQHv5lxlCrciEiq@calendula>
 <20241031230214.GA6345@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241031230214.GA6345@breakpoint.cc>
X-Spam-Score: -1.8 (-)

On Fri, Nov 01, 2024 at 12:02:14AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > # nft -f test.nft
> > test.nft:3:32-45: Error: Could not process rule: Operation not supported
> >                 udp dport 4789 vxlan ip saddr 1.2.3.4
> >                                ^^^^^^^^^^^^^^
> > 
> > Reverting "netfilter: nf_tables: must hold rcu read lock while iterating expression type list"
> > makes it work for me again.
> > 
> > Are you compiling nf_tables built-in there? I make as a module, the
> > type->owner is THIS_MODULE which refers to nf_tables.ko?
> 
> Indeed, this doesn't work.
> 
> But I cannot remove this test, this code looks broken to me in case
> inner type is its own module.
> 
> No idea yet how to fix this.

I'm missing why this check is required by now.

Only meta and payload provide inner_ops and they are always built-in.

I understand this is an issue if more expressions are supported in the
future.
