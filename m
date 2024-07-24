Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF75130484
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Jul 2024 07:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721807515; cv=none; b=KuDT/sQ5a7lIGnTPC3Zu/MrpezWP6XeaRERCHI8aCTQIpFgY3msKh4Pz+mdYcJH5o7S5r6SdGwrAxbwd8LMyW+cUnxCO26ZDAntDFfAKpwlQHGPAbMPqDEipqU0mFEBFsiYmjpFX7XJXSqEu+fMxP9/4CgdEhEQ4QTDfRrf9NPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721807515; c=relaxed/simple;
	bh=hBYTLf8MslKLqP74iUa9m/C6uYHx3577Vok4gVikqAA=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nhH4Ui66UdheCgm4BMCC1OJy5DCT82Yzwjr1+w+Y8svKsDxYZzk+eL2QCrzJatVXqW8HIBp8Tu/zeQRM7pRdguIU1W4eabW3JSHJqebubrKAIfDVBb4hwWeWnJANUkD9Qwb62hqkwcVmCs8QfRuQwYJgK8u5Dxgo/3mqPpAp8ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [46.6.251.194] (port=5458 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sWWmm-001pJj-QG; Wed, 24 Jul 2024 09:51:47 +0200
Date: Wed, 24 Jul 2024 09:51:42 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Eric Garver <eric@garver.life>,
	netfilter-devel@vger.kernel.org, nhofmeyr@sysmocom.de
Subject: Re: [PATCH nft 2/2,v2] cache: recycle existing cache with
 incremental updates
Message-ID: <ZqCyjliV3rYWVxYn@calendula>
References: <20240528152817.856211-1-pablo@netfilter.org>
 <20240528152817.856211-2-pablo@netfilter.org>
 <Zp7FqL_YK3p_dQ8B@egarver-mac>
 <Zp7QSXcMHt9a8Hm7@calendula>
 <Zp-afhWpdM9R4hco@orbyte.nwl.cc>
 <Zp-fx35ewU1n8EE5@calendula>
 <Zp-oo3YnHOnZ7H98@calendula>
 <Zp_HmLb2r3nYeBBb@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zp_HmLb2r3nYeBBb@orbyte.nwl.cc>
X-Spam-Score: -1.9 (-)

On Tue, Jul 23, 2024 at 05:09:12PM +0200, Phil Sutter wrote:
[...]
> I don't like the commit because it breaks with the assumption that
> kernel genid matching cache genid means cache is up to date. It may
> indeed be, but I think it's thin ice and caching code is pretty complex
> as-is. :/

Right.

It is possible to retrieve the generation ID from the batch via
NLM_F_ECHO and the NFT_MSG_GETGEN to answer the question: "Was it
myself that has updated the ruleset last time?".

And this needs a lot more tests for -i/--interactive which is a
similar path to what daemons will exercise to ensure cache
consistency.
