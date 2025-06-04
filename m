Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7632942A87
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Jun 2025 13:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749045165; cv=none; b=UGtbt+ShV58fDIsQuDGt/HmBXbJ717F1ooLEZa02YiL83Q3q4kNrFUtRmU3zDzF5daC8dLnb8z6MKjh1tDfNaIS/5JfWauLkCR8Hj7/LU5Fe8iUeBtzPw1e6se1clbBYX6eOHBIn5RS8n/5VVpaSLhKRPOMPi91U1DzWtJ0h/xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749045165; c=relaxed/simple;
	bh=1y+6eUfRW2jR5qXp23siSAlUHq1o1q4MRqKYz+zzhLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rmk71kICEIGIW+8Ie20yRuynMccVGG9qE0GqHZcr0Slp3mNdbrt/pENG8r4IjFb/sYp/5YaE+Af6hJ0X5LcZmUsNM5D/1wMqrODYsN+1EB4dMQ8okpNAs5C9iiIHxuSBtlA54yEFTfgT8k1WmVeWRQJCZjCUkaQURbJVuhGEqP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ErdweMvu; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ErdweMvu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1y+6eUfRW2jR5qXp23siSAlUHq1o1q4MRqKYz+zzhLQ=; b=ErdweMvuHlGVPosDNkohRD9XEZ
	9+XD9cAAMctGbFmeVXVr2qFACBF9+Feb2ASGoUoqNiHiFScJV4lZlHXC56ObQqPbux4UbI8vo7QjG
	33pVH3MjYZ3nBY1f51+BYChmrjE6k1Ckn4/ChVnzfkr2d8zaKFjQUl6civP9H0a5YDVJirxoCvJE7
	LlEioEdRj+qR3K67/uWhA8ZuuJRn3G+n/hgUedEXf1e15qpaiNH4MQl6ytkpB5THT1nlR2aXAEnuo
	BfrwqaNYprZ4ahVh/n84wjBymSgjTLlUs7uS26COzMtrTrpqA0QVL+2/oQ1IjZCCYpnSxcQGO5yxQ
	hXAryCPQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uMoXj-000000003RK-1zBT;
	Wed, 04 Jun 2025 15:52:35 +0200
Date: Wed, 4 Jun 2025 15:52:35 +0200
From: Phil Sutter <phil@nwl.cc>
To: Folsk Pratima <folsk0pratima@cock.li>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Document anonymous chain creation
Message-ID: <aEBPo-EAZA0_OSD7@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Folsk Pratima <folsk0pratima@cock.li>,
	netfilter-devel@vger.kernel.org
References: <20250604102915.4691ca8e@folsk0pratima.cock.li>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250604102915.4691ca8e@folsk0pratima.cock.li>

On Wed, Jun 04, 2025 at 10:29:15AM -0000, Folsk Pratima wrote:
> Access to the wiki is restricted, so I write here. On this page

Did you try requesting a user account?

For the time being, you could add the missing documentation to nft man
page and submit a patch. I'll gladly help with that and review results!

Thanks, Phil
