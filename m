Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF441D79A4
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Sep 2024 12:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725453197; cv=none; b=PUe1HPtWTTjmDFxAgz+20mglhxpXC4wdcvCM80e3hbpJ455WwXJPeX2F25uz/Zxlj4pojYOefUQiPd0ooNFJO8r9y+3olr5gFMSFkBacWHuJGpv4dEDeD2D5poy5uxhLgvkMO6VrSYYBUXY7/QEmA2tdcLCdnGofJt4kngAnEfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725453197; c=relaxed/simple;
	bh=7UoD9XiCpvi6y1xEyB8+5f+ERh25lzqVSxkvy5h5/dA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QKhPB6K0VJyYZ1wf0DKpOFFr/TK9KLDKKR+LxCKpoG2Y5zEiQgXPrgfmhld/KAXL/lRU28gthLaXllB11tF/acmj7XCAuAMebXMJv8blEoLRNLPzkuuwHGfOIWCMEPtcUkn4gvTPr34qXIIJFyhKk10INGAC1lqXgam/3iNDNVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D8A192px; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D8A192px"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-58ef19aa69dso6096233a12.3
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Sep 2024 05:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725453194; x=1726057994; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5bXLYQrAn55qVHKqCMDfrSJuD7so3yQzO4aIvtH++AM=;
        b=D8A192pxxQ7LzkjSwfZ1WOOlnl4xz1WO5LuMdC9o1inymEoHYM2Bfx+lEyfI6nQP8G
         3m5MiyDGexZUXqrmH5VaovppbcyBIpKtYlT7iKdwn1OPw857GgRSwapGVz8aXckKWMJC
         eHrA6cJCkdi0uL4+1+WxAJWlhSF65guFcCaiuqNwxNedM9Uqb1/iJgi3RHGLbWM4LTN+
         ewZlnXWVtFMpgKi86zF1nrAln6KgcMIAhVflDDHetysVw/mIU56ZQ6ttTB3tYAiTq1E1
         noLFXyiI/5CH2x2h2wrV79uBgnYc2fTEXIGi8rT7QDV8L/D8f+LZ4jKUO3vUbU5qy3CW
         J2Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725453194; x=1726057994;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5bXLYQrAn55qVHKqCMDfrSJuD7so3yQzO4aIvtH++AM=;
        b=ruTIySH0JGBaPeHfZD9iZY9ZaPeKlx+gSK4hR41qG0q/GcuJQWt0eoXpPs0SseA3J1
         greu3G4CB+QxLzzqDtT/E2qBhXKBGcHWnsG94d8zi0kCjOSTvmtgc8czU/JY0mzUkeW7
         Vse6gjFGXrcE8ynq9dTpeOlrW2hO81tsJCgP/oMXQ/x7b0gyyAjeVLRrEz835Jjb4Owr
         SvED+yk9QzHiVDFn6bmvjGjONEVOjmudEbHcH6Y5BazTdQ6FKkRcVA0Nz9clFZWlhz8h
         5BteBqFf+I0KnjvrYJXhXh3BRguAjM5itiwIAZ+Nt2bp/xvRUHNjd0r/LUTOFGQTOg/x
         OTOw==
X-Forwarded-Encrypted: i=1; AJvYcCVFJ2DShbjaqaKRh5yx3dG7bYYl7mzeQO1ef6HAayY+5GgSu/vVl8D72MxGHEp1MG7rQ3sMXFxNDz4bfN08l2g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzduPWw4DmRWk3BfcPlU7kk9BDbKmTBUkHxYr3S/uE4EY9hRNWC
	ZrAfA9RUxw+8XVEvA+rC32iRAoV5MA7AF8yddxeMgB1TNKbiCTlOJuYUIS1K6pH2RTKRW74QA6p
	xGCbxTYE9pjGuRZfTh2o7WcJaY2fCfyJSAINR
X-Google-Smtp-Source: AGHT+IHSWhhfEGVLU8gtaJv8edwr6ndZX9ujHluP3FBkuXM39Jrx2YzM0lBdfRG5k5PfLNmwX1DTQ6QqlRxSWW25Nz8=
X-Received: by 2002:a17:907:9409:b0:a7a:ab1a:2d67 with SMTP id
 a640c23a62f3a-a89b93d963amr1059288466b.1.1725453193678; Wed, 04 Sep 2024
 05:33:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <tencent_DE4D2D0FE82F3CA9294AEEB3A949A44F6008@qq.com>
In-Reply-To: <tencent_DE4D2D0FE82F3CA9294AEEB3A949A44F6008@qq.com>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 4 Sep 2024 14:32:59 +0200
Message-ID: <CANn89iLQuBYht_jMx7WwtbDP-PTnhBvNu2FWW1uGnKkcqnvT+w@mail.gmail.com>
Subject: Re: [PATCH] netfilter: tproxy: Add RCU protection in nf_tproxy_laddr4
To: Jiawei Ye <jiawei.ye@foxmail.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, davem@davemloft.net, 
	dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com, fw@strlen.de, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 2:25=E2=80=AFPM Jiawei Ye <jiawei.ye@foxmail.com> wr=
ote:
>
> In the `nf_tproxy_laddr4` function, both the `__in_dev_get_rcu()` call
> and the `in_dev_for_each_ifa_rcu()` macro are used to access
> RCU-protected data structures. Previously, these accesses were not
> enclosed within an RCU read-side critical section, which violates RCU
> usage rules and can lead to race conditions, data inconsistencies, and
> memory corruption issues.
>
> This possible bug was identified using a static analysis tool developed
> by myself, specifically designed to detect RCU-related issues.
>
> To address this, `rcu_read_lock()` and `rcu_read_unlock()` are added
> around the RCU-protected operations in the `nf_tproxy_laddr4` function by
> acquiring the RCU read lock before calling `__in_dev_get_rcu()` and
> iterating with `in_dev_for_each_ifa_rcu()`. This change prevents
> potential RCU issues and adheres to proper RCU usage patterns.

Please share with us the complete  stack trace where you think rcu is not h=
eld,
because your static tool is unknown to us.

nf_tproxy_get_sock_v4() would have a similar issue.
