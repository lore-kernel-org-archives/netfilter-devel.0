Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2D61D4152;
	Fri,  6 Sep 2024 16:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725640285; cv=none; b=BncmLiSnVaqIdIImAn9vNX/Z4Plg76rMoxLbJuYiIcq0tq7DYpkffPE6wqPFwTA6mHVChNQ7kK9wFG2aYvlgXZX4zQ7AmiriCaXczp/jNal/XnD/P3cmWGOxMsrIu8ceWkOpXK4msoXyVWacNHM8pvCElcXpNiul9pno/J0cns8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725640285; c=relaxed/simple;
	bh=sC8UhjbTMx5mUtLsy+Qu/baWSi3okdi2YLVuh9ssZlE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cCk2AwrUT/V33bTNVK4yL8Q6KjHqYnOQge7DqqwndxcOX8X3uWsy1Dlkoxucb4EzRhbRYfusjIeex45twF8MRpdqRFMDVLpeFUN0QK5Xz8In1dKAgJrrWLtGYbagzAj6vNqsEi6+ktki8MD2NORU+x5ajEfc1u67g6ncd3KXtD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IgXAKi3m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IgXAKi3m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39737C4CEC4;
	Fri,  6 Sep 2024 16:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725640284;
	bh=sC8UhjbTMx5mUtLsy+Qu/baWSi3okdi2YLVuh9ssZlE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IgXAKi3mUmPm5IjeRJs6mOzzfI32ZC0C55ovfAid6+OrGUj8BfGXVt6ecfDL5e8uA
	 FUSwDNFfC73KFreghcJHXGoeWqoNQjbvK2w3FHmBse5hcBLlCRbooAFjcrm5P867oK
	 fXWfwL/0+yoFvoLccJSZ/GOFndElBK7CWA8N1GnP52/RFLo7SysH3d81Mn3iIdDuBB
	 /aI/VlQWEmoHaUoxUtQEejRUJcrV1z6wPvt23OS528T6MjneBkJsghESkFnGOqlKZC
	 pjPmxDYj2ovprLp6YWtOC/ss39eLkmePU81pRmy74kZg9FpURQoaxzg2KVY5LAAQv3
	 GXGUYwM9sGMzQ==
Date: Fri, 6 Sep 2024 17:31:18 +0100
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
Message-ID: <20240906163118.GI2097826@kernel.org>
References: <20240905203612.333421-1-andriy.shevchenko@linux.intel.com>
 <20240906162938.GH2097826@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240906162938.GH2097826@kernel.org>

On Fri, Sep 06, 2024 at 05:29:38PM +0100, Simon Horman wrote:
> On Thu, Sep 05, 2024 at 11:36:12PM +0300, Andy Shevchenko wrote:

...

> Hi Andy,
> 
> Local testing seems to show that the warning is still emitted
> for ctnetlink_label_size if CONFIG_NETFILTER_NETLINK_GLUE_CT is enabled
> but CONFIG_NF_CONNTRACK_EVENTS is not.
> 
> > 
> > Fix this by guarding possible unused functions with ifdeffery.
> > 
> > See also commit 6863f5643dd7 ("kbuild: allow Clang to find unused static
> > inline functions for W=1 build").
> > 
> > Fixes: 4a96300cec88 ("netfilter: ctnetlink: restore inlining for netlink message size calculation")
> 
> I'm not sure that this qualifies as a fix, rather I think it should
> be targeted at net-next without a Fixes tag.
> 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> ...

Sorry, one more minor thing: possible is misspelt in the subject.
