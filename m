Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4E62135B9
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Jun 2025 21:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750886411; cv=none; b=CfnqqMGKGOWhrAUhwRh0owjPbH8sfOfFcY0jhYEzah2Qom7cZFtAmG7I5OZn4QysMbI1lx18vwHna47Fw/wu067AotZmpxMxG8BAGKPMT5wAdgTf3hSz7lwU0ikyCoznA73vMpXpDSg+CakKeiTAh9CQcRM+nLihiQ+6SSNP3fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750886411; c=relaxed/simple;
	bh=pdhUaEWvjjcrAOJO1VZ41/zZBJcgln2ypdSjaj44z60=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HJHVt6QhPrFYiVlUrqpBhvb2+I33ReggS5qBSicEVKL+qdqIG/Pwshazk8vchynJCRB2sq6+EhOq/DSC7M9R/gHZF2cBOfpluNula9s2Vtg3WuhNfTo21nd3Dx93ysH+4LaNwPS6H1VhlCnsoZTBqAg1QecvI2N+D6/zoPYBBk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BfcICOP4; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BfcICOP4; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BfcICOP4";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BfcICOP4"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id ACD3D60272; Wed, 25 Jun 2025 23:20:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750886407;
	bh=tMtyqm9+aqNqu7RJ2atNA0R6CJ4XXTT4imGMVSTd1tg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BfcICOP40iEbXgigK644iI4JjVnDVcupxgwIa4GXFTLGQt8JXNNYvLmGJmLfUSVwn
	 cVAy7EScxFnvEp8EAq/eitt915t1KkQZs9law0lAYQH5fD9GC8YjsnIsiXNfh89vJG
	 DpeEI13RdVyjKS/OOriaEZvOSUXAzDrDEPnk23j0VC0yActKciYheVP0pTHMUBhqvS
	 Iz/xba/R8ufQH8GA/Uz7QT8zA8vHfk5K2o1CkKQRxTa+aiLAZAPGiWhWfDcQj9fNxL
	 6/b8aXS2EuisstlPPj5/HcE4s4+rkuRSlxkerRtQJRDuxd9JvxNC6Pfk2bQOTOMxmi
	 DA895dx6RwDkA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E8E8360272;
	Wed, 25 Jun 2025 23:20:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750886407;
	bh=tMtyqm9+aqNqu7RJ2atNA0R6CJ4XXTT4imGMVSTd1tg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BfcICOP40iEbXgigK644iI4JjVnDVcupxgwIa4GXFTLGQt8JXNNYvLmGJmLfUSVwn
	 cVAy7EScxFnvEp8EAq/eitt915t1KkQZs9law0lAYQH5fD9GC8YjsnIsiXNfh89vJG
	 DpeEI13RdVyjKS/OOriaEZvOSUXAzDrDEPnk23j0VC0yActKciYheVP0pTHMUBhqvS
	 Iz/xba/R8ufQH8GA/Uz7QT8zA8vHfk5K2o1CkKQRxTa+aiLAZAPGiWhWfDcQj9fNxL
	 6/b8aXS2EuisstlPPj5/HcE4s4+rkuRSlxkerRtQJRDuxd9JvxNC6Pfk2bQOTOMxmi
	 DA895dx6RwDkA==
Date: Wed, 25 Jun 2025 23:20:04 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] json: reject too long interface names
Message-ID: <aFxoBC6EEHJ6PhJ-@calendula>
References: <20250624214702.25077-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250624214702.25077-1-fw@strlen.de>

On Tue, Jun 24, 2025 at 11:46:59PM +0200, Florian Westphal wrote:
> Blamed commit added a length check on ifnames to the bison parser.
> Unfortunately that wasn't enough, json parser has the same issue.
> 
> Bogon results in:
> BUG: Interface length 44 exceeds limit
> nft: src/mnl.c:742: nft_dev_add: Assertion `0' failed.
> 
> After patch, included bogon results in:
> Error: Invalid device at index 0. name d2345678999999999999999999999999999999012345 too long
> 
> I intentionally did not extend evaluate.c to catch this, past sentiment
> was that frontends should not send garbage.
> 
> I'll send a followup patch to also catch this from eval stage in case there
> are further reports for frontends passing in such long names.
> 
> Fixes: fa52bc225806 ("parser: reject zero-length interface names")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
