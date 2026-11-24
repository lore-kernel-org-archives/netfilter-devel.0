Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795527845;
	b=nCjtZArjndJAdFAU6BTCNbZnw58XHrIW9BM3kViQpxDe2jpcc4xYwLt9jEVX9hrB+w0F
	 O9QphI5s17Pfuk3BDgaGDPuqKu5MDvod/OZVEc7xxxY61j8lb73gDNxhO8C6wAluL9hwn
	 IrUEc8uswWlcPCLV+GGQO7yjMkwcTrqwcjZZ1gvKJnA7/BaAhdbuMQt/UJuzcGEQgtJzu
	 TWaHq/5e8I9YwTZeqFLPUO6c50JHLzpaN6OPYdiHmkH+A6/RPH+e7tR+TyHAaQRAgLfMr
	 RlcNdesOfowS4BJkZUrGa8ZRyiytPGMFkV1/JSz6Y+lR+30H7sV4ATarvVr4diuA6ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795527845;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=rl/I+Qzj9uGsWdPg0dzGTE6b4xUU00vjT3Vxw5BJD2Y=;
	b=P8HbAWNsPo6ZNmdTmiBmNNJlo6X5KKFImYOdF1f43PKT8HjJ3PX0S7IzNoVl+EZDK/an
	 oNQZ7zngBe3BIk5NQFASWKJ/toPAtt9OxoP1W+hEuigLDi8DxuliNi16XNYyJcU2kx8mM
	 TfxbshfI94UGwfTqo4CH54aUpIKTZ7fwtUsknB4f3SG3u+ccJGtN7g+HmoHENsTHmu1Di
	 xW81qTFtBiLfeJNcjoQy2DWgHcppWRR+9AmY4MZWCeh6692nwJl6NRMhvKPXU3F1y1Hk4
	 puCPMs1YgDaTk/ZIOnvJyW2g0BBLj7tdgsq7fp951Wiw17BRVlWFjCDSUwaFdN1OnLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZyjvDxQG;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=k2Ot8vSf;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36627606A321
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2026 13:44:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36627606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZyjvDxQG;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=k2Ot8vSf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795527842;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rl/I+Qzj9uGsWdPg0dzGTE6b4xUU00vjT3Vxw5BJD2Y=;
	b=ZyjvDxQGDqBOTuzWylmR9viuDTJUyembhh3DJNPKU6z5H4pZfRNBGCUqpnSpaFxBSrywen
	ZK6QbntntgcCUgnK6LS7Nb5wPJg9KZFia0bVbhKdiwD+ge38U+RnLOMHGLj8nKCmt7Sp1P
	jH1LxjnrUB5CJMk7DE9OJ08+I78NerE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-389-NUHIX2jTOKyZezYSJNifNQ-1; Tue, 24 Nov 2026 13:43:57 +0000
X-MC-Unique: NUHIX2jTOKyZezYSJNifNQ-1
X-Mimecast-MFC-AGG-ID: NUHIX2jTOKyZezYSJNifNQ_1795527836
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4ab341c0696so1326711f8f.0
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2026 05:43:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795527836; x=1796132636; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rl/I+Qzj9uGsWdPg0dzGTE6b4xUU00vjT3Vxw5BJD2Y=;
        b=k2Ot8vSfeYlBhjaIYYuMR+UjqxML7Oxx+f480QrZxs2eMF/sIB4xrgX7ujxOYycRg8
         s7tupaXGjXK9u4Rngfi5Vrm462YpLJz1ilokba/9MZZQ16e9uLtU02y6mCj/5rkw5PGB
         r1qPs9enpj4KWutw4koIr5Rz9BlaqSlAWocjhF2sRPMlQXrqL/BhR8eOl1m/hWnT5b3l
         hAHW/bA8we1ixSIDpOT3O3Vxdi1t8fuuOSd7crVYBfQ2A4PbyDUO64qg4NgHrk25V5pM
         3RS1nkB8jB5Pp1/iSYnrOHcAU2XyoSkPEcMrtJauEdaE8nI2F8RJ82LXnwsmiLZQgfnl
         tDgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795527836; x=1796132636;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rl/I+Qzj9uGsWdPg0dzGTE6b4xUU00vjT3Vxw5BJD2Y=;
        b=WeNPusBK719oDNbvWD81mraE0l6M3xV7+UnAOJd4VDxxr4w+ESJNSktfFaSx8J4Egz
         YpRUHrZ+tgHVcxZ0soDKcg22DAFAYILkscfP9H4b7nwC4WMKGqZSGKW0jBvgE2UNA3Zn
         jCRUaAvNwrDSkpJ/Eu2J1eya0bThrOgtXazlo4vHp6cFgzsuGw4rhNy75af3G/Ie6A9E
         +sv33vnnoV/OnGwMijikl2TP4N7pC43pQs7w/EpCMwkBHK3p5NqtMieFZc4bkVqMsfQi
         Wgzm4wlE1CFxlA/SL3gGeeayMQsnBW0J1DahCtlbDssI2S6SKXFquf7TvM9e2xmIDdzn
         c7rg==
X-Gm-Message-State: APuU4Z/JMu1WtO/tfeg2+PRpYqy9v5TZDkYCQShdqJwLa/jmJWCorgLF
	/BpY9ATOmV+sxHjgicSNO130j5wm7JJIRGtBrKKrNcJWirvKJ/jSgVb+r+TTY5+psCgiMPoZpT6
	TOdUn9kSjhtKLx8+mzv7nKQq0Yt9k3ZMIF5f32uZj5UjUyeQn4LEYv0Bo9OIwNa6uV0r+jQzsQf
	JZvg==
