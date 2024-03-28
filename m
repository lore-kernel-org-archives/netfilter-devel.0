Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB88313AD33
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Mar 2024 21:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711661480; cv=none; b=TjgvldZa3zX/ymKRL0HsarDn+EOktff6ExCaq7M1lZxmUopHI0KE2ptr1+QHT3f7TyhhdWFapTfnc8QUCgtKJlHuvhsXRHelFPqmoqoMCqile9bG7YDb7QA7Wf8t/t13PUvT1hHzMx/5bQOAJjaK0RouxuXaZ4lG8lUuCvIry1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711661480; c=relaxed/simple;
	bh=UaszDaGP5veDsM5R7cFMxC2OFMFNbxNTS5tsT4bTBFk=;
	h=From:Date:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=a+MPiuWidjXSzBKohcEnXlWn77U/0DlZxXeK58uoCGqC9KcAUAN613IBwKhgTQ4OB8+b+3sXYhUzpbw4KelqMpFIiExEVPWMbosQ/uZMOsdvOl/2GxBcYEaEn1DPB8H1wnoG8RdvzbIlAWMZQ3ZSejpACmqWkisPg0OOFgDbHG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YDcYMCLK; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YDcYMCLK"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1e0b889901bso13295865ad.1
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Mar 2024 14:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711661477; x=1712266277; darn=vger.kernel.org;
        h=content-disposition:mime-version:mail-followup-to:reply-to
         :message-id:subject:cc:to:date:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UaszDaGP5veDsM5R7cFMxC2OFMFNbxNTS5tsT4bTBFk=;
        b=YDcYMCLKCEtVLWmuWI6tpD5vKI5fvINQ3sbrQ8xlRd17fxrdSOoSVOLKM82LbUs/OO
         yhfC3y+zymNQyLePwfPDWATZDzGzXwHo5lTOvFcnjCrY7YPg9+XZk+ZIXaEHHoIef+tA
         hGoz5ZZ67ngWTr/vefeZRCb1z8Mai2KDSZC3Io9OAyWGK+jxR19ZDGnVzX2HtXyFiITF
         3YnnqnS1Rns7R2wO7QrZlZSLBeshrCzB2tyYLW63Nu5ezoLVVBFfivxC3Gow5z3JSI3Q
         6uGnuHRmuYZhjqtXRjYdnRyQatVJeBsC2qDp1f9GVgQ1geOuAoetCNObRZvsfmU6N9Wp
         siZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711661477; x=1712266277;
        h=content-disposition:mime-version:mail-followup-to:reply-to
         :message-id:subject:cc:to:date:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UaszDaGP5veDsM5R7cFMxC2OFMFNbxNTS5tsT4bTBFk=;
        b=Fpt5sRjpUa5VqEI8SgoHnXvgY/6wTA2ntJ3RiLjxKvm1dujw9++2+xbNRRMc7mQH0R
         XRqelKI3wLATa2EwYFfdM1LLp3HmfKTbzlDdlTBZWapdhBImm/rBvHc9h/7KPkzs+iKF
         m0n8YRmLWDcdMxazVl3KdAhybkbVDUKo2yE+HESUIyDF7OdOu9pPivCpujNT0ixii2B/
         PeIO2HqFhc1JPdXcAGywTkVTquFQ0oBpSejaPM53lvO9q5R9RxfpekK4dShL5Akm4woI
         stAUuszLEETI7a0CConxO8auwVbbTLm6bmtbyZgOvOFdGr7JOo2ZwV1t07uXowCj2BBb
         Jt0g==
X-Gm-Message-State: AOJu0Yyg7SMennR90D2DtH2rBloKIZxs4TV8J8dwgLiyfOCcXm75P+Bo
	D9+kf/PnWDdO0pUbTiiFSIGe1iKd5bLQXtYy26mN5pIu/Ps+FzHJbIML8LiP
X-Google-Smtp-Source: AGHT+IEhi1+9qlSf33R2upSmnlty/KxHVGStM9j2/RkzP4G7ishjszNOlrYxocerEViMxNwAywTsNA==
X-Received: by 2002:a17:903:2ac6:b0:1e2:307a:a585 with SMTP id lw6-20020a1709032ac600b001e2307aa585mr10046plb.47.1711661477173;
        Thu, 28 Mar 2024 14:31:17 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id d12-20020a170902c18c00b001dee0e175c1sm2106678pld.118.2024.03.28.14.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 14:31:16 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Fri, 29 Mar 2024 08:31:13 +1100
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: (re-send): Convert libnetfilter_queue to not need libnfnetlink]
Message-ID: <ZgXhoUdAqAHvXUj7@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Pablo,

On Mon, Sep 11, 2023 at 09:51:07AM +0200, Pablo Neira Ayuso wrote:
> On Mon, Sep 11, 2023 at 03:54:25PM +1000, Duncan Roe wrote:
[SNIP]
> > libnetfilter_queue effectively supports 2 ABIs, the older being based on
> > libnfnetlink and the newer on libmnl.
>
> Yes, there are two APIs, same thing occurs in other existing
> libnetfilter_* libraries, each of these APIs are based on libnfnetlink
> and libmnl respectively.
>
[SNIP]
>
> libnfnetlink will go away sooner or later. We are steadily replacing
> all client of this library for netfilter.org projects. Telling that
> this is not deprecated without providing a compatible "old API" for
> libmnl adds more confusion to this subject.
>
> If you want to explore providing a patch that makes the
> libnfnetlink-based API work over libmnl, then go for it.

OK I went for it. But I posted the resultant patchset as a reply to an
earlier email.

The Patchwork series is
https://patchwork.ozlabs.org/project/netfilter-devel/list/?series=399143
("Convert nfq_open() to use libmnl").

The series is "code only" - I kept back the documentation changes for
spearate review. These documentation changes present the "old API" as
merely an alternative to the mnl API: both use libmnl.

Do you think you might find time to look at it before too long? I know you
are very busy but I would appreciate some feedback.

Cheers ... Duncan.
