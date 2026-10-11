Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7830B45FFD3;
	Sun, 11 Oct 2026 22:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791756157; cv=none; b=WE82+DoRyCWPZUJ1PZB9BPtCvfvR9odxGvVlh9RegGLD52zF/Xs5bPoxJ2orSF5Bo+DjCsac68HmVsjuIcQhdbHl4A8hVSjZ6HWBeVJYeU3d96rplSeaeAH16txuWLbjN5ACXb636HKnvKgb0b5Z1ZIQzVWvr4HeEsqsKHh/kRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791756157; c=relaxed/simple;
	bh=nr/9dyWwQ8/7rDus24i2sml5MK/WWaozn8G6uswlxGc=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bC3hqA0cvPlmnDhllMey+TV/0/+LCdeOqOa2S4y4qNPtZ/cncTWoOcn2U7mSlq0xX7kVDlC9yxZYxPwbZmxb1VOIWiW+jHBY1rS8OignW5Zz/hFTp2WN/UQMDl5CuuouVZ5Ssg7VfCPVGarwFuTYxdZWVIl0IHTlR2q1xTaQoUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EGk0D/A2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EGk0D/A2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A9541F0089C;
	Sun, 11 Oct 2026 22:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791756156;
	bh=iVwZC1zpaojyreCpC1U9ymCY1AzhHbrEKn75qtJ80T4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=EGk0D/A2N5BvsTUXUCE+9ktn0CUc9Tw/PwOfsvHiu76L2/u0Etv82rrCMM3/gRy10
	 GesSkjo4v1GcrGMVa4L7+Ri2fnuwPlqWuf1e9tQwCTLKyejggpedlnjrA31B1qYd2k
	 uhR8N876g67gavywKUli8/EsRoOuSejg0SG3tfi5ACEbq78m7X5TMOI/Oz/j0Y9I0p
	 foaUU7d74RkUTGiMvQpT2PkEmj7uuJLTq1SroaDQKx3SkjTd0VLaXNcaH/mkDp0Fui
	 3RAQdSYVbVprNkWzGvci0uMZ412ZMhKGUHOpPAyz3bJd8QJpUgE91ukNqBQzM4Q8oW
	 6ty0giaNt/Vag==
Subject:
 Re: [PATCH net] ipv4: validate checksum_start before completing checksum
From: netdev-bot+sashiko@kernel.org
To: mst@redhat.com
Cc: linux-kernel@vger.kernel.org, dsahern@kernel.org, idosch@nvidia.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 razor@blackwall.org, steffen.klassert@secunet.com,
 herbert@gondor.apana.org.au, willemdebruijn.kernel@gmail.com,
 netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, bridge@lists.linux.dev
Date: Sun, 11 Oct 2026 22:02:34 +0000
Message-ID: <179175615475.434549.9706462488069659983@kernel.org>
In-Reply-To:
 <0a012b4923e189c4c593ef4f471e5ff0edbe9030.1791412497.git.mst@redhat.com>
References:
 <0a012b4923e189c4c593ef4f471e5ff0edbe9030.1791412497.git.mst@redhat.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 5 potential
issue(s) to consider.

Critical: 0 · High: 2 · Medium: 2 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The patch checks only IPv4, including inside shared code it
  edits, and leaves IPv6 open to the same untrusted csum_start.
- [High] The patch does not guard the most commonly reached checksum
  completion on egress.
- [Medium] IP-TFS SAs skip the new xfrm check entirely.
- [Medium] The NFQUEUE check in nf_queue_checksum_help() keys on the
  outer skb->protocol (`entskb->protocol == htons(ETH_P_IP)`), so PPPoE-…
