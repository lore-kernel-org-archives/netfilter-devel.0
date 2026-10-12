Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99357366048;
	Mon, 12 Oct 2026 05:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791781870; cv=none; b=imW0pXGAS/Ykn2FEJFyEaBhdy50CI8F5lMXW1f9hFF/iTqBWLTbk3zep3kI2HB+wfi/ZoqN9nP0iicVlFghkrnEEkWd/FDnHmaGB48Udb8de2LChu2WSKVUmxaugS8KJEvOfKiISzmKb/+aykM8YFXGxrSwv8/l7lI5zfk3mTaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791781870; c=relaxed/simple;
	bh=sJsYgyZPnM7XyhkdgU0EYF2UHk/t/02/k5Qw4IxXfac=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oOQaBhNU/pzc9JnCg/GqgdAmp2f+zfwQeRyf5RowYN/HYY4Z9Jq5Jl97CWA8Lu1HmBjdpxpK5aDL2dOzhDMZgKKMdT/A0YYs+gnkht1rSI9zInQDxHvMm/Ax4Tjz4jpJwAwb7wOrh9TB59NS0W9AfCPAfv2L55vzoVWxYdIkNQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VyqtkkEB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VyqtkkEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93DB1F0089B;
	Mon, 12 Oct 2026 05:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791781869;
	bh=KVC0ZTz/tGdRB7NZFqRTos4J+1MlShyzx8YdujHIM8A=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=VyqtkkEBCv3IQiTlrwkF1kJ54QgSTuFSnVpvWctTzhLlQBq+yClsrZmOPS43f+P7O
	 cx9Ai274hTCdf76d8kHomiEv/NNuEkZ410Dz9KpNJmvmiddLEKxqSJGE8w1orLS8Hn
	 zNuzWaxOLcDj8A+3rKfHI3+9KqFnnNnDkwSTRJBpz3LuGKz1yV1TQXjworCoYnv4aq
	 X/5D3FZnOmQcbVc8+FNRYa66tKRvnVHdeTK3oLHnsPoySL5OQO8Cc96jvVkmXR3y9A
	 xEjSoWPV6NO/Ce+wcIDKoeHZH3w/6ViDWUiakamz9pr2mq2Mx2X0J//r/vVp1RnF2G
	 LPyN+RLPNd3mg==
Subject: Re: [PATCH net v2] netfilter: nf_conntrack_reasm: avoid truncating
 header offsets
From: netdev-bot+sashiko@kernel.org
To: tjdqudcks0424@naver.com
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
 stable@vger.kernel.org, kuba@kernel.org, Jeremy.Jean@oss.cyber.gouv.fr,
 netdev-bot+sashiko@kernel.org
Date: Mon, 12 Oct 2026 05:11:08 +0000
Message-ID: <179178186825.434549.9384065506892105866@kernel.org>
In-Reply-To: <20261008050225.29543-1-tjdqudcks0424@naver.com>
References: <20261008050225.29543-1-tjdqudcks0424@naver.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The fix leaves a 16-bit skb->transport_header truncation
  reachable, which is the bug class the commit says it closes.
- [Low] The patch has Cc: stable@vger.kernel.org and Fixes: 9fb9cbb1082d
  (2007), so it will be queued for every maintained LTS tree.

--

netfilter: nf_conntrack_reasm: avoid truncating header offsets

The patch changes prev_nhoff in find_prev_fhdr() from u8 to int, so the
offset of the previous Next Header field no longer wraps at 256. In
nf_ct_frag6_gather() it also rejects an nhoff that does not fit in
frag_queue.nhoffset. It then uses skb_set_transport_header_careful() to
reject a Fragment Header offset that skb->transport_header cannot hold.

Link: https://lore.kernel.org/netfilter-devel/20260822214012.1028305-2-Jeremy.Jean@oss.cyber.gouv.fr/
Link: https://lore.kernel.org/netfilter-devel/179089937913.434549.5874493628033954656@kernel.org/

> diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
> index 599c49bf0a0af..ae25ebc873b0f 100644
> --- a/net/ipv6/netfilter/nf_conntrack_reasm.c
> +++ b/net/ipv6/netfilter/nf_conntrack_reasm.c

[ ... ]

