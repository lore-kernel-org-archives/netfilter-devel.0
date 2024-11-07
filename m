Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0655E1DFE24
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Nov 2024 10:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730976955; cv=none; b=SVhZ/K1XzHFIOzDvXrCPoBrWwGQqYXm/ZOsIn/vKk2Ryzts7uP6Ttklk5ErPZoP5fqJb3vmw8wv6rA3/hRdTPhTwFeHOUYrT1RmAlqgBT+xo5S6sEiNf6v90BKSi7HsI5LzHvjuW9XijbyCW+wf9EmiJBxv6HyDHUKH5Anl9aWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730976955; c=relaxed/simple;
	bh=Ptg2YNRv84Ka/YjxoLsk2KHmK2F0sE89zVFLQauoKXs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l/kwgRHAJxTREabQ7dA1svXmTmZXqDUUh0ASy9JszB/nRHXcL+glrxDH6IVdh/N4XG/AxRqt5cJ7yiKny7y0IsWjo/CoddrI3DnLqXnizwGoJXxB1ROHrjj8MrRWkad1lf9BDcn7ZA/v2z7Ar2RCFDwZZW5rlms0eoB8hZcfifc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jEVJFlfS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jEVJFlfS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730976952;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oAYdNfqYDY76D70Kko/7k/uzFJvDwWVIjYLWnlnNFVU=;
	b=jEVJFlfS9RgOQZdXqWK1tJoj/7sLk6JtSDmHnBbA85rxTnDSF1ughvSdsM9ORQa0AdAzk5
	5Fy6NFnkxneAZTbWijnb7PDtYKb3rfJ69QUC/QyoltvQe6dnJCkSCFxc3AEuxGLS8MnGP8
	RQctBT0GxPp7OtSHXTJqjBORBuBI7Ok=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-7mt722JrOLmVQ5O3rW6FdQ-1; Thu, 07 Nov 2024 05:55:51 -0500
X-MC-Unique: 7mt722JrOLmVQ5O3rW6FdQ-1
X-Mimecast-MFC-AGG-ID: 7mt722JrOLmVQ5O3rW6FdQ
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4315a0f25afso5677405e9.3
        for <netfilter-devel@vger.kernel.org>; Thu, 07 Nov 2024 02:55:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730976950; x=1731581750;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oAYdNfqYDY76D70Kko/7k/uzFJvDwWVIjYLWnlnNFVU=;
        b=YN8wXEbYqxcWIgn2pnFWMv28sIP2klhHBjE2kzGHwzlvh26iVemsY1JdLJv3pfwa53
         FXot7YzWFMvYg4pGhG9/FOHcCUlgrZ6HkL0DYfkzUIgymhnsOlCKbVt8ObmRtAvL7S17
         KqGzMARqjn/HGC50yYsVXP9VKKwWzTdbdrTZVV4WTejaV1mZFmpNoIGOcX9+5H7NYIHa
         csfo5RD1l9jXy9b1vZioBzz0g3NeRxZVIIE2bySLo6NLUHevFiKdybWyv8JkWcUJqbop
         77oXi8KkY0mSOG73EXQ84HUgQI4h4pc8DpMoO4Wa/8HNpXLFJgJkZzmfQNW3TBUwKy5t
         PYTA==
X-Forwarded-Encrypted: i=1; AJvYcCV6XDPRxrilPV5v6+d7UMkINpv1qKq9SHyoHMzNxpbwMDireQkgawJ7jxJAPSTD2VkAIKBgpzdKWeVn6tD09iE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkqG7bzete5fDRlQXlgHgd3XxqQFVCYfzVAcKtrumdx6Ot1+1b
	qeuJ8/+T0R8BEskqhmKXfiF4WZ2V0T6h/5dhSArkzuEZUXz8S4TtsOTqhfr/+XNLnhuiFUklXgX
	GB008nthCwLe+ZYXEMH2bGWCsLbsRcMwRLBdcXvmjlS5GUljkeg54hOOgchXyUo8Idz41fGrDLi
	vp
X-Received: by 2002:a05:600c:214d:b0:431:b42a:2978 with SMTP id 5b1f17b1804b1-431b42a2d0emr323338255e9.9.1730976950085;
        Thu, 07 Nov 2024 02:55:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGgM0/NIP9GnKSCaXLIZ3wcMjfxblKc/73rIIp2MQHCe9Kkfyj7lS7BGw7OtgMp+27yviafuA==
