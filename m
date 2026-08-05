Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B9F346AD0;
	Wed,  5 Aug 2026 00:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785888936; cv=none; b=NaJCd2k+kjBX42pSKef5QM9Ng2/f3mh77Bxvh4702VBY02Ro+LMrHZr9aHQOojWhPU8bBf/x/EIk3oFgTTr9qBXNJURhnM9bcxDHtT/GaHsSyWW59RxcG+HdhH7iznjrB94jG45WPaCtKIMKyyn/HeL2I3c8N8f0d734dTJumJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785888936; c=relaxed/simple;
	bh=lUSnWWTK3nWA1d0kqwVvma/5DUONS75XjXZEJKD4AVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TT+mUdxttOPK5BXIuD0Qd9kdEYdIyoV17IPbe8jQIOkuWIeUetSHFML1RyU0Opx+3+GZCSyGYw4hbiR/q0VaKvbgRfnIsN0ug7QTQbEz0Ou4auJdNWlbQXLAt4nV7XsscEEonsUvk7Qx0HUXemPKdkn97ixHUpOGPB/QzSfCQhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y7b9RUZL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y7b9RUZL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC581F00A3F;
	Wed,  5 Aug 2026 00:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785888935;
	bh=PrXfYFil4cduNPxDkG8wMUfSeuvKbGG/Bhl5jOzgMhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y7b9RUZLmNxoPcA4YJE63ldgGbUKkRlqsg5gHtvZpAClNwmfbS2QsMVhMIA1m1VAP
	 EB2qnaOFDhYiDJfdjha8UYTAfdYC7IszlcXAJ0IwYJ28td9zjL/tVXpghcB2i77Vpq
	 uLG20MtQrhgjjja42V3JH5BXoTqTsYzFVJMO9B85jmTZGHjxJEGeswMtNA3rLxkr8e
	 G3ZwlTchCXXwglIu8FFSMCixCmb+9+TU9Mo5TGa4us2T2yXZxMuQVVH9vDaqT4Vlhq
	 khdvcXII4i1rHuV1nzQelsmYNeTnOuGVaALWZV5bCnfB03guWbLZUdvp8BTilhEOSa
	 EZGAXvpnniNtg==
From: Jakub Kicinski <kuba@kernel.org>
To: pablo@netfilter.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	netfilter-devel@vger.kernel.org,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: Re: [PATCH net 08/10] ipvs: avoid out-of-bounds write in ip_vs_nat_icmp
Date: Tue,  4 Aug 2026 17:15:34 -0700
Message-ID: <20260805001534.3978877-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260731151806.849724-9-pablo@netfilter.org>
References: <20260731151806.849724-9-pablo@netfilter.org>
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
ipvs: avoid out-of-bounds write in ip_vs_nat_icmp

This passes the already-parsed ip_vs_iphdr down into ip_vs_nat_icmp() so
the embedded transport header offset comes from ciph->len instead of a
second read of the inner IPv4 ihl field.  The IPv4 header sanity checks in
ip_vs_out_icmp() and ip_vs_in_icmp() are also reworked to read ihl only
once.

Link: https://sashiko.dev/#/patchset/20260722101517.36313-1-ja%40ssi.bg

> diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> index 6b79e0c4d9e28..0bdaeb4ed61e4 100644
> --- a/net/netfilter/ipvs/ip_vs_core.c
> +++ b/net/netfilter/ipvs/ip_vs_core.c
> @@ -925,28 +925,27 @@ static int ip_vs_route_me_harder(struct netns_ipvs *ipvs, int af,
>   */
>  void ip_vs_nat_icmp(struct sk_buff *skb, struct ip_vs_protocol *pp,
>  		    struct ip_vs_conn *cp, int inout, unsigned int toff,
> -		    bool has_ports)
> +		    bool has_ports, struct ip_vs_iphdr *ciph)
>  {
>  	struct iphdr *iph	 = ip_hdr(skb);
>  	struct icmphdr *icmph	 = (struct icmphdr *)(skb->data + toff);
> -	struct iphdr *ciph	 = (struct iphdr *)(icmph + 1);
> -	unsigned int coff __maybe_unused = toff + sizeof(struct icmphdr);
> +	struct iphdr *cih	 = (struct iphdr *)(icmph + 1);
>  
>  	if (inout) {
>  		iph->saddr = cp->vaddr.ip;
>  		ip_send_check(iph);
> -		ciph->daddr = cp->vaddr.ip;
> -		ip_send_check(ciph);
> +		cih->daddr = cp->vaddr.ip;
> +		ip_send_check(cih);
>  	} else {
>  		iph->daddr = cp->daddr.ip;
>  		ip_send_check(iph);
> -		ciph->saddr = cp->daddr.ip;
> -		ip_send_check(ciph);
> +		cih->saddr = cp->daddr.ip;
> +		ip_send_check(cih);
>  	}

[Severity: High]
This isn't a bug introduced by this patch, but the two ip_send_check(cih)
calls here still read the inner ihl field a second time, which looks like
the same multi-read pattern the commit message describes fixing in this
function.

ip_send_check() takes its own fresh read of ihl and checksums 4 * ihl
bytes:

net/ipv4/ip_output.c:ip_send_check() {
	iph->check = 0;
	iph->check = ip_fast_csum((unsigned char *)iph, iph->ihl);
}

The only length the callers guarantee is the snapshot value ciph->len (plus
4 when ports are mangled):

net/netfilter/ipvs/ip_vs_core.c:handle_response_icmp() {
	unsigned int ctoff = ciph->len;
	...
		ctoff += 2 * sizeof(__u16);
	if (skb_ensure_writable(skb, ctoff))
		goto out;
	...
		ip_vs_nat_icmp(skb, pp, cp, 1, toff, has_ports, ciph);
}

ciph->len was computed earlier in ip_vs_fill_iph_skb_off() as
offset + iph->ihl * 4 from a skb_header_pointer() snapshot, and
skb_ensure_writable() -> pskb_may_pull() re-copies the bytes out of the
fragments, so the ihl byte ip_send_check() then reads can differ from the
one that sized the validated window.

If the fresh ihl is larger than the snapshot value, can ip_fast_csum() read
up to 40 bytes past what skb_ensure_writable() guaranteed, and fold
adjacent skb memory into the inner header checksum that is emitted?

If the fresh ihl ends up below 5 (for example the version/ihl byte going
from 0x45 to 0x40, compensated in tot_len so both the inner IP and ICMP
checksums stay valid), some architectures do not tolerate it:

arch/mips/include/asm/checksum.h:ip_fast_csum() {
	word += 4;
	do {
		csum += *word;
		carry = (csum < *word);
		csum += carry;
		word++;
	} while (word != stop);
}

with stop = iph + ihl, so for ihl <= 4 the loop termination is never hit.

arch/s390/include/asm/checksum.h:ip_fast_csum() {
	ihl -= 4;
	while (ihl--)
		csum += *ptr++;
}

where ihl == 0 underflows into roughly four billion forward word reads.

Would it make sense to checksum over the validated length
(ciph->len - ciph->off), or to re-validate version/ihl after
skb_ensure_writable(), matching what was done for the port offset?

The same sequence exists on the other call site:

net/netfilter/ipvs/ip_vs_xmit.c:ip_vs_icmp_xmit() {
	wlen = ciph->len;
	...
		wlen += 2 * sizeof(__u16); /* Also mangle ports */
	if (skb_ensure_writable(skb, wlen))
		goto tx_error;
	...
	ip_vs_nat_icmp(skb, pp, cp, 0, toff, has_ports, ciph);
}

>  
>  	/* the TCP/UDP/SCTP port */
>  	if (has_ports) {
> -		__be16 *ports = (void *)ciph + ciph->ihl*4;
> +		__be16 *ports = (void *)(skb->data + ciph->len);
>  
>  		if (inout)
>  			ports[1] = cp->vport;

[ ... ]

> @@ -1131,11 +1129,15 @@ static int ip_vs_out_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb,
>  
>  	/* Now find the contained IP header */
>  	offset += sizeof(_icmph);
> +	if (!ip_vs_fill_iph_skb_icmp(AF_INET, skb, offset, true, &ciph))
> +		return NF_ACCEPT; /* The packet looks wrong, ignore */
> +
>  	cih = skb_header_pointer(skb, offset, sizeof(_ciph), &_ciph);
> -	if (!(cih && cih->version == 4 && cih->ihl >= 5))
> +	if (!(cih && cih->version == 4 &&
> +	      ciph.len - ciph.off >= sizeof(struct iphdr)))
>  		return NF_ACCEPT; /* The packet looks wrong, ignore */

This check validates the snapshot length only, so nothing revalidates
version or ihl after the data is pulled into the linear area and handed to
ip_send_check().  Was that intentional?

[ ... ]
