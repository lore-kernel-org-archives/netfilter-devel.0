Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FBE1F12FC;
	Tue, 11 Feb 2025 14:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739285008; cv=none; b=kBxYonr1SW/STYKHzmznQBQJi6iZEJTibk72gLtPqD5r0mRV7J3kH/DCSo3u2dwB1AB93VjpnN8F0Wdav3VpsqFyP23d9l84t3XRT2ThyJP4nlx+K6dC+SJRgPQjffWPJWjOAI5llN+7J8aT+GmKPPrWXLg8KzK2SKQCfXqH29M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739285008; c=relaxed/simple;
	bh=tQt2YViAGNRUcLLNMB6hphKc7NudM5eIWN91tXZ0fI0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CvNXrN/3IImDxpKcf/tR3thHFVKyQ2XBTUb686JUY8Xc7iP6xF0JvOLyyKkYKQTZDWifFRvV0hiMqHJaplyiQtcIg0iWRvfb6NDMRhklq2Q7XUU6PL4PtAOacS5Ciec+LBl8chdAA3DvovTdJRvOZ1bA9oFGfxgChH0Kf0J0/Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RViKGNih; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RViKGNih"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-ab7d451f7c4so205379066b.0;
        Tue, 11 Feb 2025 06:43:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739285004; x=1739889804; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V+syQltWy2iShpV3VhhxV37TML7DelsfUgKCvN307fw=;
        b=RViKGNihGemvHScsUoIWlqB4F8Y+Vv1Ll+mXlyZmMio0D1p2u4j4Q2xTSPKRBpXnfP
         A5EDvKo5ZhN244bGIi6l89/8c46bPMELWHZu2xcVOZTQH1SzDmVKu1JPw7zy+zoJ9Qos
         HBDA5Zfb/2DWN8OCmJmA3SqfqmvbdGcUECyWrXGgRUxbwCXdliAkDKUgaX0hK9mAMZAg
         PlWokNyUcQO8A4HStBpJ9eV5mAMkbC7CB23HQ1DnpDNTFIgYh8DtDyaRmHK6N1LvE6MD
         KpEoH6fK6nD4HdYSo8Szb7AAQvfWGfKRrPrIj5KQRrrS/EQ6aB/RWRGFiHdTIH5JkEZM
         NnzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739285004; x=1739889804;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V+syQltWy2iShpV3VhhxV37TML7DelsfUgKCvN307fw=;
        b=Hbcv90ga96aZV5Rh+BBNZ1vy5QYmFqTpktipJ/OYpSkPYDIiRlGo3AkMTqVSP8jagN
         Kjf4CR2TQAU9T8JYV4efFpUhQeowxJ6It3q4Hlu96Q6d92McziQidFTl7O2vU1GGPEe9
         6yJ0sBZjVTVXtmKo6J4584YcISViEYi/88YGaHN1uakJo4yNG4jVzKh6JUJTxoN/METZ
         HLzaa1Gg/VAbv/LL7TwOyG9EW9xPXucbUsByHPBV+LCTdKvpyH73y2N6Qs4nEU8fPZD9
         MyqT8Zwym3jezxLi6orv9aMd7uWsyp2HseSJTvRUVhEn3rEFCg8fWG0zaGUHkNaWgQy1
         WLxA==
X-Forwarded-Encrypted: i=1; AJvYcCUt3228LRqTXUjeXbD3y8GtkNsdvgIWtalqpoUACcYm1iS9uWrm08Zv7vks9nT6MDTf2PgJt/6XLTjXVz7wObsT@vger.kernel.org, AJvYcCWhPgsQTAFYsuX0K2PyetOI187egoCP/iCzkPSgL6hGEfLCKCsVQTsRjrEYT7yXZJReUyj6gNSo@vger.kernel.org, AJvYcCWkp10P11GKEs+Rafc+8FNnjja7eEj3FnQH2zsZ31cx8wZGqjf34ihUND6sit8o6ztNCMyMxvn95Ufdot0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHMt5CXxJG33mqMJGn0EAAu/En6SphaPnDIPErmDfmk1Tz202f
	VLuwrzkktNkLb5dpDN1dwe099DDLAucNQ4ycHKayMTMGkGKEzW4h
