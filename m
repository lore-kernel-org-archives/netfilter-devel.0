Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9171730ACE6
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Dec 2025 14:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765807286; cv=none; b=FFTn970eE/x/oMxeYTlPAGLQqY+j/4T5TyqYpXRufYFqXeIKcme7K8n3vJpMmyrGtLKhU8WrTnTX7h9T4NKfgiXoqPUJBvFNu97R3gvddIO+WwnXyXAvbVUnAQFhm8wbKSDlO9pmXik9EPCaB0ivkpRIyk/u5cxm/zARaPONMr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765807286; c=relaxed/simple;
	bh=kmuP8MMWK4aEuy7vFru3hFE7uw7OZnYNOMyaSAG5PS4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aHRzmh8neyqIaxrdboOHEsoaGUJ4teOoxvVv9sGqxHL9uBjV+FBB5xZNw5HPLN6vjF+PW7pgXqxVS0QaWrAPaRX9JZo9JSOgX1Tii2aT1YOBunDi0wpcGJxf+KxbNAyFUzcpBYqkuy/UO9lTTK3JWzDaJOllK6KGzFu6m1+umPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mzCdn3Ss; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mzCdn3Ss"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4ed82e82f0fso33092841cf.1
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Dec 2025 06:01:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765807283; x=1766412083; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SPO0uPcx426hWHahgG9ImqhyoeQJpO3h5lar/hdBpJI=;
        b=mzCdn3SsyZVsUaWVtQF/UtHfJxbM+S0BhiCq0eNpM8ZGQMh6EY91raNZOjqWXEWpQ5
         HftbXwnT5+w33M0+EhA2tO6nIVmJq0vElB2pczffNZawRE9bsd6jrgGhKB5xHbGjsxq/
         IYYA0jLW3HDI6o+qSsPaJbZ6xXjhrvugRm3diXAmlmDksADCOUGfT/bDkvdtxM7Bf5fW
         jcrEzT9je0duco4guiMu9i9/UzMhknNQ6e8V2ddGJ3xVmccr1Iqk8/fc2G5RCyFFw591
         a80dfxwI0WYt+SbYF8g/qIwrlcVglWbhEh3CKs6cGzk3OdB5rNDvOrl5rP02nkA5tnnZ
         bAlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765807283; x=1766412083;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SPO0uPcx426hWHahgG9ImqhyoeQJpO3h5lar/hdBpJI=;
        b=Nez0ALNKq/p6ah4JiaU82fqVlX29iu+OmmeyQmSQgoxEGJLYuaRBCXPuz9x6SzeA7X
         Itebs6vAEqJJrV2iYWd67NXgUpOviG3PuhzJDSYXQDIFi1Akqm7Mojsd2tZk8/C3QrAt
         mA7iudA3StEKOUV8l0yaADr71YCjo2dBxmOc9ZwR/eKqQ6Xkfms4yyH7hocfLNQh4YgM
         HrnXuWngtNC1QEgObvWTJH1V1e8QrK/u9vPe/72mk02eLppWyIeAz27TN4wCWwCalgS5
         kIcqVkppEkXmku58AV/e/LYZsw6lgb2mANcp1Q+bPYH3GGKeSPkbApROK06SbpwkW6BK
         QNVw==
X-Forwarded-Encrypted: i=1; AJvYcCXI40A92bdnHgZ+N99Xzt27LUslmOtXbaeIg5Lv+vhtakMBg1A1oCS/Tl8bLR5raf7VUEWkQCYO+hakRKiW2fM=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywi2fA8NklKAZAMRs8+ivn2ON5NjhQ7w7LZcBrSa2KLyFJDux7h
	6i+soeApWBTNMIAJHUfNiotMM2td/1aY6oPpCLUpizj79g3mf5Y0NKIZpe+DJ/ZRxOfuT3hW4Fh
	2hlpb+hzrD6gADqmSJDsWj7jzeUplFeQ=
X-Gm-Gg: AY/fxX5WdNhHvbXaPVg51ruTjengevIGYEJ/zh67nT1Pv73QrmItPngn19w+Aful0Ar
	eDlxgl2U2A2sP93JQ2kJmFHeVtM4W0EWURBCboVRC6OLaCLdMUSILkAw0giD6gwKiS18C6RfQDs
	pVxq2ASpfznNrT1e2fWCWhHn1hcwJ8GRQxDtOyrYSGkrlwJgAGOLmisyMpZHlsUT63r/FCjt1qN
	uWAEYBf+2D7PJ2ccJB+BDKwYdoLpKFpYCFXxhRb05QzLWx0MX/8P0P45ZEhkg1mplkZ7w==
X-Google-Smtp-Source: AGHT+IGWvgG+PrqyPjgSyyDJipFK80SMlXFidZdqVH9PAbqjJjeB8AUiqA8gNsXzB3i6TjakiGDcsIb5tyseRVogTBU=
X-Received: by 2002:a05:622a:2610:b0:4e8:af8a:f951 with SMTP id
 d75a77b69052e-4f1d0673565mr154282801cf.83.1765807283233; Mon, 15 Dec 2025
 06:01:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251215121258.843823-1-anders.grahn@westermo.com> <aUAAuyGGhDjyfNoM@strlen.de>
In-Reply-To: <aUAAuyGGhDjyfNoM@strlen.de>
From: Anders Grahn <anders.grahn@gmail.com>
Date: Mon, 15 Dec 2025 15:01:10 +0100
X-Gm-Features: AQt7F2pRgRiYkigqJCTjnWvcQG7aWllGf2Zl0MizbkiJv08wGMdAQXlJccLZAXE
Message-ID: <CAE-Z64Fpq8ZG9CSiKS7QS0Oa_qHQyWhTeOJy3wTEy2BJorFNcQ@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nft_counter: Fix reset of counters on 32bit archs
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, Phil Sutter <phil@nwl.cc>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Anders Grahn <anders.grahn@westermo.com>, 
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> That still truncates val on 32bit.  Maybe use "s64 val"?

Agree. Thanks for the feedback.

On 32bit archs, you're definitely right. It would truncate the counter value on
32bit. However, the problem I intended to fix was the fact that, previously, a
negative value was passed to u64_stats_add() which always wrapped.

Initially, I was a bit reluctant to use s64 for u64_stats_sub() as I wanted to
keep the signature the same as the existing u64_stats_add(). As u64_stats_add()
is used in a lot of places, I was not sure about the effect of this.

However, I can prepare a v2 with just u64_stats_sub(u64_stats_t *, s64).
