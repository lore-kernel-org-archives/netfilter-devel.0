Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C386E1F5850
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Mar 2025 08:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741163380; cv=none; b=kJ+JtsbgaEjrF7CXtIrSbrfsKERqpkfSYi+qxt/66OfqXV0dbXSey6veIXQvFoCGWItXxleHkP4z2kowvKm+JFDAOGaeGrT8BTU4gLBQ5PTqJVncXg7LE0Us1rKg3MlnMJDLbSxU/OeVKvcrMUCVcsVYJBPTUjw6scF2vKBrPPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741163380; c=relaxed/simple;
	bh=BIb8PPjZHUval8yQxPaR2VI3OQirSDX4w545WCXSCig=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aNEh3aIMRTTjN8Md70w0zfDv9cRhPD9lOykS8oOxZ96d0fmVNpqH2+7yU6HlDrTsBYRhV6FsN+N+9/pmJJLq1myh3Oh8j9CaCwVOfQxgNjVCKXrfqPD+RWZSIa9dna9Nko4xPfGuEeOuFHRPfsuvUZGM8bztZTO9eImjHz03d/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org; spf=none smtp.mailfrom=blackwall.org; dkim=pass (2048-bit key) header.d=blackwall-org.20230601.gappssmtp.com header.i=@blackwall-org.20230601.gappssmtp.com header.b=C/AInHnP; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=blackwall.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=blackwall-org.20230601.gappssmtp.com header.i=@blackwall-org.20230601.gappssmtp.com header.b="C/AInHnP"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-abec8b750ebso1132774166b.0
        for <netfilter-devel@vger.kernel.org>; Wed, 05 Mar 2025 00:29:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20230601.gappssmtp.com; s=20230601; t=1741163377; x=1741768177; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iS635IvOc12Hbl5A1UFbpTyLqQYfDtGYrejudL0pBtc=;
        b=C/AInHnPu6QEjteXzTU/Y+8cXSDnlwTkiooAJDKunOxZzuyXInimEwnJpecJbpBo3o
         S0UwivWB0GwvIyxeMHaN7kHTe8v9oWO8YEWbnI+3h9H+r6sM9huilXAF30fpcyuJxNry
         vQHWkiNk5GpMBotSLwAx8VmIyzmnw31+gj2/wYmyQ9aohqYul/YubmdUtV1YULJ3ueUf
         FZSqkMhgWVa4aibkSIeJZkFHujC/3ywr1mpvpJ70ptJ9X3Voog5WLOfvXh2hdfwIEPpk
         cvKKZhVCj0ZGtNxECF8jjfftN1S7xScxZbWrwuJLw1Zf9y0aK/TKDnTgPwJSsBEVb3Ez
         mWAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741163377; x=1741768177;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iS635IvOc12Hbl5A1UFbpTyLqQYfDtGYrejudL0pBtc=;
        b=Cgd9gp+lEFn5+j/qcttDVCkMeqN//gFanQbEsDVSxb7oTDTYT6cJA6TW26V42Hkmxf
         SY2NhB9RpnMzgbapsK+mHon9ilvi8KnaXQixd4xQvODItTL1ru3GD6tK/L+sLDP0sHkY
         7Q6QfjhR+5WH9khm+3+O4BD/RWUq3xK1hBBd4OP4E0fZlrBo4IK3gyUm7WkWtE3tqI82
         pGVhro6TjdVFCJVyfKfCp5n88FKC47D8ZQP7vpAtVH/eG7MuEE5Rnk2p74Zu2yRmBEJz
         TGH+aMuX6UjRfY0y4AQkjzkOI8TQFWZ72Q3W0kUhQrPMGtTxe4UYNZ8PvEUsrm7Ut1aD
         XL+w==
X-Forwarded-Encrypted: i=1; AJvYcCVcokYQRariE9iA5wdds9dUzUFrVHrsvwEah7Ilx5uGPg88OGwGx81y+K4qKotUwf0v6Ux7vac7rk+hgyNC2L8=@vger.kernel.org
X-Gm-Message-State: AOJu0YySVmjwKBVeD4hiitqUrBrQjD7EHiarQ1pn5txa374i2psnm+bO
	4k5J4xr57je+vTEVC7mNHgQM8EIwD+vmzQ94lymvnJGtIOlLxzAj3xR5qK24o3M=
X-Gm-Gg: ASbGncv+jNuZQg2hTgGUJ+Pl/QAmiEbjfgWK0SngUTfeY5KG6pEfCPx+O9FQfZEtOXI
	l7M8C5kmN/R1jhlSf5ukHybwDxtRxxnAgDtf8gwFzNCAOwSHKbchBaTRPcGf4TWxlS29EUZuNYG
	ABP4BasGruvm6aghtA9zcqwrkvW69zg1HEWrZKhd+l8hpcXi5OrnNoEyhScRIHeQDacIpYk5FMr
	isrBWWdms1ToKkOxej8DzSg4MFVVrgVyC+20WSMrJUhh6C+Bs8Sz9k2K37iX4Wp1J/x3zRRGbPd
	thecK/ifXK8aggVWMOstjTKbPJmlXKjX4/+0IwGXIUc202n9gEaNp12TEbaQPS4biF6CEbSm6fF
	9
X-Google-Smtp-Source: AGHT+IEjj5zOJcj1/OsRfe5VF46uWo7cJGLTZaHw0tlhP7T8cxub/kFHcc4MiHV1iodJ3D5MAmAOeQ==
X-Received: by 2002:a17:907:9446:b0:ac2:b73:db3d with SMTP id a640c23a62f3a-ac20da4c87fmr226467166b.4.1741163376857;
        Wed, 05 Mar 2025 00:29:36 -0800 (PST)
Received: from [192.168.0.205] (78-154-15-142.ip.btc-net.bg. [78.154.15.142])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abfa393dd6dsm453290666b.96.2025.03.05.00.29.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Mar 2025 00:29:36 -0800 (PST)
Message-ID: <1975f2a1-9461-400d-8b3f-f40e8b94be80@blackwall.org>
Date: Wed, 5 Mar 2025 10:29:34 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 net-next 15/15] netfilter: nft_flow_offload: Add
 bridgeflow to nft_flow_offload_eval()
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
 <20250228201533.23836-16-ericwouds@gmail.com>
Content-Language: en-US
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20250228201533.23836-16-ericwouds@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/28/25 22:15, Eric Woudstra wrote:
> Edit nft_flow_offload_eval() to make it possible to handle a flowtable of
> the nft bridge family.
> 
> Use nft_flow_offload_bridge_init() to fill the flow tuples. It uses
> nft_dev_fill_bridge_path() in each direction.
> 
> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
> ---
>  net/netfilter/nft_flow_offload.c | 142 +++++++++++++++++++++++++++++--
>  1 file changed, 137 insertions(+), 5 deletions(-)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>

