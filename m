Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793312419;
	b=PPdOzi5YtBC/gdKUemPQ+WNDuREv3IaP9OqMw74q2wIgJmScYedl1M6wUc1NgDfxVqiR
	 t69nkjXdGpMztQdu73wQph9SitU/1eLMgeWJt0BH9p8ycW+igu5OQRpsqXOOcuPeabpC9
	 hTpkfAtlEtzgU52Bz+CZcPKfhXQXWd4ocnaiCOHbIn3gevqcAf4dT1OHRWAL7Ia7sMbNa
	 E9xkdS2r34PSxNq/pzPa0jGTRkOT15PzDzgpx8BmkSW6SmFvmAYn2ez7l0kn5MaqeubJW
	 /7MlNiZ3EQponRxN7jdJ9mYAOrNeh3FptVXNGvrh6SYgsSl4XDlzXpmhTphEspfK27Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793312419;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=TLTZJlW3mJ9y9u/qGK0yIQVgOzybe5bLTX+4cSIfhQQ=;
	b=qjVlEJAv85pnRgrFj2s8LanvceJ1qCTrxXiWsibINgTyIroj7zyubkWNJCjKZeVUGzh2
	 86XGsc1OcR9V8kpETFWwKjZLtxmD/7uEb5CxMFzzdfXof5cF84uo4fAKQ2OQf6Vbj0PlU
	 ZJLfkyqhJ1TFEzDdejZCENzXpG5EjOFMDMNhyZpcuUjusMI7jPuozSRB38/Fg+MwH0c+Z
	 S958cE4IieSewrAfh+HAGcYZkzHbkPwEmRjIYVol9BmF21a7/qBopUtBgLdudw/Z/qFkE
	 9FuNH1xoqIeKDZ+xaJMxcDzYggQrfXNEi2DA+K6KH9jLTg1HWZlASbcle35PrZBRB8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECFB606A31A;
	Thu, 29 Oct 2026 22:20:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7ECFB606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B6352609D0; Thu, 29 Oct 2026 23:20:15 +0100 (CET)
Date: Thu, 29 Oct 2026 23:20:08 +0100
From: Florian Westphal <fw@strlen.de>
To: netdev-bot+sashiko@kernel.org
Cc: fangxy@xiaopeng.com, pablo@netfilter.org, phil@nwl.cc,
	davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	liuwb@xiaopeng.com, razor@blackwall.org
Subject: Re: [PATCH] netfilter: xt_policy: add NULL check for skb_dst() in
 output policy match
Message-ID: <auPGmOxutnhGGBdK@strlen.de>
References: <20261026125313.14810-1-fangxy@xiaopeng.com>
 <179330010531.3134.10986246344071690394@kernel.org>
 <auOiJdDR7tkMzYAf@strlen.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auOiJdDR7tkMzYAf@strlen.de>

Florian Westphal <fw@strlen.de> wrote:

[ CC Nik ]

> netdev-bot+sashiko@kernel.org <netdev-bot+sashiko@kernel.org> wrote:
> > Is this statement accurate? There seems to be a reachable path through
> > br_netfilter on a bridge port that has vlan_tunnel enabled.
> > 
> > net/bridge/br_vlan_tunnel.c:br_handle_egress_vlan_tunnel() {
> >     ...
> > 	tunnel_id = READ_ONCE(vlan->tinfo.tunnel_id);
> > 	if (!tunnel_id || unlikely(!skb_vlan_tag_present(skb)))
> > 		return 0;
> > 
> > 	skb_dst_drop(skb);
> >     ...
> > 	tunnel_dst = rcu_dereference(vlan->tinfo.tunnel_dst);
> > 	if (tunnel_dst && dst_hold_safe(&tunnel_dst->dst))
> > 		skb_dst_set(skb, &tunnel_dst->dst);
> > 
> > 	return 0;
> > }

Hmm, Nik can you please have a look?  Its strange that we don't return
an error. dst was dropped, tunnel dst disappeared, hwaccel tag was
cleared.

Should this return 0 only if skb_dst_set() was called?

Afaics then callers would toss the skb and we won't pass this
to inet netfilter hooks.

The original code had an unconditional skb_dst_set(),
assuming tunnel_dst is always there.

That changed with
cfc579f9d89a ("net: bridge: fix vlan tunnel dst refcnt when egressing")
fixup.

I'll quote more from report verbatim below for context.

> > So a forwarder can read the old non-zero tunnel_id and then find
> > tunnel_dst NULL, or holding a dst that dst_hold_safe() rejects. The skb
> > then goes on like this:
> > 
> > __br_forward()
> >   br_handle_vlan()
> >     br_handle_egress_vlan_tunnel()   <- dst dropped, none attached
> >   NF_HOOK(NFPROTO_BRIDGE, NF_BR_FORWARD, ...)
> >     br_nf_forward()
> >       br_nf_forward_ip()
> >         NF_HOOK(pf, NF_INET_FORWARD, ...)
> >           ipt_do_table() / ip6t_do_table()
> >             policy_mt()
> >               match_policy_out()     <- dst == NULL
> > 
> > br_nf_post_routing() does the same for POSTROUTING, and
> > policy_mt_check_hooks() allows --dir out in both hooks.
> > 
> > The trigger needs a VLAN-filtering bridge with a vlan_tunnel port,
> > bridge-nf-call-iptables (or ip6tables) enabled, a "-m policy --dir out"
> > rule in FORWARD or POSTROUTING, and a tunnel mapping delete racing with
> > forwarded traffic. Given that, the pre-patch code would oops in softirq
> > context.
> > 
> > Could the commit message describe this path, so the change is not taken
> > as purely defensive?
