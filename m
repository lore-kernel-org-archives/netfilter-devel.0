Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795068024;
	b=hazdMg/dfh377hmGzNiES2EjdCzqNn2/ws6A5Rp9ry+uZhbWN9qg653saEHjQR1oefBO
	 rT9ZzKVWxyyzGzmu2c/Ffgz1TLQMtUMbORExxnNOBNMp5cSqg51IL+Iijo/TpHFl3c4CR
	 z7HKiaspuo+aPaPOH8Xbm3zDxEug/iIfGK563IjTbobm9AKdoPVSidujoOT0JhR+GOPtP
	 5qL9IY/Ukb55zPS/D0RcM0qVV7x2S1KlUhXyLR8rypTzDLzug1rMPhkdaqD/11UCJAWvG
	 lrH87kwzdotZq0cAkBbRILJOIsticW0ipYx4q+zeByIe+VWv1PTUoTQOep9fC3jSYOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795068024;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=+b8NBtiQLHCO40sC7F8rypcN15XfAiFGua5IsAt8Ejk=;
	b=Uf5RdINJdGCZLNvXja9eICnvfKY/x1yVkNSmMoR9aRMwqIPfKun3HUr9tQAjHX0tA6NI
	 PPO/k5pctZ2MAI7GyWjSmIbSd66UU3SM6ZCO+2WKnUoSk77MbUnIQ/KKLgtmhzI+OA+cy
	 A8+81yZSh9uXdzc273gIUau86MFyhkFYrgw6KSRirNIXOUpO8s+OS1S1Ae7Xo4TlzGfeR
	 2NvOktL4eJljuu97GgV3/4uklgLKne/Ic3DhVmwa0ezAwi9VhVIPmlV25RbtYlEamsGev
	 u6Av0Bx0Glc7Rlb/akUpNnwx7CmyUcDGiCExt9bNr+pRhJl/+kp1VRu2dlyBIrverkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ULPBVKx7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D88606A320;
	Thu, 19 Nov 2026 06:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ULPBVKx7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D1131F000C5;
	Thu, 19 Nov 2026 06:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795068023;
	bh=+b8NBtiQLHCO40sC7F8rypcN15XfAiFGua5IsAt8Ejk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ULPBVKx7elAZHskhquoySjADN2or1tn7LWRegayd8Q27EjVOJlO/WXP3Bk+4TM8g/
	 K8ZSfghDQC20SDp5i/ANaoQ5bYwpYcYM2u4JWugvprcsJuEGYnM2HqBYpM3LWJWUUD
	 ejPROgligt7WnsVMU1SGIAn0HvLUgSG/+gF+otBVMugu3epGC+zkJQroFXmC+bUjci
	 1ZdkXBx6Ex1mIVIOYfYAUyX3BfC6NYSlS4JZHB7c2XYqst3xh2kkV2DbvccgnMqiac
	 Uv9oQhM9ww+dN2NgNG6oKCS7jNrYP+1erCrdEQOlW68b3OjeGJJUZlrayisXM0srZH
	 nvTtk2t3XpAfw==
Subject: Re: [PATCH net v2 1/2] netfilter: nfnetlink_queue: only adjust
 bridged skbs that have a mac header
From: netdev-bot+sashiko@kernel.org
To: theodorlarionov@gmail.com
Cc: davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, pablo@netfilter.org, fw@strlen.de,
 phil@nwl.cc, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org
Date: Thu, 19 Nov 2026 06:00:22 +0000
Message-ID: <179506802273.3136.14270280205910670302@kernel.org>
In-Reply-To: <20261117175835.745796-2-theodorlarionov@gmail.com>
References: <20261117175835.745796-2-theodorlarionov@gmail.com>
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The series leaves an out-of-bounds read in nf_send_reset() and
  nf_send_reset6().
- [Low] The commit message and tags present this as a standalone fix for
  a live KASAN slab-out-of-bounds bug, with `Fixes: a5fedd43d5f6` and…

--

netfilter: nfnetlink_queue: only adjust bridged skbs that have a mac header

This patch makes nf_bridge_adjust_skb_data() and
nf_bridge_adjust_segmented_data() skip the push/pull of
skb_mac_header_len() bytes when the skb has no mac header set. It is
groundwork for the next patch in the series, which unsets the mac header
of a pskb copy that points into headroom.

