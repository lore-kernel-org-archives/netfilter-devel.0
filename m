Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com [209.85.128.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C9213D600
	for <netfilter-devel@vger.kernel.org>; Sun, 10 Nov 2024 11:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731237421; cv=none; b=rd94979mcb3nU6cyHRHSH1YRdEpEp6EHyLjRu6Lp5Wi60CLTXDfI8iSNlNv05F+r6nvy/tf5DjI7UtxGfojjM0kcS9ExMUipp6jQTjXSlRejBXfmNe12xsHqZ3YLgr5/rN9GmZzB9QddU8TqlFBYhgwLrPcmn/GCw+U3hrbq5Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731237421; c=relaxed/simple;
	bh=tpzV2q/50D3760J6uKtweytmsfUzU7l4MS1KnjlHSqg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=BQBMnzI0ur2mPhl4jfwLtxlv+6wF71BVx7wbTvdoRACSNoFv85TZRq6YGOeUCfDz+trLwYgyRn+x9F9UU0xMhwDyw3rBXHYvIdAHLp5ylj6Pc2ktyL1IGTTGZKAtNBp1YLmi3j5gK8OvLu6si3EQhV823z8n1mlO00E4O0JW8C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MQXH8UTg; arc=none smtp.client-ip=209.85.128.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MQXH8UTg"
Received: by mail-wm1-f67.google.com with SMTP id 5b1f17b1804b1-43193678216so34366805e9.0
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Nov 2024 03:16:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731237418; x=1731842218; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3w6Ve//DovfLrFxkEMYSPB+GqT7SVpJIvOnce0hUe5A=;
        b=MQXH8UTgMmojgayZ79bcElpfGoUg9HIQuSdj2AhSuCS2pdvMI4IT4eKiYdAup1Qj7H
         qfLcU689x7SMEXUu1Q7oJNtkzimwLB20KqprnRgZYLSP1nHosdmgkIWmNQLteJ4HUHKr
         tVG6O+1tbS0yGVz/mKoD6bgl7InVCvduDF5VFvXanjcXZahZgGX1wF7Midp+cUapUMzE
         3rc63CCozkZIe+WYP7ZgOGz2grp8o5AjpNl8e7Gen1n5sx2TV8FRjqiiMYMfb1kiKUzn
         kCWJB7g0DXo5opP4KjlcKFOTivF2a/iPlWd7hKfMoZGgCjeZzYQI5FTd/9lMopmDnPYE
         WnPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731237418; x=1731842218;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3w6Ve//DovfLrFxkEMYSPB+GqT7SVpJIvOnce0hUe5A=;
        b=iI/ULNSUcdNvARhajttoH1baSaXBe9YwH2SzeOoELMWiIYDHgeQ5IColH5Oxla6PQm
         FllnA0VKfTED/zDKR2tOh+Op4tCeYpNcBO1FMHo2ZFbTiICyv/HafnVR8a1GPO/ep0CF
         evz82Dr4ppqEOXWxOfKQ8BLIl5rRIHfCXRMHtksy8pRzHSZ1FAJPxMCsbXZ/D2i1uwZQ
         hNL4qSYY4Eb65CO9bJdGOhp0vl4Sv+76iPr9rfQuNeHbzqI9rhAPYT85v37EOBR3Og3d
         pVsVgZgLlp6HtNYN/rEM65JhORf4e4Y9wq6GnXkXHJtq4ScZobmrr3n24p67ZlIbBg+z
         BqwQ==
X-Forwarded-Encrypted: i=1; AJvYcCVdAi3ciAVDovlN0+9lY9lzZ27hcSXqwmz2j/a8Qrwkssq/5+w1QaZX/ELUbIsAlBpU59WhHR4a89Trw7n+jiQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVtxrKaGdo0pTn50hXsGfyVIVu96b2iWqQP2vgdEw9tXIPU6RT
	6+nd6EqdGPJZdVKZXnwJso9COOY50y+tHlH4w9+6ZyVq1V21Sef1dn0jEA/t5sM=
X-Google-Smtp-Source: AGHT+IEpxoOOpKWXGZTpyJk07IvY4K3qEPn5njX8ML6walu2l2kv3UOWuO0yORDo0uQ7KzZS3zMM1g==
X-Received: by 2002:a5d:5f41:0:b0:37d:4f1b:35d with SMTP id ffacd0b85a97d-381f188c1d7mr7489496f8f.48.1731237417671;
        Sun, 10 Nov 2024 03:16:57 -0800 (PST)
Received: from [10.202.64.22] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21177de0872sm58427905ad.110.2024.11.10.03.16.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Nov 2024 03:16:57 -0800 (PST)
Message-ID: <636e7228-2848-4507-84ec-be62d0e8b9a4@suse.com>
Date: Sun, 10 Nov 2024 19:16:47 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] nf_conntrack_proto_udp: Set ASSURED for NAT_CLASH entries
 to avoid packets dropped
From: Yadan Fan <ydfan@suse.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>, netfilter-devel@vger.kernel.org,
 Michal Kubecek <mkubecek@suse.de>, Hannes Reinecke <hare@kernel.org>
References: <fd991e87-a97b-49af-892f-685b93833bd8@suse.com>
Content-Language: en-US
In-Reply-To: <fd991e87-a97b-49af-892f-685b93833bd8@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

This patch is still not processed further:

https://patchwork.ozlabs.org/project/netfilter-devel/list/?submitter=89472

May I ask when this patch is planed to be merged?

Thanks,
Yadan Fan

On 10/10/24 20:19, Yadan Fan wrote:
> c46172147ebb brought the logic that never setting ASSURED to drop NAT_CLASH replies
> in case server is very busy and early_drop logic kicks in.
> 
> However, this will drop all subsequent UDP packets that sent through multiple threads
> of application, we already had a customer reported this issue that impacts their business,
> so deleting this logic to avoid this issue at the moment.
> 
> Fixes: c46172147ebb ("netfilter: conntrack: do not auto-delete clash entries on reply")
> 
> Signed-off-by: Yadan Fan <ydfan@suse.com>
> ---
>  net/netfilter/nf_conntrack_proto_udp.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
> index 0030fbe8885c..def3e06430eb 100644
> --- a/net/netfilter/nf_conntrack_proto_udp.c
> +++ b/net/netfilter/nf_conntrack_proto_udp.c
> @@ -116,10 +116,6 @@ int nf_conntrack_udp_packet(struct nf_conn *ct,
>  
>  		nf_ct_refresh_acct(ct, ctinfo, skb, extra);
>  
> -		/* never set ASSURED for IPS_NAT_CLASH, they time out soon */
> -		if (unlikely((status & IPS_NAT_CLASH)))
> -			return NF_ACCEPT;
> -
>  		/* Also, more likely to be important, and not a probe */
>  		if (stream && !test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
>  			nf_conntrack_event_cache(IPCT_ASSURED, ct);

-- 
Yadan Fan,
SUSE L3
