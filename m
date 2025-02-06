Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6B11C700C
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Feb 2025 14:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738851725; cv=none; b=bwo5TBRaSJuTWkY5optOPftAWJ/M7MBMoJ9xalZ8FlhMveoc46M3Y+CroFRZGSysVs3nX3gfdDUh1Rtncd+iWDWThXvZZbs37jCNtDB0F0abOXoj/ZZyeFfi4jvF0ySWtMJZqQcbKg/pbFnLDLmp8rg2vW+hIT8H/fYW2Kn/wv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738851725; c=relaxed/simple;
	bh=Qaii/4wx+f4RmmjpA6Oq2TvM5/xDsmQW0adSKnoxq2E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CsHGLkT6r0huumcHKFp21Rtg9ThI0c20iH9fzl8+Zf74s0LGWhsw+aB2U9EhhDoxta5s4n6YSHDdT+RqTKVMPw7KiwcQGE2zDVa+b2G6mam0uvUxXmX0vtRau41qOT9r0PL+1svnWW8MYVaAgX9AeGo61NceO90B2pXym9Q2vYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org; spf=none smtp.mailfrom=blackwall.org; dkim=pass (2048-bit key) header.d=blackwall-org.20230601.gappssmtp.com header.i=@blackwall-org.20230601.gappssmtp.com header.b=MO050eGm; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=blackwall.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=blackwall-org.20230601.gappssmtp.com header.i=@blackwall-org.20230601.gappssmtp.com header.b="MO050eGm"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5de3c29ebaeso211144a12.3
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Feb 2025 06:22:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20230601.gappssmtp.com; s=20230601; t=1738851722; x=1739456522; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AtE/V7UyaqCUm/jEvMcWRgFAvov74MHFiHvUqv3+ay4=;
        b=MO050eGmjK/sLxg+xPlq38AlkYnYkbbKteI/rJ0aqIRCdPLKnY2rMuCebzO6HhcGzB
         D8ews4ueLmM0QiITwODmLDz/PjSwMEi076XIe9NIkH/e9AMjpSmc0Ug63G8Jj7OZ9dNn
         e3N2VbEFys4pdIpZ2TB+HwMT+6Q8ADiK5iTlWeAYlJCt+eDKrfKy2tW5B/aaWOcce0lJ
         dAzr56scpiMlO41OqLg3wuIcDOo1yku3CcVAx83AzgtTdQLRb5euOk1iVmissu8QH6oY
         iFymGu0QkWAZsBepxsRZ1gG+rmOSl//AZ2rPiasiPYLRZVyaRcOWPbo2XH/HrdgJgDbt
         IaMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738851722; x=1739456522;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AtE/V7UyaqCUm/jEvMcWRgFAvov74MHFiHvUqv3+ay4=;
        b=ZqvS+9hOhjBz/5fx/bWOOtsY0zhfqcyq1jgpLUEF5ymu8o5Nc+Olh5jU/qCeoikK/k
         eawqaAiozPblSUdM8kQyI6vgsltiJk9wBxim7hKhnrVNnGduj6X5Qi9BBqPtFFDgaQrD
         WtHpUZYSyAdZl15pPORSt2KcwnyLHFVMKetsKdVdaQ6zCyggMxhuiT2/il1HwrJg+kUI
         YtDP2UAJC2Ya5WQYyGfscdkztHHI+H3T/CLNx3+0PFdZXBTp9QCxeUC9UIg/3KNOI9Cy
         Z+aPBKNTR1ei4hjGGFcp8+bXZx+L4U3ByRMWtAl2qxr27JI1RB3yrz4CrlCm8FbYbdD/
         WDRQ==
X-Forwarded-Encrypted: i=1; AJvYcCVyPW5QkBxtm7IsAXc+jKLlDJBLTQMtm6Dd+80PdZn7ZG3Xt1FUl4sLU3TQOJcPwlJvluxF4+MnTLOw89GRMXs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOYRYzzCYlnyqkTkxqZKU79foC1oZSiHVWjth3d93CYBtivagO
	YzkZqzA1wAeMnj8+9dOlLevTk0O0Y6dHCmVTjyHjOhAVbKjYpmKf7wuNqGEuX9s=