- [Low] ip_check_csum_start() takes its lower bound from the untrusted
  iph->ihl field (`skb->network_header + ip_hdrlen(skb)`, with…

--

ipv4: validate checksum_start before completing checksum

The patch adds an ip_check_csum_start() helper. It rejects CHECKSUM_PARTIAL
skbs whose csum_start points inside the IPv4 header. The helper runs before
skb_checksum_help() in ip_do_fragment(), nf_br_ip_fragment(),
nf_queue_checksum_help(), the CHECKSUM target and xfrm_output(), as a
defence in depth measure against bad checksum metadata coming from tun and
packet sockets.

Closes: https://lore.kernel.org/netdev/20260922030310.8684-2-habte.yibelo@gmail.com/

> diff --git a/include/net/ip.h b/include/net/ip.h
> index 6f602df72ee62..d07c2c5730240 100644
> --- a/include/net/ip.h
> +++ b/include/net/ip.h
> @@ -74,6 +74,13 @@ static inline unsigned int ip_hdrlen(const struct sk_buff *skb)
>  	return ip_hdr(skb)->ihl * 4;
>  }
>  
> +static inline int ip_check_csum_start(const struct sk_buff *skb)
> +{
> +	if (unlikely(skb->csum_start < skb->network_header + ip_hdrlen(skb)))
> +		return -EINVAL;

[Severity: Low]
The lower bound here comes from iph->ihl, and not every caller validates
that field first. If ihl is below 5, can a csum_start inside the fixed
20-byte IPv4 header still pass? With ihl == 0 the check becomes
csum_start < network_header.

One caller that can see an unvalidated ihl is nf_queue_checksum_help(),
which only pulls sizeof(struct iphdr). For a bridge-family nft queue rule,
nft_do_chain_bridge() calls nft_set_pktinfo_ipv4_validate(). That function
treats ihl < 5 as unspec, but the chain is still evaluated:

tap frame with ihl = 0, csum_start = IP + 6..19
  nft_do_chain_bridge()
    nft_set_pktinfo_ipv4_validate()   -> falls back to unspec
  queue verdict
    nfqnl_build_packet_message()
      nf_queue_checksum_help()
        ip_check_csum_start()         -> returns 0
        skb_checksum_help()           -> writes into IP header bytes 6..19

The header is already invalid in this case, so the practical impact looks
limited. Since this is a generic inline in include/net/ip.h, could the
bound be clamped to at least sizeof(struct iphdr), or could ihl < 5 be
rejected?

> +	return 0;
> +}
> +

[ ... ]

> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index a24cc8ee11d3e..eaa6fabda347e 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -771,9 +771,13 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
>  	int err = 0;
>  
>  	/* for offloaded checksums cleanup checksum before fragmentation */
> -	if (skb->ip_summed == CHECKSUM_PARTIAL &&
> -	    (err = skb_checksum_help(skb)))
> -		goto fail;
> +	if (skb->ip_summed == CHECKSUM_PARTIAL) {
> +		err = ip_check_csum_start(skb);
> +		if (!err)
> +			err = skb_checksum_help(skb);
> +		if (err)
> +			goto fail;
> +	}

[Severity: High]
This covers the fragmentation path. What about the generic egress
fallback? validate_xmit_skb()->skb_csum_hwoffload_help() finishes the
checksum in software without any csum_start check:

net/core/dev.c:skb_csum_hwoffload_help() {
    ...
	if (features & NETIF_F_HW_CSUM)
		return 0;

	if (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) {
		if (skb_has_ipv6_extension_hdr(skb))
			goto sw_checksum;

		switch (skb->csum_offset) {
		case offsetof(struct tcphdr, check):
		case offsetof(struct udphdr, check):
			return 0;
		}
	}

sw_checksum:
	return skb_checksum_help(skb);
}

Any device without NETIF_F_HW_CSUM takes this path. NETIF_F_IP_CSUM
devices take it too whenever csum_offset is not the TCP or UDP check
offset. The sender picks csum_offset, so it can force the software path.

