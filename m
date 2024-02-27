Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3FC5646F
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Feb 2024 23:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709077787; cv=none; b=MFwOUZjDcZs8EA1xMdQFRM1os34AonH+SDKv1tLFr9sLtudWIo8DULatQEVigN2i46rvDc5nDhQTXuZdzvM+XUrqPwGL0hXTbuyCQnVt9jAJT3h+42yPa2miFYW3DA5UU03Wa3+B0PYclIhlG2mV/lRLBBd8n4E43XKBdMIr7nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709077787; c=relaxed/simple;
	bh=CPcctCg0bv8HQROlnsFZPx6VzrOpx2SOQ7cOuBhiKWE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=PaeGLASq3FB7KVXeVKraHvobNCsu7n1xdXRJcWJbPYexxsmndawjRC/eVWHpVp53nWE0pGo91msatm6pkgNDpZFsQ8Cm5J0yf5EaGxZKAlT8Gf21pq8hCUkWKL/PNVss/yLsO+d9MBoD8RYBXcGQeM3mnvgNlpw7DVmPu7DW9tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rf7Cf-0000Qh-1y; Wed, 28 Feb 2024 00:49:41 +0100
Date: Wed, 28 Feb 2024 00:20:46 +0100
From: Florian Westphal <fw@strlen.de>
To: lena wang <lena.wang@mediatek.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] Add protection for bmp length out of range
Message-ID: <Zd5uTlqVBBFpyjMB@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

lena wang <lena.wang@mediatek.com> wrote:
> UBSAN load reports an exception of BRK#5515 SHIFT_ISSUE:Bitwise shifts
> that are out of bounds for their data type.
> 
> vmlinux   get_bitmap(b=75) + 712
> <net/netfilter/nf_conntrack_h323_asn1.c:0>
> vmlinux   decode_seq(bs=0xFFFFFFD008037000, f=0xFFFFFFD008037018,
> level=134443100) + 1956
> <net/netfilter/nf_conntrack_h323_asn1.c:592>
> vmlinux   decode_choice(base=0xFFFFFFD0080370F0, level=23843636) + 1216
> <net/netfilter/nf_conntrack_h323_asn1.c:814>
> vmlinux   decode_seq(f=0xFFFFFFD0080371A8, level=134443500) + 812
> <net/netfilter/nf_conntrack_h323_asn1.c:576>
> vmlinux   decode_choice(base=0xFFFFFFD008037280, level=0) + 1216
> <net/netfilter/nf_conntrack_h323_asn1.c:814>
> vmlinux   DecodeRasMessage() + 304
> <net/netfilter/nf_conntrack_h323_asn1.c:833>
> vmlinux   ras_help() + 684
> <net/netfilter/nf_conntrack_h323_main.c:1728>
> vmlinux   nf_confirm() + 188
> <net/netfilter/nf_conntrack_proto.c:137>
> vmlinux   ipv4_confirm() + 204
> <net/netfilter/nf_conntrack_proto.c:169>
> vmlinux   nf_hook_entry_hookfn() + 56
> <include/linux/netfilter.h:137>
> vmlinux   nf_hook_slow(s=0) + 156
> <net/netfilter/core.c:584>
> vmlinux   nf_hook(pf=2, hook=1, sk=0, outdev=0) + 748
> <include/linux/netfilter.h:254>
> vmlinux   NF_HOOK(pf=2, hook=1, sk=0, out=0) + 748
> <include/linux/netfilter.h:297>
> vmlinux   ip_local_deliver() + 1072
> <net/ipv4/ip_input.c:252>
> vmlinux   dst_input() + 64
> <include/net/dst.h:443>
> vmlinux   ip_rcv_finish(sk=0) + 120
> <net/ipv4/ip_input.c:435>

Can you trim this a bit?  There is no need to have a full stacktrace
in the changelog.

> Due to abnormal data in skb->data, the extension bitmap length
> exceeds 32 when decoding ras message then uses the length to make
> a shift operation. It will change into negative after several loop.
> UBSAN load could detect a negative shift as an undefined behaviour
> and reports exception.
> So we add the protection to avoid the length exceeding 32. Or else
> it will return out of range error and stop decoding.
> 
> Signed-off-by: lena wang <lena.wang@mediatek.com>
> ---
>  net/netfilter/nf_conntrack_h323_asn1.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
>         if (base)
> --
> 2.18.0
> 
> diff --git a/net/netfilter/nf_conntrack_h323_asn1.c
> b/net/netfilter/nf_conntrack_h323_asn1.c
> index e697a824b001..85be1c589ef0 100644
> --- a/net/netfilter/nf_conntrack_h323_asn1.c
> +++ b/net/netfilter/nf_conntrack_h323_asn1.c
> @@ -589,6 +589,8 @@ static int decode_seq(struct bitstr *bs, const
> struct field_t *f,
>         bmp2_len = get_bits(bs, 7) + 1;
>         if (nf_h323_error_boundary(bs, 0, bmp2_len))
>                 return H323_ERROR_BOUND;
> +       if (bmp2_len > 32)
> +               return H323_ERROR_RANGE;
>         bmp2 = get_bitmap(bs, bmp2_len);

There is another get_bitmap call earlier in this function, can
you update that too and submit a v2?

Thanks!
