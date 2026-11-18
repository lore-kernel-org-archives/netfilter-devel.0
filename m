Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794973128;
	b=eIVYBcOhbd10yV1hRmcB+usSbVCUU+Lm5Dvrd8T5blg5JcAzo0NMixGch1CY7KcLrbxq
	 xceYq3v38BQwv7Zy6KQcjNAskGHpzQLKiYeuZ0IgUXPBwVU0wc1JcMPMIEjxQ9ow18yHk
	 HAajSjuFgnYe1b0oBNtT3Is9BC+Yuiiw4SLUNa35fRm3vzgW88G3xcCB4fYaDB5tsbHBg
	 vIdOacp5k5BsKxxnqrlpAXq2ntL6LzRBgf4bP0VxRBtg4XB2q5OaE6jz4R5APYc5tuKM4
	 XfyPK4Xi3Kfq2coSpjUvhO9qf0CFX/S8XcPz2aj4tXev93glGGM6NxuQkdQalkmkUrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794973128;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Disposition:Message-ID:User-Agent;
	bh=Kvmn+xw8fMzfurQj4tJUer/fYr30jKP4x1tcbpp4Ht4=;
	b=0Sn6M/wojhLhIXxnR1budXKWGa4U5w8P/34kK3aTcqEXHIAoDRJ1eiHwhj8Lj7L/oxiv
	 38o2Azsc9JHGtVLQhhWPu+cL+anzhc8HAVsOFxMGhx1Mjapu5kvTC4TDM/7pdXnFli1ZP
	 zpL3AgpdROkrvjC6LQ8ol8DVCMx+0yhMOSyaZl0KsgA8Anr2FlUeM/dAuJS94pmKDCLHH
	 DkQJKLPM8fh3yZuX4hDPVOAZlc6kNxCn3s3qmOGpWf+GzGhBtdHmpBvpEXbnOUNWNQvb+
	 AUno2VuIZlhdXLPMhA8BCzWSIxX6pfSFJQW2ej7ojH2qv7EKGc6OGwU7JigTLls3+TQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=IfmRfcsh;
	arc=none smtp.remote-ip=74.125.82.50
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34B6606A325
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 03:38:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E34B6606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=IfmRfcsh
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-14394530ec6so852823c88.1
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 19:38:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794973127; x=1795577927; darn=vger.kernel.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Kvmn+xw8fMzfurQj4tJUer/fYr30jKP4x1tcbpp4Ht4=;
        b=IfmRfcshEf8CC2x8ZQabjNmG5gsCHR8OAyUtXOaUA4Luli9y7mZZBExDxK8bPLb6Zd
         rac2EJ4N6fEvhpBJDmWkpYnWbeIl08HM+7laGQT5cBlru06kB4cFZA9zPjBO34lNREZV
         78QFlxDIg5xGljN2NBs0N5kiQMWyWvSEK4+Dc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794973127; x=1795577927;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kvmn+xw8fMzfurQj4tJUer/fYr30jKP4x1tcbpp4Ht4=;
        b=p4l+KHS0cvF7CL5Rb8ayrJlKTc2NTebJ/8X0m8ModYB38sKjNxY7ByHeJ4FvPeQuoR
         ydxZIvfR1t1kwht1vHUWaQZ7wn6A3LUEjw2k/UkTIHS+hICwwaTHRfHy94PU/9xgi7XB
         X0b++xo/sntV6Ah7YLWe5X2zACuZUQpnU6Ox2nCRl0m+Wlab3WYRFUVkBw9shJLWmx18
         o7FMLWrV5xnzCRspeb+TqdS+Xo4MPmwUZSv8C9yS4NVZoilSta4nLaBtKQ+Vw861QojT
         RtCrMuuxburMMVLfdEsQFhHbJqQIjPWAFbVqer81jzgqsfgWLIXNadZ403B8u3P+KYsU
         44YA==
X-Gm-Message-State: APuU4Z8ks8pT5wJl5W05u1HjwLYODITdUzKe38YajOEMhxGSE+e4U8OG
	eOQCvS4hxWz4gQ77exW++BMeLg1+JV14e/53KK3YBphKJeKFDxulS8D2P9KylLzbiZ8=
