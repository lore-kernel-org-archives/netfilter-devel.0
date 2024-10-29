Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FEC20696B
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Oct 2024 14:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730211861; cv=none; b=VLc5hcP+SKeV86jPUpValy9gU027yVgWuZ7m9Q6cdUrK9eyWIqmbnXIg2C7lA6tXnxT35NbOHBsFp/5s7BH71ncFUrIr62Mz0TSIcaSJ76b7Jzv2sB80v2GTmqim/mgAzyi3TNxKq08qTOSZjcxw3PiQ5r44aD6p0Q1UczyI6ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730211861; c=relaxed/simple;
	bh=LxUs7kleg+9fYy+dAzK2OM+3g1Shfx6r+aaR+Z08tNs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=duwnOzp9eK/O4V3g0tefg0FHksZ9AcMU4AfNAxAFhrBhsziSymtbTAwEBu4hwV+sIA/+zkhMjKgV1EF534OA0Ug3rZ+7JY+vUQLe6AdkAMoa0fG9a6bfYD83RkOjjvLCXAngGJZygg5FDTBbSCaYPvUeOJ92kk2nTtdDHv4Pn1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=41782 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t5n8n-007S8e-T0; Tue, 29 Oct 2024 15:24:15 +0100
Date: Tue, 29 Oct 2024 15:24:12 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [libnftnl PATCH v3] Introduce struct nftnl_str_array
Message-ID: <ZyDwDD5ISoOZrUY_@calendula>
References: <20241029131942.15250-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241029131942.15250-1-phil@nwl.cc>
X-Spam-Score: -1.9 (-)

On Tue, Oct 29, 2024 at 02:16:56PM +0100, Phil Sutter wrote:
> This data structure holds an array of allocated strings for use in
> nftnl_chain and nftnl_flowtable structs. For convenience, implement
> functions to clear, populate and iterate over contents.
> 
> While at it, extend chain and flowtable tests to cover these attributes,
> too.
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Changes since v2:
> - Add also missing include/str_array.h
> - Drop left-over chunk from src/utils.c
> - No need to zero sa->array in nftnl_str_array_clear(), sa->len being
>   zero should sufficiently prevent access
> ---
>  include/internal.h         |  1 +
>  include/str_array.h        | 22 +++++++++
>  src/Makefile.am            |  1 +
>  src/chain.c                | 90 ++++++------------------------------
>  src/flowtable.c            | 94 ++++++--------------------------------
>  src/str_array.c            | 68 +++++++++++++++++++++++++++
>  tests/nft-chain-test.c     | 37 ++++++++++++++-
>  tests/nft-flowtable-test.c | 21 +++++++++
>  8 files changed, 175 insertions(+), 159 deletions(-)
>  create mode 100644 include/str_array.h
>  create mode 100644 src/str_array.c

One more nitpick: Missing update of include/Makefile.am breaks
`make distcheck` for libnftnl.
