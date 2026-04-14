Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643E212B93;
	Tue, 14 Apr 2026 00:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776125492; cv=none; b=tg6VIjg7sWW8GWtW61ZhZG5oh/9htPSkcXszpe4JWSmuEOI981He/7YW4fr5zD56x6OZDPiJrasDlOiIkyvmZ3KByVdWAlNw9q1CIIN9An3es/FsQ1U58rScU9ySLDi+ZlCgKjgQWnL15hGodYds6UrO/fH/sbnbI3m4gGeCMw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776125492; c=relaxed/simple;
	bh=BsJ44EHp9plgRWqro2dZPO4rDiLIW6QcDNIeoNvIS1c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LCIDm/n/CpNNstL12WG4pWdUdd1dzwGc+1xugyNIu0NpV7YvI6sBSYvWVy4MwQawVA32SAN7HxJS+QrGEJrFDQZRXj0m3uJMk04SA5aIBDO+RU+HSUOYsht7oUka3y7NXDQrszLuJAxOTFctpgB7QOqFtoKPHxZkHt+/ITUD7W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=U3zd1/5P; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="U3zd1/5P"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 5162560177;
	Tue, 14 Apr 2026 02:11:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776125489;
	bh=NvfB7f0eOiBdW3wAIWp57z2zunsl+ur5h/Olq4MZt50=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U3zd1/5PXjK7qonqD6c0rFazYmPOeAL5ygx886wH1wRG3FSXRlUkIYMOCHVAlY2FC
	 UPwQVw1sQTMDex2bN4qSpD5V7/IUvA/8T0wABTL+l2yqMGSfIXVyneN4jz8LM4IwEe
	 Pq62AKWDYivSJ5BXE7kerS86mapw4Ey1p2+Xh0oCUsNvnSgu7yOg/JaX/vNuTzE3IW
	 Qs1XF3xFRFU/eaRDi/7YJNDLQ7VuBXg2DQglNv25iLn2qg+Egr38xXwM2gHwgxFfaO
	 aZwRx8dfrgA1DUVStXsrRgUyVYLIuH06swDcsYK4g1JtNdehYnXPOzfr+v3dQ4v8hj
	 5ziXkU5xWlfSw==
Date: Tue, 14 Apr 2026 02:11:26 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Marko Jevtic <marko.jevtic@codereflect.io>
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org, phil@nwl.cc,
	coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3] netfilter: nft_set_rbtree: fix use count leak on
 transaction abort
Message-ID: <ad2GLmdP2wRVyd5c@chamomile>
References: <20260412222801.34965-1-marko.jevtic@codereflect.io>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260412222801.34965-1-marko.jevtic@codereflect.io>

Hi,

On Mon, Apr 13, 2026 at 12:28:01AM +0200, Marko Jevtic wrote:
> nft_rbtree_abort() does not handle elements moved to the expired list
> by inline GC during __nft_rbtree_insert(). When inline GC encounters
> expired elements during overlap detection, it calls
> nft_rbtree_gc_elem_move() which deactivates element data (decrementing
> chain/object use counts), removes the element from the rbtree, and
> queues it for deferred freeing. On commit, these elements are freed
> via nft_rbtree_gc_queue(). On abort, however, the expired list is
> ignored entirely.
> 
> This leaves use counts permanently decremented after abort.

Yes, but that is expected?

Expired elements reside in priv->expired, these elements are already
deactivated, ie. removed from the rbtree and chain reference is
decremented.

From abort path, the deactivated element simply remains there until
there is a commit run that gets rid of it.

I can't make any sense of this bug report so far.

Why do you think there is a need to restore an expired element?
