Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBA72580D7;
	Tue,  7 Oct 2025 10:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759831246; cv=none; b=tISvq0Tj/UEVQzBGbo9OGvKmaeATff9GKp1hHVEIL62E3X92EnQohvLRa02Qji4mM8LJy0+GcjBt3iC9e8TG7Y8bgJibYmercMpnGmUX6oFV5BgREneazUJE56A/uEqnQ0mnWSSDVDF0+0yY9vDDQnlk6Z2gXQ6TjNWsRMevRTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759831246; c=relaxed/simple;
	bh=/N816RB/jyoXeTKM1FbuTDdvx0MvuDTOOLpRyfiHmS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PeR8IC5M5Q/t+eKICNIFRsrtJNegXlfsRE5Nps+cmf6IEuiYIQJHepq56n9fQfLuD5GWf3qFbr+BszC6SKWZKdPy/P5/e7NRuJy1TpWCLcSTHdW08kSt4z59CwstMTUFvKPuITEQFcXdLi+5TCS2rGzhwIkNRHJvDRxgidrnNBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ZpdBgjAe; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SV1Brclz; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ZpdBgjAe";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SV1Brclz"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id BD39860262; Tue,  7 Oct 2025 12:00:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1759831240;
	bh=pR1Or/eOAJgtO9nK0tvnWTdub8ddzTZrCYYQdvDphMA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZpdBgjAepRfVpx9dUDTFQI+mzf+zURbrj4qV0n/icjk0f/3fhKwkX2qmybvucIP/J
	 zu5Dj7BmJd/sVnSd3FHAb77B5fs4uo4I9Jg2emoPSm1ZgLjvg9u2Y370KFFRlmoR1r
	 S8oR2TAJK8xERWDVUxn2ASrdNIxTmbHaueIOZWVvFNn8ZbBseaYRXEYY8bZbrN8Nip
	 Eu2jmlLyQb6NDCcuo5rrEyh/jNiO3zDvvaGKhuhSKMqnxyWBMXM0+mnua292vxTXbS
	 Zl8fctoBpbQujNMARj1O6N6yYwKlYpErkEJCa/sInsfZYO/cCxCA33JrtmemIseWGj
	 sYsTXbtBCspiQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BCE3660262;
	Tue,  7 Oct 2025 12:00:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1759831237;
	bh=pR1Or/eOAJgtO9nK0tvnWTdub8ddzTZrCYYQdvDphMA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SV1BrclzCWTOyNwcQ1sgdJSr76iLgNG78LapI6XxZ9eBgfEULVtMdMYy11UfdGTbF
	 pwxx1h0VF8I+an64jtiAlH0gcdGtvm15epmwj3gK8C1hjKRYEzjNjW2OnTkS+aotlt
	 ybdNr+sjxakCtUGy8N0z74oJqJ6xCFDSWBFPv3+SdJjKe+vbPPm6HIsGHr6NBiYLLe
	 QI9CM7xu8i0HdF7iGbEUcmu2Q/2H5iK1bzW9+j5MdvyRFRAckPIqfRiSimVmWUnSHf
	 vNF1j+0CbXPx48uAfrAh6O8F7drbN9hCBkLImSedjDgr9UJQd3aYQLj/ZJYtpg2uG0
	 CK5CDLCbaGpag==
Date: Tue, 7 Oct 2025 12:00:35 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Felix Fietkau <nbd@nbd.name>,
	bridge@lists.linux.dev, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v1 nf] bridge: br_vlan_fill_forward_path_pvid: use
 br_vlan_group_rcu()
Message-ID: <aOTkw72FGwaOZcz7@calendula>
References: <20251007081501.6358-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251007081501.6358-1-ericwouds@gmail.com>

On Tue, Oct 07, 2025 at 10:15:01AM +0200, Eric Woudstra wrote:
> Bug: br_vlan_fill_forward_path_pvid uses br_vlan_group() instead of
> br_vlan_group_rcu(). Correct this bug.
> 
> Fixes: bcf2766b1377 ("net: bridge: resolve forwarding path for VLAN tag actions in bridge devices")
> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>

Patch looks good.

dev_fill_forward_path() is assumed to run under RCU.

> ---
> 
> Also see the debugging info send by Florian in mailing:
> "[RFC PATCH v3 nf-next] selftests: netfilter: Add bridge_fastpath.sh"
> 
> net/bridge/br_private.h:1627 suspicious rcu_dereference_protected() usage!
> 
> other info that might help us debug this:
> 
> rcu_scheduler_active = 2, debug_locks = 1
> 7 locks held by socat/410:
>  #0: ffff88800d7a9c90 (sk_lock-AF_INET){+.+.}-{0:0}, at: inet_stream_connect+0x43/0xa0
>  #1: ffffffff9a779900 (rcu_read_lock){....}-{1:3}, at: __ip_queue_xmit+0x62/0x1830
>  #2: ffffffff9a779900 (rcu_read_lock){....}-{1:3}, at: ip_output+0x57/0x3c0
>  #3: ffffffff9a779900 (rcu_read_lock){....}-{1:3}, at: ip_finish_output2+0x263/0x17d0
>  #4: ffffffff9a779900 (rcu_read_lock){....}-{1:3}, at: process_backlog+0x38a/0x14b0
>  #5: ffffffff9a779900 (rcu_read_lock){....}-{1:3}, at: netif_receive_skb_internal+0x83/0x330
>  #6: ffffffff9a779900 (rcu_read_lock){....}-{1:3}, at: nf_hook.constprop.0+0x8a/0x440
> 
> stack backtrace:
> CPU: 0 UID: 0 PID: 410 Comm: socat Not tainted 6.17.0-rc7-virtme #1 PREEMPT(full)
> Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> Call Trace:
>  <IRQ>
>  dump_stack_lvl+0x6f/0xb0
>  lockdep_rcu_suspicious.cold+0x4f/0xb1
>  br_vlan_fill_forward_path_pvid+0x32c/0x410 [bridge]
>  br_fill_forward_path+0x7a/0x4d0 [bridge]
>  ...
> 
>  net/bridge/br_vlan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
> index 939a3aa78d5c..54993a05037c 100644
> --- a/net/bridge/br_vlan.c
> +++ b/net/bridge/br_vlan.c
> @@ -1455,7 +1455,7 @@ void br_vlan_fill_forward_path_pvid(struct net_bridge *br,
>  	if (!br_opt_get(br, BROPT_VLAN_ENABLED))
>  		return;
>  
> -	vg = br_vlan_group(br);
> +	vg = br_vlan_group_rcu(br);
>  
>  	if (idx >= 0 &&
>  	    ctx->vlan[idx].proto == br->vlan_proto) {
> -- 
> 2.50.0
> 
