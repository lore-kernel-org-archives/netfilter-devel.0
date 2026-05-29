Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD24C3DF01F
	for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2026 16:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780072435; cv=none; b=LaU2uXiqa7D6MIaaSfTWpZz1SQfBPazcennokWVENFS59jj6axFY4twQl50WJ1uIjP2Ktw1IsWJ422BdfH6CgVUFQRTmhiBYcuWvyDWYNC0yVQND34q4t3ybo6WxjdFUKkUmPY9nbw82ZDWUmUV6Phn6mRCln3pzgHqPeZ5Mfn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780072435; c=relaxed/simple;
	bh=dbF4FQw1JJO9uTpptWLy5jXFCrJD9FS9TarvQIt2lsw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tFip4S6iGCZ09sqVynqnnEFcj8p5cYQ4RRTtYfW20r8WNNO6GKzXjl1iZ6tMIe/Pf1o1t1ECoSknA60fUSrp7NA415jZ949g9XMO5guemz049BAX4QckJ7DowzdzZmW3ueZdWuauDoG2qfgh+mYtcxOUwem65uvmJg0U6RDlG5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jrife.io; spf=none smtp.mailfrom=jrife.io; dkim=pass (2048-bit key) header.d=jrife-io.20251104.gappssmtp.com header.i=@jrife-io.20251104.gappssmtp.com header.b=SQlPy5yO; arc=none smtp.client-ip=74.125.82.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jrife.io
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=jrife.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jrife-io.20251104.gappssmtp.com header.i=@jrife-io.20251104.gappssmtp.com header.b="SQlPy5yO"
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-304dd3bb7a6so163380eec.0
        for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2026 09:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jrife-io.20251104.gappssmtp.com; s=20251104; t=1780072434; x=1780677234; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aVaKxvWzuHaKgJULQUrnFqbmKMN/ktVEIETNVpTenYE=;
        b=SQlPy5yOF1UjrhPKpzB9oln8wDVgzoKyKz933jG/VDOkzetedzucAcpnFhfWAzkXWs
         D+dCd2tbKpsbiZrw64Vb4UcW0Z2b6PjXm9SKIGGfscCEImcfRzTDkK6Uo6Ia+F/2DEC3
         1RLMK3wZKbm2nP4CNcUxha0pgVcRTwqMY5l7/qb2047y3dsNpgKNebs0DuhNA1CzJM/J
         e9I1JMoRHY40EthS9qk1fZwgaOMKdq3uioF359DF8yEmJpvaf+6KQBdm+cYIKpziEyoF
         i/RY20iYh5v062ldKtHs83MCA43Nv0nMaOEq4k80c5kBVVXZyxYn2zIRmQX6BnH5XsqO
         Gqog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780072434; x=1780677234;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aVaKxvWzuHaKgJULQUrnFqbmKMN/ktVEIETNVpTenYE=;
        b=QNHFQARJTUzLaACC2imRrOnJp5eZZf07gTtAt1dbxpOciRp1WFKyGqbX/EyXWkJxoA
         +2UNCjVD5bBcDKNcEStXlgAIvOQw5hvqK73QI2PXc01lkoUWhoR9j42lMlgzbDq050Zb
         kIBlJCCD5VRF5ZoI6vnCZ7E+r0JsLEvW8qBmDs3+79pZ8KRTqEtgeiYzWaSvdxODNpN1
         0xv3bA3JJ22vvmEjLlHFhj5o/4QLaxUsDCFE+QN9iADfigxvIUv1pMUaUZke6/Vo0VoM
         wBYkl949k0348AcYh19TKUjzKBklq75h/j6Yxl0MYuZikjZlu1knuFEM1z8lAW3O/g9a
         WLAA==
X-Forwarded-Encrypted: i=1; AFNElJ+Zli5Sm5PHvEcu9j0LvtkZhBVuq0UmgOMKTvPrcyxoqCT/1SRG72C1NVmA3f0xd8ilUQdJpZQJI8FN9rLfE4o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8GIwunpcrKsfYAwEfOG8Eah7o5xlJ6yt5ejCMUOZ55TKt6D+G
	O8PgWblDIXognDbFi/GBEhHNDmOC4qcMjFsPr+GmqL/2e9ojP+vrGGdh/9eoX69qGIA=
