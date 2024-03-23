Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46ABC7F;
	Sat, 23 Mar 2024 00:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711153595; cv=none; b=g7H08pHfDfo4mH9rOgPPKu6rIylvo1RP+Fiyr0hehnFbh1aDYgNQMghNE4Bx4Rw54kRFSyXu+T0HeGbBUT7zmgmsSk5WCFzWvET7L9xzAQ7mHUJT+kDvMmpjTnVtBnUnsS8M6inNjo2PrxKBN4wKmUhHDbDzh1QuHH3YuBUQhBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711153595; c=relaxed/simple;
	bh=wU0zA8OoaYRHOvx/DIRzkdHTS/4bRP2mB1DWJA8wSWQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=twJNxAhz02AJYN7QEI+hvb1pn+6grgNxHU/vJKuHZov/Lxm/wfFGyDN//jPO0U5H4GpYY4WI59lkDPUSSCzaFQyUU6GG20nwbsrOJyVryySRmwgs/EuocpJYuP2+cjT9OozG3CFBVR+UJwK6s4KJFeSzNTfciwPBqqwznlRECfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SOXdcWjN; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SOXdcWjN"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a47385a4379so141258466b.0;
        Fri, 22 Mar 2024 17:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711153592; x=1711758392; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wU0zA8OoaYRHOvx/DIRzkdHTS/4bRP2mB1DWJA8wSWQ=;
        b=SOXdcWjNHm3pPTttpCga7l/2ltph3Bh6bK4oMk6Gtj6AS5SxlEpNIzoUmMciuQl8a5
         rC/kfBO1g+X75hnxVzsuhISVuydxg96YcvXiQP1b1+eLA6B0IyKoUoeVYt4++65Lk3g/
         ZUHanzBA18jcSCIFeZFvGH7J0ZHx07Uw6pGgqDZQXQd8kYcY6g75/GnnHTVC4D6wxcfb
         SxfOicONOdi9EI9u4tMM95s9hvbgvNd3h9txwzZzmC9r/8A13dHNkaCTZuPPDWtU7hKu
         EjrDGPMigNuREUP1bISxRp97HxvMEN9GGHQMhHRjzKdDIiU2lK104LLMQsayvoMeDm0L
         OmjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711153592; x=1711758392;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wU0zA8OoaYRHOvx/DIRzkdHTS/4bRP2mB1DWJA8wSWQ=;
        b=DQJkaVJEJ9V9sUcUiJ922M1ky4iNvazttjigP4Ta5N26cf9KAm4TG1vNtUZMb5/5ig
         pxU5hR2xd8v68MB1w5ENAEfVl08WMVNjQHWv0e8WRnkrXlLToAWFkan71PknMvgXfkE8
         AzJSvHgdjzAfDioyBNyS3v4zBSPRi2hKJHm0s97NASWJUyjkhdK9A3QohExSraDy77jt
         MQEV2Xe19LhZTyo8InDsEo5gZc/QKXVDiGKlNwuvx732QOJkaRPSbxmeKeX/FGB64ZEv
         jn66MHWsQVabEI5Vy7S2MO+xk4v4P4AJvizTkXWSpf7olAGYj9rZcuktVhPJMcgNzYhq
         kGQg==
X-Forwarded-Encrypted: i=1; AJvYcCUA9V/+7kXyRT3pQy6fPfK78/vmPjcmptRZ12hy0/hLSKhlLcgq2LEKgylk6UOpegZYTWmXX0TyyX0CvfGpO1bzsbxsmxOyHsvVUxW2ujPEAr3s4w0n9Wmk/+tAh+WKIOvoVbAkvtxq
X-Gm-Message-State: AOJu0YxeuQjsVZYr+VnpTPuYNT6sZJJIsYq5vlg/sViNa4nu/4NSNWQF
	qb33ppUt+LYTbXGBusVY+AipUojYTI4fV8YwJGm4M/zxuzcxir1gMEg/BY60j8KIIIKgtguvcHV
	f1csLr6AwncQwSO+nxpmWhrZpNWk=
X-Google-Smtp-Source: AGHT+IF3117YE3+ORlIw6dGfkG+zU6ybLu9Nvj3CXFO+gPHb+xi2TPfpqW0dJyzWVVVyRJejwAkFtbb4uBnZwDIQjsI=
X-Received: by 2002:a17:906:8cc:b0:a47:3f10:b3c8 with SMTP id
 o12-20020a17090608cc00b00a473f10b3c8mr419328eje.26.1711153592378; Fri, 22 Mar
 2024 17:26:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240311070550.7438-1-kerneljasonxing@gmail.com>
 <ZfyhR_24HmShs78t@calendula> <2aa340d2-c098-9ed8-4e65-896e1d63c2da@blackhole.kfki.hu>
 <CAL+tcoDY55yXbo3=OtHpeVOfN8aJmDjwzpd8mRkOH2rMj6QUbA@mail.gmail.com> <b1b95a71-a4e8-288c-7731-811ad548d641@blackhole.kfki.hu>
In-Reply-To: <b1b95a71-a4e8-288c-7731-811ad548d641@blackhole.kfki.hu>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Sat, 23 Mar 2024 08:25:55 +0800
Message-ID: <CAL+tcoCe6YFOWOYvdu1UH+kHRYPEmfphOJzB0BcVR-HER0GZ8g@mail.gmail.com>
Subject: Re: [PATCH nf-next v2] netfilter: conntrack: avoid sending RST to
 reply out-of-window skb
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, edumazet@google.com, 
	Florian Westphal <fw@strlen.de>, kuba@kernel.org, pabeni@redhat.com, 
	David Miller <davem@davemloft.net>, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, netdev@vger.kernel.org, 
	Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"

> I understand and appreciate your efforts. But please consider the case
> when one have to diagnose a failing connection and conntrack drops
> packets. What should be suspected? Firewall rules? One can enable TRACE
> and check which rules are hit - but because conntrack drops packet,
> nothing is shown there. Enable and check conntrack events? Because the
> packets are INVALID, checking the events does not help either. Only when
> one runs tcpdump and compares it with the TRACE/NFLOG/LOG entries can one
> spot that some packets "disappeared".
>
> Compare the whole thing with the case when packets are not dropped
> silently but can be logged via checking the INVALID flag. One can directly
> tell that conntrack could not handle the packets and can see all packet
> parameters.

Thanks for explaining such importance about why not drop silently. Now
I can see :)

In my first version, I didn't drop it directly but let it go without
clearing skb->_nfct fields and then let the TCP layer handle it. As
you said, the out-of-window case is just one of some INVALID cases
which could also cause RST behaviour, so it seems that the first
version doesn't handle it well either. It has to take all INVALID
cases into account...

Is there anything left I can do like particular tracepoints something
like this? No idea. I only hope somebody who encounters such an issue
can notice this behaviour effortlessly :)

Thanks,
Jason

>
> Best regards,
> Jozsef
