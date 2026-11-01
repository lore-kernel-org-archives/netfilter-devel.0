Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793562558;
	b=KaRd9qV/jrGxKGZXY9+uTei3fLvI0pBrIRi/I9PXvcNO23gP1lrt5mENxl1eNpmT74Hf
	 exeYY2tbI+0Fi/ptD3MCDTXl+p2ThKofojuZFkksbB+a8XiqUd95PjCeVQrOhzDEFlyAm
	 wzU3LD12J++2xW2BTuYMDqxTplvnOMR/QO75oPVcwjKcAOeGfK2Lhf5Zjjw+tMCHcdJlf
	 HC+90FBa+ePQIYi1SohF+4gGpWhHM0ITRf/HO8KV+vhMzqE3JP2ckWdx2cPh7wfmyWfJ3
	 xFhelPpSN9gqus5VuoqksLuoLy2TD7GseBnMOX/VGTJHkqOn+UYmEDVtw/mVH5FxBCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793562558;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=e3fXnbXvrppsv9b1CycvrU+6k4v2UpUxemRS9qJBayU=;
	b=Qmqu5l1aiIeRM5kbWw38Z5g4znw3dfwrpCd45+41nM6dnPaP4eWjVLmbQAHr7tzTiJpm
	 hVtt4ZSEXeiD39MrR9+IEcnQ5qCdOIguGJuf5SEnKkOSQk8t8TSFSCMLvnOgfULyYzCjt
	 dLxR/dha5JqgJ1LMfiyXNWrjcIfzio3k4sZDxoSgSvfwLm+qntYZZCD6E0oiyEaYrtOmJ
	 WwO6Ue+vbtM9eAQIK2I0CmWK3xpQHpokb0lGIEqBs18L9FHNwbQMFMiRQFkUWxPqtVT/1
	 1qgsxe7SGEY87LsNrrUG+5dHvRuvsFTlr/2QzwzxpaGL4U+xuX4cfgWPhWbnqa80dig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KRcrnAJR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD6B606A324;
	Sun,  1 Nov 2026 19:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KRcrnAJR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D933E1F00919;
	Sun,  1 Nov 2026 19:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793562557;
	bh=e3fXnbXvrppsv9b1CycvrU+6k4v2UpUxemRS9qJBayU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=KRcrnAJRlY+3zLz6rcR4u5vB8il6QxdVqYbB2CJtJBLqjwUSJcQvy/zaR9gvXxlaY
	 immUobDzl0Ki/qUhTiVQBtgcbTJ5zMqFv56G/Z8IGCGDdjETQh9C1fsfHzMilL2Go1
	 wWUEALjfL7bZgkpzK3aAUxdDz/6gug+wFuMO/HTVnre2ybJm97QQhOcMtrF4mV9SYc
	 rV8s1CXsAIadFwzOZdeRe8Du74zyi5pHB9gCR81Lritz/Ce7QlyhOT4lfw4gSiJyUA
	 /Tlblv0mklW+droaQnw30Vv30j0E9ioN/UtIKYIWOEWCkOb+Xohcs2Yc/Kzny/Vnn9
	 30bUtUY0zVlfg==
Subject: Re: [PATCH net v3 2/3] net/ipv6: don't route packets with unknown
 source address
From: netdev-bot+sashiko@kernel.org
To: ihuguet@riseup.net
Cc: ast@kernel.org, andrew+netdev@lunn.ch, andrii@kernel.org,
 daniel@iogearbox.net, dsahern@kernel.org, davem@davemloft.net,
 eddyz87@gmail.com, edumazet@kernel.org, fw@strlen.de, idosch@nvidia.com,
 kuba@kernel.org, memxor@gmail.com, ncardwell@google.com, pablo@netfilter.org,
 pabeni@redhat.com, shuah@kernel.org, willemdebruijn.kernel@gmail.com,
 bpf@vger.kernel.org, leitao@debian.org, coreteam@netfilter.org,
 emil@etsalapatis.com, fmancera@suse.de, ihor.solodrai@linux.dev,
 jlayton@kernel.org, jolsa@kernel.org, joe@dama.to, john.fastabend@gmail.com,
 zirajs7@gmail.com, kees@kernel.org, kuniyu@google.com, leon.hwang@linux.dev,
 lirongqing@baidu.com, linux-kselftest@vger.kernel.org, martin.lau@linux.dev,
 netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, phil@nwl.cc,
 tpluszz77@gmail.com, bigeasy@linutronix.de, horms@kernel.org, song@kernel.org,
 sdf@fomichev.me, willemb@google.com, luoxuanqiang@kylinos.cn,
 yonghong.song@linux.dev, ihuguet@redhat.com, dcaratti@redhat.com
