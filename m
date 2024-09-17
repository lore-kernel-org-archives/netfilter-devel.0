Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D3F192B90
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Sep 2024 21:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726607707; cv=none; b=YPzXFwthVkQfTgp7dF8/o5M1wU0W2nXxDZfuBWfBjuF8X5v5Ek6r6DbdQVF7a5q4s4ve5cEWfcfuSazPnVQF8ebPkt3iMByMebe5MG36Zy8rqruzDjkpIHzNA/GIcywxcXAmYJaWp6zmt7G+XHInHTMrsGu8+Ti2sqLLl+9Phg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726607707; c=relaxed/simple;
	bh=+6h9TL52Qv4H9KnX9mUyumON188qJPcsRKalrWbgDAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eZKck0xoFY+AqGS6cjK+eBS33ybm3rXKlTWe8jkLzizpkmcXn5hucHiJHg7mnBwklWSEptIxSgaTm9l/Z3FSlvy3JYmrxaRUWDE61VUNmlr4kjkY0eAJxhBy65Dqza5P1ASrMmwf79JNXxJOWPCOTRXDIj2HEgzqm7D953IwSeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=35180 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sqfXB-000L0s-4N; Tue, 17 Sep 2024 23:14:55 +0200
Date: Tue, 17 Sep 2024 23:14:51 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v3 01/16] netfilter: nf_tables: Keep deleted
 flowtable hooks until after RCU
Message-ID: <ZunxS5U_lrWrL62L@calendula>
References: <20240912122148.12159-1-phil@nwl.cc>
 <20240912122148.12159-2-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240912122148.12159-2-phil@nwl.cc>
X-Spam-Score: -1.9 (-)

On Thu, Sep 12, 2024 at 02:21:33PM +0200, Phil Sutter wrote:
> Documentation of list_del_rcu() warns callers to not immediately free
> the deleted list item. While it seems not necessary to use the
> RCU-variant of list_del() here in the first place, doing so seems to
> require calling kfree_rcu() on the deleted item as well.

LGTM, I plan to take this into nf.git

Thanks.

> Fixes: 3f0465a9ef02 ("netfilter: nf_tables: dynamically allocate hooks per net_device in flowtables")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  net/netfilter/nf_tables_api.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index b6547fe22bd8..2982f49b6d55 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -9180,7 +9180,7 @@ static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
>  		flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
>  					    FLOW_BLOCK_UNBIND);
>  		list_del_rcu(&hook->list);
> -		kfree(hook);
> +		kfree_rcu(hook, rcu);
>  	}
>  	kfree(flowtable->name);
>  	module_put(flowtable->data.type->owner);
> -- 
> 2.43.0
> 
