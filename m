Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B0453392;
	Mon,  3 Jun 2024 09:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717406526; cv=none; b=rwH9r+gxznQxyn2W3lnRqCiYJTFKu9AGXOfkhyXNBnEDERz5IUCX+43v32eTYZQim4BEX63wi0jXhKMEnEFpEL+mTHa8NziYei3xFUqQS8RPAbSHBmPmT5ITTo7tarw9++eTA7Q7nPAlIdRO11B5WNZNo8GzLiOq0831aq53/oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717406526; c=relaxed/simple;
	bh=kkqv7f+rHzuJEI/kMTRxMigNaE2KbZILSTGg00a2wQs=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References:
	 MIME-Version:Content-Type; b=gzqO+AC/vYMIOWRHi3y0DUDua4Tx4UUZtWepbsbUIZ8SnusW5q5sb1xRjifnqOCPEsHtyQHYv2KzQzyc6MF3JyZqbSFjIg7WxcjbXBVHefqMtQq/Me1+PFok9lTk7VPF7vYsdbmRPb2J/aKsHI+2jeWSm0z1nEi1QF7V9vRT2dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U/NWRskS; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U/NWRskS"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-421140314d5so36450925e9.0;
        Mon, 03 Jun 2024 02:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717406523; x=1718011323; darn=vger.kernel.org;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QhkDydpEnWVJa23NYnN09j8h5HHO16p8o6lqrJSS9S4=;
        b=U/NWRskSNb39w4DEcGf2BDBRJs50I0YSlvbBKmVA5lXeG/60J5aeO1V5sauFeoHspn
         uLrGYrvnUp5U1XirJTJnVJdkd91R/KSl9hX2JFYzuZwwGvJ28lJeCaDKLC98+a6QKbj9
         8He1i7IzTjrsrTRZF0CNbFLnsJP/H9mdRbswG0sEDH4Y0Eej/INf8jBQI8E9ZgsupL9B
         GhBj0ZeQ+DASd0phFrWFtUCQqe4mxFOGNeYH9JHge9e3TeArJtrdWuehU1c8LODukBvu
         eTH7uFwHUnHxtXhA4Y7dy62V+mFFhIx6lmSSTKIzwT11aM4ZB8Jja1to1ziNDQEQy9/X
         5EHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717406523; x=1718011323;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QhkDydpEnWVJa23NYnN09j8h5HHO16p8o6lqrJSS9S4=;
        b=lKrFjNUF+ipNmAtBjk0keuiFZggtKnDyx1Ov4k/MNSgP3xnTodrrDhB57jlQnhRWiV
         iHO6YbCG7RxQQUmN03FlPJS9eUblMn/FMZFl8p5xzwPYFUgkf1+SUm2+KdI86eATkThv
         4x+F74yKQjP930oejdCXwFs2vmkdRsMQcL6ZJAnEt779asQpMOU14geVlK3OXnYAFHB5
         wKQF1+hWtq+DaobBb9eNhzJNwxhkET/qu7vb7ywT2QAfcuTrZRnX8U5OclxC0cvvjAqT
         fs2Tcl70uGB/9uDBKIzvujkAZyYNuyULcfKkcLc5cgFC2Vf+kCeT1Z5mdf+ny41117NV
         mWKA==
X-Forwarded-Encrypted: i=1; AJvYcCW2jRFDiM4azfBFXEOCGAvZnObjhqW+gGGQ90uKCBwecw7S2r3kXvHrmY1tu3/xD28yJXtzg2qsA8FZ8jR5z9v0aRpPyVux+2w0ptPwSC6F
X-Gm-Message-State: AOJu0YzNE8BZ273fXtRpoc9Cj2WwCGoMORLRvnY9msI4l1fGs0YjRTkd
	vv/RAfkPZVhima/r/jVQhk3Vi8iwpX4YDlhNBnb/PP1K5V/I2xlF
X-Google-Smtp-Source: AGHT+IGYii8s236v2HRjuN11+ZclzNcKnARrLpPWiM+5LfNTUZcr+ku5iSmvDXFi/pfZX2i8uoEUEQ==
X-Received: by 2002:a05:600c:a4b:b0:421:1165:f240 with SMTP id 5b1f17b1804b1-4212e0bfd91mr72960375e9.36.1717406522919;
        Mon, 03 Jun 2024 02:22:02 -0700 (PDT)
Received: from imac ([2a02:8010:60a0:0:601f:3dcb:b672:8b65])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4212c0fb782sm109146475e9.24.2024.06.03.02.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jun 2024 02:22:02 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: Simon Horman <horms@kernel.org>
Cc: netdev@vger.kernel.org,  Jakub Kicinski <kuba@kernel.org>,  "David S.
 Miller" <davem@davemloft.net>,  Eric Dumazet <edumazet@google.com>,  Paolo
 Abeni <pabeni@redhat.com>,  Pablo Neira Ayuso <pablo@netfilter.org>,
  Jozsef Kadlecsik <kadlec@netfilter.org>,
  netfilter-devel@vger.kernel.org,  donald.hunter@redhat.com
Subject: Re: [PATCH net-next v1] netfilter: nfnetlink: convert kfree_skb to
 consume_skb
In-Reply-To: <20240531161410.GC491852@kernel.org> (Simon Horman's message of
	"Fri, 31 May 2024 17:14:10 +0100")
Date: Mon, 03 Jun 2024 10:19:27 +0100
Message-ID: <m2ed9ecrj4.fsf@gmail.com>
References: <20240528103754.98985-1-donald.hunter@gmail.com>
	<20240531161410.GC491852@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Simon Horman <horms@kernel.org> writes:

> On Tue, May 28, 2024 at 11:37:54AM +0100, Donald Hunter wrote:
>> Use consume_skb in the batch code path to avoid generating spurious
>> NOT_SPECIFIED skb drop reasons.
>> 
>> Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
>
> Hi Donald,
>
> I do wonder if this is the correct approach. I'm happy to stand corrected,
> but my understanding is that consume_skb() is for situations where the skb
> is no longer needed for reasons other than errors. But some of these
> call-sites do appear to be error paths of sorts.
>
> ...

Hi Simon,

They all look to be application layer errors which are either
communicated back to the client or cause a replay. My understanding is
that consume_skb() should be used here since kfree_skb() now implies a
(transport?) drop.
