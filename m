Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F3A70836
	for <netfilter-devel@vger.kernel.org>; Sat, 27 Jun 2026 21:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782595008; cv=none; b=cF/E42grQ7KLrLepw/KSLQ7XcL0tNNa9uxu6YNCs+JYx5GH1ni1deIco75H+efIzJA9xhZJAHEC9KDphrfSyZtY4N+4wGU1ba/Hy3njbEOLtfaQiTibi9vKr4HFtstjPy1GeJHzqj0ImhJ/zefoX7AEyY+uHLEzsIO6pGSV0X+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782595008; c=relaxed/simple;
	bh=3rGpUDw+ddrLG9sPceYY9ObkHQDjG5NTyD2hYg6jTzI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l1e67u9dAuOSyYuip8FuWgbotvnfNjSOS0AhTSmNjzEVD3tdPZpLJvCub/uRyt/1R/sUXRP1cLai5ii3Sz+hpy66Dsu14MuhCXSGPWA/x+RVdJ04K7Aqcl7uVb1QXpbszhk7UQgKK5C6tSSEChDeKEdL5FjJqxe2M5Q8g5CtZ/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OhMpEmYO; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OhMpEmYO"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-493a5392c60so1718205e9.2
        for <netfilter-devel@vger.kernel.org>; Sat, 27 Jun 2026 14:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782595006; x=1783199806; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s95FZx2QU/TjB5YrTYRCYxYo5MNS6NGrQ65w/N+79gc=;
        b=OhMpEmYO+A/1GPGrZ+Qmas4EUBsssEKbaynAB+sN/nVUzlVlzAhH3wMPUZOgPgrw74
         +FwC5zG6rTOaKpovy0oLxDaAlDm9/taG5HPoeRBjHXjSNmCGkbTv6UVB4AD3EGQ3kdzD
         vtJBCcYnLqb7kt94opUwU8UAusyX9jyKUg9JeMGSDe3S77JmV+fZDOoYbAYddZ68rbsg
         uWvkekzl/yC/pIIWzPPpiWhscudAIITxDR7ho6Jm6GjkN10M2cWyOi+RzrC6klrW2JYm
         OgA1fR8Goifx1dvvFKiicgcEqpNamfbPz6eB5jNHUYvi1WtRxiQYIqBDZ/nDxo3aM70P
         7DCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782595006; x=1783199806;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s95FZx2QU/TjB5YrTYRCYxYo5MNS6NGrQ65w/N+79gc=;
        b=pOHuehgRjdc4V6iAUxQxrNInp8aSN/zFxj51NFT7J59M+q2JbcFgvpgwaOSZGTaQ5u
         tseYNKet2XhkkC8JsPWd3d2077ktezIe6ZY5qW4vHGJ3NxHrUnNTccf2f57xcgt5kbiE
         6zdAvwFGBB2RuBZyIvD405xTUOFK0TbBeEWNb/vcEE9tS/h2lkGVtgKEuRQ0j+tBLlEs
         fbF8aa0rDn5WJAXaorapLHo08C3ZDAXNquNHq3rnTfGZqlr1a0GBlCr/GE2bX3MxvR7Q
         7n3javH7zFv4/P3fi/5BGV2VC+tIZsKpLGbAWrUtwgf9qMYmoqBdG9VLXInVaVaUDSmg
         vDIg==
X-Forwarded-Encrypted: i=1; AFNElJ8ghXn34IRNowvByFBqjuxaHtdfVeZiOk8SM/6pgArf4I3RxvycMdZA9NQDhh4iFRxqCaIsqnFH4fbhz7tZ61o=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuM1pMTvIE4GTpubSHnk2nqw9fkM0TieLmPUivzVAtFVtBIupm
	PqNypr1+8bC6kGVxFBkJtY47kIzBf/bZyGTcPH+A5pGXwwLWD7RRg+cU
