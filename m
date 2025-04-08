Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9250F23E338;
	Tue,  8 Apr 2025 18:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744137227; cv=none; b=KtsS/kkXktFw9YiTK/WueXLXNbiTx8lyCQ/l9a0EJDJysDkzQRpOWGh2MAy1aHg5glPrKcTei/SRc5pa8dhXVdqbHguvqp7RODpzypiEvegubJqKdm4bRaw6J6TyRGmYOR6hgz2AVQHCr5EwddM+2TM4NjIvMip6cOj2bv7oU0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744137227; c=relaxed/simple;
	bh=OkpfI8JKKBHKEkXG8a9cTHLMUwDLO39b4MBr8fj0v9A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WidfGhfWT1ONiB+syvNQDIqmFIiuIXpcJF/f2TiiSc1ocROtC0sFO5eAj1elRcB+zmVA+lCP31wgVt81Oz1aLxD5q4unkOVXDhlfbyy7nXo5NTiW8+bDw4/v8ZrM2SS9vWVqmQS20vd6NkwjnLw73pHhckqCkwM/+mY1rv3S9CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U6VEkrmx; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U6VEkrmx"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-abbb12bea54so138615466b.0;
        Tue, 08 Apr 2025 11:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744137224; x=1744742024; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CbR+SDBjSlCanP57hiVBvuMAbFJp90QL/uZWZc8SqiQ=;
        b=U6VEkrmxpHB2Bxp1Ri04bOVRM3pjVAyySaurjBDLcb+S6uAfEuALRAeVV+Rqd1MiKG
         jLjATI7H7Fid60uD8HYu3TRK+ydUTbu2CsIZ+IdANArL9795crujnqGrqmvrS4xxVS2Q
         uI7RjP6hsYzL9H4DO91NZKgo0MrjdUEpAkxRWP7XoF53jV7t7SrHPKBI0nMFgeaSZFB9
         XUaNk+M0NUHNQUo9HmI+0zdo8DQyg6ALaCof7pAsU1pumSqb/oLAi2UGI7xurd919cox
         QeftGRStrROIcQVpS0EC84s6rFmwGoJEP9+HTZdARiRUDYU+cc+ihTCY0qHXjoLl+Jzb
         9hdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744137224; x=1744742024;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CbR+SDBjSlCanP57hiVBvuMAbFJp90QL/uZWZc8SqiQ=;
        b=nPONCaaFvSqjeIQUwV8gLUJmZEyNymzrKdIjnfOKALpH0h4c8P+VYkmGoYhn29ZXuu
         6rQ6YPdIV0duZNp5qkiBfkcPT5JAyrybsKoAThZIdecyyWVQiv7fZP+J/90lsc/uZ+Gn
         WuhJbyJIaHcAk7jEFlBih3dxgQeVz4M/LGhoaNtLKrCedskfr+aSdb2/GPMp89Nm7L2U
         34xllljNmAk6ciNpmdoo+aTMM+Epn2Dt8L+oeGr52acDthlkp7UM7/dbUNUdZq4zPeOt
         ywCO82R8eXjwW9aZN4KDTCz23sYpsJbGY5yoAgFyNsHD39OWnLiAXa/eQj5GLgyi/SWJ
         fodg==
X-Forwarded-Encrypted: i=1; AJvYcCWcjbNGY263rLBcAKh23n27yfVDwxtvRnI/kWLHoBq6inuu3TYmT4PoCKHMhdPNkLeLnzxG6hZaYtCsGsQTJ8Y7@vger.kernel.org, AJvYcCWlmyCdIAY3nt2an5Ktbkyfo1m9ZK54E2i2Mq1mPV2lOtX2Rv4E8zlAR3XxOXct0Dhf1YJIgxQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyVA+FpKv6r+UPkFW/Y7AX11ie6XBr8C3J97aMCeTw2CuOB49d
	17U4a1x5D27Rg8lA2HzJ8waszniS/CTzLf+dsyZ/dNsDdsC7NHQR
