Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795523262;
	b=HxlHBX92cYyt1fpyNNT9BQW7VkxTDWlZQh7QlxvQga6frElc+OZDRLz+SUaZXtJclc8R
	 Eq70ET31Y1KNMYPMgj2wtiPWdJuKGn8y+NwoqQcg2uthvUKCycNq01QxtFtXDmHkrZQM8
	 vlSl2T6zcVQslWdH7xgjS2Zu7Fk4rKksAug6szLXP2+sE5xPUHGE5zznzTtBZ1pMw4imj
	 vuVziwAwZ0aiC4W3DWyWmi4mTIhJ2txLkpBVCtyp/sMNLJDkfm1+CMEoFg/cqJEVr68GN
	 SiGrkmFoJyZ49ts0VxDOjdqIPtRp9LfNdX5AKN5f8up9tUn6EPfGNGBc4L+ulERN9JA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795523262;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=E8RO8EqQMh0qvc/m85F6RGVBo/afRzFDeTmOzmDes9Q=;
	b=lJdqfUPjqjEFQZl/I84Tv2IqHuHbdWJ4MjLOIdDKgypRTGXDY0fxPkhZfOQP/oKfMKX+
	 9CM0p8QmbuUm10tl/dFQV8Uav4eQ7gvdW3P+UZibICkADoi2zc8z8ZdM5/1wKVy9kzaD+
	 UMHikAHOSN3+Z3yrjbrgkhZKeHP81GSXXYooyoAe4+6sFJxTnnvSL9RszGJWAWXnlJb0d
	 Tcs1YmRwotXRr+eiJIDI7bUtyZ9jt587FrMXKt4+RbSFlIdAU/L2RgzD1OPQKGcd0B+zt
	 hLVeayGS3CeOWOaArO8Z2O+zsbQreDKrC+ap3fTsGLNP2Rs+pl+j0bmvCe+OiOC8xrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XuHxVSQ7;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=QV4fRKle;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7D3606A31E
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2026 12:27:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B7D3606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XuHxVSQ7;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=QV4fRKle
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795523260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E8RO8EqQMh0qvc/m85F6RGVBo/afRzFDeTmOzmDes9Q=;
	b=XuHxVSQ764IKLx9pfke6aZU4bRSpm233o+vseMLoqEUCKeKKDBXbDt4b2WffyvD3FukXrR
	yQWiXpVque1x8iwUptiA/9DHA8CvTxY3HRR1oC/7wnN01dJMsgRQsAbKMwu6uDPvKFcDQy
	VR84WQoHevQK3MYnqGyLcIKQag1cvR0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-120-CIExBxLaNwyWocqzng3PMA-1; Tue, 24 Nov 2026 12:27:38 +0000
X-MC-Unique: CIExBxLaNwyWocqzng3PMA-1
X-Mimecast-MFC-AGG-ID: CIExBxLaNwyWocqzng3PMA_1795523257
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a17741243eso23285515e9.0
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2026 04:27:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795523257; x=1796128057; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E8RO8EqQMh0qvc/m85F6RGVBo/afRzFDeTmOzmDes9Q=;
        b=QV4fRKle0a5sJ0R/NDQYJEq5LXtCDUBlm5zU0okwE/zup2lwZXav7vDULqXTIyjKoL
         /S+5RElZ8CyTl2w3xcYLcIT5nCjDi/74qebPz2OrbXXpLLG0hMgVLv3zBf3MOgnRnxPm
         uvY/IY5bQy+9OTD4dQSAGCGcsFuqfyUvFk3EpTTcrq8z7qyS0N3EYaryPrZwUIOdZwNa
         WCoiR5ANTsge4CeHUkY6hRBZDZZFYc7lWWnRQK4W6ECOAVsT/5Stbjhi/A9ZrWtOM9Nn
         wXI9VUYwqmKwh2/fLhtFKFLeDjFDp8YGzxbof0cF3G0cW6TPIxwi2kXU+vUc34ZjA0vq
         7Yqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795523257; x=1796128057;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E8RO8EqQMh0qvc/m85F6RGVBo/afRzFDeTmOzmDes9Q=;
        b=qk3kewJzuUCpCVt8eWrTeJfK8iiI7nFYogCimXnco1GltuN6IslG47uCZ/Cg9b15wg
         /1mSvSCLIS8lfqz8251bobhrZ/jNIeFXutqOxtfG2FUB39diUZ6EcxPjEljrmV+yXFaf
         9lxn2krDv6DZvezawtFJme6jxgI2FG2FbG1CIQPukunkC0qpHzmooxxG0f/583dwcVgE
         iEFK7DmW96W1rzIXjB56TQE1uQNSQfUyas8uuBwJMI+kRWKnfotQUdEVWlVhHySCQqsY
         QKTKsOhy9uiE5HKveM741/WETrAmORzqrmpPfy4k//WCV+czQURolrqPcgE1jEWSIjbn
         uBVQ==
