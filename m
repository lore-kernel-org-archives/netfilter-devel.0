Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19B44AECA;
	Mon, 18 Mar 2024 14:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710771592; cv=none; b=gRiKHIw/s2x3U9jv28Jlxhs6Jbyyi9XYZOK0urc+oM2l/DIC/MBEVQu28PXaHw0OIkEBkyv8VmaxjlsOwxXfqBYeeYDzPhXoRyKtAbLQm0Y7BoHO7N2xqE+wwAioivI0qC0yEfMzOpRvgjXAGIijFKkSVblFu7QrRxQcoz/KdwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710771592; c=relaxed/simple;
	bh=TmP3ZdyfUwCNYYmuWjllMeA2Wj6w/F5tiiUhHy7auVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JQJ9iAAPOyH4BS2mfOkJ/pNR4SS1mTkIrAdGqF+L+0jyPKW/KMyr6sJQdCEHGC3Jh6xGByQn7hGamdBhSnEpJJGH6Waz0CTyFYuBVr9gWLSMJcWGuYr483DsC1Xx3Giy0y9EHI6iwzNBD5cicBmMJu9ps+90XEhTba58W6upRl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rmDq3-0006hc-HA; Mon, 18 Mar 2024 15:19:43 +0100
Date: Mon, 18 Mar 2024 15:19:43 +0100
From: Florian Westphal <fw@strlen.de>
To: Jianbo Liu <jianbol@nvidia.com>
Cc: "fw@strlen.de" <fw@strlen.de>,
	"pablo@netfilter.org" <pablo@netfilter.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [BUG] kernel warning from br_nf_local_in+0x157/0x180
Message-ID: <20240318141943.GA23181@breakpoint.cc>
References: <ac03a9ba41e130123cd680be6df9f30be95d0f98.camel@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac03a9ba41e130123cd680be6df9f30be95d0f98.camel@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Jianbo Liu <jianbol@nvidia.com> wrote:
> Hi Florian and Pablo,

	I am sorry for being such a failire.

I can't figure this out.

I'm done. I am resigning from maintainer role.

