Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E15A18E02D;
	Tue, 22 Oct 2024 09:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729590538; cv=none; b=U/qMu2qiwYJTZwGcjznXlYl1kMhJJ2MTURV0JAeSB7QAn1l3Rr5b03rjtNd1iY55lQKUIYZIEYLbFSG92gu2u/eu1bQLJJqsyHaC8TKj7FEgWu0hwNpEn/Lv119sNoBliSQ6iPzypaJ7fbU8WznU7TJBttKohDjkk/Pt0FWcJC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729590538; c=relaxed/simple;
	bh=jEqJUe9yeGE6M9ONasHF2b0aUci9zW4T+caELjnBlJM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EonvGNN6Oo0yDflTrmePDZlXBQZxQJroFbPtlOZeBsWyDAThiNEa6Om1K8DfhjfThi/T/cKkbT62IMsd8FNuoaPPeu7RIUtFvfe0IYsUiv+1fNf3dyA65FpZrCwA6bb1LboxJ8pWmR7Ny5JlnAZJ7Y3JNJMfUiHneh9omg2e2kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t3BVH-000765-3A; Tue, 22 Oct 2024 11:48:39 +0200
Date: Tue, 22 Oct 2024 11:48:39 +0200
From: Florian Westphal <fw@strlen.de>
To: Dong Chenchen <dongchenchen2@huawei.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	fw@strlen.de, kuniyu@amazon.com, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, yuehaibing@huawei.com
Subject: Re: [PATCH net] net: netfilter: Fix use-after-free in get_info()
Message-ID: <20241022094839.GA26371@breakpoint.cc>
References: <20241022085753.2069639-1-dongchenchen2@huawei.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241022085753.2069639-1-dongchenchen2@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Dong Chenchen <dongchenchen2@huawei.com> wrote:
>  net/netfilter/x_tables.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> index da5d929c7c85..359c880ecb07 100644
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -1239,6 +1239,7 @@ struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
>  	struct module *owner = NULL;
>  	struct xt_template *tmpl;
>  	struct xt_table *t;
> +	int err = -ENOENT;
>  
>  	mutex_lock(&xt[af].mutex);
>  	list_for_each_entry(t, &xt_net->tables[af], list)
> @@ -1247,8 +1248,6 @@ struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
>  
>  	/* Table doesn't exist in this netns, check larval list */
>  	list_for_each_entry(tmpl, &xt_templates[af], list) {
> -		int err;
> -
>  		if (strcmp(tmpl->name, name))
>  			continue;
>  		if (!try_module_get(tmpl->me))
> @@ -1267,6 +1266,9 @@ struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
>  		break;
>  	}
>  
> +	if (err < 0)
> +		goto out;
> +
>  	/* and once again: */
>  	list_for_each_entry(t, &xt_net->tables[af], list)
>  		if (strcmp(t->name, name) == 0)

Proabably also:

-  		if (strcmp(t->name, name) == 0)
+               if (strcmp(t->name, name) == 0 && owner == t->me)
