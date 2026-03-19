Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C183E95B2
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Mar 2026 16:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773936267; cv=none; b=p2qtr2yJ95/wHGb0AbGbOOSk4R0x9tGFbVY8Rs4Ok+cRFvYj78tMfyPI2Txn1Gz9zF903oABEkH/jP/bxYRWGcUke4NkjaDyHR6YqC7sjmQZyfMhPhRzaz0JgUC0FcQ54mVyQ1nRM9CIPIXGioZPMis32WN3YzfGIrfiC/kHmOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773936267; c=relaxed/simple;
	bh=1pvVf/fLO9BCOfPUwNbcip3uWMVq3AYH6qWZ/pQNIQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jut6hkrCMQwgHAwbn8VK8d8wlnuTona9+OOedhMAYL9FTu4WJRDrPOiIquHyq/BOcM6pTWbp/wU67bXoFkTUeYxswrdYp7R56rq0HZ+aRZu5VgFAbmJykWjF6gNQEHKvd1F6IxRyLi3GN2bawDjmjoCaUIWDVqtRKRvkvtJXxm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 44284606E1; Thu, 19 Mar 2026 17:04:18 +0100 (CET)
Date: Thu, 19 Mar 2026 17:04:18 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH] netfilter: nfnetlink_hook: Dump nat type chains
Message-ID: <abwegj2TijkaQVLz@strlen.de>
References: <20260313153220.19662-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260313153220.19662-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> These chains are indirectly attached to the hook since they are
> not called for packets belonging to an established connection.
> 
> Introduce NF_HOOK_OP_NAT to identify the container and dump attached
> entries instead of the container itself.

Please lets not do this.

Before:

        hook postrouting {
                +0000000100 nf_nat_ipv6_out [nf_nat]
                +2147483647 nf_confirm [nf_conntrack]
        }

After:
        hook postrouting {
                +0000200000 chain inet nat postrouting [nft_chain_nat]
                +2147483647 nf_confirm [nf_conntrack]
        }

... and thats not true.  The nat chain isn't hooked at 200000.

It hooks at +100, this is a dispatcher.
Concealing the actual hook location and then unrolling the embedded
nat hooks gives a wrong impression and will mislead users wrt. the
actual ordering.

If we really want the ability to list the nat hooks, I think this
needs a new command to dump them.