Date: Sun, 01 Nov 2026 19:49:14 +0000
Message-ID: <179356255441.3131.5729735978944653585@kernel.org>
In-Reply-To: <20261028191103.623156-3-ihuguet@riseup.net>
References: <20261028191103.623156-3-ihuguet@riseup.net>
X-sashiko-severity: High
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

Thank you for your contribution! Sashiko AI review found 7 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 5 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] ip6_is_local_saddr() in net/ipv6/ip6_output.c declares `struct
  fib6_result fib_result;` without initializing it and passes it to…
- [Medium] The new source-address check lives only in
  ip6_dst_lookup_tail() and is not part of the core IPv6 output route…
- [Medium] The ip6_is_local_saddr() fallback that is supposed to keep
  AnyIP working calls fib6_lookup(net, 0, &fl6, ...) on a freshly zeroed…
- [Medium] net/sctp/ipv6.c:sctp_v6_get_dst() builds its own flowi6
  (memset to zero) and calls ip6_dst_lookup_flow(), but never sets…
- [Medium] The new source check runs only in ip6_dst_lookup_tail(), and
  ip6_sk_dst_lookup_flow() returns the socket's cached dst before…
- [Medium] The new source check runs before the socket takes its route-
  cache cookie, and nothing orders the two against address deletion.