X-Gm-Gg: AfdE7ckCHtvCGZgxfoGrZ4kGCpsNQ+6C3wD1wrKVM/fcGcga0J47tEZ8AOzbV9zBIm9
	Qj7Yt5Dv5fpm6xYp5j1fkgSY73ljcKsqY9TfoTCRddxzWvBHbQOlP5qRIO3QX73rEk/zliS7hfr
	N3hh5wZvtGRg8ZAD9MpdSBstsfGlfVJEUdxRVJlDzMMZYiKaQ3zLAOfDIaPB5lmR40ygIEagSNU
	QFCGtbtsPBfh96ws8jiQU4xek0a6GhLDKf6Ohb61NjJIfrgaxSezld1zlstWMsSIy9+NwfA+zQo
	6BM/rQevpnbpeIERXuQaFnGuU/yY4r0uYi02ITKm5sNJbdHlvhzm+qbFcvcMd0mNKR4o4B1q0If
	ontQZDbihtHdMJbkNrnUAS/uaJA98F470Rxw2X7mtm75dI6oHDOUdbEjDIqElthzz1pWjyUD4Y2
	+Kkww337Lrvzt8ELARP1FdukjVsqRkMojo83bYFHrLYK5M4A==
X-Received: by 2002:a05:600c:6215:b0:492:463c:48b7 with SMTP id 5b1f17b1804b1-492668985c2mr157854005e9.22.1782595005526;
        Sat, 27 Jun 2026 14:16:45 -0700 (PDT)
Received: from pumpkin (host-92-21-50-228.as13285.net. [92.21.50.228])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49269071d05sm193434745e9.11.2026.06.27.14.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2026 14:16:45 -0700 (PDT)
Date: Sat, 27 Jun 2026 22:16:43 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Ian Bridges <icb@fastmail.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal
 <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
 <horms@kernel.org>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] netfilter: x_tables: replace strlcat() with snprintf()
Message-ID: <20260627221643.1e837496@pumpkin>
In-Reply-To: <aj78X4Cjqcpbb8Co@dev>
References: <aj78X4Cjqcpbb8Co@dev>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 26 Jun 2026 17:25:35 -0500
Ian Bridges <icb@fastmail.org> wrote:

> In preparation for removing the deprecated strlcat() API[1], replace the
> strscpy()/strlcat() pairs in xt_proto_init() and xt_proto_fini() with
> snprintf(), which builds each /proc file name in a single call.
> 
> Each name is "<prefix><suffix>", where <prefix> is the address-family
> string xt_prefix[af] and <suffix> is one of the FORMAT_TABLES,
> FORMAT_MATCHES or FORMAT_TARGETS literals. snprintf() with a "%s%s"
> format produces the same NUL-terminated, length-bounded string as the
> strscpy()/strlcat() chain it replaces, so the proc entry names are
> unchanged.
> 
> Link: https://github.com/KSPP/linux/issues/370 [1]
> Signed-off-by: Ian Bridges <icb@fastmail.org>
> ---
>  net/netfilter/x_tables.c | 24 ++++++++----------------
>  1 file changed, 8 insertions(+), 16 deletions(-)
> 
> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> index 4e6708c23922..56f4546be336 100644
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -2033,8 +2033,7 @@ int xt_proto_init(struct net *net, u_int8_t af)
>  	root_uid = make_kuid(net->user_ns, 0);
>  	root_gid = make_kgid(net->user_ns, 0);
>  
> -	strscpy(buf, xt_prefix[af], sizeof(buf));
> -	strlcat(buf, FORMAT_TABLES, sizeof(buf));
> +	snprintf(buf, sizeof(buf), "%s%s", xt_prefix[af], FORMAT_TABLES);

If you are going to use snprintf either paste the strings together:
	snprintf(buf, sizeof(buf), "%s" FORMAT_TABLES, xt_prefix[af]);
or prepend the "%s" onto the #define of FORMAT_TABLES itself:
	snprintf(buf, sizeof(buf), FORMAT_TABLES, xt_prefix[af]);

