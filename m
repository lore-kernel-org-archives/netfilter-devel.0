Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793658534;
	b=pkAfobm4Xg7fU99ktwxPhAAKCO2BP0gOONTlwSx1gaGJ7SUXDybq/t/bqoKPCsWKLZRb
	 uiyhe8X2hCAwbixi6pFQTqRtOKqZLqajBi3GH3Gm3EcjBzYcwtz+gmBcyK3OtXu/yo6pg
	 MaocyueLx2e+ltfywkWTVElhKL/zc4FWVv18z7+KzBE/WAZPq+0SsuU20cKbyH12kcRZ9
	 rJpwe9f+iNnEnBUOLbRGGZuNw9s6sqxAXqnwEu2t6oW/qCN0rry1RTFZtbu6Nh6iu50Ph
	 TJ3XdY7mqfuQkHu5DlTeeF1OSeoAP4tdVkLtymIz+np1Z8jBrtfur3fZZlRPC3YPDEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793658534;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=wcfjIPLY99vjd52pg2GrXS5VdavMXcgX9u9TknS955Q=;
	b=G7T1UNP+YoFwyJmX8g9lnvdMaDJUpLgkcDDwBgVLzy7Rnv3LmnUREZaGIHwtcAFvcUxJ
	 jkEg2PHZswFgkOWUVLqNJgUrDJSOU6oPf2ShzksvV8IQp29q1efJcV2YOymN+g40zW1TS
	 HjxMQJd4MEQzcMi2Vc2rOhy78ax3xAcAZrbauxOBfeZMibhrEbvFYUkXgadpJR1luteXP
	 cUhurp8SVULyW1w2jM59Wld8XYgkkIBbk8lSUd32I2P9jZhhRnjPzLVVO61IdUlK5nbKx
	 UGiVT/xazPa0RqGpLmSJsx6S+/BAU3wSUOqHW+Ktc3TeZhMDfktQYeeTVttrfSg6mFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=YfN5eW2B;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id A41B5606A324;
	Mon,  2 Nov 2026 22:28:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A41B5606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=YfN5eW2B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793658529;
	bh=wcfjIPLY99vjd52pg2GrXS5VdavMXcgX9u9TknS955Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YfN5eW2BHpTnbaFlualF2KojEVOVShOcWQIEb6poyrsn+tfrfEbCXF9Y/z+NQC+4i
	 nc4ISWTjZoeMVERkWAz0uOeZlsaUPnh8WhtLUCaAZDlSQwZKaXML2AIkGqYGa6kshb
	 b6ZiSeldkDoFAfI/I8owePnvoA/jqcAuKRC+ALM/w0SztJXES38jvsUd4BHoXcdQ3s
	 CsmVNKXR0ZhHFlcUdJ8V5cXYPxA6iaKU0DTxSMDbuDCcZYObBfS4M6vR2RGxMC9xUE
	 P67ze/9g2e6ZbXVdQV+FmysykvqbV3MtmVmGZXbB+PGZJTMjNKXSw3dUF1CkDLhavQ
	 1Ybhbf0dCvaEQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id A4CF76005E;
	Mon,  2 Nov 2026 23:28:49 +0100 (CET)
Date: Mon, 2 Nov 2026 23:28:46 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: zhangmh25@mails.tsinghua.edu.cn
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	coreteam@netfilter.org, stable@vger.kernel.org,
	jianjun@tsinghua.edu.cn
Subject: Re: [PATCH net] netfilter: nf_reject: validate TCP header length
 before sending resets
Message-ID: <aukOnoeRxeMJrOM7@chamomile>
References: <20261102155622.2658789-1-zhangmh25@mails.tsinghua.edu.cn>
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
In-Reply-To: <20261102155622.2658789-1-zhangmh25@mails.tsinghua.edu.cn>

On Mon, Nov 02, 2026 at 11:56:22PM +0800, zhangmh25@mails.tsinghua.edu.cn wrote:
> From: Minghao Zhang <zhangmh25@mails.tsinghua.edu.cn>
> 
> The TCP header validation in both nf_reject_ip_tcphdr_get() and
> nf_reject_ip6_tcphdr_get() checks that the TCP segment is at least
> sizeof(struct tcphdr) long, but does not verify that the header
> length claimed via the data offset is actually present in the packet.
> A peer can send a TCP packet claiming a 60-byte header although only
> the fixed 20-byte header is present.
> 
> The reset generation then computes the ACK number using the claimed
> header length, and the subtraction of the data offset from the TCP
> segment length underflows, producing a wrapped ACK value in the
> generated RST. For a 20-byte segment with doff = 15, ACK bit clear,
> sequence number 0, SYN and FIN clear, the RST carries ack_seq
> 0xffffffd8 instead of a meaningful value.

So a malformed TCP packet brings another malformed TCP packet...

> Reject TCP headers whose data offset is smaller than the fixed header
> or exceeds the available TCP segment length. This prevents generating
> resets with an ACK number derived from an invalid TCP header length.

Maybe, yes. I think TCP conntrack is marking this as invalid?
In that case, only stateless ruleset behind in this way.

> Found during a systematic audit of TCP header validation in the
> netfilter reject paths. Tested in network namespaces with nftables
> "reject with tcp reset" rules: on both IPv4 and IPv6, a probe with
> doff = 15 produced an RST with a wrapped ack_seq; with the fix no
> RST is generated for such packets, while probes with well-formed
> headers still get a correct RST.

Why did your LLM pick the net.git for this?

Then, another option is nf.git, but I don't think this is nf.git
material, maybe nf-next.git is a better target tree for this?

> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Fixes: 764d8a9f2407 ("[NETFILTER]: Add IPv6 REJECT target")
> Reported-by: Minghao Zhang <zhangmh25@mails.tsinghua.edu.cn>
> Reported-by: Jianjun Chen <jianjun@tsinghua.edu.cn>
> Cc: stable@vger.kernel.org
> Signed-off-by: Minghao Zhang <zhangmh25@mails.tsinghua.edu.cn>
> ---
>  net/ipv4/netfilter/nf_reject_ipv4.c | 5 +++++
>  net/ipv6/netfilter/nf_reject_ipv6.c | 5 +++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
> index 59ec465a9..0e8823a7d 100644
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
> +
>  	/* No RST for RST. */
>  	if (oth->rst)
>  		return NULL;
> diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
> index 07cdaa10d..9dc112e50 100644
> --- a/net/ipv6/netfilter/nf_reject_ipv6.c
> +++ b/net/ipv6/netfilter/nf_reject_ipv6.c
> @@ -223,6 +223,11 @@ nf_reject_ip6_tcphdr_get(struct sk_buff *oldskb,
>  	if (otcph == NULL)
>  		return NULL;
>  
> +	/* Reject invalid or truncated TCP headers. */
> +	if (otcph->doff < sizeof(struct tcphdr) / 4 ||
> +	    *otcplen < (otcph->doff << 2))
> +		return NULL;
> +
>  	/* No RST for RST. */
>  	if (otcph->rst) {
>  		pr_debug("RST is set\n");
> -- 
> 2.34.1
> 
