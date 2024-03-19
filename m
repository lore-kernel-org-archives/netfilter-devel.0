Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B5F5FBA6
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2024 23:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710892706; cv=none; b=I2zhg/OpnB5kAFTZEO5QTtMrBy0ztUsu+Wt3MN9Ywj7ZuOu7m6aRs++1ve4/Z45Tn5rQLyJwcJSUmB94/OmhKD9lelLOBBTPQbjRHIMi6n0oHfQtC6BTbXxt7nubeTIvNMMxMyepmPfbr6UHATFl3m+9NqoCa+QKKp3dyqqtmL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710892706; c=relaxed/simple;
	bh=SRmeLBMw9Eg1sJkZqWzJ3v4wwV6BlqRQ4eeKbcPsHGI=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HRlOD7/JKMGxsntlDqBbdAgHhgNxasnjOF9BskdkOU1mZRnO3wu12O2okv+DMLnH2y38irkULtu1ojz+RcTuZ0GWRAvpHRoB34/388ZTe4xDzPfelLjgmIW05s4L1pRpF7/+Pbc/K1iHhoaMhUBmFu8bwN4CTGAZMFbG49gvMV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PJl2g0Dv; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PJl2g0Dv"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1def3340682so39778465ad.1
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2024 16:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710892704; x=1711497504; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vPpgSAiW1HhDYuitjQf6MOEAiaL35ODrD2U6B+GBRR0=;
        b=PJl2g0DvehQavC2vIIqM8gHKUEfpKxjeswfIt8JZq4RO2vdYNzujzxGKMT/oo/G3nX
         Mg4Af2Uq0aYRAx4xpb27Ms2HElQL18aVbSWU/g2fVXL+LzFFzLZqIWymELnNjUid69y0
         JfaqggkM/p9OkWZ2I8fTzAQyp99WaYIp7B9j9KG5+P4E22ST1gg43IZvxO/NZZIQkJ6D
         BBLW4gsuonWBaX2Ss3ckYJ4iY3Ti3pNEE2qYAsP3b6xBsKRU/ZnbIjj0ICbiMxp+A1pb
         pIwUpmkOzqG5p0SjBRe3/oGFVSHUeEc724M851JXezIeskBpkp6duiMY3jjedXjAVefR
         HfsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710892704; x=1711497504;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vPpgSAiW1HhDYuitjQf6MOEAiaL35ODrD2U6B+GBRR0=;
        b=eVGHi+1T3vy7pv6HNMfWjhq8zOD58mWckM2zSMGfJafGKbA4FWG05I6/Od6p3UyKQS
         8fAR+wqR/hZNeZXf5i7P3x4WmyXWSLF04SdDWo0Z12u+0L8L1uRrwqBqnsN8hKTBPDNj
         j8ZGyE7WeG1LUic5VJG7GqR9NGMuyEEmalSiyGqA1AqYPFIPAsn3BWWe46YXE8a3deE0
         6pTfi8TUoTRK7Rg4wrWq81/BGVbISjDHMSrs8BFIW1qldUbvAse+SAn6VNJDwULNlVqG
         +mvukmRYOCkkUjTkiIJhfrY/s8PH+0YPx2Pzt/Iy5DaGSoZqsogA2FwN2co4KgDF/krt
         WQjQ==
X-Gm-Message-State: AOJu0YydSfzXdUe2eJlkyMKuiYOQwT0/6dPqnLGOS0E8a1pCQj49VuUJ
	aiTCSVXXm5PExuNpoxKx8PNxVKMXY/PhsRS1nFVmB+kT8ddVaiH011znD2fh
X-Google-Smtp-Source: AGHT+IFhyi30pztrkiMnDedw6NR1l6fhXGgSpWgZYuv+A3gjjzVvN0zvnr1d3OwIz5BEYaTJGKMBPA==
X-Received: by 2002:a17:903:4289:b0:1dd:7df8:9ed7 with SMTP id ju9-20020a170903428900b001dd7df89ed7mr4142865plb.15.1710892704250;
        Tue, 19 Mar 2024 16:58:24 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id lh6-20020a170903290600b001d94678a76csm12027885plb.117.2024.03.19.16.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 16:58:23 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Wed, 20 Mar 2024 10:58:20 +1100
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue 00/32] Convert libnetfilter_queue to
 not need libnfnetlink
Message-ID: <ZfomnPKqY2eUOBX6@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20240213210706.4867-1-duncan_roe@optusnet.com.au>
 <20240213210706.4867-2-duncan_roe@optusnet.com.au>
 <ZcyaQvJ1SvnYgakf@calendula>
 <Zc69T21ekMhEbjZ1@slk15.local.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zc69T21ekMhEbjZ1@slk15.local.net>

Hi Pablo,

On Fri, Feb 16, 2024 at 12:41:35PM +1100, Duncan Roe wrote:
> Hi Pablo,
>
> On Wed, Feb 14, 2024 at 11:47:30AM +0100, Pablo Neira Ayuso wrote:
> > Hi Duncan,
> [...]
> > because this conversion to libmnl _cannot_ break existing userspace
> > applications, that's the challenge.
> >
> Absolutely. utils/nfqnl_test.c builds and runs, are there any other examples I
> could try?
>
> Userspace applications *will* break if they either
>
> 1. Call libnfnetlink nfnl_* functions directly (other than nfnl_rcvbufsiz())
>
>   OR
>
> 2. Call nfq_open_nfnl()
>
> Is that acceptable?
>
> Cheers ... Duncan.
>
To clarify, the new patch series
https://patchwork.ozlabs.org/project/netfilter-devel/list/?series=399143
overcomes 1 and 2 above.

Existing userspace applications should *all* keep running.

Cheers ... Duncan.
