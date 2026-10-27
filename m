Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.6.0.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793121235;
	b=DZsCbZMxXTF8geYOJEeEa7GpAsEdgm+Y3Pw18jhhhl7xw3kQz6ewk8b5hcBsGS6oC1VS
	 OBlPIOvEQy0SQRN1JgmU77HaPNmZJP9L0X0wdbeXT7r0STOF+gBH7FiZyJTJ37A+qn1MJ
	 1gk5ljCyOIQx7U3TtIJJll+6cwNQg3EMapWxWUmhDuG6+3WhQgyWY5EkkKb5axOzhx30B
	 Npo+hiWeudB2zi3h2qnLPiQzSig3Oyw3sMQ8mTvHd8d43i3SS+oxSdYO8tFkpTGjC6K7a
	 2R5cUk1+xDqcSNUOLu0GZF7ib0uHwQwkMtHbA1XAQMmVjn/4OANAYRRUJ70PsYNt/dQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793121235;
	h=DMARC-Filter:Received:X-Virus-Scanned:Received:Received:Received:
	 Received:Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type;
	bh=smNS6cD/i0wOiqyZiTc0acTIfzjC2hrsc6ws6W7H+MU=;
	b=U4yNJxsVoT1uqeHmHd8YHnrBrbv7oVnnYsf9ydnjBqKq4ouhCDUP+99AFeB6mi/n3Vk2
	 RcAHbYCNshDqoM+x0hfGbqidAed6uydH+apHJmeoR9dDHFwxjhsj2nuTZOAm0qcG008Xe
	 duiPIyZRhyeaSvIrQlKqDgPqM6LmOOtmFFJPV/2pUOIwKnPvpD0rlDAD1R5CgSlajHoST
	 5l6Q6Saf6nnLJNpfuSsgtMXVaFq1jW0q9McnyAv/HvHGS7b6b4wcWBd3UobnON/1/JIsk
	 iajSyJ72ZoEV20A9eG9Mex/Y9Cv6XVrcxUO/oo4XxQ24wnXh6P0kLm0eA31e9TY+ANQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	arc=none smtp.remote-ip=148.6.0.51
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC049606A31D
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Oct 2026 17:13:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC049606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4jDcXT513Qz7s7wp;
	Tue, 27 Oct 2026 18:13:45 +0100 (CET)
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id 7M1itF5cCfNP; Tue, 27 Oct 2026 18:13:43 +0100 (CET)
Received: from mentat.rmki.kfki.hu (80-95-85-51.pool.digikabel.hu [80.95.85.51])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp2.kfki.hu (Postfix) with ESMTPSA id 4jDcXR44sHz7s7wn;
	Tue, 27 Oct 2026 18:13:43 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 1D82B1405DC; Tue, 27 Oct 2026 18:13:43 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 19AEF1401B0;
	Tue, 27 Oct 2026 18:13:43 +0100 (CET)
Date: Tue, 27 Oct 2026 18:13:43 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Florian Westphal <fw@strlen.de>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf v6 0/6] ipset: replace internal hash table with
 rhashtable
In-Reply-To: <20261027133331.25979-1-fw@strlen.de>
Message-ID: <a8a94db7-7b61-4619-e7d9-920e775814b7@netfilter.org>
References: <20261027133331.25979-1-fw@strlen.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Hi Florian,

I'm absolutely sure that your efforts to replace the custom hash 
implementation in ipset with rhastable is the proper way to solve the many 
problems lurking in the current codebase. Which are sometimes nearly 
impossible to solve anyway, without a complete redesign. So looking at the 
sashiko comments, I think the end of the long journey is not far away!

Best regards,
Jozsef

On Tue, 27 Oct 2026, Florian Westphal wrote:

> v6: address more AI complaints on v5, affects patches 3, 4 and 5.
> Rest unchanged.
> 
> v5: add Herbert Xu's new rhashtable_flush_and_free() to rhashtable, this
> replaces my own version from v4.  I also dropped a few follwup patches
> with further changes/cleanups, not strictly required for initial
> conversion.
> 
> 1) Add rhashtable_flush_and_free, From Herbert Xu.
> The initial user of this function is added in patch 4.
> 
> 2) Add rhashtable boilerplate stubs to ipset. Implement its initialization
> and destruction logic.
> 
> 3) Add rhltable boilerplate stubs to netfilter ipset. Prepare for handling
> distinct elements sharing the same hash key.
> 
> 4) Replace ipset internal hash tables with rhashtables.
> Retain legacy configuration options.
> 
> 5) Restore SET_WITH_FORCEADD eviction support to netfilter ipset. Add
> mtype_remove_random() helper to facilitate element eviction during
> additions.
> 
> 6) Report dynamic CIDR storage memory size to userspace.
> 
> Florian Westphal (5):
>   netfilter: ipset: add rhashtable boilerplate stubs
>   netfilter: ipset: add rhltable boilerplate stubs
>   netfilter: ipset: replace internal hash table with rhashtable
>   netfilter: ipset: re-add forceadd support
>   netfilter: ipset: also report mem size for cidr storage to userspace
> 
> Herbert Xu (1):
>   rhashtable: Add rhashtable_flush_and_free helper
> 
>  include/linux/rhashtable.h                 |   40 +-
>  lib/rhashtable.c                           |  187 ++-
>  net/netfilter/ipset/ip_set_hash_gen.h      | 1638 ++++++++------------
>  net/netfilter/ipset/ip_set_hash_netiface.c |   24 +-
>  4 files changed, 860 insertions(+), 1029 deletions(-)
> 
> -- 
> 2.55.0
> 
> 

-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
