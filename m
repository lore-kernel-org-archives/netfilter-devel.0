Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BAC4A138C
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Jun 2026 16:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781712256; cv=none; b=Zd9MQyR85IBK1C/SJhrZLHLpj+RxDTWLWji7y4v4rnpqLi9bCPTzL4x+fhiHzEzaAAuNfRtV36RnobxSBQk84KV3elrq+kyFNcZliT3kUeHhH3WlVXfd1HX6JIOgbu9ztPF0ITM73YPaeusSBLKaFzna9yOviy1MuPNflioQNmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781712256; c=relaxed/simple;
	bh=MFjSA0yPCcHT7tjVdjRL7Mgp9pHtw/6Wgx003V4MGQ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XqSbHBX2vNO1bWqgAsMGYC3IKO+josKsYeeuNGEiThCoEaZ/EYF4SZz5HMesN6bOev7bbylbIu8nX5en868FypJoqFE96F3ZXEhCSiZJICskI3HO2FYvjqKssi59GRlOugt530/StlqxZwJ8f5k53C3qtEAQjs47mLJ7Rjm3gvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=NQcHJhyj; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="NQcHJhyj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=yWqxQAmw1t2L2FC2XKXfYxcOUPreMOsKTxTabzBJ+DA=; b=NQcHJhyjFEZlSrZ0RelSkhpPCk
	M431da0KNQ0ALWo2g0i6RqXy0GJUBK9I7nI5VZdRJHoxbQZZbc5t5r+XmX/rBk7gzdvot3uyodnwG
	yCezvlj0pAuC3XnkZ6bMQ5jgtMznn3ZeMbDQ7vc9SHJYR6rTkx+XRqju6/si0YVCZvBcapV5ifMNE
	D9vfx1i8RCPaD424/zr8QvABWPiRDY1zUwE3SQn6zfgUCToEQIv9KLJEVo3k/ki4t1qLnXuY5kmDQ
	i9RYAKfl37JWggkZGRT12M0Sa/YLd5pnTOqMMYh/Jra8vPcEdoIVw2VBbJj1yplxpg9own463og8q
	PEFXTEcA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wZsk7-000000002nP-2AmE;
	Wed, 17 Jun 2026 18:03:55 +0200
Date: Wed, 17 Jun 2026 18:03:55 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] intervals: Fix for inconsistent union field use
Message-ID: <ajLFa6v1_aM6ItH8@orbyte.nwl.cc>
References: <20260603184715.1366533-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260603184715.1366533-1-phil@nwl.cc>

On Wed, Jun 03, 2026 at 08:47:15PM +0200, Phil Sutter wrote:
> Reported by a static code analyzer: key->value belongs to a different
> struct in the embedded anonymous union than key->range.* which is
> accessed elsewhere in that function.
> 
> It is correct in that the function asserts key->etype to be
> EXPR_RANGE_VALUE, so key->value is not necessarily valid (it just
> happens to match key->range.low's offset.
> 
> Fixes: 91dc281a82ea6 ("src: rework singleton interval transformation to reduce memory consumption")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