__virtio_net_hdr_to_skb() accepts csum_start >= skb->data + 20, which is
IP + 6 on tap. Take a forwarded IPv4 packet with csum_start at IP + 12. It
can pass through ip_rcv(), ip_forward(), FORWARD and POSTROUTING
(including SNAT) with CHECKSUM_PARTIAL intact. Could its saddr, daddr or
protocol then be overwritten here, at the last step?

Other places that finish checksums on arbitrary IPv4 traffic also have no
check. Examples are netem_enqueue() in sch_netem.c, the DSA taggers
(tag_ksz.c, tag_ocelot_8021q.c, tag_rtl8_4.c, tag_hellcreek.c) and
xfrm_iptfs.c.

The commit message says:

  let's also check before we complete the checksum.

Is it intended that the most common completion site is left out? Or is
this meant to be covered by the input validation the commit message
describes as forthcoming?

[ ... ]

> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index a3bc002800510..477fc632657f4 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c

[ ... ]

> @@ -674,6 +675,12 @@ static int nfqnl_put_bridge(struct nf_queue_entry *entry, struct sk_buff *skb)
>  
>  static int nf_queue_checksum_help(struct sk_buff *entskb)
>  {
> +	if (entskb->protocol == htons(ETH_P_IP)) {

[Severity: Medium]
This test uses the outer skb->protocol. Can PPPoE-encapsulated IPv4 on a
bridge skip the check?

With br_netfilter and filter_pppoe_tagged enabled, br_nf_forward_ip()
pulls the encapsulation and runs br_validate_ipv4() and the IPv4 FORWARD
hooks. br_nf_forward_finish() then restores the outer protocol before the
bridge FORWARD hooks continue:

net/bridge/br_netfilter_hooks.c:br_nf_forward_finish() {
    ...
		nf_bridge_update_protocol(skb);
	} else {
		in = *((struct net_device **)(skb->cb));
	}
	nf_bridge_push_encap_header(skb);
    ...
}

A later bridge-family nft queue rule (copy-packet, without
NFQA_CFG_F_GSO) would reach this function with protocol ETH_P_PPP_SES.
ip_check_csum_start() is skipped, and skb_checksum_help() then writes into
the inner IPv4 header that was already validated.

The inner IP header sits at mac + 22, and virtio allows csum_start
>= mac + 20, so the write can even hit version/ihl.

After an accept verdict, br_nf_post_routing() treats the packet as IPv4
again without revalidating it:

net/bridge/br_netfilter_hooks.c:br_nf_post_routing() {
    ...
	nf_bridge_pull_encap_header(skb);
	if (pf == NFPROTO_IPV4)
		skb->protocol = htons(ETH_P_IP);
    ...
}

NF_INET_POST_ROUTING (conntrack/NAT) and br_nf_dev_queue_xmit() then run
on the modified header.

> +		if (!pskb_network_may_pull(entskb, sizeof(struct iphdr)) ||
> +		    ip_check_csum_start(entskb))
> +			return -EINVAL;
> +	}
> +
>  	if (skb_csum_is_sctp(entskb))
>  		return skb_crc32c_csum_help(entskb);
>  
> diff --git a/net/netfilter/xt_CHECKSUM.c b/net/netfilter/xt_CHECKSUM.c
> index 9d99f5a3d1764..1fb0f8118404d 100644
> --- a/net/netfilter/xt_CHECKSUM.c
> +++ b/net/netfilter/xt_CHECKSUM.c

[ ... ]

