Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792510594;
	b=RYm5WhlWPX0KDRZTBDTm6DcFl1PTkTsqBe1SdhcUZQnpEmyL5gpa8FPEu3N3vbuyFKjF
	 TpiUql1Ayqbjc/Za9SZ10+dTBYkgj0XFnDMwjEcU8nD/uzQDS//cBkpwNtyXGNhD6cTGb
	 rCe67Fuc1eB2yfz+6t6zLOKJ3BBBZef/4m0zL3oN3CAIA7kAP7cEcS2Oq4AujeyGG0Mph
	 UE+I0py7a0GNJhrNhIekvMnXzYvG/scJ0aGeLRxvEvvbdMdD3TYOD9Ui2ylpF3M22Rp2H
	 4Gz7MCU8u5WnEbPszm69U5quVEobXMQcz80tFouPyxHXzMdxJns7kfQDKcKbfAw5r4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792510594;
	h=Received:Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 X-sashiko-severity:Content-Type:Content-Transfer-Encoding:
	 MIME-Version;
	bh=XSRILqeZVx2v4CdC8teAY95irYrnX+/DtJBtjp67C+U=;
	b=Jbu+OLwIVHM3locZOZgFuZNXK/E6sDjCZN53bCUfaKbOR/nXZvl0MWgv0+5RRleGOUs2
	 9in91y49uATKnnQqLHgxYX5mpYiNVPCMIZjTBBFu+RY5s8sgn332ut0LqxiyFN1iYCMDg
	 8eFy8oZu9JfAQhJWcy2wLmm89vpgi85TD/rNwXz9hmstvyn5VxrFrO1izxot3pBdN3F9O
	 35GXDZgYnkVD8X6dh3KBuqhgtOIR4D0lKQJ8SX7g2d449IXhqIaeAdHtYgqastwpI0MHN
	 fqVf29u0Ca+zGTVJYHq37JeK8ywsqtSUgA+t4ULXoEJmVlZJn3EsCwpUzm6fMRBZ2Bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BC4606A31E;
	Tue, 20 Oct 2026 15:36:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF4B1F000C4;
	Tue, 20 Oct 2026 15:36:32 +0000 (UTC)
Subject: Re: [PATCH net 02/10] netfilter: nft_payload: restrict checksum
 offsets to known values
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 20 Oct 2026 15:36:19 +0000
Message-ID: <179251057949.3135.6446993715432752338@kernel.org>
In-Reply-To: <20261019150249.1879516-3-pablo@netfilter.org>
References: <20261019150249.1879516-3-pablo@netfilter.org>
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

- [Medium] Undisclosed regression: the new per-protocol allow-list in
  nft_payload_csum_th_write_ok() (net/netfilter/nft_payload.c:1053-1072)…
- [Low] Inaccurate comment: the patch changed the comment for
  NFT_PAYLOAD_INNER_HEADER in nft_payload_csum_write_ok()…

--

netfilter: nft_payload: restrict checksum offsets to known values

This commit restricts the L4 checksum offset used by nft_payload set
expressions with NFT_PAYLOAD_CSUM_INET to the TCP, UDP, ICMP and ICMPv6
checksum locations. The check runs at rule load in
nft_payload_validate_inet_csum_offset() and per protocol at run time in
the new nft_payload_csum_th_write_ok(). The aim is to close a side channel
where a checksum delta could corrupt fields such as tcp->doff after
conntrack has validated the headers.

> diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
> index e315d35f73d4..5b76af68b704 100644
> --- a/net/netfilter/nft_payload.c
> +++ b/net/netfilter/nft_payload.c

[ ... ]

