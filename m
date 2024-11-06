Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73159204942
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Nov 2024 16:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730909045; cv=none; b=dvb85MjXJ7OTy9DORppjQ/sZEzEStu62AhrZ/vjqyHtOoxgSathB50N0kQCUzVs4V0iPj3579Qti65zSBXt6JI4tSjMVRwnuSg6sdAed/0wiCOHvST6MubVYClrKgpnPLv/C6eIc5Ep1b7K/S0vglXQTLpR4dI/n11Trh9FrX78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730909045; c=relaxed/simple;
	bh=Ycom8FHE6G2fbZHJzGs5LQ5IQrGdfgSPdKxrwziCKXk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WZP+ILx1MAxNZbi7PY20w1o89xx7jSYJKrSw2NQc4HcMPnWkOnduu3mZjdejLeSQef9NNtE29CxHkGAqtA9BBtrHzq1pLrODd2xKHw/32Xr2kzb+EJhmY8veLwILzYa7RXf7WDPa0aOPydR/xiwyeL/6fnX5jxqi77UAMFZAmK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=60590 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t8iVg-00AG3Y-Ed; Wed, 06 Nov 2024 17:03:58 +0100
Date: Wed, 6 Nov 2024 17:03:55 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: allow to map key to nfqueue number
Message-ID: <ZyuTa9lmkXRAvSfn@calendula>
References: <20241025074729.12412-1-fw@strlen.de>
 <Zytu_YJeGyF-RaxI@calendula>
 <20241106135244.GA11098@breakpoint.cc>
 <20241106143253.GA12653@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241106143253.GA12653@breakpoint.cc>
X-Spam-Score: -1.8 (-)

Hi Florian,

On Wed, Nov 06, 2024 at 03:32:53PM +0100, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > > From userdata path it should be possible to check for this special
> > > internal queue_datatype then encode the queue number type in the TLV.
> > 
> > I have no idea how to do any of this.  I don't even know what a "queue number
> > type" is.
> > 
> > How on earth do i flip the data type on postprocessing without any idea
> > what "2 octets worth of data" is?
> 
> You seem to dislike EXPR_TYPE; I tried to sketch something but i would
> turn EXPR_VALUE into EXPR_TYPE, including EXPR_TYPEOF_NFQUEUE_ID and
> the udata build/parse functions, with the addition of a
> 
>  /* Dummy alias of integer_type for nf_queue id numbers */
>  const struct datatype integer_queue_type = {
> 
> that has no actual function except to override what constant_expr_print()
> ends up doing.

I am fine with your patch, it is perfectly fine to address this in
this way. I just proposed a different way to handle this special case.

I can take a look later today based on your patch, I think I can reuse
90% of it, it is just a subtle detail what I am referring to.
