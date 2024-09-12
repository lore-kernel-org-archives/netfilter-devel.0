Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D0919992A;
	Thu, 12 Sep 2024 12:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726143516; cv=none; b=uoOIE8FQoKFtsldrc9lxcWIRqU0fNtfnbgEt8r9qUqGBsDH7yOz/5EW1yc5HRCjudD/esPxndybp5izCIRhrb0KqmuJfhQK7zZmr0UG/onMmldIna71BNsptrx4IteGe3xI+682YKSB8PXPbA4kOiSkOyvno/ZnAcUAlXvOFKt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726143516; c=relaxed/simple;
	bh=r3zxlM4VUHNbjP2euPsbiwCGlILtmoLXaiv2W4eRKTo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nCRndsCqqMLZYrIV9dos2kMN3zooAb/07B0uLaweBDYryDvV9iRqFcFI9YMTG0gjN3YZk5JmqifvyY1NNBIwP3mRKrvxtpkAUqHdQzC3UmvyzMd7esDV5ljPnJ9ByTUnpdCcsjPXtxk/vHmzLIjgS0N603EfGpf3h4CFdauffMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a8d56155f51so112426666b.2;
        Thu, 12 Sep 2024 05:18:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726143513; x=1726748313;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sG37F+BnEO0H/LIYsBFWUXBHGgaywY3AQMTmtrOCdqA=;
        b=gzJefGGD2AAcOaryTZRvZoF+0L3XsgIK3DfcfP0lU6L2Hw/p8JxgxA4uwBUzztScXv
         Na0Wu6THzrAVwAp3FOXizIgCvEYpFyg9tIO299RNDUr7wQv9XnfZqQ7J8I0j7a05e4Ro
         GTwMz9CvBOBsA1eA/mdm8Rcy/yJNBwR6N9FwSNBT24DS1wX6q/YmmTHxKIzroOnHSIYl
         80GKCbXIL8Qs+2v/H1DhJ95hglg/A+oX7oZx/I/3/o7sNJpFVxRXLhUZZbXjP25WTGUa
         z2a/qybMlA5wqgWckW0wmxSRxSvicGTu60FQjJ6Ix4Nh+MAfa54GRd9tUsLUXZdHEO6c
         3WCA==
X-Forwarded-Encrypted: i=1; AJvYcCWBEtu/AP07PUqIPfmDsHDZJl62W7HZOa/dNWGJI5rnPSVbfbj2unM+NLZ0h8BGDoVITQ4NlzrY0rJAY6I=@vger.kernel.org, AJvYcCWnl6Uet3ZAqBTjy44uwZ10gsv1A6RiQ37jA5Vx4VdxspwGC7ie6orOCc9SUv2NXGICguPnLAbr@vger.kernel.org, AJvYcCXa3dDUhvh7MMD5OXqXUAQMtaMzCPmebFenJD/2+MMaQO8D1esdmSGgRptpX3W8Vd1/4BWAef0bhIeAOuDVXDJ/@vger.kernel.org
X-Gm-Message-State: AOJu0YzWwEyXN69LkpuP3yVZCd1b8a8nRYWaGAypKq1PVegNqcEGSKER
	szPrp5xuIoLyWkJCoMp8C+aJ1FHROO5X+wJJlPQIBxKSJ3pcH1t0CH8zcg==
X-Google-Smtp-Source: AGHT+IH+q4gdBuX+ZUYgVOKXM+tfBQAypJi9lq6OeZ8F6i9PxYgHK5Bv2YpyZsNuwjMyXa9Pz9wuow==
X-Received: by 2002:a17:907:980f:b0:a86:7ba9:b061 with SMTP id a640c23a62f3a-a90296715c0mr225128966b.64.1726143512016;
        Thu, 12 Sep 2024 05:18:32 -0700 (PDT)
Received: from gmail.com (fwdproxy-lla-009.fbsv.net. [2a03:2880:30ff:9::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25ced17asm750185966b.170.2024.09.12.05.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 05:18:31 -0700 (PDT)
Date: Thu, 12 Sep 2024 05:18:29 -0700
From: Breno Leitao <leitao@debian.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: fw@strlen.de, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, rbc@meta.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v5 0/2] netfilter: Make IP_NF_IPTABLES_LEGACY
 selectable
Message-ID: <20240912-omniscient-imposing-lynx-2bf5ac@leitao>
References: <20240909084620.3155679-1-leitao@debian.org>
 <20240911-weightless-maize-ferret-5c23e1@devvm32600>
 <ZuIVIDubGwLMh1RS@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZuIVIDubGwLMh1RS@calendula>

On Thu, Sep 12, 2024 at 12:09:36AM +0200, Pablo Neira Ayuso wrote:
> On Wed, Sep 11, 2024 at 08:25:52AM -0700, Breno Leitao wrote:
> > Hello,
> > 
> > On Mon, Sep 09, 2024 at 01:46:17AM -0700, Breno Leitao wrote:
> > > These two patches make IP_NF_IPTABLES_LEGACY and IP6_NF_IPTABLES_LEGACY
> > > Kconfigs user selectable, avoiding creating an extra dependency by
> > > enabling some other config that would select IP{6}_NF_IPTABLES_LEGACY.
> > 
> > Any other feedback regarding this change? This is technically causing
> > user visible regression and blocks us from rolling out recent kernels.
> 
> What regressions? This patch comes with no Fixes: tag.

Sorry, I should have said "This is technically causing user lack of
flexibility when configuring the kernel"
