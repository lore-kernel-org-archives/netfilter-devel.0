Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C65261B8F
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Dec 2025 15:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764862036; cv=none; b=ormwf4DMpbqFjFvQ2rdCoK7xpJJXlcEDiO+HMlWTSsLSH7zq93UzS+yBp/CLtPa+lhYJu92hw5+gNqWaYuvs5Zogenyz1x6KzW5C4UaJuTkksLNhJRYHKvfJncaZLCoCuKhixFlGGMatRsjbBXtXGTLhrnqqPEd+AN9QADTRn6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764862036; c=relaxed/simple;
	bh=h71G4I11vLCbRHjUsyxJ4NMGquHMQsMY2Qh1El39aA0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L+nVCcIaIKonhTJw1s5uFZQNx2DZe7vCg6edxtN5V2IUjiWfPUxFN+7qNNJtgF2+yfZVVAnXp8B/yq+UwHY4BZQcW8S+zg7GXCPlo7nDS43RWPGp+Bq9AqYlLnPzkQKgf8RVVilMtkpbiW/EwyuKEQWC/zgVP4uJO/Trzjj5RCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id EC47960332; Thu, 04 Dec 2025 16:27:09 +0100 (CET)
Date: Thu, 4 Dec 2025 16:27:10 +0100
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH nf] netfilter: nf_conncount: fix leaked ct in error paths
Message-ID: <aTGoTkX8IbGjkjxw@strlen.de>
References: <20251204140124.4376-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204140124.4376-1-fmancera@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> There are some situations where ct might be leaked as error paths are
> skipping the refcounted check and return immediately. In order to solve
> it, call nf_ct_put() as soon as possible or make sure that the check is
> always called.
>
> Fixes: be102eb6a0e7 ("netfilter: nf_conncount: rework API to use sk_buff directly")
> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
> ---
> Note: this is actually rebased in top of net.git
> ---
>  net/netfilter/nf_conncount.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
> index f1be4dd5cf85..09b534fb1b4b 100644
> --- a/net/netfilter/nf_conncount.c
> +++ b/net/netfilter/nf_conncount.c
> @@ -181,6 +181,8 @@ static int __nf_conncount_add(struct net *net,
>  			nf_ct_put(ct);
>  		return -EEXIST;
>  	}
> +	if (refcounted)
> +		nf_ct_put(ct);

I don't think you can put it this early.  Afaics the zone pointer may
point to storage within 'ct', so this has to be deferred or handled
like 'tuple' (copy).
