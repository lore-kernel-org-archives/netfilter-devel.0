Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18DE459AE6;
	Fri, 11 Sep 2026 12:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789131266; cv=none; b=dlWyRGLCOG6S8vFIMMiQeaKqjV1aNVysKWls3xGqAxOQUL+aIg+St014G0jt+11c6LeISbgonag7y6FKlaR4b8uV+qwNrItGa8s/CJDGI9iu+51IqYKnG6QLnc1vviZZDfl6wy7NcuHK4/oZ+zY2mfBXv7F8TkmmllMDNgNAMH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789131266; c=relaxed/simple;
	bh=eESVCLfr3S6k1TSVTrA18zShIFXxmxR35s/Fyu3zB30=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SNled/gZQytOWxZEfcmekvu96fKG2wNi7gKn5o92UHm4t2+G6gTwI2rHgxVqihM9pqcja3fXKWRabNYq/5rKrde5yIHBd/newOebGpancJMqFYxCEJzwXSHYNGK22jHAUK0zXyJ14qTVG+g/BuZ2w17m95k8tJ4Ul1sLdC6JM24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 867FA60388; Fri, 11 Sep 2026 14:54:15 +0200 (CEST)
Date: Fri, 11 Sep 2026 14:54:15 +0200
From: Florian Westphal <fw@strlen.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH nf-next v4 01/13] rhashtable: add
 rhashtable_flush_and_free helper
Message-ID: <aqP596VqdU8Ka4-A@strlen.de>
References: <20260904185321.30313-2-fw@strlen.de>
 <aqDdwKMbvd9aErLy@gondor.apana.org.au>
 <aqFw-_Y4JGRF-0Za@strlen.de>
 <aqJ0QDwEIZg5sDql@gondor.apana.org.au>
 <aqKJUOQYHEGWKgCn@strlen.de>
 <aqPsedZD85-zXob3@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqPsedZD85-zXob3@gondor.apana.org.au>

Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > That will, at least afaics, defeat rhashtables purpose, I'd have to
> > either serialize by external single lock, or add a flag that would
> > 'eat' new insertions while the flush is running.
> 
> If there is no natural way of expressing it in the caller, then
> we might as well add the complexity to rhashtable.  Let me look
> into this.

Thanks Herbert.
