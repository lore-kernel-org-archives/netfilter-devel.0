Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498741885BF
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2024 21:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728509196; cv=none; b=NomLRhEp3FxOW1DO+sNizfMe4hctYQlYGabAQLVabyN15rJhWRtAcp5KGSvnmz/Rih2FfFmTXkTNzvRHVyNt26Z8TMJG+7mLI9x2QEvYIN7VweAIFhxUGD1UCLtXv2X1r6Iq7iA/MjC5Jv06XvKFViSNUAuARj2xfNwjdorbogQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728509196; c=relaxed/simple;
	bh=BAq0tSj9nk8JUPcZHphIHRKE23pSYNFySXzHahXhi4s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XlZqmoTzSFqlhqCYTjI5A44Cafkef5JUkDNrwuJrB8o2isfxHZW28xx/2HWYThO4cgA7dj/L4IQbVz47oW4Sc7LoX1Ctye8k736UkfVR98KmTO78VlzfKLS191QiLOIFmVfUYO+x60uZ0EaNgpmW/GTiNRVHA4zLRjmK+G31yTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=47706 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1syeCT-00BxLz-Nj; Wed, 09 Oct 2024 23:26:31 +0200
Date: Wed, 9 Oct 2024 23:26:29 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 1/2] netfilter: fib: check correct rtable in vrf setups
Message-ID: <Zwb1BYZPxcxgvRZZ@calendula>
References: <20241009071908.17644-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241009071908.17644-1-fw@strlen.de>
X-Spam-Score: -1.8 (-)

On Wed, Oct 09, 2024 at 09:19:02AM +0200, Florian Westphal wrote:
> We need to init l3mdev unconditionally, else main routing table is searched
> and incorrect result is returned unless strict (iif keyword) matching is
> requested.
> 
> Next patch adds a selftest for this.

Series applied, thanks