X-Gm-Gg: ASbGnctVkzHakti597bAJmfiWF8EuPlmHBQeyI10jIzKMJxH58rN0L5SZ0GWicGxF+N
	oa7rJVcTMfnll52RbKYmvLfdkvI5XQJwSBQhuMub4ENs+WQvpLZQEijuR9Pj0npAZo4+ffJ4IUt
	c7/VgQvy8VypMCSgIza8JFH+AmBy/c9ZFZt90eIFyWRUGKe2CsQqy5uGqG+hrmuINOx094vVkTs
	amFtMnSboaFbPAE0BoqEFs+8QgK5YTtlhr/FdNtiqCPUkdCq3Zh8nUAKu3mkmgkvMEIet0zRi2D
	xW7FHjAc6MemYY2MXSz9RHIJNWZ7X+zMapjb6SlJVr767XgO3nrTPWVeU0TrMPbJHzUKnPSasKA
	wwWCYnaIhvz5ywo0WO1ryU0oDUwCq0CnYhsJ1SyKyAzyRXie74AuHLxca9w3AsHDDPA==
X-Google-Smtp-Source: AGHT+IF9jmcJFJFbEK49xdcz+FAYc5JFQf9JpzthNkFP4VwxwCFQdCkq660UzRh31VnMKEshFSn0QQ==
X-Received: by 2002:a17:907:6e86:b0:aa6:9eac:4b8e with SMTP id a640c23a62f3a-ab789bfc7d9mr2013030966b.41.1739285004009;
        Tue, 11 Feb 2025 06:43:24 -0800 (PST)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab7c4a50e73sm394025366b.36.2025.02.11.06.43.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2025 06:43:23 -0800 (PST)
Message-ID: <9ae3548a-844e-4449-9c00-5dd79e804922@gmail.com>
Date: Tue, 11 Feb 2025 15:43:22 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 net-next 05/14] bridge: Add filling forward path from
 port to port
To: Vladimir Oltean <olteanv@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Andrew Lunn <andrew+netdev@lunn.ch>, Pablo Neira Ayuso
 <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>,
 Jiri Pirko <jiri@resnulli.us>, Ivan Vecera <ivecera@redhat.com>,
 Roopa Prabhu <roopa@nvidia.com>, Nikolay Aleksandrov <razor@blackwall.org>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Lorenzo Bianconi <lorenzo@kernel.org>, Joe Damato <jdamato@fastly.com>,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Frank Wunderlich <frank-w@public-files.de>,
 Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, bridge@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org
References: <20250209111034.241571-1-ericwouds@gmail.com>
 <20250209111034.241571-6-ericwouds@gmail.com>
 <20250211132832.aiy6ocvqppoqkd65@skbuf>
