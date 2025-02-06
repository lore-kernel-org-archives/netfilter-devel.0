Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D264F5E0
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Feb 2025 14:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738851709; cv=none; b=Go+4g47QqcqjQ5BixaNViZhr+xcoCttCrST7MYGAAdLQUmHc4IQg06r/0uFbeUHFbi6rFRRja1K+MZWAUb8ugx+iWoxgK41VNSHfZ7F4ANBQgO5wrTAnUux9Fin6t0UBfU7YI4lpvPOdCF0hfBSF4FQiuUrsbe6zCXR+jS5uR7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738851709; c=relaxed/simple;
	bh=/TJhMhlC9yfWlzDzdRKnoTLdE7CVcxNUHvoHyyqOcac=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LoaDTXhYy0O58SBpK08sjkmEjlFLCD5x4KXffaFt0FuMNq+9VqTI+azjpajqJsCXiTe4BQYjBgguFCsVY0JZdaGBH1ptZf0nh60aKHii3qZKK7Yepc8Mx6f+o+Br1g5xnEb/lIRQxxKTGn9AlusTcav8/UdRV4+kRWWlGjScPlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org; spf=none smtp.mailfrom=blackwall.org; dkim=pass (2048-bit key) header.d=blackwall-org.20230601.gappssmtp.com header.i=@blackwall-org.20230601.gappssmtp.com header.b=esM5+Wbz; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=blackwall.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=blackwall-org.20230601.gappssmtp.com header.i=@blackwall-org.20230601.gappssmtp.com header.b="esM5+Wbz"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ab6f636d821so175578266b.1
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Feb 2025 06:21:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20230601.gappssmtp.com; s=20230601; t=1738851705; x=1739456505; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qzREIBb+bKP5i/Ck51DCfeo3RpAWV5APsV60x0FMqs4=;
        b=esM5+WbzOkLXd84M4aNxR/9+gAtddG4eZ5otCj0Q6vC2mEP8QnUTcVsAG7KU0VKMOr
         TMGEiddouSjPve9lC67WCOeL7bbAQCxAUJCIc+BlqymgcLYsFDtmErtpcNKGvOX5ac+B
         PRnvgnGf5V+q2U9dAKqP9xe9D/W2gxVM4MjKdXpuqgzlMUyEaSKCkNJsQcmQcRN3UngP
         LbaQBI2YhVs9SY5xUzXFUKkMLLnzKmw+2AoopfFNbc206YsRHt8WOGMmiXu/fRRT1gWi
         UA0QHd7BoxeR5dyMgagkv127PqjRNH9TEyHWUGxCSx7jwFOBgNDkljKlynKGgogzlsN4
         71vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738851705; x=1739456505;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qzREIBb+bKP5i/Ck51DCfeo3RpAWV5APsV60x0FMqs4=;
        b=BEbEVC8OrXOAKFx7ogQZBIayHpWDGI+4h8aOFI+ukDsWN/Fq3hVk58Z/Iv8Q92neTr
         0OhqfaIG3ak7nC48h6u3EGQuTc3ae5o0rL7dNZyuIIgV1fH9NLw0Gk99H+AAM4KbXRYy
         I24uxzOVaBKVYIF3q+rV6aIxxdnrQwU+EYu8YNnp1oqvfOiZyMJnpgOz/iasLDIo0xE+
         pCvbwXDq7GmfTZcoSS0uc7+LuLxCDBi9KtXX7RyD+iu0g0S4FYnQV30mn6A8M9Gu9kuV
         O7gnwWJ1Hirp+rsgP1X5uD5drNOdg3TSiTZKTUUIyacxFNHDqzBOWWrECcDhpKmnefxf
         x0lQ==
X-Forwarded-Encrypted: i=1; AJvYcCWnRNBrZtxifoAiI+rzIdMK9VEkx3dHoX1b/RnNo6ZCqOwub5WEYnUAomod1TyA23oB0JVR7igZuENpD1Qlk1A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz12NxzNHKjOaaEiqFDLXcdV80dvdrQaHtakxM8LvDScsTxhPn2
	hcmEeP8U+r1+/I4gRhCZfb4ffNcStjRpuZRRIcue08E2AsPMbnGBCVmDMNU1P4I=
X-Gm-Gg: ASbGncv6y4dIHXpDrQl8VKgkCV+IUzzWPxhzBOK11adLzTbbrMLuqqBWEiKxiwLdwkW
	Xl7JOcTm4b/U3nDDkJH8drTO2f5fUA2e/J0qzt4aXhsPcMH6fXInBtF+C2ahXK9gYFnEs6S58D6
	XQp93AGLu4Ltyw4mMrGqsK0Scv3fxaNFH0BSLRK/ZZPhJLThNeCWFeVvCi2Pzz+9/OR2hYCsROw
	mxyVpR+F3awIYCEWaciHKQyFZDD5J4KOzXTB68rQOaB516POFaoALOkpxweoelQKv8Uv1TBFeFR
	rRvWRv6k9oB48V78OgFqpiYJmPV27wX9f4CVAIcTVEnL71g=
X-Google-Smtp-Source: AGHT+IHYDakGj/X5YiewxYiKiang3LLrhidWY47Oe3DTivu/rcwezti/yOY3bxt3zD/zpLuTb7KrqA==
X-Received: by 2002:a17:906:6a16:b0:ab6:f59e:8737 with SMTP id a640c23a62f3a-ab75e262320mr699358866b.27.1738851705010;
        Thu, 06 Feb 2025 06:21:45 -0800 (PST)
Received: from [192.168.0.205] (78-154-15-142.ip.btc-net.bg. [78.154.15.142])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab7732e70bfsm106144666b.104.2025.02.06.06.21.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2025 06:21:44 -0800 (PST)
Message-ID: <fef59299-aac3-41b1-9783-3a3f35dbb7ac@blackwall.org>
Date: Thu, 6 Feb 2025 16:21:42 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 net-next 05/14] bridge: Add filling forward path from
 port to port
To: Eric Woudstra <ericwouds@gmail.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Jiri Pirko <jiri@resnulli.us>,
 Ivan Vecera <ivecera@redhat.com>, Roopa Prabhu <roopa@nvidia.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Lorenzo Bianconi <lorenzo@kernel.org>, Joe Damato <jdamato@fastly.com>,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Vladimir Oltean <olteanv@gmail.com>,
 Frank Wunderlich <frank-w@public-files.de>,
 Daniel Golle <daniel@makrotopia.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 bridge@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
References: <20250204194921.46692-1-ericwouds@gmail.com>
 <20250204194921.46692-6-ericwouds@gmail.com>
Content-Language: en-US
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20250204194921.46692-6-ericwouds@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/4/25 21:49, Eric Woudstra wrote:
> If a port is passed as argument instead of the master, then:
> 
> At br_fill_forward_path(): find the master and use it to fill the
> forward path.
> 
> At br_vlan_fill_forward_path_pvid(): lookup vlan group from port
> instead.
> 
> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
> ---
>  net/bridge/br_device.c  | 19 ++++++++++++++-----
>  net/bridge/br_private.h |  2 ++
>  net/bridge/br_vlan.c    |  6 +++++-
>  3 files changed, 21 insertions(+), 6 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

