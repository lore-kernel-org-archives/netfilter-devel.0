Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156D734107D
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Jul 2026 10:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783073310; cv=none; b=d9z1qN0cqlLlh6dv6fova6HnE+IL3EvwKW1DPD3U1vz4scn4oxQI/9vs8gyJjzi465gtb3soXbgffCIMJipDfscma3nULpq37Zr9DN6tVd3QWqpBRoab2n0Nald1/+dcQDwIsLgl8a0xWpj1XkU1SBabyUirl8cp65cpZ3U8+Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783073310; c=relaxed/simple;
	bh=Le3cNFDKbjD87PHzv3ccDq2wwCgNEFH8bppZGbvAJc0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fp6lcFF/oN9Nb6RIHRNYP8WesPGwVTn6pMKysfZ7o6RNCMeROk4VblIo4lsxOcTJFQsqcSftLiRkDk6baEDfTj+srWl7hE2fQ/Up+EKJ14exGc8gLlvibPgIFXkWFYZ6GdlWk1GmptSVssAqv2zEHEl12JYZExNgHbf/hmR7G7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A0639602A9; Fri, 03 Jul 2026 12:08:25 +0200 (CEST)
Date: Fri, 3 Jul 2026 12:08:25 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Ren Wei <enjou1224z@gmail.com>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org, davem@davemloft.net, edumazet@google.com,
	pabeni@redhat.com, horms@kernel.org, yuantan098@gmail.com,
	dstsmallbird@foxmail.com, chzhengyang2023@lzu.edu.cn
Subject: Re: [PATCH nf 1/1] netfilter: xt_time: reject pre-epoch calendar
 matching
Message-ID: <akeKGXmzONKkGqOl@strlen.de>
References: <cover.1782879547.git.chzhengyang2023@lzu.edu.cn>
 <779d223ad31c493cbfc3c483293e435dca89cf90.1782879547.git.chzhengyang2023@lzu.edu.cn>
 <akd6KZo1lwQ719d0@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akd6KZo1lwQ719d0@orbyte.nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> On Fri, Jul 03, 2026 at 03:32:43PM +0800, Ren Wei wrote:
> > From: Zhengyang Chen <chzhengyang2023@lzu.edu.cn>
> > 
> > When XT_TIME_CONTIGUOUS handles a cross-day daytime range, packets in
> > the post-midnight part of the range are matched against the previous
> > calendar day by subtracting SECONDS_PER_DAY from stamp.

This is silly.  I'm not sure this is even a bug.
We're in 2026 not 1970.  I really don't see why this patch is required.