Content-Language: en-US
From: Eric Woudstra <ericwouds@gmail.com>
In-Reply-To: <20250211132832.aiy6ocvqppoqkd65@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/11/25 2:28 PM, Vladimir Oltean wrote:
> On Sun, Feb 09, 2025 at 12:10:25PM +0100, Eric Woudstra wrote:
>> @@ -1453,7 +1454,10 @@ void br_vlan_fill_forward_path_pvid(struct net_bridge *br,
>>  	if (!br_opt_get(br, BROPT_VLAN_ENABLED))
>>  		return;
>>  
>> -	vg = br_vlan_group(br);
>> +	if (p)
>> +		vg = nbp_vlan_group(p);
>> +	else
>> +		vg = br_vlan_group(br);
>>  
>>  	if (idx >= 0 &&
>>  	    ctx->vlan[idx].proto == br->vlan_proto) {
> 
> I think the original usage of br_vlan_group() here was incorrect, and so
> is the new usage of nbp_vlan_group(). They should be br_vlan_group_rcu()
> and nbp_vlan_group_rcu().
> 
> The lockdep annotation is important, otherwise I get this with CONFIG_PROVE_LOCKING=y:
> [ 1140.931869] =============================
> [ 1140.935996] WARNING: suspicious RCU usage
> [ 1140.940094] 6.14.0-rc1-00224-gda8926a49ba1-dirty #2666 Not tainted
> [ 1140.946371] -----------------------------
> [ 1140.950520] net/bridge/br_private.h:1604 suspicious rcu_dereference_protected() usage!
> [ 1140.958622]
> [ 1140.958622] other info that might help us debug this:
> [ 1140.958622]
> [ 1140.966752]
> [ 1140.966752] rcu_scheduler_active = 2, debug_locks = 1
> [ 1140.973435] 2 locks held by swapper/0/0:
> [ 1140.977521]  #0: ffffd9f646c333b0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire+0x4/0x40
> [ 1140.986404]  #1: ffffd9f646c333b0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire+0x4/0x48
> [ 1140.995170]
> [ 1140.995170] stack backtrace:
> [ 1140.999636] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.14.0-rc1-00224-gda8926a49ba1-dirty #2666
> [ 1140.999650] Hardware name: LS1028A RDB Board (DT)
> [ 1140.999656] Call trace:
> [ 1140.999660]  show_stack+0x24/0x38 (C)
> [ 1140.999683]  dump_stack_lvl+0x40/0xa0
> [ 1140.999698]  dump_stack+0x18/0x24
> [ 1140.999711]  lockdep_rcu_suspicious+0x174/0x218
> [ 1140.999723]  br_vlan_fill_forward_path_pvid+0x90/0x150
> [ 1140.999735]  br_fill_forward_path+0x54/0x1b0
> [ 1140.999751]  dev_fill_bridge_path+0x9c/0x188
> [ 1140.999766]  nft_dev_fill_bridge_path+0x2ac/0x418
> [ 1140.999785]  nft_flow_offload_bridge_init+0x188/0x1c8
> [ 1140.999801]  nft_flow_offload_eval+0x18c/0x300
> [ 1140.999816]  nft_do_chain+0x1c8/0x538
> [ 1140.999831]  nft_do_chain_bridge+0x15c/0x210
> [ 1140.999846]  nf_hook_slow+0x80/0x130
> [ 1140.999862]  NF_HOOK+0xd8/0x1d0
> [ 1140.999871]  __br_forward+0x138/0x1a0
> [ 1140.999880]  br_forward+0xd8/0x160
> [ 1140.999889]  br_handle_frame_finish+0x3bc/0x5a8
> [ 1140.999900]  br_nf_pre_routing_finish+0x538/0x608
> [ 1140.999917]  NF_HOOK+0x254/0x298
> [ 1140.999933]  br_nf_pre_routing+0x3e8/0x428
> [ 1140.999949]  br_handle_frame+0x264/0x490
> [ 1140.999959]  __netif_receive_skb_core+0x13c/0x1128
> [ 1140.999975]  __netif_receive_skb_list_core+0xd4/0x1e8
> [ 1140.999989]  netif_receive_skb_list_internal+0x224/0x338
> [ 1141.000000]  napi_complete_done+0xb4/0x1d8
> [ 1141.000012]  gro_cell_poll+0x94/0xb8
> [ 1141.000025]  __napi_poll+0x58/0x258
> [ 1141.000040]  net_rx_action+0x1f4/0x3e0
> [ 1141.000055]  handle_softirqs+0x184/0x458
> [ 1141.000070]  __do_softirq+0x20/0x2c
> [ 1141.000079]  ____do_softirq+0x1c/0x30
> [ 1141.000095]  call_on_irq_stack+0x24/0x58
> [ 1141.000111]  do_softirq_own_stack+0x28/0x40
> [ 1141.000127]  __irq_exit_rcu+0xd4/0x1a0
> [ 1141.000139]  irq_exit_rcu+0x1c/0x40
> [ 1141.000152]  el1_interrupt+0x8c/0xc0
> [ 1141.000170]  el1h_64_irq_handler+0x18/0x28
> [ 1141.000186]  el1h_64_irq+0x6c/0x70
> [ 1141.000195]  arch_local_irq_enable+0x8/0x10 (P)
> [ 1141.000213]  cpuidle_enter+0x44/0x68
> [ 1141.000228]  do_idle+0x1e8/0x280
> [ 1141.000238]  cpu_startup_entry+0x40/0x50
> [ 1141.000248]  rest_init+0x1c4/0x1d0
> [ 1141.000260]  start_kernel+0x324/0x3e8
> [ 1141.000272]  __primary_switched+0x88/0x98
> [ 1141.197568] ------------[ cut here ]------------

Thanks. I will correct both in v7.

