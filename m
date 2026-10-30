Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793343636;
	b=16lJuN7KkGjIo0F+DRmCunZYAaIf/WDDG5DwHyJJv0vs6bPn6VW8ypORyoVjQl0Vh6/d
	 eGssXd07UeFgbBRMb8/Llp3tg75hRGkugVvbWtMVHQEtnP6EFHAhW4K/TXUwBThsxeeDB
	 sP4dG+w+5F/a/HNXqiV4hEkMIcNUYnFr+Uxyut2trGvhVYXHBsjbqKaVjloVhM5ewOfbM
	 sP4eT3FIlw3yxXW6D5LUQCZBkWihPEKSCyH9i7ajqajLCj7fRcj994tOjkOH5U1cAF1CX
	 rUz4bGSJpT0FEpAZOTkVVIxuWt0zp/TgI/ASu3suGyctEHdx/R7d+TDgLPK6+DTwuBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793343636;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=xTPfZJpm1MzI9vwUoIhie6XDetXcrskmqtWciknXeL4=;
	b=nNgqXa38komshvOE+rHEmi18G2iUZvhQTXDsJO5j/mmOilVWA+PLKUVffUsE8mf6sIcZ
	 CqM8ZR6ERcsJ4QS5TncOTHptCrGqVkXpYcJucijiQ5mDU31O2+81G4PE+XPwzhY5EnE3K
	 bc86hyzq2uDJ56brdbdTOWNU2O1QHbfkQYEFxYdOGE10fEV5pLWKQ0qIFZz47Pmv0uNAa
	 7TZ0wGmoY3sScMI0Te/H61ntujJsNSgq1vfXCc6vahdbTY6GFuZ1jxYi8N7pkqYBkwS4j
	 pB8qtztwWIvW7i5m1X4nc+OCyzmyTnlOj6noJsmH2CNASgDTFq0OKxAAi6fuTKYfCxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BOz2MT11;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5DF606A325
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2026 07:00:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B5DF606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BOz2MT11
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a2167bd087so2272065e9.3
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2026 00:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793343635; x=1793948435; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xTPfZJpm1MzI9vwUoIhie6XDetXcrskmqtWciknXeL4=;
        b=BOz2MT11Tud4kyA4lrm9CHEbIh+XVGbR8zRYohhC15tci4wah261Z9EbUWsGUHE9ZB
         a86lfRY1jnD/GSvoaicRId3LLJxs2aC1PXfVfzqRJlMJ07OCama3aljYiaOw/pi7FrE5
         VYVU1MW1FSmOlGlfsYg5WpFNT4rChl7Y8B14bhxrzqiOgzzDSZ9gqeMK87dxZWqPIr7i
         YK0apjLGUZJdtjB6FLon8drYEFE0owttkuRtCVa568XM935JYMJyfQqbN7SlqYEL7j19
         gbKiNNmAWiso3bC/0jscj94cNtv4s3DO51XD765HLPR5i/C4fnuxUCJwO3VuMxiCnz2L
         S3+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793343635; x=1793948435;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xTPfZJpm1MzI9vwUoIhie6XDetXcrskmqtWciknXeL4=;
        b=hfMptb9zgnI2uEYEIAKz3Ri5wjQpAyRaMXM5pptPiY9/U199JQZ43Y2+Er3BH5kqy8
         PrNOSPA0u9Ai1edXjwiI9s0YmJSHrQAM1YSj4Mb32zN+R3Zmmf+s7Fdx0N8h8Yy58aoj
         F1h6oSQ0mw8gMbdHZlr7WSj+QijoKzmf0flII1prW+UooeAlyLeMCOla9lYrwQQ83Lrb
         flqT7FBKgbRhdXKQVWVPvHCHT5ScR9W4WcIckCnKGvDv+v4YywlIKv1sl+FFWIp2bqtk
         CukNtfsP8YnKPWeUXXvUhQ+3t+LsXLY7RYgAe3BK4xcxFIw0mGVebWGnkEhAifXNAX11
         VKdw==
