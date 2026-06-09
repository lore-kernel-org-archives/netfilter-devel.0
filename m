Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AE53AB5DA;
	Tue,  9 Jun 2026 22:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781045789; cv=none; b=Kf456rPp4CUzxiNJ6tO5so+UgXowfYSVUobXVmHKEhbf/klZway+HnTiWXA/IcnnJj2D1iOloVV8wK51UcKqWNrSJuxprfE4KO/iXJ2OQmccJJu22FKRoiFUfNBOrHp/IPeDr67big01jyhyQOdPiwIQ/jnh/4d61F6laxKD3cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781045789; c=relaxed/simple;
	bh=xpaEdU6Ol/5n1/0vr/gUtrqXZLnt80kQ5eGB7ESU99k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QsX5TZwCEJCMnsrNHd+9zDTdeQEPHO3TpmJ3gFZxyapt7RuH8RoqZrZpeowgSqpqKxU2Wnc3iuFVtAUlgGmmCWiF9aA6Cr8UYCXi8/PaTceOtszrnwg+K9PxCMy7Nr/elJbscLF6BiZx90XcyNxZPoCfucpphYhneUmlLWtjIqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TZcI6UOG; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TZcI6UOG"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id E69E3601A2;
	Wed, 10 Jun 2026 00:56:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781045786;
	bh=cMEq6p80xriuZxT3gMSjRHIHmpCYpiVneuEksJ9aYhQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TZcI6UOGP4YBMiou8whg2staDeI9I/huEpCIDXWEDrv+LpKEtWkJDuQan5B7NTqd0
	 m8cZmOQCUm1Pliv7dL9QC6b+59yLrb4Q24ikJi3ZXLf/q1nH+1RmAogYdCmrwvmlZu
	 b8/gd/0Q2CgvJTKeo7W+0Vx0XZm8HnmGN/cllAtc3RIX3RTUyNA1radmRuSXlfN8SK
	 zcqQ2lhP2J72y3EjH44SpybuY/vSnN9CBnZZs7EkEDysvrVgQhaPHSljGjGBa2Wscu
	 w/CaDpuBBl7MVvfWamAxQCTo2xsdMd+MVAq3OezGVOmrCuOLBIPJ9CTcwj6ypMWOpC
	 R4WkYgZs7rxaA==
Date: Wed, 10 Jun 2026 00:56:24 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dummy: add phony ndo_setup_tc stub
Message-ID: <aiiaGPj0XQ0mx-cp@chamomile>
References: <20260609142813.9197-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260609142813.9197-1-fw@strlen.de>

On Tue, Jun 09, 2026 at 04:28:09PM +0200, Florian Westphal wrote:
> diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
> index 9101b1703b52..26e7ed5a8575 100644
> --- a/net/netfilter/nf_tables_offload.c
> +++ b/net/netfilter/nf_tables_offload.c
> @@ -234,6 +234,9 @@ bool nft_chain_offload_support(const struct nft_base_chain *basechain)
>  				return false;
>  
>  			dev = ops->dev;
> +			if (dev_net(dev)->user_ns != &init_user_ns)
> +				return false;

I have no idea how hardware offload can be used away from init_net_ns
(not even init_user_ns). For most drivers, this exposes the same
hardware offload capabilities for all netns, so they can interfer
each?

@Jakub: Did you mention any driver that already support netns?
Otherwise, maybe it is worth to restrict driver which do not explicit
opt-in to netns support?

Thanks.

> +
>  			if (!dev->netdev_ops->ndo_setup_tc &&
>  			    !flow_indr_dev_exists())
>  				return false;
> -- 
> 2.53.0
> 
> 
