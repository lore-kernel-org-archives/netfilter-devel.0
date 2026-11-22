Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795348956;
	b=HOkJQI8f/xyIodPY82Sb8NOVVONvQ2H2c82eGn8uk3kVnjz0T2TbAte1hXsGI44/K8Oo
	 jfNRbXzF8Iiv7s6szD0b70ziWG57LtYIr9d801BKUE4m+BfiVQ1PHir9eeqKuSMvOr4KI
	 hQFExvMuS8gweoRrDBwsk8luqVw6nzV4HgmWEaXmP28zJce2gOZ7GG/uzj8Cn3k2UqBDa
	 P53AGZQXYdggvoOFlhzgymZNLzzYrXoV/piK5Pk6bzGKNU7QWqpq5vvxAhBGudDwuRlFw
	 AN7Rh3TxhXv5JIpMEHB8QOidojfKnvj7J85Fgdzj46P3DEeGD42BvWVWH+UFqtwgMgw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795348956;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type;
	bh=jnq/u6zdganm+2HN7xLl1QbJ2GTHXYQe3JfnfpQdzaA=;
	b=RpqkDc6/xQcT+aCgbT34ffifLNsv1UWu0wP6Z2C+uySz+ZmLovsAN7mQBF8US89uH7/G
	 +ZpvsuBLPtG1T5zXo9ftdlHtuDdcgCdxMThxQjy8YQsr/WtI2ogsKv8EkK1KhBXnUgSck
	 p10WKKg9VzdJKNGlP/uoz4wrg2yU2s+hZ3O0x208Yy10GI6pfkP4UpXax2Qe4SHyAz3gN
	 p2lVBGqdDC8N8vJNcd3tOQrSn+pLr50FhxhOxmco128unfRoT5gfJpWxV/yVWWD/ONw9v
	 YvZ0Cbd+oT1xQPFj5Z2e3O6qxWqP1V9gh8YQsZQM7Vf+jterSnWwD1iLTx2K88xTeGA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=s+8Vh9k8;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.45
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7D2606A320
	for <netfilter-devel@vger.kernel.org>; Sun, 22 Nov 2026 12:02:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB7D2606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=s+8Vh9k8
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-67dc7eb1442so2501561d50.0
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Nov 2026 04:02:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795348955; cv=none;
        d=google.com; s=arc-20260327;
        b=XMxr4kIkX5xqRhJ303ZbstpIgdVQdxJBn/i7AFsYvlQ/NXYnyuG9UNJO6HaDgp9iGV
         h2l/MsxQ8mx94q6tOnjQWLoSS3Oi0q4xlbEhh4EoGZZ8aWDutGHaRN2YYHZsUkMhHMhh
         +bYj6uLMzJZEO3MJ7CrniVHNmUunWVrNJRoE/jVn66fpgbzuQg8WTSVTs/cIUrUYtUVk
         +iJRUHPOJb5IbEyxjBVU66NPsJrqIx4i6XVfBk4EQdKTP4VtM7wNrnDaXtyUlTHTeHXh
         l9m4HjeZ27p8WIShhS1nXqlqy+hiY64h/xuFDJ4v9ItIi2qyBZVvllQ1n8mH27jYaN2n
         UUfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=jnq/u6zdganm+2HN7xLl1QbJ2GTHXYQe3JfnfpQdzaA=;
        fh=sWunJObW40wC9mQ4a7QrK/qy7kji+583Qr+lrn42S9U=;
        b=aByRuNifLl2Qy+yYtnRmRQEM2GZxBhFu3MTsIGNjv4XoOdas8cJbRRI+UDXcGRoaYL
         13GmJejxL0s9rvEq7zfenj8GFui13UzS9X8iN7IIboDTo+f1BSjjah3aQnRqDRz6Vpik
         kXxgqPPgaXDn10kEBFiYXQDReBEqopz3VIjohhVRhQd69VzFoLJV7XPI98Ln0wiUdTgZ
         IBaerofVoMwj10VD3qhuedgZ891NKMEHtEnlsae5M8T0hAXPIux53IDJwtCY9G3sSvGU
         19mqpt7snb8S0ctzvcy/AJVjWoMuoD0WUD8y/rQb3870M2807EcJV8dzkNIDk3pNuZi+
         0rzg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1795348955; x=1795953755; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jnq/u6zdganm+2HN7xLl1QbJ2GTHXYQe3JfnfpQdzaA=;
        b=s+8Vh9k8muPmhi851ob4ALsHVgL3c+xjuGj8gKKuxfV1/DygWj7dRcrz15s1vtyUpc
         VqNcvoor2ZijsLhwcBOi9RuaBtRbX+82DXpOUoorEeBtJecrFnbNl4cjNd6NqR50Ct+n
         U9z+kbHdbzVqfQOXq4+Hi120Os0WgbfqQOJ8TquXwKts2knLqhMWplQXDE1toW0nQHg8
         FU9wdLfEY7LHBdtujAyfBxPrL4GSVCsgMN34cVW29KKMT/XNaKefzZxnNbuIV+IFMdXp
         G4u+7bKYq2rZ9Zp5GipxsV2RivDQAKKYXpwmmhR7djtr/vLKUUguSM/6cEXc2OSBJRBv
         Vz2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795348955; x=1795953755;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=jnq/u6zdganm+2HN7xLl1QbJ2GTHXYQe3JfnfpQdzaA=;
        b=w5PI0CV/g+B4/5fVPkeJkfy6YsJhdi9Nw/T2r9GGtYY2a7ww/fTIRVGb5NGc/TUbLa
         GftGYjpOQF1boNrABt6e6S4xa6yBRJIvvZVmmdD4j8gSWaQFiZUUD2wctXS731r3JCG1
         xNAF24L4S+jcugfC50upJbe/nx60rTANjoOPpniSogUqRCrTUuHrujUcK1LxQq+AGHXf
         XLzMLEfqYy5EerK64+oiDpWqPXu1STKt+AwtR9Y5a46vYAOgGu657CmVXm8vpgO6kzVO
         Z3eJMrCPdwgxnJZ0dsSjeCH4/7qcLXEnAB8wPMd5bHQrsr7Af+H3EaexIULV7fTIYeQZ
         MS6g==
