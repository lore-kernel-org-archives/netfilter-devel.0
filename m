Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE672206BB;
	Tue, 11 Feb 2025 13:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739280521; cv=none; b=rhRUo7xo53sfPZGp1QsOUhkj8miG/ttH0S6mG8PKR8AVskOIcI1OamAutRGkYC2anXwfv6drft4mnKySjoh58f0V6mskPROfiwz+b49YNKklYwZsVi0KRecYAMjv4M5cJt1Ny/QhvmTTeWRDs1pY1eDvPq+kO3UYqEVBIrm043c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739280521; c=relaxed/simple;
	bh=J36o2DjG9YjX+05Z3jhO/S9Q8yTRO0ZZ92yOnlQxnuE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C48U4bNZlraxx1hjEbZtsROU8XdagcugXleXTsSq5H9q7FT2Ojxwa8+sbIreKyMpnxCCdWGZIv7GyEXGo3tAtvXKG1J02lN6VtzGOBou0IhKxV6y2Bhwuz71GskhFOK8U8hhVxTGYqHqBQMuasgYgfZ8dkabpoXqcAXO0YxmJd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S/VQGvmQ; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S/VQGvmQ"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ab7c3d44ae1so29004766b.2;
        Tue, 11 Feb 2025 05:28:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739280517; x=1739885317; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WLyb+sxmlUWI3PPRd+G753tkjaglzT6ouXpQ3N3NRPQ=;
        b=S/VQGvmQK8WUKaTVr3k0vgvAy/f9FQD9+GP/sRHyDnPCG84EgGuWr4hr4+m0F2PP5q
         BXUtRn9fIpmiYBf5ULRO2YXJKJVP0GaiZgszqGIlIm2BkU27R4CnAZbTxzBxHMh0Jhh0
         Asse3+lhNWWxWDUzYzvb6pFA1DgAMGCHkJYvsJm/NVfg4Kv9SmWmPGEixCo8DIwqf0L+
         olixJ6aOBTpoYZVTMeE+mqXCZSY2yjIR5Q2Jrf7R6p/bubihBZxSVCn/JJ8BFxjNxRsT
         2soNDBpYLmd2Dkm7hWZIgP23LBNuKrFeZgCPsd+T8hL2l0KoA1cJIFfw3vIosWMEq7YD
         gZPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739280517; x=1739885317;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WLyb+sxmlUWI3PPRd+G753tkjaglzT6ouXpQ3N3NRPQ=;
        b=f6qEaRRXxed7CCv0+JnPAkwNP3WTypsti0Ql24lFISwB1G3uGOrq//YfY8C6zPwm5G
         5F4CgEkefn9aZ7QpUkalMbQCfiogf3onuACS7bakYKLCHIW+Dn1wauuX2IXIhtt0MgHr
         T85S4aYfII3Ly573xSysl2Gu3ug2DAK15xtXVjEX1/UFIiryuYj8LlaxbOm5sQgPviRY
         x/4uEvyHByXzEymBlrGYc335HqJmm3uexNxUFlt2LDO2D4EwYjJ89D7GlORCnuFqZv3b
         LM+5y99Os0d0QlBJTBkYIpOhzL7ufMBsju1YjuVcauwSypkDXaT6H28KFO76Lt2xxT7P
         ih8g==
X-Forwarded-Encrypted: i=1; AJvYcCWe9icySEOcevNGNDPiAlcsjjBls9eRnADXG9GGT/+4MD/JxH2j7Rz4qRobyc5ZSav52jQnMM4AIYC2fv5nyefe@vger.kernel.org, AJvYcCXnnxe2YQlhm6mv4Wxtwr5GHAmZczbX2+zPEQqxOVDbXGrjfa4/hRrmFWaVM341gLyLIjyJftyiZ8Ur4e8=@vger.kernel.org, AJvYcCXzaJkh1tcgBy4oToKDTb/ebNU45VSF4QHG2y9Jy1kJFQJKQmQ9S0X96+/tfKqC+jB1zXv/Xt2h@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6CMLMWFnxNqzI2qnOO35rVKx4ue1TnwdGOl9H6aBk/z4QGlUK
	rlwoyrKcc1VXpesGByC4H4wsdcgceZ607Cb8Mvvdfja1Ebjubfec
X-Gm-Gg: ASbGncsR6t72xS9R3nZAzmEJPJ7c2sNsJokmAz0uoKbA025wbpcK2uqjXdNpBQeNp1Z
	vg/PolZQjPKHPwvEWOTG9NlE8VbN8VGgBpeop+eUN1YHAQ+umj/2OW/SAfqTKj5uXEH8nsWEH08
	duwWtKxuGo+PDUZP+nAfdeZQumwA3zgFdWnqv0UU3VTC/eshIDLSskhPA4u+b3cASEroiXxsHg5
	F0oN9q1d88n0Mt88JjXQp/v+2I8KyEJFzSyY9gdmvp07hv8Y2XscZmziFUKD70GXgDirJTdPy5x
	IhU=
X-Google-Smtp-Source: AGHT+IEI3sHUVuDg9ehqKY+KygjpcwX0rbXlLEswHpVnNf7eTh4qQELv+eql57rgOrrbLVr2hu6FNg==
X-Received: by 2002:a17:907:7d87:b0:ab7:cd83:98bb with SMTP id a640c23a62f3a-ab7e0e6e245mr105887066b.5.1739280516517;
        Tue, 11 Feb 2025 05:28:36 -0800 (PST)
Received: from skbuf ([86.127.124.81])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab7dca728fcsm147341966b.166.2025.02.11.05.28.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 05:28:35 -0800 (PST)
Date: Tue, 11 Feb 2025 15:28:32 +0200
From: Vladimir Oltean <olteanv@gmail.com>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Jiri Pirko <jiri@resnulli.us>, Ivan Vecera <ivecera@redhat.com>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Joe Damato <jdamato@fastly.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, bridge@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v6 net-next 05/14] bridge: Add filling forward path from
 port to port
