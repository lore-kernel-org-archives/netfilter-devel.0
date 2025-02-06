Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89205225A30
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Feb 2025 14:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738851798; cv=none; b=uJa+9datkq5kNp/XfbFC4PK25xcTUmCPZr36+xkoWJZsbipuzh6jcwSWVvn3ZWrkoMAlbeqMfr12Xb8GwuF3vMV72jY+9S6AA54uSWq1v/fZKoULcJHWiKVFkW37PmGjNyGp7BhV1zyGPpn9LLGdVhkM4Jp7bP6R43+7O9dFMLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738851798; c=relaxed/simple;
	bh=hYNDYZyhU3vPLzYPSaPWEcPzJSNHuY39jWh45uxHumU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D+xgsc9tbArYkFPrAVTrvV3JdTrllCvuOY07CGomceXcg7V9UdEOecXZDWrrSyGlQFIfCrSNFWZSI6LCJpwrXQz0ixKV36VrpXx4oJgYo4qlVfklUmM42gDk6T0h9cDSBYKVlw83K0uXyfqr2QojlJnKJhtYvtxC/3/PhTnKvL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org; spf=none smtp.mailfrom=blackwall.org; dkim=pass (2048-bit key) header.d=blackwall-org.20230601.gappssmtp.com header.i=@blackwall-org.20230601.gappssmtp.com header.b=w4WBJPzX; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=blackwall.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=blackwall-org.20230601.gappssmtp.com header.i=@blackwall-org.20230601.gappssmtp.com header.b="w4WBJPzX"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-aaeef97ff02so171473966b.1
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Feb 2025 06:23:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20230601.gappssmtp.com; s=20230601; t=1738851794; x=1739456594; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gFMFd8yvXqVnAGCGrRETRe/V8KRYdG7T8ArDcX9VBwI=;
        b=w4WBJPzX5UOyQ4pAoq2W+LwYbdYtyhv13tvBJnEyAwICDjjNPnZJdDRsX1IFceliKl
         4hD8mN066oU7ph/Y+RIveutEVH3p95RV7bChlz5h0viKFz1CfIB4G3oRIvDEt1KzziC/
         ZT6r19Aa1ISdkPQzzRxSrq37Pf78WKrbKwdP1LEkDD+8WHG6Q3kqZa5v2uPDaTba1Trr
         g2hEIDczbeLjDtzpWJTEawV5dNbp7aFPxf0Km5LPPuhLjdjybpBq28lp1sWjmWb08qjv
         KbLbOvUj7i8WEWfdScP3L26R4oNps+CVHb3VxOHsOGaHnsM+9kjbTGXXPkd08fUew9XN
         OYLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738851794; x=1739456594;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gFMFd8yvXqVnAGCGrRETRe/V8KRYdG7T8ArDcX9VBwI=;
        b=YOVkJ+mR8a6+HcymPxfgtAXNnH7+EJRv0u5oaHErRdhz9txhM/lyZG7B64f4ERc01K
         KHkoFyFu71phhR3o3iTnHwwntc6aXRAQ2VxSTO2XG+Fmig/RV5Rv5ZK3ICmI0HOgVmM1
         SkhyjDbDUT+T9RNTg1CZ36L++O9pst/P2Net//9RiftLsjqhVhSZ5D+0VErM5jRYuqQs
         +6/JZRteEUHo2W8ErV2KrfxTJEbu8BojnSXPE7TIb9dB6tsbiKEOZXVuHEwGVpphBm+6
         0yXUrZvtMbzoUU5cJPxSTKgEnTjGYJWlB3Fo8+8NQxqcqqSP5nrA2bD1S3nGKZM9jY25
         2GCA==
X-Forwarded-Encrypted: i=1; AJvYcCXpiTU7CJQWkLUV8wwzXxT8WhuEftiJuFVL5+tPKbd14y691wGJe+Rerfprkal2dxNkQvlUT5xvL8sSjb98xV0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBPuZj0ENYgRKBuSOJ6Pw1liQI0NCiy+H2UT/vMM9gIyRa4Ksl
	5jeH2ys72WpF1J1ARJIsVzusa6PzpyEYD8cDSqCGsLZlkA6L5EjZpMCFarjcJL0=
X-Gm-Gg: ASbGncuhZli+XZv5yK7dIq6l/JJK8JPuMesfqTmu9ie6P0vcO2qSdy/43zx2gMk3WQ1
	xuWeCvhlLjFjqoo2opzGh9PX+xJGfrHoZprU4cPnZ9GeYjXqdkzzHVUC86kIltoQmRcEv05nVEn
	phmMV34thsJi3Kh4PbQolPko/Njv/4rGRfgeZT0QXWemk29olF14kCwONdfXycLtIdInDClGGi/
	/BS4XbbXqJrRD5IDbq+6lUyXG5RzKv47X2tjNmCVTT7hRONKxLKUYpJ508RmhH2PefUMbDijPZF
	N+o8F0+7n2KZ/GfpAGLblbC+wXEYrvqz6FeXawXKMCcItGA=
X-Google-Smtp-Source: AGHT+IFFyvQfINAl6lz2A01y9ohntI7gR0hYfp3ILlqctgCUIUMFbzNkfcNhO1QK5iS0p6NSxCJe9w==
X-Received: by 2002:a17:907:8694:b0:ab7:b93:f77d with SMTP id a640c23a62f3a-ab75e245be1mr816768366b.3.1738851793676;
        Thu, 06 Feb 2025 06:23:13 -0800 (PST)
Received: from [192.168.0.205] (78-154-15-142.ip.btc-net.bg. [78.154.15.142])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab772f486c7sm106211766b.23.2025.02.06.06.23.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2025 06:23:13 -0800 (PST)
Message-ID: <5de6707a-6a77-41d1-8964-19667a0e91b2@blackwall.org>
Date: Thu, 6 Feb 2025 16:23:11 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 net-next 06/14] net: core: dev: Add
 dev_fill_bridge_path()
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
 <20250204194921.46692-7-ericwouds@gmail.com>
Content-Language: en-US
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20250204194921.46692-7-ericwouds@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/4/25 21:49, Eric Woudstra wrote:
> New function dev_fill_bridge_path(), similar to dev_fill_forward_path().
> It handles starting from a bridge port instead of the bridge master.
> The structures ctx and nft_forward_info need to be already filled in with
> the (vlan) encaps.
> 
> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
> ---
>  include/linux/netdevice.h |  2 ++
>  net/core/dev.c            | 66 +++++++++++++++++++++++++++++++--------
>  2 files changed, 55 insertions(+), 13 deletions(-)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
