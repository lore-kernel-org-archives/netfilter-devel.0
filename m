Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DEF2F7AC1
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Oct 2025 12:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759925674; cv=none; b=GCU408nWnOT+QkCTtQMOGZ9bDPvYmriwuZo4nWcHmqT+2jNYcVOyiPn+/odGaux/ydRCDhZ1o/FZsI+1oH6ToQrTynB9dngl2UxYwGwckAwT3V4MxkTe8Uoj1NU6kWRdcKvWzH9/aZhNsaRDy7Lq5NlPvPz0SgJeiZ6dfZUpXQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759925674; c=relaxed/simple;
	bh=vjhDQVYga+g0YBWJ/p14m6Z1QNbbzJBRbTSNCmMUss0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cTzn6tgV6OXEiyaBT/Qdk6KD/Y8l6WqyRzjx0fZSkRmYGoj0jcRg68KFhNdp42enUlcuDqwGlSmf29K2AmPH54cG+RFKIe3yi2WyCuKBuJI8zCdO2+WwpohUBYywTAgw4KSf+/zZPp3cDzbUVcoHm6YZll918JGvbMvR+OFa5eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ZrxiG/08; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ZrxiG/08"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Cfwf2BaT3nWWxgvy3uR0D0pLRPt/jKc8gmTDTIcO7ZM=; b=ZrxiG/08YqvAo/Wv7jj5zc7CoE
	z6R6+mbjWxlqHw+v93/g5hE87wx5n3vKFQ66UC5fUt8N07EUmNWAo/tWyBGArVzwjT8TaA4+e0I3w
	LxuO7riZW4j0F8uVUfmqf32KXcf1qXno0+BpyjSbRz+Ndr7YFchdNsoGpXdjls+GfVDqpwZbjE2Fx
	HR+EVTh1NlePZ76j0/r7D/rHvXiV6M2xX0BjRymmgycrHBnxIzPyS5+RP8O6fxuJVYqn7dHCPb3Xl
	OTnIF2ZQAuQXOK5QPYif/iXxVJfLMPuYzVrKreXhSTJY0ztN0yoNdh1c/s/o/oAa89gGDTgeXVFXt
	gh1P7A4Q==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1v6T3s-000000006HJ-0cs5;
	Wed, 08 Oct 2025 14:14:28 +0200
Date: Wed, 8 Oct 2025 14:14:28 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] mnl: Drop asterisk from end of NFTA_DEVICE_PREFIX
 strings
Message-ID: <aOZVpMCm23XKryRm@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20251007155707.340-1-phil@nwl.cc>
 <aOWI3X4pXUGkLjZo@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aOWI3X4pXUGkLjZo@calendula>

On Tue, Oct 07, 2025 at 11:40:45PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Oct 07, 2025 at 05:55:17PM +0200, Phil Sutter wrote:
> > The asterisk left in place becomes part of the prefix by accident and is thus
> > both included when matching interface names as well as dumped back to user
> > space.
> > 
> > Fixes: c31e887504a90 ("mnl: Support simple wildcards in netdev hooks")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> 
> Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Patch applied, thanks!
