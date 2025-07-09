Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF00272802
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Jul 2025 07:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752046679; cv=none; b=CIspMg4lYUKR1XKlyhnhoH+4vi6hkj5azYEzqnHGe9ElUzsePdZYiU+6qDeQNB1IMCdIPxrNO/qy9CARpSgugTD6tdGPb03KXANmWnqjvbuJ9UIUi36eE8ALJiAeIGv5On5RKG325glow0FL5mTCOqq3jOehVu19y1O4naiig70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752046679; c=relaxed/simple;
	bh=9OPmNg1Ke93Fs8SkZKBisFI6U+uVxoHqsm9QDX67Rgk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TTTztgcEz7wm8BrYUQ38xKhhRIWvOgIe8y6XDnrF30DnZSEhFbw7diCokUMt8zjyIEhpwUu2zfVLadVPBLD3hSfCnK0r5SFukZND4i2SZzNo1BVj6Naeg0O8pX8LXPjImfBoK7oBzIFIQSzmAE/kWTqSuXA+mH2iU0wQh6k6Kss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org; spf=none smtp.mailfrom=blackwall.org; dkim=pass (2048-bit key) header.d=blackwall-org.20230601.gappssmtp.com header.i=@blackwall-org.20230601.gappssmtp.com header.b=Fyx0jAOV; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=blackwall.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=blackwall-org.20230601.gappssmtp.com header.i=@blackwall-org.20230601.gappssmtp.com header.b="Fyx0jAOV"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-607cc1a2bd8so8537899a12.2
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Jul 2025 00:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20230601.gappssmtp.com; s=20230601; t=1752046675; x=1752651475; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7AF17i32IwMLY62AXSip2mxJYEDMY02Ret/Hrjg5ZK0=;
        b=Fyx0jAOVtP481WsWBZ5NWcYpPL1fT5ZKqKrZq+LAj+HgBJf945INpeqp56yXMTt9BI
         1eE9321Nax0+yrQnBRuLuX384KLwGUk6XIEy9adBSzXKf+tGIFjiN/uRiRBdzouYiHnM
         ZqnTu4cQNzotKyKcUHeaImmmetjzNbVlzQtq+r7UDGMN6AuxbtzZQEGEtQaQLD6xFdOB
         mEGrJdrpxT0NLzlM7ZjgqlGsUQVNgRh1EoZ4mQJfs4xByBRUu5IzeehyDSSuLUl4mdEt
         XgBN7nNkfWDPUra62kCWaPl94JtN+PGIVnZKKT+YTh5KAV7PRbINNxTZZOXlPF7D7tLx
         0grg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752046675; x=1752651475;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7AF17i32IwMLY62AXSip2mxJYEDMY02Ret/Hrjg5ZK0=;
        b=jFVKlH9bZmTfOrYpn26radwwG/VNzg8r0tX7/BukaJ69PvpJhG+IYf2tGnkWRyG+GC
         N7fF4aHDKdbZZP5eluO2UFu9M1g9XiHn5EJ+VgiSRqlR1hKZ9+qTd+R6Qrm3i+d1qeFE
         jSan8IgguW9ZP3IImoxuVZeccTZeH7e3CWkBgz0Nijn1Aq3bRONQmpTKAWC8RlfYkCiK
         OJQDZ10HvlTPE6OYswwjISY5izb3lkfWpIYf1cDjZ8mF45JwToNrjImb6Q72VgLpVu78
         yMn/WyJ/mCWhH+63rRgwIYRpT5sALN3inCpPm71DDja5zrrSElt2RrKZKWDBrlNPBiyv
         r4HA==
X-Forwarded-Encrypted: i=1; AJvYcCV2eKMK5++5vMSioO9c478K9CajKgb58FqvGbsUcTy+w+7EswN0C6epY/d08BKrDw/Q1weLiDSEqh3i2fzGFyE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yztte1QLMEtE4ZcNR/QVqqxPt3k2n1tgU0RJ+i/eJvtJB+1AQ6Y
	IEDo+LtITHolHK8tzir1H7yNuQop2/vKPkxAmO7HnH1qv/DiCmEE+Eg8zILdNezL4iU=
