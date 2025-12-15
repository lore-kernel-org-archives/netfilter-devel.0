Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF17F26F476
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Dec 2025 13:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765806789; cv=none; b=nwD7GNnHx1fobnqS5wqFvu8iYXqiUNifAeKTuglZRtMw6nUFIsDllPKqIJvUsyULnRTtWgzWlQbx3l90UP4pBzDAhNomsgxhsnYh1qkLOgLqe0iFwKAYm0C82KbiyW1vvvv3gG1Kzmo0w0lVKd7iaMYNECYfMWEsmYp4W2ebTLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765806789; c=relaxed/simple;
	bh=8zFWZMTo6an8vJ27NvevOZe+yH1eUMcNsTqP/opKK1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O7NjXd7eTbltyhaYJGMlyG/G37LA4rBNfg/2gKggVkBksYBeG++p0VfnWRM6lkvdHZ/pRrkgb+6fwVX4TVb4xWlKf87N8p5PrSvpBpDwfsZjWFItvLiiwKnSRkNtNjJs5Rwa0ysuGhi0rqApjJQ4FFR+TJcrE2AHW/K0djkMO9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nXNwPPYh; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nXNwPPYh"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4779adb38d3so26824125e9.2
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Dec 2025 05:53:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765806786; x=1766411586; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0oX4nrpvWkPai7atYZDyI6XfqJxF8RgdX6YGg5FC9Ik=;
        b=nXNwPPYhb6KbJX+H8ZmlKqZlqD+XS1jpECQeGBScxQQyiSaYrLYN9Oj9TZrtDEpI/L
         Y1bW8bG9Gx1Fis9UeOD7l1eoGWaRCGEU/X2RbcPLTD5mBr8iW1637dBEP1vvxvPQho0G
         B7jD5fYPPXaymFIdlSg2JD2bCtV0AJJ8d8DGeU+uaP84kxMQs5/qTI2CjMn8yLfRFdXR
         xnhvKE1d7CaskcDr+R5xXK3vgbY871QE8P/VztJluXQu1SV0FU1kNzC/j+StMf5Zxt1V
         vfoyfdznbTvr0TLVcOVFEbqUucQWTl4kAoBZQYnW9WqRHqxr2yRQe7/7KHghzlnT4S4o
         /FeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765806786; x=1766411586;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0oX4nrpvWkPai7atYZDyI6XfqJxF8RgdX6YGg5FC9Ik=;
        b=a48gCqX0RDZT5BvuiCuylbGdfZ8i284z+7uF9kgYUnxV2SvCES2Ysa+yVtOYmBk7+I
         3rp1dwHa0ci36SgzfE/i6dRVs2LnCkGvchO6I3+sf7TpS9g4pRU6Q1rPtklbGOht4xKr
         jtInT9mANcVjqqbufZ9W+YtLTAEyam0IdPZd4zHvcEyp+IgZ7lJs6LNraXay0m6f+kIc
         pRIihUVm0m60JC+wqTnXqd0+kn+wwhIciJe1Bl/W9GJfCPYMUz2nyOENywUZBB91G8Jy
         8vnsmu30SjuVzsXwD2VDPo6mUzINO3KsD6KXJW1geP3Kj26lmTO1pkqOFaxPT/qT5BJC
         2+jw==
X-Forwarded-Encrypted: i=1; AJvYcCXos+NVjSCaT6Nyka8tSJizpHfZTzKNc+Vqgo42zIl3/SCqvNg9n54/TjuW2yeLEgps8ELPTdD2FOjC4UJxhL4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwiB04uOJiM7HkVuU2ZlHxJkcaoESAZpPkrg2tn2MZ/7BhMfdfP
	zbUubJbDgnhbngYuTw4B0BalF5ZmqUclcHNov3MTFAxD6bTFLK8DrXT3
