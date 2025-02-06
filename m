Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED01236447
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Feb 2025 14:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738852749; cv=none; b=YqwpXPsgD455/aIy9Hs6FoNfrDOIbt3AmXv0rBmCdQqr8d4ESCPzaDCjvXn17zw7IMyWsuHLYkyGa10KsY6bjYg7joDYJmGl4gwhoab4XiJK1iEeoswdS3HxDT5iWOZf55VvuU3JZkO3yjWlCaxmU6GUujis2AXwi60HUC+Erpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738852749; c=relaxed/simple;
	bh=ISXGN/k+kX7BuDCNrato4yYtVy7+BXIuaTBPg+6KtsI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aoxwJSVYMKwoUkTG1bfwT0gtclWOpAMfgy/ZA0z0Q/Qp6itk+FU/8HoNZ8YNe7C7Om0QcIAtE1iR7PN/vFRcfvoO7qPTw/eX5X0boPlwq0MEgy+lKRvQ30NX2LnltjLbi3FFDWqapGNvZxxdNih0ROXYuKrQdSl6k1YumD8NJN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org; spf=none smtp.mailfrom=blackwall.org; dkim=pass (2048-bit key) header.d=blackwall-org.20230601.gappssmtp.com header.i=@blackwall-org.20230601.gappssmtp.com header.b=sj28Y190; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=blackwall.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=blackwall-org.20230601.gappssmtp.com header.i=@blackwall-org.20230601.gappssmtp.com header.b="sj28Y190"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5dcdb56c9d3so1705308a12.0
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Feb 2025 06:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20230601.gappssmtp.com; s=20230601; t=1738852745; x=1739457545; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S0JkQI3U6f+a8v60Ya7beYBhUDwWewUAZsXtUyTx0ac=;
        b=sj28Y190ZWUnke3mXhBKqYOJYbdhMa0A2ghzlmCVtvr0hOmCUOxMC8mP4IR8QuuCMt
         zkLcvBspqAEdNQpX0Nnu08Ax+kuLBE0m51+33u1yrSbaJXgYVxDdfsT1vvA2DeeswjKT
         +tHgNclcpn09FV+Vd+qKX5xSb9uzGFrpELKMicmW4SdrYw8WgaQuFOMljzaSC89tvRqb
         jxgpiSu09FLGpxDaXZldZ6MsKnQleOV8DfwoArpRPIx3iPvBWNHKUc7dft3kGbxa3HSX
         MfrOFTrwPDedhP3yV+VPNtvlHAvEyE/mhu/RQDCqDWP3PQ4Vn63UfqiAj3j0ievDfI50
         osMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738852745; x=1739457545;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S0JkQI3U6f+a8v60Ya7beYBhUDwWewUAZsXtUyTx0ac=;
        b=tyByCdLa/EyhrSm7c7SwOOfnjKiUGZj4mBPczpzRf9EOtpcIkUip9zPN5yEfQIAGY2
         XiCvDjE6wy0j+m+OkWd+UCEh5x6CMKYFiK/C6ZMAAqGEv638qYPGp1cyUSKM/JnfjMiH
         pDQOMoiJs60OhZxhopcMGYDtb0sBEPYsvmNJuCXjH2L8uLv3WYSwwEW+Nt1RakDtfx2g
         PfXBv16opZqHNJtSvMWruJoBgiNBTSvJAigzl/EOcQ2Hw0jiboaiUjoNHhOFFXcWWJJR
         dGfQOMVpxtW92/Jy6HLuSz5Y7FXhSEopBHWZQeAZS6Ky2UzbBiLcwAyjlpIWkETRmGa2
         APTQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIU6MIO301MMUL3fXGwhGjZWPjtfvDjmi+OF3SvjpzhfssruVvMBLgY+2D+KVy/5VZwVNLphqr1qMj6Sv8Tp0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVOHgtPtjD84hVG3V9k4jZDRBNSD1AA9DeV5XuJDt3tTOTkj5G
	Q9hQcZaZVBme9BomYncOJfw3Ygyu2SfeC7wilG3620Ve+OiHg/dkFnC32QOTxzs=
X-Gm-Gg: ASbGncvOPnEg/pQ3b3toUaZbCj2QH4weGE/POdezOnMn2NsJ4qvz/ovlkQyURwwoEcg
	66CqdAQCyRQMS5W9d75jhtFrWGNKYdLf38RFJr3goMQQUOugQEdvNfdkvZ4GLoYQjj7a+pZsW6U
	8KGHcXUAd+SfrCX0g4YZbBe2eKnT8JD/Plaoupj93rIlC1dvnla7tyhBtfTYkTnnzZJ1VcFZDjN
	ueHdD4yl0tkpqtXjtE4lqNdJPVH/PhDiBQHWAmzzM4DiPwj2y7fNR6cDg0td7tX6lgWpbcOcQEw
	cVQPBMaaUGnsSiBjYZIXUxlwGjnc+MpcD4QZIwzSZXH/Zvg=
X-Google-Smtp-Source: AGHT+IFfccbgqNHY4pVflwA0HY/1yvIqL3O/a0V1EXaUtiholMev7dwDOL+lRjcs6CbBMFf4cXAhig==
X-Received: by 2002:a05:6402:2812:b0:5d0:bf5e:eb8 with SMTP id 4fb4d7f45d1cf-5dcdb762d40mr15968196a12.23.1738852744810;
        Thu, 06 Feb 2025 06:39:04 -0800 (PST)
Received: from [192.168.0.205] (78-154-15-142.ip.btc-net.bg. [78.154.15.142])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab773339349sm107647866b.146.2025.02.06.06.39.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2025 06:39:04 -0800 (PST)
Message-ID: <98c8cbec-28f4-4814-bce4-e07101553f92@blackwall.org>
Date: Thu, 6 Feb 2025 16:39:02 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 net-next 04/14] netfilter: nft_chain_filter: Add bridge
 double vlan and pppoe
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
 <20250204194921.46692-5-ericwouds@gmail.com>
Content-Language: en-US
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20250204194921.46692-5-ericwouds@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/4/25 21:49, Eric Woudstra wrote:
> This adds the capability to evaluate 802.1ad, QinQ, PPPoE and PPPoE-in-Q
> packets in the bridge filter chain.
> 
> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
> ---
>  net/netfilter/nft_chain_filter.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>

