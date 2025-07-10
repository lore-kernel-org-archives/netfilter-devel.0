Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583FA18BC3D;
	Thu, 10 Jul 2025 23:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752191445; cv=none; b=dl9nMIvPCy1vK2HmnayOw2kxjOrJ5KUASMrqhtQMguTRnccwZd2P76/ULC48G5JUpKB702VL2Hd/SL9eDzIPmnP34qBozwTraRkBFNHm8GhHv0uAuBgeWiK3nzJikmvrzyqyBfxRZ5+fqmKuPt1Iqbdcj+X59S842yrRd5N2nNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752191445; c=relaxed/simple;
	bh=USCMUn54ndgPneDnVPufDeks8a9rh29vTPRvlAMeYh0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gBOw/9GGhgHuXKOm2gK8whL/B2a0lyXL7x76kNIr4uREZ+4GD4Ofsp+yjUM6CtZzWAJ3yMtNrVcPpjecvqFYaYpU6AGYpzSw+vb72p+FrZnbpaprvwMP9wBTP+v8RJZIWVBie7MnjSkKLTMApUfVFOetJTBgi3p2eXr2k8TRbdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=n7GAN3m+; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=WuCSPTNA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="n7GAN3m+";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="WuCSPTNA"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 07C83602B2; Fri, 11 Jul 2025 01:50:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752191439;
	bh=xxjhWmH3emqRlh20xFujYzSVWcjcgdolVEQ4cUUbMWQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n7GAN3m+wyc3La9L+EQz2A3QknyljOHJTe04ERK7VMeZLQADnREUoDRak33wWIk6T
	 tBEwYUGP64jnf8+blqqots4PTARFpIKsoJqCr6px4N8ewdcvKEtA1ncI0CqZSitmJB
	 i+VmxdwQR8uQ0VdDlpE8VzQfvXZGw6sqMJFt5+A/9PYUFrbc63qD1Rcj4f92jHr1vn
	 tFJGCy+R+XRQ3tsF9Nf2Zl8dLSc6uV97Wc6ib0Wk9bM8WmM+lb+MK/SNsRgarmhBzM
	 VrefQXyPZtoau88x/qSBG6bSONsCofq8sJ5+7NSbPKPAcztZiwR5Ny2KsOiqRVxMqe
	 oFMdnpHfx283w==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4B902602AC;
	Fri, 11 Jul 2025 01:50:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752191437;
	bh=xxjhWmH3emqRlh20xFujYzSVWcjcgdolVEQ4cUUbMWQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WuCSPTNA0WozrCJHux88U3ETjyHegViZ7dToIC1lv5Jpd/EwOkfCCQdwNFOdozdTe
	 Bh2g1CDzAIcWRAtO6g2DUcEU7lNp+Uirn0Ydcs4ss95L/JgaWSoSZhj4If/MorJRXR
	 kGGByfJZaq6WuvcAkEjQCQsAxaIPgZp33e2NPPA5XOlUGXOtlK05sUZYzqsd2p008g
	 Pq2Tbgp/D08rkm3aOVJcC6MOJKxOagO1qYJBFZ7H4s6HBR0o40OewgHqNsvPb+tuLL
	 lurHpVx2ckYBs3W3P2B1fVahlqm6KLWJ1nfjlYxgYTEnfF9Vfrf9tAGIIQ5j3zGh/N
	 0B1z8au6DuZWw==
Date: Fri, 11 Jul 2025 01:50:35 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Dumazet <edumazet@google.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	eric.dumazet@gmail.com,
	syzbot+bf6ed459397e307c3ad2@syzkaller.appspotmail.com
Subject: Re: [PATCH net] netfilter: flowtable: account for Ethernet header in
 nf_flow_pppoe_proto()
Message-ID: <aHBRudvDo5887q3F@calendula>
References: <20250707124517.614489-1-edumazet@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250707124517.614489-1-edumazet@google.com>

Hi Eric,

Thanks for your patch.

On Mon, Jul 07, 2025 at 12:45:17PM +0000, Eric Dumazet wrote:
> syzbot found a potential access to uninit-value in nf_flow_pppoe_proto()
> 
> Blamed commit forgot the Ethernet header.

I see, vlan indeed includes the ethernet header.

        case htons(ETH_P_8021Q):
+               if (!pskb_may_pull(skb, skb_mac_offset(skb) + sizeof(*veth)))

validates this, after this patch this looks consistent.

> BUG: KMSAN: uninit-value in nf_flow_offload_inet_hook+0x7e4/0x940 net/netfilter/nf_flow_table_inet.c:27
>   nf_flow_offload_inet_hook+0x7e4/0x940 net/netfilter/nf_flow_table_inet.c:27
>   nf_hook_entry_hookfn include/linux/netfilter.h:157 [inline]
>   nf_hook_slow+0xe1/0x3d0 net/netfilter/core.c:623
>   nf_hook_ingress include/linux/netfilter_netdev.h:34 [inline]
>   nf_ingress net/core/dev.c:5742 [inline]
>   __netif_receive_skb_core+0x4aff/0x70c0 net/core/dev.c:5837
>   __netif_receive_skb_one_core net/core/dev.c:5975 [inline]
>   __netif_receive_skb+0xcc/0xac0 net/core/dev.c:6090
>   netif_receive_skb_internal net/core/dev.c:6176 [inline]
>   netif_receive_skb+0x57/0x630 net/core/dev.c:6235
>   tun_rx_batched+0x1df/0x980 drivers/net/tun.c:1485
>   tun_get_user+0x4ee0/0x6b40 drivers/net/tun.c:1938
>   tun_chr_write_iter+0x3e9/0x5c0 drivers/net/tun.c:1984
>   new_sync_write fs/read_write.c:593 [inline]
>   vfs_write+0xb4b/0x1580 fs/read_write.c:686
>   ksys_write fs/read_write.c:738 [inline]
>   __do_sys_write fs/read_write.c:749 [inline]
> 
> Reported-by: syzbot+bf6ed459397e307c3ad2@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/netdev/686bc073.a00a0220.c7b3.0086.GAE@google.com/T/#u
> Fixes: 87b3593bed18 ("netfilter: flowtable: validate pppoe header")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks.