X-Forwarded-Encrypted: i=1; AKwUvBxoks+TPi1mNYvxl5Q1PWtK1l4l3cETnJd1UPZBZCphZ6qnvDnjPTK+6a40ZBAfOT3P1QF77A+aqwvPE7FcCtI=@vger.kernel.org
X-Gm-Message-State: AFq9FYI7iqN0SAfvdqW4Yl9aAP6lBtTxhlfAoCuViOjiadu6/8Y55DuH
	hDX60pwz/STL/gDVm4HJXXJX7Qt9pZF3tQ+8Yt4UJXGKUpXQ4mcTqN1q2uDDEgS+
X-Gm-Gg: AYBFou3WwO7YpCtJk9JHfxq5aKEtzVt/eIsDmo+ctFoUEcwQvsYM5GZ0s1CwOoCHfOi
	7R3hf/o1vUjwj3brfdLn0XOo7O1tjfFB2FdDTiPd1zxIYuLFTbCm0Dj0KpJwahaQtEkBMImqc+w
	c4teXab+6GaPspv74aZ7LakRSQ6MDoOWuowX03/AIUngi3Mpbnvn0HJGCtDdz5Kdme+Ym3xTteh
	vwIJUnkMu8nlsi0G8fgJ01oVdRP5NgmvG7LdhojEnY72hQXxguMEpOdS/PUU0jiEM567bWW9IFs
	Sq34vxbCwNTwQuweMuhWcTGsYT0SAxjqIwdMhzj6SQQ6nPhCW8l0Gec8YulZaE92RloFw6tuPOz
	Zuly8re2gGCYpIZfsOw/cN4TMrVwuoY29HQ99mj+Y41daKfDXe7QcKHbwouJ9weq15kXz9XeKFT
	gHEhEfqYXHc/On5EaCiLdqhS1tc6kkEsMeGq9QVqYgIevJV6ZSAYkrvRQ/X8/j+BiA4XxO+YHLu
	nt1dya3vcqzPgW/srTSibGbu1eUHxnvU3cWHA/biYdteQYoqTSk1bi82rkqTICNya58PWWLpXF3
	3ucC+HMoeCh+IVLJfpPfdQck5LiKDAGkFGl5tDja+5OKFT07q402izdALhHSx/bbtDeETsbY5JI
	eiApYExIHYoDj
X-Received: by 2002:a05:600c:4e90:b0:4a4:f48e:78fa with SMTP id 5b1f17b1804b1-4ac175669e4mr25449915e9.12.1793343634174;
        Fri, 30 Oct 2026 00:00:34 -0700 (PDT)
