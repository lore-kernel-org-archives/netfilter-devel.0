Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793802565;
	b=ke6YRRnWewFwnHAAqtt0XaMsnBFjh7cdY2xXv+FOV6bDJo210BY6NlixZwEZq30D4XUt
	 z5rKfME2Foax3q60q540K89qYaje884pIibJK3ejBVynoTg44v+Xwibh0muFG+CHXrxJS
	 090dq43117dRcL/2rHe3F+rycpwWfXZWvXuJWByjkwKwjSyX8orfjgxqXdFBrUycRuOIr
	 zLy9yOcx4b32WyzhSDHRKnyyLrZkJFNWb7g9Up1+UE4ZzmifMRRkCXx4eUn0bGb0h+Hta
	 f+IcY4+FageBMM60CZuTo7aiwvsibRw5WdNlwk9d7jkGYRL76+Gbx0qStittG5ph6HQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793802565;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=xNW8SUXY3/+f+CDeibZWKLCb0tWZvjpoSzIxOcHgyuI=;
	b=E5ZfIFYvtNw9OBe1t9zlS5l9hLRM5a76j0LPhdz+Ia7Zp3wdBWSWUiKs+2HPdl8wxD3N
	 OAQhAwJEzynmLbEcHHziy9YbqYoWwN54Eyn54w7y+omsFmLwj3YwnqLaC0dz3RWuIaUaZ
	 W43gS4SzSd7U6IbnXrLWGuff9I61I0bnQM+RmLsDhjTs/wik9fYqf57eoZIN0LzDuVVjJ
	 FvujS0L81PmsTP4Mbb0pqQiTvdNeP40o/hvNNUN7HQg1SuXHHItBAA/Nxl6ol+H2wSk1Y
	 aJ3Uz+JcqwYCddFkPdXnbfMVb++NU1r4xHRKIRPngSmXPQi1R19OCNUF4p2mMdc7lmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=efI5Ys1z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF1D606A32C;
	Wed,  4 Nov 2026 14:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=efI5Ys1z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1663A1F000C1;
	Wed,  4 Nov 2026 14:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793802564;
	bh=xNW8SUXY3/+f+CDeibZWKLCb0tWZvjpoSzIxOcHgyuI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=efI5Ys1zqFnSjvBXgC/EKaW0nO5QpLq5noEzldRvTyu0hD6EMxfTA8Fo7YwuqF2+N
	 qvy89l8Dr4R7umwkJLeLtNMLoiGYx5bGJHvlqOqRCWKJ893fu5SN3MWMfakt+Qi0LW
	 jAlGqSdiSA4nHiezJfbC1VKN6szToV9uL/BPxILU7OJv+bMcEow9KVqKSc62He9JwZ
	 8HSJ4LqxKPNgAxFNQyuGuQTnHK9Gv9pfQIkVJFelRognY3BnoJFXudeM7HgPV8aMUo
	 S+/keZysw8tfjJK4aAQ7Hsstjm9LIxPOZ2VlGGmVjgNCJS7vnK4WtlJnRLnFhR9JJq
	 isfTbIhSUTvbg==
Subject:
 Re: [PATCH net 05/15] ipvs: do not create conns from packets with port 0
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Wed, 04 Nov 2026 14:29:23 +0000
Message-ID: <179380256363.488856.4080152698263995983@kernel.org>
In-Reply-To: <20261103140308.591690-7-pablo@netfilter.org>
References: <20261103140308.591690-7-pablo@netfilter.org>
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

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 3 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The subject of this patch says IPVS should not create
  connections from packets with port 0.
- [Medium] udp_conn_schedule()
  (net/netfilter/ipvs/ip_vs_proto_udp.c:55-57) now returns 1 for any UDP…
- [Medium] The new port-0 early `return 1` in tcp_conn_schedule()
  (ip_vs_proto_tcp.c:66-68), udp_conn_schedule()…

--

ipvs: do not create conns from packets with port 0

This commit stops the TCP, UDP and SCTP conn_schedule handlers and
ip_vs_new_conn_out() from creating normal connections when the client
port or virtual port is 0. Such connections can never be matched later
because of the NO_CPORT lookup rule, so a new duplicate connection is
created for every packet.

Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260925141115.16126-1-axel.mierczuk%401password.com

> diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> index 8a3c880fdb266..f3eb72e95024d 100644
> --- a/net/netfilter/ipvs/ip_vs_core.c
> +++ b/net/netfilter/ipvs/ip_vs_core.c

[ ... ]

