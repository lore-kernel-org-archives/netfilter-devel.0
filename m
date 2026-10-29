Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793300107;
	b=IomMKfbbriCJMCaFbin4X0aI5ZNeUx7A+l2oVZnSaLD7GZweDpd/gFuSat5BQquIkbEl
	 Mo1Pfu2PTgRe8knHBuLZtipdLpi6b8cFu/uh3D50Yf9J/Qd1u691dYcWjWvZjvVVtabt0
	 YQZqwUTixALJxeJ0bIwF+hQUNmD9rIjYx26O4+oLYzEZ0dQvxPPspgW04ss+Q+a0k34nK
	 hbEzX8pz7hUwdt0Nuj6JK63+WCvSf1EnheDlbI8hI/eW+h+JW5t/dYpaE/LtGXl+v9CV/
	 cJRtQE4+uIMbKDULOM00X1i1rDEsYyTQMDuLGlsm1i14rez3K4ikg6xvL10lLRYRWAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793300107;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=4fltM5gdImjF1crZCIEyXf23oKVvuU4SjhacIgA9m38=;
	b=wLHa84QF43fm7fpyOtr9fI268buWrGQ0fewtk6MqrXEpB7fsMfSxps3sB91QnEVB+MDN
	 8iznYqwtupHOoCDMcykpBIn07G5Nk2FXwK94jtxVd48V+N5+O0DnhHeZmwRE9QGoxeJCf
	 Zrt3y3srQ1xJYILl0jZkRhYcsr5scZTdKWWUO+8uwRPRfXNirDjr4lEqUy4pFkRdgLIjn
	 eNH40HtAhwAD/3A8Vfu+sSUUzCADKO6GvdhVSfnppWy/VyhVbEiZDvnTzCgMT0RpsA31r
	 PHye8zoGD+AtO/F60K2piANbyFprFR/kqSomfMVSI2otDSB60yg3OaEhA5W6nllGIfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E9kR+B6z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF0C606A31C;
	Thu, 29 Oct 2026 18:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E9kR+B6z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C617E1F01825;
	Thu, 29 Oct 2026 18:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793300106;
	bh=4fltM5gdImjF1crZCIEyXf23oKVvuU4SjhacIgA9m38=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=E9kR+B6zd2TC56iOVx3LX/tayyHIrM5NuI2aKJ5/H4qRvNzBZBTEg5vvBBQdIWAOz
	 xVqrQWXDdofchDu/3HVggZoiQv2YxNaBif6VpoCiB9FcYl73/xpZ+Ij5e2rTQ48MzI
	 8xeLKMvlC8iOtrd34OfsLDTVoUtkQVgm4rX8eobo6m3YgR3f//9snSgIpYWn9zBtoJ
	 J7Cq0shZ9AqQG2sH1RyzkKqoMfLaccSRN8+yBCmvNCi7xkeeobdEZ8iMtjIydw+L3x
	 jI+Cqb7d1LLfIJ2QAWcLwjs7QRe2xtm6+mtbMK7blpOn98kW0TX7Cvh5jgESqC2GhT
	 ecykRcT5hz+GQ==
Subject: Re: [PATCH] netfilter: xt_policy: add NULL check for skb_dst() in
 output policy match
