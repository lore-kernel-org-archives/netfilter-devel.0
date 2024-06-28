Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486F5153BFC;
	Fri, 28 Jun 2024 13:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719581786; cv=none; b=hefrQowZ3ZEop3J2wstdoolN4IkaszeOn2zosbA8usuG9Y23+kuvRDsbXjIBEslNNuxTRaNKodkx9Ts12rQ9w/Hnwv+fMhOyt0OTK6PnBNXXCgqVHBM6s9rGn6FPwyVOyNX8r3a3O050NxAeJhcoXFRzyVtI9I37LDLbQQPg7A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719581786; c=relaxed/simple;
	bh=kewPDxjTMN0zz99NycBTyKz+VMkTjy03JOP9lMlVMU0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dw6p0orv/+fu2S3exZgZAXWhffawwwhK8wPc8rSnCLfnl1WY95WKb17f3Dfx4coJVHAfhMVuBLRO2rUjW3IqkEG5FRxadSnFg/3jI7nGf3d7h0wvSEMd6RGRNhDkLRN6h45rpRLe0XMdUlz61VBGmXnKLMFmAYSAM3cNbQszkE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=51360 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sNBlu-00BGd0-K5; Fri, 28 Jun 2024 15:36:16 +0200
Date: Fri, 28 Jun 2024 15:36:13 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
	fw@strlen.de
Subject: Re: [PATCH nf-next 00/19] Netfilter/IPVS updates for net-next
Message-ID: <Zn68TSp26P_QlSjh@calendula>
References: <20240627112713.4846-1-pablo@netfilter.org>
 <Zn1M890ZdC1WRekQ@calendula>
 <20240627113202.72569175@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240627113202.72569175@kernel.org>
X-Spam-Score: -1.8 (-)

On Thu, Jun 27, 2024 at 11:32:02AM -0700, Jakub Kicinski wrote:
> On Thu, 27 Jun 2024 13:28:51 +0200 Pablo Neira Ayuso wrote:
> > Note for netdev maintainer: This PR is actually targeted at *net-next*.
> > 
> > Please, let me know if you prefer I resubmit.
> 
> Not a big deal, but since you offered I have another ask - looks like
> this series makes the nf_queue test time out in our infra.
> 
> https://netdev.bots.linux.dev/contest.html?test=nft-queue-sh
> 
> Could you take a look before you respin? It used to take 24 sec,
> not it times out after 224 sec..

Please, ditch this PR, SCTP support for nfqueue is not yet ready.

I will submit a new PR without these bits.

Apologies for the noise, thanks.
