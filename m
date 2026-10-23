Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792746247;
	b=IV+zXndMioVcEejX6eZDWSuZldauXIymh7U2rOEcAWtiZAwhEPtqgRghpB/Q2jd/Bv/t
	 p7hwTLwZ3cUBt5jctAz4vt+xgCRe2Nnr49aMZ8SBReUbOmKJ3oF71K9HjOG0u7xIfFFp2
	 zplUYRuYu7iLzMu4H4shpXGC+hiHYK4io7w7GMn/ojsT94Sg0E2uHzgGYWkIckohz9gPX
	 WAm3ogaqpIXDSxUS2uuapJZDpNHloanyvj2lEsfZBMAeJUadyKfCjNw3Y1NzBx0LFabYo
	 wwSyaKmsc0M6w3HVC0qwZya/NlE/CCz+Yg0faVfrt6Q6GNs481v0xlkmWDRTeFpsq4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792746247;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=hz1aS6k9JYTIHkVB4fRMXL70ayAGOm4KjPKMJxbKxoA=;
	b=JolpTT3VTsp7Dh7hB5rYiH3FNq+5u1l6Z9XLZuTmisA+Id/d5AvkZYeFCnmmSC7cIPhv
	 YfvxA+jUSjI1ebxP9ZkV0KVgtAsBs0EAzjkl/u8VJpOCW11Ff6voxdfv7lZuC0wHDE/oy
	 hITF/6lJMpX2CxXH3LwQvJVHFIHc8JegG2mLMWE4YIliQkyX7X5KiGg21S3MEhp5pj1dY
	 ZOxFMje146x4Ovn3u8XNCo/vmvCrf04jT8uoAXc6heUiKPallRHDjy/h3mQqO3D/TnPwJ
	 wn72MxWhCL2FpzCt9DlNRJGCqweZbtUNTFK5405itJPD5+YiPR4HiRIQ7k+tNLLJ4TQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IO8VGDk7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F418606A325;
	Fri, 23 Oct 2026 09:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IO8VGDk7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A3EB1F01825;
	Fri, 23 Oct 2026 09:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792746246;
	bh=hz1aS6k9JYTIHkVB4fRMXL70ayAGOm4KjPKMJxbKxoA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=IO8VGDk7iqV49THZhE395BZDd0Dw0uBL2CUzMpxwWxpL6SfiisurgC5jq2w72H+Bt
	 MdoF+AeEG6lTfVp2Ky6uyi0/ABBohzd5zGhZgbbEZC3uYo+KqnctKqxS6/iJn59Zgv
	 vIaA9sAS5+mZasinB7xHWE11eKCu77q6xso+sn/nny17lXBiYfWNlmxWqOj8jmWCNk
	 c+JO41eyt+hOqCNTcJumemvhQnpPeqXhKBf1A8SKP87h24RD1giNfZDsofKfXW3hvR
	 vrYaBODrIoz4sQ2fnvvw8FQliBnbE6ENMx9q2guH9NzygNfzHmDGcSvKk0D7/DvkCx
	 djZSSaxIFRGFA==
Subject: Re: [PATCH 1/2] netfilter: bridge: refragment packets with a vlan tag
 moved by the bridge
From: netdev-bot+sashiko@kernel.org
To: laveeshb@laveeshbansal.com
Cc: pablo@netfilter.org, fw@strlen.de, razor@blackwall.org, idosch@nvidia.com,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 bridge@lists.linux.dev, netdev@vger.kernel.org, kuba@kernel.org
Date: Fri, 23 Oct 2026 09:04:05 +0000
Message-ID: <179274624590.3134.14861783086322416790@kernel.org>
In-Reply-To: <20261020005403.38212-1-laveeshb@laveeshbansal.com>
References: <20261020005403.38212-1-laveeshb@laveeshbansal.com>
X-sashiko-severity: Low
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

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The comment above nf_ct_bridge_frag_restore()
  (net/bridge/netfilter/nf_conntrack_bridge.c:396), "Actually only slow…

--

netfilter: bridge: refragment packets with a vlan tag moved by the bridge

With this patch, nf_ct_bridge_refrag() looks past a vlan tag that
br_allowed_ingress() moved into the packet after prerouting
defragmentation. It saves the tag, pulls it off, fragments the inner
IPv4 or IPv6 packet, and then pushes the tag back onto each fragment in
nf_ct_bridge_frag_restore() together with the outer protocol.

Closes: https://syzkaller.appspot.com/bug?extid=a8ba738fe2db6b4bb27f

> diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
> index b5444335b86f..e16071eb2df0 100644
> --- a/net/bridge/netfilter/nf_conntrack_bridge.c
> +++ b/net/bridge/netfilter/nf_conntrack_bridge.c

[ ... ]

> +		proto = data.inband_vlan_encap_proto;
> +		__skb_pull(skb, VLAN_HLEN);
> +		skb->protocol = proto;

[ ... ]

> @@ -371,11 +399,18 @@ static int nf_ct_bridge_frag_restore(struct sk_buff *skb,
>  {
>  	int err;
>  
> -	err = skb_cow_head(skb, ETH_HLEN);
> +	err = skb_cow_head(skb, ETH_HLEN + (data->inband_vlan_present ? VLAN_HLEN : 0));
>  	if (err) {
>  		kfree_skb(skb);
>  		return -ENOMEM;
>  	}
> +	if (data->inband_vlan_present) {
> +		struct vlan_hdr *vhdr = skb_push(skb, VLAN_HLEN);
> +
> +		vhdr->h_vlan_TCI = htons(data->inband_vlan_tci);
> +		vhdr->h_vlan_encapsulated_proto = data->inband_vlan_encap_proto;
> +		skb->protocol = data->inband_vlan_proto;
> +	}

[Severity: Low]
This isn't a bug, but the comment above nf_ct_bridge_frag_restore()
hasn't been changed and still says:

/* Actually only slow path refragmentation needs this. */

Now that nf_ct_bridge_refrag() pulls the vlan header and sets
skb->protocol to the inner ethertype before it picks the fast or slow
path, nf_ct_bridge_frag_restore() is the only code that pushes the
header back.

The frag_list fast paths also reach this function. nf_br_ip_fragment()
and br_ip6_fragment() call output() for the head skb and for each
fraglist member, and that leads to:

output()
  nf_ct_bridge_refrag_post()
    nf_ct_bridge_frag_restore()

Suppose a later change skipped the restore on the fast path, as the
comment suggests is fine. The head fragment would then go out without
its vlan header. data->mac would still hold the vlan TPID, and
skb->protocol would be IP or IPv6.

The comment was arguably wrong even before this patch, because
fraglist members also need the MAC copy and the hwaccel tag. Since the
fast path now depends on the vlan restore as well, could the comment be
updated or removed?

> 	if (data->vlan_present)
> 		__vlan_hwaccel_put_tag(skb, data->vlan_proto, data->vlan_tci);
> 	else if (skb_vlan_tag_present(skb))

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261020000308.37362-1-laveeshb%40laveeshbansal.com
