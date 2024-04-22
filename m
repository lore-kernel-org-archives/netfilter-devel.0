Received: from smtp2-kfki.kfki.hu (smtp2-kfki.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC54C51009
	for <netfilter-devel@vger.kernel.org>; Mon, 22 Apr 2024 08:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713774759; cv=none; b=G08e1v5+0piNeotwLdLf6PCKLm2H8i0y2bW13okK0srpX62L/iz1Hy+HHzoPSwa7qXVUfp1mvLZ1gwN95AyvzGNEglKoyT7OjWwDYiPeAR3MvPrpkJIAY2K6TiM+GfiS1Un0Q8H9lpU993QjvnCp1v/PovfsXN8ZxOr0zz9O/UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713774759; c=relaxed/simple;
	bh=3+iqPzbO8Y5B5+8ZlkVWYSE4xusm40bSBy3FMXBKGsg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=h921GRO8RBM2t/VPO/GCtqJLsAbPi5ieb2fqcoZ6Qf9FxAoUl7kRPz8hDYeFfk1BZl41cbQjyZGZZCT+mzaUR5c6gXnA/9ANNI8rO61txmcfGu0UDm6cYdv7enkMqCLNkRLx9LOH65ClD3ucd5LkYnLQkA7F63kteQG+A5nJtYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id EFCE6CC02EA;
	Mon, 22 Apr 2024 10:32:25 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP; Mon, 22 Apr 2024 10:32:23 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id C270ACC02D7;
	Mon, 22 Apr 2024 10:32:23 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id BA56134316B; Mon, 22 Apr 2024 10:32:23 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id B86FB34316A;
	Mon, 22 Apr 2024 10:32:23 +0200 (CEST)
Date: Mon, 22 Apr 2024 10:32:23 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>, 
    Alexander Maltsev <keltar.gw@gmail.com>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: ipset: Add list flush to cancel_gc
In-Reply-To: <20240417135141.18288-1-keltar.gw@gmail.com>
Message-ID: <4b7724e0-f54e-ecc1-c992-e117b571b17b@netfilter.org>
References: <20240417135141.18288-1-keltar.gw@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Wed, 17 Apr 2024, Alexander Maltsev wrote:

> Flushing list in cancel_gc drops references to other lists right away,
> without waiting for RCU to destroy list. Fixes race when referenced
> ipsets can't be destroyed while referring list is scheduled for destroy.
> 
> Signed-off-by: Alexander Maltsev <keltar.gw@gmail.com>
> ---
>  kernel/net/netfilter/ipset/ip_set_list_set.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/net/netfilter/ipset/ip_set_list_set.c b/kernel/net/netfilter/ipset/ip_set_list_set.c
> index cc2e5b9..0d15f4f 100644
> --- a/kernel/net/netfilter/ipset/ip_set_list_set.c
> +++ b/kernel/net/netfilter/ipset/ip_set_list_set.c
> @@ -552,6 +552,9 @@ list_set_cancel_gc(struct ip_set *set)
>  
>  	if (SET_WITH_TIMEOUT(set))
>  		timer_shutdown_sync(&map->gc);
> +
> +	/* Flush list to drop references to other ipsets */
> +	list_set_flush(set);
>  }
>  
>  static const struct ip_set_type_variant set_variant = {

Looks good, Pablo please apply to the nf-next tree. Thanks!

Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>

Best regards,
Jozsef
-- 
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
