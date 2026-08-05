Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2733E1201
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Aug 2026 07:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785914748; cv=none; b=S804TaJ5izZT5bL97qtEU8G/gcMEPbjeydOqUfAxnYVMDX3O7umUsudPMUANJ4guQkM3mGv8wg0cMsGVJjzBdB2PJD1r2I/0HT4FoFUohXUzo+q/cqsC12Oc28IKnaV6xkFCIvK+CqzrzAC3QLCRbYr0Uwvxs0uJOeCqBV5KRrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785914748; c=relaxed/simple;
	bh=/8Mv1AI8B8h5q/dmK7nmITSjN4hpVuEk++uwNc/Z+/8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mtaic6Eu/8OmqxWuKySAefWnb3voxjoj4auzHD3NtzLsxEEPgCHXekVpt8wQfPevJ6bZ7ONuZ1FpaUjuZfnAuaJwxAaHL4b6Qs3a+5HWk524Cd7+V7YG03nlYIZo18C0iP1cu/0ALTzhRFVAZV9A7peGrJM2w4y2HtM7x6g1nTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=De7/uW+s; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q0FV8Ztd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="De7/uW+s";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q0FV8Ztd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785914745;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=weTz5xMfFtmCj3eZsPtup6Hy3D3peSbc8vAfiLIUMAU=;
	b=De7/uW+sOdJfcgaRZFAtlCYF9808xCVgux/Pfn3IQlde7niBhyx+Cxo+bFDZ8jYCQs9odT
	Fuq5SmqRNo+GVePdRklOjJW4RMIbZzJadyxGOaOq2VmNgjVqXmfjOY6F8FSJ8+c70ij+Ip
	PYFYEMbZZHYsco/kiYtxXaVsEy1NHZA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-TJ-UtYhFMayaTEESnwb-8w-1; Wed, 05 Aug 2026 03:25:29 -0400
X-MC-Unique: TJ-UtYhFMayaTEESnwb-8w-1
X-Mimecast-MFC-AGG-ID: TJ-UtYhFMayaTEESnwb-8w_1785914728
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4955ce558d8so6026285e9.3
        for <netfilter-devel@vger.kernel.org>; Wed, 05 Aug 2026 00:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1785914728; x=1786519528; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=weTz5xMfFtmCj3eZsPtup6Hy3D3peSbc8vAfiLIUMAU=;
        b=Q0FV8ZtdVIu91NkIbgsL9TD6rN+BrysuEDzZSBjv8ubCA/uGVPq42g1Lo74TmqgiyN
         C9eq5JkD7SSjKAn0tzlB9/VuoRFn3pX3hpLc3vuUQww1j/+Zh90vppHvVio6OKXlEl5B
         wionqDl3FJxIx0CipioWtXbq0ano72L6tDJ+0pCrpGPZX1C2TtHESoPTrik+5ICYqKiI
         Ieq6rvjqYcdiq4VifuMfsr8xVNiyqvs15DeY0Rznptztf3KLINZV2rluY6R7nxMbBasg
         qMXLQnHHz04X/gPC4Y3yHj/0YUxKEKB+BHCLULk56+6Zgv3x4FEnxvo33a2E80j1SoLI
         JYhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785914728; x=1786519528;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=weTz5xMfFtmCj3eZsPtup6Hy3D3peSbc8vAfiLIUMAU=;
        b=QPyFIH/ynTes5PIPHa6VrQLYOVCfqCMQNLFTgfipZloIKaynnYCV7lTnqyjnfOVf2P
         1lFL1RX7ZiWZsfWlRjrKi7FcF/V1klKj8wjbxXNc1PKDLvSvmgMOL2cqN9X/4AKxvbA6
         ZtGWXwWDh+cD786OlopkeOmKXtVio2u07O6lfwLLn2JpkEPgahucKsKjnWM7iBBQV3dr
         E9DunjBeggeu3ikr0k0E562a71nkX82IM3JT1rIhc3syTl1DH8Yakc3/0dfFcqwLjAIq
         mSccYOG9HBCqegwEIh+vwmRcDP5biXCvP/7uWT1WRgfyGGmdDfGNXhY4xJwGaw12gQ3g
         3HPQ==
