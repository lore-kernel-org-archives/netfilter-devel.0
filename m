Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E512B1865ED
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2024 19:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729107704; cv=none; b=IfqN4EhfeXf7av+SGUPqBvZZRGyFBe3FuN3p0iuUaEEvx8NuNepOrEm80jd3WxxwHj2EVWVPl6cqiK1QA43I0mOQdnOE3pWidjLFglniTuFOw7MmPLfqWzxzMjDo2qkfgnGrTExgwuKjnhi2P8U2vLZqGEbSUXcvuh3YQstV5mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729107704; c=relaxed/simple;
	bh=PNjPWhBSt/K7GJieSj2CHPa4gOpEq3aRrowRVfJ8MpU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=l/kSOZdo8zUpCtW4RD7b0JNlpupPt+2izH5sJrESUbJ9xYPUnE93GNyHUPgCaDJ9eWzQ1wAk+23todP7QO5j0rsEkHY83B5zrdrcd1rzCOeiHwPUq7jYlb30YF2f7glAJ1aU2zMTsjnUPv4kZGhHuYRcVNUTv2HyD5NSaLtj/Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=fail smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id AABFB1003D14DE; Wed, 16 Oct 2024 21:41:37 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id A914C1100A4396;
	Wed, 16 Oct 2024 21:41:37 +0200 (CEST)
Date: Wed, 16 Oct 2024 21:41:37 +0200 (CEST)
From: Jan Engelhardt <ej@inai.de>
To: Phil Sutter <phil@nwl.cc>
cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
    netfilter-devel@vger.kernel.org
Subject: Re: [RFC libnftnl/nft 0/5] nftables: indicate presence of unsupported
 netlink attributes
In-Reply-To: <ZxAORZJ3t4o04KUl@orbyte.nwl.cc>
Message-ID: <6139s271-82o6-np6r-19qo-8s4n53p20652@vanv.qr>
References: <20241007094943.7544-1-fw@strlen.de> <Zw_yzLizGDGzhFRg@orbyte.nwl.cc> <ZxAHJO_amh8cIDaR@calendula> <ZxAORZJ3t4o04KUl@orbyte.nwl.cc>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Wednesday 2024-10-16 21:04, Phil Sutter wrote:
>> 
>> > We may increase incomplete marker correctness by treating support for
>> > any new attribute an incompatible update. Given that we often have
>> > dependencies between libnftnl and nftables for other things, it may not
>> > be too much of a downside though.
>> 
>> 15:0:4 -> 16:0:5 means new API is available while older are still
>> supported, so old nftables can use this library binary safely.
>
>Yes, and my concern is if one installs this newer libnftnl, behaviour of
>incomplete marker will change despite the same old nftables package
>being in place which doesn't handle the new kernel attribute.

LIBVERSION is all about ABI/interface, not documented/observed behavior.

If, for example,
prime_factors@MATHLIB_v15(60000) yielded {2, 3, 5} but
prime_factors@MATHLIB_v16(60000) yields  {2,2,2,2,2, 3, 5,5,5,5},
perhaps one should devise a new function name to capture the new behavior.

If a library merely passes through data from another entity (another library,
or in this case, the kernel), the function should have been specified
(documented) to potentially output unrecognized objects, and require of
any function users to deal with the situation amicably.
