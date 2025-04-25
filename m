Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCEB129A78
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Apr 2025 06:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745562158; cv=none; b=IrDQjKl7gQHrC9qnuoNJpq5h8GyCCL00mdGcaodhPotm4d5l8BPrfPATp8w0JDaU+wfvj6yDL9rG4oZ5BvEyek5ZARqCz/ZWBCQ9KdvzGCeu3S7jyuhdbzmFSGBDrfkvuDDBVxJoDvSJp4ZcfXhKlbEjTSvN60SaNXre4a/OyY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745562158; c=relaxed/simple;
	bh=qWd2uBC59px6rVuOZyYTMW1gEe+ds4BsfdUSU7j0g1g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JK1qrQoKclt3ADCnlqkl69FQIpiabTFLyLVMupUrD0llLcu+3bBaSmHsokRpGta8kU4XIEzHWSGpCes1sj5H+4JVIw6lki7SwT6asW4ttWwfgMLugnJvYbkQRD0xDxMCtgKMcfLi1R0VqB/8zFR3yVFyDrbLAnmNkjmvglHb1DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1u8CSF-0001wD-Os; Fri, 25 Apr 2025 08:22:31 +0200
Date: Fri, 25 Apr 2025 08:22:31 +0200
From: Florian Westphal <fw@strlen.de>
To: Sunny73Cr <Sunny73Cr@protonmail.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Fail to clone iptables,ipset,nftables
Message-ID: <20250425062231.GA7332@breakpoint.cc>
References: <1EYtBL_6T4QRNdyaUOoY2OO_FLzCtCfv4Q7gBf28RHR_k_LB-t0IN5R7v12bgaOOSKputo826H9PZ-2EmksldVLnGVoXyMQVemTy3tMra10=@protonmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1EYtBL_6T4QRNdyaUOoY2OO_FLzCtCfv4Q7gBf28RHR_k_LB-t0IN5R7v12bgaOOSKputo826H9PZ-2EmksldVLnGVoXyMQVemTy3tMra10=@protonmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Sunny73Cr <Sunny73Cr@protonmail.com> wrote:
> error: invalid path 'src/json.'

There is indeed a bogus file of that name, no idea
why its there or why cygwin git chokes on it.

I removed the file, can you try to pull again?
