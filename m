Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195C21C986E;
	Tue,  3 Sep 2024 08:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725353081; cv=none; b=mpKO5xOQ78O0ToSedrCH4E62lP2ZEZXW+OIHFQLU8iXm0bgcqDrlwYk6nCRxqpuMrZQNSFUrw5nplDq0WdQXM0x4pX5nHAU5a3zou+U4okbYE5Q9jR/77CRYuPAo8NUFFBbZl/5Ua++j5i3CgyUECxGnsOS/A0u+v1jz+JtFhI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725353081; c=relaxed/simple;
	bh=NqoJn9iurYRSAGJB23VQCprq3nW80csbT5HId7Aum88=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O8D6z1fDQ0nr45D2xSmNUkstbuBVdBmYkfc4uUlkR2p4BdRWAMmT9Q0AMsFIWh5SN8XjiL39zYEq0k1iG5g0SZPYpwgSf87vvWDdGxWNJXYq8xcsCpG8fsTbW0zn2onIndcrElyzIinvA6RM/pp6Y1K+vOkOAK0s40uXHXgCEw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=52890 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1slP9N-00AF4T-Ma; Tue, 03 Sep 2024 10:44:35 +0200
Date: Tue, 3 Sep 2024 10:44:32 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Yan Zhen <yanzhen@vivo.com>
Cc: kadlec@netfilter.org, roopa@nvidia.com, razor@blackwall.org,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, dsahern@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	bridge@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, opensource.kernel@vivo.com
Subject: Re: [PATCH net-next v1] netfilter: Use kmemdup_array instead of
 kmemdup for multiple allocation
Message-ID: <ZtbMcPj7W_QS3-sR@calendula>
References: <20240826034136.1791485-1-yanzhen@vivo.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240826034136.1791485-1-yanzhen@vivo.com>
X-Spam-Score: -1.9 (-)

On Mon, Aug 26, 2024 at 11:41:36AM +0800, Yan Zhen wrote:
> When we are allocating an array, using kmemdup_array() to take care about
> multiplication and possible overflows.
> 
> Also it makes auditing the code easier.

Applied, thanks
