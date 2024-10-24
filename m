Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9348178362;
	Thu, 24 Oct 2024 06:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729751141; cv=none; b=gVcVpvqThbH+p7xOEAz3EKU5EwcxPlvlMdQ9+p9tBfu9x1WYmcB1G1JxCH1BX7sOD1kOBUMeY+kmeeSMuYVbkOU96M4yS4kNOek4TQeHnAEjFicYfLzNJtvk0ekgr/AoExJUtr9CIFTgfNZ3SCZEaGZAPvFYcga0fwk2WCDWCvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729751141; c=relaxed/simple;
	bh=vw5EOB+V79k3EVt1ygjQA5pfUV9Bl0HJg7IrCO9ef5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RePs9bmen59oeuJCLN9YrXI5G0GE/KYxTOxnkzBU6l2Mzb7qXNGBTQ1BMxSHDWNkQG41fNBzKjtI4/8/X+paMHJvuBpeO0xXdN0lShfstoVCDGmZcZtMY1pmIwXee/qQwdKgF27zIlHhEA7QmsyEpw19GD6rn3airvK6uoV2tQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t3rHb-0004Mv-4t; Thu, 24 Oct 2024 08:25:19 +0200
Date: Thu, 24 Oct 2024 08:25:19 +0200
From: Florian Westphal <fw@strlen.de>
To: Dong Chenchen <dongchenchen2@huawei.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	fw@strlen.de, kuniyu@amazon.com, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, yuehaibing@huawei.com
Subject: Re: [PATCH net v2] net: netfilter: Fix use-after-free in get_info()
Message-ID: <20241024062519.GA16685@breakpoint.cc>
References: <20241024014701.2086286-1-dongchenchen2@huawei.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241024014701.2086286-1-dongchenchen2@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Dong Chenchen <dongchenchen2@huawei.com> wrote:
> While xt_table module was going away and has been removed from
> xt_templates list, we couldnt get refcnt of xt_table->me. Check
> module in xt_net->tables list re-traversal to fix it.
> 
> Fixes: fdacd57c79b7 ("netfilter: x_tables: never register tables by default")
> Signed-off-by: Dong Chenchen <dongchenchen2@huawei.com>
> ---
>  net/netfilter/x_tables.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> index da5d929c7c85..709840612f0d 100644
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -1269,7 +1269,7 @@ struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
>  
>  	/* and once again: */
>  	list_for_each_entry(t, &xt_net->tables[af], list)
> -		if (strcmp(t->name, name) == 0)
> +		if (strcmp(t->name, name) == 0 && owner == t->me)
>  			return t;

LGTM, thanks.

Reviewed-by: Florian Westphal <fw@strlen.de>
