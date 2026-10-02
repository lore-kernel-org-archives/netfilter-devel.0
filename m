Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11F51DF98F;
	Fri,  2 Oct 2026 09:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790934939; cv=none; b=cubOAdhgDNGs+E4SDKUUzZnimx2LT49OYtKJI4wOld66QjCKKmh2iFrKHd8ND3EcGjjuzmx/nPPUe+1bgoX9ucmOCOqg1p1hJ8Tk3Ilzm880yLZ9fzYq9QwdUeLyXxB9OZvtf2k76koaOyc/KBF/yFFuz+fTlMm24VzVlkp6qqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790934939; c=relaxed/simple;
	bh=NvFJmMpVkWwdWLqUID9EtsNEdV8N1zArI5mT3nmiQuk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C76eopQQicQ9hTz5P1ad92Dv/rv+LNKXWSMc/Z1Hzbp8HaEA7VdN8W+Bhhpg2fT7tgQwND42sActbc/npqjADyasyrK8IgMY3Uso5DfgUo8O/XQNCFkoHrqi6nPweqJTtjNP3Oonxw/9XEqZgIl4lxuIZ6ahQ0ekwCaZ7XZ+NHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=d5Ulbqbp; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="d5Ulbqbp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790934927;
	bh=F2JP1gIQQWSa5U3EZYQzsofRPJ5Dbb0Cl5yBaKpzQL8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d5UlbqbpUQzOR51ptWfsIi53zr2Km9xVgMwrpL5lWGtyqso5eXSYKVJKIQQttZNEU
	 jebPlYckFnrV9vCp1bTPiyesXMb6gXLTUiM/NBTXpl4ONPno1uSW2WGIKDIAVgI7AN
	 cMKcmRmcmPz4JtDk58QpfbEc2cadNYGsFnspBtr9S3/vFpZWtf18i19j5pQP708JJc
	 DEwio656H7dt6ab80orY5sZC0hoC4SZ9q8t0UoFXrdt1ftsFJ0Cvno04T+wtR97Dzi
	 MA7DcV7qH8/xeDQn3qwUP+lQ+kcRVtLxXOFr64zC/1kFwy099qcT+XYLOk1SpKR4cY
	 MCZpNOH7zae6Q==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 7DCE06069D;
	Fri,  2 Oct 2026 11:55:27 +0200 (CEST)
Date: Fri, 2 Oct 2026 11:55:25 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Daehyeon Ko <4ncienth@gmail.com>
Cc: fw@strlen.de, phil@nwl.cc, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH net] netfilter: conntrack: avoid recursive master
 destruction
Message-ID: <ar9_jXzMPf1zh-gi@chamomile>
References: <20261001180224.1018290-1-4ncienth@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261001180224.1018290-1-4ncienth@gmail.com>

On Fri, Oct 02, 2026 at 03:02:24AM +0900, Daehyeon Ko wrote:
> Conntrack entries created through ctnetlink can reference another
> confirmed entry as their master.  There is no limit on the resulting
> chain depth.

Then, just limit ctnetlink because this makes no sense.

> When the last external reference to such a chain is dropped,
> nf_ct_destroy() puts the master reference.  If that is the master's last
> reference, nf_ct_put() invokes nf_ct_destroy() recursively.  A sufficiently
> long chain therefore exhausts the task stack.
> 
> Release the master reference directly.  When it was the final reference,
> continue destroying it in the current invocation.  This keeps the existing
> refcount and lifetime rules while bounding stack use.
> 
> Fixes: 5faa1f4cb5a1 ("[NETFILTER]: nf_conntrack_netlink: add support to related connections")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
> ---
> Tested on net e23a64eb244356ee47c0620f0722d51bd88db522 and exact
> v6.12.105. A source reproducer and userns launcher are available privately
> on request and are intentionally omitted from this public posting.
> 
> The trigger needs CONFIG_USER_NS, CONFIG_NET_NS, CONFIG_NF_CONNTRACK and
> CONFIG_NF_CT_NETLINK. Host UID 65534 used only namespace-local
> CAP_NET_ADMIN. The essential vulnerable trace is:
> 
>   BUG: TASK stack guard page was hit at ffffc90001197ff8
>   CPU: 1 UID: 65534 PID: 178 Comm: conntrack-maste
>   nf_ct_destroy+0x1ac/0x5f0 (repeated)
> 
> Fixed current and LTS 6,000-entry runs ended with nf_conntrack_count=0 and
> no crash marker. The netdev allyesconfig and allmodconfig W=1 full builds
> were not run.
> 
>  net/netfilter/nf_conntrack_core.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index d0d9e5ea84a09..0ce6141b3dfd7 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -592,6 +592,10 @@ static void warn_on_keymap_list_leak(const struct net *net)
>  void nf_ct_destroy(struct nf_conntrack *nfct)
>  {
>  	struct nf_conn *ct = (struct nf_conn *)nfct;
> +	struct nf_conn *master;
> +	bool destroy_master;
> +
> +again:
>  
>  	WARN_ON(refcount_read(&nfct->use) != 0);
>  
> @@ -610,10 +614,17 @@ void nf_ct_destroy(struct nf_conntrack *nfct)
>  	 */
>  	nf_ct_remove_expectations(ct);
>  
> -	if (ct->master)
> -		nf_ct_put(ct->master);
> +	master = ct->master;
> +	destroy_master = master &&
> +		refcount_dec_and_test(&master->ct_general.use);
>  
>  	nf_conntrack_free(ct);
> +
> +	if (destroy_master) {
> +		ct = master;
> +		nfct = &ct->ct_general;
> +		goto again;
> +	}
>  }
>  EXPORT_SYMBOL(nf_ct_destroy);
>  
> -- 
> 2.55.0
