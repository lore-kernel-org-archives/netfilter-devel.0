Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445781C6B4;
	Wed, 13 Aug 2025 04:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755057967; cv=none; b=cHhYlqLetjAHUPF4zHZtC20pk9Opb8GCBRrvI3IjByuBk6ZsRf8fYlngbRle46m+vNYSd7sKME4hgf3rWI17c88o9tBvUrIhyos2UYA3jFpmRFklcTJ6ze6LJ9nlopz6+vdJp+U6xk/8+Em1dhQNOYjS1n0PwzOn0/I1h2zDas4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755057967; c=relaxed/simple;
	bh=cDuWjG5kthV/GRMssPHn0UBwsgy5WYmvB4QMQ/J2bf4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RRMLUsJy6xr/xIs0U2kNBsacxRVfe75U0kZJF55LKokPS9UXwfiVlLmzcsi0MyUDsslS0y/4w9c85ukPewpHzskl0DENFu+MYW0Dj7TgZMn8CKeB7UHRG+m3RcO0XEPqdvaUPOyLyHexqOnNtLodKR0rLrRqilxmoNAHyRAyCJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r9an25jZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r9an25jZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801BEC4CEEB;
	Wed, 13 Aug 2025 04:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755057966;
	bh=cDuWjG5kthV/GRMssPHn0UBwsgy5WYmvB4QMQ/J2bf4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r9an25jZei1JCoV8hEHtY1S1vcrPpmQglzw/Zg03OGFEdxdQXcVgH4AuD3yJ8hRzt
	 vx/x1LX0EhHVmFz8rdqR0mKzZyLXNR9nSQgfySYURQRszTh48JsnFi+wM164qVfDeV
	 /Z7/Ey4n7+8ZnPH4t/Xrm69ZdAHjKWutSzM9a6kh21IhUEsDZrJGUWJx94zcFmHSz2
	 X0+JBsKMxcgEkdCP09hx+4MCffWi6/r47UBsznLhTXWbaur4tbEFEz5H62rG+Vb/+8
	 bsazHxl01rLd8mqU0c91AszC05+5S15dxlMiY8RSPnwzzBjAj8UIv5Vqchepd0RzAy
	 NBqLiJPtRYPgw==
Date: Tue, 12 Aug 2025 21:05:04 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: Matthieu Baerts <matttbe@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	netfilter-devel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: nft_flowtable.sh selftest failures
Message-ID: <20250813040504.GA90439@sol>
References: <766e4508-aaba-4cdc-92b4-e116e52ae13b@redhat.com>
 <78f95723-0c65-4060-b9d6-7e69d24da2da@redhat.com>
 <aJsH3c2LcMCJoSeB@strlen.de>
 <f1ca1f95-c85c-48a3-beb0-78fff09a5bb2@kernel.org>
 <aJsaylkoOto0UsTL@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJsaylkoOto0UsTL@strlen.de>

On Tue, Aug 12, 2025 at 12:43:22PM +0200, Florian Westphal wrote:
> Matthieu Baerts <matttbe@kernel.org> wrote:
> > I don't know if it can help, but did you try to reproduce it on top of
> > the branch used by the CI?
> > 
> >  https://github.com/linux-netdev/testing/tree/net-next-2025-08-12--06-00
> > 
> > This branch is on top of net-next, where 'net' has been merged, all
> > pending patches listed on Patchwork have been applied, plus a few
> > additional patches are there to either fix some temp issues or improve
> > the CI somehow. Maybe one of these patches caused the removal of
> > CONFIG_CRYPTO_SHA1.
> 
> Yes:
>     sctp: Use HMAC-SHA1 and HMAC-SHA256 library for chunk authentication
> 
> removes it.
> 
> > I guess that's the case, because when looking at the diff [1] when the
> > issue got introduced, I see some patches [2] from Eric Biggers modifying
> > some sctp's Kconfig file. They probably cause the issue, but the fix
> > should be to add CONFIG_CRYPTO_SHA1 in the ST config as mentioned by Paolo.
> 
> seems like these two are the only ones that need it. at least
> xfrm_policy.sh passes again after this change.
> 
> diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
> --- a/tools/testing/selftests/net/config
> +++ b/tools/testing/selftests/net/config
> @@ -115,6 +115,7 @@ CONFIG_VXLAN=m
>  CONFIG_IP_SCTP=m
>  CONFIG_NETFILTER_XT_MATCH_POLICY=m
>  CONFIG_CRYPTO_ARIA=y
> +CONFIG_CRYPTO_SHA1=y
>  CONFIG_XFRM_INTERFACE=m
>  CONFIG_XFRM_USER=m
>  CONFIG_IP_NF_MATCH_RPFILTER=m
> diff --git a/tools/testing/selftests/net/netfilter/config b/tools/testing/selftests/net/netfilter/config
> --- a/tools/testing/selftests/net/netfilter/config
> +++ b/tools/testing/selftests/net/netfilter/config
> @@ -98,3 +98,4 @@ CONFIG_NET_PKTGEN=m
>  CONFIG_TUN=m
>  CONFIG_INET_DIAG=m
>  CONFIG_INET_SCTP_DIAG=m
> +CONFIG_CRYPTO_SHA1=y

Yes that's correct.  I've included a fix for this in v2 of the series
(https://lore.kernel.org/netdev/20250813040121.90609-2-ebiggers@kernel.org/).
Thanks for finding this!

- Eric
