Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CAA15530C
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Aug 2024 08:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724835258; cv=none; b=kzQY//jEXMB8iVEwcxyopIspaXZDlOVqziNARwr0LwY1IAamssovYHYTSnc5FGdNNWUiyfzYrMTn381oJn/UaFPj05fb17UWcCAT9sAGZr8fC3OPDEPHXGdHahVztSwg1MAiDtZ/hB/5xGYcbleTHUh46PfQsoinuY4PRNPvvC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724835258; c=relaxed/simple;
	bh=ZJ/J7m6i+8KbtJqj1FMAwGA+Bmxy4Lpbs/RVJWh8Vgo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N+u00p1BiZpBHHjIxTYvFhruDv+WvWlxbvTIlQpTbvf6tLFY/s5x7/J8gltO5/TQb2VLIcUa/4kja/9XE2d7EiwYPwABBaOGItonMbS4plWGMKw/4Uj1M/LNaz5aXhpbAckI4YzUGBqW5VJR4D/bChnPx9RDUGXK692Egp3nzdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Vprztl8/; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Vprztl8/"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3718acbc87fso3549904f8f.3
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Aug 2024 01:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724835253; x=1725440053; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IQtjr3ZsIIcSu1rCSe254P3JWX2H8aBnGOcApocErl0=;
        b=Vprztl8/nigFe59LCJ7rkABx13cVc27gwIZbJlLh63FvHvV8i//HIEY200G1ygM1yW
         MivszpVAzJL2vbokuZBHsR2QVJE9G3TY+lthYV/KySHC6qmtTIZxS05W5nfQagO2N8ID
         /kAzGBrSyrUt0/zC0q7h1a6rS0pXcygLQA8KWvn8OiM5SakfWc6p1WgHR0b+b8VT1r2y
         qzZFBozJ83oimU+iGsVBPrRzJfEZgU6JF45oXLKWD9oFe0YJn/GZXkI7jGJLVWL02dwq
         wYeMErSLXqJc9bauqYok1fS4xQMCsHOadnz1dBcchnhow1qPU7jhnKHKiYc3q+cc+rC2
         WVtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724835253; x=1725440053;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IQtjr3ZsIIcSu1rCSe254P3JWX2H8aBnGOcApocErl0=;
        b=WD0p0e6w9pvThTiWncR1BE5OreeXVpohS/m3fK2BAiXFrPLKN6GgHqA44R0HIBjpnX
         e6NRermiEOmqhjCmcngyFG4kzQcEvY/i452g0cPu2RXa93E+5LwJI7/hqXklNn1iURK/
         tfATISbUu8Yw7BO74n7W7TufE/a0Bk1ImntSo0zr/iEjPUeZRtQaQcFM+qmxupf4h8qV
         44DmIUQAKBdVZJbHVx/ZeQoLHP5kILx174Ad/6kfThEfkUXQAWFbEKEnzGwmrwmrBY5m
         GlypXtwU+o7f0pGyEcbRK+Xr3ly0jkriyKafviZTIla50Z2GpM6FHPH4H/gb8qAqz00y
         p9pg==
X-Forwarded-Encrypted: i=1; AJvYcCWQzhl3ywg7vosL6n2wuLLnWRtgdLFg6/2ujp6+92bBgIIEE8NQGChzCt9aCpq9P///S0CdB1UFA+SNIh4g0+g=@vger.kernel.org
X-Gm-Message-State: AOJu0YwG/ySpXLfDimbACVO4QQZkCJZx9YnOxyQiCZIM0OTqg79Rm17z
	C+3/LfppmTa2OAE4tOBq7+80DEgwA/Uii/zVa/hIjVL9Vkd/zk4+KQQDEAEDJCA=
X-Google-Smtp-Source: AGHT+IGr3JPJmC+vbozl+aEANHfCdvcBvynQALLAOIYsAcPYx4SVws2LzUK1Yn9Ipf6EeFPGVzxiQQ==
X-Received: by 2002:a5d:47af:0:b0:368:3731:1613 with SMTP id ffacd0b85a97d-37311840ef8mr13595292f8f.13.1724835253222;
        Wed, 28 Aug 2024 01:54:13 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42ba63b11ecsm13978265e9.26.2024.08.28.01.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2024 01:54:12 -0700 (PDT)
Date: Wed, 28 Aug 2024 11:54:08 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, dsahern@kernel.org, ralf@linux-mips.org,
	jmaloy@redhat.com, ying.xue@windriver.com, netdev@vger.kernel.org,
	linux-hams@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next 1/6] net: prefer strscpy over strcpy
Message-ID: <d5525686-aefc-439e-8c27-d41a2ee2eb69@stanley.mountain>
References: <20240827113527.4019856-1-lihongbo22@huawei.com>
 <20240827113527.4019856-2-lihongbo22@huawei.com>
 <a60d4c8f-409e-4149-9eae-64bb3ea2e6bf@stanley.mountain>
 <7fd81130-b747-4f70-978c-7f029a9137f3@huawei.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fd81130-b747-4f70-978c-7f029a9137f3@huawei.com>

On Wed, Aug 28, 2024 at 03:43:30PM +0800, Hongbo Li wrote:
> 
> 
> On 2024/8/27 20:30, Dan Carpenter wrote:
> > On Tue, Aug 27, 2024 at 07:35:22PM +0800, Hongbo Li wrote:
> > > The deprecated helper strcpy() performs no bounds checking on the
> > > destination buffer. This could result in linear overflows beyond
> > > the end of the buffer, leading to all kinds of misbehaviors.
> > > The safe replacement is strscpy() [1].
> > > 
> > > Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strcpy [1]
> > > 
> > > Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> > > ---
> > >   net/core/dev.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > index 0d0b983a6c21..f5e0a0d801fd 100644
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -11121,7 +11121,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
> > >   	if (!dev->ethtool)
> > >   		goto free_all;
> > > -	strcpy(dev->name, name);
> > > +	strscpy(dev->name, name, sizeof(dev->name));
> > 
> > You can just do:
> > 
> > 	strscpy(dev->name, name);
> > 
> > I prefer this format because it ensures that dev->name is an array and not a
> > pointer.  Also shorter.
> ok, I'll remove the len.(Most of these are an array, not a pointer)

s/Most/all/.

If it were a pointer that would have been a bug and someone would have
complained already.  :P

regards,
dan carpenter