- [Low] The new non-local source check in ip6_dst_lookup_tail() runs
  before the existing IPv4-mapped source check (ip6_output.c:1275-1279,…

--

net/ipv6: don't route packets with unknown source address

This patch adds a source address check to ip6_dst_lookup_tail(). Flows
whose saddr is not configured on the host are rejected with -ENETUNREACH
unless FLOWI_FLAG_ANYSRC is set, and ANYSRC is now set in the IPv6
places where IPv4 sets it. A FIB lookup fallback in ip6_is_local_saddr()
is meant to keep loopback subnets (AnyIP) working.

> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> index 25fe0ba98b1a6..8715cf43f00ac 100644
> --- a/net/ipv6/ip6_output.c
> +++ b/net/ipv6/ip6_output.c
> @@ -1134,6 +1134,33 @@ static struct dst_entry *ip6_sk_dst_check(struct sock *sk,
>  	return dst;
>  }
>  
> +/* Check if the address belongs to the host */
> +static bool ip6_is_local_saddr(struct net *net, struct in6_addr *saddr)
> +{
> +	struct fib6_result fib_result;

[Severity: High]
Should fib_result be zero-initialized here? The other fib6_lookup()
callers use "struct fib6_result res = {};".

If net->ipv6.fib6_has_custom_rules is set (any ip -6 rule, VRF,
wg-quick and so on), fib6_lookup() goes through fib_rules_lookup(). That
calls ops->suppress after each successful rule action:

fib_rules_lookup()
  fib6_rule_action()
    fib6_rule_action_alt()    /* returns 0, never writes res->rt6 */
  fib6_rule_suppress()

net/ipv6/fib6_rules.c:fib6_rule_suppress() {
	struct fib6_result *res = arg->result;
	struct rt6_info *rt = res->rt6;
	...
	if (!rt)
		return false;

	if (rt->rt6i_idev)
		dev = rt->rt6i_idev->dev;
	...
	if (rt->rt6i_dst.plen <= rule->suppress_prefixlen)
		goto suppress_route;
	...
suppress_route:
	ip6_rt_put_flags(rt, flags);
}

Only __fib6_rule_action() writes res->rt6. Here, whatever was left on
the stack would be dereferenced as an rt6_info pointer. If a rule has
suppress_prefixlen set, that pointer could also be released as a dst.

Any flow without ANYSRC and with a non-configured saddr reaches this
path, for example:

- a socket using IPV6_FREEBIND
- an established TCP socket whose address's valid_lft has expired
- IPV6_PKTINFO with nonlocal bind

CONFIG_INIT_STACK_ALL_ZERO builds would hide the problem.

> +	struct flowi6 fl6;
> +	bool result;
> +
> +	if (ipv6_chk_addr_namespace(net, saddr) ||
> +	    ipv6_chk_acast_addr_src(net, NULL, saddr))
> +		return true;
> +
> +	/* Fallback to FIB local routes so that loopback subnets work. */
> +	memset(&fl6, 0, sizeof(fl6));
> +	fl6.daddr = *saddr;

[Severity: Medium]
Can this fallback find AnyIP local routes that live in a VRF table or in
a policy-routed table?

Only daddr is set here. The caller's flowi6_l3mdev, oif, iif and mark
are all dropped, even though ip6_dst_lookup_tail() has the original fl6
available and passes only &fl6->saddr.

With the VRF l3mdev rule installed, fib6_lookup()->l3mdev_update_flow()
finds no l3mdev because oif and iif are 0. The rule then never matches:

net/l3mdev/l3mdev.c:l3mdev_fib_rule_match() {
	...
	if (!fl->flowi_l3mdev)
		return 0;
	...
}

Tables selected by fwmark, iif or oif rules are skipped the same way.

For example, with "ip -6 route add local 2001:db8::/64 dev lo table
<vrf-table>", a socket in that VRF that replies from 2001:db8::5 would
now get -ENETUNREACH. The commit message presents AnyIP as handled, but
this seems to work only for local routes in the local or main tables.

> +	result = false;
> +
> +	rcu_read_lock();
> +	if (fib6_lookup(net, 0, &fl6, &fib_result, 0) == 0 &&
> +	    fib_result.fib6_type == RTN_LOCAL &&
> +	    fib_result.nh->nh_common.nhc_dev) {
> +		result = true;
> +	}
> +	rcu_read_unlock();
> +
> +	return result;
> +}
> +
>  static int ip6_dst_lookup_tail(struct net *net, const struct sock *sk,
>  			       struct dst_entry **dst, struct flowi6 *fl6)
>  {
> @@ -1191,6 +1218,17 @@ static int ip6_dst_lookup_tail(struct net *net, const struct sock *sk,
>  	if (err)
>  		goto out_err_release;
>  
> +	/* From RFC 4862, "an invalid address MUST NOT be used as the source
> +	 * address of outbound packets". Exceptions to this must set the ANYSRC
> +	 * flag (i.e. transparent sockets).
> +	 */
> +	if (!ipv6_addr_any(&fl6->saddr) &&
> +	    !(fl6->flowi6_flags & FLOWI_FLAG_ANYSRC) &&
> +	    !ip6_is_local_saddr(net, &fl6->saddr)) {
> +		err = -ENETUNREACH;
> +		goto out_err_release;
> +	}
> +

[Severity: Low]
Does this new check shadow the existing v4-mapped check further down in
ip6_dst_lookup_tail(), which came from commits ec5e3b0a1d41 and
00ea1ceebe0d?

	if (ipv6_addr_v4mapped(&fl6->saddr) &&
	    !(ipv6_addr_v4mapped(&fl6->daddr) || ipv6_addr_any(&fl6->daddr))) {
		err = -EAFNOSUPPORT;
		goto out_err_release;
	}

ip6_is_local_saddr() always returns false for ::ffff:a.b.c.d. So any
flow without ANYSRC that has a v4-mapped saddr now gets -ENETUNREACH,
and IPSTATS_MIB_OUTNOROUTES is incremented even though a route was
found.

For example, a dual-stack UDP socket bound to ::ffff:127.0.0.1 that
calls sendto() to a native IPv6 peer used to get EAFNOSUPPORT and now
gets ENETUNREACH. A v4-mapped saddr with a v4-mapped or :: daddr, which
used to be allowed, would now be rejected too.

[Severity: Medium]
Is SCTP missing an inet_sk_flowi_flags() update like the other
protocols got in this patch?

sctp_v6_get_dst() in net/sctp/ipv6.c builds its own flow and never sets
flowi6_flags:

net/sctp/ipv6.c:sctp_v6_get_dst() {
	...
	memset(&_fl, 0, sizeof(_fl));
	fl6->daddr = daddr->v6.sin6_addr;
	...
	dst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, final_p);
	...
		bdst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, final_p);
	...
}

SCTP does allow binding to non-local addresses:

net/sctp/ipv6.c:sctp_v6_available() {
	...
	res = ipv6_can_nonlocal_bind(net, &sp->inet) ||
	      ipv6_chk_addr(net, in6, dev, 0);
	...
}

Take an SCTPv6 socket with IPV6_TRANSPARENT that is bound to a
non-local address. Both the first lookup and each bind-address lookup in
the loop would now fail with -ENETUNREACH, leaving t->dst NULL.

IPv4 SCTP (sctp_v4_get_dst()) does not set ANYSRC either, so this
matches IPv4. It is still new breakage for IPv6 SCTP TPROXY users.

[Severity: Medium]
Can the socket dst cache bypass this check?

ip6_sk_dst_lookup_flow() returns the cached dst before it reaches
ip6_dst_lookup_tail():

net/ipv6/ip6_output.c:ip6_sk_dst_lookup_flow() {
	struct dst_entry *dst = sk_dst_check(sk, inet6_sk(sk)->dst_cookie);

	dst = ip6_sk_dst_check(sk, dst, fl6);
	if (dst)
		return dst;
	...
}

ip6_sk_dst_check() compares fl6->saddr only under
CONFIG_IPV6_SUBTREES. Otherwise it checks just daddr and oif.

Consider a connected UDPv6 socket with IPV6_FREEBIND, or a host with
ip_nonlocal_bind=1. ip6_datagram_send_ctl() copies any IPV6_PKTINFO
ipi6_addr into fl6->saddr, because ipv6_can_nonlocal_bind() is true.

udpv6_sendmsg() clears connected when cmsgs are present, but that only
stops the dst from being stored. The dst cached by connect() is still
returned, and the packet goes out with an arbitrary non-local source.
The same send without a cached dst would be rejected with -ENETUNREACH.

IPv4 udp_sendmsg() clears connected before sk_dst_check() when cmsgs
are present, so its core check always runs.

[Severity: Medium]
Is there a window where an address deletion is missed and the stale dst
then stays cached?

The check here runs before the socket samples its route cookie in
ip6_dst_store(), and nothing orders the two against ipv6_del_addr():

CPU0 (socket lock, e.g. inet6_csk_route_socket())
ip6_dst_lookup_tail()
  ip6_is_local_saddr()            /* address still found */

CPU1 (RTNL)
ipv6_del_addr()
  hlist_del_init_rcu(&ifp->addr_lst)
  __ipv6_ifa_notify(RTM_DELADDR)
    rt_genid_bump_ipv6(net)       /* flushes fn_sernum */

CPU0
ip6_dst_store()
  rt6_get_cookie()
    fib6_get_cookie_safe()        /* reads the post-flush sernum */

For routes without a nexthop object (rt->sernum == 0), the cached dst
now carries a current cookie. Later calls through __sk_dst_check() ->
ip6_dst_check() accept it, and ip6_dst_lookup_tail() is not run again
for that socket. Packets would keep going out with the removed source
until some unrelated routing change flushes the trees again. Routes that
use nexthop objects are not affected.

>  #ifdef CONFIG_IPV6_OPTIMISTIC_DAD
>  	/*
>  	 * Here if the dst entry we've looked up

[ ... ]

> diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
> index a7025ec870359..716fc6e246de9 100644
> --- a/net/ipv6/netfilter.c
> +++ b/net/ipv6/netfilter.c

[ ... ]

> @@ -41,6 +42,12 @@ int ip6_route_me_harder(struct net *net, struct sock *sk_partial, struct sk_buff
>  	};
>  	int err;
>  
> +	fl6.flowi6_flags = sk ? inet_sk_flowi_flags(sk) : 0;
> +	if (saddr_type & (IPV6_ADDR_UNICAST | IPV6_ADDR_LINKLOCAL))
> +		fl6.flowi6_flags |= FLOWI_FLAG_ANYSRC;
> +	else
> +		fl6.saddr = in6addr_any;
> +

[Severity: Medium]
Does this ANYSRC assignment have any effect? This flow goes straight to
ip6_route_output(), and in net/ipv6 the flag is read only by the new
check in ip6_dst_lookup_tail(). xfrm_decode_session() also rebuilds fl6
afterwards.

This points to a wider gap: the new check is not in the core IPv6
output lookup, so direct ip6_route_output() callers skip it. In IPv4 the
check sits in ip_route_output_key_hash_rcu() and covers every output
lookup, including __xfrm4_dst_lookup().

On the IPv6 side, xfrm6_dst_lookup() copies the SA's saddr and routes it
without any source check:

net/ipv6/xfrm6_policy.c:xfrm6_dst_lookup() {
	...
	if (params->saddr)
		memcpy(&fl6.saddr, params->saddr, sizeof(fl6.saddr));
	...
	dst = ip6_route_output(params->net, NULL, &fl6);
	...
}

So IPsec tunnel-mode outer headers would still go out with a removed or
expired local address. Other direct ip6_route_output() users
(ip6_route_me_harder(), collect_md tunnels, seg6/rpl) are also
unchecked.

This hunk also clears fl6.saddr for non-unicast source types (::,
v4-mapped, multicast) before the reroute lookup. The commit message does
not mention that change.

Given this, is the statement in the commit message accurate?

  This aligns the behaviour with the IPv4 stack.

>  	if (sk && sk->sk_bound_dev_if)
>  		fl6.flowi6_oif = sk->sk_bound_dev_if;
>  	else if (strict)

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261028191103.623156-1-ihuguet%40riseup.net