X-Gm-Gg: AY/fxX4HbBiW+C0hx7JyeKwjCt+z6HhDuwrax70/60/5S4sWJbsx83eD6BkwGLuTXPr
	iaf/XF5ZAPf9xnqMVcn17kx2EROQlZjTCc6CDiVm8DOUBt9McmRGwPt7Br2kJa5Tklb8QupYS4C
	ivLSWwOgtwsWI0eiXpch9gJ8iL+jrkHykRElT2yE3IcDNYeqZc8Xfm5iBfGRujeICee6YmBlOV+
	IyqXws4LOPqakJv5JQvBzjqgmf9Y+u3ffrbFscKSUhZXt5RJMY8+QFCVTFlZIiXtZqchVbS4hlN
	EWPoJ2UlXgteLUaAvt01008IVvMd6JpIFsgnYyUx9bSH9nMxh3SjyiP/XuiGpGp45A3E3GaIKAy
	QxNvZXxVQ6jao+mYQpoLUGlNlgddYgH+VqCkr/n+41/fOEGx0PXw1kc4t6O54nXMPAUbiUXHk33
	A0QFEm8mw62yc1IMnYFPcvmQAzHr9Pl8NN+iqpgDKULxW5WEIh4/Ms
X-Google-Smtp-Source: AGHT+IGhHsIa/I96pYEni0zAnzO9+wzE6tXY69h25/pF+Ws1y0k0/TacBAYssZKxcUf8ahWpq5bA6w==
X-Received: by 2002:a05:600c:8286:b0:477:7ab8:aba with SMTP id 5b1f17b1804b1-47a8f8ab861mr110451985e9.1.1765806786085;
        Mon, 15 Dec 2025 05:53:06 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a8f3352a0sm69034975e9.0.2025.12.15.05.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 05:53:05 -0800 (PST)
Date: Mon, 15 Dec 2025 13:53:01 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Florian Westphal <fw@strlen.de>
Cc: Anders Grahn <anders.grahn@gmail.com>, Pablo Neira Ayuso
 <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, Phil Sutter
 <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Sebastian Andrzej
 Siewior <bigeasy@linutronix.de>, Anders Grahn <anders.grahn@westermo.com>,
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_counter: Fix reset of counters on 32bit
 archs
Message-ID: <20251215135301.75986b89@pumpkin>
In-Reply-To: <aUAAuyGGhDjyfNoM@strlen.de>
References: <20251215121258.843823-1-anders.grahn@westermo.com>
	<aUAAuyGGhDjyfNoM@strlen.de>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 15 Dec 2025 13:36:11 +0100
Florian Westphal <fw@strlen.de> wrote:

> Anders Grahn <anders.grahn@gmail.com> wrote:
> > nft_counter_reset() calls u64_stats_add() with a negative value to reset
> > the counter. This will work on 64bit archs, hence the negative value
> > added will wrap as a 64bit value which then can wrap the stat counter as
> > well.
> > 
> > On 32bit archs, the added negative value will wrap as a 32bit value and
> > _not_ wrapping the stat counter properly. In most cases, this would just
> > lead to a very large 32bit value being added to the stat counter.
> > 
> > Fix by introducing u64_stats_sub().
> > 
> > Fixes: 4a1d3acd6ea8 ("netfilter: nft_counter: Use u64_stats_t for statistic")
> > Signed-off-by: Anders Grahn <anders.grahn@westermo.com>
> > ---
> >  include/linux/u64_stats_sync.h | 10 ++++++++++
> >  net/netfilter/nft_counter.c    |  4 ++--
> >  2 files changed, 12 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/u64_stats_sync.h b/include/linux/u64_stats_sync.h
> > index 457879938fc1..9942d29b17e5 100644
> > --- a/include/linux/u64_stats_sync.h
> > +++ b/include/linux/u64_stats_sync.h
> > @@ -89,6 +89,11 @@ static inline void u64_stats_add(u64_stats_t *p, unsigned long val)
> >  	local64_add(val, &p->v);
> >  }
> >  
> > +static inline void u64_stats_sub(u64_stats_t *p, unsigned long val)
> > +{
> > +	local64_sub(val, &p->v);
> > +}  
> 
> That still truncates val on 32bit.  Maybe use "s64 val"?
> 

It probably depends on the type of total->bytes and total->packets.
The 'bytes' value will wrap 32bits quickly, so may need to be 64bit anyway.
And if (elsewhere) there are this_cpu->bytes += val; total->bytes += val;
pairs you can't 'undo' the adds once total->bytes has wrapped.
So should any of these types be 'long' at all?

I sometimes think that 'long' should be pretty much never used in the
kernel because of the 32bit/64bit portability issues.
But that should have been sorted over 20 years ago.
Maybe M$ had it right keeping long as 32bits :-)

	David


