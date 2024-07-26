Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4772117B4EC
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Jul 2024 13:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721999718; cv=none; b=fPybnZxdoJcG79k5uUvibSXJv+l6F5nqqtYzkTRlulHkgvovIdneCV4S+XOVjQFIv45TTBKfk3+r77VFzOXpsEFvzk7Vkki0Mq9Rzq4sqPpCLVJZWLdGgq8xkqvzHM6HlduE9w7sdfbIoQzld459KcnFWbHv+/YOcdFPTzB4hXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721999718; c=relaxed/simple;
	bh=LF0PKlCsDKYpv+HQFt2fCkqg6jtEYdv7eFCfliVOwPo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=is5fiFC+lZcofRLQAGVwErOM54eH8kOY7s14CGtk62EeKyl4kjFAr27BQoGgpSS6eUTSa7qqC3memOI9ytmY/oIL/Dc3wEal2mg/D4e/XZelOA3YcRmvbtvY7zCO77AQvlnTr4qZBC2ZhFMRS0NyQ5vOOedTiQnxUWCXvNPgQWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UlR1xAhw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UlR1xAhw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721999716;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2EhpoWb0AurDY6o27/mIIhlnMNFRUh7l8fb/1FOa9EY=;
	b=UlR1xAhw4xyO7jfjwQ6RObXG4p3iWgWopYqAuCf6wYmegEyF2uJ0LaJjeSGpcCRu6XaHHw
	JzFtdMfV8fCxQrjTDYVPvd6gTXR+cXyp2rd1eVhLgPc1xxCwZ041dCAKRDzopcoclGt1oR
	KxVC57Ir5PVNODtpjom/lWFuZXwqmEM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-WbBTLNJZOFq2DSQFmWdXrQ-1; Fri, 26 Jul 2024 09:15:14 -0400
X-MC-Unique: WbBTLNJZOFq2DSQFmWdXrQ-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3686d709f6dso1343890f8f.0
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Jul 2024 06:15:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721999713; x=1722604513;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2EhpoWb0AurDY6o27/mIIhlnMNFRUh7l8fb/1FOa9EY=;
        b=Yb+oAjTnp+bZTc54LDaj7o82ysqqrF+FM5XlD3zOFfNcfjv+/5MaH2DLVXPJMg8PCz
         K/ellWSWIm4qWqtXv+V3YoEsqkXuGB8IFd8q79a1pyuvRINCNpgDrP4c3kDzj/5FAMgG
         Ozej8UApi3jE1nzN7gGZrXei7F5dsu6FsGZbMRNpGmOLT+FUSTj8cj8uFRXDXGL80sGb
         rZO8y0V6NUSEj7qRd/p+QMqEk+SHxPrqGNM6PCYPGJmUY62BXpjaJ9QSb4zq4gsL+auJ
         2qFhwZVAT08eSjI8dJ0LlwOqe4Bw731FIFPw595mD+zNjoJiXRIrgvqtcSqBl9tsruxU
         /UXA==
X-Forwarded-Encrypted: i=1; AJvYcCXPISsSPCZNgT4Nvs9tC1xmLoNrnSP5T/3Rqmhqq5JsE+v7+qH6lYItL1fYwehVFQStuYEVjfvjJgbWKKCWqJmKa7ZwIhVpKX6+MAiANiTX
X-Gm-Message-State: AOJu0Yyf5UIKFUGrhWGKURaHVc4PzF4wm1CCFBcv0c2zSJ9aycNdDQz/
	ImJxPhq3JnhYgRkkLtoQUCSsFrrEEeF7TAYqengRqM+Tjd0Ad/6cAcnf4k+6jfAheB2XR92UQyT
	onFn7Cr38lbqQ9YKJnpjqB8t61WGao2yotvrp8JvOmHt6le8Ftezh2VerfQ3SAAT0bQ==
X-Received: by 2002:adf:e792:0:b0:367:96b5:784e with SMTP id ffacd0b85a97d-36b31a795fbmr3817596f8f.50.1721999713445;
        Fri, 26 Jul 2024 06:15:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGAIVE6aRZFryUDPhlNqaJ4GXjinhwOOFRqyjWsrTiYldwpHCv9/AZ2LGJXXQtrl5tKP35uLg==
X-Received: by 2002:adf:e792:0:b0:367:96b5:784e with SMTP id ffacd0b85a97d-36b31a795fbmr3817568f8f.50.1721999712852;
        Fri, 26 Jul 2024 06:15:12 -0700 (PDT)
Received: from debian ([2001:4649:f075:0:a45e:6b9:73fc:f9aa])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-427f93594b6sm121233975e9.5.2024.07.26.06.15.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jul 2024 06:15:12 -0700 (PDT)
Date: Fri, 26 Jul 2024 15:15:09 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, dsahern@kernel.org, pablo@netfilter.org,
	kadlec@netfilter.org, fw@strlen.de
Subject: Re: [RFC PATCH net-next 2/3] netfilter: nft_fib: Mask upper DSCP
 bits before FIB lookup
Message-ID: <ZqOhXSYp6yHlcNmy@debian>
References: <20240725131729.1729103-1-idosch@nvidia.com>
 <20240725131729.1729103-3-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240725131729.1729103-3-idosch@nvidia.com>

On Thu, Jul 25, 2024 at 04:17:28PM +0300, Ido Schimmel wrote:
> As part of its functionality, the nftables FIB expression module
> performs a FIB lookup, but unlike other users of the FIB lookup API, it
> does so without masking the upper DSCP bits. In particular, this differs
> from the equivalent iptables match ("rpfilter") that does mask the upper
> DSCP bits before the FIB lookup.
> 
> Align the module to other users of the FIB lookup API and mask the upper
> DSCP bits using IPTOS_RT_MASK before the lookup.

If Florian and Pablo are okay with this change and the long term plan
to allow full DSCP match, then I'm all for it.

Reviewed-by: Guillaume Nault <gnault@redhat.com>

