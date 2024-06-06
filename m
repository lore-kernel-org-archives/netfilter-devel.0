Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D3B19752A;
	Thu,  6 Jun 2024 14:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717685030; cv=none; b=Djk8eRfJgVmRH7xxcRp3Mf6eWm3wJGK4WWa+acvY5BbVA87C5I4jmqcsSL3e6lGlCU9iYsoP6dStfUe+SzvwZAgsbkrztHIaeuyLJ3XM4ZmgkFDZZbsazzqFjb0WkeaMtlY1ZFYW5n4810cVauT0mKSvdJ6ky+ngk07P9tIjyJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717685030; c=relaxed/simple;
	bh=JB1NevTXdv+UNsEQ6WfgHDPb8FWJM5nleNsoGLmDvwY=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=HAJlsKEXM9c3J2jTD7/4b3+Cfd/44ZPRHTMl/hlk4wkK4tvvV/A0VRFIOUJeyHinANf8nwmgkKYNS+hN7dh7aF964Xyt6q2gMMl31hP2+omIVimcpLjEEZ4QBNOrHe/xocnXTYuqbSp4KI1sY7jdOirFloIQaWnFbue1SXwVcjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WpnVf+bP; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WpnVf+bP"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-6afbf9c9bc0so5630026d6.3;
        Thu, 06 Jun 2024 07:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717685028; x=1718289828; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dp3NsIAD5uVeKMXKm6Hi7+g1K8jYuPKZ1gkbAWgUwqw=;
        b=WpnVf+bPVXpu71ipkKRoDt6mX0MIA0C/GtZgq5p7VnZAhqKOcmAaN8cDwzCuxkbLI2
         Ogin1MlymRkgdaA8vhgZ6QaXqDk7q5nqSbL5V4VV7Ngt/rfQXSORPKo77JAVl0vGsPUv
         EdW3zrz/+jYN0gFiehMMKdV8+TNixDOfGoS+gIPVaowhvzZKyjalPQrcdprbVjCUvFNu
         DbKZFtgiz/hBUtumkFOZlkZo1sZJ4odYMtDF2LVAM9L3+rParjX0knjIWngmnNQH1WxX
         jYxrWaE9QH6NTazI/cP5MfazfwpezbGyE4X4kWBx05S00MuSCGR2IhLEPHCtmAfLAEbk
         ZfHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717685028; x=1718289828;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dp3NsIAD5uVeKMXKm6Hi7+g1K8jYuPKZ1gkbAWgUwqw=;
        b=ZPwq+ofRhL61m/Ji2aJaw1Czz2XQyfgiXAMg3+zXO+/NzV916EmXCMzXEIxCYOpc87
         SqEl4Twx7t8XFiNAyrArNrBDNl3KNnORm3nw13CfBB5x77tqAgGNS92SQqLEeQ+6Xnpn
         gqHoglxa8qRMRUr+aL2w0etxGjZ7TvyZvFDzoFeb6bx81uA3NwMBPKDxXjnP1p+6hGGD
         +LYI0XmnG82D72bWTPpZ1SUWn5Bi7IBnClAfidhnh6el4TaovqfueMMrgm3OiGJwfwTP
         VgUtvOxDghfxRx5UaKbIlE1pK2taNr1KftqqQ858SwqgVmkA3fMWgPC/1OzPlf0yshsm
         5r7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWLWB/ptQUBgPU6QJIViobEBnTI+4UTop0Zkd85Hwp/LpWnXzufwTXd7fuGlDZQMxh+/CEDLRMMQOHvcbyFLbHY9bqMbksSkwsFJ1G/nA+NihPDhcCh51I1MruGeE7UvhoE+NHBdE8B
X-Gm-Message-State: AOJu0YxegjyGS3q1kD/k9Tx1/qbVHUms4Q1IcqNrgUKndyM+2gy6FOP9
	NSHMSmvy/2lh7Wa+UBKAumHCSW8Z6H7H9ny7ZH8qi81syElw42OL
X-Google-Smtp-Source: AGHT+IFz7VpWfdXKTOre5xW5ScvKtvVshPrUNctrvmvVjvcf+ECV/tT7kx8p6xx3FxnJS7asAQWkwA==
X-Received: by 2002:a05:6214:3902:b0:6af:cb9f:59dc with SMTP id 6a1803df08f44-6b020320c02mr60993506d6.1.1717685028129;
        Thu, 06 Jun 2024 07:43:48 -0700 (PDT)
Received: from localhost (112.49.199.35.bc.googleusercontent.com. [35.199.49.112])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b04f7046c2sm6859456d6.59.2024.06.06.07.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jun 2024 07:43:47 -0700 (PDT)
Date: Thu, 06 Jun 2024 10:43:47 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Florian Westphal <fw@strlen.de>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, 
 Christoph Paasch <cpaasch@apple.com>, 
 Netfilter <netfilter-devel@vger.kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, 
 netdev@vger.kernel.org, 
 daniel@iogearbox.net, 
 willemb@google.com
Message-ID: <6661cb237158e_37d9572949b@willemb.c.googlers.com.notmuch>
In-Reply-To: <20240606143816.GC9890@breakpoint.cc>
References: <20240604120311.27300-1-fw@strlen.de>
 <FF8A506F-6F0F-440E-9F52-B27D05731B77@apple.com>
 <20240605181450.GA7176@breakpoint.cc>
 <ZmCwlbF8BvLGNgRM@calendula>
 <20240605190833.GB7176@breakpoint.cc>
 <20240606092620.GC4688@breakpoint.cc>
 <20240606130457.GA9890@breakpoint.cc>
 <6661c313cf1fe_37b6f32942e@willemb.c.googlers.com.notmuch>
 <20240606141516.GB9890@breakpoint.cc>
 <6661c788553a4_37c46c294fc@willemb.c.googlers.com.notmuch>
 <20240606143816.GC9890@breakpoint.cc>
Subject: Re: [PATCH nf] netfilter: nf_reject: init skb->dev for reset packet
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Florian Westphal wrote:
> Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:
> > > I named the copypasta as nf_skb_get_hash. If placed in sk_buff.h:
> > > net_get_hash_net()?
> > > skb_get_hash()?
> > 
> > Still passing an skb too, so skb_get_hash_net()?
> 
> Sounds good to me.
> 
> > > And if either of that exists, maybe then use
> > > skb_get_hash_symmetric_net(net, skb)
> > 
> > If symmetric is equally good for nft, that would be preferable, as it
> > avoids the extra function. But I suppose it aliases the two flow
> > directions, which may be exactly what you don't want?
> 
> It would actually be fine, but the more important part is that
> skb->hash is set.
> 
> For the trace id, I want a stable identifier that won't change
> (e.g. when nat rewrites addresses).
> 
> This currently works because skb_get_hash computes it at most once.

Probably not relevant to these skbs, that don't have an skb->sk.

But in case skbs coming from the TCP stack are also in scope: can
sk_rethink_txhash cause problems?
 
> skb_get_hash_symmetric_net() will be used from nft_hash.c as
> __skb_get_hash_symmetric "replacement".
> 
> Pablo, you can drop this patch, I will try the 'pass net to dissector'
> route.


