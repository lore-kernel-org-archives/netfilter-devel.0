Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1C275811;
	Wed, 19 Jun 2024 10:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718794213; cv=none; b=tVrBFfPLTohgPg5fNEeqFSR81JPFWbW9BURQH2jrlO/IlCSBNmPU4uraOSYSDAUpvM7qga2QVB+bHbLMsDoL+BpYnNRo3PeljjazM2IMkyO1z9uWGG7eQiCsOU4kMHnhfaCAevVD0fRws+atbgUecY8AmP5y+jQ5uRv9ZT1fFAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718794213; c=relaxed/simple;
	bh=0Ov3PmE7CC+7zbi2UBMAfob1j/aM88J4U3/b2MU/JpE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AoQwJCklRJa51k4IZ10E0dHT+RpVMDPzrDZrFeUc/Rg2kmBzS75kAWBhc1MKljowD/3sLHa+O1zIh2sPJSO6XF1H4TuiJDEY3TSG1snUPcdhWjtn6Rb4N56lRIyFUA8TNoX5IpN9al48+6nsuzRRl5oMIxuuv08/ovKvMnvb0K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ocQwpkUG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ocQwpkUG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8813CC2BBFC;
	Wed, 19 Jun 2024 10:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718794212;
	bh=0Ov3PmE7CC+7zbi2UBMAfob1j/aM88J4U3/b2MU/JpE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ocQwpkUGUMZc03Gru9NmDF0xTVgb+um1ucEtWz+ylXn/oBd/T/mGeMohJfjwZlmux
	 sBHYlwgTDWf8h81W5l3fSidwU8Yg29eS3yyIH2Qlg7ptT4s+GtlYUkOG0siHjP4yo/
	 nrHvzsc+/NDEddNU5edya9Z0cFG9ZwEg9zKaoLXY=
Date: Wed, 19 Jun 2024 12:50:10 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, sashal@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH -stable,5.4] netfilter: nftables: exthdr: fix 4-byte
 stack OOB write
Message-ID: <2024061904-primer-dexterous-c6d3@gregkh>
References: <20240613171455.121818-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240613171455.121818-1-pablo@netfilter.org>

On Thu, Jun 13, 2024 at 07:14:55PM +0200, Pablo Neira Ayuso wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> commit fd94d9dadee58e09b49075240fe83423eb1dcd36 upstream.
> 
> If priv->len is a multiple of 4, then dst[len / 4] can write past
> the destination array which leads to stack corruption.
> 
> This construct is necessary to clean the remainder of the register
> in case ->len is NOT a multiple of the register size, so make it
> conditional just like nft_payload.c does.
> 
> The bug was added in 4.1 cycle and then copied/inherited when
> tcp/sctp and ip option support was added.
> 
> Bug reported by Zero Day Initiative project (ZDI-CAN-21950,
> ZDI-CAN-21951, ZDI-CAN-21961).
> 
> Fixes: 49499c3e6e18 ("netfilter: nf_tables: switch registers to 32 bit addressing")
> Fixes: 935b7f643018 ("netfilter: nft_exthdr: add TCP option matching")
> Fixes: 133dc203d77d ("netfilter: nft_exthdr: Support SCTP chunks")
> Fixes: dbb5281a1f84 ("netfilter: nf_tables: add support for matching IPv4 options")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> Hi Greg, Sasha,
> 
> This backport is missing in 5.4, please apply to -stable. Thanks.
> 
>  net/netfilter/nft_exthdr.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)

Now queued up, thanks.

greg k-h
