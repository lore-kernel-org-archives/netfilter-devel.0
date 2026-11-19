Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795068025;
	b=Cu7JN0md1ucNIguS4y4FWUeHHR/vOgw6kulaJCv72E6aBDrj5jVTQHGM0EcG4xu1g+bw
	 XN+sJx2FHLieEmuNz8Kfm2Na7u/heA1EEjpLwWEZIy7k1GhM8qhKstDdBRBYApnlmel/C
	 vyQir4pRb2XuyDVTo8y704mt8UBAlNl5/ieF9PqGA8+292XSHbtfcSFuKzTlHsgwiRw0n
	 IDLiWKA17wG7s9IR17S4/2Sz/LPN27hey05s/TQFcBilsC57uZw1MqelWzfRkTFiuHgoT
	 OYCY+h/eEpJKgIdFgTfQofinSCcEI8tk8jVapf9x1+PXheFRxoDueZvnFO4PfCFm4PA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795068025;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=T3n37shyWOHLZaB8WszkZe/mlAqDBkE4KEay+1Bhaek=;
	b=Vu9f0cZSBpqVCY8RfmMkX3J5SjIOyAmZMD2V4CGjs+5XrP3jfjeWWjpuXJFz2/6HXt6A
	 2y/Uj0OhoP9L2QoM8LYt1nsqqf0kUydAqhSBEemPJTo+cGiWVRdYyYEwQBwgWpBznPiUo
	 heg+Anulx+06yLZIjsidvbNSO10I9eDh5rrvoMpL7UuGIZ8+6dNkz8wkXDaXV/7WY+2VP
	 CLayeo4hOgaoA7tQVUzbESffVmHDZwfBQhat2Wgq3eCB7xBn9CFwL24U20TmY9yeNsJII
	 lJWeVXX8N5e62CCiRT/8FejdI3PJFc9gg1tPD5DhkquDhXekcWAus2ahQ6MZZR/yo4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M8+9DZJx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F1460A2605;
	Thu, 19 Nov 2026 06:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M8+9DZJx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9091F000C4;
	Thu, 19 Nov 2026 06:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795068025;
	bh=T3n37shyWOHLZaB8WszkZe/mlAqDBkE4KEay+1Bhaek=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=M8+9DZJxBK5X7lhCAD1GwhslgNFKOo7YW2cZM9W0ZqGwqS6K3K2Rtm/w8HbmTiPDT
	 ocAsdsGF16R7/t2RAuJJGhiNCet29TQRH65mUCi0c1qTVM3e4FBFoCJOEh5RRlQeGY
	 v781i4hKOwjYle/TaDewbwhySTJl82/pUeQ3YJF7BWoegRze7dPAyhr/fy04W5Y/bt
	 GyLJHnSeTdUJQkjI0KGtVMnEhDCY3xGIl71ZfT++V16NybFMW6t/J9d5WGcz0GCCF3
	 /617VR6rKMyCo/pVHGUvG049YA/a66n9U06wXmmT8mmAfwtLCOk0dxsiMgzO5T+hce
	 eQ2WjdmzST6/Q==
Subject: Re: [PATCH net v2 2/2] net: unset the mac header of a pskb copy that
 points into headroom
From: netdev-bot+sashiko@kernel.org
To: theodorlarionov@gmail.com
Cc: davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, pablo@netfilter.org, fw@strlen.de,
 phil@nwl.cc, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org
Date: Thu, 19 Nov 2026 06:00:23 +0000
Message-ID: <179506802393.3136.3490105838474942994@kernel.org>
In-Reply-To: <20261117175835.745796-3-theodorlarionov@gmail.com>
References: <20261117175835.745796-3-theodorlarionov@gmail.com>
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] net: out-of-bounds read in nf_send_reset() after
  __pskb_copy_fclone()

--

> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -2278,6 +2278,8 @@ struct sk_buff *__pskb_copy_fclone(struct sk_buff *skb, int headroom,
>  	}
>  
>  	skb_copy_header(n, skb);
> +	if (skb_mac_header_was_set(n) && skb_mac_offset(n) < 0)
> +		skb_unset_mac_header(n);
>  out:
>  	return n;
>  }

[Severity: High]
Does this turn the uninitialised read into an out-of-bounds read for
bridged packets? The copy still carries SKB_EXT_BRIDGE_NF, because
skb_copy_header() -> __copy_skb_header() -> __skb_ext_copy() duplicates
the extensions. After this change, though, n->mac_header is ~0U.

nf_dup_ipv4() and nf_dup_ipv6() hand that copy to ip_local_out() and
ip6_local_out(), so it goes through NF_INET_LOCAL_OUT before any
link-layer header is pushed. Suppose a reject with tcp reset rule
matches there. nf_send_reset() and nf_send_reset6() only test
nf_bridge_info_exists(oldskb) before calling eth_hdr(oldskb). They then
pass oeth->h_source and oeth->h_dest to dev_hard_header().

With the mac header unset, that trips the DEBUG_NET_WARN_ON_ONCE() in
skb_mac_header(). It then reads 12 bytes at oldskb->head + 0xffff,
well past the end of the head buffer. Those bytes end up in the
Ethernet header of the RST sent out the bridge port, or the access
faults if the address is unmapped.

Before this patch the same path read uninitialised headroom inside the
buffer, which is the leak being fixed here. So the reject helpers
probably need a skb_mac_header_was_set() check, the same way
nf_bridge_adjust_skb_data() in nfnetlink_queue.c has one. Or would you
rather drop the bridge extension on the dup path? Either way, it looks
like that has to go in together with this change, especially with the
stable tag.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261117175835.745796-1-theodorlarionov%40gmail.com
