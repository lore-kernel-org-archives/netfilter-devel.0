Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7B919E7FB
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Sep 2024 12:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726748815; cv=none; b=u5EXbJm+DT4gZu03Qzvrath77ZAbko/ZN7su5WUK0R4k4d9SVek2pDzF+4a0Hjg4czyT+qPN9uM+6ejUMVFRQuqrTh5rBCAH4fM7Y25pP3/kYVqXHv3YLkwYWM7Ko2qn0TLTiMKkuIBpfoaF+TZkBRzyED/kJOKtQV26RH17YGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726748815; c=relaxed/simple;
	bh=FZFM8lJLNi9/dyerLg7E2k920yfr+ZxFvCsmBnKqfog=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QYOClg86SZnjWaidXEx2BLEzA8uYa3x19AxFhIdi0lcFkhjWwOKF9JjmsT0HC09ObrdHccgasCfkNd3Kf58Sd87uDx7eMvz9sDA1JjJrx9LSwMC7XuDJz9d/VEJPJjWTExJ3fe7MUsqKGb0wW5OAb3vPLSzdvfHwueNTADAlE1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=nFjojdnm; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="nFjojdnm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=8UrT+QfQjfNeysB7mJCdzQfzNuGBXQb9pbOpS4+Y6YE=; b=nFjojdnm8vvF6itXYjhhp266Jv
	LDBll84J05Pg6m7/UgSMMdRy4R0n5C3IjE6VpZTtPjWQHyzQ1bhGAnnJD07UZo7gVqr6v5cTHABy2
	AM0i3YplaAKHmKXVa/g8ZPdPm9S+rTy/l7vVQ5vdthtcg2aurRHzHc9iLwRvnjJlNi96e4C7Jrew4
	7nv08jHDyh48Zdh4F0UpneoiHzVxBF+zO364Iazg4kWC8882IlLVAG9h7yNG1LaKWf1ViLGd4B2fW
	NFfpABc51IM7vHoC3+Oodwq1R10MXOzlI5jlBdNejU/oY2DDt6L6VWYyqyOCXCYzdasjj+IHdTh/v
	Zz5TYSUg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1srGFH-000000003PK-0mxp;
	Thu, 19 Sep 2024 14:26:51 +0200
Date: Thu, 19 Sep 2024 14:26:51 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH] netfilter: nf_tables: nft_flowtable_find_dev() lacks
 rcu_read_lock()
Message-ID: <ZuwYi7E2LXiN385t@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20240919104503.20821-1-phil@nwl.cc>
 <20240919104922.GE8922@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240919104922.GE8922@breakpoint.cc>

On Thu, Sep 19, 2024 at 12:49:22PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Make sure writers won't free the current hook being dereferenced.
> 
> Are you sure?
> AFAICS its only called from eval function/hook plane, those are already
> rcu locked.

Oh, right! I missed the fact that nf_hook() takes care of it already.

So please discard this patch, it's worthless.

Thanks, Phil