FORMAT_TABLES should also be FORMAT_NAMES.

-- David

>  	proc = proc_create_net_data(buf, 0440, net->proc_net, &xt_table_seq_ops,
>  			sizeof(struct seq_net_private),
>  			(void *)(unsigned long)af);
> @@ -2043,8 +2042,7 @@ int xt_proto_init(struct net *net, u_int8_t af)
>  	if (uid_valid(root_uid) && gid_valid(root_gid))
>  		proc_set_user(proc, root_uid, root_gid);
>  
> -	strscpy(buf, xt_prefix[af], sizeof(buf));
> -	strlcat(buf, FORMAT_MATCHES, sizeof(buf));
> +	snprintf(buf, sizeof(buf), "%s%s", xt_prefix[af], FORMAT_MATCHES);
>  	proc = proc_create_seq_private(buf, 0440, net->proc_net,
>  			&xt_match_seq_ops, sizeof(struct nf_mttg_trav),
>  			(void *)(unsigned long)af);
> @@ -2053,8 +2051,7 @@ int xt_proto_init(struct net *net, u_int8_t af)
>  	if (uid_valid(root_uid) && gid_valid(root_gid))
>  		proc_set_user(proc, root_uid, root_gid);
>  
> -	strscpy(buf, xt_prefix[af], sizeof(buf));
> -	strlcat(buf, FORMAT_TARGETS, sizeof(buf));
> +	snprintf(buf, sizeof(buf), "%s%s", xt_prefix[af], FORMAT_TARGETS);
>  	proc = proc_create_seq_private(buf, 0440, net->proc_net,
>  			 &xt_target_seq_ops, sizeof(struct nf_mttg_trav),
>  			 (void *)(unsigned long)af);
> @@ -2068,13 +2065,11 @@ int xt_proto_init(struct net *net, u_int8_t af)
>  
>  #ifdef CONFIG_PROC_FS
>  out_remove_matches:
> -	strscpy(buf, xt_prefix[af], sizeof(buf));
> -	strlcat(buf, FORMAT_MATCHES, sizeof(buf));
> +	snprintf(buf, sizeof(buf), "%s%s", xt_prefix[af], FORMAT_MATCHES);
>  	remove_proc_entry(buf, net->proc_net);
>  
>  out_remove_tables:
> -	strscpy(buf, xt_prefix[af], sizeof(buf));
> -	strlcat(buf, FORMAT_TABLES, sizeof(buf));
> +	snprintf(buf, sizeof(buf), "%s%s", xt_prefix[af], FORMAT_TABLES);
>  	remove_proc_entry(buf, net->proc_net);
>  out:
>  	return -1;
> @@ -2087,16 +2082,13 @@ void xt_proto_fini(struct net *net, u_int8_t af)
>  #ifdef CONFIG_PROC_FS
>  	char buf[XT_FUNCTION_MAXNAMELEN];
>  
> -	strscpy(buf, xt_prefix[af], sizeof(buf));
> -	strlcat(buf, FORMAT_TABLES, sizeof(buf));
> +	snprintf(buf, sizeof(buf), "%s%s", xt_prefix[af], FORMAT_TABLES);
>  	remove_proc_entry(buf, net->proc_net);
>  
> -	strscpy(buf, xt_prefix[af], sizeof(buf));
> -	strlcat(buf, FORMAT_TARGETS, sizeof(buf));
> +	snprintf(buf, sizeof(buf), "%s%s", xt_prefix[af], FORMAT_TARGETS);
>  	remove_proc_entry(buf, net->proc_net);
>  
> -	strscpy(buf, xt_prefix[af], sizeof(buf));
> -	strlcat(buf, FORMAT_MATCHES, sizeof(buf));
> +	snprintf(buf, sizeof(buf), "%s%s", xt_prefix[af], FORMAT_MATCHES);
>  	remove_proc_entry(buf, net->proc_net);
>  #endif /*CONFIG_PROC_FS*/
>  }

