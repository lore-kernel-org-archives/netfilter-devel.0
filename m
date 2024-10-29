Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DE31EF0B7
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Oct 2024 11:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730202231; cv=none; b=FBlgMrBktbkwtprJMtvnC3zMFhhaGVGMQJr6KpgjrZbpY5076MsoOEX0+lJ8Hw9GsdQ4ZViWDdd9z0Mg9OC+PAuFfQ7PD9noXWsSGWEKDBahfAGdE/q7yP+YxUqm5urMuv2Pseey29+Fi+TL2LS5CojoL4m9R5lzwes4j+gsyUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730202231; c=relaxed/simple;
	bh=7FX9hMEDd5CqCVYuT+kD+DXzUW/O7JDLJkDmhIU/WHU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=PEsqg6syIKaetN0n2Vh9FJ+FCnpZJCJeNcuFtH9h5rPZPL0ChsNkjfEqWVOcaPB7f0DUOyQYb7g2TptMRiD/ATedRqVH8zAx9qfKCUHWUeFVm7hKIjYqxaCnqIydjH6BXUe8qme1wFpJmMwXdrvy7x1wHAEMHD1E4CKHweYg5uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U+Q44E5f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U+Q44E5f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730202228;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rX6BijrrS2O7d2gB4josGNcaJMKvlHXTG8s2SjPX2ww=;
	b=U+Q44E5fu71egbiogvIDhW8wzErmJcTeasuzPIVsZBlNnvi/3cYOCPvODWlr5iC9O4zdzT
	avJZJF1glnkQGpEMLjKYt2Oc5r3MiIgjZ9yBkl2MnM8cZBVog3vYZEGn/tqaAiv9QX0JpE
	5Iz7y5pv75zjqoKwshU0SlFOFixurf4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-347-VXN-udEGNaWvlXuw0066Tg-1; Tue, 29 Oct 2024 07:43:47 -0400
X-MC-Unique: VXN-udEGNaWvlXuw0066Tg-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-37d537292d7so3531299f8f.2
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Oct 2024 04:43:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730202226; x=1730807026;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rX6BijrrS2O7d2gB4josGNcaJMKvlHXTG8s2SjPX2ww=;
        b=ZWnlpoBgO1yuaFOTOi/tOLB/CZnypYHhac+RYdzyf76+rQ+aFOYx2cNn1/sxMX72o0
         hABBYx/7Zt0lKVKzWCROKJP6kyMW6XWt42rdExXlXKkdbHNV3cMWnhHgcJ95F6OUUB9N
         FX4WdC+eYL9mlYLM1RNBr+YJorOfavzaDl2DyAVS5oCME4bf5mvpPysM+wwttXQh2z7v
         uw9dKMXgumBpnnReJ3Jz8tORQQquDF+L7HgKeLjsu5B53+NSwFLHfnSVOW4k0m6GfOVf
         9N1FioqUeBKmwNAA1xfqtB85wa6KJYcgm/XaSEu7t12MooA/ckQThYu8FXXABdtlnF7d
         fTQA==
X-Forwarded-Encrypted: i=1; AJvYcCVkwcz+NkHomsiU41GwRwCp0NFTXQAItH5RYva1LP1bUBjhSeyAC7KnpftJe+TI3k1+KW3RKEr8oUtwP3B8Vw4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJ0n8BeTnv1JSag2l2hsKHR4Oo6fXGJaJoKtD5XCL2b/sfyZsT
	k7i/N5pk4I2X50IKz4HWBSoODP4audeU73V9I0cp6K8CRMO8g46qtL2njH7Gua6+8RcnVqJ+RLW
	jjF/NJyHBZ0BFI8II6iK+3fXuLO2JHAr7otsTRHPChsqLtnI3onamsIobsPTR5pndmq5Jfc5hRe
	Wx
X-Received: by 2002:a5d:5508:0:b0:37d:51b7:5e08 with SMTP id ffacd0b85a97d-3806117ea93mr9838376f8f.18.1730202225716;
        Tue, 29 Oct 2024 04:43:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFUW11sieopiskBwtqbuDoiZfsz0mhE/TMdfvrLaJCplcw4NptzH3dwCL5GU49qWJwSmFO3vA==
X-Received: by 2002:a5d:5508:0:b0:37d:51b7:5e08 with SMTP id ffacd0b85a97d-3806117ea93mr9838354f8f.18.1730202225285;
        Tue, 29 Oct 2024 04:43:45 -0700 (PDT)
Received: from [192.168.88.248] (146-241-44-112.dyn.eolo.it. [146.241.44.112])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38058b6f838sm12286162f8f.83.2024.10.29.04.43.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Oct 2024 04:43:44 -0700 (PDT)
Message-ID: <3f194c95-5633-42c2-802a-9a04b4a33a8c@redhat.com>
Date: Tue, 29 Oct 2024 12:43:42 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 net-next 04/14] tcp: extend TCP flags to allow AE
 bit/ACE field
To: chia-yu.chang@nokia-bell-labs.com, netdev@vger.kernel.org,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 dsahern@kernel.org, netfilter-devel@vger.kernel.org, kadlec@netfilter.org,
 coreteam@netfilter.org, pablo@netfilter.org, bpf@vger.kernel.org,
 joel.granados@kernel.org, linux-fsdevel@vger.kernel.org, kees@kernel.org,
 mcgrof@kernel.org, ij@kernel.org, ncardwell@google.com,
 koen.de_schepper@nokia-bell-labs.com, g.white@CableLabs.com,
 ingemar.s.johansson@ericsson.com, mirja.kuehlewind@ericsson.com,
 cheshire@apple.com, rs.ietf@gmx.at, Jason_Livingood@comcast.com,
 vidhi_goel@apple.com
References: <20241021215910.59767-1-chia-yu.chang@nokia-bell-labs.com>
 <20241021215910.59767-5-chia-yu.chang@nokia-bell-labs.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20241021215910.59767-5-chia-yu.chang@nokia-bell-labs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/21/24 23:59, chia-yu.chang@nokia-bell-labs.com wrote:
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 9d3dd101ea71..9fe314a59240 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -2162,7 +2162,8 @@ static void tcp_v4_fill_cb(struct sk_buff *skb, const struct iphdr *iph,
>  	TCP_SKB_CB(skb)->end_seq = (TCP_SKB_CB(skb)->seq + th->syn + th->fin +
>  				    skb->len - th->doff * 4);
>  	TCP_SKB_CB(skb)->ack_seq = ntohl(th->ack_seq);
> -	TCP_SKB_CB(skb)->tcp_flags = tcp_flag_byte(th);
> +	TCP_SKB_CB(skb)->tcp_flags = ntohs(*(__be16 *)&tcp_flag_word(th)) &
> +				     TCPHDR_FLAGS_MASK;

As you access the same 2 bytes even later.

>  	TCP_SKB_CB(skb)->ip_dsfield = ipv4_get_dsfield(iph);
>  	TCP_SKB_CB(skb)->sacked	 = 0;
>  	TCP_SKB_CB(skb)->has_rxtstamp =

[...]
> @@ -1604,7 +1604,7 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
>  	int old_factor;
>  	long limit;
>  	int nlen;
> -	u8 flags;
> +	u16 flags;

Minor nit: please respect the reverse x-mas tree order

Cheers,

Paolo

