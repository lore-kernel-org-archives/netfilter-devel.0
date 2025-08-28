Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCE830C60A
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Aug 2025 10:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756378095; cv=none; b=opc1aKxiSzIm+Jaz/sofUMu3bmxNyWCfOrVD9Ud3eQ1fgRwYh+yEF3niqHN4ECaZkd3xwPfAz+nRLw4e0GXvsAZd9kNtRMpusL4cL+KG92YeY1Bl3ZgF3QCPNFLwziHnanb9dpFLARGnUsVcqLl0AJ5LNf6+eGoOA3of57lBVTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756378095; c=relaxed/simple;
	bh=bBxPTIh3mvzsf67P/hNf6BUnTWHQo3ffNuCvTUKTdOM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QN70Wzgz+ySCn6Sbgi0FmyyaJpfn0BiOH0ihx6RBFTpTCoVUu8Od1ed+ITXoF9E+QkJp4f3lRpGDCayrb59+Q8nh9C+LX0d/iV4SOmrXOYFAmKHWP+jaqyztTKCkpDaWH4kVm1+a33Ou9uSvNmMmSxSHatwJZ6HT2iidIrKGMvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=endBcbHo; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="endBcbHo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uAXxSxZr8EM10sQk9ZSrXrUjefm3c/nvNNYponLN1qw=; b=endBcbHo0XHHtnEzYK8q9bu4OR
	SlnijqHcOnfMugwT8uxumFPjon/zppK+/9/0dKeZ+keZy8ZKQamrXn9xjUVPteIPoZz4FMbeSQZ9W
	xh9cSo3pOi6fh7H0Wj6Lkxqkj/OVcwam4hEhtB/V3XILiNi4Z6jhLG0wqTiEw/NFDx+1RQXutdhoR
	22stFXxUsCEAefXG6nSIk5+lSm1yJakYodq1avaPxM+aAfGNJZo/rRKTOVPJdQRR1tAUUQdUpAhX4
	PiFmnMkiXhung3v4xgp+mjquF2tulOLfTJIgopQOYRGhXQNokeQTC+EqKqe1tb//GPbi3q5Nm7I7g
	Q5QS4Lpg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uraAr-000000003Pv-2Mup;
	Thu, 28 Aug 2025 12:48:09 +0200
Date: Thu, 28 Aug 2025 12:48:09 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Dan Winship <danwinship@redhat.com>
Subject: Re: [nft PATCH] table: Embed creating nft version into userdata
Message-ID: <aLAz6WrZE_1g6zjm@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Dan Winship <danwinship@redhat.com>
References: <20250813170833.28585-1-phil@nwl.cc>
 <aK-K3qn6spM6O5eV@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aK-K3qn6spM6O5eV@calendula>

On Thu, Aug 28, 2025 at 12:46:54AM +0200, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> On Wed, Aug 13, 2025 at 07:07:19PM +0200, Phil Sutter wrote:
> > Upon listing a table which was created by a newer version of nftables,
> > warn about the potentially incomplete content.
> > 
> > Suggested-by: Florian Westphal <fw@strlen.de>
> > Cc: Dan Winship <danwinship@redhat.com>
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> 
> Just rebase this and apply, it clashes with my update for --unitdir.
> 
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Also applied.
