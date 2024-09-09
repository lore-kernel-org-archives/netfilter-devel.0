Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400F4BA42;
	Mon,  9 Sep 2024 18:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725906952; cv=none; b=DuaoZ74AxXBLGMueaYdi7VxWaKcblsJhOFO9Dw0THJT6ADBEdcGf/y6+4AdDJ+u9bOk9Gz4g2L7lnozqdzy6nhM9Tkvnqy0R8Q6z/LiU5fMqe9bNo36VNyzvlLAmgmIEkx0EHS0CLGwP9Dub7yydUNGgbajfVWQVQoynlSDN6xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725906952; c=relaxed/simple;
	bh=ABrxZeQuIquezOEOvPL3bfj6o77d72AIM0y4FRAbwlc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bihx1YwjiRyrMBXJYOIzp+aMHO6j00z6ZrrFOJw/v0VzlTPt80OYBcO/Fb4gWRskwT4FFurBHJ1o2UJizcBcwI0M6tZPiwWHNoBQwC5+H5YK6ffjdp2tQkYeugdRTjAZvCaNJy2Z/oc41IqiLv+QpXzn3+o87mKRrtkGM3JaNrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XOfecqm3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XOfecqm3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F29EC4CEC5;
	Mon,  9 Sep 2024 18:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725906951;
	bh=ABrxZeQuIquezOEOvPL3bfj6o77d72AIM0y4FRAbwlc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XOfecqm32u0vSbd1kZYM+v0aYOgu7guw/lAPuOaDp6BGG4faRyi1vd+E5GwtqXZl/
	 Zy73QPaARu+s9e2O58u9nlZNgeXODfaEp3zZuvGd9k1Zw4UoCNUYeOot+aCmEszm7V
	 aNEVh6mwH7LCH5mlOM3084RZZjDOSnG1XONOUL0kq4/wkzkxN0iTJI5CnZvA8baRbB
	 Q1y3xPZ3iDFA54lVTo5fMPNCvo05mAN9lZRADaSs/meCBrRRObK939zTenttNuuJoe
	 E5EHUDj9C3ycqiDka8bVxI0VVth1WpP7Xn6m8kCuDQJZQdTFhmomniNBRgxVyUGlCO
	 /9HSXqQTLZLEg==
Date: Mon, 9 Sep 2024 19:35:46 +0100
From: Simon Horman <horms@kernel.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Felix Huettner <felix.huettner@mail.schwarz>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>
Subject: Re: [PATCH net-next v2 1/1] netfilter: conntrack: Guard possible
 unused functions
Message-ID: <20240909183546.GF2097826@kernel.org>
References: <20240909154043.1381269-2-andriy.shevchenko@linux.intel.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240909154043.1381269-2-andriy.shevchenko@linux.intel.com>

On Mon, Sep 09, 2024 at 06:39:56PM +0300, Andy Shevchenko wrote:
> Some of the functions may be unused, it prevents kernel builds
> with clang, `make W=1` and CONFIG_WERROR=y:
> 
> net/netfilter/nf_conntrack_netlink.c:657:22: error: unused function 'ctnetlink_acct_size' [-Werror,-Wunused-function]
>   657 | static inline size_t ctnetlink_acct_size(const struct nf_conn *ct)
>       |                      ^~~~~~~~~~~~~~~~~~~
> net/netfilter/nf_conntrack_netlink.c:667:19: error: unused function 'ctnetlink_secctx_size' [-Werror,-Wunused-function]
>   667 | static inline int ctnetlink_secctx_size(const struct nf_conn *ct)
>       |                   ^~~~~~~~~~~~~~~~~~~~~
> net/netfilter/nf_conntrack_netlink.c:683:22: error: unused function 'ctnetlink_timestamp_size' [-Werror,-Wunused-function]
>   683 | static inline size_t ctnetlink_timestamp_size(const struct nf_conn *ct)
>       |                      ^~~~~~~~~~~~~~~~~~~~~~~~
> 
> Fix this by guarding possible unused functions with ifdeffery.

I think it would be worth mentioning, that
the condition is that neither CONFIG_NETFILTER_NETLINK_GLUE_CT
nor CONFIG_NF_CONNTRACK_EVENTS are defined (enabled).

> 
> See also commit 6863f5643dd7 ("kbuild: allow Clang to find unused static
> inline functions for W=1 build").
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
> v2: fixed typo, dropped Fixes (Simon), optimised by reusing existing ifdeffery
>  net/netfilter/nf_conntrack_netlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

...
