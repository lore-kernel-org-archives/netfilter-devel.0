Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DF5227FBB;
	Wed, 25 Sep 2024 12:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727266639; cv=none; b=K0HErD0hVV/NJRzHHwMHyjorG9Ujmf7cB1xxFk4e8a+UyCiWavuUPhLMN+ZxnHjlDXUXkWd7pm418XQVc1SNgwqWmuNchn1PcwqWvKcLwEL8Iy71gl0UM/QZ/PsTV0XfJKiWrDZ/eWar34ssN+gLkntMhudDzS0rrgbHHA8gY20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727266639; c=relaxed/simple;
	bh=8BgnRoC6xEKzYPbgp/nm/ASC3dzKrb4J/9Jn0ZwgG0c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KsqABLiLU+/7kT3lGGAs8LzVDE0nmIK35sCP33tmi7l8uf66Mp401SJzwF8rqkzU532RojBk4KP4ctkpg7jsPw0cfAa4Q75/3ott+XLQwRUFIsRZ/RVtm2Y2qfdAQvQn8Tj8AVyP78Y2ubrY3+zLdMWDSEhvpVAm/4F/svOHfxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=59158 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1stQxE-0006jg-99; Wed, 25 Sep 2024 14:17:14 +0200
Date: Wed, 25 Sep 2024 14:17:10 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Florian Westphal <fw@strlen.de>, kadlec@netfilter.org,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.11 049/244] netfilter: nf_tables: don't
 initialize registers in nft_do_chain()
Message-ID: <ZvP_Rh4Hsr3dqknY@calendula>
References: <20240925113641.1297102-1-sashal@kernel.org>
 <20240925113641.1297102-49-sashal@kernel.org>
 <ZvP6-utbwqWmP5_0@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZvP6-utbwqWmP5_0@calendula>
X-Spam-Score: -1.9 (-)

On Wed, Sep 25, 2024 at 01:58:54PM +0200, Pablo Neira Ayuso wrote:
> Hi Sasha,
> 
> This commit requires:
> 
> commit 14fb07130c7ddd257e30079b87499b3f89097b09
> Author: Florian Westphal <fw@strlen.de>
> Date:   Tue Aug 20 11:56:13 2024 +0200
> 
>     netfilter: nf_tables: allow loads only when register is initialized
> 
> so either drop it or pull-in this dependency for 6.11

same applies to all kernels below this 6.11
