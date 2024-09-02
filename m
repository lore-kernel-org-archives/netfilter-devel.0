Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA59186287;
	Mon,  2 Sep 2024 09:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725269164; cv=none; b=WmmNFaaACkNKeJJFMm4JwZih7s3LD3JowxwsGlN3cop/+QSg48sIKMv08W5b1bkdkrOhpKbPEesEtPs8a5xjPW/FAwB8cmVVw3OFb78E3geci612nt267NxzRWVJN7GmVDqr4yDnp+sTEgeMkhR/1YXRWTxVnqXokx2hbycPKGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725269164; c=relaxed/simple;
	bh=QhDTm4HJF/Ht+jrsMbiuFTYROIIyP9rnmpAZHvX+DHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VxgHGT6YY9T2OYFpNkvmnZRjSO41naaNSeO8iWpzRZVigkWpb40AzxCyb4NLQyGnwWUMEvBas57Iq6GlOaYVx21xd3ZKtNi7b7rnTEja/XzpjYYxY8TmjGQXllLNi2aIy8puAUuPEd22RC1gppVgQy+UyZDnxqf+RzZtUw5TO6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hhU9U/fl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hhU9U/fl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023F1C4CEC2;
	Mon,  2 Sep 2024 09:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725269164;
	bh=QhDTm4HJF/Ht+jrsMbiuFTYROIIyP9rnmpAZHvX+DHg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hhU9U/fl62oZDkmdWRFx05vx7xX12dY+EjXBn3eQuOoDaUBcztLa3NYsVVdfn6goC
	 dRop+SfqBnkPMLruVAo5/abgmMq9sJBQ2rwVuIRJQAfkPEwUwnh/8GwWMEqNug0pGv
	 1cFXMy+/kKP7fFKvS3gkvs+2Dxv9NRd6HKpL/QfCEg57aqKqhLv90nUvAE6rt/95Kr
	 n6W/pTPsNxeT9vLPLIOvAMhQM0yJTGsd0IEcX1AXS4Qie1bS4Z9DhTjt8tiOl3EJhY
	 R6+UlMUGEr942sMQJYYsoQ6jDGrU+KfNUhpXaOh11asyLya3rfkz6Pmmpp2cJlog9l
	 ILN4b/+LEuaCQ==
Date: Mon, 2 Sep 2024 10:25:59 +0100
From: Simon Horman <horms@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH nf-next 0/2] netfilter: Add missing Kernel doc to headers
Message-ID: <20240902092559.GF23170@kernel.org>
References: <20240830-nf-kdoc-v1-0-b974bb701b61@kernel.org>
 <20240831200307.GA15693@breakpoint.cc>
 <ZtTJfzkFWlNgpVO-@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZtTJfzkFWlNgpVO-@calendula>

On Sun, Sep 01, 2024 at 10:07:27PM +0200, Pablo Neira Ayuso wrote:
> On Sat, Aug 31, 2024 at 10:03:07PM +0200, Florian Westphal wrote:
> > Simon Horman <horms@kernel.org> wrote:
> > > Hi,
> > > 
> > > This short series addresses some minor Kernel doc problems
> > > in Netfilter header files.
> > 
> > Thanks Simon, this looks good to me.
> > Series:
> > Reviewed-by: Florian Westphal <fw@strlen.de>
> 
> Thanks for reviewing.
> 
> If you both don't mind, I am going to collapse the three pending
> patches from Simon that are targeting kdoc stuff.

Thanks Pablo,

No problem with that from my side.