X-Received: by 2002:a05:600c:214d:b0:431:b42a:2978 with SMTP id 5b1f17b1804b1-431b42a2d0emr323338015e9.9.1730976949737;
        Thu, 07 Nov 2024 02:55:49 -0800 (PST)
Received: from [192.168.88.24] (146-241-44-112.dyn.eolo.it. [146.241.44.112])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432b05c26e3sm19610585e9.33.2024.11.07.02.55.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Nov 2024 02:55:49 -0800 (PST)
Message-ID: <362a90d1-a331-4bcc-8f14-495baf5c2309@redhat.com>
Date: Thu, 7 Nov 2024 11:55:47 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 1/1] netfilter: nf_tables: wait for rcu grace period
 on net_device removal
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
 edumazet@google.com, fw@strlen.de
References: <20241106235853.169747-1-pablo@netfilter.org>
 <20241106235853.169747-2-pablo@netfilter.org>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20241106235853.169747-2-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,
On 11/7/24 00:58, Pablo Neira Ayuso wrote:
> 8c873e219970 ("netfilter: core: free hooks with call_rcu") removed
> synchronize_net() call when unregistering basechain hook, however,
> net_device removal event handler for the NFPROTO_NETDEV was not updated
> to wait for RCU grace period.
> 
> Note that 835b803377f5 ("netfilter: nf_tables_netdev: unregister hooks
> on net_device removal") does not remove basechain rules on device
> removal, I was hinted to remove rules on net_device removal later, see
> 5ebe0b0eec9d ("netfilter: nf_tables: destroy basechain and rules on
> netdevice removal").
> 
> Although NETDEV_UNREGISTER event is guaranteed to be handled after
> synchronize_net() call, this path needs to wait for rcu grace period via
> rcu callback to release basechain hooks if netns is alive because an
> ongoing netlink dump could be in progress (sockets hold a reference on
> the netns).
> 
> Note that nf_tables_pre_exit_net() unregisters and releases basechain
> hooks but it is possible to see NETDEV_UNREGISTER at a later stage in
> the netns exit path, eg. veth peer device in another netns:
> 
>  cleanup_net()
>   default_device_exit_batch()
>    unregister_netdevice_many_notify()
>     notifier_call_chain()
>      nf_tables_netdev_event()
>       __nft_release_basechain()
> 
> In this particular case, same rule of thumb applies: if netns is alive,
> then wait for rcu grace period because netlink dump in the other netns
> could be in progress. Otherwise, if the other netns is going away then
> no netlink dump can be in progress and basechain hooks can be released
> inmediately.
> 
> While at it, turn WARN_ON() into WARN_ON_ONCE() for the basechain
> validation, which should not ever happen.
> 
> Fixes: 835b803377f5 ("netfilter: nf_tables_netdev: unregister hooks on net_device removal")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/net/netfilter/nf_tables.h |  2 ++
>  net/netfilter/nf_tables_api.c     | 41 +++++++++++++++++++++++++------
>  2 files changed, 36 insertions(+), 7 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index 91ae20cb7648..8dd8e278843d 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -1120,6 +1120,7 @@ struct nft_chain {
>  	char				*name;
>  	u16				udlen;
>  	u8				*udata;
> +	struct rcu_head			rcu_head;

I'm sorry to be pedantic but the CI is complaining about the lack of
kdoc for this field...

>  
>  	/* Only used during control plane commit phase: */
>  	struct nft_rule_blob		*blob_next;
> @@ -1282,6 +1283,7 @@ struct nft_table {
>  	struct list_head		sets;
>  	struct list_head		objects;
>  	struct list_head		flowtables;
> +	possible_net_t			net;

... and this one ...

>  	u64				hgenerator;
>  	u64				handle;
>  	u32				use;

[...]
> +static void nft_release_basechain_rcu(struct rcu_head *head)
> +{
> +	struct nft_chain *chain = container_of(head, struct nft_chain, rcu_head);
> +	struct nft_ctx ctx = {
> +		.family	= chain->table->family,
> +		.chain	= chain,
> +		.net	= read_pnet(&chain->table->net),
> +	};
> +
> +	__nft_release_basechain_now(&ctx);
> +	put_net(ctx.net);

... and also about deprecated API usage here, the put_net_tracker()
version should be preferred.

Given this change will likely land on very old trees I guess the tracker
conversion is better handled as a follow-up net-next patch.

Would you mind addressing the kdoc above? Today PR will be handled by
Jakub quite later, so there is a bit of time.

Thanks!

Paolo

