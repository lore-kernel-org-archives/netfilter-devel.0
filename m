Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD16CA6B;
	Fri,  2 Oct 2026 00:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790899382; cv=none; b=i6cZUdZ1OfLduXagCW+xobl0f3nvp65maK09cT9otjvDnmB795DgceKfj5njli8L6TUUHaIP7NjUAfpf6/PX/LRGIfZ9jSxdVlL2Lr5co+Wq62jc6Jij74xPMoFhghQNSSZzSbQaRV4bp6UFTS5k/LFZyCcyAjKx1rHxd8sV3Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790899382; c=relaxed/simple;
	bh=+MKk/w3EM1ZEGB9QX8DBqYUytNMvpxXUpLbkvJGiEbY=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Iq8ifzIHh3z6nUMcc66Mqz691BPKW7KpdGjJfXi27Z+RDqEiOdVoj35qv4f3om19ZWKqp3Q3E7Kmv5LpIyanxqGe9WqJB5PMIqw4E6AeTFsoNz4RFoQihTShTMdf0aKPpkxpcGyFSepTwmrCKauTj0rHLXdbBVsCindKHm8KV5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=krt04fVr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="krt04fVr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17831F000FF;
	Fri,  2 Oct 2026 00:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790899380;
	bh=Dvor4gYEkp32nNT2Ew94wywNzoc+aD/8FscPLTSJ8Sc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=krt04fVrQvyeRY5I7T9ijhoPXbmcQfoD1wnOl0pShdgHqotO9u8nio63kLWm5En9d
	 euHt97dcsEBYrUnpFTrPtZ/GV/jOyrHVbLgO9bO7tDFTpBlzEvULKYvVYzS0G0NHWi
	 JeS9AuGNDNh1I/XzIzFUPliIBp4o3hMtW+1zLyEy64Qs0DfQkKStOU8PTiTMl7R+Hx
	 3do3HXlOuOL10NuVqVI/F8CZWvawCODG9uD/4g4m3WUs7yiyfrJHTLXxI0cLMEpRQd
	 t2/LxvSRywXyQqEf0FEmlD/TDyjgTs1+HtKfg2FH3n/+7JHdiBK7FiVn9qdgOIV/Wt
	 M3d0bGUq60D6g==
Subject:
 Re: [PATCH net] netfilter: nf_conntrack_reasm: avoid truncating header offset
From: netdev-bot+sashiko@kernel.org
To: tjdqudcks0424@naver.com
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de,
 phil@nwl.cc, netdev@vger.kernel.org, stable@vger.kernel.org, kuba@kernel.org
Date: Fri, 02 Oct 2026 00:02:59 +0000
Message-ID: <179089937913.434549.5874493628033954656@kernel.org>
In-Reply-To: <20260929090027.200041-1-tjdqudcks0424@naver.com>
References: <20260929090027.200041-1-tjdqudcks0424@naver.com>
X-sashiko-severity: High
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

Critical: 0 · High: 1 · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The patch widens prev_nhoff to int, but header offsets in this
  parse-and-reassemble path are still truncated to 16 bits with no range…

--

netfilter: nf_conntrack_reasm: avoid truncating header offset

This patch changes prev_nhoff in find_prev_fhdr() from u8 to int, so a
Next Header offset of 256 or more is no longer truncated. Before the
change, nf_ct_frag6_reasm() used the truncated value from
frag_queue.nhoffset and overwrote the IPv6 header instead of the
preceding extension header's Next Header field.

> diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
> index 599c49bf0a0af..be72c4346f8b7 100644
> --- a/net/ipv6/netfilter/nf_conntrack_reasm.c
> +++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
> @@ -398,7 +398,7 @@ find_prev_fhdr(struct sk_buff *skb, u8 *prevhdrp, int *prevhoff, int *fhoff)
>  {
>  	u8 nexthdr = ipv6_hdr(skb)->nexthdr;
>  	const int netoff = skb_network_offset(skb);
> -	u8 prev_nhoff = netoff + offsetof(struct ipv6hdr, nexthdr);
> +	int prev_nhoff = netoff + offsetof(struct ipv6hdr, nexthdr);

[Severity: High]
This fixes the 8-bit truncation. Are the same offsets still truncated to
16 bits later in this path?

find_prev_fhdr() bounds prev_nhoff and fhoff only by skb->len. Both values
then go into 16-bit storage with no range check:

include/net/ipv6_frag.h:struct frag_queue {
    ...
	__u16			nhoffset;
    ...
}

net/ipv6/netfilter/nf_conntrack_reasm.c:nf_ct_frag6_queue() {
    ...
	if (offset == 0) {
		fq->nhoffset = nhoff;
    ...
}

net/ipv6/netfilter/nf_conntrack_reasm.c:nf_ct_frag6_gather() {
    ...
	skb_set_transport_header(skb, fhoff);
	hdr = ipv6_hdr(skb);
	fhdr = (struct frag_hdr *)skb_transport_header(skb);
    ...
}

skb_set_transport_header() adds fhoff to the u16 skb->transport_header.
If headroom + fhoff is above 65535, the value wraps and fhdr no longer
points at the real Fragment Header.

At PRE_ROUTING this seems harmless. ip6_rcv_core() trims skb->len to
payload_len + 40, and nf_ct_frag6_queue() then appears to drop the wrapped
cases because end exceeds IPV6_MAXPLEN.

The LOCAL_OUT raw path looks different. rawv6_send_hdrinc() limits the
length only by dev->mtu, which is 65536 on lo by default. It does not
rewrite payload_len and calls NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_OUT, ...)
directly.

lo has 16 bytes of headroom. So a 65536-byte IPV6_HDRINCL packet can put
fhoff at 65528 behind a chain of Destination Options headers.
transport_header then wraps to 8, and fhdr points into the headroom at
skb->head + 8.

The real Fragment Header can carry a nonzero offset, so
ipv6frag_thdr_truncated() still passes. Suppose the stale headroom bytes
decode as offset 0 with MF clear, for example zeroed memory under
init_on_alloc. Would the packet then be reassembled as a single fragment?

If so, could it reach this sequence?

nf_ct_frag6_gather()
  nf_ct_frag6_queue()
  nf_ct_frag6_reasm()
    skb_network_header(skb)[fq->nhoffset] = skb_transport_header(skb)[0];
    ...
    skb->network_header += sizeof(struct frag_hdr);
    ...
    inet_frag_reasm_finish()
      skb_push(head, head->data - skb_network_header(head));

The first line copies a byte of uninitialized headroom into the packet
data.

The network_header increment moves it to head + 24, past skb->data at
head + 16. The skb_push() length is then -8, which becomes 0xFFFFFFF8 as
an unsigned int. Would that trigger skb_under_panic()?

This path needs CAP_NET_RAW, which an unprivileged user may get inside a
user and net namespace. It also needs conntrack defrag active in that
netns, for example through an nft ct rule.

Also, if lo's MTU is raised above 65536, can prev_nhoff reach 65536 or
more? The store into the __u16 nhoffset would then wrap to 0, 8 and so
on, which is the same misdirected Next Header write this commit fixes for
the u8 case.

Should find_prev_fhdr() or nf_ct_frag6_gather() reject nhoff and fhoff
values that the 16-bit consumers cannot hold? For fhoff, that means
including the headroom and sizeof(struct frag_hdr).

>  	int start = netoff + sizeof(struct ipv6hdr);
>  	int len = skb->len - start;
>  	u8 prevhdr = NEXTHDR_IPV6;

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260929090027.200041-1-tjdqudcks0424%40naver.com
