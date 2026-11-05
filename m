Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793879900;
	b=VpajqGtURlvglb09UZL1Bus6RgM8qGFhpViXmY4Zeg6NjzIRZhy0t8gsd6Mr5ccC0dXD
	 noMz3RcG3ZoqiXUm6UcpdsVwOuid7gJLupLp3Tpj0EoOi7URVbCvzNYSHNjNNh5li/4kJ
	 4sMbfKFtewOU4pT2GDLZOQPhCm0cDRffZrIwB+Kzh/2Z5ksSniE49b3I3KUECeGx2wXAC
	 7ToesWjie6hw09h6jwOtRAAqdXr/J3M8R2bf6stAojDP3BwAstk9R3f0X6gKszBNbPbdO
	 9t0bZqRDSCzxsGfwLqh0WSh+jCbqU/BBkAWlXzK95hhreqZL1eJW9ASCVqorjMGfDxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793879900;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=SpfLuW96ysa+N5RDQ9Bs8I6IRaYlyOe+7/4nH7BbGf8=;
	b=F63On7d2iFmAJfUVzcglSBLeZV+7MCv0ZhoF1icki3JEwcdE0/Niu108srhkwyelA/EY
	 k0d+z4NIPKtGHA+jYUwOA+romT23LSug1Dn++EBn/1p6nNrloybaRbfSYoLGWbfESaPpK
	 7QmrokeyYwRjujXjqNECl8vhDHN+FM1LBi2VNzQk/1TQ1QaOBfT+VZ2xJZPF9gBYx4pnJ
	 ez+dhMyIzG7N6RzdIIkPbpDOIm+4T/U/qqnKZyt6YnStyVLYKDK7FUS2Bcwd3YNfkMZ1K
	 ecWjC8UoVen7jr8haFmoHyACIis171k9jPioIvnsdugXQeU/dKqJfnhqU46RdViYUOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24168606D816;
	Thu,  5 Nov 2026 11:58:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24168606D816
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A893760293; Thu, 05 Nov 2026 12:58:10 +0100 (CET)
Date: Thu, 5 Nov 2026 12:58:05 +0100
From: Florian Westphal <fw@strlen.de>
To: Henry Martin <bsdhenrymartin@gmail.com>
Cc: pablo@netfilter.org, davem@davemloft.net, edumazet@kernel.org,
	kuba@kernel.org, pabeni@redhat.com, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_tables: fix pernet use-after-free on
 UNREGISTER rebroadcast
Message-ID: <auxvTfxdTgYnZ0Wn@strlen.de>
References: <20261105114817.3033625-1-bsdhenrymartin@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105114817.3033625-1-bsdhenrymartin@gmail.com>

Henry Martin <bsdhenrymartin@gmail.com> wrote:
>  
> +	/* netdev_wait_allrefs_any() rebroadcasts NETDEV_UNREGISTER
> +	 * while waiting for the last references to be dropped; the
> +	 * netns and its nftables pernet storage may already be torn
> +	 * down by then.
> +	 */
> +	if (event == NETDEV_UNREGISTER &&
> +	    READ_ONCE(dev->reg_state) == NETREG_UNREGISTERED)
> +		return NOTIFY_DONE;
> +

3x copypaste of same arbitrary conditional :-(
