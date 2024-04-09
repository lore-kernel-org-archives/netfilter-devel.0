Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67165384
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Apr 2024 12:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712667326; cv=none; b=B6opEBrVpUobbVmniWD5Ktan9uqLF2F4HBZW/mLCvyLohYzKA+8niBbsUuRnyVC6Sz0o+m1gzbwK0qXO76tW/8wKqfWmraJXsQ+58nNAmgl5JCxIIkDTll2qwTaYFIXxX3AMr/oZ59NpvwIAYIedCpBJ321nwMsxWAsEpr+278w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712667326; c=relaxed/simple;
	bh=TLGLz3ceJWDEyWDUB9uQewq+DjXZrAMr7cbKF2VoxxM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RDX3+HDi2wcA+iKXDxq+7JAKZh8pB9YqOXLixJoWM49RogY/tq89RuKMrtRZP3+zayUYPsIyWuhUS+k2HYeoEtjKkixXUCFWwVVC8NKqjuh6YSyXvqhowSCmNFaiONuD+oaXZbxk43HO/0r/umL5v/Hs/M5YvJr9/4yKmoLQBew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CWMza9IB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CWMza9IB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712667323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VNniD/0gYX36QFFVq4AgTLTRus47Miy0YO9x/oR7kbg=;
	b=CWMza9IB8dOf8ZQgBPPp6p7Us5ifh7L6WUd3P5n8lQVRl2QskAgK2QZoLqk8raL6+FmiLt
	btFynIwW+EowRwwpfugRx6AFyFzrBzJ0vq8PnuGejywv+Oqg4bC9BD8ApNVi3jCKbcz8w5
	5hP7cK9RC0Q6N40/NqjH+IWev9OPwHM=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-45-M7QnCIumPEGx7d0WPcB26w-1; Tue, 09 Apr 2024 08:55:22 -0400
X-MC-Unique: M7QnCIumPEGx7d0WPcB26w-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-516dc2a36easo2703669e87.3
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Apr 2024 05:55:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712667316; x=1713272116;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VNniD/0gYX36QFFVq4AgTLTRus47Miy0YO9x/oR7kbg=;
        b=vOKEc2g+tv/+ZEtbWuKLWtaGOru71GrAT8GciVPjNeUE0IvSjXbUNTzE7hjbhgZNAR
         9W0TXe2ztv7qYK20myfCvj8LVO6oT8zhla96SO94tcCGMVjn80SZ2ZoVTziSEoo8R9ov
         Vvclh/OikVBKW8Q+RUgC1besrPmaA4soSATPHU6Qa4rnDM9EOCNGbiPCx0IsDHtcAju1
         HnewuAdedH/m/5EmPdGv6DOgbJx8xcUgMpxzoYKUMq13C1+ib7Lw9sKN+8sTGP5Nlqi9
         0xH0CX4SuXr1z9lw/DB2D4VqE6FHXWZLNbUvWRn+5VuBnKPsjsmhRvKqLos2DtD90C5e
         Nn2A==
X-Gm-Message-State: AOJu0Yyz+bCO81IjXNOuBjAJJ1NkOu3dyOnYDpFu7fFbI9yxwb842RAt
	jR1nHHDnItRugz76Eivi2vLRO335o8qLStZ/fRivpEgNfvLfWh+K3YJO6hI5xjcusck9Zdo09Nn
	rJ6pweJPF+5azQkZX4gx/3wKIHBI2ahDSeX3pxvJp9Ner97RYqWmMHQjiAU+liQwvq2vQrO3UwL
	qv
X-Received: by 2002:ac2:4304:0:b0:515:d30f:7670 with SMTP id l4-20020ac24304000000b00515d30f7670mr7588964lfh.13.1712667316472;
        Tue, 09 Apr 2024 05:55:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE8g7y6JHVUuGwInkXseQIXPbvPOMg1n0mc++PAOw3kA+QsZogRlLfXqn21k7ifFU1zU81Wxw==
X-Received: by 2002:ac2:4304:0:b0:515:d30f:7670 with SMTP id l4-20020ac24304000000b00515d30f7670mr7588944lfh.13.1712667315906;
        Tue, 09 Apr 2024 05:55:15 -0700 (PDT)
Received: from maya.cloud.tilaa.com (maya.cloud.tilaa.com. [164.138.29.33])
        by smtp.gmail.com with ESMTPSA id z12-20020a17090655cc00b00a42f6d17123sm5626580ejp.46.2024.04.09.05.55.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Apr 2024 05:55:14 -0700 (PDT)
Date: Tue, 9 Apr 2024 14:54:40 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 3/9] netfilter: nft_set_pipapo: prepare destroy
 function for on-demand clone
Message-ID: <20240409145440.5b72df13@elisabeth>
In-Reply-To: <20240409110704.GA15445@breakpoint.cc>
References: <20240403084113.18823-1-fw@strlen.de>
	<20240403084113.18823-4-fw@strlen.de>
	<20240408174503.0792a92e@elisabeth>
	<20240409110704.GA15445@breakpoint.cc>
Organization: Red Hat
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.36; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 9 Apr 2024 13:07:04 +0200
Florian Westphal <fw@strlen.de> wrote:

> Stefano Brivio <sbrivio@redhat.com> wrote:
> > > The rcu_barrier() is removed, its not needed: old call_rcu instances
> > > for pipapo_reclaim_match do not access struct nft_set.  
> > 
> > True, pipapo_reclaim_match() won't, but nft_set_pipapo_match_destroy()
> > will, right? That is:
> >   
> > > -	if (m) {
> > > -		rcu_barrier();  
> > 
> > ...before b0e256f3dd2b ("netfilter: nft_set_pipapo: release elements in
> > clone only from destroy path"), this rcu_barrier() was needed because we'd
> > call nft_set_pipapo_match_destroy() on 'm'.
> > 
> > That call is now gone, and we could have dropped it at that point, but:  
> 
> I do not follow.  nft_pipapo_destroy() is not invoked asynchronously via
> call_rcu, its invoked from either abort path or the gc work queue at at
> time where there must be no references to nft_set anymore.

Hmm, sorry, I was all focused on nft_set_pipapo_match_destroy()
accessing nft_set, but that has nothing to do with
pipapo_reclaim_match(). However:

> What do we wait for, i.e., which outstanding rcu callback could
> reference a data structure that nft_pipapo_destroy() will free?

...we still have pipapo_free_match(), called by pipapo_reclaim_match(),
referencing the per-CPU scratch areas, and nft_pipapo_destroy() freeing
them (using pipapo_free_match() since this patch).

I guess *that* was the original reason why I added this rcu_barrier()
call here? Unless I'm missing something, nothing changed in this regard
since then.

Or is there another reason why pending call_rcu() callbacks can't touch
the same scratch areas now?

-- 
Stefano

