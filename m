Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DF225E465;
	Wed, 21 May 2025 10:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747823328; cv=none; b=iIcNjSxW1s0Wai8YPcUhjV6HhK4KkJU3xK8qP0zI3Xzg9IBXs+w/+TYcu7bAPXzYaC7ym/zj7qQu1y14Wv3D6pQCom2NDY1/AxHS+DGcL/N7lpF0XATzY9qecewTjDU6LH8Jc/dFoh5LJcvn95l3fn+S52gK6u/A+BVO7PVw0NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747823328; c=relaxed/simple;
	bh=3d0obmYsX3T2V9AzCr4AMDxRbYCNnGvKP0ArUwkntt0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NvxhccAHnBtUuOEbAOVKRVEXaAVukYphQ1/QK8lBGOFAI+ogq/1VtJqX1Z9QVriFQ6sSyp3VpcoyDlYZ0U9q5r8z2A608co+uxJ4v/r+oj7HAxl38m+r810EnDWt/eRfZdgj+m3RVUP7xw0FpAvw1OxmzzxzwVWGF2GfV6vklck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DXpZlLaI; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=qe5jRX0m; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DXpZlLaI";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="qe5jRX0m"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 3C6A7602D6; Wed, 21 May 2025 12:28:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747823325;
	bh=GMiyj9YVk+wS3RYRfkCFc1jyeRHyyRXJ5KrReLVUun0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DXpZlLaIQxf8D/BzUmaH1hkoyvEHWHD2NU3HENd+E0pOa53EcvShJt8ul9MUKgfBs
	 koraho3mBkJOq5ps7Yz0lKxfVlsFFrtoovEcLsAb13MrHwdgp3TVNXuQlnH1BX9Y7d
	 EwVmZBns2IDHBCS72PdJ8jmPDBn6Nb8OD9r0Cbw3TfEwrsaf14OOBnF94C2jsaZIh4
	 VqqTBKQhHH+9EYpdbFcS1PGgkfm8pHmsL+NcesxKTJ9Qyyy+CJHtA8JD06jP15g62h
	 Q/FHITnIqelxjc1vbO+nCaeGZXAMLnKvxHihvF5kBwhLmpslC/nFsUIA6Tc4Mn1+FJ
	 7pqiqjNaRpoRg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D6234602D6;
	Wed, 21 May 2025 12:28:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747823323;
	bh=GMiyj9YVk+wS3RYRfkCFc1jyeRHyyRXJ5KrReLVUun0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qe5jRX0m5+3IIM4xWpcbgvh/730Fq0XQDenhPe3s9Tu18LoHrg/gUo9w945JClTlk
	 wnGcUiB/wqe1uXGPEVBH/j0pe+PxXLuB1nh6DPDlKTNv34wH6yKGeuspkEy6q+LcNw
	 24vF0Va+fRQJ6zXQPcblZkpU3LmXlE2u4/WDeXtvwyBlin1eXp+z0P5Ozr3UPGsple
	 8n80KQddfcpzfSCWvRfeU56UAPX8sv30GXG7IN17GTa9uoj5T+05XXOUQtI+gIOX39
	 CsNAI6Urgrcwh/25KHWNlpCJPKD6hfZ1DRKVYa82xxR7RomVctYln0iwafI/0YMFHl
	 BAYIgltyOTncA==
Date: Wed, 21 May 2025 12:28:40 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: lvxiafei <xiafei_xupt@163.com>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, lvxiafei <lvxiafei@sensetime.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_conntrack: table full detailed log
Message-ID: <aC2q2OgYNVd8-5Yw@calendula>
References: <20250508081313.57914-1-xiafei_xupt@163.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250508081313.57914-1-xiafei_xupt@163.com>

Hi,

On Thu, May 08, 2025 at 04:13:12PM +0800, lvxiafei wrote:
> From: lvxiafei <lvxiafei@sensetime.com>
> 
> Add the netns field in the "nf_conntrack: table full,
> dropping packet" log to help locate the specific netns
> when the table is full.
> 
> Signed-off-by: lvxiafei <lvxiafei@sensetime.com>
> ---
>  net/netfilter/nf_conntrack_core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 7f8b245e287a..71849960cf0c 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -1659,7 +1659,8 @@ __nf_conntrack_alloc(struct net *net,
>  			if (!conntrack_gc_work.early_drop)
>  				conntrack_gc_work.early_drop = true;
>  			atomic_dec(&cnet->count);
> -			net_warn_ratelimited("nf_conntrack: table full, dropping packet\n");
> +			net_warn_ratelimited("nf_conntrack: table full in netns %u, dropping packet\n",
> +					     net->ns.inum);

Maybe print this only if this is not init_netns?

Thanks

>  			return ERR_PTR(-ENOMEM);
>  		}
>  	}
> -- 
> 2.40.1
> 
