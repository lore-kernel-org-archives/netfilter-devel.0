Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597BA3A1D1C;
	Thu, 16 Apr 2026 10:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776336017; cv=none; b=jt/SrznCDZ3U5WVMIZAye2exM/XcC2cvY6UhDAQrMyE+I8UhtZSM9MJH2zc6ntDXFJr/LGlQUxpyjMfPvOj6SOkkV0kkNPuGGgiGu934e1xf1sXwuDmijQQm8K9aKy9/dzzng8Y8kVLpfJWSWlKqusNYyMwzhMPlGDVeqxyUEn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776336017; c=relaxed/simple;
	bh=0+0ksEBqhjHFtIVgjGw8tJ46hxVXvRjrpsF9vBCpNCI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VSHU7A8szEIf066sbHu6qOSqrURvwd7XgPDu+OrR73vLtkCTV1ZBONkenv86ImoemNRjG6RWp1v2LB/QmjKseGLZKDUWYNgorpw7EsIfu/fIo2QStmhZjrLbtZ1phs4L3Ytn/ft2HoRZjo79VaxgNxB0dGTQEBjgFRiuBk84jZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 76E8260923; Thu, 16 Apr 2026 12:40:12 +0200 (CEST)
Date: Thu, 16 Apr 2026 12:40:07 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, horms@kernel.org
Subject: Re: [PATCH net 00/14] Netfilter/IPVS fixes for net
Message-ID: <aeC8hyj6IFW7UvUG@strlen.de>
References: <20260416013101.221555-1-pablo@netfilter.org>
 <aeCPB1_WaFOX-Xos@chamomile>
 <aeC4A75gYD9qT5OR@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeC4A75gYD9qT5OR@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> I cannot send a batch before 16h my local time, I need a bit more
> time.
>
> Sorry.

No problem.  Alternative is to drop patches, this is what I did in the
past.  Some LLM comment indicates problem, remove patch from v2
and defer to next week.

But that was before LLM reviews flagged 50% of patches.
I'll pick up on anything left behind for next weeks batch(es).
