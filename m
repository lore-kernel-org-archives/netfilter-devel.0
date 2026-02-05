Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E73421F05
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 15:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770304908; cv=none; b=oYioN/L/ZZIdxdQqTt42LvuxXr3FazjQSVsMBhpF11XUWI62pgHbGEYtiTSNigB7WFIgr4am9AVXlusj04JgfdI9dj4ezJomHCX2tJMuLvD8HqRUs3EQVTlAWSdnB+5MuzaByOmrlOnE8qzhVIZWUOAkQszoEIea8EINJ+rNpEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770304908; c=relaxed/simple;
	bh=bIBxE3gv4Ql6/9UBqhl0HD4+y4SmL6wGwH0reYUhJLk=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kvxp2XI5QLm9hYbRLBvqZewJrlFjNNNhC2fcO8eTS/lNarHe32XoLpf7qHAEgvWTIPQAFIY0db0rc9qMo9JE9hkbZ5736iaCTKby6DLLCwaEJiRfG8kJdbAnna9J8POuQYo+gO5ni7PDyJIUcGrC3UAPXSOm6JsVlDdhz/hFm+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=TDObD7CC; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="TDObD7CC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NwIiy/JI5ZOKcBBSX/nAX2a7gP0CvPUbTQM+6qWVGDo=; b=TDObD7CCCnDqYF6yMvIWHwZG5J
	YXMrC9oA59VoUkfPvWuJWPMsxGBxXNPWOy98RBPKZX2XhsJ2t4oye+JHxLC1EFSIctInQo79Z8xtG
	OS3q7OrOLq/c4cclIR6aoPWX7R1B1v8Cu34bjeb2pg5MIms+D9hL9zUghf9NuoWvh3qJkTBMdCEHt
	9X/dMzw6zQOX/pv/KvO7l+r7Dclk/Rcdd3mx0X51Pl6vFGX7so7e9EWNINBDUEeh8+nDxkQj+gaAd
	mFYQU13Gzffhq25JDSxv3Fp0bZURRKMejTVq93L3yQiDU3OogjP77npJg/fc2DX+mVe1GUunP8BZO
	WBgXY3RQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vo1Aw-000000003K6-44W4
	for netfilter-devel@vger.kernel.org;
	Thu, 05 Feb 2026 16:21:46 +0100
Date: Thu, 5 Feb 2026 16:21:46 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] doc: nft.8: Describe iface_type data type
Message-ID: <aYS1ikHAFm88-4Q7@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
References: <20260127221252.27440-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127221252.27440-1-phil@nwl.cc>

On Tue, Jan 27, 2026 at 11:12:52PM +0100, Phil Sutter wrote:
> An entry in data-types.txt offers space for a name-value table. Even if
> one would refer to ARPHRD_*, some names are not derived from the
> respective macro name and thus not intuitive.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
