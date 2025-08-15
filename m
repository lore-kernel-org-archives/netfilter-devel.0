Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A9D29A9CD
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Aug 2025 13:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755264610; cv=none; b=uegrhPDp0Nsu1CqaE0P0vWGe0gbGVXZfscGWC0jVcE+6uqWS0QmzIr0Gl6M7dbFVXovq3yKjJzrcdGdbQjNz25CwhBH0c6GianWI7KKz/ohQBmW+LEokT8ul8KXVNoEorqwWwy1JofusRTZY4VhS+DWh1jLd9JReX6NijTvW1vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755264610; c=relaxed/simple;
	bh=JcpzPUuuoMmr+vJu1T7gI95Vy/Dexg+BnZ0huS3U5UM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DgRJEVGzO7nQIrqWywXPLvue/y/J8qqF+8zncCGJzV7L0YwN4YC/8iGyE/kRZLOLIb5myyHfvfN2kNbyDa+MJYlkJvgyRIC0O/8l9lz1ouN5DgeAlwKr57G2MeGYkVl2tu4QFCq9wduVf00K27rCxDGIrjx810pppMRR+Tu8XmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=UVuO3SyX; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="UVuO3SyX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=JcpzPUuuoMmr+vJu1T7gI95Vy/Dexg+BnZ0huS3U5UM=; b=UVuO3SyXNuCZl1aBDGLmMLnnJW
	TAmPbvIbfAoywTBVK2aMuc0d/fmdt0ZNr6PyovN05ot+yPiKLJTgsyhXuEJ44egIFFFbKvXTAFWsA
	Cc+O6e+QXaX7BFJK2BGafrkvCX2J/ufEWEy807T4hz29HzjnNhklc1Ai8cr2cg8+IhEPy0HdVsjSA
	IOtUVfZf8wwH4we2XgOU/02U/2JjqtIgdJ4uMq1yP+ScJ0JlwhLCHSCiM7SouGaSs9JivHOsrMY4C
	h43SoOd2Vzt8yBzQTZufVVZyeHqYuWRkzGKRli7+3eLUL+aTuq5Mos636gNayulvl9uRWfnk0Ra2P
	UH7pYZkw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1umuVM-000000006Dl-0xpq;
	Fri, 15 Aug 2025 15:30:00 +0200
Date: Fri, 15 Aug 2025 15:30:00 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 12/12] src: replace compound_expr_alloc() by type
 safe function
Message-ID: <aJ82WGOx8sC-iRhl@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250813141144.333784-1-pablo@netfilter.org>
 <20250813141144.333784-13-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250813141144.333784-13-pablo@netfilter.org>

On Wed, Aug 13, 2025 at 04:11:44PM +0200, Pablo Neira Ayuso wrote:
> Replace compound_expr_alloc() by {set,list,concat}_expr_alloc() to
> validate expression type.

This is just for consistency wrt. the previous patches in this series,
right? There is no chance the expr_{set,concat,list} macros' assert
calls will ever trigger in these _alloc() functions.

Cheers, Phil