> @@ -1008,11 +1009,14 @@ static bool nft_payload_validate_inet_csum_offset(const struct nft_ctx *ctx,
>  		if (priv->csum_flags) /* makes no sense, asks for "re-update" of L4 checksum */
>  			return false;
>  
> -		/* no further check here; offset can't be negative so bogus
> -		 * offsets can corrupt L4 or payload but not l3 headers.
> -		 * We already allow arbitrary l4/inner payload writes.
> -		 */
> -		return true;
> +		/* Validate csum_offset is one of the supported transport header checksums */
> +		if (priv->csum_offset == offsetof(struct tcphdr, check) ||
> +		    priv->csum_offset == offsetof(struct udphdr, check) ||
> +		    priv->csum_offset == offsetof(struct icmphdr, checksum) ||
> +		    priv->csum_offset == offsetof(struct icmp6hdr, icmp6_cksum))
> +			return true;
> +
> +		return false;
>  	case NFT_PAYLOAD_INNER_HEADER:
>  		return true;
>  	case NFT_PAYLOAD_TUN_HEADER:
> @@ -1046,6 +1050,27 @@ static bool nft_payload_csum_nh_write_ok(const struct nft_payload_set *priv,
>  	return false;
>  }
>  
> +static bool nft_payload_csum_th_write_ok(const struct nft_payload_set *priv,
> +					 const struct nft_pktinfo *pkt)
> +{
> +	if (!(pkt->flags & NFT_PKTINFO_L4PROTO))
> +		return false;
> +
> +	switch (pkt->tprot) {
> +	case IPPROTO_TCP:
> +		return priv->csum_offset == offsetof(struct tcphdr, check);
> +	case IPPROTO_UDP:
> +	case IPPROTO_UDPLITE:
> +		return priv->csum_offset == offsetof(struct udphdr, check);
> +	case IPPROTO_ICMPV6:
> +		return priv->csum_offset == offsetof(struct icmp6hdr, icmp6_cksum);
> +	case IPPROTO_ICMP:
> +		return priv->csum_offset == offsetof(struct icmphdr, checksum);
> +	}
> +
> +	return false;
> +}

[Severity: Medium]
Does this turn off the checksum fixup for every transport protocol except
TCP, UDP/UDPLITE, ICMP and ICMPv6, while still doing the payload write?

Before this patch, NFT_PAYLOAD_TRANSPORT_HEADER fell through to the
INNER_HEADER case and returned true. Now an IGMP packet (csum at offset 2)
or a DCCP packet (dccph_checksum at offset 6) hits the final return false
here.

Those rules still load, because the check in
nft_payload_validate_inet_csum_offset() does not know the protocol and
offsets 2 and 6 are both in its allowed set.

At run time nft_th_write_ok() lets the write through because tprot is not
IPPROTO_TCP. nft_payload_set_eval() then does:

	if (priv->csum_type == NFT_PAYLOAD_CSUM_INET &&
	    nft_payload_csum_write_ok(pkt, priv) &&
	    nft_payload_csum_inet(skb, src, fsum, tsum, csum_offset))
		goto err;
	...
	if (skb_ensure_writable(skb, max(offset + priv->len, 0)) ||
	    skb_store_bits(skb, offset, src, priv->len) < 0)
		goto err;

When nft_payload_csum_write_ok() returns false, only the checksum update is
skipped. The header bytes are still rewritten, so the packet leaves with a
stale checksum. nftables appears to emit CSUM_INET with offset 2 for
"igmp ... set" rules.

There is also a load-time change. A TRANSPORT_HEADER rule with any other
csum_offset, such as GRE's checksum at offset 4, used to load and now fails
with -EINVAL.

The commit message does not mention either change, and the Fixes tag means
the patch will go to stable.

nft_th_write_ok() already allows arbitrary direct writes to every non-TCP
transport header:

	if (pkt->tprot != IPPROTO_TCP)
		return true;

Would it be enough to pin csum_offset to offsetof(struct tcphdr, check)
only when tprot is IPPROTO_TCP? Another option is to return NFT_BREAK when
the fixup is refused, so the write is not stored without a checksum update.

> +
>  static bool nft_payload_csum_write_ok(const struct nft_pktinfo *pkt,
>  				      const struct nft_payload_set *priv)
>  {
> @@ -1055,9 +1080,10 @@ static bool nft_payload_csum_write_ok(const struct nft_pktinfo *pkt,
>  	case NFT_PAYLOAD_NETWORK_HEADER:
>  		return nft_payload_csum_nh_write_ok(priv, pkt);
>  	case NFT_PAYLOAD_TRANSPORT_HEADER:
> +		return nft_payload_csum_th_write_ok(priv, pkt);
>  	case NFT_PAYLOAD_INNER_HEADER:
> -		/* neither offsets are validated, offsets cannot be
> -		 * negative so real l3 headers cannot be mangled.
> +		/* offset is not validated, offset cannot be
> +		 * negative so real l3/l4 headers cannot be mangled.
>  		 */

[Severity: Low]
Is the added "l4" in this comment accurate? For TCP,
__nft_payload_inner_offset() computes:

	pkt->inneroff = thoff + __tcp_hdrlen(th);

__tcp_hdrlen() returns th->doff * 4 and nothing checks that doff >= 5. On
a malformed TCP packet with doff < 5, inneroff falls inside the fixed
20-byte TCP header. An unvalidated csum_offset can then reach real L4
fields, including doff.

For IPPROTO_IPIP, inneroff is set to thoff, so the inner base is the same
as the transport header base.

Conntrack's tcp_error() already treats such packets as invalid, and
INNER_HEADER writes are unrestricted anyway, so behaviour does not change.
The comment does claim more than the code guarantees, though.

Could it keep the original "l3" wording, or say that it assumes a
well-formed packet?

>  		return true;
>  	case NFT_PAYLOAD_TUN_HEADER:

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261019150249.1879516-2-pablo%40netfilter.org
