Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C03E191F91
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2024 14:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724164978; cv=none; b=J9youfRDOijeKeMXn8x7RtADlsVxe8ywki39BWWkU8n3LA3NPIZ3sdlGpDx6p0tbBECTzIv0qMGd/shfUyOoVCE6jWrbaD0BlvrVri15/x51yjiIM3khi2f6GKW2FHjAUvZshFV/P1lq+zY6pNRcVlCM2fOA62SbpBxcBC4Qm/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724164978; c=relaxed/simple;
	bh=ejArwdH/GCuKtYASKHBHy+oCqeyYmvzQZGmVaEqs9hM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jYh+DhW13BdA5oAwGynozc1hvFufZOXRxiVL+PPxYcA+vKifKR4kvC4QNDYBbX8jwHWDH9iyRWc6PknCTU9dJM3C87Zmiu8Pdne0Z01oZL9JGwBcKT87dOj4lGeQmkTw8gakQHYoQKXljiVz0ptgkbkxR3rQw+12N+x0o2HpZ2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CoJFfyIp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CoJFfyIp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724164975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ydhevR7sNCZW4QWQke0ngPB+mitsjK/8az2rf5wXLK8=;
	b=CoJFfyIpThwHAjM6UEjN7JqNMQaaD07KEmTel9jXYF8wf1QV13II3ASP0j383NAFhvME0N
	eOm64SafvPgWjzwwugnWjS9psZJTacISfO8d+vbYTmSlNftuHueqJQs4bGA8x7ZsM/u4Xf
	HoVyPURu1ui1rHzJEffr7yjNjmrgkwE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-494-AIUxkDj-Of2Ib14pxDaVdg-1; Tue, 20 Aug 2024 10:42:53 -0400
X-MC-Unique: AIUxkDj-Of2Ib14pxDaVdg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-42808685ef0so49042335e9.2
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2024 07:42:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724164971; x=1724769771;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ydhevR7sNCZW4QWQke0ngPB+mitsjK/8az2rf5wXLK8=;
        b=oshtkfNRb+WadjiKS16gm/bpzPDSajgYDin8okjeOFBhPaRB49IOhlwSu2t7nTWGvP
         tckgP+19NAwFOK0cutth2NQef2S0s4dAqeAqZq0GJslRVb7k8YMOWjjYlCWy8hWKXTvU
         4Tbvso04dceo4ODgVugc/ev6G0fBncng1rAxjKqtyaMqQbCo71yhJvPAtq0LRwoOSsz/
         BiXTVQDkaltR/4nAXn+kE8jErdh+XghwEWtvYBWWmi9xi8S4Tc2Xc2McS5x1OStHshp6
         HlEvayF4hNDYCWKQDRyqgD2PmjEYmGoEfapv6MT8Ch10GIIBdmVkZZWZoQ8JgsLhw486
         XSYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTp67LOkS6GZtPG6yXJuB9UUWWbmXmwOb2DQG3QxldtXar2zS1D1ydR+iFep4aWIyCunikyn8O7w6MiL8zWKH18jrbUetWV7aZW7EdI8ew
X-Gm-Message-State: AOJu0YxQiFKxSzKaEqzp7uMNLtjAdULN3VQ9Xr25Hr6euGOTnZQIlIAP
	3lJJ4EwRQd3KpKH9jwSTwOQbO/7l1mj0OZlTRYLQ/5o4X/XlDh3gsMAT4jwrIpOYUdULgmvUFok
	L9GV7b/LZ7s0DYzNevLU15QGZwdXpEYnQ02mE28ffpBvueKKOYAFG7Y27YM/pHYEsCg==
X-Received: by 2002:a05:600c:4e91:b0:428:150e:4f13 with SMTP id 5b1f17b1804b1-429ed7e232emr96770345e9.33.1724164971641;
        Tue, 20 Aug 2024 07:42:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFHVeQ6jHcAhxfzkL4buSeHfHsZ3iDOB6Od9pARovqx5Xe2BHKWBj47sEnzPcyJ2IMCTsGtsA==
X-Received: by 2002:a05:600c:4e91:b0:428:150e:4f13 with SMTP id 5b1f17b1804b1-429ed7e232emr96769885e9.33.1724164970597;
        Tue, 20 Aug 2024 07:42:50 -0700 (PDT)
Received: from debian (2a01cb058d23d6005b76a425e899d6bf.ipv6.abo.wanadoo.fr. [2a01:cb05:8d23:d600:5b76:a425:e899:d6bf])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429ded71ee3sm196333585e9.29.2024.08.20.07.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2024 07:42:50 -0700 (PDT)
Date: Tue, 20 Aug 2024 16:42:48 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, dsahern@kernel.org, pablo@netfilter.org,
	kadlec@netfilter.org, fw@strlen.de
Subject: Re: [PATCH net-next v2 3/3] ipv4: Centralize TOS matching
Message-ID: <ZsSraEC0ZSGjK/Qt@debian>
References: <20240814125224.972815-1-idosch@nvidia.com>
 <20240814125224.972815-4-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240814125224.972815-4-idosch@nvidia.com>

On Wed, Aug 14, 2024 at 03:52:24PM +0300, Ido Schimmel wrote:
> The TOS field in the IPv4 flow information structure ('flowi4_tos') is
> matched by the kernel against the TOS selector in IPv4 rules and routes.
> The field is initialized differently by different call sites. Some treat
> it as DSCP (RFC 2474) and initialize all six DSCP bits, some treat it as
> RFC 1349 TOS and initialize it using RT_TOS() and some treat it as RFC
> 791 TOS and initialize it using IPTOS_RT_MASK.
> 
> What is common to all these call sites is that they all initialize the
> lower three DSCP bits, which fits the TOS definition in the initial IPv4
> specification (RFC 791).
> 
> Therefore, the kernel only allows configuring IPv4 FIB rules that match
> on the lower three DSCP bits which are always guaranteed to be
> initialized by all call sites:
> 
>  # ip -4 rule add tos 0x1c table 100
>  # ip -4 rule add tos 0x3c table 100
>  Error: Invalid tos.
> 
> While this works, it is unlikely to be very useful. RFC 791 that
> initially defined the TOS and IP precedence fields was updated by RFC
> 2474 over twenty five years ago where these fields were replaced by a
> single six bits DSCP field.
> 
> Extending FIB rules to match on DSCP can be done by adding a new DSCP
> selector while maintaining the existing semantics of the TOS selector
> for applications that rely on that.
> 
> A prerequisite for allowing FIB rules to match on DSCP is to adjust all
> the call sites to initialize the high order DSCP bits and remove their
> masking along the path to the core where the field is matched on.
> 
> However, making this change alone will result in a behavior change. For
> example, a forwarded IPv4 packet with a DS field of 0xfc will no longer
> match a FIB rule that was configured with 'tos 0x1c'.
> 
> This behavior change can be avoided by masking the upper three DSCP bits
> in 'flowi4_tos' before comparing it against the TOS selectors in FIB
> rules and routes.
> 
> Implement the above by adding a new function that checks whether a given
> DSCP value matches the one specified in the IPv4 flow information
> structure and invoke it from the three places that currently match on
> 'flowi4_tos'.

A bit late for the review, but anyway...

Reviewed-by: Guillaume Nault <gnault@redhat.com>

Thanks Ido!

