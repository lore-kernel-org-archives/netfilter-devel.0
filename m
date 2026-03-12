Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265862459EA
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2026 22:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773354681; cv=pass; b=RynELzVNHTz1ALthGTEuSEwn51s6mbMdXGUTMxTLZBdptvKgo4gBj4C0gDX+mobGjRhRtvu6758/+BgLNhSMkIQlh6XMn818LVIBdclna3zEn//9aSQ6AKA51/Hp4IkQdEpq2IyR/SUtnY3YsuToy9ICcsVFvir0x2YyBvcEcZk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773354681; c=relaxed/simple;
	bh=jIysDDa+z2vnCpZjDOfTgI4RhgB7fGnohz/dtG6w9Qs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FxoZJ+b1LTXbyp3uaQhV+Se8Ityflmc7hHy4mtjRjTWu/YZq2du4vqpxnIjaz7sOYuKklWs7yHNBZT4M2bTQksMJwUEFdI5jZ9E0pkpiiXdy3L8mAFBwZxYcIvVnmSDpyGM/yNI/GPGYeGsWGYWxI29a9nSVavokngNcaqkCoec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=arista.com; spf=pass smtp.mailfrom=arista.com; dkim=pass (2048-bit key) header.d=arista.com header.i=@arista.com header.b=DdDsoHbQ; arc=pass smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=arista.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arista.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arista.com header.i=@arista.com header.b="DdDsoHbQ"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5a1322af04fso1878568e87.2
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2026 15:31:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773354678; cv=none;
        d=google.com; s=arc-20240605;
        b=GMinlkw7YgSIpsnb7vFZUQ3GgXu58XwiZz4cg+h9X6COJE89nz5S6zKmK23AJY5GRo
         7/jUBssCpkswDIMOztVM4012pATBARL9g3plV0XrxMWsfOVSiurU7dmBK+jjdYud6j29
         adYUdH37Gb1yKJSDqpvpKdHzFShdLz5nId7XJh3UHbcjHc+Q8unn2UH3cEFb8GVfOAja
         C6SaMLcTYHfinSEZxqSrfjPD9ol/K2JUdHwlocoqCSL5wye8w3io+qKwwFpDc391mRXj
         MDg0KPPtn5pciVdaRMYSwYpN7AXnnHZ5PeRYBZgCn5NzdTYWxCQrYoagwJPeNkNLJmgt
         3abw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MpQacvF+mAyXs6pqu3/eg9OImF2i4oKZdu4qdPo1RFg=;
        fh=GGiwdHYbi+1BzwZX5Fj2ssBp3CKAIY2dSe3/6BsSRjM=;
        b=RraX1sRnF/Q6e5Yp7T3GlSB4H2vpDXwwuVHGESmBVhXuR4/INBG3Nf1L/JqU/y3XJs
         ONOrMq5HrjdetL3KiAozl+swsEfskKs5wk/kNbqCPz1cWGMsgUz1QqFEvs2eO1rrMREn
         ld2a4iLHXjWyGGvD895TwRWx/8vOXzaBZbM2/YA//T1TT1BxOy76E0/MwXOSmb2oHCK0
         WGFnlYVijLqXF6oAEhfBibFQ3Gf60gowBGnl5ejaie0xsST6HgkTA8qx1w5ftkb6uOyt
         9Tz4OCEwo5fbrA3q2uku98gxl+HyaXnQaEjpKfjg8HsIMw+ZgoKuAxdSXP4yMWfZV6bg
         AF6w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1773354678; x=1773959478; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MpQacvF+mAyXs6pqu3/eg9OImF2i4oKZdu4qdPo1RFg=;
        b=DdDsoHbQQpbbpq/aniI/yWh5R3J55sdzc7y2esgxiVMBisQV0mmbw7J4xD/vbx6mnA
         vZ8MpbdMgXHHlRXWTxBxL7+mrlGy7fqAIHEgqzgT3obuSy3vgGwsV0KKK6MeP3QFBQqX
         0ZPWU0FcDSs+SmnsWSVO1OISQfSdr4cJpvqEpszw+AtoZzw4bgqphM23E01clD8k7vFU
         QKRcIakSsMXB10ZpuLVugLShLtv/MSWXphLe7Kr2qvBL67NWdaYqLkPXM7ipPB96f8QW
         Lg2NHqumobwW9ZnPfCupHFpLNIb6ABk2sFwbLhNEImG8FSNaL6R6vv0XnAn+HiIFK9Hd
         netw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773354678; x=1773959478;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MpQacvF+mAyXs6pqu3/eg9OImF2i4oKZdu4qdPo1RFg=;
        b=ijTWarJ8LlhOAH/HCuOW0LtL9p6IIUp21J7gJts26Nnf7iPiu7UaqgE2gmWK7URy80
         b8sSkqHaNrLCjkJAVep2uyIpkx3dHZFQMixGna1iSw/VMbgXWLHLhR8dERjFXtI/N3PM
         efJ38wjawifBAowzXv64hVez++eaWbZq14KPUkRnU4O+JXcOJ7tLuNY36FGrNoxzaUgR
         j3GUkDDvzdMgqdHh6GZFiVeXKEGoyGdIDpAKD98yZxVjj/jQl22+2zwq27aHUVibwSG1
         Lw5nf8O+W32RcDNYx45HUYWWZkatTo9p+OvTP8DlZNbBDgxjzSNlVkD3EheisUhkdAJZ
         91xQ==
