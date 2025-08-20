Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD0D2EBDE0;
	Wed, 20 Aug 2025 11:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755689511; cv=none; b=BQSrvbHw05NuyCtwmtbm/Ek1S5CS12IRj4Pw7mxc3jgf9HxwNy/Oxm1CCgMLArCrxwin41pkdrVL0c9hqs3XGI/enmKr0zpXyakEAzjDpjs9T6CJnbT639KBdZfaRToHSOF6toZHJ2NKvmgyZbk7lAeP3iOfe/lqh2kUay4kLWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755689511; c=relaxed/simple;
	bh=klfgj4WdEOsavVwBNUw+UR7Xf33AREIENyMxTC80kgU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dMtZlaH0mWABaAroiWOtPwtCNDKbYWGKSaEIJZXT5m7ZSUUDYVNWyhq+7xq0z8vM9pAaHg6s13EgSr4brfPeFKQJqmNl4Sbev4GTLU85cPmA0PAK+3m+k/XF7lQd1n6NixyY2Ry9Fe1GhbyS5VAS9Y78RdWW6I6QARu6/BtV+rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D5EE160242; Wed, 20 Aug 2025 13:31:46 +0200 (CEST)
Date: Wed, 20 Aug 2025 13:31:46 +0200
From: Florian Westphal <fw@strlen.de>
To: Wang Liang <wangliang74@huawei.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, razor@blackwall.org,
	idosch@nvidia.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	yuehaibing@huawei.com, zhangchangzhong@huawei.com,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	bridge@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] netfilter: br_netfilter: reread nf_conn from skb
 after confirm()
Message-ID: <aKWyImI9qxi6GDIF@strlen.de>
References: <20250820043329.2902014-1-wangliang74@huawei.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250820043329.2902014-1-wangliang74@huawei.com>

Wang Liang <wangliang74@huawei.com> wrote:
> Previous commit 2d72afb34065 ("netfilter: nf_conntrack: fix crash due to
> removal of uninitialised entry") move the IPS_CONFIRMED assignment after
> the hash table insertion.

How is that related to this change?
As you write below, the bug came in with 62e7151ae3eb.

> To solve the hash conflict, nf_ct_resolve_clash() try to merge the
> conntracks, and update skb->_nfct. However, br_nf_local_in() still use the
> old ct from local variable 'nfct' after confirm(), which leads to this
> issue. Fix it by rereading nfct from skb.
> 
> Fixes: 62e7151ae3eb ("netfilter: bridge: confirm multicast packets before passing them up the stack")
> Signed-off-by: Wang Liang <wangliang74@huawei.com>
> ---
>  net/bridge/br_netfilter_hooks.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
> index 94cbe967d1c1..55b1b7dcb609 100644
> --- a/net/bridge/br_netfilter_hooks.c
> +++ b/net/bridge/br_netfilter_hooks.c
> @@ -626,6 +626,7 @@ static unsigned int br_nf_local_in(void *priv,
>  		break;
>  	}
>  
> +	nfct = skb_nfct(skb);
>  	ct = container_of(nfct, struct nf_conn, ct_general);
>  	WARN_ON_ONCE(!nf_ct_is_confirmed(ct));

There is a second bug here, confirm can return NF_DROP and
nfct will be NULL.

Can you make this change too? (or something similar)?

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 94cbe967d1c1..69b7b7c7565e 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -619,8 +619,9 @@ static unsigned int br_nf_local_in(void *priv,
        nf_bridge_pull_encap_header(skb);
        ret = ct_hook->confirm(skb);
        switch (ret & NF_VERDICT_MASK) {
+       case NF_DROP:
        case NF_STOLEN:
-               return NF_STOLEN;
+               return ret;


nfct reload seems correct, thanks for catching this.
