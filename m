Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB36189BB0
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Jun 2025 21:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749763016; cv=none; b=u0YoDa+W6IlkeLup7iBCAl7fTZ4oiCow6SPUijHF0Gbm+elaaHjxEeojtYO+jZTCxwZvQNOsjh1HEPFcQsL7vW1jhGS3kPoR8WSxq7PKRNmxDa1NrmXgPE3wDyKUvupiqjhqsFgxxPjE7wD+oGqbsytEKZ/D6tU5O6+tMmJPunw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749763016; c=relaxed/simple;
	bh=ggwB96CM05mquPKcrZp5zDltq7SP97ShTHqNxD+65SE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C7FIV6PR1u6M0W2b8r3qotcoUVYKbl2yFOZzJGO5EJ5NcMyeXuYawPGMa2k8GEWjPYNwtz36VsuMzdJTwLeqxIgjqJKuV2pLGXTKbzVOQOX7eKaMl2aeUknZlqsxeBK4HewH7OyUpVNpI7+NNb3nrsqEAz+PNkxRt2yG1yBfrdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=F+lZU8SU; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="F+lZU8SU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+D1nKYrEJQVfTt918FE0O+P3rYFeydeKLDwZNF1XERI=; b=F+lZU8SUk5SQvl2Og7hzPpAEF5
	fb7mFrnNjhVY0JXRcOxMKZLsT/Nj9P5kG+VRS/T/mdGrE1dJx5CHHaBBx+wOxpjuibDZZJ5653LV3
	xtq8h5EnPlseJZcSEYyBmFs56eivnaF9AmMy8aElvrFcORSsuvq6ZybWVp4AgBccY2ciZ4WNukELq
	J+jD9x0SbrSwapOB5ylp+kMGpu0Z6p57qOkGZ6sv+g7EDqVcpBeKEGYF0kU37uvZ4zjG8/xRVNtKX
	IIMVfyP0YHj6MGYv54qldjKu/Yb2GOvzMyVtNVxkXq9v0kuk6QHqyMTYiNSYt5DpOg0c69dWvNGdo
	asmcIxig==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uPpI5-000000001Hw-0gQY;
	Thu, 12 Jun 2025 23:16:53 +0200
Date: Thu, 12 Jun 2025 23:16:53 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] netlink: Avoid crash upon missing
 NFTNL_OBJ_CT_TIMEOUT_ARRAY attribute
Message-ID: <aEtDxQLaANcwAjSq@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250612183937.3623-1-phil@nwl.cc>
 <aEs3P6EGuVNkQbj8@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aEs3P6EGuVNkQbj8@calendula>

On Thu, Jun 12, 2025 at 10:23:27PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Jun 12, 2025 at 08:36:35PM +0200, Phil Sutter wrote:
> > If missing, the memcpy call ends up reading from address zero.
> > 
> > Fixes: c7c94802679cd ("src: add ct timeout support")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> 
> Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Patch applied.