X-Gm-Gg: AYBFou2g8tidcrw4e6ENfR6+Y+LCTc9ROVUJOJZnk1kt+C/+aQ6lPivjLwgQMMmmgi2
	UyeCTF/jxpSkz0JCbHpUNgZzQebbNlXIqoUPBXAceiyP8MtN7WgiL4I7aXBjk/4P9aJjBi26lqm
	l9Ymm1FvExS8zRxOehSvUZm/7DiRF6Gk35I7ADFYBOtPyCfciIea/MyvM3WzNe6TrRuQa4eqnv/
	WTV/7nfJ6GrM6KPB4f7RdyuFqvuH/aOMvbWcP2vGuzA6rPqNbytOuuNnQg/PG4/FbXqz39iy0Yv
	va4bS8yWqTBxbUN33KyYM1Jmwe2+r4Ne42UqTTmmpSxR0ogit93fcGG5mrMfm1S2XYkexKeXdu2
	YXnB48GkRXLyaljbSQqU2XLVkm+BL8uZDLo1WcyNvsmk0hrJ/qRGUEsZsdiJ2jDw/dTuQgmqWIv
	LXWDn5aPfDLWgpgdfYA1aF5ZcX+hEFbNYVN7Bwlld4LujgX7575kEbGTNRxWZRhHElZ0FQrglKB
	rkjaAGxBlS9X+NXEdrndCXVay1RtFaW+j5ZqoJVMROG6sZjA3JiNJfxXEpIG3ht40h4zmCednUU
	q9/Y5igvsYISo2kXm/PGrtvk5WOYnq8DSPzNzEfiHGb8VO522NU87UIpwkjnWoSdk8U1de3FIdt
	ib4yhv8J/nrSRcAeE0409w5UFHLVBky5bfgw1KjjafVz3R7j6/31pke2hB7B3rxCW78HtjcsEg+
	nRbkEJv1DbHRNho7WjuyhYiM7kR2ZxsCH3zfIRtOEF0Dq/UR7bY51IRkz/0/lR/164
X-Received: by 2002:a05:7022:fc01:b0:1b5:1a6c:af64 with SMTP id a92af1059eb24-1b543bcd4b2mr1258863c88.17.1794973126774;
        Tue, 17 Nov 2026 19:38:46 -0800 (PST)
Received: from [172.20.0.2] ([172.56.235.113])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-382a63059f8sm4907822eec.9.2026.11.17.19.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 19:38:46 -0800 (PST)
Date: Tue, 17 Nov 2026 19:38:43 -0800
From: Chris Down <chris@chrisdown.name>
To: Alireza Asgari via B4 Relay <devnull+alireza.asgari.net@kernel.org>
Cc: netfilter-devel@vger.kernel.org, linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>, Shuah Khan <shuah@kernel.org>,
	Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>,
	Zhang Jiao <zhangjiao2@cmss.chinamobile.com>, Song Hu <husong@kylinos.cn>,
	cgroups@vger.kernel.org, netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Alireza Asgari <alireza@asgari.net>
Subject: Re: [PATCH RFC nf-next 0/9] netfilter: nfqueue: account queued memory
	and reserve capacity
In-Reply-To: <20261115-b4-nfqueue-memory-accounting-v1-0-b9cc30819997@asgari.net>
References: <20261115-b4-nfqueue-memory-accounting-v1-0-b9cc30819997@asgari.net>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <av0dwzvTBXXLqWCa@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

Hi Alireza,

Alireza Asgari via B4 Relay writes:
>3. Whether the proposed bulk reservation interface is an appropriate MM
>   interface for this use, including the explicit restriction of charged
>   growth to 64-bit kernels. Is this compatibility tradeoff acceptable for
>   the initial interface?

Hmm, I don't think this needs a new interface. obj_cgroup_charge() and
obj_cgroup_uncharge() on the objcg you take at BIND already deal with root
ownership, reparenting and the kmem statistics, which is most of what patch
4 reimplements. They would just need exporting.

>4. Whether non-reclaiming reservation growth is the desired failure policy.

I don't think so. A long-running cgroup usually sits at memory.max, mostly
with page cache, so resizing the queue would fail with ENOMEM even though
most of that memory could be reclaimed.

>Increasing capacity obtains the additional reservation before publishing
>the new limit. Failure leaves the existing configuration intact. Shrinking
>preserves queued packets and retains page-rounded backing for the greater
>of the configured allowance and outstanding saved charges. Excess capacity
>is refunded as entries drain, with refund work serialized against resizing
>and coordinated with queue destruction. Refunds settle the actual memory

Keeping the charge at the larger of the limit and the bytes still queued
makes sense. Otherwise one could shrink a full queue, charge the refund to
another queue, and leave the old packets uncharged. But, unless I'm
mistaken, the excess doesn't have to come back as the queue drains.
Configuration already runs under the nfnl subsystem mutex, so if the excess
is released at the next configuration change or when the queue is
destroyed, it looks like mem_work, mem_mutex and mem_stopping can all go.

Thanks!

Chris
