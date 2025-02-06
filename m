Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC358236448
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Feb 2025 14:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738852786; cv=none; b=TCreJpmGsxQI9s6toML3OKpDgerGmRY86ZNxwtVTr2CwKVnpLBLa3oEdAGFSWk8psl4jhU3k8FXpjnDTaDPLyKVTSWCGali+MxJ2wIpTSYHG6Gq7wl5hg4hLc2TbMti77DsxY7bVqJJxshsl9Jsfiws6Fxiw8MkxbwHn6S+o/+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738852786; c=relaxed/simple;
	bh=czZSa8RE8rPjUA6bt67Tw98QD1nGxDQA7k8TsCfdCzU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rXIoUYEngQJ8B6zvXecJjtn7L9tfZDgTU3hox8zKGUm8wU/3HDQt8Nny5hhhVpRfR6O3N5aG4sZd+XG+1D9GrOx1/G2NQ2oSvr8HYzO1j/LIZ32ALEchx6/AC+Cn62FXl1uqj2vpGHVDV4XlLHUBTjyIa65txeTCqfl2QspKn94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org; spf=none smtp.mailfrom=blackwall.org; dkim=pass (2048-bit key) header.d=blackwall-org.20230601.gappssmtp.com header.i=@blackwall-org.20230601.gappssmtp.com header.b=JWdmmSnz; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=blackwall.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=blackwall-org.20230601.gappssmtp.com header.i=@blackwall-org.20230601.gappssmtp.com header.b="JWdmmSnz"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ab771575040so170832066b.1
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Feb 2025 06:39:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20230601.gappssmtp.com; s=20230601; t=1738852782; x=1739457582; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qwM9ak9hrD3h4qVx1yCYkLliO4mOGlB4YCv6ISmSjO4=;
        b=JWdmmSnzoZq5RGgbQpuszpn6O6rOYZkznr+oAMvxumyfsRzbSEpzqR6aBqRCsbunXa
         FAgAiHFq3lWqSe+H5cw1nOEPAgTYGQMhhgqjNQsyNJrsNT0yAi+h+BhvupGYxOmzvfQ4
         eRXLZIj7fmgKXb22Gno2eEJw9qh0DTnkkUoJCezfRCp7ZXq7ekIf+pJpW10hh+l0qs2i
         69hdisIWk9h27wElBpCz++2PhbJiPLBw9dxwO2KGXL0PZ+D90zQZjQktwxvCZnxq8WsU
         iCcz/1vlzXs2Xku9lK//QhQcVGiqRcmgwQACQbq7GJsHtetRWXVex8KrWo5lt+YqNkaI
         egyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738852782; x=1739457582;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qwM9ak9hrD3h4qVx1yCYkLliO4mOGlB4YCv6ISmSjO4=;
        b=Re67JZhQHj+kT4x41r0dF5xWvcdD9jZQFtPYCtNSPWD1dd6G2CFMPSm5+hCjp5yw5n
         4VAceOCGgaaTH0ZUbD322PqKdbVVqlgDA4O1mWfalfuKGr/eKX5Zpehm1dGVByDa/e8q
         gIlAYoQ+G4Z1njYIitE4tb4K9ZJWpSkhgvxhdLZhYo57NqrtRFGbM+IPCpmexwGRwVZZ
         QMVXQnna6keqLnHCs/g5BjISQTM5s4797rjZFeMqQOsfKm4e3PzsR/Y98kF9UoH9xVBA
         4VFbBhXoJT96sheYAoAex3H0I5vC/ZyEzPvC5+4Zg07zba6Rp6AWdoBmVxdaKw8g031+
         sGuw==
X-Forwarded-Encrypted: i=1; AJvYcCX6ygY6haZd4QfEU90FbAW/Ar9qX/lvv/dh/B36y8VlgY/8vZOpl5+/YoAZxUzMdLt6z/Hx4y29J9GHNt61K18=@vger.kernel.org
X-Gm-Message-State: AOJu0YzA5uKxeroMdLfAujZuSS2ZA/GtCPeZXKJJnhc+oF3jNlXgcQZc
	76Fh/e2ottU0+jAMxM9O8D/qIZfvRZi29tOqEx8XXgPxq4VHm+HlD3PUdomPsPc=
X-Gm-Gg: ASbGncvRFNq62AeG7RHHbH8bNqkrnsVNHAGWVt+8fni7TfUoJ3jHZoJXcTONxELY4ed
	Nmmptnc1VtITJL0u9Wlwwd0yJI5+JUSIRim4ioz6MQ2prrGCV9myQ9rmOs+nukFL3uLymm9Wzne
	0aj9y4epig+UW3DEv27gcUjKwxj1OXgJ/7bVAxBS1VNbU9DO6CV0+tj7tYmgSZhxnLSVprhMJCn
	NXXJLtgniXw29D4hfKLbD5OHPgmEnlu09QqylCJUEVE3fQX1o3qK4R6jkqei+JSa7hDp18lXJkv
	pm7odtL3h3kLGMHpSaiyXqaUa5ulrqC8v5wzAAdbT9u+/aA=
X-Google-Smtp-Source: AGHT+IGWp5+1BVne358ySyNOgZ1qVjbCgfUJUnYbiNP8cDVB4maBnu+CTyhvHYo+RSuyGyXRNdH4eA==
X-Received: by 2002:a17:907:9611:b0:ab3:61e2:8aaf with SMTP id a640c23a62f3a-ab76e9dbe8amr395071966b.25.1738852782052;
        Thu, 06 Feb 2025 06:39:42 -0800 (PST)
Received: from [192.168.0.205] (78-154-15-142.ip.btc-net.bg. [78.154.15.142])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab7732e70e7sm108777266b.87.2025.02.06.06.39.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2025 06:39:41 -0800 (PST)
Message-ID: <46b7042c-8284-4523-b54f-38f97e70075a@blackwall.org>
Date: Thu, 6 Feb 2025 16:39:39 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 net-next 08/14] netfilter: nf_flow_table_inet: Add
 nf_flowtable_type flowtable_bridge
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
 <20250204194921.46692-9-ericwouds@gmail.com>
Content-Language: en-US
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20250204194921.46692-9-ericwouds@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/4/25 21:49, Eric Woudstra wrote:
> This will allow a flowtable to be added to the nft bridge family.
> 
> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
> ---
>  net/netfilter/nf_flow_table_inet.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>

