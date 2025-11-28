Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D36235358
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Nov 2025 18:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764353243; cv=none; b=KCPM7/cIjnpHwIV8WuQV4KgiQhGSyuPbcZyP8zR+PWA43g+STqF3tl+gHBRyTc49eaXyidQu8KAhDKdxzNnQahw05eJNW35A+N94sQWEQW9JSfKG35ZD3r3A1XwVz8/CmQnfAVlaSGFb+kgtCnTec6RNFCNlzLCCRwQh/YpDRHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764353243; c=relaxed/simple;
	bh=fv6c54Nhf/JOAzkGYs2fDv2YBFPfCViBjYbBVRH/f/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B7VqBPDEkArSuwWYGz84yGYQa7iPDDBeq+p8iYGfrJGLLAtd0ZfncPB6n73Siz5M7+5qw5ZQpY9l80iafvEOTtEOFBCdyXxjpiTNbZS5nccXHg9xvxzo+4I45NVrK5jss6dZVe7nj0SEeXkDm+OMvSYVcVh1J9DtD0cAaaLcVUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=qsno1ecF; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="qsno1ecF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=CPxlVlgH6pCdunCd2q8V4TIKjPN+XlgTDfLBm0HKIZk=; b=qsno1ecFo1vK0swmiSBW2cJj+b
	hY0Kj605Fw74oxTH+p9S+BI3Dea+RN5ibRePnAFivhwr1vpBzZxqfv1t4S4jn1YBCP0xwynqsWQGG
	eVm855iSGEG6aV8NGm2n62NgeGI9AAOSpLCEhnOgpe/GatfkWN2AiiDVQU2UQLq+lH8N7vR4aifXv
	fq0bAcGgYwdQPQLSctLlVmJgRDXN7qFbFoMyzG4rk55RG6GCoMNBemdgBubpIQf6YRniSQ1NN6B5O
	oWFl/qWTt2AjyWY5zmoLHgrApQnqRgN+phjpyllY7uFlqWxIRoPC+d5l6ZECDMaKfPaHKU4Xg6yuG
	69cex6lQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vP2sH-000000007xp-3uwQ;
	Fri, 28 Nov 2025 19:07:17 +0100
Date: Fri, 28 Nov 2025 19:07:17 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH RFC 6/6] scanner: Introduce SCANSTATE_RATE
Message-ID: <aSnk1YtMPIhkSK9e@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20251126151346.1132-1-phil@nwl.cc>
 <20251126151346.1132-7-phil@nwl.cc>
 <aSnecCkmj1FPGFHk@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSnecCkmj1FPGFHk@strlen.de>

On Fri, Nov 28, 2025 at 06:40:00PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> >  struct limit_rate {
> >  	uint64_t rate, unit;
> >  };
> > diff --git a/include/parser.h b/include/parser.h
> > index 8cfd22e9e6c42..889302baf5950 100644
> > --- a/include/parser.h
> > +++ b/include/parser.h
> > @@ -47,6 +47,7 @@ enum startcond_type {
> >  	PARSER_SC_META,
> >  	PARSER_SC_POLICY,
> >  	PARSER_SC_QUOTA,
> > +	PARSER_SC_RATE,
> 
> Could this new scanstate get added in a different patch?
> 
> > -"hour"			{ return HOUR; }
> > -"day"			{ return DAY; }
> > +<*>"hour"		{ return HOUR; }
> > +<*>"day"		{ return DAY; }
> 
> this might allow to scope this to meta+rate first before adding
> the exclusive start condition change.

Sadly, not. Unless you want to get rid of meta_key_unqualified as well:
Since nft accepts rules like "hour 10 accept", we have to keep "hour"
and "day" in global scope.

Cheers, Phil
