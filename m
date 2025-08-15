Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE2820766C
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Aug 2025 14:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755267531; cv=none; b=VBIgaKBNTxFd+zHD75IUXf9A1y4Brlb9LRPH1tDDNaIZvl/akXcTElhl92vHo1LjzasIbcwZhHKJdxq+gBFE43niaT3kga4cQlrB8WOFc1hWup/LS5cZZUSiwn8e27obTVl8KZ4mamYmClpYvyBFoYBzqiioo4Bzz4BHPHYLI/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755267531; c=relaxed/simple;
	bh=OmETtmDwEMiTyu3F3XyI/a24DPFcU7M1N5wg8ggfnic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IKCw/aorbur9hpeamp+m4T71BmdAusCfK8Jd8Zf+byTW9iQa/ZK9QCbLWUax+34e9oK8ozbWKwCKzhGPm+CgPzE9JbSKTq6XxuWBk8i0cDpDqM3aeT4yQ0orMTQTS0K1NmoI/0+Dl7ySoVPsYTCCqVs9w5B1pVZ/6CJWL84epB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=bEfrYsSw; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="bEfrYsSw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+4NWyeLwr0YUwb5Rh05scqOI8h9iQiTJc+p4VUaSQSA=; b=bEfrYsSwtp+d3Djn0VH26FEnZ0
	RVNTEfzFKCiO1HlVIZr9FbPQWAdwUNFSF0aY2/2MTiJnUmecwtgR01fNbud3jMXQ6OCOiHbnfO978
	2pvt8Cwml1tjulejc2op8S2c0Svb/h0GOuVy+DHPQh/oohVngcjKtXlg8km0vGDGpnZYMT1gltKMF
	F9T8LpP6mnG6z4jLvTRi0deB4jkuln3z0tY4djAcPWy3GQ8k/y0vMOQJ4wyGoPjPNrREBuDERJzpt
	6F/u2FYYuKvOF6LhT4f0keJ9b0Eh18D7p98yQaHZRWmqvtgq+zFXDLK2wdJXhpKbndFNQhcqoLFkY
	/aZOs9Nw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1umvGY-000000005Gd-1xYc;
	Fri, 15 Aug 2025 16:18:46 +0200
Date: Fri, 15 Aug 2025 16:18:46 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 00/12] replace compound_expr_*() by type safe function
Message-ID: <aJ9BxkibzDF-ET6s@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250813141144.333784-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250813141144.333784-1-pablo@netfilter.org>

Hi,

On Wed, Aug 13, 2025 at 04:11:32PM +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> This is a series to replace (and remove) the existing compound_expr_*()
> helper functions which is common to set, list and concat expressions
> by expression type safe variants that validate the expression type.
> 
> No rush to apply this, there is a reported regression on the JSON
> output, in case there is a need to make a new release to address it.

Patch 1 looks like a candidate for advance integration.

> Pablo Neira Ayuso (12):
>   segtree: incorrect type when aggregating concatenated set ranges
>   src: add expr_type_catchall() helper and use it
>   src: replace compound_expr_add() by type safe function
>   src: replace compound_expr_add() by type safe function
>   src: replace compound_expr_add() by type safe function

I suggest changing the subject to something more unique, e.g.:

- src: Introduce set_expr_add()
- src: Introduce concat_expr_add()
- src: Introduce list_expr_add()

Although duplicate commit subjects sometimes happen, there are
situations where it helps tremendously if one can tell them apart by
their subject, e.g. when backporting.

Cheers, Phil
