Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF11E20E30A
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2024 23:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729209594; cv=none; b=ClpP2bgiQH+FsgEuAZHFr3uFS3Krn5jFTV32FA1m+aLssr76w5OUTw4wWa3d9Rly+72JoezTEdJVVjtTKoWRsgXHgqOJjY04deQlyZI3LcUBeVHhVZ7sphffFo3e4JVbh6BqNn9JI0Ty7LWAXPHmvq78kU1INvqDg6MLu71TkCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729209594; c=relaxed/simple;
	bh=m/wIOYYIooFVhtowEL3Lr7AVFSqh4T7JhwF8ElCZplM=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kBImDvdVqMPqIPb9CqYUuJp1E7DxFx9rALImlD7eFdO09UA2HgBicn7UU2YaRGxMNcQoRCgi+ce29Ikje1utDR1gZE44uxByqyqGjT/CjVKJN24HGvGGD8Jj2/FDLH6VLithotqiZ/wnBroofxbDu97P6Y9DUiZhXsW/5BjD++8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kSq8tF2a; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kSq8tF2a"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2e3fca72a41so697255a91.1
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2024 16:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729209592; x=1729814392; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m/wIOYYIooFVhtowEL3Lr7AVFSqh4T7JhwF8ElCZplM=;
        b=kSq8tF2a3JvbN3xasJCWhWnkO15SMo+cryIbOqMibW9h2+TVajwf//kY6etPxYwEpV
         LqvQBoOXb8zv2r3yDCfqd3idVtgUZzvtkEtX5crIMa+Cb67q5gk1WKhdXqGp2i5gLC71
         6LDXrFbrLj6uQ/cTYEhf9PwkNLtgYn7HjlsAVQQXWmXa8sqEeB0EBdEU8E3GjeWWIcHj
         5uq5KS0luNgHWNvf5xMP4EPp9ch9PP7S/uXgLbAxJZnCeE9xRf9qOOitk/QS9Fz9Pp57
         zRcSBGn8TOtZ6OQYeGI9XXzlVs/M4K2luPRca30AR1KiUY+0L4p7TNzHpEHP7KLkCMGG
         20Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729209592; x=1729814392;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m/wIOYYIooFVhtowEL3Lr7AVFSqh4T7JhwF8ElCZplM=;
        b=YCcBa9t9iSSLlG68xg4epnwAt8r1G9fqKgnZhOF8RMdbyb79U7ZiBS9g3SdtXTIV8x
         8WDc2Y8xTi6W4Nz7fMjZ0oHLZRu1N2jz+ZJZsmLEimRS9sUZSuu4cYEPOpCZ/yXvrNTB
         MnaLIFqKPW25M6Mr27+5QhZ7ZP4vVxkaeL3VdVVhnUhwEhhXR7fH3Os76hDFxj46bdDw
         w9MhGn25zf7GPAwLSfdQhN/T0D1BHFj0/4ydtHEP6VEfOz5CjAN17TmmcQqRd4NcQaxU
         P1LxXm49Czci7kPlnzUbBmdc7yq4Nyt3LrCjpw5baK44XHTDsgHgdCgHxTf2YVhQSR1W
         NySg==
X-Gm-Message-State: AOJu0YzuEUt8Yt1er49sOJVuaPjfqKo+O9zrDaAG/hkwZnV2nXiyc9qO
	//UihVMSIoOaAx5Dc8noyfxyoAlFkJ02pp7LUz3WZ8iMblZevB1OxeCFxw==
X-Google-Smtp-Source: AGHT+IGWkthFz/bJPTrVtCx9VJzRpCPUB1fW9fYrYiSLO5QwtIjHSYPrcFzU3IyoBkzqk0wi1ASdlA==
X-Received: by 2002:a17:90b:2287:b0:2e2:d74f:65b5 with SMTP id 98e67ed59e1d1-2e561634a12mr862137a91.16.1729209592124;
        Thu, 17 Oct 2024 16:59:52 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e5610af851sm348364a91.1.2024.10.17.16.59.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2024 16:59:51 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Fri, 18 Oct 2024 10:59:47 +1100
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libmnl v2] build: do not build documentation automatically
Message-ID: <ZxGk8yIfteaFRcuA@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20241012171521.33453-1-pablo@netfilter.org>
 <ZwzOgRoMzOiNfgn0@slk15.local.net>
 <ZwzRn6EQpRJWxYA-@calendula>
 <n4r27125-61q3-r7p2-ns82-77334r0oo3s3@vanv.qr>
 <Zwz-e5ef9uyTG6Yv@calendula>
 <Zw8UOCbpwSOupUcf@slk15.local.net>
 <Zw9qbppRAtX4VbIv@calendula>
 <Zw9qkveNN6DkpvHM@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zw9qkveNN6DkpvHM@calendula>

Hi Pablo,

On Wed, Oct 16, 2024 at 09:26:10AM +0200, Pablo Neira Ayuso wrote:
> ... And it seems distros don't include already built doxygen
> documentation in their packages.
>
With the libmnl man pages the way they are, I can't say I blame them ;)

However it *is* normal userland practice to offer a set of man pages with a
library.

libnetfilter_log and libnetfilter_queue both have acceptable man pages. I'm
happy to cut over libmnl to use build_man.sh much as I did for
libnetfilter_log. Default would then be: run doxygen to produce man pages.

I could make that my next netfilter project.

What do you think?

Cheers ... Duncan.
