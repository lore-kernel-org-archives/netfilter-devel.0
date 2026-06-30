Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4C038D;
	Tue, 30 Jun 2026 08:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782809133; cv=none; b=aL53hKZuhMRgF1nM3UrGIbuh5JjMuYsB97shn1HAFtA2W20BeowkjZDz78k9A+RecevsodlakuK5FcNPLGY176cc+3dU79dizOZE4uUPHemHay44ga+MRaCAppajIdqLcvTXy3uH2VL0HFdg1E2RXo1hqIYLWKt7+OUzaaZVkKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782809133; c=relaxed/simple;
	bh=I4Pnz4BFZhOUQEXvABQHM5+XoJIu89iqbkkiGgFOw7M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Al7LwrJcQ7NT3iIowI8FK04HzE/Ci7UbXPAa/hUpEWW1ePubAFHgUguQsCkBcueQWpq7naSTlrywRq8A/3BEyjxFurNCMas+7F152Qy3a2V7OejIgOKYk9Nq3ew3Hc0lI0DfOV3Pxtqr331ZpMea5T5SOKp275XkwhaOu+gMoOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=nIr3D04D; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="nIr3D04D"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 7B7476019C;
	Tue, 30 Jun 2026 10:45:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782809128;
	bh=2QDs7p8/Xz3WWuXQy2Gd1QNRcYz9tg+di8ISRSUsTm4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nIr3D04DQLaD3VEweCFcD8bAzLB9Sl/otEDmhxRtRCmCNg6UZu2BraOttxuCB4JjT
	 avuVGtmT8XalBIQAmnTtLDX5J55yPos9H13ACWCs0qUcMZ6dArTLHKO6YwBzpN3S9S
	 o9wuW8B2U/1+mSiv5zGQq8ngt0YaHRNIdTh9cdrWYUCtVVuvpOIA1IjdLJ9HKcMSmr
	 xAgSuxARDNG032H5+cvRHSIaRJ0qAIPYj/kCSb7pQmhV7DZ+fSTR2pffNRQgwodbwb
	 XwOLSrAF1oel/uY8RvUEQ2rhNL9QBPbV093oDVGXWTpPKJf3F9a2wQT7NDyuqK1Q/o
	 IVuSOBQN2VrPw==
Date: Tue, 30 Jun 2026 10:45:24 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Daniel Pawlik <pawlik.dan@gmail.com>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org, fw@strlen.de,
	phil@nwl.cc, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	andrew+netdev@lunn.ch, razor@blackwall.org, idosch@nvidia.com,
	matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com,
	bridge@lists.linux.dev, coreteam@netfilter.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, rchen14b@gmail.com,
	lorenzo@kernel.org
Subject: Re: [PATCH v2 0/5] netfilter: nf_flow_table_path: L2 bridge offload
Message-ID: <akOCJI-2kAAwOQzz@chamomile>
References: <20260630065735.3341614-1-pawlik.dan@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260630065735.3341614-1-pawlik.dan@gmail.com>

Hi,

On Tue, Jun 30, 2026 at 08:57:30AM +0200, Daniel Pawlik wrote:
> This series adds L2 bridge offload support to nft_flow_offload, allowing
> bridged IPv4/IPv6 flows to be accelerated by the flowtable fast path
> without requiring L3 routing.
> 
> Background
> ----------
> Hardware flow offload engines (e.g. MediaTek PPE) can accelerate bridged
> traffic but require that nft_flow_offload detect and handle bridged flows
> differently from routed ones: no routing table lookup, MAC addresses from
> the Ethernet header, and VLAN context pre-populated from the bridge port.
> 
> v2: Fix missing Returns: tags in kernel-doc comments for the three new
>     bridge helpers (br_fdb_has_forwarding_entry_rcu,
>     br_vlan_get_offload_info_rcu, br_vlan_is_enabled_rcu).
> 
> Patches
> -------
> 1/5  net: export __dev_fill_forward_path
>      Refactors dev_fill_forward_path() to expose __dev_fill_forward_path()
>      which accepts a caller-supplied net_device_path_ctx, needed to
>      pre-populate VLAN state before the forward path walk.
> 
> 2/5  net: bridge: add flow offload helpers
>      Adds br_fdb_has_forwarding_entry_rcu(), br_vlan_get_offload_info_rcu()
>      and br_vlan_is_enabled_rcu() to expose bridge state to nft_flow_offload
>      without requiring inclusion of net/bridge/br_private.h.
> 
> 3/5  netfilter: nf_flow_table_path: add L2 bridge offload
>      Core of the series. Adds nft_flow_offload_is_bridging() detection,
>      nft_flow_route_bridging() which avoids nf_route() (fails for
>      bridged-only subnets), MAC/VLAN pre-population for bridged flows,
>      and a dst leak fix. nft_flow_route() becomes a thin dispatcher.
> 
> 4/5  netfilter: nf_flow_table_path: handle DEV_PATH_MTK_WDMA in path info
>      Fixes zero-source-MAC in PPE entries when a bridged flow traverses
>      MT7996/MT7915 WiFi WDMA hardware.
> 
> 5/5  netfilter: nf_flow_table_path: add VLAN passthrough support
>      Records VLAN encap info for passthrough-mode bridge ports so hardware
>      offload entries include the correct VLAN tag.
> 
> Rebase note
> -----------
> Originally developed against OpenWrt pending-6.18 patches by Ryan Chen
> <rchen14b@gmail.com> and Bo-Cun Chen <bc-bocun.chen@mediatek.com>.
> Rebased to current upstream: path discovery infrastructure moved to
> nf_flow_table_path.c in commit 93d7a7ed0734 ("netfilter: flowtable: move
> path discovery infrastructure to its own file"), so all netfilter changes
> now land in that file rather than nft_flow_offload.c.
> 
> How to enable bridge offload
> -----------------------------
> 1. Load kmod-br-netfilter so that bridged IP traffic traverses the
>    netfilter forward chain.
> 
> 2. Enable netfilter hooks on the bridge:
>      echo 1 > /sys/class/net/<br>/bridge/nf_call_iptables
>      echo 1 > /sys/class/net/<br>/bridge/nf_call_ip6tables

This requires br_netfilter which is a no go.

Sorry, but we should really target at the native nf_conntrack_bridge
support.

> 3. Register bridge member interfaces in the nft flowtable:
>      table inet filter {
>          flowtable f {
>              hook ingress priority filter
>              devices = { eth0, wlan0 }
>          }
>          chain forward {
>              type filter hook forward priority filter
>              meta l4proto { tcp, udp } flow add @f
>          }
>      }

Yes, but br_netfilter makes no sense for nftables.

br_netfilter was made to fill gap at the time ebtables was lagging a
lot behind iptables in terms of features. And getting ebtables on pair
with iptables in functionality was not feasible either, because it
required many new extensions that were specific of the bridge family,
which probably was not a big deal, but it also required to get
the ebtables command line tool on pair with iptables userspace, which
has received more development attention/effort that the bridge tool.

All of this does not stand true anymore with nftables, where the
bridge family capabilities are at pair with the inet families.

I am looking now at the native flowtable bridge support, I will get
back to you with updates.
