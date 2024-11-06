Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AA61CB310
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Nov 2024 13:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899724; cv=none; b=Pcxp/g9N+FWp20UXt5taG8srnaVhnZjwmrzf0w3uwIaKbNJCh6k4q5JHEXkLszHzoi/cZ9NT/YIiluXmQWgunOT8Sabfnq/1UAp5vXpC+4dyCPiXcC7qkV9zuR22ZrN+tYsipxJCwST7LEOWZCwKsplmL2kjLK227S6fKHRDMRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899724; c=relaxed/simple;
	bh=FxHs4y9eH8FtdyvjaY0kK/8NKSKjztABZJ2PB9EriPs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FrOMrWV3dgfoHMgU8gwACat6YiH//OmhE2gtP0GaShyIUEVU6SCZU9OVfw+nv1Yk6sqvj/fDhdNDuC08gtcR/XJVTXgj7LnYull0RmOcFaxoiz3/lI+tht4dBzrbpHw2L4ixrZgxiL6FNBKAxAh8mq2yMkbwhFD3XLVTrdANkgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=53636 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t8g5G-009iyL-Ew; Wed, 06 Nov 2024 14:28:32 +0100
Date: Wed, 6 Nov 2024 14:28:29 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: allow to map key to nfqueue number
Message-ID: <Zytu_YJeGyF-RaxI@calendula>
References: <20241025074729.12412-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241025074729.12412-1-fw@strlen.de>
X-Spam-Score: -1.8 (-)

Hi Florian,

On Fri, Oct 25, 2024 at 09:47:25AM +0200, Florian Westphal wrote:
[...]
> @@ -447,6 +457,9 @@ extern struct expr *relational_expr_alloc(const struct location *loc, enum ops o
>  extern void relational_expr_pctx_update(struct proto_ctx *ctx,
>  					const struct expr *expr);
>  
> +extern struct expr *typeof_expr_alloc(const struct location *loc,
> +				      enum expr_typeof_key key);

I think it should be possible to follow an alternative path to achieve
this, that is, use integer_expr and attach a new internal datatype,
ie. queue_type, for this queue number.

No need for new TYPE_* in enum, that is only required by
concatenations and this datatype will not ever be used in that case.

For reference, there is also use of this alias datatypes such as
xinteger_type which is used to print integers in hexadecimal.

From userdata path it should be possible to check for this special
internal queue_datatype then encode the queue number type in the TLV.

Thanks.
