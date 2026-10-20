Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792510686;
	b=26MmgINSZlRGcWsVZVv9qdiiK/29gRQfFXRyS/5xNyZhkJ6ixsUNncQpKirpH4cHtcqu
	 Ak3D6ROeDHXVhQArpYEPyARK1u2kiZo/BfXEK8t4FMHOYemI+TAf76seeRhKJdut0kIUu
	 fnx3aNehTmW0tzQpTf3am96MwUj2+pMveGGd5s7sB1gVjnU0OaBH0kaCc7eG099QdJGqP
	 l7VBxTW+SZZqmySbXc+5I7voC7ll/HCahzU5uTR0YEfuCgNZPt45Xw864etrdVvKczSly
	 +fa9l3Nq8X5DGnUH74FLTsqi1vXZrCa9v4v8vs2KFTGZDvpAo2533yFaCqyvGgL2p2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792510686;
	h=Received:Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 X-sashiko-severity:Content-Type:Content-Transfer-Encoding:
	 MIME-Version;
	bh=kb7VtS8GkjPRMLpKFBGVZ7+99G77FFFnDQhteJfj4rw=;
	b=li06JC6TH+D0zFjpO4aryhuZU95BcELyK8kie1FOHEGfpXsnF8YzrqHmvQAnkYpD9he7
	 hoc6I094MK90aprmbFhhtatE9LKfzt5yIq+yUJwyvqNK1+/LslkAuIvJVhNBghCuuUiJW
	 VURiVFO/Ukkk6ocsMnDtGQ/S4KTFrJ3edpM+n+EE1MlCtLexJd3rGYsx1jIjXzMu8krXP
	 4oCuBrh9geASv/EzInG50187WiN7ZwcT9GaTYMRQm0q0qZ7ljx2MhGDXDq4UrlsXIWiPg
	 BmNvW3idfgTx2mSZoyw4l0vPhN+thMZZu2NA2uyTjabQhMA4MKfkHZd9isutWTA7UHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E197606A339;
	Tue, 20 Oct 2026 15:38:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1DF41F000C5;
	Tue, 20 Oct 2026 15:38:05 +0000 (UTC)
Subject:
 Re: [PATCH net 06/10] netfilter: nf_reject: initialize IPCB at inet ingress
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 20 Oct 2026 15:37:35 +0000
Message-ID: <179251065552.3135.365430607202597759@kernel.org>
In-Reply-To: <20261019150249.1879516-7-pablo@netfilter.org>
References: <20261019150249.1879516-7-pablo@netfilter.org>
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0 (1)

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The new IPv6 initializer in nf_send_unreach6() sets
  IP6CB(skb_in)->iif = skb_in->skb_iif unconditionally.

Pre-existing issues:
- [Low] At NF_INET_INGRESS, the reject helpers do not check the L4
  checksum of CHECKSUM_COMPLETE packets.

--

netfilter: nf_reject: initialize IPCB at inet ingress

The inet ingress hook runs before ip_rcv_core() and ip6_rcv_core(), so
skb->cb can still hold stale data from an earlier layer. When called from
NF_INET_INGRESS, nf_send_unreach() and nf_send_unreach6() now clear
IPCB/IP6CB and restore iif. This stops stale IPv4 option offsets from
overflowing the stack buffer in __ip_options_echo().

> diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
> index 59ec465a9df9..7cb33af671e2 100644
> --- a/net/ipv4/netfilter/nf_reject_ipv4.c
> +++ b/net/ipv4/netfilter/nf_reject_ipv4.c
> @@ -357,6 +357,11 @@ void nf_send_unreach(struct sk_buff *skb_in, int code, int hook)
>  	if (!skb_valid_dst(skb_in) && nf_reject_fill_skb_dst(skb_in) < 0)
>  		return;
>  
> +	if (hook == NF_INET_INGRESS) {
> +		memset(IPCB(skb_in), 0, sizeof(*IPCB(skb_in)));
> +		IPCB(skb_in)->iif = skb_in->skb_iif;
> +	}
> +
>  	if (skb_csum_unnecessary(skb_in) ||
>  	    !nf_reject_verify_csum(skb_in, dataoff, proto)) {
>  		icmp_send(skb_in, ICMP_DEST_UNREACH, code, 0);

[Severity: Low]
This is a pre-existing issue and was not introduced by this patch. Since
this path now has NF_INET_INGRESS handling, though: is the L4 checksum of
a CHECKSUM_COMPLETE packet ever checked at this hook?

Further down, nf_send_unreach() does:

	if (nf_ip_checksum(skb_in, hook, dataoff, proto) == 0)
		icmp_send(skb_in, ICMP_DEST_UNREACH, code, 0);

nf_ip_checksum() in net/netfilter/utils.c only verifies for PRE_ROUTING
and LOCAL_IN:

	case CHECKSUM_COMPLETE:
		if (hook != NF_INET_PRE_ROUTING && hook != NF_INET_LOCAL_IN)
			break;

With hook == NF_INET_INGRESS, csum stays 0, and the reject code reads that
as a good checksum.

nf_ip6_checksum() has the same check. It affects
reject6_csum_ok()->icmpv6_send() in nf_send_unreach6(), and also the TCP
RST path through nf_reject_ip6_tcphdr_get().

So can an inet ingress reject rule answer a packet with a bad L4 checksum
with an ICMP/ICMPv6 unreachable or a TCP RST? The same packet would get no
reply at PRE_ROUTING, or at netdev ingress (NF_NETDEV_INGRESS has the same
value as NF_INET_PRE_ROUTING).

Adding NF_INET_INGRESS to that hook list may not be enough on its own. At
ingress, skb->len can still include link-layer trailer padding, which
ip_rcv_core()/ip6_rcv_core() would normally trim.

This came in with commit 117ca1f8920c ("netfilter: nft_reject_inet: allow
to use reject from inet ingress").

> diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
> index 07cdaa10da0d..5e08d8529cc8 100644
> --- a/net/ipv6/netfilter/nf_reject_ipv6.c
> +++ b/net/ipv6/netfilter/nf_reject_ipv6.c
> @@ -444,6 +444,11 @@ void nf_send_unreach6(struct net *net, struct sk_buff *skb_in,
>  	if (hooknum == NF_INET_LOCAL_OUT && skb_in->dev == NULL)
>  		skb_in->dev = net->loopback_dev;
>  
> +	if (hooknum == NF_INET_INGRESS) {
> +		memset(IP6CB(skb_in), 0, sizeof(*IP6CB(skb_in)));
> +		IP6CB(skb_in)->iif = skb_in->skb_iif;
> +	}

[Severity: Medium]
The commit message says this matches ip6_rcv_core(). Does that hold for
packets looped back through lo? ip6_rcv_core() chooses iif based on the
dst:

	IP6CB(skb)->iif = skb_valid_dst(skb) ?
				ip6_dst_idev(skb_dst(skb))->dev->ifindex :
				dev->ifindex;

Its comment explains that a locally generated packet sent to a local
address on ethX arrives through lo. For scoping, though, it has to be
treated as arriving on ethX.

loopback_xmit() keeps the dst with skb_dst_force(). Then
__netif_receive_skb_core() sets skb->skb_iif to lo's ifindex before
nf_ingress() runs. For an inet ingress reject rule on lo, this code sets
iif to lo, while ip6_rcv_core() would use the dst's interface.

icmp6_send() uses parm->iif to pick the source address, through
dev_get_by_index() and ipv6_dev_get_saddr(). It also passes parm->iif to
icmp6_ext_append() for the RFC 5837 interface information.

Can the resulting ICMPv6 error get the wrong source address, or report lo
as the incoming interface?

nf_reject6_fill_skb_dst() runs after this block, so the original dst is
still attached here. Would something like this be closer to
ip6_rcv_core()?

	IP6CB(skb_in)->iif = skb_valid_dst(skb_in) ?
		ip6_dst_idev(skb_dst(skb_in))->dev->ifindex :
		skb_in->skb_iif;

> +
>  	if (!skb_valid_dst(skb_in) && nf_reject6_fill_skb_dst(skb_in) < 0)
>  		return;

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261019150249.1879516-2-pablo%40netfilter.org
