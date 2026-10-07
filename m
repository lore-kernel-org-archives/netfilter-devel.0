Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C8244A406;
	Wed,  7 Oct 2026 08:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791362935; cv=none; b=gb/pqePRTF/+jORqlf309enzrj04q/6KwBkd4xkiUphntF4laYXiSluIk9XU0Dx+ZK3SAh109+qUiwAcmquH81ZmzuoXC+Ky8wOHeUYohZSOc341+24gS//+FYZjCAoINssCSD7+dmc3RgzHpAG4JvrlUCuj3uZkGkwzIQQUPyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791362935; c=relaxed/simple;
	bh=v5DhNq5+rQFKLrFNihG9VAM61iFoZKuf9uJy8//4nKs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=auxywIQ9ps0px7s2ML8j5R6duV59+Yn8/mSB1/0+QWjreWt/stXsNuxIh5w7YGqkskKF1Ok0VZI7gPITjAHerMoqsrVXEBywXENEMfQ+LRx0/aYNU0VMGxvpSN4X6Rd5ez8BGOP/Tmqu4URXkss8iOj5oIlo2vc33f+wni2v/s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 422746038C; Wed, 07 Oct 2026 10:48:49 +0200 (CEST)
Date: Wed, 7 Oct 2026 10:48:48 +0200
From: Florian Westphal <fw@strlen.de>
To: Daehyeon Ko <4ncienth@gmail.com>
Cc: pablo@netfilter.org, phil@nwl.cc, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH net v3] netfilter: conntrack: avoid recursive master
 destruction
Message-ID: <asYHaUFdxo0flpAe@strlen.de>
References: <20261007014802.2615503-1-4ncienth@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007014802.2615503-1-4ncienth@gmail.com>

Daehyeon Ko <4ncienth@gmail.com> wrote:
> A conntrack holds a reference to its master. Userspace can build an
> unbounded acyclic chain through ctnetlink. Expectation producers can do the
> same: an nft ct expectation can attach its helper to an unconfirmed
> expected child and arm the next expectation with that child as master. The
> H.323 Q.931 helper can also propagate itself through call-forwarding
> expectations.
> 
> When only child-held references remain, destroying the leaf calls
> nf_ct_put() on its master. If that was the final reference, nf_ct_put()
> recurses into nf_ct_destroy(). Repeating this at each level exhausts the
> task stack and panics.
> 
> Nested expectations are existing helper semantics, and CTA_TUPLE_MASTER
> was introduced for conntrackd state replication. Avoid per-producer
> restrictions. Decrement the master's refcount directly, then free the
> current conntrack. If the refcount reached zero, continue destroying the
> master in the same invocation. This preserves existing constructors while
> bounding stack use.
> 
> Fixes: 5faa1f4cb5a1 ("[NETFILTER]: nf_conntrack_netlink: add support to related connections")
> Cc: stable@vger.kernel.org
> Link: https://patch.msgid.link/179127347858.434549.11821822167265441355@kernel.org
> Assisted-by: LLM
> Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>

Acked-by: Florian Westphal <fw@strlen.de>

That said, ignoring the source of the problem is not good.

I see no point whatsoever for a expected connection to have a
non-control connection as its master.
