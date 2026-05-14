Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D761384CD0
	for <netfilter-devel@vger.kernel.org>; Thu, 14 May 2026 14:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778769802; cv=none; b=Yd8ZVALLncKdDDAOuaygzd3ovt88qI8vbzZ2qq8MRfDY4Qo1zioAg12kntjTH6fOJQKG54m+zkYLZ6NzJsANwitECw9SghMw1TrLxSwQ/MpNy75LsbQIhyuR0L6/dOSD9ZVYx42tPme5WbeNStm7WnSLzFnWfajzo/7QaW4EjEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778769802; c=relaxed/simple;
	bh=gNK/qtTK85hRQk4Or2+ssXTsuX5F1ZvH5Qg3rH9Nxc8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LSwq8CqiVUaIdyP64jVb3S+4zT5+Erhed3dZ2iVXg0bDJjb1QIBvmAmk3CL4MAzAmxAcjOpSUXYn9ZzgV6qlbkW6n/SOkdh/O5pZBi2D4bsBcVtGwOPrL12TIBL0p/ZGPd4Hp32KPIjWiY8v0BuAbKjvlrC0/DZZl+LKCiuvKjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id ED53C6099C; Thu, 14 May 2026 16:43:17 +0200 (CEST)
Date: Thu, 14 May 2026 16:43:17 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v2] netfilter: conntrack: add dead flag to helpers
Message-ID: <agXfhQb8Dcl9p5ce@strlen.de>
References: <20260514143016.874811-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514143016.874811-1-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Add a new NF_CT_HELPER_F_DEAD helper flag to notify the packet path that
> this helper is going away. Thus, helpers are effectively disabled and no
> new expectations are created while removing the expectations created by
> this helper as well as unhelping the existing conntrack entries.
> 
> Add the check for NF_CT_HELPER_F_DEAD in the packet path to:
> - Conntrack confirmation path which invokes the helper callback.
> - Propagation of helper to conntrack via expectation.
> - OVS ct helper invocation.

Not sure this is enough.  New conntracks are not in any hash table /
unreachable, and synchronize_rcu() doesn't guarantee they get confirmed
(can get queued).

> +	WRITE_ONCE(me->flags, me->flags | NF_CT_HELPER_F_DEAD);

How does this avoid race with nfnl_cthelper_update() ?
