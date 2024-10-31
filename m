Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BE719923A
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2024 23:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730417313; cv=none; b=lghFaTBZine2hOKgL9Kc7mbKHizhMf0hgUMfXiONYaoSDxiBCuHHge2hucPNxwqEV3THwo2n3OueNIjG+bSQXmq0OP7hmtEsU3LLHeFpi5ab/ccyw7sDYFJ+oWgSHnrN8wR9nf7sBwJkFytemfxY4UPbqgtMxYXwf7kAHjFauCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730417313; c=relaxed/simple;
	bh=wqMI1PqMFkD+RF4Qe9djmMlWlzNgbu1vf5M80aG7Ihk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JtpSKOGXGjJjQH6AKWIGn+Y519dIpkTOBjL33I8b1Sygmce3oFGHwwFt3/iUHRZE/HLlbtzh0dE9zp415lvfJ3q6YNAxVp90ZP34AejWa4y4ztOYGIe+Ax3LFxKqKAYjo4Ww7LCi/XPWQ6aZrY3B1H8EYSCACUI5iz1tZ0DSORc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=34216 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t6eaQ-00HMhs-Pv; Fri, 01 Nov 2024 00:28:24 +0100
Date: Fri, 1 Nov 2024 00:28:18 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 nf-next 0/7] netfilter: nf_tables: avoid
 PROVE_RCU_LIST splats
Message-ID: <ZyQSklHw0ncffCXz@calendula>
References: <20241030094053.13118-1-fw@strlen.de>
 <ZyP7Q94DCbwBmobU@calendula>
 <20241031215645.GB4460@breakpoint.cc>
 <ZyQHv5lxlCrciEiq@calendula>
 <20241031230214.GA6345@breakpoint.cc>
 <20241031232201.GB6345@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241031232201.GB6345@breakpoint.cc>
X-Spam-Score: -1.8 (-)

On Fri, Nov 01, 2024 at 12:22:01AM +0100, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > # nft -f test.nft
> > > test.nft:3:32-45: Error: Could not process rule: Operation not supported
> > >                 udp dport 4789 vxlan ip saddr 1.2.3.4
> > >                                ^^^^^^^^^^^^^^
> > > 
> > > Reverting "netfilter: nf_tables: must hold rcu read lock while iterating expression type list"
> > > makes it work for me again.
> > > 
> > > Are you compiling nf_tables built-in there? I make as a module, the
> > > type->owner is THIS_MODULE which refers to nf_tables.ko?
> > 
> > Indeed, this doesn't work.
> > 
> > But I cannot remove this test, this code looks broken to me in case
> > inner type is its own module.
> > 
> > No idea yet how to fix this.
> 
> Can you apply the series with out patch 6?
> Someone else should look at it, i can't find a
> good solution, this would need a rewrite to obtain
> a reference on the type AFAICS.
> 
> I could cmp for nft_payload_type/nft_meta_type instead
> but I feel its cheating and fragile too.

And these expression are the only ones providing ->inner_ops at this
stage. I understand your concern if future extensibility could bring
bugs, but we can place a comment here to remember by now.