X-Gm-Gg: ASbGncsZzlC/hhZro+MbA36MjGQG5f0/hbWwoUQ5HxLzqz96OVo781Ov8M9KwzO7/40
	TFXpr0KGzJhxKIRUkfi1SZYy9lEGcFLgAUyl9nL+Fiu0TH+xOQtp9XE5egbKy9sPFuhXYyZ+aVm
	TYwfEiRZylynQXbFARPqxstF368Nf8HxoiSmXT2Q7NUzqoxlb7/juN1qE+DCF4Z6FLViAZK/Zk7
	TEhIVKGB98HyoDF2eSfFcXc9GRfcKWmQsMJWMip/HYmhynDwKzhzj6/NqHnzoRE+PVT2Bf73NxS
	SptK2hs2hwGP8BKwq53ZzMFKIftDElY6I+bj4T2phFvlkPwcTRebOvphfO6kd4yW+864+Od6iLw
	1nSTTBTKDhN7K6JsG42ti1NRty7DodIrqriV8CLtTO85dUw5BcS4C/RIWq8YGqrBn/Wpm+Mdb+D
	F8F3ZQGx/4VL9JTxLL8D4=
X-Google-Smtp-Source: AGHT+IHAAt6vPbKGMz1eXRWFE/FZ9F4uiX2LpnIYwTZUS8jCgcDQIcbdzzrkb6ANj1v8EAbdA8C1Tw==
X-Received: by 2002:a17:907:d93:b0:abf:4c82:22b1 with SMTP id a640c23a62f3a-aca9b695a43mr20164966b.32.1744137223553;
        Tue, 08 Apr 2025 11:33:43 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7c013fda7sm954327466b.117.2025.04.08.11.33.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Apr 2025 11:33:43 -0700 (PDT)
Message-ID: <fc34e774-e264-492c-9ecb-20eaf7bd87e8@gmail.com>
Date: Tue, 8 Apr 2025 20:33:42 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 nf-next 1/2] netfilter: bridge: Add conntrack double
 vlan and pppoe
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>,
 Nikolay Aleksandrov <razor@blackwall.org>, Ido Schimmel <idosch@nvidia.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
 bridge@lists.linux.dev, netdev@vger.kernel.org
References: <20250408142619.95619-1-ericwouds@gmail.com>
 <20250408142619.95619-2-ericwouds@gmail.com>
 <20250408163931.GA11581@breakpoint.cc>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
In-Reply-To: <20250408163931.GA11581@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/8/25 6:39 PM, Florian Westphal wrote:
> Eric Woudstra <ericwouds@gmail.com> wrote:
>> This adds the capability to conntrack 802.1ad, QinQ, PPPoE and PPPoE-in-Q
>> packets that are passing a bridge.
> 
> Conntrack is l2 agnostic, so this either requires distinct
> ip addresses in the vlans/pppoe tunneled traffic or users
> need to configure connection tracking zones manually to
> ensure there are no collisions or traffic merges (i.e.,
> packet x from PPPoE won't be merged with frag from a vlan).
> 
> Actually reading  nf_ct_br_defrag4/6 it seems existing
> code already has this bug :/
> 
> I currently don't see a fix for this problem.
> Can't add L2 addresses to conntrack since those aren't
> unique accross vlans/tunnels and they can change anyway
> even mid-stream, we can't add ifindexes into the mix
> as we'd miss all reply traffic, can't use the vlan tag
> since it can be vlan-in-vlan etc.
> 
> So likely, we have to live with this.
> 
> Maybe refuse to track (i.e. ACCEPT) vlan/8021ad qinq, etc.
> traffic if the skb has no template with a zone attached to it?
> 
> This would at least push 'address collisions' into the
> 'incorrect ruleset configuration' domain.

Thanks for the input. I will look in to it and see if I can also add it
to the test script.

The thing is, single vlan (802.1Q) can be conntracked without setting up
a zone. I've only added Q-in-Q, AD and PPPoE-in-Q. Since single Q (L2)
can be conntracked, I thought the same will apply to other L2 tags.

So would single Q also need this restriction added in your opinion?

