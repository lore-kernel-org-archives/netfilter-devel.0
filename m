Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0061C767E;
	Tue,  3 Sep 2024 09:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725355339; cv=none; b=PEeanbr5yPeGV+HQxKBUk3oQnmz+c/skS7dUzbROwisHUgYpcUYhu3nJWKsMVZmZJX2GTdooB2JeLDu/XjeJ7iwOX54/7869CZ/Snb34jE9ZM+h+vVCJgW85G/BkVYn75mf+hJ6dmAnMv7PJw7Av1Ur3jvmtiElryxNsNFxLYSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725355339; c=relaxed/simple;
	bh=+jpS8dvfpaDCvDQD27QYkU/MBTXQBGZl8pEB1qBPWzw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j8f/fo3smjpw4ZMLPeTH5SfvVlBSY6W3Lu/E0BTRwQSdGj82iy5+NuaNuDVsfAejPOlrxsIUwJhxEcHhdfTn4t9PKwlGNcZfE+5wO+7REYwMGmzU31esAyVODxtacr7VS7HHH1BAjaavrZJCmdSYl9AiN1sO/VzRBbT6ahUzjvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=59208 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1slPjo-00AHVs-HH; Tue, 03 Sep 2024 11:22:14 +0200
Date: Tue, 3 Sep 2024 11:22:11 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Simon Horman <horms@kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH nf-next 0/2] netfilter: Add missing Kernel doc to headers
Message-ID: <ZtbVQ5Svyw6VWx8L@calendula>
References: <20240830-nf-kdoc-v1-0-b974bb701b61@kernel.org>
 <20240831200307.GA15693@breakpoint.cc>
 <ZtTJfzkFWlNgpVO-@calendula>
 <20240902092559.GF23170@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240902092559.GF23170@kernel.org>
X-Spam-Score: -1.9 (-)

On Mon, Sep 02, 2024 at 10:25:59AM +0100, Simon Horman wrote:
> On Sun, Sep 01, 2024 at 10:07:27PM +0200, Pablo Neira Ayuso wrote:
> > On Sat, Aug 31, 2024 at 10:03:07PM +0200, Florian Westphal wrote:
> > > Simon Horman <horms@kernel.org> wrote:
> > > > Hi,
> > > > 
> > > > This short series addresses some minor Kernel doc problems
> > > > in Netfilter header files.
> > > 
> > > Thanks Simon, this looks good to me.
> > > Series:
> > > Reviewed-by: Florian Westphal <fw@strlen.de>
> > 
> > Thanks for reviewing.
> > 
> > If you both don't mind, I am going to collapse the three pending
> > patches from Simon that are targeting kdoc stuff.
> 
> Thanks Pablo,
> 
> No problem with that from my side.

Thanks Simon, I have collapsed these two patches.
