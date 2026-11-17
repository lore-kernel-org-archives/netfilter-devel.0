Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794879634;
	b=e1cVYug/TNHi/wn2BUEChfCTURCiREmJPxs1eDnCWd0YFK256nH0ChgoImzIu/ThKVla
	 yJgaV729AKekpPPCKXIC/KRZBfG5wZ3xWLrgAXQJOv/ElFKxwvlUFdbJa0+jemfFe917S
	 403uV/y32Yfc8Q5zLA/asRwATJt5ycyJbv81hiW9UIc6DEjGHJH0MKpfZjtDC1DfpnVLJ
	 21Wb7FjNefc56ZOznfEWFvSzx+lLb5EFDPKCxogXd51zQpb2FP7HZHtL8hwWfgk6NtwON
	 OWRq1jC6R1XVWgY4AHTPOiAr8YtltUwqhW7sJA0p91Yz941C8LkTIndX4zWw+iyqQiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794879634;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=TNaxjKn+yd84Ek5TurGXTCya3oTFzwHSZ2zRuEyQCKc=;
	b=y1wKipyikqBXNFz7CUTraFbXSXe6oYb1UQcbczF4km4z3jOjKpd1Uhm5H+X7++a4quF3
	 wRdy/5SMxyNRbPYtQk8eWCBQuMqMLkpmHbG+CTitEcvwMxk82o9LxsBp96p+9UmMhzk4W
	 VoGaZ/bw/Csk9iZt+QaO7XSwoWl6dOxlCVJRWU/XFMjj1akdSmPolGglPvuCp5ezm9SA7
	 qP64tj79B4moEP65jF0YoYMBS2DW+NSHX6eAey7sDzDu+ls1iqgB6fk+k07i395+Br/6Y
	 x0RRc5v8LR3Gz6MwZJPO4ylz6Y5/zCyYqJh2mza3tIRI5LEwn5s/OYORShibMU9NUyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mLrVkwkn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D80B606A332;
	Tue, 17 Nov 2026 01:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mLrVkwkn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2381F000C4;
	Tue, 17 Nov 2026 01:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794879634;
	bh=TNaxjKn+yd84Ek5TurGXTCya3oTFzwHSZ2zRuEyQCKc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=mLrVkwknG2kICY4twtyNuTfc5dQ5wZkElgdUzmFhdxw3KyzPDixXg/0f5nwvhbhZO
	 gTloR6JG5yO8k2c8kvKbgd/0OVz4iVGbjhhxZ5rJPelpnHGiZXCothgcdVahmU56Tp
	 H8xA5kdSvQz6B6adtMpSlAc9hCl8fKUsvNDilfC0mttYRX+RycrxkxsauD3fqM2hDe
	 SvWPHQXLewm3WFy328LVP3coVN8IONQaVVeQJv0XkGZ1j2FcavEH94/lRze0Wz3Gy9
	 c78g8uEEuDeYGG2o7xKpK+1Tb7GVGP503DRf0BtMjG8xcwZCJRARmedklnFbs5Ergp
	 tzPRTaZgpDs8w==
Subject:
 Re: [PATCH net 10/11] ipvs: do not create conns from packets with port 0
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 17 Nov 2026 01:40:33 +0000
Message-ID: <179487963329.3136.11227226787276094605@kernel.org>
In-Reply-To: <20261116004404.2821183-11-pablo@netfilter.org>
References: <20261116004404.2821183-11-pablo@netfilter.org>
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

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] udp_conn_schedule() (net/netfilter/ipvs/ip_vs_proto_udp.c) now
  drops every UDP packet with source or destination port 0 that matches…
- [Low] The commit message explains rejecting cport 0 (the NO_CPORT
  lookup requirement makes such connections impossible to find again),…

--

ipvs: do not create conns from packets with port 0

This commit makes tcp_conn_schedule(), udp_conn_schedule() and
sctp_conn_schedule() drop new packets that match a virtual service when
either the source or the destination port is 0. It also makes
ip_vs_new_conn_out() refuse to create connections for client port 0. The
stated reason is that cport 0 connections cannot be found again because
of the NO_CPORT lookup requirement, so a new connection gets created for
every packet.

