Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C98A348C7F
	for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2026 09:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780045377; cv=none; b=Aa8KlCDRCaEVjI/WI790Et36YY0jVCrWYAav9CgeH/39oXGoyF5JqlPB55UdhHNXOyfVh80RIUOO20SqwC3rnte1IJZsU5zqUdmlytMpMNeHtpMRCv8S+/1SljuurIDMizehtejfKGJHT5a+Xn7dpzBpC4dGqBkIvTCA3hv6/F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780045377; c=relaxed/simple;
	bh=yYAsUywyR27qE6vul78x3gmb+ziWG12hAXlyRaI1uXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JYMpx16By/1b9Z8C79nlThilQugOi/HpKKAk+DBlcqnlw73wnsvLwStWE75CdTpA8R01gEsY9onvis+qW7eGDxKaL3xBe3imybyBVpBxxhKRRj+wVihsNBcTFFjBv+1rfuO8ya7sgG3HR/hXnWQk3EPgIIp6Zmm1lh64MiYpq2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kq5vIbAO; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kq5vIbAO"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49048e043e5so58928865e9.1
        for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2026 02:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780045375; x=1780650175; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hgXlCsm5faN5BZz1S/HGhbOsFnx36ZERe35q1tpIjtU=;
        b=Kq5vIbAOUpLhDomSF/Ua9MOsvqV+3RV7U8CQjBkiWgQohi5iSbXbbO90hQTqEZ4UyV
         /knsowfZKl6qmh7zQurhjPTzvNTpU9XtB6rA9ESPsocG3mV+dYXHcLHeAD9ftEdTkQCL
         /0y8vIckS/8z5q5EJOI2fRrltUFU4M0djEl1T36R5iHV+NYYw36GEcE38np4w2pzMo7K
         ZTrBEBwcWgebIqcFTS+TCkpUnVrWKcUap9v4l6/Uebl6lNU1wyIdPNJtpLZAlnQwmcy3
         VrQV2fzxV9nwbqbbh8sPtrZeaqVmDwG8PbDYsZmQDkuD7MHpL03b2g40mHxozm22MO5K
         edPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780045375; x=1780650175;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hgXlCsm5faN5BZz1S/HGhbOsFnx36ZERe35q1tpIjtU=;
        b=Ah5c6mhIrwLzeUIe6QlJBdkTMrxHsUDxvJ1jrxeWVuaVt0qPMVWPGUAw9o5WNFTHJS
         53W3UR61kVswI9q8rKQUeM3CuUteJljrb8XuJxazetIxc4ay8wFWzPvVZ5N0NFlH6sN3
         qixx5UuWmNZhWlG+oMt/6ggSzilbVF7FCQ/k3wG9nvMbFHjwK7Xk1bTZUMYk10w6kKtI
         WrV4RwDQV3k7UAdoybvjFlvAbnk/qVJu9x4O3nJuxFnvP15KkDXEXeFYaxhb/GgGTck3
         dh3z1cyIEgPlH+okFLK4wIUSA8EJzft55yCgthKqVNJfP70Q5RAycvvR32Cg4YB9dOkv
         +ksQ==
X-Forwarded-Encrypted: i=1; AFNElJ+DCcsnS5NVjOVx9VbjkIG+qFPEcgPD5grwheVD8mSKexI0u6+f+A8txQjZa3yMotiFhdEzGebRwEji/0iAL+w=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYRarAyBo60UGC5oe4sinZf80baj2OQaeNkYEB0/8rrk3u17O0
	dmY2YpwuoDQqPIictM9o9vp2glla1tnJOJYZc7HQ7YKhxuXA+GgWrl0+
