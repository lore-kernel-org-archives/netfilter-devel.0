Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794626626;
	b=Bu0SF20aFJX5NaB2HBzgGbk1G3nJUCxO1HILNcChDybFoY6h96BCWuHy7Vx7AY25Pxbz
	 RVwCcr21FG/sSfovfDY2IUzVrT4umnjNaEknX+99M94mfTCHtasf4HtMxW7jNfq4BooSm
	 dm/8kUbocz4rREDrHU5fjbWtd5RY/p2/4Ghc3xiVYA/XcrKCnXhRia5IvCsOl4PPevYF1
	 JitRu18wEaHwpbtZSh0iBnBmT++jqxJ2zve6DVHtoP8a8qwx63E26cBOzF84ZNjXLK0OZ
	 VBoo4WuJ2Z5X4ORsWNcr1zlW/xiJZnSyEH8lagsLoxqK2wz6O3M1bJo1LvtzhBc5PoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794626626;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=BOZHaxpcpsJwtqYpgj7ylDSrS3tDSBJJRb8I8JDCWb8=;
	b=Wzurm3VvVzossEJI8kNJlnl05w2OxQYLKsbxA4jLh3uk+ICa94RGo+6ydny+AJdQV9qJ
	 B1dWduNiYXn3rNlk72o5EB60kRWYNUdc7bmIKh5QdYwOrFYfHxxcHXx+bQSbDxWF4Azk2
	 74CWPtk3sYwu4YQRELm1IIXRy8yE1anhZYFasjui5hKfLonjiHDK5CZwvRiLira/RjvIQ
	 bzMJrJ6t0Iytsdn0C5JIFt4LskMvRcaYreyFOkhDTk7aA14hHiJbKLKVj8Le28X4omlJ3
	 lshLYZMLKtZjRAxHw55Fdj0K/1GaW5B6LQiRXFHE94qnb85uuPdl5prcn3yO6ufZiyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AwYpKQio;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33E7606A8B1;
	Sat, 14 Nov 2026 03:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AwYpKQio
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC991F000C4;
	Sat, 14 Nov 2026 03:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794626626;
	bh=BOZHaxpcpsJwtqYpgj7ylDSrS3tDSBJJRb8I8JDCWb8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=AwYpKQiok9rZITNpYWLU9JrIvkJKFkhJVbTcbive8Kbox3rAVbtiwYn8buIjaPqLT
	 b7nD/XxKhy+75KXATJn0NexwvUIOepPcmABS6UrlzIgcyB2F0ydQVNUD9qeA3/xT4a
	 VZrBzwPCGpUeviD7x6IfSBv91iwONShvC/DH6DQKf5Tco5oGHDzXrpu1VdwanD8w78
	 emCI8FcD8KMQP0Ph2ABMTb3dyHd4L4W1zQkpyhDJ2KnFQjNV6lfZb2UAySOZ8O52Vr
	 po5G2cjKI4sX8n9d62wldCWu2KYV4jX9RfR9ONcW725zoYF09MbZnJNI6L5MfHQWi6
	 u3er5VzwsIq0w==
Subject: Re: [PATCH net-next 07/15] netfilter: nft_flow_offload: do not
 offload multicast
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Sat, 14 Nov 2026 03:23:45 +0000
Message-ID: <179462662560.2199510.13407170160389207306@kernel.org>
In-Reply-To: <20261113031251.2437074-8-pablo@netfilter.org>
References: <20261113031251.2437074-8-pablo@netfilter.org>
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

- [Low] The commit message of "netfilter: nft_flow_offload: do not
  offload multicast" describes a bug that users can see, but the patch…

--

netfilter: nft_flow_offload: do not offload multicast

This patch makes nft_flow_offload_skip() skip packets with a multicast
destination for both IPv4 and IPv6. The flowtable then no longer depends
on the ruleset or on the reverse route lookup to keep multicast flows
out.

> diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
> index d3c5651dd6997..530e20c7fd457 100644
> --- a/net/netfilter/nft_flow_offload.c
> +++ b/net/netfilter/nft_flow_offload.c

[ ... ]

> @@ -33,6 +34,10 @@ static bool nft_flow_offload_skip(struct sk_buff *skb, int family)
>  
>  		if (unlikely(opt->optlen))
>  			return true;
> +
> +		return ipv4_is_multicast(ip_hdr(skb)->daddr);
> +	} else if (family == NFPROTO_IPV6) {
> +		return ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr);

[Severity: Low]
The commit message describes a bug that users can see. IPv6 multicast
forwarded by ip6mr is added to the flowtable, and the flow keeps sending
to the output it resolved even after the last listener leaves. Should
this have a Fixes: tag, and maybe Cc: stable as well?

The path to the bug looks like this:

ip6mr_forward2()
  NF_HOOK(NFPROTO_IPV6, NF_INET_FORWARD, ...)
    nft_flow_offload_eval()
      nft_flow_route()
      flow_offload_add()

In nft_flow_route() in net/netfilter/nf_flow_table_path.c, the reverse
lookup does:

    fl.u.ip6.saddr = ct->tuplehash[!dir].tuple.src.u3.in6;

For a multicast flow in the original direction, that address is the
multicast group. On IPv4, ip_route_output_key_hash_rcu() returns -EINVAL
for a multicast saddr. The IPv6 output lookup has no such check, so
other_dst resolves and the flow is added.

NF_INET_FORWARD is the only hook nft_flow_offload_validate() accepts. A
ruleset with a plain 'flow add @ft' in a forward chain reaches this path
on current kernels.

Without a Fixes: tag, stable and distro backporters have nothing that
points them at this fix. Older kernels would likely keep sending IPv6
multicast to stale outputs.

>  	}
>  
>  	return false;

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261113031251.2437074-2-pablo%40netfilter.org
