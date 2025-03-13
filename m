Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CB62E336B;
	Thu, 13 Mar 2025 20:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741896612; cv=none; b=ewgoBArDDMpJCyGnOPJM17VkD/O4G9ULDdSqqhKQZEbxvBUYdAOcLnqqP4IKaDmAdrHr7EWEepTEjvFgzhg4YQT1rBsB0lfGc0eV48zTZHe1jYvqO/hVvqqJ84kVmYFggHljhCfukBuz/4fWyan24D47e2u6owFJUMLqaLReuPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741896612; c=relaxed/simple;
	bh=wsERaqiWQgxWymOEQd/Ph106WUNWiAfphRxnfmdECiw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mochvPpaXDl4jhK76P2orV4bKFLzTygA/MdqMETeA2CbiLW7tu0TTak0v+te6mc026xWOsQjm0yFIYwLQUZEEedtkOlzoyVTCiNH+/6rL3HR52zvjW4aznlRVtiLlNMPzo1lsF0jXG36W1YnYqXPHvCm0h6sc0mTNoqLKOMLwZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tsosZ-0006tJ-6Z; Thu, 13 Mar 2025 21:10:07 +0100
Date: Thu, 13 Mar 2025 21:10:07 +0100
From: Florian Westphal <fw@strlen.de>
To: Chenyuan Yang <chenyuan0y@gmail.com>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, casey@schaufler-ca.com
Subject: Re: [PATCH] net: Initialize ctx to avoid memory allocation error
Message-ID: <20250313201007.GA26103@breakpoint.cc>
References: <20250313195441.515267-1-chenyuan0y@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250313195441.515267-1-chenyuan0y@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

[ trim CCs, CC Casey ]

Chenyuan Yang <chenyuan0y@gmail.com> wrote:
> It is possible that ctx in nfqnl_build_packet_message() could be used
> before it is properly initialize, which is only initialized
> by nfqnl_get_sk_secctx().
> 
> This patch corrects this problem by initializing the lsmctx to a safe
> value when it is declared.
> 
> This is similar to the commit 35fcac7a7c25
> ("audit: Initialize lsmctx to avoid memory allocation error").

Fixes: 2d470c778120 ("lsm: replace context+len with lsm_context")

> Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
> ---
>  net/netfilter/nfnetlink_queue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index 5c913987901a..8b7b39d8a109 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -567,7 +567,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>  	enum ip_conntrack_info ctinfo = 0;
>  	const struct nfnl_ct_hook *nfnl_ct;
>  	bool csum_verify;
> -	struct lsm_context ctx;
> +	struct lsm_context ctx = { NULL, 0, 0 };
>  	int seclen = 0;
>  	ktime_t tstamp;

Someone that understands LSM should clarify what seclen == 0 means.

seclen needs to be > 0 or no secinfo is passed to userland,
yet the secctx release function is called anyway.

Should seclen be initialised to -1?  Or we need the change below too?

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -812,7 +812,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
        }

        nlh->nlmsg_len = skb->len;
-       if (seclen >= 0)
+       if (seclen > 0)
                security_release_secctx(&ctx);
        return skb;

@@ -821,7 +821,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
        kfree_skb(skb);
        net_err_ratelimited("nf_queue: error creating packet message\n");
 nlmsg_failure:
-       if (seclen >= 0)
+       if (seclen > 0)
                security_release_secctx(&ctx);
        return NULL;
 }
