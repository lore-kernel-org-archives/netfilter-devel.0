Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E9914F136;
	Fri, 18 Oct 2024 16:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729268105; cv=none; b=vGQpgG4r+cx5eSfcGZ+EMH3fcsnLgkVqv/yBZE9JIXGEQCPPgSgNv/rILd/M+5IE1sXotmmBfYQf8/P6du7QUUkjsluWZdFqQgJG1y1KCvCD/yzN9wvCsTwc1XEA2/ldNts8w19ItG5b4jDwX4G+lKI7GOlELMa80qYEIRKdG2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729268105; c=relaxed/simple;
	bh=HiNOUOcHP+DFYzrL197loAtgVwl+t1N6n3BFuflm3gQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bghk49ls5czQM/MyWbViKEH9/T63jWa3yoE8j8d7Z/MZsQ8fEjNiJQK4ENqWYe33BUVp/WLwnox2YDh2nTpEKm8zyoMNjNmer6WEEckqHzJ8sHR4Bu+90KNVJfAPieRvG2EiyINwbUG9+uh5G+sHBPWVfuHD5nW1IuPqzT2kIvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=UZbcTX8V; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="UZbcTX8V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=njJXmmHlyrmifSwhGJ3xAOTJk+rOjt68DUMLWt+BY3E=; b=UZbcTX8V63cA7mvfnaAKoMA9t5
	jIzYM/MQD9zRcjCNOu0jLDtkQ7S2wsK6IJ/KZM5hTbb1IZZtz7wn0yxZkzzlSK/Lsdv6cp26BlNlk
	/mIzGIslzLXFXF1/7GRGvJxNohqdFbMr/aqCggLMiBvG7q7sD+LEX8rzVdabMI8eQQVTOW383Kepm
	MuMubAAuOhjbtsfjeiuk2QUr5MbTiIQgh/S7rzmc5i1yEo1WHWHwrSF1k0v/oKirETNVETuGbY5Ra
	gX6pxzp4D3g439UnBCPrLmO/+A9Rb1y4Px3UfdRom25ID3lBqauaYdnX7V/z1TaGgSv3M9fU7ztIF
	HrwJ6Pzg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t1pcp-0000000040f-1w41;
	Fri, 18 Oct 2024 18:14:51 +0200
Date: Fri, 18 Oct 2024 18:14:51 +0200
From: Phil Sutter <phil@nwl.cc>
To: Ilya Katsnelson <me@0upti.me>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Florian Westphal <fw@strlen.de>, Sasha Levin <sashal@kernel.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfliter: xtables: fix typo causing some targets to not
 load on IPv6
Message-ID: <ZxKJe9sPze2mEJvF@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, Ilya Katsnelson <me@0upti.me>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Florian Westphal <fw@strlen.de>, Sasha Levin <sashal@kernel.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241018-xtables-typos-v1-1-02a51789c0ec@0upti.me>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241018-xtables-typos-v1-1-02a51789c0ec@0upti.me>

On Fri, Oct 18, 2024 at 06:45:00PM +0300, Ilya Katsnelson wrote:
> These were added with the wrong family in 4cdc55e, which seems
> to just have been a typo, but now ip6tables rules with --set-mark
> don't work anymore, which is pretty bad.
> 
> Fixes: 4cdc55ec6222 ("netfilter: xtables: avoid NFPROTO_UNSPEC where needed")

On my system, the commit is 0bfcb7b71e735560077a42847f69597ec7dcc326. Is
that correct?

> Signed-off-by: Ilya Katsnelson <me@0upti.me>

Reviewed-by: Phil Sutter <phil@nwl.cc>