> @@ -474,7 +474,9 @@ int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user)
>  	if (!pskb_may_pull(skb, fhoff + sizeof(*fhdr)))
>  		return -ENOMEM;
>  
> -	skb_set_transport_header(skb, fhoff);
> +	if (nhoff != (u16)nhoff ||
> +	    !skb_set_transport_header_careful(skb, fhoff))
> +		return -EINVAL;

[Severity: High]
Does this check cover every value that transport_header has to hold later
in this path?

skb_set_transport_header_careful() only checks the start of the Fragment
Header, thoff = (skb->data - skb->head) + fhoff. It verifies that thoff
fits in the 16-bit field and is not the 0xffff sentinel.

Later, nf_ct_frag6_queue() pulls past the Fragment Header:

net/ipv6/netfilter/nf_conntrack_reasm.c:nf_ct_frag6_queue() {
    ...
	/* Point into the IP datagram 'data' part. */
	if (!pskb_pull(skb, (u8 *) (fhdr + 1) - skb->data)) {
    ...
}

Then nf_ct_frag6_reasm() writes skb->data - skb->head, which is now
thoff + 8, back into the __u16 field:

net/ipv6/netfilter/nf_conntrack_reasm.c:nf_ct_frag6_reasm() {
    ...
	skb_reset_transport_header(skb);
    ...
}

The only guard on that narrowing is a debug-only warning:

	long offset = skb->data - skb->head;

	DEBUG_NET_WARN_ON_ONCE(offset != (typeof(skb->transport_header))offset);
	skb->transport_header = offset;

So for any thoff in 0xfff7..0xfffe the new check passes, but the reset
stores either 0xffff or a wrapped value of 0..6. Both are before
network_header.

Here is an example on the LOCAL_OUT raw path with 16 bytes of headroom, as
in the commit message, but with the Fragment Header at offset 65512
instead of 65528:

- thoff is 0xfff8, so the new check passes.
- The packet is an atomic fragment (offset 0, MF clear) with 8 bytes after
  the Fragment Header, so it is reassembled immediately.
- The reassembled payload_len of 65480 passes the IPV6_MAXPLEN check.
- After the pull, data - head is 0x10000, so transport_header becomes 0.

Right after the reset, nf_ct_frag6_reasm() does:

	if (skb->ip_summed == CHECKSUM_COMPLETE)
		skb->csum = csum_partial(skb_network_header(skb),
					 skb_network_header_len(skb),
					 skb->csum);

Here skb_network_header_len() returns transport_header - network_header,
which underflows.

The effects depend on the configuration:

- With CONFIG_DEBUG_NET the warning fires, which is a DoS with
  panic_on_warn.
- On CHECKSUM_COMPLETE skbs, csum_partial() gets the underflowed length.
  Implementations that treat the length as unsigned, such as the x86_32
  asm version, read out of bounds.
- On the receive path, ip6_protocol_deliver_rcu() later calls pskb_pull()
  with a negative transport offset, so the packet is dropped.

The raw path itself produces CHECKSUM_NONE, so the csum_partial() part
needs some other source of CHECKSUM_COMPLETE skbs of about 64KB.

Should the bound also cover the end of the Fragment Header? One option is
to reject when skb_headroom(skb) + fhoff + sizeof(struct frag_hdr) does not
fit in transport_header. Another is to use
skb_reset_transport_header_careful() in nf_ct_frag6_reasm() and fail the
reassembly.

[Severity: Low]
This patch has Cc: stable and Fixes: 9fb9cbb1082d, so it will be queued
for all maintained LTS trees. It relies on
skb_set_transport_header_careful(), which was only added recently by
commit f12c2de4f542 ("batman-adv: reject unrepresentable multicast TVLV
offsets").

That commit's own Fixes: tag is 07afe1ba288c ("batman-adv: mcast:
implement multicast packet reception and forwarding") from 2023. LTS trees
older than that code, such as 6.6, 6.1, 5.15 and 5.10, will not get the
helper through that backport. On those trees nf_ct_frag6_gather() would
not build.

Could the commit message mention this prerequisite? If a backport replaces
the helper with plain skb_set_transport_header(), the truncation this
patch removes comes back.

>  	hdr = ipv6_hdr(skb);
>  	fhdr = (struct frag_hdr *)skb_transport_header(skb);
>

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261008050225.29543-1-tjdqudcks0424%40naver.com