X-Gm-Gg: ASbGnctWuT0eXtsZtJRArabyXOyAVz3U5nmg8g2HQHZBzRBOaeve9mcU/aMgpkUaa7K
	QDGdfd7MXydw2DSy3x4FOU/+Nd5gEWr570bE09YT3ES7inQMTbF/YZDJDrsJ1Qyr2WD+OEnMnKK
	0XkqZI4+tHE6Ob0lwWkEAhGYaaKO6VYVtA3LuLU9XlSLQULiMz+v9dFlYuqJjpOdaTu2JqNjH4W
	Nsh5skJoWWH7+gxpuWb8dh1hjEiuIjqPgSYUMTSlYyf/VYzBmRWuB5nYcpkPcT35C1sfKAG5WWV
	OYUiuB/FnobU3G0pY1cBavXyXKba0FkKu2N37crnGlBFtJo=
X-Google-Smtp-Source: AGHT+IEe7WdSsNkjgnty/HyvHskjlhljY6wt44W4IMiUaDBB3MI2H2nfwFKZUIVfpj7A/eSHa7SXrA==
X-Received: by 2002:a05:6402:4486:b0:5db:f423:19b9 with SMTP id 4fb4d7f45d1cf-5dcdb72958cmr8121194a12.16.1738851721184;
        Thu, 06 Feb 2025 06:22:01 -0800 (PST)
Received: from [192.168.0.205] (78-154-15-142.ip.btc-net.bg. [78.154.15.142])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dcf1b85a3fsm941354a12.46.2025.02.06.06.21.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2025 06:22:00 -0800 (PST)
Message-ID: <cd2926cf-b32b-4de7-851e-97a3ce2118af@blackwall.org>
Date: Thu, 6 Feb 2025 16:21:58 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 net-next 12/14] bridge: No DEV_PATH_BR_VLAN_UNTAG_HW
 for dsa foreign
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
 <20250204194921.46692-13-ericwouds@gmail.com>
Content-Language: en-US
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20250204194921.46692-13-ericwouds@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/4/25 21:49, Eric Woudstra wrote:
> In network setup as below:
> 
>              fastpath bypass
>  .----------------------------------------.
> /                                          \
> |                        IP - forwarding    |
> |                       /                \  v
> |                      /                  wan ...
> |                     /
> |                     |
> |                     |
> |                   brlan.1
> |                     |
> |    +-------------------------------+
> |    |           vlan 1              |
> |    |                               |
> |    |     brlan (vlan-filtering)    |
> |    |               +---------------+
> |    |               |  DSA-SWITCH   |
> |    |    vlan 1     |               |
> |    |      to       |               |
> |    |   untagged    1     vlan 1    |
> |    +---------------+---------------+
> .         /                   \
>  ----->wlan1                 lan0
>        .                       .
>        .                       ^
>        ^                     vlan 1 tagged packets
>      untagged packets
> 
> br_vlan_fill_forward_path_mode() sets DEV_PATH_BR_VLAN_UNTAG_HW when
> filling in from brlan.1 towards wlan1. But it should be set to
> DEV_PATH_BR_VLAN_UNTAG in this case. Using BR_VLFLAG_ADDED_BY_SWITCHDEV
> is not correct. The dsa switchdev adds it as a foreign port.
> 
> The same problem for all foreignly added dsa vlans on the bridge.
> 
> First add the vlan, trying only native devices.
> If this fails, we know this may be a vlan from a foreign device.
> 
> Use BR_VLFLAG_TAGGING_BY_SWITCHDEV to make sure DEV_PATH_BR_VLAN_UNTAG_HW
> is set only when there if no foreign device involved.
> 
> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
> ---
>  include/net/switchdev.h   |  1 +
>  net/bridge/br_private.h   | 10 ++++++++++
>  net/bridge/br_switchdev.c | 15 +++++++++++++++
>  net/bridge/br_vlan.c      |  7 ++++++-
>  net/switchdev/switchdev.c |  2 +-
>  5 files changed, 33 insertions(+), 2 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

