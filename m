Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792537533;
	b=3NcZQo06/OA7BCaMY2nqwHWtJaVAQOXVDcYZezggLBCicIHuNgNUzZ7rGjvSNcujzzaE
	 RAOupb7O/+zoQqim9cGAgBmmvMkQn2KB6GQ6Q/g7GiadlrsjzK+768RGG79tpGPnJLLXE
	 8cBjcy4xZFLzpiGOkYm83QlXE2rXA4yFXB+mM4RLzEDHYU/RIxXz0Yw2ftD26MyezP2wv
	 yC/VWz9/Pgr7nKPEBXrBw0zeVgcINQphiEuREItXIdWgvH86qgNbZdhQLxfHM+qB13yYF
	 7zwgzzg54fMuGvNOKTYXmcA+8O5x5+CxK1R3SMm8UXx2FTQdRF1kME2/0t4tyIJYUdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792537533;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=DGHCc7YlFfr3Ltf+5fwMGa4jDDixIv2iju+O30mYuOs=;
	b=0CFr9/QpzmhyCt2ykYHSrNCj2YskQKSNqyxLM/gXAeuJ5cp1YhcbBnnGCvTGslB4/gl3
	 59bTP8kewaK6a+io16NKml5NLCvyJJ6I05Xe6ZbyJ3R7RV1zFwkC/iZ/BDXwLWW1b8sZM
	 YPQDiODcYlg5LAkf502WtFygEViYWwx2lT22KfOc6VKM4e4BbMDqsf8okvgWRUN1e4J2t
	 H3Uk3UXmjClUjs2mvQoYg6kE7y+Bf7xR6DI1kRl6AFD4gEU1WcYJFxA74ZWr3IQguxWie
	 1ebXOcB5qWrhsJt6mTzilkURG7VpWWDrJCvebRTesv6z2/8hA4odg5GipZwaL1fkggg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=p2b0mi2f;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 68C93606A31C
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2026 23:05:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68C93606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=p2b0mi2f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792537530;
	bh=DGHCc7YlFfr3Ltf+5fwMGa4jDDixIv2iju+O30mYuOs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p2b0mi2fsdZ0kHYplwOQBkz2xICJSjmTqcGmw951aUSmbUmJOnaTHEMDX6bUSxFHW
	 df1/zxnP+oRyb1tEI0cTxVTeydIV0eRT7TZQesntd7cTRjVnmfaXgon5kACy/TA4CG
	 /z+djwrEXmyLcywlyt/FbVWFJe3y+vk9SGPfihnT7n7n5Xag0QnhxWHL2DfyM2fAxS
	 E4u628t7e7JLfWb0mHVntHv5RAVSFg1swNLrAiyvw4EXqutsbKnjl5xsN2wgLUKpAH
	 0aSpcBRasQ2FjJBhS0nhVPE9GKHogfPzdvdmv/keD5hnjWbleSV+oxwIlcvMW3NluK
	 6sIrf2mX9E0uw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 469336005D;
	Wed, 21 Oct 2026 01:05:30 +0200 (CEST)
Date: Wed, 21 Oct 2026 01:05:27 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Dominik Maier <dmnk@google.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	dmnk+artist@google.com
Subject: Re: [BUG] netfilter: ipv6: nf_defrag: u8 prev_nhoff truncation in
 find_prev_fhdr()
Message-ID: <atfztyDQItk5FT0O@chamomile>
References: <CAE7N4Sq0wALccc4+715nZLtYQWeZz=uBHfyK34F+LVz4iov_vA@mail.gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAE7N4Sq0wALccc4+715nZLtYQWeZz=uBHfyK34F+LVz4iov_vA@mail.gmail.com>

On Mon, Oct 19, 2026 at 05:16:32AM -0500, Dominik Maier wrote:
> In Linux 7.3.0 (commit c03c1a14507d), find_prev_fhdr() in
> net/ipv6/netfilter/nf_conntrack_reasm.c (line 398) tracks the current
> extension header offset in int start and writes the preceding header's
> nexthdr offset to int *prevhoff, but declares prev_nhoff as u8.
> 
> When nf_defrag_ipv6 (CONFIG_NF_DEFRAG_IPV6=y/m) reassembles an incoming
> fragmented IPv6 packet whose unfragmentable extension headers place the
> header preceding the Fragment header at offset start >= 256 (for
> example, start = 296 with a 40-byte IPv6 header, a 256-byte Hop-by-Hop
> Options header, and an 8-byte Destination Options header at offset
> 296..304), assigning prev_nhoff = start truncates 296 modulo 256 to 40.
> 
> During reassembly in nf_ct_frag6_reasm(), writing
> skb_network_header(head)[nhoff] = fhdr->nexthdr overwrites offset 40
> (HopOpts.nexthdr) with IPPROTO_UDP (17) while leaving NEXTHDR_FRAGMENT
> at offset 296 (DstOpts.nexthdr). Subsequent Netfilter hooks and
> xfrm6_policy_check() (__skb_flow_dissect()) parse the 8-byte
> Destination Options header as the outer UDP header, whereas
> ip6_protocol_deliver_rcu() delivers the real UDP payload at
> skb_transport_offset(skb) = 304 to the destination socket.
> 
> We reproduced this in QEMU by sending two IPv6 fragments containing a
> 256-byte Hop-by-Hop Options header and an 8-byte Destination Options
> header (placing the Fragment header at offset 304), causing
> nf_defrag_ipv6 to overwrite offset 40 instead of offset 296 and bypass
> an inbound XFRM_POLICY_BLOCK policy on the target UDP port. The
> reproducer is available upon request.
> 
> Below is a proposed fix (also tested in QEMU) changing prev_nhoff from
> u8 to int to match start and *prevhoff.

Dup, for the record:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260822214012.1028305-2-Jeremy.Jean@oss.cyber.gouv.fr/

> Fixes: 029f7f3b8701 ("netfilter: ipv6: nf_defrag: avoid/free clone operations")
> Assisted-by: ARTIST LLM
> ---
>  net/ipv6/netfilter/nf_conntrack_reasm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c
> b/net/ipv6/netfilter/nf_conntrack_reasm.c
> index 13bd8997f36c..8fb7380f239d 100644
> --- a/net/ipv6/netfilter/nf_conntrack_reasm.c
> +++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
> @@ -398,7 +398,7 @@ find_prev_fhdr(struct sk_buff *skb, u8 *prevhdrp,
> int *prevhoff, int *fhoff)
>  {
>  	u8 nexthdr = ipv6_hdr(skb)->nexthdr;
>  	const int netoff = skb_network_offset(skb);
> -	u8 prev_nhoff = netoff + offsetof(struct ipv6hdr, nexthdr);
> +	int prev_nhoff = netoff + offsetof(struct ipv6hdr, nexthdr);
>  	int start = netoff + sizeof(struct ipv6hdr);
>  	int len = skb->len - start;
>  	u8 prevhdr = NEXTHDR_IPV6;
