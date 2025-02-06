Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE82236442
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Feb 2025 14:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738852764; cv=none; b=uOgC+LDUZfMKQGWyWrpXGwQwrM51OzU5VESV96NQFdmxZHEaEts4UBomVk0MD2gQvruW4HdhaeYQreaJaj/a7/5cxBJWpPqBS1JVdsZYarDbbkteGlmYxNjTmqm8TLYLLOEkUU1zEZ//sVaRAXrOjSdz3MYWdnC6VHoUF1yOnCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738852764; c=relaxed/simple;
	bh=Uu8aEP8VA8t1pCN7nvIDtXe9YZ0sStLUfZzdpt3Xdwk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n0a6+mWbyJ8UjyeXmEcZYyrZW9Y4SOgPcsSGGFGl09ysAmiuNHkA6O4+0q4F1G3UQxTiRuMB5QGxvE7lNmqSE1xsc5fVviYiGgAVzbjbnq88QsIxSrS3CA+tvs9p2CNf9fEKaRyWq3RWu0rGcQOGrlZZLDh83KZBUu19vK3Aj4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org; spf=none smtp.mailfrom=blackwall.org; dkim=pass (2048-bit key) header.d=blackwall-org.20230601.gappssmtp.com header.i=@blackwall-org.20230601.gappssmtp.com header.b=nS58+4LO; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=blackwall.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=blackwall-org.20230601.gappssmtp.com header.i=@blackwall-org.20230601.gappssmtp.com header.b="nS58+4LO"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5dcd8d6f130so2021089a12.1
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Feb 2025 06:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20230601.gappssmtp.com; s=20230601; t=1738852761; x=1739457561; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=THjRLKw27fymwkm9c9udCcZ4ry8EIlt6eJdjpKX8aMI=;
        b=nS58+4LOG6u/Q5ccdch9G5EWZXlco1ayiEjfSMtXeD4KHtM0gHL3VN6RGk38uCmt5t
         Oc1QT11cxpBtlZ7J6cMHsPLGuIWjxT8hf/GUer0jGV6PneXcnspl8Rx9f29MHYVY1knt
         BODAkrTcImAboCfJIwCA7ot+15ooIr7DmrqOX0VyCEkeDCMNx1Q1YlaPhCrlwMKtE6qG
         5vMd9IF3RURy/IG87UyUoWMOoDmZ4soLRScIXcgoTKVgUouv08GdLpqzxXE6rIfwPhwx
         vd80oxE8H8nGLHk2HHU4TJclxaz0kZi4YTpb3h8w4X7fmMHz2ouYinsEs6FF5XwqF4Cv
         UO8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738852761; x=1739457561;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=THjRLKw27fymwkm9c9udCcZ4ry8EIlt6eJdjpKX8aMI=;
        b=vA6StS1A3KunjXO/cNv4m85M0IZ50S93PyCkjsp1WaBBULjXRhbhEaj0SxlejVxHB5
         NWAUHZqyIRmBMWR1LAwbC/CIYhdVIWpHFVXW7owfMIPXwcMTLhpKznLZtJhzfeDG2yE7
         X50ckPdkK0/1obZLexGtzytAHptwnfMycOJt7lL51uRK3bwP37jkORs8SxPgM80IYrfU
         mIf63JhrxRvp2GLkuVLkArhLXDmfi1ujDD5hQFhG2fpmqystTC2Tsd1jrLSEpAkF9BPg
         dsx+wV/iLzt38X45S9ScDalCDtQiJvWqh2GgwFElOUobmFY2zWQB2jlFi/Ze01Y1lMWM
         JvfA==
X-Forwarded-Encrypted: i=1; AJvYcCVA3lV2jA/ornxgSZ3nDZTYiTTG1Kur3MWWQAUXf54t7w3fD0EuZE76H80UExEjW4iq5niTBz3+4KXdmknq+MI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGhjhL++03Xyh6sunTqAV2uo3G0r6aSkMim3LxOi3O3mLVNGQd
	flTtLbqMkMX4VYRln+FLnbZctgcEpP+vBRzUB9vmmCNhNLHy2UKH3nXsbZCgt90=
X-Gm-Gg: ASbGncssXTobyppPevt2H0ebZWpYlDpGZWRuvG3ICEEOdCWEKbDSG7yPT5MhRxA4J27
	54m9KPdoohaWRlQgUOQz/ZVLSFE0X0j5d7tY5pHgSQqPBGy8eAwmR5dlohNSXZDQ3zOC+DC/U+d
	P3yq1pGEscVyuWcLGX/id2eN+SmDNkh7xCWSe7mlcCXEvsFgEpTCxVD2J9/VDiQUGF2IuvPTPWT
	nbkhJPRvKhzb5FmxpAW4fCje+Ei4WS3J0+EJEGaZekKHhl9Ggw5JVethi1J68UEQVyWDzrWzCVG
	7xahK0sBVEantbsEXcwHyqn5YitcIB+I4LeLJCy/T3g2Khk=
X-Google-Smtp-Source: AGHT+IFlbmeulV0zbsnKd23pIgbY7sXFFTYPJ1StMcXHIPOGJvEQyfJ18rL8z1Xxot6BGyZS0rrfLw==
X-Received: by 2002:a17:906:ca48:b0:ab7:6e14:c03f with SMTP id a640c23a62f3a-ab76e14c0d5mr312575166b.21.1738852761390;
        Thu, 06 Feb 2025 06:39:21 -0800 (PST)
Received: from [192.168.0.205] (78-154-15-142.ip.btc-net.bg. [78.154.15.142])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab772f843a9sm109650266b.67.2025.02.06.06.39.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2025 06:39:20 -0800 (PST)
Message-ID: <114ff1da-c7f4-4851-af3e-1a4fdabde9f5@blackwall.org>
Date: Thu, 6 Feb 2025 16:39:19 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 net-next 07/14] netfilter :nf_flow_table_offload: Add
 nf_flow_rule_bridge()
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
 <20250204194921.46692-8-ericwouds@gmail.com>
Content-Language: en-US
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20250204194921.46692-8-ericwouds@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/4/25 21:49, Eric Woudstra wrote:
> Add nf_flow_rule_bridge().
> 
> It only calls the common rule and adds the redirect.
> 
> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
> ---
>  include/net/netfilter/nf_flow_table.h |  3 +++
>  net/netfilter/nf_flow_table_offload.c | 13 +++++++++++++
>  2 files changed, 16 insertions(+)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>

