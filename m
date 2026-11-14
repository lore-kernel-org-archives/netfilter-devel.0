Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794622551;
	b=lH/ffyN1lLeblbyuyczrhXYTJsaU/vN2jmoSNyyBgzuUnsL3N7uci35xr7xcP3EH08Gs
	 ICaa017X+bW2GHHYL4+rm00KHjgB7r6nS5yr8wR0XpzCjppsgU6FZ4p2CP1jelAVKIjg+
	 PMx9IffYc6L4rH1+y6V6jBznsQ/1p6opXuXosut9ZmKBiBgpL8ysLXT7p79K6WVrOgh2J
	 m3QY+/49mYxd/YPquXn1x/aZxIUa5pHWUUzM6hbkmgF5krDoOqtzJhpjGt31NWVgbAn8P
	 C/Beof10K7LAB8YZ/Tcpb3A6GE/LWEGIjTQ4RyLQ2VqbBLXVmOmzdPXy6zqZQMbbBDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794622551;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=DbnRoYaz7WeLEqcZJVonNGdyyxcBa8JZZm43/4ccHhs=;
	b=wWWg5SEnX99WmZZqU7qUHN9ygkVtFOhMpU0VFdbL8VwVHM/mbZI9NT0AdcBNpg20ysvD
	 GswHP9+rDFjAVAiSR2+F6mKO40CsZIOCRMtZx30ladnSdnCaIHn+mnoQNBhUk919aA7+N
	 B9ZbBF59HsWbmngPZ63wyJ8GPth6zGYFoE5zPnXUOWpKSpZlmk99xjemzKAH0ptG8pOBl
	 IjHKeGLSLwAuyVaNrWX5eqaI4LcuPsyE6epvSYiz9OKODYy9vR51bTnMGaFCQu+qK54cy
	 1UhzRskS1pKekmR/mhMLO3m7iDIofveveqbq1sziXb9QdbR5o70Msa6WyKmmfyE6ZSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ez+isFo4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7717E60A2611;
	Sat, 14 Nov 2026 02:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ez+isFo4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B466B1F000C6;
	Sat, 14 Nov 2026 02:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794622551;
	bh=DbnRoYaz7WeLEqcZJVonNGdyyxcBa8JZZm43/4ccHhs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ez+isFo4obju+u2dVnjiQo1HQuJEg7TG9IhznyBt9Ie42ZwLtj0PCJvRYLxtTOS0m
	 z5GOgN2e2xKtlgrH3t1uRTDs/Gk14U2uV/HVFWBZwivqDYCFOD8v27fePaaoyiHszC
	 V3XbSvQd7unVRcByh5hIT2lftz+28W2IQZUZSZwfoFWTpMmtzeWePkKs7EH2wgXet2
	 DnTsRA7Bj9L0HqyWkhEXJSw/Zm0ruYUsfOwzzaFPL7TkJaiA199C/WoyD7M29Rdv1x
	 jFtV+qtv3n5zQFvbNO5Mw+5QK6W9tAGsnErfMrWV6e+Iny1tKo4tDOCwWu0BVZm55/
	 KHfhiSvFYeSEw==
Subject:
 Re: [PATCH net 15/15] ipvs: pass correct sk to update_pmtu and on tunneling
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Sat, 14 Nov 2026 02:15:50 +0000
Message-ID: <179462255032.2199510.1137217300010098170@kernel.org>
In-Reply-To: <20261113011447.2357709-16-pablo@netfilter.org>
References: <20261113011447.2357709-16-pablo@netfilter.org>
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

Thank you for your contribution! Sashiko AI review found 6 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 3 · Low: 3

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The new IPv6 null transmitter was added to the IPv4 binder
  instead of the IPv6 one.
- [Medium] maybe_update_pmtu() treats `sk->sk_state == TCP_ESTABLISHED`
  as proof that the socket's daddr is the packet's destination; the…
- [Medium] ip_vs_tunnel_xmit() and ip_vs_tunnel_xmit_v6() now call
  ip_local_out(net, NULL, skb) and ip6_local_out(net, NULL, skb) instead…
- [Low] The new family check in maybe_update_pmtu() (`sk->sk_family ==
  dst->ops->family`, net/netfilter/ipvs/ip_vs_xmit.c:224) also turns off…
- [Low] The commit message's main example is UDP_TUNNEL (state->sk
  differs from skb->sk) and it says 'we may need to provide state->sk to…
- [Low] maybe_update_pmtu() relies on a lockless, plain read of
  `sk->sk_state == TCP_ESTABLISHED` to make sure the socket has a valid…

--

ipvs: pass correct sk to update_pmtu and on tunneling

The patch passes the netfilter hook state down through the IPVS
conn_schedule and packet_xmit handlers. maybe_update_pmtu() then uses
state->sk, limited to TCP_ESTABLISHED sockets at LOCAL_OUT whose family
matches the dst. The tunnel transmitters now call ip_local_out() and
ip6_local_out() with a NULL sk, and a new ip_vs_null_xmit_v6() handler is
added.

Link: https://sashiko.dev/#/patchset/20261103152550.60449-1-ja%40ssi.bg

> diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
> index 83d8a9153a342..7cb8de634f5f9 100644
> --- a/net/netfilter/ipvs/ip_vs_conn.c
> +++ b/net/netfilter/ipvs/ip_vs_conn.c
> @@ -1057,7 +1057,7 @@ static inline void ip_vs_bind_xmit(struct ip_vs_conn *cp)
>  		break;
>  
>  	case IP_VS_CONN_F_LOCALNODE:
> -		cp->packet_xmit = ip_vs_null_xmit;
> +		cp->packet_xmit = ip_vs_null_xmit_v6;
>  		break;
>  
>  	case IP_VS_CONN_F_BYPASS:

[Severity: Medium]
Was this change meant for ip_vs_bind_xmit_v6() instead?

This hunk is in ip_vs_bind_xmit(), which is not under CONFIG_IP_VS_IPV6.
Both the prototype in include/net/ip_vs.h and the definition in
ip_vs_xmit.c sit inside #ifdef CONFIG_IP_VS_IPV6.

With CONFIG_IP_VS enabled and CONFIG_IP_VS_IPV6 disabled (for example
CONFIG_IPV6=n), won't this fail to build? ip_vs_null_xmit_v6 would be
both an implicit declaration and an undefined symbol.

With CONFIG_IP_VS_IPV6=y it builds, but the two bindings look swapped.
IPv4 LOCALNODE connections now get the v6 handler, while the IPv6 binder
is unchanged:

net/netfilter/ipvs/ip_vs_conn.c:ip_vs_bind_xmit_v6() {
    ...
	case IP_VS_CONN_F_LOCALNODE:
		cp->packet_xmit = ip_vs_null_xmit;
		break;
    ...
}

So IPv6 connections never use ip_vs_null_xmit_v6, which is the opposite
of what the commit message describes. This has no runtime effect, because
ip_vs_send_or_cont() only reads pf when local == 0.

> diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
> index ebc6b697ae516..c777493eee749 100644
> --- a/net/netfilter/ipvs/ip_vs_xmit.c
> +++ b/net/netfilter/ipvs/ip_vs_xmit.c
> @@ -205,13 +205,24 @@ static inline bool crosses_local_route_boundary(int skb_af, struct sk_buff *skb,
>  	return false;
>  }
>  
> -static inline void maybe_update_pmtu(int skb_af, struct sk_buff *skb, int mtu)
> +static inline void maybe_update_pmtu(int skb_af, struct sk_buff *skb, int mtu,
> +				     const struct nf_hook_state *state)
>  {
> -	struct sock *sk = skb->sk;
> -	struct rtable *ort = skb_rtable(skb);
> -
> -	if (!skb->dev && sk && sk_fullsock(sk))
> -		ort->dst.ops->update_pmtu(&ort->dst, sk, NULL, mtu, true);
> +	struct dst_entry *dst = skb_dst(skb);
> +	struct sock *sk = state->sk;
> +
> +	/* The update_pmtu handlers are missing some checks for:
> +	 * - skb->dev: present for tunnels, not for IPVS, so we do not
> +	 * provide skb, only sk
> +	 * - present daddr: so, we require TCP_ESTABLISHED (connected socket)
> +	 *
> +	 * In some states the senders ignore the PMTU events:
> +	 * - sk_fullsock(): so use the TCP_ESTABLISHED check
> +	 */
> +	if (sk && sk->sk_state == TCP_ESTABLISHED &&
> +	    state->hook == NF_INET_LOCAL_OUT &&
> +	    sk->sk_family == dst->ops->family)
> +		dst->ops->update_pmtu(dst, sk, NULL, mtu, false);
>  }

[Severity: Medium]
For datagram sockets, does TCP_ESTABLISHED guarantee that the socket's
daddr is the packet's destination? The commit message says "where the sk
is connected to destination address".

udp_sendmsg() still uses msg_name on a connected socket:

net/ipv4/udp.c:udp_sendmsg() {
    ...
		daddr = usin->sin_addr.s_addr;
		dport = usin->sin_port;
    ...
}

An unprivileged local user could connect() a UDP socket to any address X
and then sendto() an IPVS tunnel VIP. Every new check passes (sk set,
TCP_ESTABLISHED, LOCAL_OUT, AF_INET):

udp_sendmsg()
  ip_local_out()
    ip_vs_in_hook()
      ip_vs_tunnel_xmit()
        __ip_vs_get_out_rt()
          maybe_update_pmtu()
            ip_rt_update_pmtu(dst, sk, NULL, mtu, false)
              ip_rt_build_flow_key()->build_sk_flow_key()
                  /* daddr = inet->inet_daddr, i.e. X */
              __ip_rt_update_pmtu()
                update_or_create_fnhe(nhc, X, 0, mtu, ...)

Would that create a netns-wide PMTU exception for X, using the tunnel MTU
from the VIP route?

IPv6 looks similar. With iph == NULL, __ip6_rt_update_pmtu() uses
sk->sk_v6_daddr and adds an RTF_CACHE exception under the VIP route.

