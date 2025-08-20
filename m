Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261DC326D47
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Aug 2025 16:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755706548; cv=none; b=gdjYHBNehg+k5xkr8CbDE9G/2mHbIMVhgOT+4W+IhUvt3hoOwT96gGT4qSQ0k/PaSGl+gucfP48JS/T4MGu69EaTz2cLX1dBWxjC4KtyEzcBbzlr6YuVCz5SbXvpHpT8aOl/VHiK4SwPyPnttRccMaiVE59UF+PNFg1PRsnaem4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755706548; c=relaxed/simple;
	bh=FmHOEf7MjwzLR9SFGycQnEmLXC7g7DnQT/alR2QVzT8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kkP1QuPEv2wkWcE9LDXb8C7Pv/o5FFpoWZ7+QZj3azpKHmwougqq0FsQetlmCrVu1QUF/nKMrDFkdz+z/xJreqKv0vdC1IfDoMNprPM4TkaXgoYd8S6JbD++0oUGwMJuRL+QhxIk1ls5eZXwU0F+jn6gvzd+yRHBbMH7BfaqXhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hNwIotPX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hNwIotPX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755706545;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yBhB09wHdMhtpKjiEXV4nMg7vjjK7vxey/Z1jurlktk=;
	b=hNwIotPXaQGk7GK9VL/ncQX9P7Oi8tJbWcosDJAA2ahx3ZnzrUkdn1Zt2Koi0F2/wl7P4t
	eU6vgPyL+C7+XklS2UpWBS7PhUK329oZkkhb/PlZJcxgxYwT+nHP+NdURcEzQUUC094cuq
	ZwddZnFDtgUByu9+/m8If5HaTYHsseI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-470-v5fwnXpKN6attMk3jKT4sw-1; Wed, 20 Aug 2025 12:15:41 -0400
X-MC-Unique: v5fwnXpKN6attMk3jKT4sw-1
X-Mimecast-MFC-AGG-ID: v5fwnXpKN6attMk3jKT4sw_1755706541
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1b0c5366so207715e9.3
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Aug 2025 09:15:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755706540; x=1756311340;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yBhB09wHdMhtpKjiEXV4nMg7vjjK7vxey/Z1jurlktk=;
        b=k00W31uw5MijSzoRDVStSYRmAuhSXAwb7VFcXcMIlCnq2uqd3NJy5nBsv3JvxpMf96
         oSIQh/BQIvk46JciSILK0yJ/Jp28rirBUckrE0Erb1cYWrb4KbgER+R4Awnc3cWAuanm
         t9OdGTc31wtGoybqEFc9Q/T36GhkAEsm3X0xbjp83kRacRrKzYc+9LLpc/NhpMRU8YOq
         rM6t3NjYa2DCVXKheg1vVT6nGO9pxBOdoOCJsPCeqV+GYkLK1Gbs8ONjVXD5cmUYWZiH
         6AKpVysFCwufPAsCDkAE8FnllNZ9H4uA7lSfdofCJTf/jmjo8EtUlBlQfqyLru2C07MQ
         CCeA==
X-Forwarded-Encrypted: i=1; AJvYcCWQ0BC8nSs4bT9kRiT4ZgMZJWvANfhoZHH1u+oUhDx22FsA72yBseM4hLIPTSHPKsTiLQFLc0O/mW2mXrRcU9g=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoLRrqYuytAVNtXRT+TExOpYXqMlPWgAkeQlkMR6s3cHuGbvhO
	heEQAMWXGb/QzrU16jE6zXXZfwAc2Un8GPsgdmoY47pLJD31xXL+mBBRh+gz2lju+el3126ulgk
	WqNrFYBWtk4NM+gEn1QJo59jbSP5FwmJVZaG3eMDDLpqHQyWPG+9sItTrjtVKi45waHnYZJ8LvZ
	Kkeg==
