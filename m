Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82CF6433C4
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Dec 2024 14:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733323539; cv=none; b=EZgd+OntmIc4sus+EktEpzTkykbk4D1cFtLAYTUkeQ5ijYnzVR9BiNJ9I6iZdRDBxT+UntIUZk326VgXLM9YH4iSunyNsJ7dMdGvBbyg9BDYxa8ZfNMda9RVksWNuBST5wcXlyEu+j7t6wCkPQ1LLhazmpn1+aMSe5avb6BrqgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733323539; c=relaxed/simple;
	bh=ZTIxemQ2NeYFfPfIRCSI6IFulM3qSvghFyF86pcUsgk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bSE47aoc4eWeKJMbLxDZzHAUn5smjSXn5eCj+VZun4WLYiFmRgayi02NnV/qn1e56TKt0BwAmDh+a/3jhjSJuNbcJamePaFUkhSCdrFtgaDYCo6BadQ8h1IMH84NJGxXQhLTaQS3kb76ekev8O8pm1V6psHc6Glf33DmYdyH5pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.39.247] (port=34144 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tIqd9-009BpT-EO; Wed, 04 Dec 2024 15:45:33 +0100
Date: Wed, 4 Dec 2024 15:45:30 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: jeremy@azazel.net
Subject: Re: [PATCH nft] src: allow binop expressions with variable
 right-hand operands
Message-ID: <Z1BrCr7-3yhmqcZt@calendula>
References: <20241119123158.185298-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241119123158.185298-1-pablo@netfilter.org>
X-Spam-Score: -1.8 (-)

On Tue, Nov 19, 2024 at 01:31:58PM +0100, Pablo Neira Ayuso wrote:
> From: Jeremy Sowden <jeremy@azazel.net>
> 
> Hitherto, the kernel has required constant values for the `xor` and
> `mask` attributes of boolean bitwise expressions.  This has meant that
> the right-hand operand of a boolean binop must be constant.  Now the
> kernel has support for AND, OR and XOR operations with right-hand
> operands passed via registers, we can relax this restriction.  Allow
> non-constant right-hand operands if the left-hand operand is not
> constant, e.g.:
> 
>   ct mark & 0xffff0000 | meta mark & 0xffff
> 
> The kernel now supports performing AND, OR and XOR operations directly,
> on one register and an immediate value or on two registers, so we need
> to be able to generate and parse bitwise boolean expressions of this
> form.
> 
> If a boolean operation has a constant RHS, we continue to send a
> mask-and-xor expression to the kernel.
> 
> Add tests for {ct,meta} mark with variable RHS operands.
> 
> JSON support is also included.
> 
> This requires Linux kernel >= 6.13-rc.
> 
> [ Originally posted as patch 1/8 and 6/8 which has been collapsed and
>   simplified to focus on initial {ct,meta} mark support. Tests have
>   been extracted from 8/8 including a tests/py fix to payload output
>   due to incorrect output in original patchset. JSON support has been
>   extracted from patch 7/8 --pablo]

This is now applied.