X-Gm-Message-State: AOJu0YxnmmgS3sAp8Lbp0py8yAbxgE5mxAxcz20LIyosneECqP+ssvU3
	kcOVWDQmN/uAyaFX8LsobOlNPzfSKtYs6U6dMYOXBEeLZTGXKvEuTWXvldc2cqmG5VMBm3rReTB
	w9jNEEFMv0EIOz7W9K6CL6aGvGFgmYYfxn8ZcYDzC
X-Gm-Gg: ATEYQzwQmUL0VjAkdLrvT7tN8G+DIM0Zqy4kVxQX5AEDR9vIj+p2oWPQZ/KlsGD+iFY
	ajeLH24TwnosiwUcNOgkCnfMe049+czugo+r9nLwtZttovfirxKedx9lFqRcui1ONXcQK9v/o4r
	jaaxCf1TJPOVDjmLpTyMiSts2U0whKDB6ZyoYL6Z9aDTvDedZjDhwPTVTa+9i5wHXLQaFsGZQjG
	Sd8vlKaAGNvT4LMEPz56/DvvXAmFoWMkEkf+wEq9pO+VTvrrQRtOmKdtaG/W9baHV5Aoxyzz51U
	70MBxg==
X-Received: by 2002:a05:6512:3b99:b0:5a1:36ac:2ca9 with SMTP id
 2adb3069b0e04-5a162b2fd47mr388247e87.49.1773354678175; Thu, 12 Mar 2026
 15:31:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260311194058.13860-1-panchamukhi@arista.com> <abKzWIhVz_SeiSOa@strlen.de>
In-Reply-To: <abKzWIhVz_SeiSOa@strlen.de>
From: Prasanna Panchamukhi <panchamukhi@arista.com>
Date: Thu, 12 Mar 2026 15:31:06 -0700
X-Gm-Features: AaiRm51ZlKY4h04uIgBgBAaeWon8_os3iwnwKSpFi3tkPhPpb-qpMihKuCf8Q-8
Message-ID: <CACqWiXD2_O32K4NhmNBZrAUG7U9-N93LTFjJHG6Tq=4vuafNuA@mail.gmail.com>
Subject: Re: [PATCH net-next] netfilter: conntrack: expose gc_scan_interval_max
 via sysctl
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Pablo Neira Ayuso <pablo@netfilter.org>, 
	Phil Sutter <phil@nwl.cc>, netdev@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, coreteam@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 12, 2026 at 5:36=E2=80=AFAM Florian Westphal <fw@strlen.de> wro=
te:
>
> Prasanna S Panchamukhi <panchamukhi@arista.com> wrote:
> > The conntrack garbage collection worker uses an adaptive algorithm that
> > adjusts the scan interval based on the average timeout of tracked
> > entries.  The upper bound of this interval is hardcoded as
> > GC_SCAN_INTERVAL_MAX (60 seconds).
> >
> > Expose the upper bound as a new sysctl,
> > net.netfilter.nf_conntrack_gc_scan_interval_max, so it can be tuned at
> > runtime without rebuilding the kernel.  The default remains 60 seconds
> > to preserve existing behavior.  The sysctl is global and read-only in
> > non-init network namespaces, consistent with nf_conntrack_max and
> > nf_conntrack_buckets.
>
> This was proposed before, see:
>
> https://lore.kernel.org/netfilter-devel/aO-id5W6Tr7frdHN@strlen.de/
> https://lore.kernel.org/netfilter-devel/aRsuU57juCvsMBKE@strlen.de/
>
> I did not hear back wrt. the horizon cache.
>
> I'm not 100% opposed to this, but I do wonder if we really can't do
> better than the current avg strategy.

Hi Florian,

Our primary goal is to cap the maximum time taken by the GC to clean
up expired entries. We rely on user-space notifications to clean up
these entries from the hardware, so ensuring a predictable upper bound
is important for our use case.

Regarding the adaptive strategy, we are using this sysctl to address
environments where the current average-based calculation delays the
cleanup of short-lived entries.

Thanks,
Prasanna
