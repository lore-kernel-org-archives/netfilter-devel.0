Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B1E28504F
	for <netfilter-devel@vger.kernel.org>; Wed, 14 Jan 2026 01:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768354390; cv=none; b=lq89cWLdv8tLMEmAUmaFUSSLDOvIqyItlGtlRiyeaUzfo0whImYBk6kIc/n5lLEIvivvw6k/uWjX6ImvtZdjZLpMZ78Qh2zCF4XKisVFuJe3MhWtVsRFpKwSIhiRKlYYqidYRyRJO3R0eTk4wEpRUFqDRAjNJzKvU2S+XDQ7QiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768354390; c=relaxed/simple;
	bh=4/RDkIXEaC7ebb/PMZLE7DU26Loe6p+5o2aK4clc+80=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M6r4CuWddbKq1Y3LLru7c2zU0keTszd7cjxuYmFwWDclWN+iluHK5L5xGBq9S1qvpBapibbZw+BZrPaaWEXnXn8L5pxh5hGXsbvFNu9QShfGMV2HoUx9sJezrzdR6JWRH3L5iyOBNHadsVEMVmVLhJRJ3idZ6kfT/JAGL6NkXnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zhw04clK; arc=none smtp.client-ip=209.85.221.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zhw04clK"
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-5637886c92aso937698e0c.0
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Jan 2026 17:33:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768354387; x=1768959187; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BMo06rMlppqTMC+QmirbCY56Rr9+/7J+WMgFuIXf5II=;
        b=Zhw04clK/hXKnLUhT5VoPsYAKjEVw94Nw3IL4YelFpcX/qiQvimczI9sRiop/OEOOP
         UOXoCw2/ilaNVlUHiV4pOABhtqxDurJymaCtqx1bOI7KMzshQTZXdDQWrLsJ1QhuMnCs
         /5+ces4j2sWHZ29NTQb1L0VfmSbK2YHVrhkF21RHbvuwDgUh7fFnhlaW5JpaEOJ92maD
         IaTo91ngW8cMgIPaw6cfJmOxRByvXbha+p54efpjeLVyojwLjdXTU2bhm62TONwbHEiC
         u2z1dp4apy/scRQHYZQ4yeqvQrXD8Z7xGwCm0hZeLkeV+3O5HiZfOs5Bv6SrS1TGAWyI
         KSvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768354387; x=1768959187;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BMo06rMlppqTMC+QmirbCY56Rr9+/7J+WMgFuIXf5II=;
        b=YYR7MYTa2TS7GZLU0Pp0s1EsWizap/LI1bk96uBwNMD9hEQf/fMDFd+8Nv1lQzNY3I
         qtc1Yh7iAeXX1yu5mW+rBaeNNX9wWeMjZtLhU1ZFL00WzCkPy0yIc7dxovmN+1FQcQXJ
         zultIGNg1czv5mBO+Knjqg22qTw4is0LTV8wMN8iCF1zymMV30SRkZlu09zc/CQL955n
         AnG8ieuqbt1z32qifYMaoePTXNYF4YMx1R1PqX8hsAkM/uW4T0JoYjEoUk4HuW1rqft6
         4Ok3NV27d4cUX9Cf7vYnofN4RyQFWOG0GzBEk4Dd8ekxWzDs3u5EHxjycTvkHXE0Ha3O
         w7rA==
X-Forwarded-Encrypted: i=1; AJvYcCVr+JJHGEUNGN4S7NIjdK8RYhin5R2/Y9LYSsC14mYJdUPV7JyFd6Y3HMZ7SXctCV0gC8d8HmiNTCpyMO+69zw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2lgdVMZmGB+oUfAJFTi1KMBvuTVbB9YqjsJTwcQIHmxmCToKs
	Zn5kWwIIKBvV4XMCvGfdKZL5G5pxyUNWeqyIUpYRgRkTbRGmnRF7iQurVBnm/cfIoF6fTbgzPYq
	xKC7d1wMBKHTz0iLkf9639AAQazbBJTc=
X-Gm-Gg: AY/fxX49QQndnutvtuLhSleWL3vzonKVD0j9b97C9Xp+jEqoqPmAJiI26C96GYvkgjv
	eyu5gxsUMZn5zjUiVVNVyxIfNBslYdcsoLk+fFBTEs9Btw2/YUpJsEFwKfyJRzUyjYD+WIy2E4Q
	lkDlSlF54QewOWRnhWAXZMyy00n3h8rIYbWuHpTtg+ViL/z3V68VUqqowHTwwfCtt7R6QFym/lQ
	ElxV/6pEPFZRUzimmE/YJjgRifAW8yVkFG3r4p8Lmrt5DPrYPofVyAx+rn2+PVz3LCA32M=
X-Received: by 2002:a05:6102:cd4:b0:5db:3b75:a2aa with SMTP id
 ada2fe7eead31-5f17f4a2372mr440740137.18.1768354387341; Tue, 13 Jan 2026
 17:33:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251122003720.16724-1-scott_mitchell@apple.com> <aWWQ-ooAmTIEhdHO@chamomile>
In-Reply-To: <aWWQ-ooAmTIEhdHO@chamomile>
From: Scott Mitchell <scott.k.mitch1@gmail.com>
Date: Tue, 13 Jan 2026 20:32:56 -0500
X-Gm-Features: AZwV_Qj6CcCyaVBZc2cjoFwcgu1ECBdYD4c-ySqVCWBS8dJSHHzcY3XsAgj7RAA
Message-ID: <CAFn2buDeCxJp3OHDifc5yX0pQndmLCKc=PShT+6Jq3-uy8C-OA@mail.gmail.com>
Subject: Re: [PATCH v5] netfilter: nfnetlink_queue: optimize verdict lookup
 with hash table
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: kadlec@netfilter.org, fw@strlen.de, phil@nwl.cc, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> > +     NFQA_CFG_HASH_SIZE,             /* __u32 hash table size (rounded=
 to power of 2) */
>
> This should use the rhashtable implementation, I don't find a good
> reason why this is not used in first place for this enhancement.

Thank you for the review! I can make the changes. Before implementing,
I have a few questions to ensure I understand the preferred approach:

1. For the "perns" allocation comment - which approach did you have in mind=
:
  a) Shared rhashtable in nfnl_queue_net (initialized in
nfnl_queue_net_init) with key=3D{queue_num, packet_id}
  b) Per-instance rhashtable in nfqnl_instance, with lock refactoring
so initialization happens outside rcu_read_lock
2. The lock refactoring (GFP_ATOMIC =E2=86=92 GFP_KERNEL) is independent of
the hash structure choice, correct? We could fix that separately?
3. Can you help me understand the trade-offs you considered for
rhashtable vs hlist_head? Removing the API makes sense, and I want to
better understand how to weigh that against runtime overhead (RCU,
locks, atomic ops) for future design decisions.

I'll use a custom hashfn to preserve the current mask-based hashing
for the incrementing IDs.
