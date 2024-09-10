Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876405674E;
	Tue, 10 Sep 2024 13:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725974467; cv=none; b=Zj2lM02zGscLQgkvkbaZXeKSWzzEvMw3mWeiz+XUXHcXkZUASzaJVfOri2YkBaVLrj7ZTGcFDf97DN5jUQLby/J0lGkCCmPqkR4K0pjectVJVWKF8mZXYmOe6vFTH8XJIFwsRPic19v5LeJuDYoL+n15hBzq4gKL5GGRsNWEOoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725974467; c=relaxed/simple;
	bh=pi8HPtsLIXcAq9k4tIct6sJRE/y4u4yXa0nPJIIB/Ms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dKZrKeyHDBbA/VpvkHLcNOV00QvoHiECFIhkQDeGS9aP48BqZYkt46A+v6W4TT9smwoUCQ4Dv02cevacbr8IXyNzDkfII9XGt7E8XydOwSNqY8yB7eDSL9RiGEW7UPJb7DT/ORNHh5Nt2bEagSHvvV3YPxnvnl6vcp3uhUXVado=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YHqNw/LJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YHqNw/LJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6B9C4CEC3;
	Tue, 10 Sep 2024 13:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725974467;
	bh=pi8HPtsLIXcAq9k4tIct6sJRE/y4u4yXa0nPJIIB/Ms=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YHqNw/LJWe/ax8rtvw3sQG7dO8LPpvB13tKKsNaY2UlbOoY1j0UZaf4JSb9+flTKV
	 EXD8ngtdr/UPDH1FOxbeNuiu8BwiaQj3uoyRaDuCn+n3wAkSRsjovYuIEifVg1PHL+
	 dZna27QCeQjcdALjZLHefkRIzJ+UcF66GzwxG4ePQ4UTGDWXWHw2bWBpLsJ4R2g95v
	 Uql4u+D07AabdFufp5CG0dtSh+N76mYMXzTgp0ZHPjjgqRwM6BRmdc+U4ptp0hEkTO
	 H6EQAx6tHVn+U6gsMLx0Lv2SDR+5x8AyuVZhPx4INOzz5HBHEjunwK6doqXcPJQRvA
	 7+W4Z3tY1TBPA==
Date: Tue, 10 Sep 2024 14:21:01 +0100
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
Subject: Re: [PATCH net-next v3 1/1] netfilter: conntrack: Guard possible
 unused functions
Message-ID: <20240910132101.GC572255@kernel.org>
References: <20240910083640.1485541-1-andriy.shevchenko@linux.intel.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240910083640.1485541-1-andriy.shevchenko@linux.intel.com>

On Tue, Sep 10, 2024 at 11:35:33AM +0300, Andy Shevchenko wrote:
> Some of the functions may be unused (CONFIG_NETFILTER_NETLINK_GLUE_CT=n
> and CONFIG_NF_CONNTRACK_EVENTS=n), it prevents kernel builds with clang,
> `make W=1` and CONFIG_WERROR=y:
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
> 
> See also commit 6863f5643dd7 ("kbuild: allow Clang to find unused static
> inline functions for W=1 build").
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
> 
> v3: explicitly mentioned the configuration options that lead to issue (Simon)
> v2: fixed typo, dropped Fixes (Simon), optimised by reusing existing ifdeffery

Thanks for the updates.

Reviewed-by: Simon Horman <horms@kernel.org>
