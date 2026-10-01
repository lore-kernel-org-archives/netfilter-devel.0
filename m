Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6091143E9D2;
	Thu,  1 Oct 2026 08:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790844323; cv=none; b=fpK4f26XtjhJVuE1umlPAtDzZrm1u7bqvz5kpMYsy5VdtZMExhYKfX2Sd38Gb+rGJ6Nn66BRi+hRi/Bqj5Ldr3DvURe5WxXHZS2zkLOzefMl6PhllvAN7LqrXjN8Y25e3jpCYyiR+jynIhdxy4IGMgPiBf277H3A+eK8n3TfoKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790844323; c=relaxed/simple;
	bh=IhYylikuF+2eipo20Uj+Q8itlP2GilXlsVODQOqeKT4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SkBVI5u0BHoiW9qcrX396Y9qCM0P2SKeCRoHNJt6tyZGJ/HnfLVTftMWTl/pVZolHnQUWv/JO4pvx3C4f7VWFIuSVfxCS2DnQKGPhHKwLqFQUBAQnVSDcJ64FJ5jZzFTHSjjFnA3XyuYKRCN3vG/KWpLeMem9kLJII+ZUrxyrWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RzQ91zJZ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RzQ91zJZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790844319;
	bh=nTa8ZkyRQIbxzuq9Nka8ZFVvCVtpAbM3zarnO5O0pnY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RzQ91zJZyCyvRRHE+PuX3bs9rl/j6gWHxZYJs3TpHXu6LZZblQQuUwHoXq0agALY7
	 xTXYibrL12Qd4ehQFzw6wwjk5ChES+2VzIRoTB0sgqu6POhfmhPHjLDYBgNtDj/nzN
	 LedNRn9ADsQCeK/x5Ekl75mH/4H2S4+/odHSsce1+Kns7CHEdy0iukvbXaGzgLd2Pl
	 CEDEk0FWDzJxMRMXDvoDRnORMAb/BDQxOv/hmg5rCoiD6RxaYX5LCX+cfDC2nrDxol
	 jdf14ZztT4h/D7HPM+8ImFwPcRzdBPVbc1u7CBkrMm1r7DGDmhQRWMJ5Od3OE4tdpM
	 0nrqA+Ohrihmg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id D11EE60076;
	Thu,  1 Oct 2026 10:45:18 +0200 (CEST)
Date: Thu, 1 Oct 2026 10:45:15 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Subham Pal <subhampal789@gmail.com>
Cc: fw@strlen.de, phil@nwl.cc, kaber@trash.net, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net 0/2] netfilter: nf_conntrack_h323: fixes for NAT
 bypass and ASN.1 decode
Message-ID: <ar4dmyEFr8NViDG2@chamomile>
References: <CAHeizqHDqx3ue1=0QL92ef+6C63Ur+v1Z=d93smgdD5zTj_-Pw@mail.gmail.com>
 <arORyXjxvZUoEAIw@chamomile>
 <CAHeizqF--yGMCLGBEv9f7Gs=dmbZO6+DwSh7KZjpDgbNonCotA@mail.gmail.com>
 <CAHeizqEqOx_bTJdNaUYGc1Mc_dcWbY6ybJNmo9uKMcyBPVLS1g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHeizqEqOx_bTJdNaUYGc1Mc_dcWbY6ybJNmo9uKMcyBPVLS1g@mail.gmail.com>

On Thu, Oct 01, 2026 at 10:09:45AM +0530, Subham Pal wrote:
> Hi Pablo,
> 
> Just following up to check if there are any remaining questions or queries,
> regarding the multi-vendor testbed I described, or if the series is
> ready to be applied.

I am not sure this is really fixing up anything.

If any, this should go to nf-next because this does not crash the
kernel.
