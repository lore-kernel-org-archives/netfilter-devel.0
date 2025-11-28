Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8D8275AE3
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Nov 2025 15:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764342799; cv=none; b=oYCKpdoupvgyVx6jHak/a/W55Y8ra+ocfrdETyv3KMqTYRx3gmAZNQvfb4NckQut7+jS/z6UNi+ufZM6e6LZH2RjnTnd9qVF7jzvsx6eG4eaGFOHIZW0YakFS4vnHQnHDxUmiODHt4EENWeTLEt30/SY5PspdhyxSHrxwn/blac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764342799; c=relaxed/simple;
	bh=jo8dJ03UJWdnM3Vg/+7jnw8vp023s+6QUJ0d9DY+YdI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e1jdDUAExOQM1jsDce7+H5RITNzP+ZE0kjJo6smQdSPnaioHQdGu4toBSCxQEAh/gY9v3JpNoVYk6Vz1JROWo9vRsh4fBeXClBauLujCSvMppAi0H+P94rhB1ORxULIQaf3yipbzTxppHrxrOwjLwXcIC7r6IIofvIKQlyxmmFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=RJpmofhx; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="RJpmofhx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=IKAfrCGDwH3KuOuDJwobhwJznnCygqGeRG/LCD1Nqzc=; b=RJpmofhxHxxJ+YO3CXAiPSIYrZ
	UZO/597Mz3kkKE6yHPTSWQfGJUiKl9WFCvc6tgu42KrpGa3csQ5g+kASZn7k5UX9XRj+81L8PHsHn
	05lmnnIbhv/H4af/zcH3e4UMA3P1gsYccbc365LO+w5KXisqPDgpN3045IxZ9Mvx/+R3ECg45P7Q1
	9YbQRMZuXOWioXc/AhRZLEElT8XdHyN8Z0fK3fsQ6/6OSkAVYJJwnim8fdLta0jQ0JuA3c1uYw16w
	Z75Zb/V6ONRNuFgazuQ8ZyVxrnQwxOzKBYWBOUhXxmnCDwg1Mv7MF9VTultndUX/QHqhwdy9uENXm
	z1TTOL5A==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vP09p-000000000bx-3j2V;
	Fri, 28 Nov 2025 16:13:13 +0100
Date: Fri, 28 Nov 2025 16:13:13 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH RFC 1/6] parser_bison: Introduce tokens for monitor
 events
Message-ID: <aSm8CQmW4Ji21P8u@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20251126151346.1132-1-phil@nwl.cc>
 <20251126151346.1132-2-phil@nwl.cc>
 <aSm3D2ixdyD8yT_1@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSm3D2ixdyD8yT_1@strlen.de>

On Fri, Nov 28, 2025 at 03:51:59PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > There already is a start condition for "monitor" keyword and also a
> > DESTROY token. So just add the missing one and get rid of the
> > intermediate string buffer.
> > 
> > Keep checking the struct monitor::event value in eval phase just to be
> > on the safe side.
> 
> Looks good, just minor nits below:
> 
> > diff --git a/include/rule.h b/include/rule.h
> > index e8b3c0376e367..4c647f732caf2 100644
> > --- a/include/rule.h
> > +++ b/include/rule.h
> > @@ -739,15 +739,22 @@ enum {
> >  	CMD_MONITOR_OBJ_MAX
> >  };
> >  
> > +enum {
> > +	CMD_MONITOR_EVENT_ANY,
> > +	CMD_MONITOR_EVENT_NEW,
> > +	CMD_MONITOR_EVENT_DEL,
> > +	CMD_MONITOR_EVENT_MAX
> > +};
> > +
> >  struct monitor {
> >  	struct location	location;
> >  	uint32_t	format;
> >  	uint32_t	flags;
> >  	uint32_t	type;
> > -	const char	*event;
> > +	uint32_t	event;
> 
> any reason for using u32_t rather than an enum?

Nope, good point.

> > -struct monitor *monitor_alloc(uint32_t format, uint32_t type, const char *event);
> > +struct monitor *monitor_alloc(uint32_t format, uint32_t type, uint32_t event);
> 
> If we can get rid of internal parsing I would prefer
> 	... , enum monitor_event_type event); or similar.

I'll then also remove CMD_MONITOR_EVENT_MAX from the enum so only
allowed values are valid indexes to monitor_flags array. This eliminates
the boundary check from cmd_evaluate_monitor().

Thanks, Phil
