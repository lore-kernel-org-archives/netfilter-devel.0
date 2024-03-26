Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F25513D89C
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Mar 2024 22:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711490809; cv=none; b=K0ePNO1OxHv0k7zBPErDFqarS4X/Ve+cKKeQD5vv16V7eHbKGRXD9OVlVriWtOHiP+PxTbEAnDF2zf1BymdM+r2JT3EQdwdSDKv+86WuzjF23tExtF2V04ZF0PLqa9b59ixEpvBN4YgRC0e1XCm3ozHDp/TE48GE0TWn5gYGFZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711490809; c=relaxed/simple;
	bh=UaszDaGP5veDsM5R7cFMxC2OFMFNbxNTS5tsT4bTBFk=;
	h=From:Date:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=JjnyLs/Ha24H7tlupK4xYddMk1FN37+wfsmZuUx/nd8RgQBrUrLCVt8xmeVmcWMVh2/Ub+QB6HngpDzA6UIGPhfgvvivnvvgCqA+flcUuyJJKbRVzV9V6KDGNkBJF321PQaZ9uBhCI7S7aZTZahQ7SpIa7G+2qUgV5gt829En4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VaVwYLBN; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VaVwYLBN"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-29ddfada0d0so3361799a91.3
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Mar 2024 15:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711490807; x=1712095607; darn=vger.kernel.org;
        h=content-disposition:mime-version:mail-followup-to:reply-to
         :message-id:subject:cc:to:date:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UaszDaGP5veDsM5R7cFMxC2OFMFNbxNTS5tsT4bTBFk=;
        b=VaVwYLBNogx/Nub5EshKPrQMF5D1sMLM0v9g0H99pAQFSGsnFcNc/kxwoK9RCxMY4B
         1oszAsEH72EvqrrViT19vln4nO/ww+RsRVlogNgfUjcUQdbXUIsTx5lSX/V3Fxr7tSUq
         NXxiYOMQolRJCc2D8kDKMIyzR2KU3rmz4PgFdZiMrKnLIjz09kEDd5zoIubx9UaRVnqU
         AqtLhmmWaVBj26o6icaNEWtfoGUU34xj7/NLILkoeFPbxwmxXTwGtiZ8zGC2qx85MAGJ
         sf47qWRbP/8TVquHx2j82f2qP6/68UX5SCNpWj9u+p8F89B1XStZOz62u0vowB+UTlox
         jXOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711490807; x=1712095607;
        h=content-disposition:mime-version:mail-followup-to:reply-to
         :message-id:subject:cc:to:date:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UaszDaGP5veDsM5R7cFMxC2OFMFNbxNTS5tsT4bTBFk=;
        b=iW8mZ7pAmWuCXG/HXwfrzI2OT4XPstfkAevMf1hmhNjxE3ht9JrpWb+PD7p4GtaUqg
         Aqg11TvTPnzpIqZm2q8fceeBxCUt/wVaVEdFEtS/Flbkpl47VvUhYIS//4LJgMVkaZfs
         K2MWLbMeePC3/X3zHSo0MpV/Q6r+uGCh5C3ILR1gf1gNn+uXwI33q0MyvxIHnwKmwIjG
         vYWERa0AlKQmxiJmT0RKktDvSTLvjf6YPuDl+DGoDyoQnW1WtTD8SuuAOJbJBg5aC5RK
         Rq75NXmXwFBjAiPMzf0X3vxIm1RzchK0uGn7HCllfjbXYMoe5poznrMW6qdyOrU40REO
         /Jsg==
X-Gm-Message-State: AOJu0YyQdxxjlnWfvSe+Us8Tv3R75zPyLKODl9KjRuqHL3+9ps6tn1k5
	NomjwJ7XR4TBtk9WPYrI5gu1/W6z3DIzigvGmgfGPTCiNpE9n0YDDitjj0yt
X-Google-Smtp-Source: AGHT+IEtUj+SNSA8UIqVSL0rxkFK/hfCQGAYDWchNAx5cDUJeIvQZkhcSFexAIJNkLQ4o6bikHHtaA==
X-Received: by 2002:a17:90a:678f:b0:29c:6fc1:17e0 with SMTP id o15-20020a17090a678f00b0029c6fc117e0mr3818902pjj.10.1711490806764;
        Tue, 26 Mar 2024 15:06:46 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id j13-20020a17090a7e8d00b002961a383303sm97549pjl.14.2024.03.26.15.06.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Mar 2024 15:06:46 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Wed, 27 Mar 2024 09:06:43 +1100
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Convert libnetfilter_queue to not need libnfnetlink
Message-ID: <ZgNG88d1sAkgl+BU@slk15.local.net>
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
