Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0641DEFD9;
	Thu, 17 Oct 2024 16:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729182251; cv=none; b=QPowVUVDB0TvycNeaX2uwOPJwfqaR2pC5yZq6aS8ZECLgfnbdW7zrt3yelm9xUfo7/0dNLXTitdBaJyZUL0JViIpwmfcus/SxswJEmdiEOBXau2Dp5uFj95xUU4Qlo5LOyfXvUHV1ymr+ODj53kVi5cK3AYwYHoNDRkToGsqsgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729182251; c=relaxed/simple;
	bh=FIJQtuVoNTAvb6Y1oymLg85tDSfnvin/mxeeP3WOMAM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KUWDFSeJdCTWZbt8h5AszISuhIvYAIUBRg350HsY6vKlS0+sgpyQopQMaquRUctouyzCMAlJjwYycC9VchvHeOrTdDo+9E85ID+zNF0kk5WSLREdUPJ8OBiD5Zj4DDU+Ek5CrgpIXFe/usQWvODAunwp7aa4fcluH7tH8kqoFs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=44352 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t1TI8-00FNjo-GJ; Thu, 17 Oct 2024 18:24:02 +0200
Date: Thu, 17 Oct 2024 18:23:59 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, paul@paul-moore.com, rgb@redhat.com,
	audit@vger.kernel.org
Subject: Re: [PATCH nf-next v3 0/5] netfilter: nf_tables: reduce set element
 transaction size
Message-ID: <ZxE6H03jhdp3gONB@calendula>
References: <20241016131917.17193-1-fw@strlen.de>
 <Zw_PY7MXqNDOWE71@calendula>
 <20241016161044.GC6576@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241016161044.GC6576@breakpoint.cc>
X-Spam-Score: -1.9 (-)

Cc'ing audit ML.

On Wed, Oct 16, 2024 at 06:10:44PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > This is bad, but I do not know if we can change things to make
> > > nft_audit NOT do that.  Hence add a new workaround patch that
> > > inflates the length based on the number of set elements in the
> > > container structure.
> > 
> > It actually shows the number of entries that have been updated, right?
> > 
> > Before this series, there was a 1:1 mapping between transaction and
> > objects so it was easier to infer it from the number of transaction
> > objects.
> 
> Yes, but... for element add (but not create), we used to not do anything
> (no-op), so we did not allocate a new transaction and pretend request
> did not exist.

You refer to element updates above, those used to be elided, yes. Now
they are shown. I think that is correct.

> Now we can enter update path, so we do allocate a transaction, hence,
> audit record changes.
>
> What if we add an internal special-case 'flush' op in the future?

You mean, if 'flush' does not get expanded to one delete transaction
for each element. Yes, that would require to look at ->nelems as in
this patch.

> It will break, and the workaround added in this series needs to be
> extended.
> 
> Same for an other change that could elide a transaction request, or,
> add expand something to multiple ones (as flush currently does).
> 
> Its doesn't *break* audit, but it changes the output.

My understanding is that audit is exposing the entries that have been
added/updated/deleted, which is already sparse: Note that nftables
audit works at 'table' granurality.

IIRC, one of the audit maintainers mentioned it should be possible to
add chain and set to the audit logs in the future, such change would
necessarily change the audit logs output.

Thanks.
