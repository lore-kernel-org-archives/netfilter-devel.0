Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C391E411D
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Oct 2024 14:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730296871; cv=none; b=tfy0aDT5ojIjhbYjty7MSCwAmEsSj5FoAwo8am3yqzi5l4RTsfvfZ8Eb+vORODxA8/w0CUP0oI9OnDEvk36WG/hdz4UFjs/tvx9fnyoTSuJn41P1EbGpCgkwiVqSBvAbUhi4DiEkw+7NYm9B4rMzI4lQYzKxN2NR//4ToA2k95M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730296871; c=relaxed/simple;
	bh=GhUNoFj5X1FbKXOxZ/yRcOGUIMRzMeOMyfkTKt1lDxU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VsatZGy0Mi6LnGQRxgHsHFk3jKJDC8056w6er6yJQTKFodxjvByyoRacct+QZl3UB4kzjOFTvRN2dYmvVRuQOAJ7bOeQ6I6TmdaDx/NZ4/DkoEuqHAkjJKOcV9vDWZeF+Zuw7arrUJyRMrOBd5hzKfZx1uhknN8dcW+/lyMuhEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=35454 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t69Fw-00BVN2-3P; Wed, 30 Oct 2024 15:01:06 +0100
Date: Wed, 30 Oct 2024 15:01:02 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2] doc: extend description of fib expression
Message-ID: <ZyI8HrvACYJ-JJ8L@calendula>
References: <20241030132756.19532-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241030132756.19532-1-fw@strlen.de>
X-Spam-Score: -1.9 (-)

On Wed, Oct 30, 2024 at 02:27:52PM +0100, Florian Westphal wrote:
> Describe the input keys and the result types.
> Mention which input keys are mandatory and which keys are mutually
> exclusive.
> 
> Describe which hooks can be used with the various lookup modifiers
> and extend the examples with more information on fib expression
> capabilities.
> 
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1663
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