Message-ID: <20250211132832.aiy6ocvqppoqkd65@skbuf>
References: <20250209111034.241571-1-ericwouds@gmail.com>
 <20250209111034.241571-6-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250209111034.241571-6-ericwouds@gmail.com>

On Sun, Feb 09, 2025 at 12:10:25PM +0100, Eric Woudstra wrote:
> @@ -1453,7 +1454,10 @@ void br_vlan_fill_forward_path_pvid(struct net_bridge *br,
>  	if (!br_opt_get(br, BROPT_VLAN_ENABLED))
>  		return;
>  
> -	vg = br_vlan_group(br);
> +	if (p)
> +		vg = nbp_vlan_group(p);
> +	else
> +		vg = br_vlan_group(br);
>  
>  	if (idx >= 0 &&
>  	    ctx->vlan[idx].proto == br->vlan_proto) {

I think the original usage of br_vlan_group() here was incorrect, and so
is the new usage of nbp_vlan_group(). They should be br_vlan_group_rcu()
and nbp_vlan_group_rcu().

The lockdep annotation is important, otherwise I get this with CONFIG_PROVE_LOCKING=y:
[ 1140.931869] =============================
[ 1140.935996] WARNING: suspicious RCU usage
[ 1140.940094] 6.14.0-rc1-00224-gda8926a49ba1-dirty #2666 Not tainted
[ 1140.946371] -----------------------------
[ 1140.950520] net/bridge/br_private.h:1604 suspicious rcu_dereference_protected() usage!
[ 1140.958622]
[ 1140.958622] other info that might help us debug this:
[ 1140.958622]
[ 1140.966752]
[ 1140.966752] rcu_scheduler_active = 2, debug_locks = 1
[ 1140.973435] 2 locks held by swapper/0/0:
[ 1140.977521]  #0: ffffd9f646c333b0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire+0x4/0x40
[ 1140.986404]  #1: ffffd9f646c333b0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire+0x4/0x48
[ 1140.995170]
[ 1140.995170] stack backtrace:
[ 1140.999636] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.14.0-rc1-00224-gda8926a49ba1-dirty #2666
[ 1140.999650] Hardware name: LS1028A RDB Board (DT)
[ 1140.999656] Call trace:
[ 1140.999660]  show_stack+0x24/0x38 (C)
[ 1140.999683]  dump_stack_lvl+0x40/0xa0
[ 1140.999698]  dump_stack+0x18/0x24
[ 1140.999711]  lockdep_rcu_suspicious+0x174/0x218
[ 1140.999723]  br_vlan_fill_forward_path_pvid+0x90/0x150
[ 1140.999735]  br_fill_forward_path+0x54/0x1b0
[ 1140.999751]  dev_fill_bridge_path+0x9c/0x188
[ 1140.999766]  nft_dev_fill_bridge_path+0x2ac/0x418
[ 1140.999785]  nft_flow_offload_bridge_init+0x188/0x1c8
[ 1140.999801]  nft_flow_offload_eval+0x18c/0x300
[ 1140.999816]  nft_do_chain+0x1c8/0x538
[ 1140.999831]  nft_do_chain_bridge+0x15c/0x210
[ 1140.999846]  nf_hook_slow+0x80/0x130
[ 1140.999862]  NF_HOOK+0xd8/0x1d0
[ 1140.999871]  __br_forward+0x138/0x1a0
[ 1140.999880]  br_forward+0xd8/0x160
[ 1140.999889]  br_handle_frame_finish+0x3bc/0x5a8
[ 1140.999900]  br_nf_pre_routing_finish+0x538/0x608
[ 1140.999917]  NF_HOOK+0x254/0x298
[ 1140.999933]  br_nf_pre_routing+0x3e8/0x428
[ 1140.999949]  br_handle_frame+0x264/0x490
[ 1140.999959]  __netif_receive_skb_core+0x13c/0x1128
[ 1140.999975]  __netif_receive_skb_list_core+0xd4/0x1e8
[ 1140.999989]  netif_receive_skb_list_internal+0x224/0x338
[ 1141.000000]  napi_complete_done+0xb4/0x1d8
[ 1141.000012]  gro_cell_poll+0x94/0xb8
[ 1141.000025]  __napi_poll+0x58/0x258
[ 1141.000040]  net_rx_action+0x1f4/0x3e0
[ 1141.000055]  handle_softirqs+0x184/0x458
[ 1141.000070]  __do_softirq+0x20/0x2c
[ 1141.000079]  ____do_softirq+0x1c/0x30
[ 1141.000095]  call_on_irq_stack+0x24/0x58
[ 1141.000111]  do_softirq_own_stack+0x28/0x40
[ 1141.000127]  __irq_exit_rcu+0xd4/0x1a0
[ 1141.000139]  irq_exit_rcu+0x1c/0x40
[ 1141.000152]  el1_interrupt+0x8c/0xc0
[ 1141.000170]  el1h_64_irq_handler+0x18/0x28
[ 1141.000186]  el1h_64_irq+0x6c/0x70
[ 1141.000195]  arch_local_irq_enable+0x8/0x10 (P)
[ 1141.000213]  cpuidle_enter+0x44/0x68
[ 1141.000228]  do_idle+0x1e8/0x280
[ 1141.000238]  cpu_startup_entry+0x40/0x50
[ 1141.000248]  rest_init+0x1c4/0x1d0
[ 1141.000260]  start_kernel+0x324/0x3e8
[ 1141.000272]  __primary_switched+0x88/0x98
[ 1141.197568] ------------[ cut here ]------------
