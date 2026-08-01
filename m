Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D152C2DC789;
	Sat,  1 Aug 2026 13:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785592547; cv=none; b=YvBHGTGlUtkunrj2ePArDnHi+iCSQtTMH3NLUZCb0yaexN55KrNdClKgCMfQ3HA4YDIO0oByCKpmgJZ5IfAnCJIUGnbTQomY8G90cBjsK6VtA8Sb/IBvadWOaDmiQOLfkMDxeX72L31FYuy+Jez/B9lwStKS4boRarnhuuUR3TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785592547; c=relaxed/simple;
	bh=tc2qu4Upiy9N+pG5Gn3G0mr2NcOvtwfomhmvsbYg6i4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qy8IW24fRrj2Cr08iL3/tM/guQiClkQCwNMOXRABNuMvVKH97P3vSF/OKQTXFJFmap9r2S6sakbwA/LhahBmW2xsm/r6Co+VXeoYE1BhygkFbC4K2CjQKNcU3hIHGsRHxXUCOYel2ZeUngecmh66Jem0DO0myZxAq88/rj3Vwv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A815660952; Sat, 01 Aug 2026 15:55:42 +0200 (CEST)
Date: Sat, 1 Aug 2026 15:55:42 +0200
From: Florian Westphal <fw@strlen.de>
To: Zhiling Zou <zhilinz@nebusec.ai>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	pablo@netfilter.org, phil@nwl.cc, kadlec@netfilter.org,
	den@openvz.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, xmei5@asu.edu,
	kees@kernel.org, sbrivio@redhat.com, vega@nebusec.ai
Subject: Re: [PATCH nf 1/1] netfilter: ipset: serialize kernel-side
 put-byindex with swap
Message-ID: <am363vHJsdnL3Ja-@strlen.de>
References: <cover.1785583673.git.zhilinz@nebusec.ai>
 <df40376603e2a53a311d5ceea63240bedc11bdfc.1785583673.git.zhilinz@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df40376603e2a53a311d5ceea63240bedc11bdfc.1785583673.git.zhilinz@nebusec.ai>

Zhiling Zou <zhilinz@nebusec.ai> wrote:
> list:set garbage collection drops member set references through
> ip_set_put_byindex(), which resolves inst->ip_set_list[index] before
> __ip_set_put() takes ip_set_ref_lock. ip_set_swap() swaps both the set
> pointers and the corresponding refcounts while holding that same lock.
> 
> If garbage collection looks up the old set pointer for an index and then
> loses the lock race to ip_set_swap(), it decrements the old object after
> its refcount has already been swapped away. This can trigger BUG_ON(ref
> == 0) when the other set had no references, or otherwise under-reference
> a set that is still reachable through the swapped index.
> 
> Fix this by holding ip_set_ref_lock across the kernel-side lookup and
> refcount decrement. This keeps ip_set_put_byindex() paired with the same
> set/ref state that ip_set_swap() publishes, without changing normal
> list:set deletion or swap behaviour.

Looks like a duplicate of
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260722223832.3524006-1-xmei5@asu.edu/
