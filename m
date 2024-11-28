Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F05197A7A
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Nov 2024 14:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732804448; cv=none; b=ZGiVn1Qw0zZ4E4sda7mu9C3ZIsN571WlHybb9bzldEXW/fE3phN2nUZNItC/ejH6DEKad0wmFs9A6twB/AP1qzedoIEBma4lxEWkEPBGyZLmQzXwD2wWDKLBmfRx9UtnPs9MOXcSPvgpGwuAFy+2iYPizaZvnxiFHTv/GxwmlCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732804448; c=relaxed/simple;
	bh=gdLUI1umdb/rW5MV+Vie2SqmLyB0r5FRY7XWGNb7lEI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YZUJoctfiAjG7PQn9U8NXeO0og80VpZkrFO+RFvztfpWMzBcQj/7Hk6AkPQUmzU8bbHJ5lpBrZFqyPDeEkWiTSNP3wGFvJQIGE0qMUiqMamq4yqMgFyPzEiED04FdmfAH15elyACx5+Vf0E8T5SNI7yE0j08La2J+k0lk36UJyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MPQUjaMe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MPQUjaMe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732804444;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xa1GFFWBjwObkzYkodtut89seCqzVlMLu2RNr+6Yzzo=;
	b=MPQUjaMeN/eotmGTo+WkhbAVxiAX4AVnUwEDTETaGUuI0kklhpRkQYzAwVkQF0qeTmgiJb
	pLWpf6vSZ55Dc31EDITv2hLJPmdT9tMPnlaOllOUJZxSmaVuSkLvp9TLR9KahMmOzyBuQw
	pydSk7VdIgDEniUdKdf84iK9l1g3rlE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-318-TtW0tn_HMfWO4qoukciIQA-1; Thu, 28 Nov 2024 09:34:03 -0500
X-MC-Unique: TtW0tn_HMfWO4qoukciIQA-1
X-Mimecast-MFC-AGG-ID: TtW0tn_HMfWO4qoukciIQA
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4349fd2965fso8285025e9.1
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Nov 2024 06:34:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732804442; x=1733409242;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xa1GFFWBjwObkzYkodtut89seCqzVlMLu2RNr+6Yzzo=;
        b=HNQFJRSNcLQsA+8XX5aGVKS5NYaNwvUrLq+TKhDa2EzF6reeQXG9+D2PTkQgMVPSl6
         xUFwYQDQYwjy+MiIEznp9VMQzNdX+a81xxIxFagXNH+Zm4Veo2AV1LphDAtakLiC4IFw
         ixCUdAkFagFqAhQqymDfUDFS3d9FlBb7dNoIJUjwenlAEAuDIBJVJc9ZzbTpffFWtHBZ
         Xmr3ku+/m51CwN4zPpIiijEi2TpXgTjn5HH67R/djbgBDa6lWCAwmiUtm1z8jKXYwZPg
         NByEWKDgNeNw9cqzQRvDHz2+EOasBCaM9lXOCXkhWiRUYMOW1ar413/Xvpb8X/8Xwcut
         4+yg==
X-Forwarded-Encrypted: i=1; AJvYcCUMUFsGXN2H12e2fNDTTMsxW0qro642bKMuOjBKzAhxdvkNo04QE6KTEKcn+9p1KMZvEWoItTsjE0qegByxvvY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4cOLV1QV5O67u9Bf/bneHivdqPDYB7BPSR4xBgCEnEI2wmJ49
	i/3dfz0ZaTsn/Ino5aEgpGambY6Uxx3I1qPeqFBV48e6Rausg4iurpz0E38Z1K30yxpnu+t4Wy9
	oAGW5YCBruQtPsEqMOMRh4sOrdXALtLNiYu61OIxykkYDOP5gYEC+TdqlCftR593dpQ==
X-Gm-Gg: ASbGncvU6HkMusnp1OjvLW1wcqPPCk+2U20MaFyVOUHyDxbOnXBK0kKpbhVtx1qHl13
	OMRCAZUVVZwQ0Rt1+jjvJ3hXTJLLCHLXxKxRSYDSPvlW57VFtjpZWOYY7pYekkYF1Agzra8C3LC
	eBTW04v1OAsQAUGKcfihxfE7jKYAzaNaFdgCNr65e2pAIgL/JCcg6uFVxbgeFwWzdaQECyVqbZZ
	g/gobRpH+KkLJDors0KaGIuXwwoJZdCBc2d9kNdvNcEX1m/yb9XyjTZyOIZG7HYHfzAlRv/Av5E
X-Received: by 2002:a05:600c:458b:b0:42f:8229:a09e with SMTP id 5b1f17b1804b1-434a9df7b85mr69158585e9.29.1732804442043;
        Thu, 28 Nov 2024 06:34:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEGSJwAZufVlwux6fyvnWoUoLuDNYE+JXwRvg7ZKjaI2N2OLZle9IsMIsJNi3GMwOw5YRJ3UQ==
X-Received: by 2002:a05:600c:458b:b0:42f:8229:a09e with SMTP id 5b1f17b1804b1-434a9df7b85mr69158355e9.29.1732804441715;
        Thu, 28 Nov 2024 06:34:01 -0800 (PST)
Received: from [192.168.88.24] (146-241-38-31.dyn.eolo.it. [146.241.38.31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434b0f70cbfsm24154265e9.36.2024.11.28.06.34.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Nov 2024 06:34:00 -0800 (PST)
Message-ID: <d74075e2-8e82-4c7d-b876-398f4880d097@redhat.com>
Date: Thu, 28 Nov 2024 15:33:59 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net,v2 0/4] Netfilter fixes for net
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
 edumazet@google.com, fw@strlen.de
References: <20241128123840.49034-1-pablo@netfilter.org>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20241128123840.49034-1-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/28/24 13:38, Pablo Neira Ayuso wrote:
> v2: Amended missing Fixes: tag in patch #4.
> 
> -o-
> 
> Hi,
> 
> The following patchset contains Netfilter fixes for net:
> 
> 1) Fix esoteric UB due to uninitialized stack access in ip_vs_protocol_init(),
>    from Jinghao Jia.
> 
> 2) Fix iptables xt_LED slab-out-of-bounds, reported by syzbot,
>    patch from Dmitry Antipov.
> 
> 3) Remove WARN_ON_ONCE reachable from userspace to cap maximum cgroup
>    levels to 255, reported by syzbot.
> 
> 4) Fix nft_inner incorrect use of percpu area to store tunnel parser
>    context with softirqs, reported by syzbot.
> 
> Please, pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-11-28
> 
> Thanks.

Oops... I completed the net PR a little earlier than this message, I was
testing it up 2 now, and I just sent it to Linus. Is there anything
above that can't wait until next week?

Thanks,

Paolo

