Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD9C1E3DCD
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Oct 2025 21:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759873255; cv=none; b=FT3gvJobTt2T0KG3oCjSizNoBx5F2zlzCd+oeNEGN4kWNi4OXpxpBxJY4BUto6Op64TmAzMuVE7pRknuI1aYazxQ5d/zaTVzMv+y1biN4pKspfQ3cVHujv2Yabd0vP7StEw0tW1kwZfyTo9MLtLMZok0zihuyw+VP7RAR0vk/QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759873255; c=relaxed/simple;
	bh=Oa1DYVqG/lrQWJY4tLLa3klGbQxlsGsi0qbxjsx89Q4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iJjsMxk/gEhs3JcobjyHuyD0WKdzVFcHMKt/0Le37J/Q5nIexSSBZooZZyzgscEY8ny2NaX9jEDXjwwtg701Zi5dt2T+6vWe7s1GHKm9oAptFNZKxnHqtvkcUc12GHpczBlOXhOSeOAEOBi/aaRQXwxfERgbseNO0AP6p+HfDSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ONwSlrXI; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QxgNRxwr; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ONwSlrXI";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QxgNRxwr"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id AD23360262; Tue,  7 Oct 2025 23:40:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1759873249;
	bh=TVASY6hLSvzq+xBrrGDrEsJtNWk4D01hSproAV8NbtU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ONwSlrXIFq/PAuG/YgLxriPudxKIfBpTJb5MLNs4WDtceZvOGWlQSKyelRbwvKTV8
	 XBiT+zllefLtS+RKJt8OeP4JkLMykpeSBACRUO8KHM9WCe/DUR4yXwD6ZFoqot7+OP
	 TZAtLGwR4crSnXZbQ2I3LyaQop/EwKQZJAByyMr+8LDZoh12l01jMss386PkJ5cA9u
	 Noa4fpYDAzwd0+x8ZXsU7FxlYyuzBEXpM+ULv8ffExDbCCElL7cyghsK9nJ7A9D7k1
	 J1nthDWB6RIA4hQTDg7iJ4GMIesHHCeP50b7D3Mrhflp8R7yNroP5lOYV0QtSoOAJm
	 IXpEeWaGzNbSA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CB13A600B9;
	Tue,  7 Oct 2025 23:40:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1759873248;
	bh=TVASY6hLSvzq+xBrrGDrEsJtNWk4D01hSproAV8NbtU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QxgNRxwrOo3tVqwCo1Ba3kooYaAD7qB/2E9bBbGJyrJ0g0ENnheJA4C98ERY8D4SS
	 Dyx9EUogUdMA0NbUIYxgv8TgRr9ybB59tLtd+jhnXIXAx66tFCQwx+saJBEWZE8OWc
	 bZC7WiAfSmvJp11RF8wCIKoQAJo3ou+LEGQ1tU9kaB9Ql+fmnl+j59q1z/mkrQNyRW
	 eQ2Xt86KkUwjE478D2Ts33Mzzme1wB9DPQsoEGf3Wshsig7v69GzBH4YRa9oKrQiu2
	 GbaGp3ftbRm/ILT9vz72BUS1VtbDLlR9vLSSVEp2SYmQ/h0xoD3LFhgvYxnIv8wBGE
	 WiDxSFqB7w8iA==
Date: Tue, 7 Oct 2025 23:40:45 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] mnl: Drop asterisk from end of NFTA_DEVICE_PREFIX
 strings
Message-ID: <aOWI3X4pXUGkLjZo@calendula>
References: <20251007155707.340-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251007155707.340-1-phil@nwl.cc>

On Tue, Oct 07, 2025 at 05:55:17PM +0200, Phil Sutter wrote:
> The asterisk left in place becomes part of the prefix by accident and is thus
> both included when matching interface names as well as dumped back to user
> space.
> 
> Fixes: c31e887504a90 ("mnl: Support simple wildcards in netdev hooks")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks.