> Fixes: a5fedd43d5f6 ("netfilter: move skb_gso_segment into nfnetlink_queue module")
> Cc: stable@vger.kernel.org

[Severity: Low]
Is this Fixes tag accurate for this patch on its own? The commit message
says the trigger only shows up once the next patch is applied:

> A pskb copy of a bridged packet, such as one made by nft dup,
> keeps that info, and the next patch unsets its mac header.

Before that patch, a pskb copy keeps the original mac_header offset. So
skb_mac_header_was_set() is true and skb_mac_header_len() does not
underflow in nf_bridge_adjust_skb_data().

The next patch ("net: unset the mac header of a pskb copy that points into
headroom") has Fixes: 1da177e4c3f4 and no dependency note. A backport of
that patch alone would bring in the KASAN splat this patch prevents.

Could the commit message say this is a prerequisite for the following
patch? Or could the stable tag on the next patch list this one as a
dependency?

> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index a8aa7ad832c3f..fafadd9057cf7 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -1084,13 +1084,13 @@ nf_queue_entry_dup(struct nf_queue_entry *e)
>   */
>  static void nf_bridge_adjust_skb_data(struct sk_buff *skb)
>  {
> -	if (nf_bridge_info_get(skb))
> +	if (nf_bridge_info_get(skb) && skb_mac_header_was_set(skb))
>  		__skb_push(skb, skb_mac_header_len(skb));
>  }
>
>  static void nf_bridge_adjust_segmented_data(struct sk_buff *skb)
>  {
> -	if (nf_bridge_info_get(skb))
> +	if (nf_bridge_info_get(skb) && skb_mac_header_was_set(skb))
>  		__skb_pull(skb, skb_mac_header_len(skb));
>  }

[Severity: High]
This patch only guards these two nfnetlink_queue helpers. Do other users
also trust the mac header whenever nf_bridge info is present?

nf_send_reset() in net/ipv4/netfilter/nf_reject_ipv4.c does this:

	if (nf_bridge_info_exists(oldskb)) {
		struct ethhdr *oeth = eth_hdr(oldskb);
		...
		if (dev_hard_header(nskb, nskb->dev, ntohs(nskb->protocol),
				    oeth->h_source, oeth->h_dest, nskb->len) < 0)

It never calls skb_mac_header_was_set(). nf_send_reset6() in
net/ipv6/netfilter/nf_reject_ipv6.c has the same code.

With the next patch applied, it looks like this path can be reached:

1. Bridged IPv4 or IPv6 traffic passes ip/ip6 PREROUTING or FORWARD
   through br_netfilter. At that point skb->data is at the network header,
   so skb_mac_offset() < 0.

2. A TEE or nft dup rule calls nf_dup_ipv4() or nf_dup_ipv6(), which call
   pskb_copy(). Then __copy_skb_header()->__skb_ext_copy() keeps
   SKB_EXT_BRIDGE_NF on the copy, and after the next patch the copy's
   mac_header is 0xffff.

3. The copy goes through ip_local_out() or ip6_local_out() and the
   LOCAL_OUT hook.

4. An OUTPUT rule "REJECT --reject-with tcp-reset" (or nft "reject with
   tcp reset") matches the copy. nf_reject_ip_tcphdr_get() only checks
   frag offset, protocol, RST and checksum, so the copy passes.

5. nf_bridge_info_exists() is true, so eth_hdr(oldskb) returns
   skb->head + 65535.

dev_hard_header() then copies 12 bytes from that address into the RST's
Ethernet header. The RST goes out the physical input port.

Can this read past the buffer and send those kernel bytes onto the wire?
Before the series this path read uninitialized headroom inside the buffer.
With the series applied, it reads past the end of the buffer.

Would it be more robust to drop SKB_EXT_BRIDGE_NF from the copy in the
dup path? For example, call skb_ext_del(skb, SKB_EXT_BRIDGE_NF) after
pskb_copy() in nf_dup_ipv4() and nf_dup_ipv6().

The copy is a locally routed L3 packet, so its br_netfilter state has no
meaning there. That would cover every user and make the per-user guards
unnecessary. If not, nf_send_reset() and nf_send_reset6() would need the
same skb_mac_header_was_set() check.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261117175835.745796-1-theodorlarionov%40gmail.com
