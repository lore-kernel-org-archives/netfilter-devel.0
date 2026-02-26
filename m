Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F613290A8
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Feb 2026 17:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772126399; cv=none; b=H8q2Ep/9W/eadt4HZFVoFmNyr2srATiWzSUA8FdQvUFyGY4oCWrL8HKUG/U1wN4ZuW7rukpAQuCOXMjR+yMeJ49VcJrcaooUfphUvj2CuwmfCvDiTBixpBO9Y9tpmwkUFXamAHuYUzHqR+FMFwcielr3bVOXm4/awj7uyxWTO7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772126399; c=relaxed/simple;
	bh=439dE7sFUE8Ylr/hcP7uv5Gr5kbWRamHCpjN1hMqb0Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m+8AdxFWtyejog7o18fxZcidr/ZoK/5XxbJH85KMr31AEbCiP7/1Ha8iFFCG6sEj7/ZY3XbysY5HPKaqjuknJD3nDFd9pJamb3VNnjQbKifbWcvE7opkTV3YrgT1WV04EXp0tgzNyGaE595BWHRd1mbj2v2sHqmR9KHN8BmbaoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=byF8qcdr; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=CpNI2wOv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="byF8qcdr";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="CpNI2wOv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772126396;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TquABwgtbOZ5KxkpbEKIOiEEuQnLW+9e9Fgru6e5Tlg=;
	b=byF8qcdr/knkkoPk73xXlamEJ2pz8ZMmtFPkGGL+nF4fIZ8m+XjxesIfqA/50msoExIS+0
	oP5zdKSTjEZErU0+qqKjo+p8osHQPXWzCl7pd5RJGEq24SGS2cxXzt3WGmAX4DjcA4XgXT
	jSWgP41mCkhrbiOljsmKeai6NLxXHwY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-445-_zrFcqSTPXerX39fHtjjPA-1; Thu, 26 Feb 2026 12:19:54 -0500
X-MC-Unique: _zrFcqSTPXerX39fHtjjPA-1
X-Mimecast-MFC-AGG-ID: _zrFcqSTPXerX39fHtjjPA_1772126393
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4806b12ad3fso9398185e9.0
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Feb 2026 09:19:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772126393; x=1772731193; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TquABwgtbOZ5KxkpbEKIOiEEuQnLW+9e9Fgru6e5Tlg=;
        b=CpNI2wOvlmnrgocQz9Lfk1N0lDohOa+HmGusD8Pcir3iQGKsAxm5cgWU31w/BZKqtV
         155MKgUGyYHQOm9AjptotsjHTHWNUzwVVWDjMJrsoUYhSewTN4KWUMP9ael3h5veALIl
         Xz2B7MHkHTnng3fQ2fCqCQN2IuTH94top9hgAEzCU9WhbUkZA2+oD1WZYBn7jvgj2kuU
         MON3X00R6ClTlwBFKhrSNYDn1I7kL6wy4fNLstfA3va9JbFegbILTZP83Oaf3KVH6LUO
         96iFRoBEwgrOVZTW+TfkQDBg1bUp2gUAE1BB0qef4fFGekF3QegQP/ItXN5QwiN+Eiuk
         rjoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772126393; x=1772731193;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TquABwgtbOZ5KxkpbEKIOiEEuQnLW+9e9Fgru6e5Tlg=;
        b=fW5rjNK+XXQdLj1pItFagVQfFhdMQAeWVhGsow/WgaR1xQEg2QE4mVzIn/JEYlh1O/
         MppPLGirvdc1GawLv3PhkUNeyZmBMg/m+CkAGhFD6xbvINlTn0CKODQr77Bph9HJ/A6t
         cFz9C4nhGalL1Rzwros2ORnQZsc7zt2gg1qmuL/4h8qR6jlfSXrdrQGBYz6r/t23pitS
         JeaoKVLreyZ/9OqBAhW7pdKeEfgAhTSvFA6A3FD1uuqGY/palC8M65IkRJE17xLPpzJE
         cjnVRww8+ltjZ82Vdn4IJVdTC9lSbHT3Hunr4N8cEC8YqnMBs3kREiEB165KLj+LeyMN
         hvUw==
