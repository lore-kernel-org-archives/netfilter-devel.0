Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4509D4C9E0B
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Sep 2026 09:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790672849; cv=none; b=PMfF+yvKOXFdgaQR05F/ZSFInwt9lJq/8LIhfMlcbG4tgByiQdOnDwmDGxnI1iyLxvRL6jPfoVxc5v706V+/CqmpEv2ZIXzzFphPRjmJ6hRFxDMLziwxyTAphkvx2OK94d1UuCaGLkSLOQ0YEVYMuZpAfHJn35It10XnLTzpkd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790672849; c=relaxed/simple;
	bh=LSXXC63uvwPL1FU418+vs6BCAdrkvN4Z+SsQe3HxWlE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aiyh6HnjKgF/zvlVTO7+boXHod0XSqwg74IzY8Af9c8Rxme1iMhqJ9zvZVzaLEX0hEGRy4B5WEx60F3STEuxXODCF1TPW2I1xAV4V5Q0AUhMspEytmglZ/idyBlg/LamxAcE8oaMG49YSiMxaFE8P3mXEt3ERRJ3jGlLD2OsaAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=nqMDG1AQ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="nqMDG1AQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790672828;
	bh=clSaHs0Fyld5ZAZhCUrZyLaoHiSTmiuhC40Fqb4hE5M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nqMDG1AQdnd39BRHjUEqb8PycoDKS5+v1cXHQ2JqrRO8kxgzn1QaJQnHGxIsqEDVF
	 2dcwZyhMDTjFSIzoQEMuqqhp0QjOFUX3rC4p95b3V2cR4Iv6OPLRT3V1Lx8EYEfjJK
	 1d31qYMV7gGVEugEKqoIHJIfXW3utRPgTZQh4PXdu6Ctgp/buOvUKv8YMw+0kb3HVn
	 Sd6X7udmUx3oLyMdt6W53/ICC5bYjAdhh0k7Hn2REm+ezLBO0YhWwJD+qY9Y6Knyfz
	 hN8kiNNFWVFAEeVFlYYf1aiV6TwlfAaXTNw4IdwlDa2LP4lZohLcl+CUdd2AZqCmkq
	 V5B8R7kIHhifg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 2A1BE6005B;
	Tue, 29 Sep 2026 11:07:08 +0200 (CEST)
Date: Tue, 29 Sep 2026 11:07:04 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: =?utf-8?B?7ISx67OR7LCs?= <tjdqudcks0424@naver.com>,
	netfilter-devel@vger.kernel.org, phil@nwl.cc
Subject: Re: [BUG] netfilter: IPv6 conntrack fragment reassembly truncates
 header offset
Message-ID: <art_uBuhM9QUosnZ@chamomile>
References: <622191c6a9b35335b65fdb07f8914b7@cweb016.nm>
 <artmviCh2h4vYLKG@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <artmviCh2h4vYLKG@strlen.de>

On Tue, Sep 29, 2026 at 09:20:30AM +0200, Florian Westphal wrote:
> 성병찬 <tjdqudcks0424@naver.com> wrote:
> > I found a reproducible IPv6 conntrack fragment reassembly bug in:
> > 
> >   net/ipv6/netfilter/nf_conntrack_reasm.c
> > 
> > Tested kernel:
> > 
> >   Linux v7.2.8
> >   commit 9a66fdc0d7fd55f54235524a73435af99051e46f
> >   x86_64 with KASAN enabled
> >
> > In find_prev_fhdr(), the previous Next Header offset is stored in u8:
> > 
> >   u8 prev_nhoff = netoff + offsetof(struct ipv6hdr, nexthdr);
> 
> Please send a formal patch, thanks.

For the record, there is one already.

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260822214012.1028305-2-Jeremy.Jean@oss.cyber.gouv.fr/

But I stumbled on it because lacking a reproducer, sorry.

We can include it in the next batch.
