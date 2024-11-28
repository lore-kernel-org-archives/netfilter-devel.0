Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CC019D064;
	Thu, 28 Nov 2024 12:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732797207; cv=none; b=BMyw4Slg8HLDEwPEC0dNdBO4DTYklRuu67v1L+pKFBiOWlQAVOTjXTl0b4IukytO27UqYe7L7Sl+yz1AKcyUb97kGO5QmKucXbE4phDZHISCYoQnUOqQq4RyQZkGjMmBsKiX7ZCk2qWtjVPUUjjm3zLZ1lTROgl4ysYEhSseizM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732797207; c=relaxed/simple;
	bh=on1vlubdaCZJno993lj+9z9Le/8KuhPsrcKc4IzBC7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WHCkNWkVyQ1BgW8tmS2wp7W4bwRVXu0Bbro/K5Y7J/EhtY2hZ7KJfDU7nldCufW9kHpIEaF/UL2Y3aae4t9cjWBf6K2m3J2HOliW+fEQ2TlzsW2+HLx8ygN57xb5RJnr0BsRqhT2kaDayM0tnFy8tiDayS4KQ2WxjAcBtro93nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.39.247] (port=51550 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tGdhw-00Fu8t-QS; Thu, 28 Nov 2024 13:33:22 +0100
Date: Thu, 28 Nov 2024 13:33:19 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, fw@strlen.de
Subject: Re: [PATCH net 0/4] Netfilter fixes for net
Message-ID: <Z0hjDyQq-tRrMsHy@calendula>
References: <20241128122305.14091-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241128122305.14091-1-pablo@netfilter.org>
X-Spam-Score: -1.9 (-)

Hi,

On Thu, Nov 28, 2024 at 01:23:01PM +0100, Pablo Neira Ayuso wrote:
> Hi,
> 
> The following patchset contains Netfilter fixes for net:
> 
> 1) Fix esoteric UB due to uninitialized stack access in ip_vs_protocol_init(),
>    from Jinghao Jia.
> 
> 2) Fix iptables xt_LED slab-out-of-bounds, reported by syzbot,
>    patch from Dmitry Antipov.
> 
> 3) Remove WARN_ON_ONCE reachable from userspace to cap maximum cgroup
>    levels to 255, reported by syzbot.
> 
> 4) Fix nft_inner incorrect use of percpu area to store tunnel parser
>    context with softirqs, reported by syzbot.

This patch #4 is missing Fixes: tag. Apologies.

I am going to prepare another batch and resubmit.
