Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A786471D1F;
	Fri, 21 Aug 2026 11:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787310022; cv=none; b=gMyshztkRlOwPT0pTQAstltUpE5WwtPDxpvULh7gzCExOS4vKahpkXRwmd8PCfX4EuE5mhnnUMxDoy+RIgnqJqg19W3+k/ndhEn9mT4/QQPrTfi/yleCqXeiE9aXEbAyBY1eYWmCJOSz9P9nX9aQrp6d8JRyv1gA+GE4ccRjyzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787310022; c=relaxed/simple;
	bh=nSJzURZgEJst9KtNRTZEaVsIKU5l3p8zwHSjwCM2ByI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ck2dXCNNpIcwWlNLqTRYTk252do2FswJ7HAJ6odAxhhL+HMT5ianVNuTgUm0n8TDOk7O772HNNkXYfIRV8XBoNqio+2cugnpj//UHDSNkqGW02+EuH43icpQlvvxqjigZ9ytpGa4uYiGctSA06cljcicG1owjyzvNoCFPLFLo9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=v/ZeH0eM; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="v/ZeH0eM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787310017;
	bh=14/Lj7P4QHumhD5L136aLbsxWWeu9dzzJUnun8PpqpA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=v/ZeH0eMWdvA2Bg5hNjCEKEf9pxyU+v/0FBI7WPGkw05l5N+UdnRDN+ejdPk6HTTT
	 gAGbObx2pSccHeqHGHAeU5wgjEkyoDO35853DzrV3U/553geuvSaU/CCA964x+t1AO
	 uCJtmAymRdh0OtWUxnY+CFJP61ShKpn09k7wZs/1+pP/y4ZXldOcZ6zsVt8nqz+ubF
	 4dZU9qSUS5ws0dpsYgif5c74CJPTgm5YZkWIpUXVvIr/2k15/wLCXkEkZAGzZpFvQK
	 86Y1quqFWLXUTe+gYm+pdpMkF67FzMjEHVPZZzU8Xdmp7jNtu23m5C1APeBfLnod5d
	 YHaP5mLKAic4Q==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 4CB476007D;
	Fri, 21 Aug 2026 13:00:17 +0200 (CEST)
Date: Fri, 21 Aug 2026 13:00:13 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: luoqing <l1138897701@163.com>
Cc: Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Phil Sutter <phil@nwl.cc>, Simon Horman <horms@kernel.org>,
	Jing Min Zhao <zhaojignmin@hotmail.com>,
	Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nf_conntrack_h323: fix double cursor
 advance in decode_int()
Message-ID: <aogvvRZuH8j650Oj@chamomile>
References: <20260821065229.121871-1-l1138897701@163.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260821065229.121871-1-l1138897701@163.com>

On Fri, Aug 21, 2026 at 02:52:29PM +0800, luoqing wrote:
> From: Qing Luo <luoqing@kylinos.cn>
> 
> In the CONS case of decode_int(), when the field is actually decoded
> (base is not NULL and the field carries the DECODE attribute),
> get_uint() already advances the bitstream cursor by 'len' bytes.  The
> subsequent unconditional "bs->cur += len" then advances the cursor a
> second time over the same data, so the parser skips 'len' extra bytes.
> 
> All fields following such an integer are decoded from a wrong bit
> position.  This affects the timeToLive field in RAS
> RegistrationRequest/RegistrationConfirm messages: subsequent fields
> (e.g. transport addresses) end up being parsed from arbitrary offsets
> inside the message, so the helper may create expectations based on
> bogus addresses/ports.
> 
> Only advance the cursor manually when get_uint() was not called, so
> that the value bytes are consumed exactly once in either case.

This patch should be targeted at nf-next.

Please, use [PATCH nf-next] given this does not result in a crash.

> Fixes: 5e35941d9901 ("[NETFILTER]: Add H.323 conntrack/NAT helper")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Qing Luo <luoqing@kylinos.cn>
> ---
>  net/netfilter/nf_conntrack_h323_asn1.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
> index 6830c9da3507..a51275cc4d0f 100644
> --- a/net/netfilter/nf_conntrack_h323_asn1.c
> +++ b/net/netfilter/nf_conntrack_h323_asn1.c
> @@ -336,8 +336,9 @@ static int decode_int(struct bitstr *bs, const struct field_t *f,
>  			unsigned int v = get_uint(bs, len) + f->lb;
>  			PRINT(" = %u", v);
>  			*((unsigned int *)(base + f->offset)) = v;
> +		} else {
> +			bs->cur += len;
>  		}
> -		bs->cur += len;
>  		break;
>  	case UNCO:
>  		BYTE_ALIGN(bs);
> -- 
> 2.25.1
> 