X-Forwarded-Encrypted: i=1; AJvYcCUXWmODINxG8A8QNzE9/yys457TVYxD8GenS91CKOA+ONqbzOjikGvwUjSLPALcDo46ub4qcGpehGa3zHpGM0k=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQIWVGFot83pn1Ia4vfWjVnOaXNX2TMRR/UdgooHHUnQ4+131M
	mFo7DQTRp0dkgfHOb+dhxWWGL9QtQ75RbhqGzn6yR0owpKb/bfGecvZBB9/2DcK4q3/XuSylijN
	LEb2xYT1Cwe9elZDPXsDG4KNEpcYAvRi6Dn8ORcpgqp5gwbhNgF/PBG3ub/nPAJ/D6t3flA==
X-Gm-Gg: ATEYQzw4hatSk7rOl70McnDL1VWu2xIKGaQk/H4cxM7R4yjKhV9/D/jhTy+CEvxM+Hf
	+bn4705CwppcQDsCTCqr5NbRB6NGDeAsMKIOOcWKGCqFkc44PedTzc0w8psvsWsHi/4JfwKyks8
	FbRRblFJWP93oLetKH3X+b/ck8ebSMLpOdcXqt922AR53tGsMLWwsj33dP323uPQaosmtG32ER3
	LiYTgNcjpDAyrisPMKJg/TTqHG/4wFNKh1q28mzgshL1wv2cYujbr4+yq8wueq1cdyLLp/cz1Ft
	/DBWiWp4gzpLgAYoiBGlIfJejkOshE6SyQqPEzZJ+2GiD4kp1ybawSE16d/p5qXYMv3wsU4DETV
	PbdcXn4qEshnuXMW+CHGKxA9/og==
X-Received: by 2002:a05:600c:6217:b0:471:14af:c715 with SMTP id 5b1f17b1804b1-483a95eb550mr327319695e9.3.1772126393344;
        Thu, 26 Feb 2026 09:19:53 -0800 (PST)
X-Received: by 2002:a05:600c:6217:b0:471:14af:c715 with SMTP id 5b1f17b1804b1-483a95eb550mr327319095e9.3.1772126392772;
        Thu, 26 Feb 2026 09:19:52 -0800 (PST)
Received: from [192.168.88.32] ([212.105.149.227])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bfcb4f8bsm104020285e9.4.2026.02.26.09.19.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Feb 2026 09:19:52 -0800 (PST)
Message-ID: <6fd597ff-ab5a-4304-a56d-1a0c9642c194@redhat.com>
Date: Thu, 26 Feb 2026 18:19:51 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [net,2/2] netfilter: nf_tables: unconditionally bump set->nelems
 before insertion
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: Jakub Kicinski <kuba@kernel.org>, edumazet@google.com,
 netfilter-devel@vger.kernel.org, davem@davemloft.net, netdev@vger.kernel.org
References: <20260225130619.1248-3-fw@strlen.de>
 <20260226035628.1827287-1-kuba@kernel.org> <aaACGbUnAyQiV3ut@strlen.de>
 <aaB0kaSgbnSgVFBE@chamomile>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <aaB0kaSgbnSgVFBE@chamomile>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/26/26 5:28 PM, Pablo Neira Ayuso wrote:
