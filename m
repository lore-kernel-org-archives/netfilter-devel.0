Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7131422AB
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Oct 2024 21:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730237535; cv=none; b=cE5YxYjyQgUWKx3Uc93toM2L2zNWDy28bYQtwc1+z49C5tbQGNftpta2reao/anKjRKS8GuMFrtzHN6P8gunrXD3LY1r64wHC1lqAgQRVZHDJXqg0rWuk7s008bFAKZsdMK/TwYLaBYhHe9DMFV5jJ1IIxs3V5iiyqw6JnJrA94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730237535; c=relaxed/simple;
	bh=1dMObqAiuCjjBsCsUtkEuOMudKK5D+f3BcSZkspsTvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A3nCJl16+VHFRW89KPju3UYk2yeAGy7UknxSjUOkf90V4Ii9IKSJ4xKRnzjCszm8MxTJ0Re3JoryGq9eNNeU79b+O46i5W+o/J2ARWd8B/WcVxByJNr+K1RRLxM5Q3LoLXyt7kQfrdI6JVkUrGy7yQD6qUDimLqewg776TfxCso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=48554 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t5tou-008fRj-It; Tue, 29 Oct 2024 22:32:10 +0100
Date: Tue, 29 Oct 2024 22:32:02 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [libnftnl PATCH v4] Introduce struct nftnl_str_array
Message-ID: <ZyFUUqzGmBnr071n@calendula>
References: <20241029152919.20293-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241029152919.20293-1-phil@nwl.cc>
X-Spam-Score: -1.9 (-)

On Tue, Oct 29, 2024 at 04:28:58PM +0100, Phil Sutter wrote:
> This data structure holds an array of allocated strings for use in
> nftnl_chain and nftnl_flowtable structs. For convenience, implement
> functions to clear, populate and iterate over contents.
> 
> While at it, extend chain and flowtable tests to cover these attributes,
> too.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
