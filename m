Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D355A175BF
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 16:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728751559; cv=none; b=gknxf+wwDrTbEShI0lwBLllRZzQPpeD273ADGzzN0YFNqYA07qHUByV+Lyf/G1FqVg6PyNzFH8Qp7DO/rShV5v5+I+QuCS5qamSqndUkWpoH4CGscJZ7hT/pHG/YFBULA6p8acWPjlsR8AXuODz3LRWjpGle5h95hu/NoFjHvF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728751559; c=relaxed/simple;
	bh=+D9H652vIzaArU/zGvjQYgMLM8l5y6WzXCVYxhC+Du8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=peiCFq5q/6JEgopWYNaWVX0RGyzLBGKXVwBTGJxCCeDVBd9OTWSrgsDvOQMKp8VbseCsyw3Q2B2eRGMneSv2tjRHf2JUcq8vFHV+lkYPXPZGKsJJyB+9E2IbxVuZJfWUpQCN6QxCBhEG+iz14gYrOJF3UWvJvdy9q3rWDMRrJck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=54772 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1szfFY-001adr-HK; Sat, 12 Oct 2024 18:45:54 +0200
Date: Sat, 12 Oct 2024 18:45:51 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/4] netfilter: use skb_drop_reason in more places
Message-ID: <Zwqnvy78DX0Mi_us@calendula>
References: <20241002155550.15016-1-fw@strlen.de>
 <ZwqDI5JcQi5fMa46@calendula>
 <20241012144216.GA21920@breakpoint.cc>
 <ZwqY8Rm74MO_UMM8@calendula>
 <20241012155448.GB21920@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241012155448.GB21920@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Sat, Oct 12, 2024 at 05:54:48PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Or do you mean using a different macro that always sets EPERM?
> > 
> > Maybe remove SKB_DROP_REASON_NETFILTER_DROP from macro, so line is
> > shorter?
> > 
> >         NF_DROP_REASON(pkt->skb, -EPERM)
> > 
> > And add a new macro for br_netfilter NF_BR_DROP_REASON which does not
> > always sets SKB_DROP_REASON_NETFILTER_DROP? (Pick a better name for
> > this new macro if you like).
> 
> NF_DROP_REASON is already in the tree and currently most users use
> something other than SKB_DROP_REASON_NETFILTER_DROP.
> 
> I did not yet add new enum values or a dedicated nf namespace
> (enum skb_drop_reason_subsys), because I did not see a reason and
> wasn't sure if we'd need sub-subsystems (nf_tables, conntrack, nat,
> whatever).

Does this mean values exposed through tracing infrastructure can
change or these are part of uapi? From what I read from you, I
understand it is possible to change SKB_DROP_REASON_NETFILTER_DROP to
a more specific sub-subsystem tag in the future without issues.

> If you like, I can add NF_FREE_SKB(skb, errno) and rework this
> set to use that?

Not strong about this. I was exploring if it should be possible to
remove (repetitive) information in the code that can be assumed to be
implicit, I still like the word "REASON" in the macro for grepping.

I think we can just move on with this series as-is if you prefer and
add new macros incrementally to refine.
