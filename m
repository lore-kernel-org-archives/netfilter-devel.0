Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B4D2D3A9C;
	Thu,  2 Oct 2025 08:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759392720; cv=none; b=YUcNPZJMINHhNkhHbIoajUILxnqpXnJSqLMk0qxZ01uyqf2iI1NNyyqs7slDyfOxtDQwSkPqC9SNRcV0pS/79kaKiU7oeoce0ehA3z3i6vs4dvQlaBN8xEK1iuuTXv8qQcuvVxtEY40+xnlYxdoQOGzWlr6j4DgJZv/2P3kHQj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759392720; c=relaxed/simple;
	bh=j7M390s4SZpOyOrMryqiFM0pIqnUrnZLA/F32tlcy4o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fNW2JG9ne93eFdGFSKxXcDuT7fVLsEy2WHKwzxHbvxEdLnxaFzbwitqEn6SDnZEfD7IUpP2dZUZpxFSiGQIzIi2nh3pu8yo+a3a9zLYgLRwOaRfc+lC6i7bW7TrZPudhv0yxoNIBi1i0gsvHP9jrgycQooKOLo8oPoJJGNdUwMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 907186032B; Thu,  2 Oct 2025 10:11:56 +0200 (CEST)
Date: Thu, 2 Oct 2025 10:11:56 +0200
From: Florian Westphal <fw@strlen.de>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, bridge@lists.linux.dev
Subject: Re: [PATCH v15 nf-next 2/3] netfilter: bridge: Add conntrack double
 vlan and pppoe
Message-ID: <aN4zzDvdJKjRxdnt@strlen.de>
References: <20250925183043.114660-1-ericwouds@gmail.com>
 <20250925183043.114660-3-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250925183043.114660-3-ericwouds@gmail.com>

Eric Woudstra <ericwouds@gmail.com> wrote:
> This adds the capability to conntrack 802.1ad, QinQ, PPPoE and PPPoE-in-Q
> packets that are passing a bridge, only when a conntrack zone is set.

I got no more comments for the patch itself, but this commit message
needs more information.

Why are you adding this?
Why the conntrack zone constraint?

Also, I don't think this conntracks 802.1ad etc. at all, it tracks
connections carried inside these L2 encapsulations rather than
just plain ip(v6) in ethernet.

... and again, why would one do that, i.e. whats the purpose of this
patch?
