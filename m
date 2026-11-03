Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793721445;
	b=EDDtDNgUHhSFnMyZQVhjVuEfyZWuiBD1h13ojkv1EHqXMTqprtL1YS4dveB2lipGsXge
	 4b6SBjmk4GSSiP0EofCMQIC2HM4o1tiRi3G86I/9B9AGJIcYkQT7p4I54edQ6ZKLpIw7O
	 XB//sl3UvGmNkt4naot1WfukMJvE8rs+3wCwe049kh8XpyZEgaCJo5IzdK+cGzwPUgVai
	 5NNtc5rkQMTxnOli2XUl3o813DN8v11oqiEe0upigyHK3XJF2JaX/HT6zABGQs3Hay0JM
	 F6e0NqyiTUrn2IfQkHcCsi5kwrEZHg9QeTEVKA+21im/fLdwrY8F5rAmxDKgU3ZxXog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793721445;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=gNzyZBC6D62ObBOksRyz9sJ65IeUrHPgVdzW9BysQek=;
	b=NpcfIv1ANAlfQzrd8wsraDJZvdMc26Wul4ShgRkwY/C7re52It3OubwL24KFtf3F3Gm7
	 Meq8Vr2anOn1m5kvNSDLcoSXiscSIkPROB+AO+B8IRFm6gFbQauvdfLATppLZDXDCAk6X
	 NIThDFy0SRQfr3orHMyVGoPTAvCVQbn0Gv8dyjXx+zZT3bHi5qj+xZcLBhT2lqd0+3gm8
	 P6ukF4biP3Bq826Q6Wni44KTAPdG/y+JyOgE4HQleP7wDVrEAb+K+mbkdmCGxJreJ2xMX
	 vlKqdKXx3hC9ewSjwAZzPzLQTO3oVyTrsoGbsoCzD+lxIQ5GV/3kOP110YXupV/rjUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="H6PWEm/Z";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD41D606D815;
	Tue,  3 Nov 2026 15:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H6PWEm/Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C45A1F000C1;
	Tue,  3 Nov 2026 15:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793721444;
	bh=gNzyZBC6D62ObBOksRyz9sJ65IeUrHPgVdzW9BysQek=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=H6PWEm/ZPW83hxmsfMz+Ant7GwUD01Z4UOEWjnivIq48H4ArN5Rq7iqfjmNfKObei
	 Vy1AemAmjLDLatmBo+EygXVVgsOtmMNncps5mSDTLyIn2Dql6vGzaeR3vdZmfmpNxV
	 ixkRm3knpes5vkDK5TWcX8r6sVJuDQL4FeuQ3KxVnT9iTChgANijOwLzr/n/6bYGJ0
	 0FcMXLxLRjr6K61bopompM4dqwoFNeBSiahAtzEDOroboY9hFeJQJviJatWR1L4sSG
	 mSWBU4JnkY2I9ZGSYoBL1noNDDVcVXObYygZ68H7CO4nxJymrnPoWLSd8FsFmwclCl
	 DC7s12nDF8P6A==
Subject: Re: [PATCH net] netfilter: nf_reject: validate TCP header length
 before sending resets
From: netdev-bot+sashiko@kernel.org
To: zhangmh25@mails.tsinghua.edu.cn
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
 pablo@netfilter.org, coreteam@netfilter.org, stable@vger.kernel.org,
 jianjun@tsinghua.edu.cn, kuba@kernel.org
Date: Tue, 03 Nov 2026 15:57:23 +0000
Message-ID: <179372144385.488856.3773065210102501294@kernel.org>
In-Reply-To: <20261102155622.2658789-1-zhangmh25@mails.tsinghua.edu.cn>
References: <20261102155622.2658789-1-zhangmh25@mails.tsinghua.edu.cn>
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

- [High] The patch does not fully close the case it says it closes.

--

netfilter: nf_reject: validate TCP header length before sending resets

This adds a check to nf_reject_ip_tcphdr_get() and
nf_reject_ip6_tcphdr_get(). It rejects TCP headers whose doff is smaller
than the fixed header or larger than the available TCP segment. The goal
is to stop sending an RST whose ack_seq comes from an invalid header
length.

> diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
> index 7cb33af671e26..5ed97772bbaaf 100644
> --- a/net/ipv4/netfilter/nf_reject_ipv4.c
> +++ b/net/ipv4/netfilter/nf_reject_ipv4.c
> @@ -189,6 +189,11 @@ nf_reject_ip_tcphdr_get(struct sk_buff *oldskb,
>  	if (oth == NULL)
>  		return NULL;
>  
> +	/* Reject invalid or truncated TCP headers. */
> +	if (oth->doff < sizeof(struct tcphdr) / 4 ||
> +	    oldskb->len - ip_hdrlen(oldskb) < (oth->doff << 2))
> +		return NULL;

[Severity: High]
Should this check use the length from the IP header instead of
oldskb->len?

nf_reject_iphdr_validate() only rejects skb->len < tot_len. Also,
nf_reject_skb_v4_tcp_reset() never trims oldskb:

net/ipv4/netfilter/nf_reject_ipv4.c:nf_reject_iphdr_validate() {
    ...
	len = ntohs(iph->tot_len);
	if (skb->len < len)
		return 0;
    ...
}

The unreach builder in the same file trims before it uses the length:

net/ipv4/netfilter/nf_reject_ipv4.c:nf_reject_skb_v4_unreach() {
    ...
	if (pskb_trim_rcsum(oldskb, ntohs(ip_hdr(oldskb)->tot_len)))
		return NULL;
    ...
}

Callers inside the IP stack get an skb that ip_rcv_core() has already
trimmed. The netdev ingress and bridge reject expressions don't:

nft_do_chain_netdev()
  nft_reject_netdev_eval()
    nft_reject_netdev_send_v4_tcp_reset()
      nf_reject_skb_v4_tcp_reset()
        nf_reject_ip_tcphdr_get()

nft_reject_br_send_v4_tcp_reset() works the same way. On these paths
skb->len still counts Ethernet padding and any trailing bytes the sender
adds.

For those skbs, can a doff that runs past the end of the IP-declared
segment, but fits inside the trailer, still pass this check?

Take tot_len = 40 (a 20-byte TCP segment), doff = 15 and 40 trailing
bytes. The check sees 60 >= 60 and passes. nf_ip_checksum() also sums
over skb->len - dataoff, so it doesn't catch this either. Then
nf_reject_ip_tcphdr_put() computes:

	tcph->ack_seq = htonl(ntohl(oth->seq) + oth->syn + oth->fin +
			      oldskb->len - ip_hdrlen(oldskb) -
			      (oth->doff << 2));

and an RST still goes out. That seems to contradict this part of the
commit message:

    on both IPv4 and IPv6, a probe with doff = 15 produced an RST with a
    wrapped ack_seq; with the fix no RST is generated for such packets

A minimum-size frame shows the same thing. With tot_len = 40, 6 bytes of
padding and doff = 6, the check passes (26 >= 24) and the RST carries
ack = seq + 2.

The wraparound itself is fixed, because the check and the ack_seq
calculation now use the same length.

IPv6 looks the same. In nf_reject_ip6_tcphdr_get(), *otcplen is
oldskb->len - tcphoff. nf_reject_ip6hdr_validate() only rejects
payload_len + 40 > skb->len, and nf_reject_skb_v6_tcp_reset() never
trims. The IPv6 unreach path does trim to payload_len, in
nf_reject_v6_csum_ok(). nft_reject_netdev_send_v6_tcp_reset() and
nft_reject_br_send_v6_tcp_reset() pass untrimmed skbs into this code.

Would it be better to use ntohs(tot_len) - ip_hdrlen() (and the
payload_len based length for IPv6) for both this check and the ack_seq
calculation? Trimming oldskb first, as the unreach paths do, would also
work.

Either change would also fix an older problem: for well-formed doff = 5
packets on these paths, ack_seq is off by the padding length.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261102155622.2658789-1-zhangmh25%40mails.tsinghua.edu.cn