X-Gm-Gg: Acq92OEXz9f1cuak1iXpHIWf21QIn+Whyz8WOZskntFXGfTH85bIup31RkoMXFzfEYv
	i4Zwjbw6GfDn+Z49dzI1U3HdiAO54leFCoVFNNn1TRgbVFgVNqrv6qMfEW5q3JYL+NSX1mQY4jK
	iwh6idyOXnGympa7z5Q8J2K5NabK//MvMNmLHDy1y+qhoPpO1t06EDsMTWxpGzbD88sb6CtRmul
	a2EdloI/Ra7/jcemuWQ8+QEPEWjOUxi0x3ViGYPGogBCVRdq89v7TzUbXhoZRyQPvpHi9SpoPC2
	5+BDLfxJlvYwxTKzdAFeWl0Wzlx3TrqbNMkBlMp73S6OmMiYOd3iSihWjZbWA/bCxuP6p7JsqQR
	YoB8t9X8iCuT0Aixjnw2OblUn2iWXyydSFjIXj9xAMj4IdLk/hclps2cxFje2tHnyIxYKuhMw3T
	CYerteWLsxP/liy4oyM9JJfnps
X-Received: by 2002:a05:7022:3d8c:b0:134:c6ab:a516 with SMTP id a92af1059eb24-137d42922eamr68702c88.6.1780072433802;
        Fri, 29 May 2026 09:33:53 -0700 (PDT)
Received: from m2 ([83.171.251.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-137b3c7fd47sm1512560c88.14.2026.05.29.09.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 09:33:52 -0700 (PDT)
Date: Fri, 29 May 2026 09:33:48 -0700
From: Jordan Rife <jordan@jrife.io>
To: Mahe Tardy <mahe.tardy@gmail.com>
Cc: bpf@vger.kernel.org, martin.lau@linux.dev, daniel@iogearbox.net, 
	john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org, yonghong.song@linux.dev, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH bpf-next v7 3/7] bpf: add bpf_icmp_send kfunc
Message-ID: <nnxnmye7f7vbmyhtotcujnbrfo3n56giitq7mwmsy4qc65hode@o44aefu6g2qa>
References: <20260526153708.279717-1-mahe.tardy@gmail.com>
 <20260526153708.279717-4-mahe.tardy@gmail.com>
 <d65aepu3gg5mzqy6umxvhwyvwq7gvpezle3f4u6dla7sorndt3@nirsf36ozbii>
 <ahlWPCJCXa6DMSwQ@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahlWPCJCXa6DMSwQ@gmail.com>

On Fri, May 29, 2026 at 11:02:52AM +0200, Mahe Tardy wrote:
> On Thu, May 28, 2026 at 03:55:21PM -0700, Jordan Rife wrote:
> > On Tue, May 26, 2026 at 03:37:04PM +0000, Mahe Tardy wrote:
> > > [...]
> > > +__bpf_kfunc int bpf_icmp_send(struct __sk_buff *skb_ctx, int type, int code)
> > > +{
> > > +	struct sk_buff *skb = (struct sk_buff *)skb_ctx;
> > > +	struct sk_buff *nskb;
> > > +	struct sock *sk;
> > > +
> > > +	sk = skb_to_full_sk(skb);
> > > +	if (sk && sk->sk_kern_sock &&
> > 
> > Won't this prevent the kfunc from working for traffic emitted from
> > kernel sockets like those used by NFS/SMB mounts? I can imagine there
> > being a legitimate use case where you'd want those kind of connections
> > to fail fast as well by emitting ICMP*_DEST_UNREACH.
> 
> I don't know much about NFS/SMB but I'd expect them to use UDP or TCP
> for their transport protocol, so the second half of the condition check:
> 
> > > +	    (sk->sk_protocol == IPPROTO_ICMP || sk->sk_protocol == IPPROTO_ICMPV6))
> > > +		return -EBUSY;
> 
> should fail. Meaning that this should be suitable for it.

Not sure how I missed this. Makes sense, thanks for explaining.

> 
> The goal here was to identify the ICMP kernel sockets, I think this way
> should be precise enough and does not require new code. The other more
> precise ways we thought about initially were more invasive:
> - exposing ipv4_icmp_sk out of net/ipv4/icmp.c to compare the pointer:
>   not clean as other part of the code could reuse those sockets.
> - expose a helper like is_kernel_icmp_socket from net/ipv4/icmp.c to be
>   used in net/core/filter.c: new exported functions.
> 
> > > +
> > > [...]