X-Forwarded-Encrypted: i=1; AHgh+RqqlTaaHbCT+4rQSLM93QGPrHlr7URSj9sdudPMzYWVtVNaag4uTx5sFEsUq06D1M5yqB56WzW9qAHbL36TXPY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyC/dHZiBibqWwY4e/iMysqETAW86wyCwJWQPCmpRjYu1lS8k2
	pSedLbVsvvtF0YbLJAHXQLUFGIpHK9whJuMT4p9lnUHL3BGcXMz2ekcgAkSG9Gz4Mmb8+AIhFol
	HlZXHlhyKo3GMJKYgx4Mg+2v+OkAPtUUFF3O/+1FnRYSovCX5xACQQgdPiANnudZ0pXrilg==
X-Gm-Gg: AR+sD12fCAImwQgYytnmXkBFP2sCeU6Q4RRuOW1KMLPkZx7l3rO/fdCBQokXygQqXgx
	Qnyocjr1RCkabFvotZDconpRNCihauJpdCg1g8/U3LR9mXABVLbQx/FdbxhyIY/VBGcTqyn9Teg
	LkPo1TMGMSFsetZBWJSz9XcZCnL581MWIv0TKHndkOhmWHORPe7ppAaWSeNhmDHvw0IJVKUab6s
	KkYz+BzSE+ilCW4V+LL1XvC+OZBFU6aBP1615AjGDa+kR1W0lVC++tE9NbAtZK5JERVV3V9lXCN
	0ScyBBU1rz9wDcTLxeDDLaPneyxwISHo431IMmNWweDoCBh7rEKp06Rg1PwG47T7RqzwEQdDcNf
	Aj3GitfdTaL/K9A4uLXngaG9FGH1nKG7TOTL8TS3j6dnPmoOE5zyu3RL+Y4vJX6FkW6LCLQSqqp
	M=
X-Received: by 2002:a05:600c:4f83:b0:493:c42e:5be0 with SMTP id 5b1f17b1804b1-4994e6c4194mr53322315e9.0.1785914728300;
        Wed, 05 Aug 2026 00:25:28 -0700 (PDT)
X-Received: by 2002:a05:600c:4f83:b0:493:c42e:5be0 with SMTP id 5b1f17b1804b1-4994e6c4194mr53321845e9.0.1785914727896;
        Wed, 05 Aug 2026 00:25:27 -0700 (PDT)
Received: from [192.168.188.103] (ip239-44-231-195.pool-bba.aruba.it. [195.231.44.239])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4994e03589asm58416655e9.9.2026.08.05.00.25.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2026 00:25:27 -0700 (PDT)
Message-ID: <4c70e63c-3b6d-46a0-bba0-33335f73071a@redhat.com>
Date: Wed, 5 Aug 2026 09:25:26 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 02/10] netfilter: ebt_nflog: pin the NFLOG backend
To: Florian Westphal <fw@strlen.de>, Jakub Kicinski <kuba@kernel.org>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
 davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 horms@kernel.org
References: <20260731151806.849724-3-pablo@netfilter.org>
 <20260805001529.3978646-1-kuba@kernel.org> <anLiOdg5xYKNoNLL@strlen.de>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <anLiOdg5xYKNoNLL@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/5/26 9:11 AM, Florian Westphal wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
>> This is an AI-generated review of your patch. The human sending this
>> email has considered the AI review valid, or at least plausible.
>> ---
>> netfilter: ebt_nflog: pin the NFLOG backend
> 
> We need a way to annotate patches that they have known followups.

Willem used direct command to sashiko after the '---' separator:

https://lore.kernel.org/netdev/20260726202902.760552-8-willemdebruijn.kernel@gmail.com/

and it looks like that would work. I'm not sure if such per patch
annotation fits a PR creation, possibly landing it in the cover letter
would work. At least would work for human reviews.

/P

