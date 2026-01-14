Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFBB25228C;
	Wed, 14 Jan 2026 20:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768420843; cv=none; b=Jo2oymoDn6afpxrBfBxI6xpzVMjsnfM1dQrwXPFwSpMMxJiox6AQF6CywZ/i3PVjSDrJ5HW0/LnyyKY6jRXNmJlOofl0ogxaUCml7NacbuNUbjT1H4OZCKJvRV6YY8HphXS1lINv0ih2zvbIle99Bu+4/GYRZLxlRujUKKf28/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768420843; c=relaxed/simple;
	bh=jQL2DGJIUuoKsRj/apvhOGnSH97GSGbmLb6wMNSpcro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lGZSNCVuO5bIi1K66RegnbJPJMdMUVrgs/8KuKQGLagzLTQzFBUGtFYUIdPi+Wn7KCwvmL1fmjIyEu8x+Psi8mgVqkp+BUYRA69yXrlGjOwosSDIfWhQIdXRzGGVxNOIhIvXeVgPjyX6w2OjGupZ2tvF9F4Ep5NhIus6dwdkoMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QadWT2e0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QadWT2e0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185E1C4CEF7;
	Wed, 14 Jan 2026 20:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768420843;
	bh=jQL2DGJIUuoKsRj/apvhOGnSH97GSGbmLb6wMNSpcro=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QadWT2e0PDyMcL9h7VjXXD1zuDeJ7jZmCpJdTcv2vLDdW7NlZYekOW+elzS9vb+QU
	 Cz0dzydVe29gAdQYoLHDRaTHBOhDVNWIYdi8rw0v+NxQv+obPGZWrfmj2D1aRJ2zpj
	 9ecaEhedTDKI0rgkLpYbCVS3uAT5z5qJ6gmNWDsKh1ncmDDBy7i3+36PSv4vCLsW6d
	 XJzhjifLMcSO7ZAsNOJYBv7hn9/6l+BOMtblR2vgOAm50PMQ2G2UhvlrMR/MNbmect
	 fYrcmLWVS+BGdZe6safAhfa4kS2zWiVsnEKkZctA3TBjtYZpzwnECq9Vb635jeLtAv
	 X+P1KGn32oXMQ==
Date: Wed, 14 Jan 2026 15:00:40 -0500
From: Sasha Levin <sashal@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: Re: [PATCH AUTOSEL 6.18-6.6] netfilter: nf_tables: avoid chain
 re-validation if possible
Message-ID: <aWf16HxPQNNg8XIU@laps>
References: <20251223100518.2383364-1-sashal@kernel.org>
 <20251223100518.2383364-2-sashal@kernel.org>
 <aUprB84-pTouDuac@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aUprB84-pTouDuac@strlen.de>

On Tue, Dec 23, 2025 at 11:12:23AM +0100, Florian Westphal wrote:
>Sasha Levin <sashal@kernel.org> wrote:
>> +	if (WARN_ON_ONCE(!nft_is_base_chain(ctx->chain)))
>> +		return false;
>
>This WARN will fire unless you also pick up
>a67fd55f6a09 ("netfilter: nf_tables: remove redundant chain validation on register store")

Looks like it's already in the trees, thanks!

-- 
Thanks,
Sasha
