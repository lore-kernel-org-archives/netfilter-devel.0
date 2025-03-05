Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8268F1F584A
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Mar 2025 08:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741162899; cv=none; b=PZMbBDlSJkjvJYybB1mLEyugD86AkWKE+FSauqJpKEh7FtJcc4D1yhPYc2B/MeDz6FtIfISL5CRZnVDOoDdYYQ8VnfDBFpwICoq5KDYqQ7na9NjoAt2DU1+hBeQtNgsx6sYqVwPhiUNeVAhr5HCrE1+dsa8/58sCMCdvW7z51ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741162899; c=relaxed/simple;
	bh=Dd3fU7x3Zyy9J91IPT2gBtr3RmiUZhQvAeaOmlAbIPA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BC5aSKoJy8cKh2xdLgWb+z5yTK65w3txHlOakHfo4as8kNPLZWbRUHd4TUJYYE0onreBNKRhCQiF3f9BVTHa80oi2QOpLQeVwpFyqkrzuCqhTnkjeA77Vmh46WjYafFmGQgKKfOiHY3ddBeoLBs1/RPqjACb96dafpr7mEE9JfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org; spf=none smtp.mailfrom=blackwall.org; dkim=pass (2048-bit key) header.d=blackwall-org.20230601.gappssmtp.com header.i=@blackwall-org.20230601.gappssmtp.com header.b=A2bhTYH2; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=blackwall.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=blackwall-org.20230601.gappssmtp.com header.i=@blackwall-org.20230601.gappssmtp.com header.b="A2bhTYH2"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-abf45d8db04so661976566b.1
        for <netfilter-devel@vger.kernel.org>; Wed, 05 Mar 2025 00:21:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20230601.gappssmtp.com; s=20230601; t=1741162896; x=1741767696; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Nsv6iruxF/55s5GG7wPPBagKb4juSNlpcghKgAFq1qg=;
        b=A2bhTYH2IUKPMamHYkFV5kaQY8j11XM1Rkzkh8OksbViihKIHdIyYaOl68RIpO6mJ9
         0hS5ZGLixOaBzMhOI+yG6WhYFTQ4GvqL9Nc/G3etuoWG7vQVXGzS+zuwOJPAXifC/UTl
         XF/kDOlaCo9md4uupo/S3HQC0igucI4fKqBDm52qzqnPbGZwkujc/SsZj7uw3a/yqdsK
         R2R5d+LjtiqUYkiv8EgQiG4rLJm21gZmemC1eIyLxXGlwhxKO3jmhAf8UIXj0PwCpkfj
         sGTOddwdQTN5kI4jOrmHFMWg2zZHCLBhrGM/Fzp0lRv+M3RkPsvVT00gLuCjUT+aoHAy
         Qp3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741162896; x=1741767696;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nsv6iruxF/55s5GG7wPPBagKb4juSNlpcghKgAFq1qg=;
        b=RFkSeoGcD0qw4Vg+RkkHFgJJdbE0mXUo9VMQNIKH9ad/u0nkaZIwr8jDjL1jes07K9
         zZpTwMezTLZRHCJ7skFWjB0+3Vu7OnRFS+OF6p08by1EgJVAhYeC6mSraw3sepbZlx9F
         nVITBnOleQb2xkbm4JnB+WEDBO/VWZJY5nT8sJvDXYmno3QVFXWNlnBghRzEX3pPcCvM
         Ieo5oAb0tVasoXtUa+TyWVk3hoUMim066xzPAE2lBbv/q2LB1LJi4eibgUYBvo/0Qf1h
         rc5e1gxpVK4/4IEjMMNTChRtFE09eb6ztWeJSMEJSg6SFVrc6xzCY2N3gm75/AJQrdg+
         nrrA==
