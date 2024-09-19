Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9641991BB
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Sep 2024 12:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726749505; cv=none; b=LlHzJi23BRngw1Yw9XH6l2qJLhZHwd9lipxNBQc6q7Eadhk/XjZMJUiED+dHXJUNWBqHRETeEWpJbl8xcC1569+MoXdyMFB2V4VN5ub7QYQqEQFroV02OESojy8FcWKi34yqwMPZQQgKhTx/rnshplbCSfE+MK5EDUTgZx8W6GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726749505; c=relaxed/simple;
	bh=uz/HHxUAzYaV9kScvC7s95JjtW2BNoSzgkRMlP9yAy4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n/hmoqdwCSVrArVH8EVYd4ibP3sj1MBCz4jAIxApuSUmCgNv3VrGoBH8jCQ6AXXZoHfaAkqru5zDh1lwJHDwugd6WShRZUK+/Os8If0nhcqKyeBClzVVNsPlrC0gI11aUfMw9cTkN4KNavvPsKNNauCArK5Wgj8K0alwboordjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=RbwvzEMb; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="RbwvzEMb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=gHC8Tfec66MZEWkUZ5gnjBkdhdfFbFxND+A8Ot7cggE=; b=RbwvzEMb6KPDRfeT7NUpxGigbf
	ChbmWhlHs5Z7iRh89I11D8DJJc8wE7dxw4hi0gLK4XfRSFfbZHhwWpnsxHSZBj7TLj08O1SIhAcve
	/otYpEKdfixguTG4puvkD1t6iiRsuSS0eeY8KzcmMHsA7lgcIIFDj9K1jl04CBd8EgcU/yfxpe+Go
	EDZefM505dzXgTEEU5g28XHhtpJ2gX2SdMVG9NQTKtgGNuFUJ4BiOVg3Bq/Z5eTkV+kL61iR9d4h0
	mxSOLG0dfwl/8urQ4DY/RQ5Va7TBaR3f2ZXtavhGlodUTbSTScyRur6+1Rj3H7nhrU1rOkUOGRGnj
	fmuroyYA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1srGQQ-000000003Xa-0FRy;
	Thu, 19 Sep 2024 14:38:22 +0200
Date: Thu, 19 Sep 2024 14:38:22 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH] selftests: netfilter: Avoid hanging ipvs.sh
Message-ID: <ZuwbPuLh5pf2-fT8@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20240919104356.20298-1-phil@nwl.cc>
 <ZuwS6KD5ObBEaNY6@calendula>
 <ZuwUSgiqE0-mYChs@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZuwUSgiqE0-mYChs@calendula>

On Thu, Sep 19, 2024 at 02:08:42PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Sep 19, 2024 at 02:02:51PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Sep 19, 2024 at 12:43:56PM +0200, Phil Sutter wrote:
> > > If the client can't reach the server, the latter remains listening
> > > forever. Kill it after 3s of waiting.
> > 
> > Applied to nf.git, thanks
> 
> Too fast. One of my test machine has not waitpid, there is no usage of
> waitpid in other existing selftest scripts?

Yeah, I only see "wait" being used in other scripts which is a
bash-builtin. I needed waitpid for its timeout option.

> What am I missing here? :)

My v2 which uses 'timeout' command as used for the client already. :)

Cheers, Phil
