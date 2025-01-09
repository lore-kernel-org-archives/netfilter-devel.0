Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3718F21D595;
	Thu,  9 Jan 2025 15:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736435902; cv=none; b=NA/Oj0uyZwGDrs9UxEmFdHNzWettDcMs4zzhizNN+7W+HQokgcLq6EOC4/wsOmhrBsYeR9zUOsrk/ak8E1O3m+UO2KItI5qibVBlt7tbpcXTiCdPQusZs4Z3DKIVK+qAOolxduDqvjkFAgVpVVL7v0QnKqa6T+dWPe9Lzr5MSZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736435902; c=relaxed/simple;
	bh=Wu6LHOw4BVP92UHf+qEa4+D1tfFfHz+5Q0VlvXszTp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IdkSJH3obltViLTWyueQJapKytXiz/TwCcVgC7dt25GDl+6MWpKDAiNK7Bi11OIXnxfazDyKlTiyNNOKn3pQjfgDMB8jO/Hnd8R0YhD+r6wl35ipEAJrxgaX3af+eHFNkOvVz1sFFKuGBbaoexwOXx4A2Z7t66p+0wmWJlYI89Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jubKguQ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jubKguQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65589C4CED2;
	Thu,  9 Jan 2025 15:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736435901;
	bh=Wu6LHOw4BVP92UHf+qEa4+D1tfFfHz+5Q0VlvXszTp0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jubKguQ29PQrLJOM9qUOMEVIrczgQHYudhYp2ZLfAj86oTpuhd5EbvuTIp9pfTxoZ
	 m77dkRE30Xjo0ZXlSbql0odEuuMpYJoxPFtivKMpZBgoQjxzrOfWIACASE1TqRnqwa
	 HcbZPbiO16fPtYZ7CNgPT43B2CIU/2cZMvCAhjDaNrRmLe++GUEGsMR4O8z817ORie
	 n9kG7QTVxryGnhIlx3pJIzGc0AquC1k5rDE2mjLdiBpzbxfYt45xuu86TuILgpnjvH
	 mNkhBPcsW2+w1GwBBw5f30aOb41DckZm+OURf1C/oT80l9pfDg7XLeYnuE4WYucMaM
	 fHK1ausfq1XVg==
Date: Thu, 9 Jan 2025 15:18:18 +0000
From: Simon Horman <horms@kernel.org>
To: Antoine Tenart <atenart@kernel.org>
Cc: pablo@netfilter.org, kadlec@netfilter.org, dsahern@kernel.org,
	menglong8.dong@gmail.com, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: br_netfilter: remove unused
 conditional and dead code
Message-ID: <20250109151818.GH7706@kernel.org>
References: <20250109093710.494322-1-atenart@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250109093710.494322-1-atenart@kernel.org>

On Thu, Jan 09, 2025 at 10:37:09AM +0100, Antoine Tenart wrote:
> The SKB_DROP_REASON_IP_INADDRERRORS drop reason is never returned from
> any function, as such it cannot be returned from the ip_route_input call
> tree. The 'reason != SKB_DROP_REASON_IP_INADDRERRORS' conditional is
> thus always true.
> 
> Looking back at history, commit 50038bf38e65 ("net: ip: make
> ip_route_input() return drop reasons") changed the ip_route_input
> returned value check in br_nf_pre_routing_finish from -EHOSTUNREACH to
> SKB_DROP_REASON_IP_INADDRERRORS. It turns out -EHOSTUNREACH could not be
> returned either from the ip_route_input call tree and this since commit
> 251da4130115 ("ipv4: Cache ip_error() routes even when not
> forwarding.").
> 
> Not a fix as this won't change the behavior. While at it use
> kfree_skb_reason.
> 
> Signed-off-by: Antoine Tenart <atenart@kernel.org>
> ---
>  net/bridge/br_netfilter_hooks.c | 30 +-----------------------------
>  1 file changed, 1 insertion(+), 29 deletions(-)

Nice diffstat :)

Reviewed-by: Simon Horman <horms@kernel.org>
