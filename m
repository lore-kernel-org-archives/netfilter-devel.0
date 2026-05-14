Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79814406298
	for <netfilter-devel@vger.kernel.org>; Thu, 14 May 2026 15:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778771460; cv=none; b=GHYyxJY70k8OMOvuaNfEn89r2K+j9BKddPSTwFHk0ZBvpRM47gpD+VVnmI7Lmvraa4wGGb+ilHTy1wozqTqW5OePB8hP7Ssv7jcyHD/PoGwW8z3cKxhcebHHTWIEOxBmfLiCS5KDKPcShATodDHpJHvJOBfN7gRtWvglcXS1Tpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778771460; c=relaxed/simple;
	bh=B76m9kAFaz41O15Vk4kDbD8O5PxwDvdpX+YMmxhUTwU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tAq81tzw3ugScY8XSeq9zb9CRquFgfXJKNXCrypK+5Vv3+QOm45EIn2LYGAnHAf9j3MGEGlyrk7ah3zpvnd3hWwtBCepN0qmGtE+8iw3l3rkN/Jb0BehpSlkB/ZYpNwUv6XbJo/8gdBbFlA1WPbFgjvtq+D/d5xoecMJkYyz24M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Lvj+1Ut0; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Lvj+1Ut0"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 95E7E601B8;
	Thu, 14 May 2026 17:10:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1778771454;
	bh=OkB2JIhOtktoZz1UF6p965hbcnN2zA+kdKcZ4Swxe30=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lvj+1Ut0KIMu3pbkOKmj9eFj8m8TpEpDr4FmsxbexKppeE+9LpwbioLUSex1LTfOr
	 AYWqmLjsDPXm6U4tQGWKTZ4xe7/quIvaag3SVr3YtYOva3Y5uAG/KblKRuFelNyFyX
	 Xi2L55/TkeN2seMiGCivelsMW7jDbal0jG/Affe8twYT0u7717dY5zwFkYBXEQWzA8
	 fuNucjObbjMuQPe9osPQDGFnNFZMlPPqUT6KDkuNiNJIt0xS9gj4BUYgs8xT7FEpsW
	 vb0F6kRMcB7mY6yx4Li/JTFprgK//25/bJQ0RaxSgObPd+ja3lbw2i+xSnUvHY7EsA
	 sxxAhdl8n+Kcg==
Date: Thu, 14 May 2026 17:10:51 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v2] netfilter: conntrack: add dead flag to helpers
Message-ID: <agXl-3NDpK3YUZiF@chamomile>
References: <20260514143016.874811-1-pablo@netfilter.org>
 <agXfhQb8Dcl9p5ce@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <agXfhQb8Dcl9p5ce@strlen.de>

On Thu, May 14, 2026 at 04:43:17PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Add a new NF_CT_HELPER_F_DEAD helper flag to notify the packet path that
> > this helper is going away. Thus, helpers are effectively disabled and no
> > new expectations are created while removing the expectations created by
> > this helper as well as unhelping the existing conntrack entries.
> > 
> > Add the check for NF_CT_HELPER_F_DEAD in the packet path to:
> > - Conntrack confirmation path which invokes the helper callback.
> > - Propagation of helper to conntrack via expectation.
> > - OVS ct helper invocation.
> 
> Not sure this is enough.  New conntracks are not in any hash table /
> unreachable, and synchronize_rcu() doesn't guarantee they get confirmed
> (can get queued).

nf_ct_iterate_destroy() calls nf_queue_nf_hook_drop() for each netns.

> > +	WRITE_ONCE(me->flags, me->flags | NF_CT_HELPER_F_DEAD);
> 
> How does this avoid race with nfnl_cthelper_update() ?

Hm. I overlook that these flags are toggled, I will propose a new
approach.