X-Gm-Gg: Acq92OEa8qIcyZy0pRa3Ps7pRAZpXl8fY1fXMQqDZ5thIAzF3wq3O5/WOWSbgwBH34e
	5OgbGHUV4N47B0VjdHdNRNnnlFtlWLSYduarJNX+jUY1LQtqW9WPypZ0ojzAqkeORmkDBuWQI/5
	PMjb94a3rn4JfsGgl52KfPagf5k9uhQKfGKDycLvgnm8nRUK2lyahTHKlJOI51vQyfbMJiY+N42
	f/j4bwpwrVLHCqEvtAQLbpJsjuRWt+0OGrC4A1od7/AwzP3BB1StseCd00YdMPes7Ui+R0wm9FO
	xV9CWP780FRKK5UEQxVhPgkRdG5dKStTWx1hOeElSp2I8b1obt4Lvn8Pbs4S+BQOYeLP2gmLM7U
	N9PwT5woBxnOkA2u2T/C4UjQJ3wMosoWYmks3Ck7eR9M/vMvcap9RCuaigNXU3lM1MhpESE6977
	zR14qhsVNS7zNejLjSwf/GY+v2VA9qg5ykXaUZSxopNGvipMHtF6dhS5w8p/8FTNw+LA2eC+nTL
	V2O
X-Received: by 2002:a05:600c:4f53:b0:48f:e26a:1744 with SMTP id 5b1f17b1804b1-4909c07e7d7mr35184845e9.9.1780045374624;
        Fri, 29 May 2026 02:02:54 -0700 (PDT)
Received: from gmail.com (deskosmtp.auranext.com. [195.134.167.217])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909d6f35f8sm21915255e9.13.2026.05.29.02.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 02:02:54 -0700 (PDT)
Date: Fri, 29 May 2026 11:02:52 +0200
From: Mahe Tardy <mahe.tardy@gmail.com>
To: Jordan Rife <jordan@jrife.io>
Cc: bpf@vger.kernel.org, martin.lau@linux.dev, daniel@iogearbox.net,
	john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org,
	yonghong.song@linux.dev, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH bpf-next v7 3/7] bpf: add bpf_icmp_send kfunc
Message-ID: <ahlWPCJCXa6DMSwQ@gmail.com>
References: <20260526153708.279717-1-mahe.tardy@gmail.com>
 <20260526153708.279717-4-mahe.tardy@gmail.com>
 <d65aepu3gg5mzqy6umxvhwyvwq7gvpezle3f4u6dla7sorndt3@nirsf36ozbii>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d65aepu3gg5mzqy6umxvhwyvwq7gvpezle3f4u6dla7sorndt3@nirsf36ozbii>

On Thu, May 28, 2026 at 03:55:21PM -0700, Jordan Rife wrote:
> On Tue, May 26, 2026 at 03:37:04PM +0000, Mahe Tardy wrote:
> > [...]
> > +__bpf_kfunc int bpf_icmp_send(struct __sk_buff *skb_ctx, int type, int code)
> > +{
> > +	struct sk_buff *skb = (struct sk_buff *)skb_ctx;
> > +	struct sk_buff *nskb;
> > +	struct sock *sk;
> > +
> > +	sk = skb_to_full_sk(skb);
> > +	if (sk && sk->sk_kern_sock &&
> 
> Won't this prevent the kfunc from working for traffic emitted from
> kernel sockets like those used by NFS/SMB mounts? I can imagine there
> being a legitimate use case where you'd want those kind of connections
> to fail fast as well by emitting ICMP*_DEST_UNREACH.

I don't know much about NFS/SMB but I'd expect them to use UDP or TCP
for their transport protocol, so the second half of the condition check:

> > +	    (sk->sk_protocol == IPPROTO_ICMP || sk->sk_protocol == IPPROTO_ICMPV6))
> > +		return -EBUSY;

should fail. Meaning that this should be suitable for it.

The goal here was to identify the ICMP kernel sockets, I think this way
should be precise enough and does not require new code. The other more
precise ways we thought about initially were more invasive:
- exposing ipv4_icmp_sk out of net/ipv4/icmp.c to compare the pointer:
  not clean as other part of the code could reuse those sockets.
- expose a helper like is_kernel_icmp_socket from net/ipv4/icmp.c to be
  used in net/core/filter.c: new exported functions.

> > +
> > [...]
