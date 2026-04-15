Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D63126F3B;
	Wed, 15 Apr 2026 09:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776243745; cv=none; b=JITFFkaVfli4zhMKxR6ghSDZFXKgy5ZN5prjziUs19VFZt/Ri/rt7bOBlTIjGyijBHaAXvxHnog+Y+i74JfWKzsLtqPcumQlFI+1ZckLy3RWxbmqXTd1dKQcKrfp8+13C7TW85t7rUQysnsxYIKjZ4aWtrg6K9agMAuoJaFzxRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776243745; c=relaxed/simple;
	bh=PYpK4dOMTYD3aQATFMceXk5m2Wbvut2ijRVYcL4pYUM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T1nBDJsgQOMY02nSPCelyQPZkJJRIEXv8xeEvXhBHdondmdv8T8Vqiac6BfCVxhAiYkLF8t8/dWRHlmTvFt+3cWoelfPXwjKeZxAg0VmfXERbF9n9zRbeBRnmVgc2/a1Gz+W8u0eg6zmXkUttji83Cnpf9D1HOZf6e6vD6PS1DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 10AC560640; Wed, 15 Apr 2026 11:02:16 +0200 (CEST)
Date: Wed, 15 Apr 2026 11:02:15 +0200
From: Florian Westphal <fw@strlen.de>
To: "Kito Xu (veritas501)" <hxzene@gmail.com>
Cc: pablo@netfilter.org, phil@nwl.cc, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, jengelh@medozas.de, kaber@trash.net,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: xt_realm: fix null-ptr-deref in realm_mt()
Message-ID: <ad9UF5Cr12YGJnbi@strlen.de>
References: <20260415034343.107920-1-hxzene@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415034343.107920-1-hxzene@gmail.com>

Kito Xu (veritas501) <hxzene@gmail.com> wrote:
> realm_mt() unconditionally dereferences skb_dst(skb) without a NULL
> check. The xt_realm match registers with .family = NFPROTO_UNSPEC,
> making it available to all netfilter protocol families. Through the
> nftables compat layer (nft_compat), an unprivileged user inside a
> user/net namespace can load this match into a bridge-family chain.

I do not think this bug is related to nft_compat.
You can also use ebtables setsockopt api to request xt_realm, no?

> Fixes: ab4f21e6fb1c ("netfilter: xtables: use NFPROTO_UNSPEC in more extensions")

Looks correct.  Alternatively we could revert the xt_realm.c change.
But I don't have a strong opinion here, patch looks correct.
