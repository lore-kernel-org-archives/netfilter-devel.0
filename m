Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56453BB22
	for <netfilter-devel@vger.kernel.org>; Sun,  7 Apr 2024 17:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712510612; cv=none; b=F59YVqeqY4cagGc4Rfs8Jni5lSzjOUGinQx1Cq4WnQiEsYXrWlkfC+MCR3ejfv9xwlfq6o6QbTHPkqIYyZkpogl/dcdN0FH8VhC2HaAvQbmCzuyD2UksK3KXw6HDz3oh2ORm3ClkwPj7xuaQvFLriO60ENwGYb2O6uN4+q3W9nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712510612; c=relaxed/simple;
	bh=Z07aL/TnzpkIC2+wzCFLfwYDExvrpBHFx+cDzGRbweg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oYo+pdmX+mBU1xl65dtGpEDBJ04OMrb7KjpvYiBbCvH18KZZHRQIZi3Idaa1HYfGVFpdwXJvFqE1QB+v/5x3bT7O5qLN+DKABn9Fe0hfa9YFyrsUsf2lpt3vnKCJAQoPf/wzjLviRoZtKf5MgqUVBmKI+IkS479XeMd9UfrM+5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rtW98-0007r4-3t; Sun, 07 Apr 2024 19:17:34 +0200
Date: Sun, 7 Apr 2024 19:17:34 +0200
From: Florian Westphal <fw@strlen.de>
To: Son Dinh <dinhtrason@gmail.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [nft PATCH] dynset: avoid errouneous assert with ipv6 concat data
Message-ID: <20240407171734.GA28575@breakpoint.cc>
References: <20240407124755.1456-1-dinhtrason@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240407124755.1456-1-dinhtrason@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Son Dinh <dinhtrason@gmail.com> wrote:
> Fix assert bug of map dynset having ipv6 concat data
> 
>  nft add rule ip6 table-test chain-1 update @map-X { ip6 saddr : 1000::1 . 5001 }
>  nft: src/netlink_linearize.c:873: netlink_gen_expr: Assertion `dreg < ctx->reg_low' failed.
>  Aborted (core dumped)
> 
> The current code allocates upto 4 registers for map dynset data, but ipv6 concat
> data of a dynset requires more than 4 registers, resulting in the assert in
> netlink_gen_expr when generating netlink info for the dynset data.

Could you plese either extend an existing test case or add a new one for
this?

> -	sreg_data = get_register(ctx, stmt->map.data);

This line is wrong, this sould be

   	sreg_data = get_register(ctx, stmt->map.data->key);