X-Gm-Gg: ASbGncsyiDMHtWJbal8ihZx/feKkILOJgLCqIC+JqjxNcErDrKsiQ++zyRG22DV8Zln
	Y03CMznWbX522tOLDVyoY9H4cTm/Ssne2Lb/NMulMRyZNEn+tFxoZe2KKJQTRESGgUY9dt170Vd
	nmdhZQljUoQJzjCrTiZ8x79x+8nLvlipsHXTP/zD6uWGlq63M0LOlHnThL5gOVGmYO5Ny2HEGPf
	9SPC3EcC1qoi9P1s3uRQbNGyQGwMjoBe0ZNbwHn3VvDKovKzVcwnjVumJEwH+0PnNy0wjom+Gdw
	IqQYRdSzMqgmwVDCVqQTMaQrHxXN7Dmz+iHW4qJifYzjsFrGn51F2gN6R/GB8PUVyhNPfL8XnFR
	RRIYgKKcNvnEGa51MVw==
X-Google-Smtp-Source: AGHT+IGKNKwRhwXTcmwtGN+5HGqX7L50fvavD2PabeX9y+OqiZC5bMINAl/BO5b4T2iWDRdBG72Lbw==
X-Received: by 2002:a17:907:3f9c:b0:ae0:cccd:3e7d with SMTP id a640c23a62f3a-ae6cf73f3f5mr147273866b.33.1752046674928;
        Wed, 09 Jul 2025 00:37:54 -0700 (PDT)
Received: from [192.168.0.205] (78-154-15-142.ip.btc-net.bg. [78.154.15.142])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae3f6b02f68sm1054983366b.117.2025.07.09.00.37.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jul 2025 00:37:54 -0700 (PDT)
Message-ID: <f382be0d-6f30-443e-b161-d1d172dcd801@blackwall.org>
Date: Wed, 9 Jul 2025 10:37:51 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH bpf-next v3 7/7] netkit: Remove location field in
 netkit_link
To: Tao Chen <chen.dylane@linux.dev>, daniel@iogearbox.net,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, ast@kernel.org, andrii@kernel.org,
 martin.lau@linux.dev, eddyz87@gmail.com, song@kernel.org,
 yonghong.song@linux.dev, john.fastabend@gmail.com, kpsingh@kernel.org,
 sdf@fomichev.me, haoluo@google.com, jolsa@kernel.org,
 mattbobrowski@google.com, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, horms@kernel.org, willemb@google.com,
 jakub@cloudflare.com, pablo@netfilter.org, kadlec@netfilter.org,
 hawk@kernel.org
Cc: bpf@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org
References: <20250709030802.850175-1-chen.dylane@linux.dev>
 <20250709030802.850175-8-chen.dylane@linux.dev>
Content-Language: en-US
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20250709030802.850175-8-chen.dylane@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/9/25 06:08, Tao Chen wrote:
> Use attach_type in bpf_link to replace the location field, and
> remove location field in netkit_link.
> 
> Acked-by: Jiri Olsa <jolsa@kernel.org>
> Signed-off-by: Tao Chen <chen.dylane@linux.dev>
> ---
>  drivers/net/netkit.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/netkit.c b/drivers/net/netkit.c
> index 5928c99eac7..492be60f2e7 100644
> --- a/drivers/net/netkit.c
> +++ b/drivers/net/netkit.c
> @@ -32,7 +32,6 @@ struct netkit {
>  struct netkit_link {
>  	struct bpf_link link;
>  	struct net_device *dev;
> -	u32 location;
>  };
>  
>  static __always_inline int
> @@ -733,8 +732,8 @@ static void netkit_link_fdinfo(const struct bpf_link *link, struct seq_file *seq
>  
>  	seq_printf(seq, "ifindex:\t%u\n", ifindex);
>  	seq_printf(seq, "attach_type:\t%u (%s)\n",
> -		   nkl->location,
> -		   nkl->location == BPF_NETKIT_PRIMARY ? "primary" : "peer");
> +		   link->attach_type,
> +		   link->attach_type == BPF_NETKIT_PRIMARY ? "primary" : "peer");
>  }
>  
>  static int netkit_link_fill_info(const struct bpf_link *link,
> @@ -749,7 +748,7 @@ static int netkit_link_fill_info(const struct bpf_link *link,
>  	rtnl_unlock();
>  
>  	info->netkit.ifindex = ifindex;
> -	info->netkit.attach_type = nkl->location;
> +	info->netkit.attach_type = link->attach_type;
>  	return 0;
>  }
>  
> @@ -776,7 +775,6 @@ static int netkit_link_init(struct netkit_link *nkl,
>  {
>  	bpf_link_init(&nkl->link, BPF_LINK_TYPE_NETKIT,
>  		      &netkit_link_lops, prog, attr->link_create.attach_type);
> -	nkl->location = attr->link_create.attach_type;
>  	nkl->dev = dev;
>  	return bpf_link_prime(&nkl->link, link_primer);
>  }

LGTM for netkit,
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

