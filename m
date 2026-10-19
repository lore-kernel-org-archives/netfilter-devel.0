Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01535331EA4;
	Mon, 19 Oct 2026 01:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792372888; cv=none; b=n854QsHOeGQkN1EU10FjVQCgjuTq4ccXNrCO3gUHyOlc2GZ0KbS2p8ufiLScvUqZD7mBBNRCZ4epe0ZIM3GLc3KKeIeuj+3Dmxa5abL7SDOy1BaDKnxDsXODVpFTa/w3tI70SmyBgIZmwJ47rGnpKi9ZFn1iCbovyIjUJpqg0YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792372888; c=relaxed/simple;
	bh=e5Xd58moRpR62FS9qqX0UaCpJl+wDgqlhat5GQpKhn0=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SUOlUNtNaMtcXCg0i2S9wINELKgE2MR1vnbYhlHyWM8w5UMjV6LE+zqe+ILOgQZ/N3ohIpxzGohSHIBdbd7aEdByLPkhA8zkRWwTgzoFRUXFNsvre/0O4YeVdT4d/wDAs7HNFDs/M/Q/oaAooSfFdYfW4yVPEwojnnVKl9uAn/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PKdpYMqX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PKdpYMqX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679161F000C4;
	Mon, 19 Oct 2026 01:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792372886;
	bh=U46645cs7EGJYldRql8QKV3YLk2/u49t8CLizs4sWTo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=PKdpYMqXt2P0P8IhxYJMXHVcJwazST7V7DQrNTh/V4TvCabqfrhJfoCAtzn5S/0fM
	 VECv83OJNTG7LiJtu2MbNkE+Q7Oi8mBQfz5mo4QCHahPXOKJ627YyejJar+HCuTa34
	 /8U0fMS50hrvrIx2GabuH7ZB3pCsA+O+qBeAsxWwDZQQkJA8iFAPes8mUtynwpWE8Z
	 HMtyODBimyruaFpkXquDRbV85jUkFv7/PC2/zETSqkF14pfIJB6q+VbPdztpYwM5TN
	 eOY8hBCLD01/2taI8+n4VM7dBgUDpFzA0NPVjvgzW53XFPKX6+lJV/pZ9d4ofQGC3T
	 jiwFKDBB9H1Sg==
Subject: Re: [PATCH net-next 09/15] netfilter: nft_exthdr: avoid 60 bytes
 stack buffer in TCP option mangling
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Mon, 19 Oct 2026 01:21:26 +0000
Message-ID: <179237288600.3135.15119152740392179853@kernel.org>
In-Reply-To: <20261018005638.1776148-10-pablo@netfilter.org>
References: <20261018005638.1776148-10-pablo@netfilter.org>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The commit message says "This patch also updates the logic to
  drop malformed packets, before this patch NFT_BREAK was used as a…

--

netfilter: nft_exthdr: avoid 60 bytes stack buffer in TCP option mangling

This commit changes nft_exthdr_tcp_set_eval() and
nft_exthdr_tcp_strip_eval() so they no longer call
nft_tcp_header_pointer(). Each function now reads only the 20 byte fixed
TCP header with skb_header_pointer(), validates doff, and leaves it to
skb_ensure_writable() to pull the options. This removes a 60 byte stack
buffer and a redundant second header copy from both functions.

> diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
> index 3492426dccf7f..861bab93f4352 100644
> --- a/net/netfilter/nft_exthdr.c
> +++ b/net/netfilter/nft_exthdr.c
> @@ -233,16 +233,23 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,

[ ... ]

> -	tcph = nft_tcp_header_pointer(pkt, sizeof(buff), buff, &tcphdr_len);
> +	if (pkt->tprot != IPPROTO_TCP || pkt->fragoff)
> +		goto err;
> +
> +	tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt), sizeof(_tcph), &_tcph);
>  	if (!tcph)
>  		goto err;
>  
> +	tcphdr_len = __tcp_hdrlen(tcph);
> +	if (tcphdr_len < sizeof(*tcph) ||
> +	    tcphdr_len > sizeof(*tcph) + MAX_TCP_OPTION_SPACE)
> +		goto err;
> +
>  	if (skb_ensure_writable(pkt->skb, nft_thoff(pkt) + tcphdr_len))
>  		goto err;
>  
> @@ -313,16 +320,23 @@ static void nft_exthdr_tcp_strip_eval(const struct nft_expr *expr,

[ ... ]

> -	tcph = nft_tcp_header_pointer(pkt, sizeof(buff), buff, &tcphdr_len);
> +	if (pkt->tprot != IPPROTO_TCP || pkt->fragoff)
> +		goto err;
> +
> +	tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt), sizeof(_tcph), &_tcph);
>  	if (!tcph)
>  		goto err;
>  
> +	tcphdr_len = __tcp_hdrlen(tcph);
> +	if (tcphdr_len < sizeof(*tcph) ||
> +	    tcphdr_len > sizeof(*tcph) + MAX_TCP_OPTION_SPACE)
> +		goto err;
> +
>  	if (skb_ensure_writable(pkt->skb, nft_thoff(pkt) + tcphdr_len))
>  		goto drop;

[Severity: Medium]

The commit message says:

  This patch also updates the logic to drop malformed packets, before this
  patch NFT_BREAK was used as a verdict instead.

Does that match what the diff does? The diff does not touch any verdict
code. The change in behaviour only comes from removing the second,
full-length skb_header_pointer() call that nft_tcp_header_pointer() made:

  return skb_header_pointer(pkt->skb, nft_thoff(pkt), *tcphdr_len, buffer);

Before this patch, a truncated TCP packet (thoff + doff * 4 > skb->len)
made that call return NULL. Both functions then took goto err and
returned NFT_BREAK.

With this patch the 20 byte read succeeds and the doff check passes. The
packet then fails in skb_ensure_writable()->pskb_may_pull(), and the
result differs per function:

  nft_exthdr_tcp_strip_eval(): goto drop -> NF_DROP (new)
  nft_exthdr_tcp_set_eval():   goto err  -> NFT_BREAK (unchanged)

A packet with doff < 5 still takes goto err and gets NFT_BREAK in both
functions.

As a result, a tcp option reset rule now drops a truncated packet, while
a tcp option ... set rule treats the same packet as a non-match.

Should the drop policy also cover nft_exthdr_tcp_set_eval() and the
doff < 5 case? If not, could the commit message say that the change only
affects truncated options in nft_exthdr_tcp_strip_eval()?

Separately, this isn't a bug, but the new upper bound check:

    tcphdr_len > sizeof(*tcph) + MAX_TCP_OPTION_SPACE

can never be true. doff is a 4 bit field, so tcphdr_len is at most 60.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261018005638.1776148-2-pablo%40netfilter.org
