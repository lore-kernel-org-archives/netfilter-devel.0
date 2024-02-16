Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889FC125C1
	for <netfilter-devel@vger.kernel.org>; Fri, 16 Feb 2024 01:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708047702; cv=none; b=XvK6dI3md67nF7d0PlH8UdWXyeH9+TGupC82S2gwtQyPu/gFfW9wokomIn7XYs4n0jsaPWat2a7BFqx0pVkZwqTzkl1Eg5rgkmX10RjUyfPc4/NxJGMsRw1MJdKcodYbme4s8Vpyyl0kocWzNiGYC4OBKii2I6uVhOc+moHHxKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708047702; c=relaxed/simple;
	bh=D3cj0EChgj9OZf8mGLg0v7Xb24JtZc+4hGeZWPv2fmA=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VnHIKxB0ZqLCgR82FZP2j+aBxRdljbmYaakWKK3f8F45e/KHsI82WWdjtl5advvaPKxPvDcHXuRkvsvlIhb8VmjO04pD7XYr5W5mPdco1lIPMEa24k+dX2MYSOB0qvye6i/ltlgdf1lQ8JPXsPvJxMhivqRBfiKs51N/j0Uc8ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CJ7vhix4; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CJ7vhix4"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-5dbcfa0eb5dso1418919a12.3
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Feb 2024 17:41:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708047700; x=1708652500; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=my91kn751UWNWnwDukeAxrBgyCOwJRSWbR3JQ8gB+UY=;
        b=CJ7vhix42FqYsfmUF7ommpIGeM3CDT0RGDHt0o8b7QcrYIIjlzMKk4hEdASehcVRGI
         0Udqivututjye0FT1AfTIHEUjiajoYx6rnQNPF35Ph7k047JdVyfvwPvup8gfzS8r74t
         cJb/jsHUzss2Er4AZMlRGOsoAilMDH54H+XvQNG0UlQe8YzK70pMIs/YvmCf0kOYBKqS
         KHKYOzmqVKn4EfhRVWJfRGe2D60uGttlqgZOK7cfMs3PkXZmOnspNWTzKHFvx7IUhjN8
         qZxnE+hsO0S5dxB2/TjxiV6sIj2so/4QjZaI2k7xuGXpVY+pkjeCLafdLzL7DPQjCABF
         YmzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708047700; x=1708652500;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=my91kn751UWNWnwDukeAxrBgyCOwJRSWbR3JQ8gB+UY=;
        b=HogNIgS/NVr+ZeR+I2Codsj1jyLSAOo1Dhn8rBAdz6LaCoxmxJGg2hZ214Q8s4Ahe4
         vADkeePETdpgTNkjgm3Ls6DRBmblSbbwDb3FEEl6AL3VouoPZ47Rda/fP7X7YE+BLfOR
         AP0oLtyvGwsIrho/VP6taQ8qV1Z1sSGHdANpEAHm1hYRAFdp0oB9UXOX4W+8GkjL94AB
         lzH04YvwgzwPm+OeUABUcQGsQBuOr+iKTF1pOL/zc6HNIHgFl+aMjkeBxUINFu4VX/SI
         8YC/QiKH46N720wNH3iY6weQlmbt7sc/MXCiTQyEkyeaa67B+Lx0YSfI0jV1qrpPUv9T
         WDyQ==
X-Gm-Message-State: AOJu0Yw9OcxLtUwsf5JITwyALJ+9SX4mkOObrsQSUAmrsz4sU173IWr/
	SXOsuFTUvquhtQs+M2pwrMljJNQkTSl4HJTxkIp2ujBoF31ug4pxxhMuOp5N
X-Google-Smtp-Source: AGHT+IEvc94WoMpAH/A87ra70LIjAJW54Fb6pgiqEd7o91jx/Kj2Zj2/Ggghp7zZSAyK77hDxSM65g==
X-Received: by 2002:a05:6a21:1583:b0:19e:cae4:7c07 with SMTP id nr3-20020a056a21158300b0019ecae47c07mr4406610pzb.45.1708047699739;
        Thu, 15 Feb 2024 17:41:39 -0800 (PST)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id l23-20020a17090a3f1700b00298f2ad430csm2333081pjc.0.2024.02.15.17.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Feb 2024 17:41:39 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Fri, 16 Feb 2024 12:41:35 +1100
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue 1/1] Convert libnetfilter_queue to use
 entirely libmnl functions
Message-ID: <Zc69T21ekMhEbjZ1@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20240213210706.4867-1-duncan_roe@optusnet.com.au>
 <20240213210706.4867-2-duncan_roe@optusnet.com.au>
 <ZcyaQvJ1SvnYgakf@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZcyaQvJ1SvnYgakf@calendula>

Hi Pablo,

On Wed, Feb 14, 2024 at 11:47:30AM +0100, Pablo Neira Ayuso wrote:
> Hi Duncan,
[...]
> because this conversion to libmnl _cannot_ break existing userspace
> applications, that's the challenge.
>
Absolutely. utils/nfqnl_test.c builds and runs, are there any other examples I
could try?

Userspace applications *will* break if they either

1. Call libnfnetlink nfnl_* functions directly (other than nfnl_rcvbufsiz())

  OR

2. Call nfq_open_nfnl()

Is that acceptable?

Cheers ... Duncan.
