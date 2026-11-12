Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.6.0.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794497401;
	b=5KDPJO1BTSKPjZgLp+9iH08R0IK9Y5QPZ2qYB+eVNyjkRACz0NwZM4SNqVaYbTfOVk/u
	 1/Zc8DvSUcILyE6XTRb+hJt+w96cmNV66ImXwye5nVcVNG91NBmeKrVFzUNwiSMREAfRO
	 oN7pru/aDNJNI5Eo9j8VcNENQwfYll+2t+7rMFYrxBe8FSSZTV8OP/M1B51ZK0NLzUhRi
	 Wlt4e26HtAxkpVoOirVpIUe8N2A3dz3Xc3mUve1UsC5T57xlAzcvRV0YV2SMLzKuXKBU0
	 uDKaEyQxvqxZFQDdijj63R/8wms5lkmURnqUQgggkkbEESKqpnt7jE0usBEuXq13xLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794497401;
	h=DMARC-Filter:Received:X-Virus-Scanned:Received:Received:Received:
	 Received:Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type;
	bh=l1JnrmffnMrdfdwWJtgqzJgHq3EBck9aWeWNh17MB3M=;
	b=At3QJC2yO1/tedzDNGYV2+Fy2mv3sX6Hc3vli1xkPVCcP9Cq9sXm+3UWD7ono7RxJr69
	 uQzcFQAm11LvBmCE/+MFhfBSbAd5JteO9KOODNv3eAgEHI3dJaVSbwS3axbX19aDWe0vU
	 zrJj6qWY2W1YVrkaf+oNIDATr5g2j4IUNNazOrVugB977WsZ8yMzsmP4S5+5m25yASjie
	 zZPLKcIv3OSZY4t/tgF2APQcL556lDSDFYu1BAtMWOB6s8IuMmbl++c4krjqqmyd7En3S
	 amOkdYbDibhN8SpLA4iQiW6tvjQrICg1VIWCzaWs9oef9oAS5pbCxycaLMFAuFCL7OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	arc=none smtp.remote-ip=148.6.0.51
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09405606A338
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2026 15:29:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09405606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4jQPTD019qz7s7wf;
	Thu, 12 Nov 2026 16:29:51 +0100 (CET)
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id m0ZMtmj153qF; Thu, 12 Nov 2026 16:29:50 +0100 (CET)
Received: from mentat.rmki.kfki.hu (254C23C3.nat.pool.telekom.hu [37.76.35.195])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp2.kfki.hu (Postfix) with ESMTPSA id 4jQPT96Hysz7s7wY;
	Thu, 12 Nov 2026 16:29:49 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 50BF5140396; Thu, 12 Nov 2026 16:29:49 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 4CD0E140031;
	Thu, 12 Nov 2026 16:29:49 +0100 (CET)
Date: Thu, 12 Nov 2026 16:29:48 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Florian Westphal <fw@strlen.de>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v10 0/6] ipset: replace internal hash table with
 rhashtable
In-Reply-To: <20261112143818.30638-1-fw@strlen.de>
Message-ID: <9a882426-58aa-c14d-fe99-64538c98d293@netfilter.org>
References: <20261112143818.30638-1-fw@strlen.de>
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

On Thu, 12 Nov 2026, Florian Westphal wrote:

> v10: No changes except dropped mention of rhltable in patch 3 commit
> message.
> 
> I did extensive LLM reviews of this thing, but by now noise outweights the
> signal by far, with successive rounds often giving contradicting hints.
> This passes ipset tests, like previous versions of this patchset.
> 
> 1) Add rhashtable_flush_and_free, From Herbert Xu.
> The initial user of this function is added in patch 3.
> 
> 2) Add rhashtable boilerplate stubs to ipset. Implement its initialization
> and destruction logic.
> 
> 3) Replace ipset internal hash tables with rhashtables.
> This drops functionality, in particular, MULTI sets will not work
> correctly.  This is restored in patch 5.
> 
> 4) Report dynamic CIDR storage memory size to userspace.
> 
> 5) Reimplement hash:net,iface (IP_SET_HASH_WITH_MULTI) using a
> group-of-elements structure with explicit exact-over-wildcard match
> priority. Update gc, list, flush, and destroy paths for the extra group
> level.
> 
> 6) Restore SET_WITH_FORCEADD eviction support to netfilter ipset. Add
> mtype_remove_random() helper to facilitate element eviction during
> additions.
> 
> Florian Westphal (5):
>   netfilter: ipset: add rhashtable boilerplate stubs
>   netfilter: ipset: replace internal hash table with rhashtable
>   netfilter: ipset: also report mem size for cidr storage to userspace
>   netfilter: ipset: re-add IP_SET_HASH_WITH_MULTI support
>   netfilter: ipset: re-add forceadd support
> 
> Herbert Xu (1):
>   rhashtable: Add rhashtable_flush_and_free helper
> 
>  include/linux/rhashtable.h                   |   40 +-
>  lib/rhashtable.c                             |  186 +-
>  net/netfilter/ipset/ip_set_hash_gen.h        | 2176 ++++++++++--------
>  net/netfilter/ipset/ip_set_hash_ip.c         |    6 +-
>  net/netfilter/ipset/ip_set_hash_ipmac.c      |    6 +-
>  net/netfilter/ipset/ip_set_hash_ipmark.c     |    6 +-
>  net/netfilter/ipset/ip_set_hash_ipport.c     |    6 +-
>  net/netfilter/ipset/ip_set_hash_ipportip.c   |    6 +-
>  net/netfilter/ipset/ip_set_hash_ipportnet.c  |    6 +-
>  net/netfilter/ipset/ip_set_hash_mac.c        |    3 +-
>  net/netfilter/ipset/ip_set_hash_net.c        |    6 +-
>  net/netfilter/ipset/ip_set_hash_netiface.c   |   74 +-
>  net/netfilter/ipset/ip_set_hash_netnet.c     |    6 +-
>  net/netfilter/ipset/ip_set_hash_netport.c    |    6 +-
>  net/netfilter/ipset/ip_set_hash_netportnet.c |    6 +-
>  15 files changed, 1464 insertions(+), 1075 deletions(-)

For all patches:

Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>

In my opinion the patches should be applied to nf-next: the new method 
passes all the tests, no functionality lost and it evicts all the issues 
in the old code. There's no point for further tuning.

I'm absolutely grateful for your hard work, Florian!

Best regards,
Jozsef
-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