The old code behaved the same way with skb->sk. Since the patch now
relies on TCP_ESTABLISHED for this guarantee, could it also compare
inet_sk(sk)->inet_daddr with ip_hdr(skb)->daddr (or sk->sk_v6_daddr with
ipv6_hdr(skb)->daddr)? Limiting the update to stream sockets would be
another option.

[Severity: Low]
Can the sk_state check go stale before the handler reads the address?

Connected UDP sockets send without lock_sock(). A concurrent
connect(AF_UNSPEC) runs __udp_disconnect() under lock_sock only:

net/ipv4/udp.c:__udp_disconnect() {
    ...
	sk->sk_state = TCP_CLOSE;
	WRITE_ONCE(inet->inet_daddr, 0);
    ...
}

Suppose that runs between the sk_state check here and build_sk_flow_key()
reading inet->inet_daddr. Wouldn't ip_rt_update_pmtu() then build the
flow with daddr 0? That ends up in fib_lookup() and
update_or_create_fnhe() for 0.0.0.0, the case the TCP_ESTABLISHED check
is meant to exclude.

On IPv6, a concurrent connect() could leave __ip6_rt_update_pmtu() reading
a torn sk_v6_daddr. The plain sk_state read also races with the plain
store above, which KCSAN may report.

[Severity: Low]
Does the sk->sk_family == dst->ops->family check also rule out AF_INET6
sockets connected to v4-mapped addresses?

Such a socket transmits through the IPv4 path, so at LOCAL_OUT
state->sk->sk_family is AF_INET6 while the dst family is AF_INET.

Before this patch, ip_rt_update_pmtu() was called for these sockets.
build_sk_flow_key() reads only inet_sk() fields (inet_daddr, inet_saddr,
inet_opt, sk_bound_dev_if, sk_mark), and those are valid for v4-mapped
sockets.

When pmtu_disc is enabled, ensure_mtu_is_adequate() still sends ICMP
FRAG_NEEDED to these senders. The lost update matters mostly with
pmtu_disc=0 in tunnel mode.

Was dropping this case intended? If so, could the commit message mention
it?

[Severity: Low]
The commit message gives UDP_TUNNEL as the motivating case:

  "This can be the case for UDP_TUNNEL where different sk is provided to
  ip_local_out. If such packet is then forwarded via IPVS tunnel we may
  need to provide state->sk to the update_pmtu handler, not skb->sk."

vxlan, geneve and wireguard create their sockets with udp_sock_create()
and no peer_udp_port. Those sockets are bound but never connected, so
sk_state stays TCP_CLOSE.

With the TCP_ESTABLISHED check, won't these tunnel sockets never get the
direct update? For most of the motivating cases, the update seems to be
dropped completely rather than redirected to the tunnel socket.

Only connected tunnel sockets still qualify, such as kernel L2TP sockets
or FOU with FOU_ATTR_PEER_PORT. The other tunnel drivers still learn the
PMTU from the ICMP FRAG_NEEDED sent by ensure_mtu_is_adequate().

Could the commit message say this explicitly, to help backporters?

[ ... ]

> @@ -1276,7 +1308,7 @@ ip_vs_tunnel_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
>  
>  	ret = ip_vs_tunnel_xmit_prepare(skb, cp);
>  	if (ret == NF_ACCEPT)
> -		ip_local_out(net, skb->sk, skb);
> +		ip_local_out(net, NULL, skb);
>  	else if (ret == NF_DROP)
>  		kfree_skb(skb);
>  

[Severity: Medium]
Does passing NULL here skip cgroup egress BPF for the encapsulated
packet?

For local clients, IPVS steals the original packet at LOCAL_OUT. That
makes this tunneled packet the only one that reaches ip_finish_output().

ip_vs_prepare_tunneled_skb() keeps the owning socket:

		if (skb->sk)
			skb_set_owner_w(new_skb, skb->sk);

So before this patch, BPF_CGROUP_RUN_PROG_INET_EGRESS(sk, skb) ran with
sk == skb_to_full_sk(skb). With sk == NULL the macro returns early:

	if (cgroup_bpf_enabled(CGROUP_INET_EGRESS) && sk) {

As a result, cgroup_skb/egress programs (for example systemd
IPAddressDeny= or IPAccounting=) would no longer filter or count locally
generated traffic that IPVS forwards in tunnel mode. The same applies to
the ip6_local_out(net, NULL, skb) change in ip_vs_tunnel_xmit_v6().

The NAT and DR paths already pass NULL to NF_HOOK() in
ip_vs_send_or_cont(), so this matches them. On the other hand,
xfrm_output_resume() keeps the original sk for locally encapsulated
packets.

Was this side effect intended? If so, could the commit message mention
it?

> @@ -1418,7 +1451,7 @@ ip_vs_tunnel_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
>  
>  	ret = ip_vs_tunnel_xmit_prepare(skb, cp);
>  	if (ret == NF_ACCEPT)
> -		ip6_local_out(net, skb->sk, skb);
> +		ip6_local_out(net, NULL, skb);
>  	else if (ret == NF_DROP)
>  		kfree_skb(skb);
>

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261113011447.2357709-2-pablo%40netfilter.org
