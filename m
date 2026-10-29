Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793303089;
	b=1HgkScXsnhjinLnLdkhpXpUNDlciiIE7gnD/GIKs+8V26491t5J77wA7CVIAW3tcH2xx
	 s5bxec7ua2mhRqvgT3llLUFq74wHYRGiv6Vj1l7vA7gE63dzSdlB2Mabhf6DGR/2/N9Qs
	 oUQTypRG3MjFLQKxN6RqWgra1wzJSdksmYWS6jsVNlgysZaThKAf/bhy39fIYi0J1Rm4C
	 /9ziI3aUOo0BGcs36mb5dNDAST9pw6kbYyhOg/acmaqklBHbhv+GFtxDSwdMIQioR66Vq
	 s7HLSpDhVc0v3k++10M/HEc8MlgnTaTogQnxNtNfpTaVel2/CZ23u6eN4RW70qelkHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793303089;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=x6f0DlTTrO8DceGjxWUVN1xDkxoEdvbta7Vsujrj9zc=;
	b=K1UKz4mnzCpCQ4wpM8Ff6TBWvSgYPMyOZPTDZPjrRPYvb/FyHligd3IXG7/IwqTvKJ/K
	 skU0nIOvSwoGi4vLYqOs65RyzUbFEr3Qm4QN/QmZbbb3sDonJrUB1MBtKnrIAuzYEE+uQ
	 JOX3nHUgdEv5rnx7IVf5WmlTXplnCgD2ZXGIKuU5b2mnxKZaoEiG8FbN5Ua9mR8xhPMlh
	 ELI5UDRfcjvIcZViW/Xl9BohVLIHvkuMDr3rI38b3POOo0U5QeGgt01JCSrvIPrpN98E6
	 eqZJmai6GzNabIJW7kL7thBQKprduhwkqhZNs0fmurOFARkNJYBWUpjwFo1v9hHmf4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0F5606A31A;
	Thu, 29 Oct 2026 19:44:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D0F5606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8CE5B609D0; Thu, 29 Oct 2026 20:44:44 +0100 (CET)
Date: Thu, 29 Oct 2026 20:44:37 +0100
From: Florian Westphal <fw@strlen.de>
To: netdev-bot+sashiko@kernel.org
Cc: fangxy@xiaopeng.com, pablo@netfilter.org, phil@nwl.cc,
	davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	liuwb@xiaopeng.com
Subject: Re: [PATCH] netfilter: xt_policy: add NULL check for skb_dst() in
 output policy match
Message-ID: <auOiJdDR7tkMzYAf@strlen.de>
References: <20261026125313.14810-1-fangxy@xiaopeng.com>
 <179330010531.3134.10986246344071690394@kernel.org>
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
In-Reply-To: <179330010531.3134.10986246344071690394@kernel.org>

netdev-bot+sashiko@kernel.org <netdev-bot+sashiko@kernel.org> wrote:
> Is this statement accurate? There seems to be a reachable path through
> br_netfilter on a bridge port that has vlan_tunnel enabled.
> 
> net/bridge/br_vlan_tunnel.c:br_handle_egress_vlan_tunnel() {
>     ...
> 	tunnel_id = READ_ONCE(vlan->tinfo.tunnel_id);
> 	if (!tunnel_id || unlikely(!skb_vlan_tag_present(skb)))
> 		return 0;
> 
> 	skb_dst_drop(skb);
>     ...
> 	tunnel_dst = rcu_dereference(vlan->tinfo.tunnel_dst);
> 	if (tunnel_dst && dst_hold_safe(&tunnel_dst->dst))
> 		skb_dst_set(skb, &tunnel_dst->dst);
> 
> 	return 0;
> }
> 
> This drops the fake rtable that br_nf_pre_routing_finish() attached. If
> tunnel_dst is NULL or dst_hold_safe() fails, the skb continues with no
> dst.
> 
> The delete side runs under RTNL, and nothing orders it against the
> softirq reader:
> 
> net/bridge/br_vlan_tunnel.c:vlan_tunnel_info_release() {
>     ...
> 	WRITE_ONCE(vlan->tinfo.tunnel_id, 0);
> 	RCU_INIT_POINTER(vlan->tinfo.tunnel_dst, NULL);
> 	dst_release(&tdst->dst);
> }
> 
> So a forwarder can read the old non-zero tunnel_id and then find
> tunnel_dst NULL, or holding a dst that dst_hold_safe() rejects. The skb
> then goes on like this:
> 
> __br_forward()
>   br_handle_vlan()
>     br_handle_egress_vlan_tunnel()   <- dst dropped, none attached
>   NF_HOOK(NFPROTO_BRIDGE, NF_BR_FORWARD, ...)
>     br_nf_forward()
>       br_nf_forward_ip()
>         NF_HOOK(pf, NF_INET_FORWARD, ...)
>           ipt_do_table() / ip6t_do_table()
>             policy_mt()
>               match_policy_out()     <- dst == NULL
> 
> br_nf_post_routing() does the same for POSTROUTING, and
> policy_mt_check_hooks() allows --dir out in both hooks.
> 
> The trigger needs a VLAN-filtering bridge with a vlan_tunnel port,
> bridge-nf-call-iptables (or ip6tables) enabled, a "-m policy --dir out"
> rule in FORWARD or POSTROUTING, and a tunnel mapping delete racing with
> forwarded traffic. Given that, the pre-patch code would oops in softirq
> context.
> 
> Could the commit message describe this path, so the change is not taken
> as purely defensive?

No.  This is the wrong place.  We don't work around bugs in bridge by
adding random skb->dst == NULL tests in random xt or nft parts.

If this bug is real, it has to fixed in either bridge itself or
br_netfilter.  Calling inet stack from bridge was never a good idea, and
the onus is on br_netfilter to satisfy ip stack preconditions.

inet netfilter land should not have to cater / cope with bogus skbs
originating in bridge layer.