X-Gm-Gg: AZFdTZf4GKk0kklk1cTNTaXqM/u/K1btFmabZ/8r9U5I+0uQoHB/aLlvh4ALEOrvPq7
	HnYXfKpgrCTf84D/jVJQbmGiVjOO6ia26gXYIeAy/5SEEHSZeoJDU+WxAZFjeh9NjdnX2GLWVDC
	zcxFzwPpOiQDsZzyF4tFEUqZ88dQFyp9CQkUUH+PwqJfVY2eLZDyHx1uHBPwG9K4ZgkhYNBUosV
	sFOPGz8h7GazxrhPbm8ESZbIbOg6sObXqHrr80LidIimrHCwKwEAPPI6LSLbLZ4c5DFrgiTZob6
	oMQX7CqIHQp+7YZ1sM/WyqC5Wt4tyrEEnBKKXlxKm4vVK0FPVmj5zuoaLuRht3MOOSVENfYJJl9
	YRY9Kg4sptSFFkWUqO++yzu+/WcnL2N8a0Q9zc/qbYK+u/POhD7d/nwDgYZ7e0lTTHC4xj/Xx7R
	BKmVxYA55y/OJA9DR5TDlTpJh72Tq9yVos9F1qeb9mfgiS
X-Received: by 2002:a05:6000:29c6:b0:49b:b93d:9631 with SMTP id ffacd0b85a97d-4abb4b85a51mr20666623f8f.48.1795527836012;
        Tue, 24 Nov 2026 05:43:56 -0800 (PST)
X-Received: by 2002:a05:6000:29c6:b0:49b:b93d:9631 with SMTP id ffacd0b85a97d-4abb4b85a51mr20666573f8f.48.1795527835548;
        Tue, 24 Nov 2026 05:43:55 -0800 (PST)
Received: from [192.168.88.30] (ip231-128-192-82.pool-bba.aruba.it. [82.192.128.231])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab69bf680fsm32111230f8f.14.2026.11.24.05.43.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2026 05:43:55 -0800 (PST)
Message-ID: <f0a3c071-0142-4c62-b74b-ffff8121c8d9@redhat.com>
Date: Tue, 24 Nov 2026 14:43:53 +0100
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next,v2 00/15] Netfilter updates for net-next
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, edumazet@kernel.org,
 horms@kernel.org, fw@strlen.de, ja@ssi.bg
References: <20261123135726.3940688-1-pablo@netfilter.org>
 <8e69f35e-73fb-4558-910b-45f5e723c64a@redhat.com>
 <awWSHujeBmMMOonS@chamomile>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <awWSHujeBmMMOonS@chamomile>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/24/26 14:33, Pablo Neira Ayuso wrote:
> Hi Paolo,
> 
> On Tue, Nov 24, 2026 at 01:27:35PM +0100, Paolo Abeni wrote:
>> On 11/23/26 14:57, Pablo Neira Ayuso wrote:
>>> v2: address cover letter errata.
>>>
>>> -o-
>>>
>>> Hi,
>>>
>>> The following batch contains Netfilter updates for net-next. This is
>>> composed of four groups:
>>>
>>> 1) Patch 1 addresses a race in the nf_conntrack_buckets sysctl handler,
>>>      that has been reported by LLM. From Fernando F. Mancera.
>>>
>>> 2) Patches from 2 to 7: This is a conntrack hardening series to address
>>>      LLM reports of the issues related to skbuff mangling while a ct is
>>>      already present, leading to mismatch protocol numbers, ie. ct becomes
>>>      stale since it does not represent this skbuff. This is unlikely to
>>>      happen in a real world. From Florian Westphal.
>>>
>>> 3) Patch 8 updates nft_synproxy to address SYN and ACK packets only, just
>>>      like ip{6}t_SYNPROXY does. From Fernando F. Mancera.
>>>
>>> 4) Patch 9 validate hook priority so nft_ct template is narrowed down
>>>      to be used where it makes sense. From Florian Westphal.
>>>
>>> 5) The ipset hash types conversion to rhashtable, including a new
>>>      rhashtable helper function to flush and destroy the hashtable.
>>>      This is a rework that aims at fixing the existing resize races in
>>>      the ipset hash type, which has triggered a myriad of LLM patches
>>>      addressing the symptoms but not the core issue. This large so
>>>      we prefer net-next for these series. Series from Florian Westphal,
>>>      plus one patch for rhashtable to add a flush and destroy helper
>>>      function by Herbert Xu.
>>>
>>> Please, pull these changes from:
>>>
>>>     git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-26-11-23
>>>
>> Unfortunately a couple of in-flight nf patches prevent the CI from
>> picking this series:
>>
>> https://lore.kernel.org/all/20261120111910.67379-1-juny24602@gmail.com/
>> https://lore.kernel.org/all/20261121212037.149722-1-omermetekaya0@gmail.com/
>>
>> Could you please re-post it? thanks!
> 
> Just a verbatim repost?

Yes.

>> (Do I recall correctly that guidance for nf patches is to not CC netdev?)
> 
> So CI is picking in-flight patches that were Cc'ed to netdev@?

Yes, CI tries to pick everything that lands in the netdev PW, which in
turn is everything that land on the ML and looks like a patch.
> I just want to understand if I did anything wrong.

AFAICS, nothing. It was just an unfortunate over the air collision.

/P