From: netdev-bot+sashiko@kernel.org
To: fangxy@xiaopeng.com
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, liuwb@xiaopeng.com
Date: Thu, 29 Oct 2026 18:55:05 +0000
Message-ID: <179330010531.3134.10986246344071690394@kernel.org>
In-Reply-To: <20261026125313.14810-1-fangxy@xiaopeng.com>
References: <20261026125313.14810-1-fangxy@xiaopeng.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 (1) · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The commit message says the patch is defensive only ("No
  reachable path that passes an skb with a NULL dst to…
- [Low] The patch fixes a reachable NULL-pointer dereference in
  match_policy_out() (net/netfilter/xt_policy.c) but has no Fixes: tag…

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but xt_realm has
  the same unchecked skb_dst() dereference.

--

netfilter: xt_policy: add NULL check for skb_dst() in output policy match

This commit adds a NULL check for skb_dst() in match_policy_out() before
dst->xfrm is accessed. When no dst is attached, the function returns -1,
the same as for a dst without XFRM state. The commit message says the
change is defensive and that no reachable path is known.

> Code review identified the unchecked dereference. No reachable path
> that passes an skb with a NULL dst to match_policy_out() has been
> identified in current kernels.

[Severity: Medium]

Is this statement accurate? There seems to be a reachable path through
br_netfilter on a bridge port that has vlan_tunnel enabled.

net/bridge/br_vlan_tunnel.c:br_handle_egress_vlan_tunnel() {
    ...
	tunnel_id = READ_ONCE(vlan->tinfo.tunnel_id);
	if (!tunnel_id || unlikely(!skb_vlan_tag_present(skb)))
		return 0;

	skb_dst_drop(skb);
    ...
	tunnel_dst = rcu_dereference(vlan->tinfo.tunnel_dst);
	if (tunnel_dst && dst_hold_safe(&tunnel_dst->dst))
		skb_dst_set(skb, &tunnel_dst->dst);

	return 0;
}

This drops the fake rtable that br_nf_pre_routing_finish() attached. If
tunnel_dst is NULL or dst_hold_safe() fails, the skb continues with no
dst.

The delete side runs under RTNL, and nothing orders it against the
softirq reader:

net/bridge/br_vlan_tunnel.c:vlan_tunnel_info_release() {
    ...
	WRITE_ONCE(vlan->tinfo.tunnel_id, 0);
	RCU_INIT_POINTER(vlan->tinfo.tunnel_dst, NULL);
	dst_release(&tdst->dst);
}

So a forwarder can read the old non-zero tunnel_id and then find
tunnel_dst NULL, or holding a dst that dst_hold_safe() rejects. The skb
then goes on like this:

__br_forward()
  br_handle_vlan()
    br_handle_egress_vlan_tunnel()   <- dst dropped, none attached
  NF_HOOK(NFPROTO_BRIDGE, NF_BR_FORWARD, ...)
    br_nf_forward()
      br_nf_forward_ip()
        NF_HOOK(pf, NF_INET_FORWARD, ...)
          ipt_do_table() / ip6t_do_table()
            policy_mt()
              match_policy_out()     <- dst == NULL

br_nf_post_routing() does the same for POSTROUTING, and
policy_mt_check_hooks() allows --dir out in both hooks.

The trigger needs a VLAN-filtering bridge with a vlan_tunnel port,
bridge-nf-call-iptables (or ip6tables) enabled, a "-m policy --dir out"
rule in FORWARD or POSTROUTING, and a tunnel mapping delete racing with
forwarded traffic. Given that, the pre-patch code would oops in softirq
context.

Could the commit message describe this path, so the change is not taken
as purely defensive?

> Reviewed-by: Weibin Liu <liuwb@xiaopeng.com>
> Signed-off-by: Fang Xieyan <fangxy@xiaopeng.com>

[Severity: Low]

Since the dereference looks reachable, should this patch carry a Fixes:
tag and Cc: stable? Without them, stable tooling won't pick it up.

The unchecked dst->xfrm dereference dates back to c4b885139203
("[NETFILTER]: Add policy match").

The behaviour of continuing with no dst after skb_dst_drop() in
br_handle_egress_vlan_tunnel() came from 58e2071742e3 ("net: bridge: fix
vlan tunnel dst null pointer dereference") and cfc579f9d89a ("net:
bridge: fix vlan tunnel dst refcnt when egressing").

Either one could be a candidate Fixes: target.

> diff --git a/net/netfilter/xt_policy.c b/net/netfilter/xt_policy.c
> index ff54e3a8581e1..6bbaf92f0cfc9 100644
> --- a/net/netfilter/xt_policy.c
> +++ b/net/netfilter/xt_policy.c
> @@ -87,7 +87,7 @@ match_policy_out(const struct sk_buff *skb, const struct xt_policy_info *info,
>  	int strict = info->flags & XT_POLICY_MATCH_STRICT;
>  	int i, pos;
>  
> -	if (dst->xfrm == NULL)
> +	if (!dst || dst->xfrm == NULL)
>  		return -1;

[Severity: High]

This isn't a bug introduced by this patch, but realm_mt() in
net/netfilter/xt_realm.c appears to have the same unchecked skb_dst()
dereference:

net/netfilter/xt_realm.c:realm_mt() {
	const struct xt_realm_info *info = par->matchinfo;
	const struct dst_entry *dst = skb_dst(skb);

	return (info->id == (dst->tclassid & info->mask)) ^ info->invert;
}

realm_mt_reg registers it for NFPROTO_IPV4 in these hooks:

	.hooks		= (1 << NF_INET_POST_ROUTING) | (1 << NF_INET_FORWARD) |
			  (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_LOCAL_IN),

Bridged IPv4 traffic reaches FORWARD through br_nf_forward_ip() and
POSTROUTING through br_nf_post_routing(). The same
br_handle_egress_vlan_tunnel() and vlan_tunnel_info_release() race
described above can leave that skb with no dst.

Would a "-m realm" rule in FORWARD or POSTROUTING then dereference
NULL->tclassid in softirq context? This patch only covers
match_policy_out(), not this sibling.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261026125313.14810-1-fangxy%40xiaopeng.com