X-Forwarded-Encrypted: i=1; AJvYcCVKQgerLP8mmR/l7KQ5cp1TM4xMt7re0A8UKSM4fL/wg1OCS6F0V4mqj3Z1srOECQNI2Dyc4SUfGOGHRKcck8M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyz7SOaDJfyKRdgaYTGsO5sIUVsynf4CgHyP/UGSTZNJT2/7yV5
	W5aJ3yoUqZd9jQdOCmJPrWqcBrscw/MqpL2fkfrAcJBv+qsWcspaJwQGPSk80c8=
X-Gm-Gg: ASbGnct/RK48rNwnbSF/Kz400PR8cKxabHAblH9Y1QMfwCvsqsgfmrDhZTE2OBVVPck
	1s8+1S/+fE0J8TO+Q1gPN9EBgu50Cbdx3+SGnEULV04aiZbluPf0J/8UBjoPlupV09hNl3nUt4g
	etNPS3gqnTOfoEH9X1ZiZLfC3L0YiP+nlZZ67W8XnNnjd5icUgUA4gOYsPo7BeAQiPVEt8wOgKf
	6o8PSNBUdRUoRrYR72aZiga8XWAZvxPMXTCPbZ3B517SLiZz2R8m9HrGV6NhX3p7EqWkFBwedc2
	Zbg7qO9nOV0veqMjbVO3LLspX/Z384lYLEE8DEa4Y6ZWcyaCpA0cmqZKTWUfZWmkUVdYpiQcwV7
	R
X-Google-Smtp-Source: AGHT+IGaoXnq3lSxzaaUwAuVfK+jenlYaXFrv+TPSgSHSnmbmoUQLeCI462sahYSphebEzq/qYnUHQ==
X-Received: by 2002:a17:907:7f0b:b0:ac1:fb60:2269 with SMTP id a640c23a62f3a-ac20d925048mr217259766b.27.1741162895402;
        Wed, 05 Mar 2025 00:21:35 -0800 (PST)
Received: from [192.168.0.205] (78-154-15-142.ip.btc-net.bg. [78.154.15.142])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf58804b49sm693744066b.26.2025.03.05.00.21.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Mar 2025 00:21:34 -0800 (PST)
Message-ID: <b3b5418c-65d5-48bf-8868-2d9abcb4f758@blackwall.org>
Date: Wed, 5 Mar 2025 10:21:33 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 net-next 01/15] net: pppoe: avoid zero-length arrays in
 struct pppoe_hdr
To: Eric Woudstra <ericwouds@gmail.com>,
 Michal Ostrowski <mostrows@earthlink.net>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Jiri Pirko <jiri@resnulli.us>,
 Ivan Vecera <ivecera@redhat.com>, Roopa Prabhu <roopa@nvidia.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Ahmed Zaki <ahmed.zaki@intel.com>,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Vladimir Oltean <olteanv@gmail.com>,
 Frank Wunderlich <frank-w@public-files.de>,
 Daniel Golle <daniel@makrotopia.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 bridge@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org, linux-hardening@vger.kernel.org,
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>
References: <20250228201533.23836-1-ericwouds@gmail.com>
 <20250228201533.23836-2-ericwouds@gmail.com>
Content-Language: en-US
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20250228201533.23836-2-ericwouds@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/28/25 22:15, Eric Woudstra wrote:
> Jakub Kicinski suggested following patch:
> 
> W=1 C=1 GCC build gives us:
> 
> net/bridge/netfilter/nf_conntrack_bridge.c: note: in included file (through
> ../include/linux/if_pppox.h, ../include/uapi/linux/netfilter_bridge.h,
> ../include/linux/netfilter_bridge.h): include/uapi/linux/if_pppox.h:
> 153:29: warning: array of flexible structures
> 
> It doesn't like that hdr has a zero-length array which overlaps proto.
> The kernel code doesn't currently need those arrays.
> 
> PPPoE connection is functional after applying this patch.
> 
> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
> ---
>  drivers/net/ppp/pppoe.c       | 2 +-
>  include/uapi/linux/if_pppox.h | 4 ++++
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>

