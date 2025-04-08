Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F94819995B;
	Tue,  8 Apr 2025 14:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744120884; cv=none; b=XPiEYCVhcymhPpVKUuAAoExDAsZQzsrv2IqLQQB+gSDCTCNWeAlnvPlA3grA79d3rRgLXQX5nrZTffQGrjOLK5IOXQo8XNZD3aBNtJakS+FxHiYSBLwKkmLXDvvCtdHTWBCFt6Hq6Fw0I2+v1xFqnW+ZHheLnyK5UM41yjIVw4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744120884; c=relaxed/simple;
	bh=BlQXhUm5QQ1RBHJaTTWH1U3t6ByEHH4f1QwLeQYAGbk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VqeL6V8QvfjAFLEhhbWrfSxt6NGmoWdAW4oYJZHZVlPy7yJrtK7efdLQ1o5thFNaqyDV/Y9q0sZuF5NgsxQKgm/BqN8wheEAga6txCY15wYVcMMrG/kWHzIUV7TN8rosBTjIs5m3GKqyoOpevKLPhDnZAp6gWJHzq91qZOeopWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1u290Y-0002Nj-GD; Tue, 08 Apr 2025 15:28:54 +0200
Date: Tue, 8 Apr 2025 15:28:54 +0200
From: Florian Westphal <fw@strlen.de>
To: lvxiafei <xiafei_xupt@163.com>
Cc: fw@strlen.de, coreteam@netfilter.org, davem@davemloft.net,
	edumazet@google.com, horms@kernel.org, kadlec@netfilter.org,
	kuba@kernel.org, linux-kernel@vger.kernel.org,
	lvxiafei@sensetime.com, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, pabeni@redhat.com,
	pablo@netfilter.org
Subject: Re: [PATCH V2] netfilter: netns nf_conntrack: per-netns
 net.netfilter.nf_conntrack_max sysctl
Message-ID: <20250408132854.GA5425@breakpoint.cc>
References: <20250408095854.GB536@breakpoint.cc>
 <20250408123908.3608-1-xiafei_xupt@163.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250408123908.3608-1-xiafei_xupt@163.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

lvxiafei <xiafei_xupt@163.com> wrote:
> This modification can make nf_conntrack_max support
> the netns level to set the size of the connection
> tracking table, and more flexibly limit the connection
> tracking of each netns. For example, the initial user ns
> has a default value (=max_factor*nf_conntrack_htable_size).
> The nf_conntrack_max when netns 1 and netns 2 are created
> is the same as the nf_conntrack_max in the initial user ns.
> You can set it to netns 1 1k and netns 2 2k without
> affecting each other.

Netns 2 can also set it to 2**31 and cause machine go OOM.

> If you are worried that different netns may exceed the
> initial user limit and memory limit when setting,
> apply max = min(init_net->max, net->max), the value in
> netns is not greater than init_net->max, and the new
> maximum memory consumption <= the original maximum memory
> consumption, which limits memory consumption to a certain
> extent.

That was one of the suggestions that I see how one could have
tunable pernet variable without allowing netns2 go haywire.

> However, this will bring several problems:
> 
> 1. Do not allow nf_conntrack_max in other netns to be greater
> than nf_conntrack_max of the initial user. For example, when
> other netns carry north-south traffic, the actual number of
> connection tracking is greater than that of the initial user.

Sure.

> 2. If nf_conntrack_max of the initial user is increased, the
> maximum memory consumption will inevitably increase by n copies

How is that different to current state of affairs?

> 3. If nf_conntrack_max of the initial user is reduced, will
> the existing connections in other netns be affected?

No, but new ones will be blocked until its below init_net limit again.
