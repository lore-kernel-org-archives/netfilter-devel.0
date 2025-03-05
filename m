Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BAE253F01
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Mar 2025 21:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741209078; cv=none; b=EczFlJHr3BwnZwQrZklAvP4MrF4oFvfM+EBaoUw3DJ9E9kYCMffZa5WNhqWTZOqS1Zu8BuYT8k5YHfNCPs1K5c3GH0nH3wmuAyKM0KJCVJk0E+aJeQIB+QFcTy71ZSNJnRM07B/ZxqsUdE/Tked2COfapLH9PkWm0bO9JGTZtKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741209078; c=relaxed/simple;
	bh=NBLVzrm0ApVo0u5axN8yMGUwhRs3FarqtvpSfAGkXnE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LwVuIf2KsExYEbqosLWR4cFhHVFhaAd3LCxnzPYfA8JzEREJjlVpOmHsS46FztycijSakg+VDWugQRdmfo5VaOMh5/SIVLr9VdebiJqr1ZsJDXkumS9gXGHb7Tx2PbuWwaQEpZaIxK10mkWsf1kmqzWaGYHbHqIFjPKidAvXs/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=L80bgWdE; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NvOPuEtD; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="L80bgWdE";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NvOPuEtD"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 4ED20602AD; Wed,  5 Mar 2025 22:11:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741209073;
	bh=kpaRfYX4csBspQlBgU1rwrZ7NS0ROfZnySpXLiqljYs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L80bgWdEVYjuk+uLjfvREpVvsn58L5ms2n+Gtei93Fh8IjChwh2HKGPNyJ9Z59/rf
	 mcfpT27w5KhXbBdSaRD6dyNTwNrxFZQFiP7eo5q7IHqm+UpDHzOUMGSg/8HTD4mtwB
	 6OUt4hdlSpmB1l1yMyjnQsoU+HkP4TilUQFDtmVms09m/obPif5SCLCmBE1qrWeRhr
	 eWjyfhvZt0y1UncB039+2Mu+o995QM9TfIrSqGaULfSrs2Qg38BdFthF13CVkqKj7l
	 4RNMBYHH0knvbr1SHGuNT5g37UaEee9vNJ8DmTfFCoR6HCb1XcrZ+zE8tjm8k+88Ty
	 R5MioQ6h7x8Jg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8C9D4602A0;
	Wed,  5 Mar 2025 22:11:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741209072;
	bh=kpaRfYX4csBspQlBgU1rwrZ7NS0ROfZnySpXLiqljYs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NvOPuEtDnGI5KcQavBMp8vT63gYwzsdmerlRJYUVJxqjbQ5Q09yD19GOW8GN/gGjs
	 maBSsXd3Lx3huJ0ZEoAYSi23kjcE5MUvdrFLeheKcMHc/1bW55q7ZpLa0rjWUhOnK0
	 ufJkoWZ0Xq6WH38/KDOTAuNe460Tmrb+MojTIJXU4oz+ZbGuAMYKZboj13v/yQMTmS
	 Zhsjb19eaUh6vopK7wWRssLRuhmXSU4pVw7qeZepWnKfV7l580aC/KifP+lhBl4DG8
	 /IJkjfqGk01z4eybt65E61J/8E3fOPt48Dy2Q7JLJxKcOJHix3B2rEPgNZtEhKHQrS
	 xlX1fv5ymNxPA==
Date: Wed, 5 Mar 2025 22:11:10 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Xiao Liang <shaw.leon@gmail.com>
Subject: Re: [PATCH nft] payload: don't kill dependency for proto_th
Message-ID: <Z8i97mgqSWoaXCV6@calendula>
References: <20250227104705.9283-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250227104705.9283-1-fw@strlen.de>

On Thu, Feb 27, 2025 at 11:47:02AM +0100, Florian Westphal wrote:
> proto_th carries no information about the proto number, we need to
> preserve the L4 protocol expression unless we can be sure that
> 
> For example, if "meta l4proto 91 @th,0,16 0" is simplified to
> "th sport 0", the information of protocol number is lost.
> 
> Based on initial patch from Xiao Liang.
> 
> Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
