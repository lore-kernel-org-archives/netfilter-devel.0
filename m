Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23ABA2E3EB
	for <netfilter-devel@vger.kernel.org>; Sun, 22 Sep 2024 07:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726990351; cv=none; b=Q5DqgypDprV2Di+4CvGpDqtzcFjryC4XyEaAYhWP0MVdlYvG1NbrSTW9W3D4kxh9K+HCPOopmGVYOk8PsnJYXJqS+Ev7vAIJLVQhFv6Qv3kDxRE4jxdryYChF8V9FNCLH+8kCXRVaq3s+3TQeqzke66NvjZelJFJ0gZNcG5HSMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726990351; c=relaxed/simple;
	bh=wcX5ENpFmFK7VfofO2SDwXsSlSz0Lj6JDjMKioHm8b4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DJwXw7s+jdKZxQn1grG1afvPv3L4p3SIRRfveaLZmTw1qXSasdgILPMxTcQLNf2AaODAUK58iRb0nF/8fgXV47uQIK+TjsBPSaYqedfXkEvTCLtFnVKc2Dwjeg5nTsMwWF1f+gV17S5/kbf5PgOylA0QFBjEeZr9jPIycPZPuOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1ssH4y-0008WT-Q1; Sun, 22 Sep 2024 09:32:24 +0200
Date: Sun, 22 Sep 2024 09:32:24 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v4 13/16] netfilter: nf_tables: Handle
 NETDEV_CHANGENAME events
Message-ID: <20240922073224.GA32587@breakpoint.cc>
References: <20240920202347.28616-1-phil@nwl.cc>
 <20240920202347.28616-14-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240920202347.28616-14-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> For the sake of simplicity, treat them like consecutive NETDEV_REGISTER
> and NETDEV_UNREGISTER events. If the new name matches a hook spec and
> registration fails, escalate the error and keep things as they are.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Changes since v3:
> - Register first and handle errors to avoid having unregistered the
>   device but registration fails.
> ---
>  net/netfilter/nf_tables_api.c    | 5 +++++
>  net/netfilter/nft_chain_filter.c | 5 +++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 2684990dd3dc..4d40c1905735 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -9371,6 +9371,11 @@ static int nf_tables_flowtable_event(struct notifier_block *this,
>  	struct nft_table *table;
>  	struct net *net;
>  
> +	if (event == NETDEV_CHANGENAME) {
> +		if (nf_tables_flowtable_event(this, NETDEV_REGISTER, ptr))
> +			return NOTIFY_BAD;
> +		event = NETDEV_UNREGISTER;
> +	}

Consider flowtable that should claim devices "pv*".
You get CHANGENAME, device name is, say, pv5.

Device name is registered in nf_tables_flowtable_event().
Then, event is set to UNREGISTER.

AFAICS this may unreg the device again immediately, as unreg part
only compares device pointer and we can't be sure the device was
part of any flowtable when CHANGENAME was triggered.

So I think nf_tables_flowtable_event() must handle CHANGENAME
directly, first check if any flowtable holds the device at this time,
then check if we need to register it with a new name, and do unreg
only if it was previously part of any flowtable.

Same logic needed for netdev chains.

Does that make sense?
