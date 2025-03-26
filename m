Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A78E248871
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2025 21:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743023184; cv=none; b=V3lJ0eeuPzNdd2yztxmblxwN8eZfOItpxgeARNE6/z5Tud2ZVt6sN0xPr0ZKzVZg47AcCetQO/db4loLxNOkL9UjWuzV2c/Ga6BjrtY1vVdQECpWAT9uSovN9yJfV3a6PvJtzyYMyDNi44+uHKL4xPHKryFlR628Vyojt7wpguA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743023184; c=relaxed/simple;
	bh=72pJSjCqsh+OJlqJ2MR7BQuBOwcPALMoOEZeWm3rTcU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uhTjGZbUQKZfeKIxp2tadJ3WmGJOfqFEJ8yLsGb4zPdrCAWT33LmfW6QTawXUWJkk+GiCMBRW0mxTkYCD85lXWLlRKr3AKmq2fPw7R5wmvz106iol64Mw10ISIISptP14XunGb8G/yj2CTh8cTXP5HwN/qSa/qcLjNuIBX7v6H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=qwArIESu; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=qwArIESu; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="qwArIESu";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="qwArIESu"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id B9885605C3; Wed, 26 Mar 2025 22:06:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743023180;
	bh=ELmoU+5r0xTL6D9jh9XM3VW1z/VyyWv+TYtUUwKtHgM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qwArIESuMuQ3BrXEy8yjVdQIJJXeXmSrfE2RWzooCPozAIK/ObE8qmK2HmNWkGptU
	 LTHUUMiNNmi1eWmhF5qD1YUibiSCmI/UtimE5LgJHRCoEKH3Q++G+KWRQh7KUA4Utg
	 i/tVqAjdLOsBTJhTLqsWSno7MrdQnjXClOBt1Uf/vVyMQiAfCu3vX+D1GiT93owq18
	 dEoOPtoewe7rik6BQjAXIuK5QBtGOXytLRuZqnumbpUsg3IrDU7olePGl4AITJJUn/
	 YY6o2nL80iAg9mWnGp8qGwb8HtSRIIwEFDKpKXprzXTjrc/dUH8IaKvaTNJiQRDuLP
	 jAAS24O+oqtXQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1E5C5605C3;
	Wed, 26 Mar 2025 22:06:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743023180;
	bh=ELmoU+5r0xTL6D9jh9XM3VW1z/VyyWv+TYtUUwKtHgM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qwArIESuMuQ3BrXEy8yjVdQIJJXeXmSrfE2RWzooCPozAIK/ObE8qmK2HmNWkGptU
	 LTHUUMiNNmi1eWmhF5qD1YUibiSCmI/UtimE5LgJHRCoEKH3Q++G+KWRQh7KUA4Utg
	 i/tVqAjdLOsBTJhTLqsWSno7MrdQnjXClOBt1Uf/vVyMQiAfCu3vX+D1GiT93owq18
	 dEoOPtoewe7rik6BQjAXIuK5QBtGOXytLRuZqnumbpUsg3IrDU7olePGl4AITJJUn/
	 YY6o2nL80iAg9mWnGp8qGwb8HtSRIIwEFDKpKXprzXTjrc/dUH8IaKvaTNJiQRDuLP
	 jAAS24O+oqtXQ==
Date: Wed, 26 Mar 2025 22:06:17 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 4/4] src: remove flagcmp expression
Message-ID: <Z-RsSTyGARhxluoa@calendula>
References: <20250326202303.20396-1-pablo@netfilter.org>
 <20250326202303.20396-4-pablo@netfilter.org>
 <20250326203325.GC2205@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250326203325.GC2205@breakpoint.cc>

On Wed, Mar 26, 2025 at 09:33:25PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >  	EXPR_SET_ELEM_CATCHALL,
> > -	EXPR_FLAGCMP,
> >  	EXPR_RANGE_VALUE,
> >  	EXPR_RANGE_SYMBOL,
> >  
> > -	EXPR_MAX = EXPR_FLAGCMP
> > +	EXPR_MAX = EXPR_SET_ELEM_CATCHALL
> >  };
> 
> This is strange, why is EXPR_MAX not set to last expression?
> 
> Perhaps this should be changed to __EXPR_MAX
> #define EXPR_MAX (__EXPR_MAX-1)
> 
> like we do elsewhere so this doesn't have to be
> updated all the time?

That's a good idea, I will send a v2 of this:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20250326210511.188767-1-pablo@netfilter.org/