X-Forwarded-Encrypted: i=1; AL+hErEF5jNJFd1RxLqcMBnI3rPL4X/Ix4MmFRnr8cd1z6UGBE7JmcXTlmj3XL9ctr2eyJNNbNgeI3kKOv5cMJsaiB4=@vger.kernel.org
X-Gm-Message-State: APuU4Z/9+NNauOBM5CzuwjYEFByq+wp31CfrTDJkgQ+hQzjQV1xFYHDU
	bgaaNJjFjDM4We5/opRnrOxl5aiQhj05/Crzlihn3aRn7M9bY1hoGg8RfK/YvAEuRozlwKkEb0T
	E1mH2NeVXcyuqkNtiip92Qv5ypOoV2XVjWCmOMlxYsWkGeA1d9x0OoZhlCQ9aN/Of5D8JjQ==
X-Gm-Gg: AZFdTZdexxYgOptU4+WVpc5reVMPVQunr6VAglTTEbzAhY7+jKgnkgtXdm0lXkP78X/
	RKKG4RRKcPlJ7EFZI0qL/T1LWVY18xwlirNnyJxNng/9Kjd3gJ3Ipdk7fujAz+R/HEC8psuRP7S
	E/2VO4zQyclabWRhP41m17FA2v3VDL5s5hsOrwQJVEDxOfc5lSHgihKSWRH80g2SgLdqUeM+pZD
	QMu2yXkdONncdbKsE88scSU3IS+/165LsLLEatWELB0RrzXEbtTsW7Jesj9UoOixVvPU+CnRXiJ
	TTln0xdma9+u9jCIjObNgovmUAsGvLaRdqa7cVHCXnK48Xj9HrzW/xOZ0/E6UEu86xLGa5T1UK+
	RyRTqzRB4wfQl76SR4d+UyCkyeKU1N8qbjYqZQCadgLX1irHL1l8AItLshY/N9RYX4zLAf7oMny
	TTZQ1Jro0G0CZ2M0gsNA5FYQwwIrcZO273fZQg5VhNBEK8
X-Received: by 2002:a05:600c:3113:b0:4a2:267:25b3 with SMTP id 5b1f17b1804b1-4bb8882a4b9mr312098785e9.35.1795523257001;
        Tue, 24 Nov 2026 04:27:37 -0800 (PST)
X-Received: by 2002:a05:600c:3113:b0:4a2:267:25b3 with SMTP id 5b1f17b1804b1-4bb8882a4b9mr312098305e9.35.1795523256610;
        Tue, 24 Nov 2026 04:27:36 -0800 (PST)
Received: from [192.168.88.30] (ip231-128-192-82.pool-bba.aruba.it. [82.192.128.231])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853a9846sm510138135e9.11.2026.11.24.04.27.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2026 04:27:36 -0800 (PST)
Message-ID: <8e69f35e-73fb-4558-910b-45f5e723c64a@redhat.com>
Date: Tue, 24 Nov 2026 13:27:35 +0100
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
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
References: <20261123135726.3940688-1-pablo@netfilter.org>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20261123135726.3940688-1-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/23/26 14:57, Pablo Neira Ayuso wrote:
> v2: address cover letter errata.
> 
> -o-
> 
> Hi,
> 
> The following batch contains Netfilter updates for net-next. This is
> composed of four groups:
> 
> 1) Patch 1 addresses a race in the nf_conntrack_buckets sysctl handler,
>     that has been reported by LLM. From Fernando F. Mancera.
> 
> 2) Patches from 2 to 7: This is a conntrack hardening series to address
>     LLM reports of the issues related to skbuff mangling while a ct is
>     already present, leading to mismatch protocol numbers, ie. ct becomes
>     stale since it does not represent this skbuff. This is unlikely to
>     happen in a real world. From Florian Westphal.
> 
> 3) Patch 8 updates nft_synproxy to address SYN and ACK packets only, just
>     like ip{6}t_SYNPROXY does. From Fernando F. Mancera.
> 
> 4) Patch 9 validate hook priority so nft_ct template is narrowed down
>     to be used where it makes sense. From Florian Westphal.
> 
> 5) The ipset hash types conversion to rhashtable, including a new
>     rhashtable helper function to flush and destroy the hashtable.
>     This is a rework that aims at fixing the existing resize races in
>     the ipset hash type, which has triggered a myriad of LLM patches
>     addressing the symptoms but not the core issue. This large so
>     we prefer net-next for these series. Series from Florian Westphal,
>     plus one patch for rhashtable to add a flush and destroy helper
>     function by Herbert Xu.
> 
> Please, pull these changes from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-26-11-23
> 
Unfortunately a couple of in-flight nf patches prevent the CI from
picking this series:

https://lore.kernel.org/all/20261120111910.67379-1-juny24602@gmail.com/
https://lore.kernel.org/all/20261121212037.149722-1-omermetekaya0@gmail.com/

Could you please re-post it? thanks!

(Do I recall correctly that guidance for nf patches is to not CC netdev?)

/P

