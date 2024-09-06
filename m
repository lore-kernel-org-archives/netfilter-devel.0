Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7661D3648;
	Fri,  6 Sep 2024 16:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725640184; cv=none; b=myzilJADknW2NePanEN+r8JngJWFwpBKAaTCgYyTYmmb27JuI9sdduvkw0C2frSXatNS+KCYDO9nerZRXokh4BZEFyDd5Rt549/Q3r2tbqZSBKKopAiLRwFkU8LkCrF3XxBB+b8kIv6FAJNkhKOjDisKxzb9XzB25NFyzLwLr48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725640184; c=relaxed/simple;
	bh=isicg2xVvBkJbP7LTTJMcVn6tBqaJzlkJ9FaWwbW78M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=txiVxdCR3ksUi2h4UnS4YkR/uP7aW3pq+dgca8pOwMaIVapK8RKaX/z6pmd3Rj/SWMF/BiZVmIVdHezu1Z5uVI6FNUCs0Pw6B+Q9k7w7t+sRrKUcTw6j36+rmLl3xANeawnz7YP62aNNLzFpXv/GFugTWtI21FVms5FIo02x1vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p81CISkT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p81CISkT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98FAC4CEC4;
	Fri,  6 Sep 2024 16:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725640184;
	bh=isicg2xVvBkJbP7LTTJMcVn6tBqaJzlkJ9FaWwbW78M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p81CISkTKAL1pyeXbDKDDy+3e3a0s/fWXRvfbR/07gbDizKYIEd7SjzLIs8GOcHnD
	 RAJHpns+pJOMzTKFmdmi3RQLNu34K9mcFr08J7456zd00S1klgbKPcyaNVfCkE7xqW
	 ZkPcJ5zoGXSJzyAu8uOsDV5F7GKTJL/6Nspl+GUUJY92J22dpgqtfyXjZuW9alSlOc
	 vrtUzzRLDBEVtFdIsGFfml3Pz64tHLbUKeSCdMnMVRX48aMGRsvAOcM2aFUR0Pnsth
	 /QhF0ptJM6vVBzfHSpbxlSJJqta79+IEnaVTIwtI3CrawEb0XSOQUXto/34JQ2cPQC
	 TOHDdhErTLkXA==
Date: Fri, 6 Sep 2024 17:29:38 +0100
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
Subject: Re: [PATCH net v1 1/1] netfilter: conntrack: Guard possoble unused
 functions
Message-ID: <20240906162938.GH2097826@kernel.org>
References: <20240905203612.333421-1-andriy.shevchenko@linux.intel.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240905203612.333421-1-andriy.shevchenko@linux.intel.com>

On Thu, Sep 05, 2024 at 11:36:12PM +0300, Andy Shevchenko wrote:
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

Hi Andy,

Local testing seems to show that the warning is still emitted
for ctnetlink_label_size if CONFIG_NETFILTER_NETLINK_GLUE_CT is enabled
but CONFIG_NF_CONNTRACK_EVENTS is not.

> 
> Fix this by guarding possible unused functions with ifdeffery.
> 
> See also commit 6863f5643dd7 ("kbuild: allow Clang to find unused static
> inline functions for W=1 build").
> 
> Fixes: 4a96300cec88 ("netfilter: ctnetlink: restore inlining for netlink message size calculation")

I'm not sure that this qualifies as a fix, rather I think it should
be targeted at net-next without a Fixes tag.

> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

...
