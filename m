Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750F91DFFC
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Sep 2024 16:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725380060; cv=none; b=sgcex0sz4tOk0vN6+zkCFM0oLB26YaLkH/gzk4F8dngVVzwASor/U0tOT0/F8/M8cQ2ncv0F3L0iMZMQWqJm8ra3ff3/62MX7272UzoOlq3NDWY4koND9QHwGsCNRuSmtqlMfNGN4sVxCVJvK0AfV4XfbW5m0nQ3rp4P9bDnUgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725380060; c=relaxed/simple;
	bh=5pCnivjw4Gzf+EqxvXbf2UtZLL8uiDdu/aiE0gxNpV4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N2sU/iTmLm1Z7ByHY8uDp6yt+rAgS04rdFwJj5uA9c7O+DoXKl9Fch1x9JlAyRUwZu5+S/xGNK+Rvl4ohcDy2gCNUcDp0/6ajMEf5fCqOzzJh5fhLZvIfMUStJ9sFk8Hf3RK6zox2e2BiAogWNOJJ5CD18/ntAar0ERVQ7ReJe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=p5bzzl0I; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="p5bzzl0I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9UMnWlB+MkQ+LYD/g8Cg3lthN5cL/1f/OSqdA5bK6r8=; b=p5bzzl0IuM0dvxVRV6EmhPo1oj
	YWOLBPRCkLm3WKKQR4Rs5ZO5edzt7PWAD34wjrvJkKcdgHP9u33Bn7PqTwcBexgBFcyZixa++5mNM
	W6MPB5x9cZ9TUMwAC3RBE7QriLAl1tcdbiIjCsXQljV8J8qtkrD+kcNMsNE3naEGiVzmKKv2ClW9f
	b6f1UMF4Cf3hE725hPI0PBB4JRtazwgY5bbcEu7LSAx+i16mOt/4CLdXrrXSUP61usKsAXaRbIG0j
	l2YfiJB4sIk+hTN7vNtX/Ea5wXfTTtg1tbU0a5u6n9UqmfSBGYZR8hzzhJ61jpFxJsu7OlxYKLmtv
	C3x22AvA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1slWAa-000000002s8-1jpx;
	Tue, 03 Sep 2024 18:14:16 +0200
Date: Tue, 3 Sep 2024 18:14:16 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] libnftables: Zero ctx->vars after freeing it
Message-ID: <Ztc12EWhEb5P0TrM@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20240903154918.17211-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240903154918.17211-1-phil@nwl.cc>

On Tue, Sep 03, 2024 at 05:49:18PM +0200, Phil Sutter wrote:
> Leaving the invalid pointer value in place will cause a double-free when
> users call nft_ctx_clear_vars() first, then nft_ctx_free(). Moreover,
> nft_ctx_add_var() passes the pointer to mrealloc() and thus assumes it
> to be either NULL or valid.
> 
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1772
> Fixes: 9edaa6a51eab4 ("src: add --define key=value")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
