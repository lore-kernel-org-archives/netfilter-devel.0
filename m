Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2644B49627;
	Sun, 15 Sep 2024 21:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726434885; cv=none; b=KC7NZ6dbBzCh8hJE+TsZMO/XojMcVog+Iik6XYVamBZscvElsg/u5BVg7L0jdEmy94RlW7qBl4UNkjwHOI/ZQ7ia601oqXk+bPKeCFO0nLiAxEi6sBSmLzlWEaeRC0URlG+h8M7nxh6Tzkwebl0CsdZGn9ny84PxLCCbghcV1iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726434885; c=relaxed/simple;
	bh=3lJfMfpKsyd8hr0ZSbUAGDOe9KGdIjjzJZMvfavacew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JxfOrSrvXXRoItVBJSv/grVJTejV9wySehnp+HlrnOPm+Fr28yP8vFy24XCmo6rLtI0LWm4hh2u3qrBKUVagErYTUF670JEK7QLiEy2ls3V35gatd4/A1c8uPLEfqBKeGSauiZ1h2lsXi9gktzpEvXqrPXE7LiM+cwHwroyXD/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=56434 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1spwZo-00EIyt-4J; Sun, 15 Sep 2024 23:14:38 +0200
Date: Sun, 15 Sep 2024 23:14:35 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Simon Horman <horms@kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
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
Message-ID: <ZudOO1chdsy5h6CX@calendula>
References: <20240910083640.1485541-1-andriy.shevchenko@linux.intel.com>
 <20240910132101.GC572255@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240910132101.GC572255@kernel.org>
X-Spam-Score: -1.9 (-)

On Tue, Sep 10, 2024 at 02:21:01PM +0100, Simon Horman wrote:
> On Tue, Sep 10, 2024 at 11:35:33AM +0300, Andy Shevchenko wrote:
> > Some of the functions may be unused (CONFIG_NETFILTER_NETLINK_GLUE_CT=n
> > and CONFIG_NF_CONNTRACK_EVENTS=n), it prevents kernel builds with clang,
> > `make W=1` and CONFIG_WERROR=y:
> > 
> > net/netfilter/nf_conntrack_netlink.c:657:22: error: unused function 'ctnetlink_acct_size' [-Werror,-Wunused-function]
> >   657 | static inline size_t ctnetlink_acct_size(const struct nf_conn *ct)
> >       |                      ^~~~~~~~~~~~~~~~~~~
> > net/netfilter/nf_conntrack_netlink.c:667:19: error: unused function 'ctnetlink_secctx_size' [-Werror,-Wunused-function]
> >   667 | static inline int ctnetlink_secctx_size(const struct nf_conn *ct)
> >       |                   ^~~~~~~~~~~~~~~~~~~~~
> > net/netfilter/nf_conntrack_netlink.c:683:22: error: unused function 'ctnetlink_timestamp_size' [-Werror,-Wunused-function]
> >   683 | static inline size_t ctnetlink_timestamp_size(const struct nf_conn *ct)
> >       |                      ^~~~~~~~~~~~~~~~~~~~~~~~
> > 
> > Fix this by guarding possible unused functions with ifdeffery.
> > 
> > See also commit 6863f5643dd7 ("kbuild: allow Clang to find unused static
> > inline functions for W=1 build").
> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > ---
> > 
> > v3: explicitly mentioned the configuration options that lead to issue (Simon)
> > v2: fixed typo, dropped Fixes (Simon), optimised by reusing existing ifdeffery
> 
> Thanks for the updates.
> 
> Reviewed-by: Simon Horman <horms@kernel.org>

Applied to nf.git