Received: from ?IPV6:2a01:cb15:86cb:1100:1bc3:2226:ceb4:c3c8? ([2a01:cb15:86cb:1100:1bc3:2226:ceb4:c3c8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b725a2sm1501193f8f.13.2026.10.30.00.00.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2026 00:00:33 -0700 (PDT)
Message-ID: <e80f4fde-ec36-4fc3-9386-7b8c1053e1bf@gmail.com>
Date: Fri, 30 Oct 2026 08:00:31 +0100
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
Subject: Re: invalid pointer in nf_conntrack
To: Florian Westphal <fw@strlen.de>, =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?=
 <ukleinek@debian.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, 1149525@bugs.debian.org,
 netfilter-devel@vger.kernel.org
References: <179076304109.1376.1522422117778282591.reportbug@bellecote.private.montagnes.net>
 <59d64272-e162-486c-99c2-6f61feead01b@gmail.com> <auDhy6OW5SrGg3jv@monoceros>
 <auMgBQDEedGU8iiT@strlen.de>
Content-Language: en-GB
From: Philip Dodd <orange.spyderman@gmail.com>
In-Reply-To: <auMgBQDEedGU8iiT@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 29/10/2026 11:29, Florian Westphal wrote:
> Uwe Kleine-König <ukleinek@debian.org> wrote:
>> this is about a bug report filed against the Debian 7.2.12 kernel. Further
>> context can be found at https://bugs.debian.org/1149525.
>>
>> Note this is an arm64 machine, and the problem doesn't reproduce on 7.3.
>>
>> On Mon, Oct 26, 2026 at 08:36:01AM +0100, Philip Dodd wrote:
>>> 7.2.12+deb14-arm64 is affected in the same way, reproduced by just loading
>>> the nf_conntrack module shortly after boot.
>>>
>>> After the failure:
>>>      nf_conntrack module use count: 0
>>>      net.netfilter.nf_conntrack_count: 0
>>>      nf_conntrack hashsize: 65536
>>>      /proc/sys/kernel/tainted: 128
>>>
>>> No nf_nat or xt_* modules were loaded.
> If thats the case, why is there a conntrack entry in the first place?
> Is 'enable_hooks' modparam used?

No, I'm not explicitly using |enable_hooks|. Simply running |sudo 
modprobe nf_conntrack|is sufficient to trigger the oops.

For context, I originally encountered the oops shortly after boot during 
normal operation. I narrowed it down to occurring shortly after 
|tailscaled|started, but subsequently found that even with Tailscale 
disabled, simply loading |nf_conntrack|triggers the same oops almost 
immediately; and since I've reproduced this on all the 7.2.x kernels 
I've tested (the versions mentioned earlier in the Debian bug report), 
but also kernels compiled directly from upstream sources.

The same |modprobe nf_conntrack|command does not trigger the oops on 
7.1.x or 7.3.x kernels; Prior to upgrading to the first 7.2.x kernel, 
this host had also been running Tailscale with |nf_conntrack|loaded for 
weeks (at least) without any problems and yesterday, I installed the 
7.3.x kernel packages from Debian experimental and ran Tailscale for an 
extended period without encountering any issues.

So, as far as I can establish, this is an issue specific to the 7.2.x 
series, with the issue no longer reproducible on 7.3.x.


>
> If not, conntrack hooks are not registered so it cannot pick up
> any entries (you need some rules configured that require conntrack
> without that modparam on).
>
> That would imply that hlist_nulls_for_each_entry_rcu() is causing loop
> execution for an empty list.
>
>> The problematic code location is
>>
>> 	if (nf_ct_is_expired(tmp)) {
>>
>> in net/netfilter/nf_conntrack_core.c with
>>
>> 	static inline bool nf_ct_is_expired(const struct nf_conn *ct)
>> 	{
>> 		return (__s32)(READ_ONCE(ct->timeout) - nfct_time_stamp) <= 0;
>> 	}
>>
>> .
>>
>> In assembly that is:
>>
>>      2f78:       9a812000        csel    x0, x0, x1, cs  // cs = hs, nlast
>>      2f7c:       cb1c0000        sub     x0, x0, x28
>>      2f80:       9ada0c00        sdiv    x0, x0, x26
>>      2f84:       8b00039c        add     x28, x28, x0
>>      2f88:       f94042e0        ldr     x0, [x23, #128]
>>      2f8c:       37180300        tbnz    w0, #3, 2fec <gc_worker+0x184>
>>      2f90:       f9400318        ldr     x24, [x24]
>>      2f94:       37000a78        tbnz    w24, #0, 30e0 <gc_worker+0x278>
>>      2f98:       3940df00        ldrb    w0, [x24, #55]
>>      2f9c:       9ba98800        umsubl  x0, w0, w9, x2
>>      2fa0:       8b000317        add     x23, x24, x0
>> *   2fa4:       b9400ae1        ldr     w1, [x23, #8]
>>      2fa8:       f940036b        ldr     x11, [x27]
>>
>> I think the original issue was a few lines above (i.e.
>> ldrb w0, [x24, #55]), because the tripping address was 0000000000010037
>> (with 55 = 0x37). That is in nf_ct_tuplehash_to_ctrack(h).
>>
>> All in all it looks like `h` is invalid.
> Its a garbage address, yes.
>
>> Does that ring a bell? After starring at the code for a while I don't
>> spot the culprit. Also looking over the changes between 7.2.12 and 7.3
>> I don't spot a suspicious commit.
> Never seen this before.
