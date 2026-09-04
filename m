Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1431F37E5D6;
	Fri,  4 Sep 2026 02:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788487311; cv=none; b=XW5coaOBQxPUFAYG78imXkxCb0UCc46u1qpfZsyxeqSBdxxWCRsaz7VkH0qGNSCckJUstXEXCVLWwclEqK3c6TdhN6mo4SjOtkHpKhTtNyQKcCmmAQ1rDGLi1Ov0BbMWQzHYKtVe+zNIuKJCwO32HPqtS7uO0p8kGdMO8L0UD4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788487311; c=relaxed/simple;
	bh=Pnqi3vdJlLfP+DBJKG+BCY+PHnGPcPuSaJ51aaVp0Lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ldJueXdda+8CySfnDQSiSozqlaYIA3TR3FUraeDcEjl/CttwbF93vq3FYyr+N777+VOO8hm5BDFNFwze4vou9ETfSCOs/GmkCjQftFkWQSKYSXmCceUs5eiO2QfwPHiL2EmjlRRRLumZ3Domwkp38PYc/sES7csmtHJiX6kecFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mnMH79aC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mnMH79aC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772CB1F00A3D;
	Fri,  4 Sep 2026 02:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788487309;
	bh=claOqgXATEZ54h/TRFqscxDfWqA4miXj+3iH9Qamd3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mnMH79aCf3ZQ/V+bnCFkXBkMQSAPTbJ1KecAZwtn5L6brKnD9zfepyFsFoHGXKFdB
	 hAorqVOyFdOscce8a0sUbsumlas6qIIGucJkYBAajc6wjnCj6N5DX3KdkMKIJ7TaUg
	 1sWMM/hD7+yR+lKIAkI9gxKx3eVfQ/DKHOEEGyhfGGLTmoW8MLHyJzVmXT1I1LbxRI
	 /xjD+FlfCWs25yfBVhY0oVapcKbfRc2NDskjzC82IUN6PV+7jCgalVnC3mZmnmn/S6
	 tyWWA3v4tMCXSDdd81KQbnyI3tkOGhGNj59sCyfVn3PzKjJ3VdSFj92FIceImeMR5c
	 U1i9gmjWvnlkw==
From: Jakub Kicinski <kuba@kernel.org>
To: pablo@netfilter.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	netfilter-devel@vger.kernel.org,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: Re: [PATCH net 07/12] netfilter: nft_payload: restrict checksum offsets to known values
Date: Thu,  3 Sep 2026 19:01:48 -0700
Message-ID: <20260904020148.3549914-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903004149.1037028-8-pablo@netfilter.org>
References: <20260903004149.1037028-8-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
netfilter: nft_payload: restrict checksum offsets to known values

This restricts the NFT_PAYLOAD_CSUM_INET checksum offset for transport
header writes, both at rule load time in
nft_payload_validate_inet_csum_offset() and at packet time via the new
nft_payload_csum_th_write_ok() helper.  Previously the transport header
case accepted any csum_offset.

> diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
> index e315d35f73d4..70f70a65e327 100644
> --- a/net/netfilter/nft_payload.c
> +++ b/net/netfilter/nft_payload.c
> @@ -1008,11 +1008,13 @@ static bool nft_payload_validate_inet_csum_offset(const struct nft_ctx *ctx,
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
> +		    priv->csum_offset == offsetof(struct icmp6hdr, icmp6_cksum))
> +			return true;
> +
> +		return false;
>  	case NFT_PAYLOAD_INNER_HEADER:
>  		return true;
>  	case NFT_PAYLOAD_TUN_HEADER:
> @@ -1046,6 +1048,25 @@ static bool nft_payload_csum_nh_write_ok(const struct nft_payload_set *priv,
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
> +	}
> +
> +	return false;
> +}

[Severity: High]
Should nft_payload_csum_th_write_ok() also handle IPPROTO_ICMP?  There is
no arm for it, and neither IPPROTO_ICMP nor struct icmphdr appear anywhere
in nft_payload.c (linux/icmp.h is not included), so pkt->tprot ==
IPPROTO_ICMP falls out of the switch and returns false.

At the same time the load time check above accepts csum_offset == 2,
because the two checksum fields sit at the same offset:

include/uapi/linux/icmp.h:
struct icmphdr {
  __u8		type;
  __u8		code;
  __sum16	checksum;
  ...

So a rule such as:

    nft add rule ip filter output icmp id set 1

still loads without error, but at packet time the checksum fixup is
skipped.  In nft_payload_set_eval() the helper is only the middle operand
of an && chain, so a false return does not reach the err label:

	if (priv->csum_type == NFT_PAYLOAD_CSUM_INET &&
	    nft_payload_csum_write_ok(pkt, priv) &&
	    nft_payload_csum_inet(skb, src, fsum, tsum, csum_offset))
		goto err;
	...
	if (skb_ensure_writable(skb, max(offset + priv->len, 0)) ||
	    skb_store_bits(skb, offset, src, priv->len) < 0)
		goto err;

Does this mean the ICMPv4 header bytes are still rewritten by
skb_store_bits() while the old checksum is left in place, so such packets
go out with a stale checksum?  Before this patch the
NFT_PAYLOAD_TRANSPORT_HEADER case of nft_payload_csum_write_ok() returned
true unconditionally, so previously working ICMPv4 mangling rules would
change behaviour here.

The accepted protocol list looks like the one in
nft_payload_l4csum_offset(), which serves the csum_flags pseudo-header
path and therefore has a reason to omit ICMPv4.  Is that the right list to
reuse for the NFT_PAYLOAD_CSUM_INET path?

Two things that may be worth considering: adding

	case IPPROTO_ICMP:
		return priv->csum_offset == offsetof(struct icmphdr, checksum);

to nft_payload_csum_th_write_ok(), and making the run time refusal set
NFT_BREAK rather than silently skipping the checksum update, so load time
and run time agree.

> @@ -1055,9 +1076,10 @@ static bool nft_payload_csum_write_ok(const struct nft_pktinfo *pkt,
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
>  		return true;
>  	case NFT_PAYLOAD_TUN_HEADER:

[ ... ]