X-Gm-Message-State: APuU4Z9cavNTZ/Kt4w/U5UW7N/l+uHeN6cyn5j3fhZYtT+VRKN3e5G9O
	0D6ouiJ9DJGAayvxnQoaF1xp/WnvHh7tsSUJoAnU1TOz7iab1NkjHsQTUvKBgic8b9uUHnIw+f/
	ohzZ/UcawAgquTuWneroxN1xxoe6ctJ4BoiT6FrkqGfeSVLhPTEQA2rtX
X-Gm-Gg: AZFdTZfq7L09uQHG8yEziBh4fqrfJ+63rDTegCOGef/nWhDBuBwyI9DNV2X73+BIArZ
	6UTmQN9Fpw6OzQR+hbkAZIyuN9WKfPkY3a2wAinmwHwA7vACQos9f1DjrlKeqCI8CPBy7LPjn6n
	it6OSJ795CIFE0fAt137FJ25pUNSjq35UOCDXGoBVQD7gKLh/srgdeAtMiOVtamEf9N0LCcIrih
	Aw3enRmFOsP+NhY5j/I+neys8V24V2gj6HRrCLSfUpLshwnB8Gk1G2QvcgRTzJmW3uCpyQ7abDk
	UBTDlH2/McUrSqsy67/+x8nXqvuXqw/Z97peCpygKJuBJFeKraORScaikSuZ8vucxcM0hlDy3nw
	TupX1rpB1ZS67DZMtZNTayMWLh+ch+uqvtQNWlM2f/oTcZeE9DWiZ3iQlEvcsgH1gFOGPMkhdct
	6gj9Xm9JwnzVet5TP93FTb6CGS/6YfYyH+EiirVewsE0Ar+RNpA78PXx9QBMtn+mi8q0M6n1YEQ
	19DNukQJ3/LEvMDiRZLQqAd6JRTKFtnwQPV4wViGCIYm0Uyo+UuReouOL4II2dUle6cjGtDJLsb
	Wie0Eo2tQ+eB5QLNQLp9B0Y3XxV2+rgmfqHNtFsF/pGWWYGL539olDDvbbL5GJX/W2TqdMXYDxk
	+aYDmRdK4gdAkaR7zmDoejyNc1zgDnw==
X-Received: by 2002:a05:690e:150a:b0:67d:ba55:4be2 with SMTP id
 956f58d0204a3-67df448c8acmr3910408d50.84.1795348954949; Sun, 22 Nov 2026
 04:02:34 -0800 (PST)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Julius Bairaktaris <julius@bairaktaris.de>
Date: Sun, 22 Nov 2026 12:02:01 +0000
X-Gm-Features: Aa3M54pH0XPj8PaVHSQQOJG1yc7OI6ojMb4tcH2vVfk07W7DCxGrFZCqrnNjroM
Message-ID: <CAC1t37KnLKSepB-ct5Vjgyi0obL2BuSFnKoVSOCEK2ALWaJGQA@mail.gmail.com>
Subject: Re: [PATCH nf,v6 2/3] netfilter: flowtable: cache destination hw
 address for XMIT_NEIGH type
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, Nov 22, 2026 at 01:57:13AM +0100, Pablo Neira Ayuso wrote:
> > > So you're suggesting nf_flow_dst_check_gc() should run for
> > > FLOW_OFFLOAD_XMIT_DIRECT too?

For a direct tuple that has a dst_cache, yes: the h_dest comparison,
which runs only for XMIT_NEIGH now. A tuple without a dst_cache has no
neighbour to look up.

> > This is what this patch does:
> >
> > [PATCH nf-next] netfilter: flowtable: teardown flow reaching bridge port on fdb updates
> >
> > Until that gets merged, stall is expected.

The fdb check does not see a MAC change: it looks up the old h_dest,
whose entry stays on the same port or ages out, and both keep the flow.
With v11 of the roaming series on top of your v6, the bridge cases with
no tunnel, IPIP and IP6IP6 still stall, 1 run each.

> Ah, I suspect you refer to the XMIT_DIRECT case when hw offload is
> enabled, which indeed have dst/neigh entries.

No, the software flowtable: the tunnel's underlay device is a bridge,
which makes the tuple direct, and flow_offload_fill_route() keeps its
dst_cache because the reply direction has a tunnel.

Julius
