Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECD557303
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2024 08:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705998028; cv=none; b=YlvwWpht/udmYFudbcSjbwXbeI3cJ1JDTQBU7fTPNloGntHZkGrJBKMuqSojUIw3O1h/r6XbCl3ug4GDumbQyQ4PPZDCeI7in3O0HUD+ys2tPqKPvqnZ/6SnDaISDvblbtwylODUzDNGvdK02FIjt/aVdrVA8xBjxlk3O62xzJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705998028; c=relaxed/simple;
	bh=NbZgyJ+IO1y5lhJf7Psu4Zs+/SSjLII0x45p7XO8uJc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qo7NuGLi/me6si1AA/LdhuSeUznHqIyf59DaOwPnx6ZqZzqHzjP61xcYcwi4uJ6P7d8+ou4KRAVGI/8nhWO26Zp3vj104QA8nkP1qzW4bnc1TprPHhK6FlIMIXIWjbll9l8Wy65RbYr8fR7pEd0CE+wT9BQ5tBq21U5H4ecMrw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.41.52] (port=44560 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rSC15-004ag4-WF; Tue, 23 Jan 2024 09:20:21 +0100
Date: Tue, 23 Jan 2024 09:20:19 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Yi Chen <yiche@redhat.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	fw@netfilter.org
Subject: Re: [PATCH] tests: shell: add test to cover ct offload by using nft
 flowtables To cover kernel patch ("netfilter: nf_tables: set transport
 offset from mac header for netdev/egress").
Message-ID: <Za92w7Y22pMdftay@calendula>
References: <20240122162640.6374-1-yiche@redhat.com>
 <Za6vFpJZCHVw1LrV@calendula>
 <20240122212623.GA29630@breakpoint.cc>
 <CAJsUoE34NyBPm=bBOhsvDh80g6L1BzHOm-m2nLNQDWDsMY8V4g@mail.gmail.com>
 <CAJsUoE1bQz0cGXFgvhRU8xJGxTLdsX_fAeFKL9QC5FXT=iQs7g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJsUoE1bQz0cGXFgvhRU8xJGxTLdsX_fAeFKL9QC5FXT=iQs7g@mail.gmail.com>
X-Spam-Score: -1.9 (-)

On Tue, Jan 23, 2024 at 11:26:47AM +0800, Yi Chen wrote:
> > Hi,
> >
> > This test reports:
> >
> > I: [OK]         1/1 testcases/packetpath/flowtables
> >
> > or did you see any issue on your end?
>
> Yes, on the latest rhel-9 kernel 5.14.0-408.el9 which hasn't involved
> this patch:
> a67db600fd38e08 netfilter: nf_tables: set transport offset from mac
> header for netdev/egress
> 
>  it report:
> W: [FAILED]     1/1 testcases/packetpath/flowtables
> 
> This test case existed before and caught this issue.

Great, thanks for submitting this