> On Thu, Feb 26, 2026 at 09:19:37AM +0100, Florian Westphal wrote:
>> Jakub Kicinski <kuba@kernel.org> wrote:
>>> This is an AI-generated review of your patch. The human sending this
>>> email says "Is this legit?"
>>
>> Looks legit to me.
>>
>>> For local reproduction steps see https://netdev-ai.bots.linux.dev/ai-local.html
>>> ---
>>> netfilter: nf_tables: unconditionally bump set->nelems before insertion
>>>
>>> This commit addresses a race condition where a new element gets published
>>> then removed without waiting for the RCU grace period when the set is full.
>>> The fix moves the nelems increment before insertion and adds cleanup logic
>>> using the abort path to safely unwind the set.
>>>
>>>> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
>>>> index 0c5a4855b97d..834736237b09 100644
>>>> --- a/net/netfilter/nf_tables_api.c
>>>> +++ b/net/netfilter/nf_tables_api.c
>>>> @@ -7171,6 +7171,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
>>>>  	struct nft_data_desc desc;
>>>>  	enum nft_registers dreg;
>>>>  	struct nft_trans *trans;
>>>> +	bool set_full = false;
>>>>  	u64 expiration;
>>>>  	u64 timeout;
>>>>  	int err, i;
>>>> @@ -7462,10 +7463,18 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
>>>>  	if (err < 0)
>>>>  		goto err_elem_free;
>>>>
>>>> +	if (!(flags & NFT_SET_ELEM_CATCHALL)) {
>>>> +		unsigned int max = nft_set_maxsize(set), nelems;
>>>> +
>>>> +		nelems = atomic_inc_return(&set->nelems);
>>>> +		if (nelems > max)
>>>> +			set_full = true;
>>>> +	}
>>>> +
>>>>  	trans = nft_trans_elem_alloc(ctx, NFT_MSG_NEWSETELEM, set);
>>>>  	if (trans == NULL) {
>>>>  		err = -ENOMEM;
>>>> -		goto err_elem_free;
>>>> +		goto err_set_size;
>>>>  	}
>>>>
>>>>  	ext->genmask = nft_genmask_cur(ctx->net);
>>>> @@ -7517,7 +7526,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
>>>>
>>>>  					ue->priv = elem_priv;
>>>>  					nft_trans_commit_list_add_elem(ctx->net, trans);
>>>> -					goto err_elem_free;
>>>> +					goto err_set_size;
>>>>  				}
>>>>  			}
>>>>  		}
>>>> @@ -7535,23 +7544,16 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
>>>>  		goto err_element_clash;
>>>>  	}
>>>>
>>>> -	if (!(flags & NFT_SET_ELEM_CATCHALL)) {
>>>> -		unsigned int max = nft_set_maxsize(set);
>>>> -
>>>> -		if (!atomic_add_unless(&set->nelems, 1, max)) {
>>>> -			err = -ENFILE;
>>>> -			goto err_set_full;
>>>> -		}
>>>> -	}
>>>> -
>>>>  	nft_trans_container_elem(trans)->elems[0].priv = elem.priv;
>>>>  	nft_trans_commit_list_add_elem(ctx->net, trans);
>>>> -	return 0;
>>>>
>>>> -err_set_full:
>>>> -	nft_setelem_remove(ctx->net, set, elem.priv);
>>>> +	return set_full ? -ENFILE : 0;
>>>> +
>>>>  err_element_clash:
>>>>  	kfree(trans);
>>>> +err_set_size:
>>>> +	if (!(flags & NFT_SET_ELEM_CATCHALL) && !set_full)
>>>> +		atomic_dec(&set->nelems);
>>>
>>> Does this properly handle the element update path when the set is full?
>>
>> Pablo, why does that check !set_full?  The increment is unconditional,
>> so why is the decrement asymmetric?
>>
>> err_set_size:
>>         if (!(flags & NFT_SET_ELEM_CATCHALL))
>>                 atomic_dec(&set->nelems);
>>
>> ?
> 
> I think so, this is a leftover from initial patches that where still
> using conditional atomic_add_unless().
> 
> I'm preparing a re-spin.

Please note that patch 1/2 as been already applied to the net tree.

/P

