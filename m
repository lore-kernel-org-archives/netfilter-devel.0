Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8AF4F5E0
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Feb 2025 14:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738852703; cv=none; b=LYo+DHuZxO7gN7+EUsHKayGdrOQ9WVhgzKuFsCfwLqZgnlsnlO6Z/N9AjJKFnFISf+96uhWffgH8rT7bifTNzXCzXSWF9ujnuOuQugV5TVTj1VAp8kAjjObpaDHmFcxwuHtd3bhles2nWVClQfX7M3GjToF+f5oGzZO8wWrHmMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738852703; c=relaxed/simple;
	bh=wQw2TdeuTizcqF3Q9lrwzFprE3cAuiPJ1x44hiY1wKc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dmjS3bJ/XkdaJPvV5pYFoEo00tZGx/o00Ht0SCTE2lbQLZmI1oY/myfa8YWSqHgn3RQJOTesyUvLrZF3ksDLRm5Vo0RegeV9P6gVesbTnA8W56wAPVH/8KvSsM1e2aCBAO5vu3lsIj3PeIdQRWalWIr0h5LpZ7xJ34vf1iNH0LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org; spf=none smtp.mailfrom=blackwall.org; dkim=pass (2048-bit key) header.d=blackwall-org.20230601.gappssmtp.com header.i=@blackwall-org.20230601.gappssmtp.com header.b=yxb82rKu; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=blackwall.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=blackwall-org.20230601.gappssmtp.com header.i=@blackwall-org.20230601.gappssmtp.com header.b="yxb82rKu"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5dce3adbc31so1715436a12.2
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Feb 2025 06:38:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20230601.gappssmtp.com; s=20230601; t=1738852700; x=1739457500; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PGl8f7Yf7qIHwGS9qrFDj3Wy7/eEHYp4eEWPnG5nI64=;
        b=yxb82rKu7CGO8G07j/nAb1pq0YotoiKsSjDIi2m6WtE2gsVSmYeofNivkzv/ed/QyN
         6u0KAfju5eoAdlVjIAxZ2H4NBfVy4ZoOn1r8+ufYb12uRJY8ZER7DB2tfI33M5934ULa
         w5sWx5OQC/QRdHQMVxbssiGkuZR/916UrR03G9M4Diz5oG/H6qdoIxKifH74XzyWl31B
         P8fPQOgV1y9unbfi3N5pV9lTUynGDSofFaC2XAfZyg1zLbb7XjN5pDA8BuN5UZNV9WV2
         1c5JhseQIEaPvM0ES7qm07gT+SvcOYbcXRQfNZSkowtyXOOL9O+sklVTQbbnpUg5/L1C
         wBCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738852700; x=1739457500;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PGl8f7Yf7qIHwGS9qrFDj3Wy7/eEHYp4eEWPnG5nI64=;
        b=O5DnGtKf1ur36Z95AdckR9m79noJ37f36fJAhIHyK5m+swg/OHp1OucKc6nwXQ8ryI
         ZPQXUlEQETBJiWCt6lUjdql8qoPrGBEZu1BdT7h+3CqilcAooYnXNhhfHZNq+tluL47M
         xptQ0oJNBGVkT4kkI9CX9mM8UyxZraVKtIw/ecslOG6xFNhQ/j+a0TwLnITZ0cI7ijO4
         UP7lxosHULG145r59Qk9k6+JBlnj9GsdDA62Qm13Ov552cvNlQgzgD+DxV5w5Heyia2v
         pBm73XBIXKFLRwoGzgD0aHlHVEJJTZZHLHXqEe+fLPVRoPIrOXHM9OD7lM3gy0SrZwtg
         TsGQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwZQiZU+gOG9FW+Rm9vUaOROa24VNf8GnzSFVKtL/bmKmbNCcqcpVeOPlXqwjekfBcFpjKn3KKOmLmv+u8s54=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcPd+o0NI0HRwfvDHVG54HQkUQMHaG+cvwbhxhEtlOf5Ypcj+R
	Ww0JJ+QzyalmY4LTifMN917FaRNUBZGii7h6eOvMhGCR+ToWSpmPzd5y/ZCjFLY=
X-Gm-Gg: ASbGnct1p4uTxcwyXtmWFPVoOTP0PAqpB9Xv20BeSyRmYUhy4KMKmz+R+0tYEQ9AU3u
	p91n17GhiCtemHXh4i/YK4XDC9EO5ALZio5O9lBcMWsdE0dkahQYbiHi4kOvPEFaG94UCJ+jM+P
	YmxFPQo4QCa6hfIJEaUloBO5RcCvLY4kp3mBnlm1EDA0qi1KYehI1/dgqKdEteF14xPqRYG+qkv
	iPIzfRRc64m+d9Q0EVjl9L/EyR6MVPXoj+ykUi0PkaG9FdXM+V+7pyh6YuoXVChrcJ/WmfKWMeL
	zxvFlqz6tdwUcKSWBp6rLgWl2vgcVQz6sm6NzsO4I2+aTF8=
X-Google-Smtp-Source: AGHT+IHtlKzpr7zCul0guNkxORZKS7E5zmeQUNtvu4QsPr2PA2enKb+nYgF0UWob2xBe5euOje74bg==
X-Received: by 2002:a05:6402:35c8:b0:5dc:89e0:8ea5 with SMTP id 4fb4d7f45d1cf-5dcdb6f9f8cmr18518934a12.3.1738852700066;
        Thu, 06 Feb 2025 06:38:20 -0800 (PST)
Received: from [192.168.0.205] (78-154-15-142.ip.btc-net.bg. [78.154.15.142])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab7732e7120sm108661666b.91.2025.02.06.06.38.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2025 06:38:19 -0800 (PST)
Message-ID: <568586b4-aeb4-43b8-b645-a2a0517e3fc7@blackwall.org>
Date: Thu, 6 Feb 2025 16:38:17 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 net-next 01/14] netfilter: nf_flow_table_offload: Add
 nf_flow_encap_push() for xmit direct
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
 <20250204194921.46692-2-ericwouds@gmail.com>
Content-Language: en-US
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20250204194921.46692-2-ericwouds@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/4/25 21:49, Eric Woudstra wrote:
> Loosely based on wenxu's patches:
> 
> "nf_flow_table_offload: offload the vlan/PPPoE encap in the flowtable".
> 
> Fixed double vlan and pppoe packets, almost entirely rewriting the patch.
> 
> After this patch, it is possible to transmit packets in the fastpath with
> outgoing encaps, without using vlan- and/or pppoe-devices.
> 
> This makes it possible to use more different kinds of network setups.
> For example, when bridge tagging is used to egress vlan tagged
> packets using the forward fastpath. Another example is passing 802.1q
> tagged packets through a bridge using the bridge fastpath.
> 
> This also makes the software fastpath process more similar to the
> hardware offloaded fastpath process, where encaps are also pushed.
> 
> After applying this patch, always info->outdev = info->hw_outdev,
> so the netfilter code can be further cleaned up by removing:
>  * hw_outdev from struct nft_forward_info
>  * out.hw_ifindex from struct nf_flow_route
>  * out.hw_ifidx from struct flow_offload_tuple
> 
> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
> ---
>  net/netfilter/nf_flow_table_ip.c | 96 +++++++++++++++++++++++++++++++-
>  net/netfilter/nft_flow_offload.c |  6 +-
>  2 files changed, 96 insertions(+), 6 deletions(-)
> 

Too bad the existing vlan push helpers can't be used. :)
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>

