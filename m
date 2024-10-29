Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3654205E25
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Oct 2024 12:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730203439; cv=none; b=stmDOfH+YKcY2uAxNqJ06/aT5qj2nT5nAJOOdB/7n/piQZywiDHuavA4erbnJkWCMmScBn0uBBP8AQMfypG/d1EGNfjQeU90OyACR0G9zQhVV5M5uzFQ0PK9EXRTyxwmqWlnhri+VhXx3mOQm8/J9wIcE1MeQboBizSYwBkav8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730203439; c=relaxed/simple;
	bh=5GK+Y0dlDBq0HgZlK8ImIyrIBS7uZXbPH4s+H2rROCw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=TBWrTRWn/phnACwnJ5TX8/AeqYXSu1nc8tkcA5RP4MZIWFxXK2AtTscKo/p5v1tyxcVjydRKUmrsc0foQu2v8zFvncS9BiNLw9dwPDq1HhAnhvA0iZSjpFGzHwEgx4la3t5Ca05fSAkTtmGIluN78qN1UphD3H4H9VdubkrBGKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CgtlgiVX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CgtlgiVX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730203436;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RsrenDUXhbziRmlRR2s/iOkAhRnLqKHn+/ZPEctWEQI=;
	b=CgtlgiVXKVxrYXe6XbVpCodWnUUj2p6bxJbn/8En12nLKTAtqbmO19u7KPgpbybOMQdOaW
	qJCSdCYGadTZUtrPzcxtCD5w+o6zyK7E/Dmv1ySA6IPQrnBaoyNTPo/vpjqomUSqRNR2Lv
	ep9vPv9htxrlXGUxiFvr90c/GZiF2wE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-rfkjNsN0NM-kcnIRMVJyXA-1; Tue, 29 Oct 2024 08:03:54 -0400
X-MC-Unique: rfkjNsN0NM-kcnIRMVJyXA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-37d5016d21eso2613492f8f.3
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Oct 2024 05:03:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730203433; x=1730808233;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RsrenDUXhbziRmlRR2s/iOkAhRnLqKHn+/ZPEctWEQI=;
        b=ftOuD9vrnfAE3OlQzegHXYupXIA5WsJBQr5ryE/xw3BQi4uRvCDj/gvuSxk3QH6gwB
         XLxNWAz/euKrQtUpuBp45a3cWasJF75JKzfZdgQGAfIOko1WVvG6Nre4yq7uF2rfW9iy
         GjLyOTOyO0Lz6eqxAQOy8dSHktWdnu4yIWtlruz5DJtFU2yi/6oiArfGjUKKV44gwf9B
         FAwDxUGGoGfBFOT7zJQRIOA898egVUsCz6B4w2DWaobvf3DtIfEOBDDwTxsgcVJQ6IrF
         uwOn8uIszyjl64VnSra/CHxuFnfsu2h4SgG7Smop/Gt74u9oze6gMsJO08eSvoyohaod
         9Yug==
X-Forwarded-Encrypted: i=1; AJvYcCULjFo3IsszHm9OctO0oW+aaRMvliwN+GGt0DjKjt/hYifbMlnDeFHs6ctQrwYb7aDlMYyfat8hl0XHOTZeumg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRiHcUbtF1X5wN61J/hUfbzUB/AfWhtXi0kMlL5Jn+yqbdj/JX
	R2dQqyPuseTxgX32Lb4N2MiVHUJh8rpEIBqyHvjLAeEpzoa4g3bd5aap+gdHT5b3N0nGsoe3ta/
	3GFvyamlRMBqyF3sjuhB1RMZMhFXGqbFK3EXXbXjf+25tlrUJCkeFCA8eKLBxk5T90w==
X-Received: by 2002:a05:6000:12c5:b0:37c:c5be:1121 with SMTP id ffacd0b85a97d-380610f7bb8mr7878154f8f.9.1730203433581;
        Tue, 29 Oct 2024 05:03:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHmcOdbW18dBJkXTSEFyIXIVpI8cKVb7n72/NXV2aGY+gIgo8rSiQfqoqQSTFgNlUVg+xeK6Q==
X-Received: by 2002:a05:6000:12c5:b0:37c:c5be:1121 with SMTP id ffacd0b85a97d-380610f7bb8mr7878104f8f.9.1730203433096;
        Tue, 29 Oct 2024 05:03:53 -0700 (PDT)
Received: from [192.168.88.248] (146-241-44-112.dyn.eolo.it. [146.241.44.112])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38058b3c625sm12331743f8f.37.2024.10.29.05.03.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Oct 2024 05:03:52 -0700 (PDT)
Message-ID: <eb04ddfd-6e17-464b-a629-09aed99e2e95@redhat.com>
Date: Tue, 29 Oct 2024 13:03:50 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 net-next 09/14] gro: prevent ACE field corruption &
 better AccECN handling
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
 <20241021215910.59767-10-chia-yu.chang@nokia-bell-labs.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20241021215910.59767-10-chia-yu.chang@nokia-bell-labs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 10/21/24 23:59, chia-yu.chang@nokia-bell-labs.com wrote:
> From: Ilpo Järvinen <ij@kernel.org>
> 
> There are important differences in how the CWR field behaves
> in RFC3168 and AccECN. With AccECN, CWR flag is part of the
> ACE counter and its changes are important so adjust the flags
> changed mask accordingly.
> 
> Also, if CWR is there, set the Accurate ECN GSO flag to avoid
> corrupting CWR flag somewhere.
> 
> Signed-off-by: Ilpo Järvinen <ij@kernel.org>
> Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
> ---
>  net/ipv4/tcp_offload.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
> index 0b05f30e9e5f..f59762d88c38 100644
> --- a/net/ipv4/tcp_offload.c
> +++ b/net/ipv4/tcp_offload.c
> @@ -329,7 +329,7 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb,
>  	th2 = tcp_hdr(p);
>  	flush = (__force int)(flags & TCP_FLAG_CWR);
>  	flush |= (__force int)((flags ^ tcp_flag_word(th2)) &
> -		  ~(TCP_FLAG_CWR | TCP_FLAG_FIN | TCP_FLAG_PSH));
> +		  ~(TCP_FLAG_FIN | TCP_FLAG_PSH));

If I read correctly, if the peer is using RFC3168 and TSO_ECN, GRO will
now pump into the stack twice the number of packets it was doing prior
to this patch, am I correct?

That is likely causing measurable performance regressions.

>  	flush |= (__force int)(th->ack_seq ^ th2->ack_seq);
>  	for (i = sizeof(*th); i < thlen; i += 4)
>  		flush |= *(u32 *)((u8 *)th + i) ^
> @@ -405,7 +405,7 @@ void tcp_gro_complete(struct sk_buff *skb)
>  	shinfo->gso_segs = NAPI_GRO_CB(skb)->count;
>  
>  	if (th->cwr)
> -		shinfo->gso_type |= SKB_GSO_TCP_ECN;
> +		shinfo->gso_type |= SKB_GSO_TCP_ACCECN;

If this packet is forwarded, it will not leverage TSO anymore - with
current H/W.

I think we need a way to enable this feature conditionally, but I fear
another sysctl will be ugly and the additional conditionals will not be
good for GRO.

Smarter suggestions welcome ;)

Cheers,

Paolo

>  }
>  EXPORT_SYMBOL(tcp_gro_complete);
>  

