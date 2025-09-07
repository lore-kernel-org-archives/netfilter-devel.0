Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330A723C4EA
	for <netfilter-devel@vger.kernel.org>; Sun,  7 Sep 2025 14:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757254258; cv=none; b=bBBP0SGzvI5sScjBpZRpHTI5IFgQtDYxz7AcGgmbYusFBuLvj8yy1hVUGDUfbvpwjsLo0a0pT84op17U0cuN3C4/TdU8E4LfYx939ERsRMYVXuk0hc+nj9VWkMifA0EgowVaCXueiD7H/goHJmPOlL2pY0lj2UG6YCNCU2aEYF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757254258; c=relaxed/simple;
	bh=sqCb1FBIAU7v/mL9TAv7gR7PZsAPJCsmtwWqNweHKhU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z76+e8+Yx5XfU54IGis+aeAoVkVWdPXG0muFwkgINl1qQM+3fccYxzZsksWYUTjelhOq0ByQ0XMXrU0k54lTlTD8QB67UO13c6KW56N2Y7BbQNq98HLoKKFtdHOr4Fo0YeF8RzHp300JcR8yidj/vlYzpqHPBUa01STWfT16Vas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E288161A2A; Sun,  7 Sep 2025 16:10:52 +0200 (CEST)
Date: Sun, 7 Sep 2025 16:10:52 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/7] src: normalize set element with EXPR_MAPPING
Message-ID: <aL2SbBTVwjeo1UA2@strlen.de>
References: <20250905153627.1315405-1-pablo@netfilter.org>
 <20250905153627.1315405-2-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250905153627.1315405-2-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> This patch normalizes the expression for mappings:
> 
>                                        EXPR_SET_ELEM -> EXPR_VALUE
>                                       /
> 	EXPR_SET_ELEM -> EXPR_MAPPING |
>                                       \
>                                        EXPR_VALUE

Is the plan to eventually rewrite this to

                                         EXPR_VALUE
                                        /
  	EXPR_SET_ELEM -> EXPR_MAPPING |
                                        \
                                         EXPR_VALUE
?

I don't see why there is a need to two set_elem shims.
I makes sense to have all set elements that get stored be
EXPR_SET_ELEM rather than a mix as we have now.

But I don't understand double-set-elem for mapping.
If its just an intermediate step, thats fine, no need for
a huge series that rewrites everything.
