Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBFE3C873A
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2026 15:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774020704; cv=none; b=cXu88Ho4ZDO//NSARlPAO2GkRt9hw75k9zkSWlmqVqWdxPdl92z+H7e92jbea3Vq8byPXcqxtD8YNmeHS4R7L0F8G+pSZvxRJzzmaXxIHuXUTiKaQoCMg4wwHDN8nHfTYLoWMwKyU1Bi/LNklhYAZ8aL2wXl/IsnohkQJdXif68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774020704; c=relaxed/simple;
	bh=9DQJvW5mPEp1myMusXEznI8ym+tsHjy48Sk+kj4u2yA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rMET28HEkdM5JxvgNquv/LjtH2RTyup8lKbHSqjowAJqN/3mS5BTRXT8uEAKb9Sek7W9hCUcKikvvXhIjSCGkHq73AlO+dfGZXxqs33r9XNy7mWHirmCLc5tGl4hgOpd2juK/SF2KbsGpdpOHr/1cEge3m1HNu1PQXai0XAHUVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=i9+cFMQj; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="i9+cFMQj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zgovTtorn9BaE/w6o5m0BDCgUp4Cj9L9fsbmWo6PgYI=; b=i9+cFMQjbtxk2n0CW5Wx1znaE7
	GaJvIM4esdHdiZ19QzjosQz1R1X8ik11JSdh8GThklpE2DPn1MUR0aeijwl6/8h7BnGRqfdmS0iY3
	rFmQ47FObGx/qKrvqpmuZoLwzMvmt1vlBjiC2dxC6qS3B8ezVWh/nUzF5v2GzzpaQfcVcAiD+JkdK
	oJXAqmyx2GoHiWGDPnkVR8TNrbUrFf+PlmuOW5cUb5kmhJvjWaT1AE6542G1SUsl2busNv3ENTnqi
	QwsefDoPdYlXm4w5lvob419zXqspPIV9C0NkZrCa4e4P88Q8jNa8t6UcprHFCJ/cTXyFUUYVnHIV5
	6MIpSDOg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w3bp7-000000002BN-24YM;
	Fri, 20 Mar 2026 16:31:41 +0100
Date: Fri, 20 Mar 2026 16:31:41 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] mnl: Fix ordering of hooks in 'list hooks' output
Message-ID: <ab1oXc7FPvOUWGhb@orbyte.nwl.cc>
References: <20260320151625.5318-1-phil@nwl.cc>
 <ab1mBgSjDyCs5aZC@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab1mBgSjDyCs5aZC@strlen.de>

On Fri, Mar 20, 2026 at 04:21:42PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Hooks with same family, basehook and priority were inadvertently
> > inserted into the list in reverse ordering, fix that.
> 
> Right, just push this out.

Patch applied.
