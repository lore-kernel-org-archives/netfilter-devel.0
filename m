Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D825E1C9ED9
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Sep 2024 11:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725621670; cv=none; b=M/Q+usJYHowATZBXTDfeAgXGoVrftkddlXZOTZDG3rA5F7u+tYyzbXk+yEPqI1pdZEJ/GKSHXH/PL8/Rt+STR91xtnDqQObh+klBJk22iIf//EJMUHRX6ZSSJ7ZdJ+/CjsiwLeTZlQzuSIbGKrzdQ89ozZb0eB3HNy7L66s1nV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725621670; c=relaxed/simple;
	bh=XM5romIm4KxJKc2Cm0Xo4inyO+ieNM4r8IJYwcGNYzU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N+JH1QQDQ/QMtysbNLCc0BHJBC1c1jxUBtYGqofbrpoUiFmXcdifRxdUlQrkQkCLBvQQmVzV+8I/NkVnmgwkp7JJmCJ2wDlj52PPaOHkhPF2QJ4I206912QNS8mFqTJ+Q0Rr61eZFhPRW6z/yuvty1DmjumUpMn95VcrCR2SQAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CYcw5Jv8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CYcw5Jv8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725621667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XM5romIm4KxJKc2Cm0Xo4inyO+ieNM4r8IJYwcGNYzU=;
	b=CYcw5Jv8BDvU98HiCNiY7to0v1mR5i3UC69SUWW/Q5ehBuvWWpsQSyr8Xj3PBn0bTWVNyi
	iANQgd012t4kzXxd0XKiR3UwYMLTCGJXG/KgW9KUGiC7JXNiIwANvskcLpW74XvFuCIgT5
	almXTJz9J4BXNGYImIy39A30buJ5KJw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515--ibDsUddPRaGxhN4eismQA-1; Fri, 06 Sep 2024 07:21:06 -0400
X-MC-Unique: -ibDsUddPRaGxhN4eismQA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-42c827c4d3aso15264885e9.2
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Sep 2024 04:21:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725621666; x=1726226466;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XM5romIm4KxJKc2Cm0Xo4inyO+ieNM4r8IJYwcGNYzU=;
        b=J40pKe63t56ZZm27z7wYhleS/ovVjqUf4yFb40rCRM+m2swk66+qpSOVNkg1TyjlDA
         N2fFoBaRPOHXsfZnmq0uc364WYsREo1KSZbGqJtAFriVhFoOc43oxkGpENQyKY3Vy1tK
         22mj4vx2TTELiUdLY9T3vKOSPXzO9UYg0Jpb7NaU/bO9mhH2zXqLrjKtKSuyj6JKBIwz
         4FI0svekImLF5NkcwpWSEcgrbgCti/aChBAWthI5N9qD/fPNSZQPYHpDEDRl47PJNZ9D
         SokFZShnuja4R7WfbulquG3GPaqHrEbPh99tV8omVI3qZ9PSv5ai/+7HCtvmU/dpbt7r
         2OMw==
X-Forwarded-Encrypted: i=1; AJvYcCXaakxNz5xdMaL4o58jfbp/+cxBs1GJszbEHUTigA7JDH9ex1Ns0VKVlKQ01kpcWkE/5qSyFcrzzGp4LJupW5s=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywbn0MnX8CO3Ir4RbKUBTEffqArWngQhfSu/SDROnbdTSPd3dgu
	uy35TMs4AtfBTu15n9rsrsEJhSDf2G6D+c7w8LEMEinnxbKEt89KBSusdE0Ji4X4w3QtJiB7zLy
	4naIHqIqDdoqm98K53wxAEo2xtrlgXmDXyVjJYOKbUVNM6HlR7Vfuo3kf5ejgwQTK4w==
X-Received: by 2002:a05:600c:5103:b0:428:2e9:65a9 with SMTP id 5b1f17b1804b1-42c9f9d65cbmr16318255e9.28.1725621665633;
        Fri, 06 Sep 2024 04:21:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE93E9q/W6NuTuOA8k3tsvdqWAFnV+g/TGFfrApNmc8vSoM76gleN9ntAIhvsJ+eJLqfOgoMQ==
X-Received: by 2002:a05:600c:5103:b0:428:2e9:65a9 with SMTP id 5b1f17b1804b1-42c9f9d65cbmr16317795e9.28.1725621664988;
        Fri, 06 Sep 2024 04:21:04 -0700 (PDT)
Received: from debian (2a01cb058d23d6009996916de7ed7c62.ipv6.abo.wanadoo.fr. [2a01:cb05:8d23:d600:9996:916d:e7ed:7c62])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42ca0606e9dsm17561175e9.45.2024.09.06.04.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 04:21:04 -0700 (PDT)
Date: Fri, 6 Sep 2024 13:21:02 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, dsahern@kernel.org,
	razor@blackwall.org, pablo@netfilter.org, kadlec@netfilter.org,
	marcelo.leitner@gmail.com, lucien.xin@gmail.com,
	bridge@lists.linux.dev, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-sctp@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [PATCH net-next 03/12] bpf: lwtunnel: Unmask upper DSCP bits in
 bpf_lwt_xmit_reroute()
Message-ID: <ZtrlnguvBN+BJpFc@debian>
References: <20240905165140.3105140-1-idosch@nvidia.com>
 <20240905165140.3105140-4-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240905165140.3105140-4-idosch@nvidia.com>

On Thu, Sep 05, 2024 at 07:51:31PM +0300, Ido Schimmel wrote:
> Unmask the upper DSCP bits when calling ip_route_output_key() so that in
> the future it could perform the FIB lookup according to the full DSCP
> value.

Reviewed-by: Guillaume Nault <gnault@redhat.com>