X-Gm-Gg: ASbGncvklqKLE1QHIiyfMLDGtzhbTaQb7AcGDVI+LdlDRd9h4xCyRZOgPfLuImPFM3g
	ucAL1YFeo4ukS6FN8+MkRgMN+W0+rpb5V4D2VUrT08zfB9ylWVV3/iZTlJPvYcOum4FGfSf1H71
	KHMPWvqg+JoRKBtyRsPa3zWLoDUGe+dgCDyBqU4waxu8tpGu7IGT9asPClwKh8AXwOzxrCplB31
	A5n1eItm+U7AdZka14An5YfKHiKRi0jZdotVZJd6V+PzN8wTtIWw8O6EvRvkJooyMe0E0jqj0Ww
	xSjLAUgloOFC7raUKIav6bdka7mx44s7MN+XNRHhawMS2ofQrJI=
X-Received: by 2002:a05:600c:154b:b0:455:f380:32e2 with SMTP id 5b1f17b1804b1-45b479f79d6mr27255975e9.18.1755706540008;
        Wed, 20 Aug 2025 09:15:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEPJDWrBumRyAQCy4kE8EcRfm7sgn0bAFrBm23+c10zozIdTM+CPPG52qle89ZD6znNmpKcKQ==
X-Received: by 2002:a05:600c:154b:b0:455:f380:32e2 with SMTP id 5b1f17b1804b1-45b479f79d6mr27255695e9.18.1755706539550;
        Wed, 20 Aug 2025 09:15:39 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [2a10:fc81:a806:d6a9::1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b47c5bfdasm37188635e9.19.2025.08.20.09.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 09:15:39 -0700 (PDT)
Date: Wed, 20 Aug 2025 18:15:36 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH net-next 5/6] netfilter: nft_set_pipapo: Store real
 pointer, adjust later.
Message-ID: <20250820181536.02e50df6@elisabeth>
In-Reply-To: <20250820160114.LI90UJWx@linutronix.de>
References: <20250820144738.24250-1-fw@strlen.de>
	<20250820144738.24250-6-fw@strlen.de>
	<20250820174401.5addbfc1@elisabeth>
	<20250820160114.LI90UJWx@linutronix.de>
Organization: Red Hat
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.49; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 20 Aug 2025 18:01:14 +0200
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> On 2025-08-20 17:44:01 [+0200], Stefano Brivio wrote:
> > On Wed, 20 Aug 2025 16:47:37 +0200
> > Florian Westphal <fw@strlen.de> wrote:
> >   
> > > From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > > 
> > > The struct nft_pipapo_scratch is allocated, then aligned to the required
> > > alignment and difference (in bytes) is then saved in align_off. The
> > > aligned pointer is used later.
> > > While this works, it gets complicated with all the extra checks if
> > > all member before map are larger than the required alignment.
> > > 
> > > Instead of saving the aligned pointer, just save the returned pointer
> > > and align the map pointer in nft_pipapo_lookup() before using it. The
> > > alignment later on shouldn't be that expensive.  
> > 
> > The cost of doing the alignment later was the very reason why I added
> > this whole dance in the first place though. Did you check packet
> > matching rates before and after this?  
> 
> how? There was something under selftest which I used to ensure it still
> works.

tools/testing/selftests/net/netfilter/nft_concat_range.sh, you should add
"performance" to $TESTS (or just do TESTS=perfomance), they are normally
skipped because they take a while.

> On x86 it should be two additional opcodes (and + lea) and that might be
> interleaved.

I think so too, but I wonder if that has a much bigger effect on
subsequent cache loads rather than just those two instructions.

> Do you remember a rule of thumb of your improvement?

I added this right away with the initial implementation of the
vectorised version, so I didn't really check the difference or record
it anywhere, but I vaguely remember having something similar to the
version with your current change in an earlier draft and it was
something like 20 cycles difference with the 'net,port' test with 1000
entries... maybe, I'm really not sure anymore.

I'm especially not sure if my old draft was equivalent to this change.
I reported the original figures (with the alignment done in advance) in
the commit message of 7400b063969b ("nft_set_pipapo: Introduce
AVX2-based lookup implementation").

> As far as I remember the alignment code expects that the "hole" at the
> begin does not exceed a certain size and the lock there exceeds it.

I think you're right. But again, the alignment itself should be fast,
that's not what I'm concerned about.

-- 
Stefano

