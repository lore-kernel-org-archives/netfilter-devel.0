Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51DF19A;
	Wed, 23 Jul 2025 01:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753232542; cv=none; b=MStCXtx1xxLwc96vUg8jWYnDeGGZDzekITCsg0fQ+ajKZfS8U1y3hH3aevjvI9knm7JWtnV9YzodtCXnZtQg9zlkh3L4M/JmuVhlhL2X9QZFV7ufFcz9U3G1XWo0qeNunSmc+y1pIzA87FutG/fvvFwe/zBBm22gMXlFzKUyzH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753232542; c=relaxed/simple;
	bh=vr7pD0YXRwAScuGrHCqezmW3XIU4AIHJ6JEseENsoCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cdYQUi+mif88XGtfiGNl0rs7Uw75wZlIiw8VfyzFJe6C98UQZDMSzpw4niicsBKWJDNNlk6obXEkRjIDhXB+Xw+Z8nDos9HdV89VmGmYzKKw7tXUVMmVIJjijLAL4WSRmZrwYBp20jmsxpRlPiJHW9qnRFP0xzqnmfBw+XGEMtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=piNnvYcZ; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RjYIICVa; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="piNnvYcZ";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RjYIICVa"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 95B2660286; Wed, 23 Jul 2025 03:02:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753232536;
	bh=EdBX1broglTSvzLe9lwy2ZswEClbQ77newzg7SsGALQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=piNnvYcZVGZjhbwkbgC5IpM+efqJQIz/dU+UVB9X6ILYWi5OfISmkKd+f3+UaNMhx
	 +xlXTPBQqplY30YBtm+qMvmZWdTpYuRu3Bv6V1cdrsLxFiR2DNcUERr16XX3tdmC1l
	 bB8NtZ+w7zDLRtg+U4jqQLTd62NQYkWOzPn/yJGToXoO0Xy5xDpnL2V7wk/2riHL74
	 /EfPESziNiN27aGwntYYA5aBx4XsC5Bno8qHyOWFImoJeiNzXJ+GOYQ0Pu1xBdl76k
	 LzaIalKxgd/PagVss9cCqEqxurK38FBWDo33WYgMKTD9LtDmb9YVpN3VKs63/eobre
	 O6DwK6OZa6rbw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4636A6027B;
	Wed, 23 Jul 2025 03:02:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753232533;
	bh=EdBX1broglTSvzLe9lwy2ZswEClbQ77newzg7SsGALQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RjYIICVaotgq0vkIS+QNcJYDP7fcYp3/qKFToB+eVy255pard5wDrJkbncSN3mLXi
	 7e3o+XK43GHZd+yicBqVyPG3L9wRO/zgGoX4k3L/UxBsbeEQ2gTs0gXxLAnv/V/b5s
	 3H1bFZuMiCNzSLuxts9mcjxyA5uPTZm0N3NkMsvwEalkbX+rLLGMPzRnLL+MypH5xx
	 Fm8yXJ837xbnZDRF+zF1lB79YVoc2MUk6icDi+P4+tnsdOB/J8z5bXRr2PBn1NWM0B
	 7jjWPKdFdrAzvqJtpOY/fKyRsXZgCnnydtA1uyZsS7PfWlMZ37IAt+phsUfGThars5
	 HZun9V/hJwpVg==
Date: Wed, 23 Jul 2025 03:02:09 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: lvxiafei <xiafei_xupt@163.com>
Cc: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
	horms@kernel.org, kadlec@netfilter.org, kuba@kernel.org,
	linux-kernel@vger.kernel.org, lvxiafei@sensetime.com,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	pabeni@redhat.com, fw@strlen.de
Subject: Re: [PATCH V2] netfilter: nf_conntrack: table full detailed log
Message-ID: <aIA0kYa1oi6YPQX8@calendula>
References: <20250508081313.57914-1-xiafei_xupt@163.com>
 <20250522091954.47067-1-xiafei_xupt@163.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250522091954.47067-1-xiafei_xupt@163.com>

On Thu, May 22, 2025 at 05:19:54PM +0800, lvxiafei wrote:
> From: lvxiafei <lvxiafei@sensetime.com>
> 
> Add the netns field in the "nf_conntrack: table full,
> dropping packet" log to help locate the specific netns
> when the table is full.
> 
> Signed-off-by: lvxiafei <lvxiafei@sensetime.com>
> ---
>  net/netfilter/nf_conntrack_core.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 7f8b245e287a..47036a9d4acc 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -1659,7 +1659,11 @@ __nf_conntrack_alloc(struct net *net,
>  			if (!conntrack_gc_work.early_drop)
>  				conntrack_gc_work.early_drop = true;
>  			atomic_dec(&cnet->count);
> -			net_warn_ratelimited("nf_conntrack: table full, dropping packet\n");
> +			if (net == &init_net)
> +				net_warn_ratelimited("nf_conntrack: table full, dropping packet\n");
> +			else
> +				net_warn_ratelimited("nf_conntrack: table full in netns %u, dropping packet\n",
> +						     net->ns.inum);

This is slightly better, but it still does not say what packet has
been dropped, right?

Probably a similar approach to nf_tcp_log_invalid() would better here.

Thus, nf_log infrastructure could be used as logging hub.

Logging the packet probably provides more context information than
simply logging the netns inode number.
