Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B8B176248;
	Wed, 18 Sep 2024 11:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726658474; cv=none; b=XAaH3sNBRh0aEt0vXBbggs0mcEjxT//6YGuG2UTObrq/YpziH+dSY1wYhaeE3cL4sNwzh9oncySk4NeU/RZ1KA2O/lPD7xATcwILjaqXHPfNwDQB2nMgZcNTMIE0G1bGFcThaMLucSRUG7voB7eivnRV8FIx/w1bkkJ7zs5GdvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726658474; c=relaxed/simple;
	bh=rhyNmR8hAjJ9SSA7CFA1s3XYnMcGfkB27v3q2tu/ZaY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H7ewy8gB1QqVVyjQQjNZ/fMDpLOHH7Ng/Z07DdAfnWM47uQStJEtJuzlR2aPo0+MhFqN4v0X2WzEh1G7Ua4aTvmsGeK1F1KS9khoxGvQvrvLjn5KXvos465xTPsX7FGU8hGGEVeV5qn3Rf+EBuZycgGJMWYWZuqJIFOWB5YhEEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=49978 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sqsk3-001Kge-3o; Wed, 18 Sep 2024 13:21:07 +0200
Date: Wed, 18 Sep 2024 13:21:02 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Breno Leitao <leitao@debian.org>
Cc: fw@strlen.de, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, rbc@meta.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v5 0/2] netfilter: Make IP_NF_IPTABLES_LEGACY
 selectable
Message-ID: <Zuq3ns-Ai05Hcooj@calendula>
References: <20240909084620.3155679-1-leitao@debian.org>
 <Zuq12avxPonafdvv@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zuq12avxPonafdvv@calendula>
X-Spam-Score: -1.9 (-)

On Wed, Sep 18, 2024 at 01:13:32PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Sep 09, 2024 at 01:46:17AM -0700, Breno Leitao wrote:
> > These two patches make IP_NF_IPTABLES_LEGACY and IP6_NF_IPTABLES_LEGACY
> > Kconfigs user selectable, avoiding creating an extra dependency by
> > enabling some other config that would select IP{6}_NF_IPTABLES_LEGACY.
> 
> This needs a v6. There is also:
> 
> BRIDGE_NF_EBTABLES_LEGACY
> 
> We have more copy and paste in the bridge.
> 
> Would you submit a single patch covering this too?

There is also:

# ARP tables
config IP_NF_ARPTABLES
        tristate

which has never had a description. Could you also add?

         arptables is a legacy packet classification.
         This is not needed if you are using arptables over nftables
         (iptables-nft).

There is no need for _LEGACY in this case.

Single patch to update them all should be fine.

Thanks
