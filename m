Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7784BAA1A
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2026 14:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788446141; cv=none; b=cuoMO65mW0spcOWGJlJaYjDjzIepScLQjD8FdklEAFgMuAZR7pBV1B43u3Oakl7ur6t61cdakw7h9sf7arFaTNzXRlr2xn9seEZbSzBH6cCQXMfr1IQBorz6GGUMs0TtqjDT5QBHJ/6wx+uvOVuSN2poijL6zfO1dKkgfN9FMqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788446141; c=relaxed/simple;
	bh=CxSmyd+2nxKto+wurmJS11JDiL5H3ayLNg4eUE2w+l8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZboA4aCWS0goi5T8knf2jhjY7rmMy6sscBak/JZysjLWYjcuIEgASHBOZcMNlLw2V0xAhd8JC61m7Iq/5ZC2Hzi77fnNHn0WJNVdTOWfJbKTNxbeR3PTQZsHLREdS9QOfVbilerKat44kUDVPDqN5uhiMaFlYa/SzKcz72u/ml4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=a3+SIsVU; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="a3+SIsVU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=r2qKmBE51w0nWeNufysgrhEM0aH4bHU909IhIaYlOv8=; b=a3+SIsVU7RhItuQWgVyeel9XUN
	K4Tm9NR4ZaN6gHNT1xhx25K/1GxrN5dbGP+B2md/AOGQykHoN/iHxE2jCOnhC4UP/x2YDwSQ+mVrs
	6KjGeZlEXUnb5i06er+n8dZIjAXoayCYimJgI3uBMorHOijcvy6EYtikWbVA0keQ+po0Tdfes3Jdg
	0jB0rPFJICA8jEyT8TbnLGBBEbQyCfURRDw03JkFVBU5j/+4WJsqo+L5ujQMp6X9HrtBaR4rQcEYt
	SpYJnpdvt4polbngmAt/AWnxPFEAp6IYKCgJKMGq0VEOUZYOYGb+dBHeAmRvaBOO69t/8FUJOyolR
	HpP59IrQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1x28XN-000000004S7-257Q;
	Thu, 03 Sep 2026 16:35:33 +0200
Date: Thu, 3 Sep 2026 16:35:33 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [conntrack-tools PATCH v2] conntrack.8: Document --stats counters
Message-ID: <apmFtfsT_UpdsA0b@orbyte.nwl.cc>
References: <20260730091858.1982235-1-phil@nwl.cc>
 <apl-LmT_S_ZhSpAd@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apl-LmT_S_ZhSpAd@strlen.de>

On Thu, Sep 03, 2026 at 04:03:26PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Provide a brief description of each counter's meaning based on
> > code-analysis in kernel's nf_conntrack_core.c and feedback from
> > netfilter-devel list.
> 
> Reviewed-by: Florian Westphal <fw@strlen.de>
> 
> > +Number of entry insert clashes resolved. These happen frequently with DNS
> 
> Maybe 'Number of insertion clashes', but up to you. No need for a v3 in
> any case.

Much better than my broken English - patch applied, thanks!
