Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16EC27F75F
	for <netfilter-devel@vger.kernel.org>; Tue, 20 May 2025 11:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747739328; cv=none; b=XpA1psyfg6+Vb7BtCmwOtBcu9uCz3ENpdpu4TXpWlqkKVLk3xirpKV3PMl4QektLnXiQE/leRj+hml2o4C3qszOC/k6U3TCgLX1B0ysMPpn4MQ6ZEKY6E4dZlz3HE0Q1/hfQtdYAAhj39b5MjeuwDfrczpRDvknl3e775nct1bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747739328; c=relaxed/simple;
	bh=z1kCkxQ9OR1WejzNf+GvvC+97V5YxXh4J1/cgRoaMNc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J0jolX2KxMpEWt3/+O9gRVJ7GFq76R0VhZ2G7/ujWDSeF1TkYTgLAsVNGBL8M5r5ccN0UtyQ6n7UBtFiQTrGMy0oHNJwCX2PPFTuSEhnRoztjG5Y1G9sIBIJJ0b+bnkd+qqtqUE7+hDqnMoECW8q4w8CvRgarvC1lSQtY+rDAsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=pvwZiCLW; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="pvwZiCLW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XcGVGMM8Ew4g01a8uzXAmWxbQBIp0dGO4plQDgLFrM4=; b=pvwZiCLWMrVXeEXAWjVE2Y8qth
	AIxhfaD5VHRMt1hW6vOe7pPfWmSd+BU8ocYVDWwxpgw0AqxB9MXOYizatu5WuUjOX8UHV1/zdA5YS
	76BlH00mfepmgrVyedFCCNSImKjp0GBIkHnyk/OpgKlmd36Qxf+XNu4BArUSAJWGZNwg5bEi3unfI
	vsV+nTVTvI+pDLn7yDVUQ9u1wuccbReYfDvfJ8S3V5GpANVjLDRJIKZ/nwFWQ88BaLhHVsBfzGV7L
	cy2hR/nY8SZ9a/+4AAVQT9Qp7D0ApIgznGNU2gzqfgoplS0c1Yzv7tQtgv3SGaDdbHOMFYFjxVX+B
	b9AOPaCg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uHKpw-000000008V7-43Qm;
	Tue, 20 May 2025 13:08:44 +0200
Date: Tue, 20 May 2025 13:08:44 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v6 00/12] Dynamic hook interface binding part 2
Message-ID: <aCxivIkJztgsynjQ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
References: <20250415154440.22371-1-phil@nwl.cc>
 <aCxgYJAE5G7nMi7V@orbyte.nwl.cc>
 <aCxhhBWNsVQYluX5@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCxhhBWNsVQYluX5@calendula>

On Tue, May 20, 2025 at 01:03:32PM +0200, Pablo Neira Ayuso wrote:
> On Tue, May 20, 2025 at 12:58:40PM +0200, Phil Sutter wrote:
> > Bump!
> > 
> > Anything I can do to help push this forward? The series I submitted to
> > add support for this to libnftnl and nftables should still apply as-is.
> > Anything else missing on my end? Or should I try to break this down into
> > smaller patches/chunks?
> 
> I was exactly now looking into integrating this into nf-next, sorry
> for the slow turn around.

Nice! I obviously start to sense when someone reviews a patch of mine.
:D

Thanks, Phil
