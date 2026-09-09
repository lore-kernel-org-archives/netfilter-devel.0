Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E5934216C;
	Wed,  9 Sep 2026 11:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788952590; cv=none; b=n1PLJnnGSHKd/jmtpj0XA7unLj4bbKRHAvq9g1m3sTZCor0x2v0tSeel2NSiVgzXgI4m8LJT67bmQ9hzafPDVN9SLxclNCpT/uuCdY1/26FGbRBpOP6dwRNtfQhGdCDNMYN9JhEjUn6tR8XV+2jlq7qgLTwkrq2Pd/0rbIZIhWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788952590; c=relaxed/simple;
	bh=pM18hodoYh89Gegf5eGFurmx1byx//TJX5LP6hLooqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V3nP1jFPSbJybSCWLBX3dxPzy/1exCwPWAGpC9dDHEmjNE1UshTBlZBdG95V+YxsKsPGVor2imCDU2f9U58sTQX9yP590dZLJ+t93eE0+VWa/5LC7JfYcfXvccRd4UKGjGushRJQyXcbJYWT7uZVAK/v4msbNJW2qk0eqgAPEIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=I9MY6P17; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="I9MY6P17"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4ckrxe/i82aP6rQ3gEczXf00HbaLYCnnzYIs+1cYnUA=; b=I9MY6P17RMOR6umrSD7CrvQbB6
	Fq6xrt0UEQwtcfJy+3/2c56gGJJECNjfhdKw2ttRedzjX2sN7xK5SZPkW9VPPnbp+GJAPgB718/JZ
	J/tLGVligIIXn1CJjIT02RSzH5XR/hCm9PX+4awvYqugW1pamVytMM9gOZxr4QGWAF5om/UpWduBU
	0ARPhpr774jtDA8CLnIte6F8IS89q1/SuC6yWKh32XLdwtW6PnFOX9fGycGX44ImWWq/AiSUpP+S3
	LA5v+8A4ksBfh9u8aC5Oh3idoQSHkPB1uMehULffYICFT29V63E3+EA8BPYSkOWBI5JZOLf3trHgn
	d15vMe2A==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1x4GHo-000000006wU-2nnZ;
	Wed, 09 Sep 2026 13:16:16 +0200
Date: Wed, 9 Sep 2026 13:16:16 +0200
From: Phil Sutter <phil@nwl.cc>
To: Qingfang Deng <qingfang.deng@linux.dev>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: flowtable: check namespace before
 iterating flows
Message-ID: <aqFAALdUODUjUMo0@orbyte.nwl.cc>
References: <20260909081705.1512600-1-qingfang.deng@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909081705.1512600-1-qingfang.deng@linux.dev>

Hi,

On Wed, Sep 09, 2026 at 04:17:04PM +0800, Qingfang Deng wrote:
> nf_flow_table_cleanup() walks every registered flow table, checking the
> network namespace for each flow in nf_flow_table_do_cleanup(). As a
> result, tables in other namespaces are still iterated and their cleanup
> work is flushed.
> 
> Compare the flow table's namespace with the device's namespace in
> nf_flow_table_cleanup() and skip nonmatching tables. This avoids
> unnecessary iteration and work flushing, and leaves the per-flow cleanup
> callback to check only the interface index.
> 
> Signed-off-by: Qingfang Deng <qingfang.deng@linux.dev>
> ---
>  net/netfilter/nf_flow_table_core.c | 17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 03241d4bfd5e..52cca7a8f141 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -730,14 +730,9 @@ static void nf_flow_table_do_cleanup(struct nf_flowtable *flow_table,
>  {
>  	struct net_device *dev = data;
>  
> -	if (!dev) {
> -		flow_offload_teardown(flow);
> -		return;
> -	}
> -
> -	if (net_eq(nf_ct_net(flow->ct), dev_net(dev)) &&
> -	    (flow->tuplehash[0].tuple.iifidx == dev->ifindex ||
> -	     flow->tuplehash[1].tuple.iifidx == dev->ifindex))
> +	if (!dev ||
> +	    flow->tuplehash[0].tuple.iifidx == dev->ifindex ||
> +	    flow->tuplehash[1].tuple.iifidx == dev->ifindex)
>  		flow_offload_teardown(flow);
>  }
>  
> @@ -754,8 +749,10 @@ void nf_flow_table_cleanup(struct net_device *dev)
>  	struct nf_flowtable *flowtable;
>  
>  	mutex_lock(&flowtable_lock);
> -	list_for_each_entry(flowtable, &flowtables, list)
> -		nf_flow_table_gc_cleanup(flowtable, dev);
> +	list_for_each_entry(flowtable, &flowtables, list) {
> +		if (net_eq(read_pnet(&flowtable->net), dev_net(dev)))
> +			nf_flow_table_gc_cleanup(flowtable, dev);
> +	}

A second caller of nf_flow_table_gc_cleanup is
nf_flow_table_indr_cleanup in net/netfilter/nf_flow_table_offload.c. Is
the net_eq-check needed there as well? If not, could you please update
the patch description with a statement explaining why?

Thanks, Phil

>  	mutex_unlock(&flowtable_lock);
>  }
>  EXPORT_SYMBOL_GPL(nf_flow_table_cleanup);
> -- 
> 2.43.0
> 
> 
