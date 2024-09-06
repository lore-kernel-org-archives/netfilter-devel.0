Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6F11CBE99
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Sep 2024 11:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725623963; cv=none; b=bjY3NJ2OI03D8lDugwve9aumCcqCev0riiMaJSFDe+VRtmtwyUmyYZGj4U4Nw8V9So/aiImlJCNkVfAa6Oll4jQ2gRu+F3zztKRwBX7xRwPQMXjxy8hwQuNmRPH6kKUo0PZpJ2fVR1SZfBddSfztlQ5lo1kT+AF2lmFdyKZNVHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725623963; c=relaxed/simple;
	bh=0G0nIhs1bi5zMGUov/GDdwukKR4YYpCSt5fRVl7zUl8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rM3jgEbUpCNCPGnikGbNFckNrmpXDJq9+Bxn77t9aoBFlEmp92YYloJZzB7ZefHn+JhNHPC7llIXw7KXc9NLniKBmbWEk0vqQLlhpxcXWMdVBLS2/4alwqiG12JFadQyKEjaQ9ohEmuZjoE+8s4EH6BC6rb1qPADrhAQHbsvo+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SBsrkHWs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SBsrkHWs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725623959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0G0nIhs1bi5zMGUov/GDdwukKR4YYpCSt5fRVl7zUl8=;
	b=SBsrkHWsCOGQlxVhPyMHDXDGZ8kiTK+eG9zgYRAZXXz0bCx4IrEeFsvhKczPqYMgucRjZ2
	EhX8ElLzOdBVo81C/+uHUHtwe7I0gEiSZ2gxA1vLeopYlvKOtX2Wnpdv/hQWlNV1fl3bIu
	r2THp5EqKARhUDSNvqMFJURm1cr1E9k=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-450-P-Gh7xj3PrCEjBapwYHvyQ-1; Fri, 06 Sep 2024 07:59:18 -0400
X-MC-Unique: P-Gh7xj3PrCEjBapwYHvyQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-42c7b6358a6so15617655e9.1
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Sep 2024 04:59:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725623957; x=1726228757;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0G0nIhs1bi5zMGUov/GDdwukKR4YYpCSt5fRVl7zUl8=;
        b=cow9BUjdoOrSmNcWs+20hr8dpKECzMSVpkaXv6YzXzqSHRaNj7yoiGZ3FhCnszqQEb
         CmUdz5Ch0pJDimcR0rI17BKRDoTIr8S/xHWxcl2xyFdKEpl3o2RaoQs2NfLSY3mybj+K
         Wb+wbKDmkze9+7GMRt3hpxJpT8DQp8vFtA0pDaEk16qGAAfqyZ7xtnxyTtD2B+2R7M5X
         Mb1v3OZ6ZXBh1OuTZDpZJLkwG4TZ/kFLh7UL+OW7WmrCprAFjAIj3LfkWYl1L3WR39yW
         GJRG64MjMmCwbtDWIkhz9nOoXD7O5RoES4z4iWiVh4Q+yMMHM3xLgnbyJVyOrDCUHAbp
         rOYg==
X-Forwarded-Encrypted: i=1; AJvYcCVLYHYnIoLZCP1FfAq5oBWzsl3MUqnaWavKpGgGWru6sG7iTwzITYpTVpVmvgDT6XY6butaIAB7HPM+aupySb4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxH6HfUXctaQpP8BySN4Hue8sDUKfJvPq+rXLFg8Y5WD2TIVSbA
	hz/bMqYoXCWhILCZRdQ22MiWXraR39iQk29J7sj6sPl0llnczPAZP2gxseuFSQJkwpiuypwKK2+
	fHAigk26VYNDtNhtDUPqBfBIwkoLGuzqGKOIk+jTZ5MvSWZL/7XhKZDfWZjbeokz/HA==
X-Received: by 2002:a05:600c:3c88:b0:428:eb6:2e73 with SMTP id 5b1f17b1804b1-42c9f9e0d14mr18589845e9.29.1725623957341;
        Fri, 06 Sep 2024 04:59:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHYA3WJyXIhIIDEVufGNxXIOM6KJ1IZ7nsonG5drAh9teOtbcCOcgYplQPKS/qfufalrdR4OA==
X-Received: by 2002:a05:600c:3c88:b0:428:eb6:2e73 with SMTP id 5b1f17b1804b1-42c9f9e0d14mr18589465e9.29.1725623956763;
        Fri, 06 Sep 2024 04:59:16 -0700 (PDT)
Received: from debian (2a01cb058d23d6009996916de7ed7c62.ipv6.abo.wanadoo.fr. [2a01:cb05:8d23:d600:9996:916d:e7ed:7c62])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42ca05d351bsm18481815e9.30.2024.09.06.04.59.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 04:59:16 -0700 (PDT)
Date: Fri, 6 Sep 2024 13:59:14 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, dsahern@kernel.org,
	razor@blackwall.org, pablo@netfilter.org, kadlec@netfilter.org,
	marcelo.leitner@gmail.com, lucien.xin@gmail.com,
	bridge@lists.linux.dev, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-sctp@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [PATCH net-next 10/12] netfilter: nf_dup4: Unmask upper DSCP
 bits in nf_dup_ipv4_route()
Message-ID: <ZtruknlefVpreVRQ@debian>
References: <20240905165140.3105140-1-idosch@nvidia.com>
 <20240905165140.3105140-11-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240905165140.3105140-11-idosch@nvidia.com>

On Thu, Sep 05, 2024 at 07:51:38PM +0300, Ido Schimmel wrote:
> Unmask the upper DSCP bits when calling ip_route_output_key() so that in
> the future it could perform the FIB lookup according to the full DSCP
> value.

Reviewed-by: Guillaume Nault <gnault@redhat.com>

