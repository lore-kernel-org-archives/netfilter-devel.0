Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C043612D2;
	Wed, 19 Nov 2025 12:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763555147; cv=none; b=GIBYU5Pve7FxygYWpGyRJsBv7FiumOS/2BSqqmf1XO07CoYNNfrf18RczK+MU5Izp+sXFCNq2jKgzDB2qrWkT0kUcCFSkT5gZdFndqA9BEk8llaftSetz0YrCCvwpfbKHh9uG5zcPOSoUqhcJLh4m/ClUPX/zCs5cSszzQM9x7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763555147; c=relaxed/simple;
	bh=cHLbhSSln/f0aP7ENSKsnQoQCEcHBOsmT8u3QTxAkUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cxP1EJg5M5ORmEdDRsqly+c5YdACYMjkkWEC7mWgjzPHli1EWqE0kulsFmV6cZKox1UEH/KL6ZPc8OricWAyt0INDOf4nPv2ew1TLMrlQpKBTUZ2SuMjy+yR8A2256UIUd5wS7/tdxEBAXi9YVPtrJdSeyOCY+1k/1hVfRJQgrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 46121604EF; Wed, 19 Nov 2025 13:25:36 +0100 (CET)
Date: Wed, 19 Nov 2025 13:25:37 +0100
From: Florian Westphal <fw@strlen.de>
To: Chenguang Zhao <zhaochenguang@kylinos.cn>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf-next v2] netfilter: conntrack: Add missing
 modification about data-race around ct->timeout
Message-ID: <aR23QWKZvF4gdCGU@strlen.de>
References: <20251119030119.124117-1-zhaochenguang@kylinos.cn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119030119.124117-1-zhaochenguang@kylinos.cn>

Chenguang Zhao <zhaochenguang@kylinos.cn> wrote:
> struct nf_conn)->timeout can be read/written locklessly,
> add READ_ONCE()/WRITE_ONCE() to prevent load/store tearing.

Do you have a KCSAN splat or similar?

> The patch 'commit 802a7dc5cf1b ("netfilter: conntrack: annotate
> data-races around ct->timeout")'fixed it, but there was a
> missing part that this patch completes it.

I'm no longer sure this was missing.

> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 344f88295976..df4426adc9c8 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -1297,7 +1297,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
>  	/* Timeout is relative to confirmation time, not original
>  	   setting time, otherwise we'd get timer wrap in
>  	   weird delay cases. */
> -	ct->timeout += nfct_time_stamp;
> +	WRITE_ONCE(ct->timeout, READ_ONCE(ct->timeout) + nfct_time_stamp);

Here we hold the bucket insert locks for ct, so I don't see
how we can have concurrent modification here.