> @@ -25,8 +26,11 @@ MODULE_ALIAS("ip6t_CHECKSUM");
>  static unsigned int
>  checksum_tg(struct sk_buff *skb, const struct xt_action_param *par)
>  {
> -	if (skb->ip_summed == CHECKSUM_PARTIAL && !skb_is_gso(skb))
> +	if (skb->ip_summed == CHECKSUM_PARTIAL && !skb_is_gso(skb)) {
> +		if (xt_family(par) == NFPROTO_IPV4 && ip_check_csum_start(skb))
> +			return NF_DROP;
>  		skb_checksum_help(skb);

[Severity: High]
checksum_tg() is also registered for NFPROTO_IPV6 in checksum_tg_reg[], so
ip6t_CHECKSUM still calls skb_checksum_help() with no check. Is IPv6 left
out on purpose?

The other shared paths in this patch work the same way.
nf_queue_checksum_help() and xfrm_output() only check
skb->protocol == htons(ETH_P_IP). The IPv6 versions of the two
fragmenters hardened here keep the old pattern:

net/ipv6/ip6_output.c:ip6_fragment() {
    ...
	if (skb->ip_summed == CHECKSUM_PARTIAL &&
	    (err = skb_checksum_help(skb)))
		goto fail;
    ...
}

net/ipv6/netfilter.c:br_ip6_fragment() {
    ...
	if (skb->ip_summed == CHECKSUM_PARTIAL &&
	    (err = skb_checksum_help(skb)))
		goto blackhole;
    ...
}

Both commits named in Fixes: also send IPv6 through
__virtio_net_hdr_to_skb(). For non-GSO packets, nh_min_len stays at
sizeof(struct iphdr), so csum_start can point inside the 40-byte IPv6
header.

Even in IFF_TUN mode, csum_start = IP + 20 is accepted, which lets the
write land in daddr. With tap, nexthdr, hop_limit, saddr and daddr can
all be reached.

Couldn't this rewrite an IPv6 header after ipv6_rcv() validation, routing
and ip6tables/nft filtering, through ip6t_CHECKSUM, NFQUEUE reinjection or
xfrm output? The commit message doesn't mention IPv6. Could both families
be covered here, or could the commit message explain why IPv6 is left out?

> +	}
>  
>  	return XT_CONTINUE;
>  }
> diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
> index e305ba32e356b..f1f612cd7b438 100644
> --- a/net/xfrm/xfrm_output.c
> +++ b/net/xfrm/xfrm_output.c
> @@ -823,16 +823,22 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
>  	}
>  
>  	if (skb->ip_summed == CHECKSUM_PARTIAL) {
> -		err = skb_checksum_help(skb);
> -		if (err) {
> -			XFRM_INC_STATS(net, LINUX_MIB_XFRMOUTERROR);
> -			kfree_skb(skb);
> -			return err;
> +		if (skb->protocol == htons(ETH_P_IP)) {
> +			err = ip_check_csum_start(skb);
> +			if (err)
> +				goto error;
>  		}

[Severity: Medium]
Do IP-TFS SAs bypass this check? xfrm_bundle_create() sets:

	dst1->output = xfrm[i]->mode_cbs->output;

For IP-TFS this is iptfs_output_collect(), so inner IPv4 packets never
reach xfrm4_output()/xfrm_output() with their own checksum metadata.

iptfs_output_collect() only segments GSO skbs. A non-GSO CHECKSUM_PARTIAL
skb is queued as is, and its checksum is finished later without a
csum_start check:

net/xfrm/xfrm_iptfs.c:iptfs_first_skb() {
    ...
	if (skb->ip_summed == CHECKSUM_PARTIAL) {
		err = skb_checksum_help(skb);
		if (err)
			return err;
    ...
}

net/xfrm/xfrm_iptfs.c:iptfs_output_queued() {
    ...
			if (skb2->ip_summed == CHECKSUM_PARTIAL) {
				if (skb_checksum_help(skb2)) {
    ...
}

xfrm_output() only runs later, on the outer IP-TFS packet, which is
already CHECKSUM_NONE. Consider a tap guest packet routed into an IP-TFS
tunnel. Could its inner header still be rewritten after ip_rcv()
validation and FORWARD filtering, then encrypted and sent to the peer?

> +		err = skb_checksum_help(skb);
> +		if (err)
> +			goto error;
>  	}

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/0a012b4923e189c4c593ef4f471e5ff0edbe9030.1791412497.git.mst%40redhat.com