Link: https://sashiko.dev/#/patchset/20261104201530.147292-1-ja%40ssi.bg
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261103140308.591690-3-pablo%40netfilter.org
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260925141115.16126-1-axel.mierczuk%401password.com

> diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c b/net/netfilter/ipvs/ip_vs_proto_tcp.c
> index fec0e8b47b716..25d4576d0e129 100644
> --- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
> +++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c

[ ... ]

> @@ -74,6 +75,12 @@ tcp_conn_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
>  	if (svc) {
>  		int ignored;
>  
> +		/* Do not create connection for port 0 */
> +		if (!ports[0] || !ports[1]) {
> +			*verdict = NF_DROP;
> +			return 0;
> +		}

[Severity: Low]
The commit message gives a reason for rejecting cport 0, then says "Do
the same for vport 0." without giving one. Does the duplicate connection
problem apply to the virtual port at all?

__ip_vs_conn_in_get() compares vport with plain equality. Only p->cport
takes part in the XOR:

	if (p->cport == cp->cport &&
	    p->vport == cp->vport && cp->af == p->af &&
	    ...
	    (!p->cport ^
	     (!(cp->flags & IP_VS_CONN_F_NO_CPORT))) &&

ip_vs_conn_out_get() also matches the server side port with plain
equality. Its XOR uses p->vport, which in the out direction is the client
port:

	if (p->cport == sport && cp->af == p->af &&
	    ...
	    (!p->vport ^
	     (!(cp->flags & IP_VS_CONN_F_NO_CPORT))) &&

So a hashed connection with vport 0 and a non-zero cport looks like it
can still be found, and would not be duplicated on every packet.

Before this patch, packets to destination port 0 that hit fwmark services
or persistent port-zero services were scheduled and forwarded. The
!ports[1] check (or !ports[0] in the inverse case) now drops them. The
same check is in udp_conn_schedule() and sctp_conn_schedule().

If this is meant as a policy change, for example because port 0 is not
valid on the wire, could the commit message say so? That would help
reviewers and stable backporters judge it.

[ ... ]

> diff --git a/net/netfilter/ipvs/ip_vs_proto_udp.c b/net/netfilter/ipvs/ip_vs_proto_udp.c
> index f32785682402d..ab3ab95241687 100644
> --- a/net/netfilter/ipvs/ip_vs_proto_udp.c
> +++ b/net/netfilter/ipvs/ip_vs_proto_udp.c
> @@ -62,6 +62,12 @@ udp_conn_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
>  	if (svc) {
>  		int ignored;
>  
> +		/* Do not create connection for port 0 */
> +		if (!ports[0] || !ports[1]) {
> +			*verdict = NF_DROP;
> +			return 0;
> +		}

[Severity: Medium]
Should one-packet scheduling (OPS) UDP services be excluded from this
check?

The check runs before ip_vs_schedule() sets IP_VS_CONN_F_ONE_PACKET, so
it also drops port 0 traffic for services with IP_VS_SVC_F_ONEPACKET.
OPS connections are never inserted into the connection table:

net/netfilter/ipvs/ip_vs_conn.c:ip_vs_conn_hash() {
    ...
	if (cp->flags & IP_VS_CONN_F_ONE_PACKET)
		return 0;
    ...
}

They are also freed right after use. So the NO_CPORT mismatch in
__ip_vs_conn_in_get() cannot cause duplicate connections for them:

	(!p->cport ^
	 (!(cp->flags & IP_VS_CONN_F_NO_CPORT))) &&

Before this patch, OPS UDP traffic from client port 0 was scheduled and
forwarded. RFC 768 allows source port 0 for one-way UDP, and that is the
traffic OPS is meant for. With this patch those packets are dropped.

The new !cport check in ip_vs_new_conn_out() has the same scope:

	if (!vport || !dport || !cport)
		return NULL;

It returns before the IP_VS_CONN_F_ONE_PACKET flags are computed. As a
result, OPS UDP initiated by a real server toward client port 0 gets no
connection, and leaves the director without SNAT.

The commit message says it will "disallow normal connections ... to be
created". It doesn't mention that matching packets are now dropped, or
that OPS services are affected too.

Could OPS services be exempted here and in ip_vs_new_conn_out()? If not,
could the commit message describe the dropping?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116004404.2821183-2-pablo%40netfilter.org
