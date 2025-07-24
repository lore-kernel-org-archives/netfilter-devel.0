Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F442417C3;
	Thu, 24 Jul 2025 23:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753400066; cv=none; b=IFMHRWmodMo5fmpDCwnEx62T2SXUWrwm3rnRNb/3x0LszJJWnOg/DDURlxUBExgvxzuIBf7d0N+r3MSOybJ9GvIyfJxX6ea3q0oG1sCluLXrJ8QqOMFN0wiu5cJVRj4XRErGXry1nwHH0PPeVEarZ4KMIoW7qwxdB4tDFCgOkyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753400066; c=relaxed/simple;
	bh=DHaKhk7Q7aNey7uhHw3907c5pOFD9XNr0CX/GKMTrmE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GYuItUGwMiw93iCvGjA8IfKCWwTY8bh1/HkiU4nMydr8rUsVO9MQrUWQxgpJ9o88+u0gzyRprF6WvZF6daxhSzx0pyrpAR4FrDXjYMx44TNlDyWdOK+11J27w7s9shbojpEhZRLiuzXfqYYv6DYpTQ9Hr662u1cND4hAoLJZD3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=HEdsJ+5B; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UeXuyF0x; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="HEdsJ+5B";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UeXuyF0x"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 1E90C60281; Fri, 25 Jul 2025 01:34:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753400055;
	bh=DxcPnYvgss5L9/yxk39bT5oq0THwPqr7O/TdLTVsmyM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HEdsJ+5BImOlOMKwqRu6FNdi11jUTmWtPVKjJDbV2NPOvmxOLQgZI1R/pQ3rFUQjs
	 51I0wVwkJ36etLLvNwOh2v5qYdU2f95qqHBMynMHOyX7IQlk7PdA6tZkP34T4UKzgf
	 nmeaGYDknTHYE8tROnrAGNJe0781D2XkGp9JJkk5L2awxfDC+jYsJiB+IrVf3QBC+t
	 bsuimiZzKNmc9lPqZF9kjwl0v9fYWPvCmhnAd50BksG+lroiW4FB7kc6PgFGJDI7Of
	 RrMsQwFJ4uYmE9VBQVp0I4Me9yAYopSJhsVp+qoeIJUsicHfVtep8L9uSTDYyGjYBI
	 6wjMhI5Ea2hDA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3211660264;
	Fri, 25 Jul 2025 01:34:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753400052;
	bh=DxcPnYvgss5L9/yxk39bT5oq0THwPqr7O/TdLTVsmyM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UeXuyF0xh7XMUEXc4YiCYGAnYzSKWEy2tJp+Zcf2LKFkphzAeDS2xLXdg48KVPB9R
	 uIUHZxufE8MO5UXRkM662yg+3Gr3JCqLp+5THRlTO9slvqU9SzOE1mVo0x0yFVJQE7
	 lQjRUa684+J56I6yxiR6D88uNsI7ETZwaDuERRbTHW/THJSCNKAMCEI9gxO187Vbj0
	 /UwgpLMuFkqToETSZ3YfY080Aq5yQLpuCfOWfq3YG2lJVY/SQsEM2uMWr9U60tRZ6k
	 Q1UTpUa77CKrYcbNKuoj2BleG76jLAotTBKQNRxS+ZMtuWnec+HGwMPLD5PBNS44Gk
	 vCWGXI8/UbFKg==
Date: Fri, 25 Jul 2025 01:34:08 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: lvxiafei <xiafei_xupt@163.com>, coreteam@netfilter.org,
	davem@davemloft.net, edumazet@google.com, horms@kernel.org,
	kadlec@netfilter.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
	lvxiafei@sensetime.com, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH V2] netfilter: nf_conntrack: table full detailed log
Message-ID: <aILC8COcZTQsj6sG@calendula>
References: <20250508081313.57914-1-xiafei_xupt@163.com>
 <20250522091954.47067-1-xiafei_xupt@163.com>
 <aIA0kYa1oi6YPQX8@calendula>
 <aIJQqacIH7jAzoEa@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aIJQqacIH7jAzoEa@strlen.de>

On Thu, Jul 24, 2025 at 05:26:33PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > +				net_warn_ratelimited("nf_conntrack: table full in netns %u, dropping packet\n",
> > > +						     net->ns.inum);
> > 
> > This is slightly better, but it still does not say what packet has
> > been dropped, right?
> > 
> > Probably a similar approach to nf_tcp_log_invalid() would better here.
> >
> > Thus, nf_log infrastructure could be used as logging hub.
> > 
> > Logging the packet probably provides more context information than
> > simply logging the netns inode number.
> 
> Hmm, the conntrack table is full, and packet creates a new flow.
> What would logging the packet tell us what the printk message doesn't?

I was thinking, does the packet logging exposes already the
net->ns.inum? IIUC the goal is to find what netns is dropping what
packet and the reason for the packet drop, not only in this case but
in every case, to ease finding the needle in the stack. If so, then it
probably makes sense to consolidate this around nf_log()
infrastructure.

Anyway, maybe I'm overdoing, I'll be fine with this approach if you
consider it good enough to improve the situation.

Thanks.
