Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E46E2D97BB
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2026 20:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785443134; cv=none; b=j/+t3G0BCeptgDvZRcCOeomTNSthr8qIR56L1oYPvlmMf69tqopJMoj88SXszdlILeX/9KwHAsA7TvFgc8OlFGZOf2843iyKIqUK2uIZdxrSldpbHJaEe7q8Rck1Pl+oHd1FY0E3ng7Hd5rJzkVMh5p1tXaSePHFy4Yg+DCSBx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785443134; c=relaxed/simple;
	bh=tnlQVCmuRMXhX9V5LMRnOiWI3oP+jc2hDYHpyosyiFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KD3Gb85oLJKj2mLEII7Ynxrf2ErpDYo+xRn+X7JzPfLXu8mbnk6WJxFiB6B/BPdN5wxX+fWwIjc72AC1i4/CLZXZ4hZjJbOIqVDiKMxRz8FTDvEAffIs3l+MeuJOtnDhrdoMjb+5laMqdI9bbmmycHR38LYwkS6y5Xer/c4IMhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id DAD3360380; Thu, 30 Jul 2026 22:25:22 +0200 (CEST)
Date: Thu, 30 Jul 2026 22:25:22 +0200
From: Florian Westphal <fw@strlen.de>
To: Zihan Xi <zihanx@nebusec.ai>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, phil@nwl.cc,
	davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
	horms@kernel.org, avagin@gmail.com, vega@nebusec.ai
Subject: Re: [PATCH nf v2 1/2] netfilter: nf_conntrack_tcp: defer
 timeout-lowering invalid log until after unlock
Message-ID: <amuzMlprGP13tg1L@strlen.de>
References: <cover.1785348197.git.zihanx@nebusec.ai>
 <e387bc8da39f47fe48fddb576125805273a9a48d.1785348197.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e387bc8da39f47fe48fddb576125805273a9a48d.1785348197.git.zihanx@nebusec.ai>

Zihan Xi <zihanx@nebusec.ai> wrote:
> nf_tcp_handle_invalid() can lower the timeout of an assured TCP
> conntrack when an out-of-window FIN/RST is answered from the other
> direction.  Today it also logs that event while ct->lock is still held.
> 
> If invalid logging is routed to nfnetlink_log and conntrack export is
> enabled, the log path can re-enter conntrack netlink glue and recurse
> into tcp_to_nlattr() on the same conntrack.  Move this timeout-lowering
> log emission out from under ct->lock by making nf_tcp_handle_invalid()
> return whether logging is needed, then emit the message after unlocking.
> 
> Keep the timeout update unchanged and simplify the log text so this path
> does not need to stash extra state while the lock is held.

Reviewed-by: Florian Westphal <fw@strlen.de>

But consider following up on nf_conntrack_proto_sctp.c.
