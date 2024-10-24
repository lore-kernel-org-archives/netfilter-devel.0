Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73931B0F26;
	Thu, 24 Oct 2024 16:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729786234; cv=none; b=AD5TU1poxsq6nDSu6eDWoq39P5SMkeg0UDZdVgn5ENGUagXZUsRKpo3p8X8eTa6GFeX2VXqkkm7KsaztsTVYCZWRB9YwEmoRho68dKU2aWYeHyVVt78EgR6AsRDuWKuQBiHUdaaH6cXb3ux+c4B53oEEY8qKcemP99Ews7CKszU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729786234; c=relaxed/simple;
	bh=OpjoVF0VuGF5sKCt7TDKYW928JWMZOf7mNiX1LT8/8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jKU/zZG7BSxEXz+MCHQMOSra2Kgf0VeIkwfEtSqcwCvt0mzvvcz9rfg7kAFKaY9dZ9vt8tDBRnI+wx1FNW2vXUxG830jJSG1KWYkqsHt5UlrAjRYlajrSC59iqhjV4REvB9Aq+65dhKjTH1qvIQK9UMrc3MbWg9wKFKqLxJiBEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=60766 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t40Pf-004H0p-NK; Thu, 24 Oct 2024 18:10:17 +0200
Date: Thu, 24 Oct 2024 18:10:14 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: paul@paul-moore.com, linux-security-module@vger.kernel.org,
	jmorris@namei.org, serge@hallyn.com, keescook@chromium.org,
	john.johansen@canonical.com, penguin-kernel@i-love.sakura.ne.jp,
	stephen.smalley.work@gmail.com, linux-kernel@vger.kernel.org,
	selinux@vger.kernel.org, mic@digikod.net, netdev@vger.kernel.org,
	audit@vger.kernel.org, netfilter-devel@vger.kernel.org,
	Todd Kjos <tkjos@google.com>
Subject: Re: [PATCH v3 2/5] LSM: Replace context+len with lsm_context
Message-ID: <ZxpxZuErvXSLApsf@calendula>
References: <20241023212158.18718-1-casey@schaufler-ca.com>
 <20241023212158.18718-3-casey@schaufler-ca.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241023212158.18718-3-casey@schaufler-ca.com>
X-Spam-Score: -1.6 (-)

Hi Casey,

This is a review of the netfilter chunk.

On Wed, Oct 23, 2024 at 02:21:55PM -0700, Casey Schaufler wrote:
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index 86a57a3afdd6..dd74d4c67c69 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -360,8 +360,8 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
>  	struct lsm_context ctx;
>  	int ret;
>  
> -	ret = security_secid_to_secctx(ct->secmark, &ctx.context, &ctx.len);
> -	if (ret)
> +	ret = security_secid_to_secctx(ct->secmark, &ctx);
> +	if (ret < 0)
>  		return 0;
>  
>  	ret = -1;
> @@ -665,8 +665,8 @@ static inline int ctnetlink_secctx_size(const struct nf_conn *ct)
>  #ifdef CONFIG_NF_CONNTRACK_SECMARK
>  	int len, ret;
>  
> -	ret = security_secid_to_secctx(ct->secmark, NULL, &len);
> -	if (ret)
> +	ret = security_secid_to_secctx(ct->secmark, NULL);

This breaks here.

len is really used, this should be instead:

	ret = security_secid_to_secctx(ct->secmark, &ctx);

[...]
        return nla_total_size(0) /* CTA_SECCTX */
               + nla_total_size(sizeof(char) * ctx.len); /* CTA_SECCTX_NAME */
#else
        return 0;
#endif
}

