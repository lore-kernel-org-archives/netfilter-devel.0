Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794316244;
	b=URhSknZfKFECsxMj069LJUKE9D/YQT2HO1uE4+2rcS/ON0KxMRmOvonve/NgTRtwDHMT
	 kfTJdTYXBEP5rmGZ202H0GbRLSiuGIzMtoMIReQKUv5ZL1amS6nAyztycDaBuxk4STlxu
	 yVXXEq1G/y0y7gtRV21ZMnAT1D83cj/JN86SRNaCfGpK7aw0NqTEIe0hDzKriNx3RecZa
	 9Td32l3FF89jdRahSidYmu4yIehQbr/BIZjbmf69RqDGezenlC5L5illus7vf2qqNigvf
	 6hGJrvTACqkDbwONoKvQlkbmPr86Eld1TIyyd4CemPaLjQTYmgAfxpJcuJSSQsdEfJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794316244;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=HiYzsbBOyOMWLsyBgylOcRi6NQLVjT/dfJAdNwyLB90=;
	b=4dwvJFnfzXBzHV95jaVhGkjPmEVXQujEju3Gd4FEXsGPIaw8maMnM8EvKubMGeoIlRkv
	 rHalL80/1lADrHUYgJoAJJr1gVdG8fUGe1pEsvFTPpomYubUvIVVDrKsdzu/65KvQHTf5
	 1ks5AMTSDa+/NFCpORapbMRgAPBYBUTIF32aCHeoillK54BlNRc3lbMl7TCbRsLdyclM4
	 DaynbAmj2A/0evJAMrUoZQgqlJr8VPaZizIEjohyXmUQKHFQBq2vkbM58bqrAvSu1Ywv1
	 rKoUQWdT52Uo0233P9B9D7A4v7Kqw/oitIkUWmar0LGi//nolnaC0ijvooHoofqIJiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=G52yr7oy;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 98E13606B2C4;
	Tue, 10 Nov 2026 13:10:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98E13606B2C4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=G52yr7oy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794316241;
	bh=HiYzsbBOyOMWLsyBgylOcRi6NQLVjT/dfJAdNwyLB90=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G52yr7oyUuYgjhhkTNxO/c6mUA8WPVpAkCUkl0/qCHjYnKIIegFkzfWIwSRLWSCjm
	 df7hfAlEgF0Al/6IazgcEhqwr5ndyAzEipMuNcmLfcFyBe4oQ3nZWnX6UKIkwYlMCO
	 7eOl+geGh3kfdtUNGEl/0wUPeUulS9navi38QVI+V7CB0iMDIaR1RDPbcVhzDPoUlU
	 /yZ3O2a5N2nbdR8oYqmpncHjbEpzFMcmGWOhegD/gDJH4WT6iD4N4gC1MTkvrOF+28
	 vAB4w8by7FB+KHXgQbSV4CSRZ4FOIPaa3PxbrwwXt11YkKwp/tYr3+H40RololQx3H
	 Bqn0xN80xS3Bg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 1055960056;
	Tue, 10 Nov 2026 14:10:41 +0100 (CET)
Date: Tue, 10 Nov 2026 14:10:38 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: JiangJieHua <jiangjiehua1@huawei.com>
Cc: Paul Moore <paul@paul-moore.com>, audit@vger.kernel.org,
	linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
	Ricardo Robaina <rrobaina@redhat.com>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, zhangchangzhong@huawei.com
Subject: Re: [PATCH] audit: fix incomplete NETFILTER_PKT records and return
 void
Message-ID: <avMXzjF9hIcTVc9c@chamomile>
References: <20261110122939.45373-1-jiangjiehua1@huawei.com>
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
In-Reply-To: <20261110122939.45373-1-jiangjiehua1@huawei.com>

Hi,

On Tue, Nov 10, 2026 at 08:29:39PM +0800, JiangJieHua wrote:
> Commit f19590b07cb6 ("audit: add audit_log_nf_skb helper function") and
> commit 15b0c43aa621 ("audit: include source and destination ports to
> NETFILTER_PKT") introduced audit_log_nf_skb() and its transport header
> parsing.

I guess conntrack is not enough in your scenario. How does your
ruleset look like?

More comments below.

> The helper returned early with -ENOMEM when skb_header_pointer() failed for
> the network header, and the later port parsing did the same for the
> transport header.  Such an early return skips the remaining fields, so the
> NETFILTER_PKT record is emitted with only "mark=" and without the address
> and protocol fields.
> 
> Log the address and protocol once the network header is available, and
> route the error paths through placeholder logging: a missing network header
> logs "saddr=? daddr=? proto=-1", as the pre-refactoring callers did, and a
> transport header that cannot be read where one is expected logs
> "sport=? dport=?".  The same "proto=-1" placeholder is used for an
> unknown bridge ethertype and an unknown nfproto, which previously printed
> "proto=?".
> 
> Validate the IP version and the IPv4 header length, since bridge packets
> can reach the audit hook without the receive path validating them.  Locate
> the transport header from the network header instead of relying on
> skb_transport_offset(), which is not guaranteed to point at the transport
> header.  For IPv4, a non-first fragment or an unreadable transport header
> logs unknown ports; protocols without ports are unaffected.  For IPv6, a
> non-first fragment leaves proto at IPPROTO_FRAGMENT (44) and a negative
> offset from ipv6_skip_exthdr() means the extension header chain cannot be
> parsed; in both cases the transport header is not available, so keep the
> addresses and protocol and do not log ports.
> 
> Both callers ignore the return value (net/netfilter/nft_log.c and
> net/netfilter/xt_AUDIT.c), so make the helper return void instead of
> inventing error codes for a value nobody consumes.
> 
> A packet whose network header cannot be read now logs:
> 
>   before: mark=0x0
>   after:  mark=0x0 saddr=? daddr=? proto=-1
[...]
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 631d6d4a23cf..c5997077a46b 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -2511,8 +2511,8 @@ void audit_log_path_denied(int type, const char *operation)
>  	audit_log_end(ab);
>  }
>  
> -int audit_log_nf_skb(struct audit_buffer *ab,
> -		     const struct sk_buff *skb, u8 nfproto)
> +void audit_log_nf_skb(struct audit_buffer *ab,
> +		      const struct sk_buff *skb, u8 nfproto)
>  {
>  	/* find the IP protocol in the case of NFPROTO_BRIDGE */
>  	if (nfproto == NFPROTO_BRIDGE) {
> @@ -2532,24 +2532,32 @@ int audit_log_nf_skb(struct audit_buffer *ab,
>  	case NFPROTO_IPV4: {
>  		struct iphdr iph;
>  		const struct iphdr *ih;
> +		int thoff;
> +		bool frag;
>  
>  		ih = skb_header_pointer(skb, skb_network_offset(skb),
>  					sizeof(iph), &iph);
>  		if (!ih)
> -			return -ENOMEM;
> +			goto unknown_proto;
> +		if (ih->version != 4 || ih->ihl < 5)
> +			goto unknown_proto;
> +
> +		thoff = skb_network_offset(skb) + ih->ihl * 4;
> +		frag = ntohs(ih->frag_off) & IP_OFFSET;

Are we going to add all these validations everywhere in the code?

So we will have to validate that the IPv4 header is well-formed over
and over again?