> @@ -1328,7 +1329,7 @@ struct ip_vs_conn *ip_vs_new_conn_out(struct ip_vs_service *svc,
>  	/* check pre-requisites are satisfied */
>  	if (svc->fwmark)
>  		return NULL;
> -	if (!vport || !dport)
> +	if (!vport || !dport || !cport)
>  		return NULL;
>  
>  	/* for persistent service first create connection template */

[Severity: Medium]
The FTP application helper also creates connections from packet data.
Does it need the same port 0 check?

In ip_vs_ftp_in(), a client on an established FTP control connection
can send "PORT a,b,c,d,0,0". The legacy branch of
ip_vs_ftp_get_addrport() returns success with port 0:

net/netfilter/ipvs/ip_vs_ftp.c:ip_vs_ftp_get_addrport() {
    ...
		*port = get_unaligned((__be16 *) (p + 4));
		return 1;
    ...
}

ip_vs_ftp_in() then uses that value as the cport. It creates a normal
connection without IP_VS_CONN_F_NO_CPORT:

net/netfilter/ipvs/ip_vs_ftp.c:ip_vs_ftp_in() {
    ...
		ip_vs_conn_fill_param(cp->ipvs, cp->af,
				      ipvsh->protocol, &to, port, &cp->vaddr,
				      htons(ntohs(cp->vport)-1), &p);
		n_cp = ip_vs_conn_in_get(&p);
		if (!n_cp) {
			n_cp = ip_vs_conn_new(&p, cp->af, &cp->daddr,
					      htons(ntohs(cp->dport)-1),
					      IP_VS_CONN_F_NFCT, cp->dest,
					      skb->mark);
    ...
}

__ip_vs_conn_in_get() only matches when this holds:

	(!p->cport ^
	 (!(cp->flags & IP_VS_CONN_F_NO_CPORT)))

So a lookup with cport 0 never finds this entry.

Wouldn't every such PORT command then add another duplicate connection?
That is the same problem the commit message describes.

The extended EPRT/EPSV branch of the same function already rejects
port 0, so the two formats handle it differently:

	if (s == data_limit || !hport || *s != edelim)
		return -1;

[ ... ]

> diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c b/net/netfilter/ipvs/ip_vs_proto_tcp.c
> index fec0e8b47b716..2e55b62445c60 100644
> --- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
> +++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c

[ ... ]

> @@ -62,6 +63,10 @@ tcp_conn_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
>  		return 0;
>  	}
>  
> +	/* Do not create connection for port 0, skip the packet */
> +	if (!ports[0] || !ports[1])
> +		return 1;
> +

[Severity: Medium]
Does this change where port 0 packets sent to a configured VIP:port end
up?

This check runs before ip_vs_service_find(). Returning 1 while *cpp is
still NULL makes ip_vs_try_to_schedule() accept the packet:

net/netfilter/ipvs/ip_vs_core.c:ip_vs_try_to_schedule() {
    ...
	if (unlikely(!*cpp)) {
    ...
		*verdict = NF_ACCEPT;
		return 0;
	}
    ...
}

Before this patch, a SYN with source port 0 to a VIP:port that has a
service was always handled by IPVS. It was either scheduled to a real
server or passed to ip_vs_leave(). When no destination was available,
ip_vs_leave() did this:

	icmp_send(skb, ICMP_DEST_UNREACH, ICMP_PORT_UNREACH, 0);

	return NF_DROP;

Now the packet goes to the director's own TCP stack instead. If the
director has a local listener on the same port (for example bound to
the wildcard address), can a remote sender using source port 0 now
complete a handshake with it through the VIP? IPVS used to shadow that
listener. The local TCP receive path does not appear to reject
th->source == 0.

udp_conn_schedule() gets the same early return, and so does
sctp_conn_schedule() for INIT chunks.

Would dropping port 0 packets that match a service, instead of
accepting them, avoid the duplicate connections without changing where
this traffic goes?

>  	/* No !th->ack check to allow scheduling on SYN+ACK for Active FTP */
>  
>  	if (likely(!ip_vs_iph_inverse(iph)))

> diff --git a/net/netfilter/ipvs/ip_vs_proto_udp.c b/net/netfilter/ipvs/ip_vs_proto_udp.c
> index f32785682402d..92c0b76c1a021 100644
> --- a/net/netfilter/ipvs/ip_vs_proto_udp.c
> +++ b/net/netfilter/ipvs/ip_vs_proto_udp.c
> @@ -52,6 +52,10 @@ udp_conn_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
>  		return 0;
>  	}
>  
> +	/* Do not create connection for port 0, skip the packet */
> +	if (!ports[0] || !ports[1])
> +		return 1;
> +

[Severity: Medium]
Does this check also need to cover one-packet scheduling (OPS) UDP
services?

It runs before the service lookup, so it also applies to services with
IP_VS_SVC_F_ONEPACKET. ip_vs_schedule() sets IP_VS_CONN_F_ONE_PACKET
on those connections:

	flags = (svc->flags & IP_VS_SVC_F_ONEPACKET
		 && iph->protocol == IPPROTO_UDP) ?
		IP_VS_CONN_F_ONE_PACKET : 0;

ip_vs_conn_hash() never inserts such connections into the table:

net/netfilter/ipvs/ip_vs_conn.c:ip_vs_conn_hash() {
    ...
	if (cp->flags & IP_VS_CONN_F_ONE_PACKET)
		return 0;
    ...
}

So they cannot cause the duplicate hashed connections this patch
targets.

Before this patch, an OPS service forwarded UDP datagrams with source
port 0 to a real server. RFC 768 allows source port 0 when no reply is
expected, which is the one-way traffic OPS is meant for.

With this change, ip_vs_try_to_schedule() returns NF_ACCEPT for these
datagrams. They go to the director's local stack and are no longer load
balanced. Could ONE_PACKET UDP services be exempted from this check?

>  	if (likely(!ip_vs_iph_inverse(iph)))
>  		svc = ip_vs_service_find(ipvs, af, skb->mark, iph->protocol,
>  					 &iph->daddr, ports[1]);

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261103140308.591690-3-pablo%40netfilter.org