> +	if (ret < 0)
>  		return 0;
>  
>  	return nla_total_size(0) /* CTA_SECCTX */
> diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
> index 5f7fd23b7afe..502cf10aab41 100644
> --- a/net/netfilter/nf_conntrack_standalone.c
> +++ b/net/netfilter/nf_conntrack_standalone.c
> @@ -175,8 +175,8 @@ static void ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
>  	struct lsm_context ctx;
>  	int ret;
>  
> -	ret = security_secid_to_secctx(ct->secmark, &ctx.context, &ctx.len);
> -	if (ret)
> +	ret = security_secid_to_secctx(ct->secmark, &ctx);
> +	if (ret < 0)
>  		return;
>  
>  	seq_printf(s, "secctx=%s ", ctx.context);
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index 37757cd77cf1..5110f29b2f40 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -470,18 +470,18 @@ static int nfqnl_put_sk_classid(struct sk_buff *skb, struct sock *sk)
>  	return 0;
>  }
>  
> -static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
> +static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, struct lsm_context *ctx)
>  {
>  	u32 seclen = 0;
>  #if IS_ENABLED(CONFIG_NETWORK_SECMARK)
> +

remove unneeded line.

>  	if (!skb || !sk_fullsock(skb->sk))
>  		return 0;
>  
>  	read_lock_bh(&skb->sk->sk_callback_lock);
>  
>  	if (skb->secmark)
> -		security_secid_to_secctx(skb->secmark, secdata, &seclen);
> -
> +		seclen = security_secid_to_secctx(skb->secmark, ctx);
>  	read_unlock_bh(&skb->sk->sk_callback_lock);
>  #endif
>  	return seclen;
> @@ -567,8 +567,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>  	enum ip_conntrack_info ctinfo = 0;
>  	const struct nfnl_ct_hook *nfnl_ct;
>  	bool csum_verify;
> -	struct lsm_context scaff; /* scaffolding */
> -	char *secdata = NULL;
> +	struct lsm_context ctx;

Help us make this get closer to revert xmas tree:

  	enum ip_conntrack_info ctinfo = 0;
  	const struct nfnl_ct_hook *nfnl_ct;
+	struct lsm_context ctx;
  	bool csum_verify;
-	struct lsm_context scaff; /* scaffolding */
-	char *secdata = NULL;

>  	bool csum_verify;
> -	struct lsm_context scaff; /* scaffolding */
> -	char *secdata = NULL;

>  	u32 seclen = 0;
>  	ktime_t tstamp;
>  
> @@ -643,8 +642,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>  	}
>  
>  	if ((queue->flags & NFQA_CFG_F_SECCTX) && entskb->sk) {
> -		seclen = nfqnl_get_sk_secctx(entskb, &secdata);
> -		if (seclen)
> +		seclen = nfqnl_get_sk_secctx(entskb, &ctx);
> +		if (seclen >= 0)
>  			size += nla_total_size(seclen);
>  	}
>  
> @@ -783,7 +782,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>  	if (nfqnl_put_sk_classid(skb, entskb->sk) < 0)
>  		goto nla_put_failure;
>  
> -	if (seclen && nla_put(skb, NFQA_SECCTX, seclen, secdata))
> +	if (seclen && nla_put(skb, NFQA_SECCTX, ctx.len, ctx.context))
>  		goto nla_put_failure;
>  
>  	if (ct && nfnl_ct->build(skb, ct, ctinfo, NFQA_CT, NFQA_CT_INFO) < 0)
> @@ -811,10 +810,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>  	}
>  
>  	nlh->nlmsg_len = skb->len;
> -	if (seclen) {
> -		lsmcontext_init(&scaff, secdata, seclen, 0);
> -		security_release_secctx(&scaff);
> -	}
> +	if (seclen >= 0)
> +		security_release_secctx(&ctx);
>  	return skb;
>  
>  nla_put_failure:
> @@ -822,10 +819,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>  	kfree_skb(skb);
>  	net_err_ratelimited("nf_queue: error creating packet message\n");
>  nlmsg_failure:
> -	if (seclen) {
> -		lsmcontext_init(&scaff, secdata, seclen, 0);
> -		security_release_secctx(&scaff);
> -	}
> +	if (seclen >= 0)
> +		security_release_secctx(&ctx);
>  	return NULL;
>  }
>  
