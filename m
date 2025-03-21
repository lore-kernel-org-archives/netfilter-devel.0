Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACD79461
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Mar 2025 01:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742522259; cv=none; b=PYnGjuE9KuA2Fpy7C9CacUbp+Rai3i4uGQCO+JQQV1bUf16NqqyAkdB3qpaKT7xmks62e07/n2LS8ioztMB47pT9IBKz/j2nGjfnilBJdM+3zalciYSGEpbHlkFa33CTJwOTnXcoTt1o7c1MOQevLPpap3CCE/FFIiMFh2alD7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742522259; c=relaxed/simple;
	bh=TFFomu1Eksr50yc4b/31emzAbCyM5bPlIZxmLS/D5lM=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cUKLMLF8BRNC0n7JZtW2daTmVe8gnht1s57lVhlR3MIWK/y/Z/uAEVIZKLiLkqVroq1lma5hEASty3SOPXAaaCNw8ZnT6jK8HyLjP7YXGol6KythZQNI58py7B+RyNora0aLeUUu24s9G99TUwm1Rxn9t3d0ychBtw59uLhXIEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FlSKul6z; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FlSKul6z"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-225df540edcso54115475ad.0
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Mar 2025 18:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742522257; x=1743127057; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S0aP0TL7A+pAYTet05RbopSqH1JoLS7+bp3XLlQ0Lxw=;
        b=FlSKul6zs/Wghk0hIw2mUHrfXTshrqN8i3w6J78lGyR4FNN8O5Lr59jGbgTEZ/c9OI
         EqSdolnftqt77ITceE2nunkeuunhrNq6MeV7uF4EK+1t//7SZD35Z3trssYNxRBAi1BE
         NaLL1IoIhQ4w9VAfebJoOlmP9F+JfAEWLbC96WhRQAMvs8fplpZliONioqEI3j+mDfso
         7LJvfiajeLGm9RCbTwHLTFToNDziaib3fLqolf23NJ1EH2Likq4LLrjeSwAdXm4J71VJ
         i5s+u06aAy6jFlPE4H8bBM9Nn7rtxszDX1aNYwql74FhJveufTGaqIeg9ftcfvrgE8Oh
         vJrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742522257; x=1743127057;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S0aP0TL7A+pAYTet05RbopSqH1JoLS7+bp3XLlQ0Lxw=;
        b=vednvLIn8d+wemhmk5OEpHXY2rhp4G5T0gdueWvShljLKhCM6uYf74f/vwbDX7rYZ5
         CmBz9kOPVkYLl43AZUF9KDOMOXK9FOFVMeeWmjf2AjNOoS6PdTi5GrfRuJGUS6Mcaz1T
         UJzNufJDgsGkJ4xH4Ir8PahaZaNaska61mKHNSjDHgfqgA8yHaNK0jc7HWlJDYlIC9t0
         wFb/SW/to4gredxAsmnQwDHYJ/BcMIxHGvh3Z/Ay1ZnIUr4RRdPnjBIZhlTDwZ9gfos/
         eHFKvpmIBICgQcDRufLnhtBeFYanV/S2QvTZRIXeYQGuhCWAc9X2X9/DCM3TgTQp0537
         oIeA==
X-Gm-Message-State: AOJu0Yx5H0OAfvkSvVY4f8zOS5WKGLKof2UgEIc9xTLH3QyE69osxE9c
	BwFbxDEmGb/8+wbhezMkXZHTMnAU+GZ461GaMfi6J0vB/KdY/BBRaP978A==
X-Gm-Gg: ASbGnctKFVdgsRl6B3P3zcLTsNUzuVeC/Ox3ibn5DJv9ui3ffjh4HEU16QnfS5M6irm
	EQmb1UnCd5/RZJhM7oQsc2uuMXYxRo/71TZnYjQr94mBxMFmn52owvDVy0ShlATLCQ5HEYhrFVY
	ANvNjv+s9dErQl/7lwjP85iyvedEhWr3DfXwgRsuKZ+5pvPlG1TMdOjV8bdYW/289Au1lWJLANn
	wP7oEL6B0oCDBzlZRMg4+hife1IvjMvmq5qDEhLs2Hjl/Ra9/VX4ROoX01pFYcYheNGMBGmLdJS
	nUKsGR9p6o9d/TTfAiI0jeodiqdLrGihmgBQv1uAwRuXYDVaAn255amn3J48lrhf0fIh5pdL8gP
	jeFuQAMXqOfomY6CH2imsFg==
X-Google-Smtp-Source: AGHT+IG4emdSoEmhMb7nrsvD6xV5x5zSwcJem0eeHmQJ7KMBFCOuvLQ5nD8NZfc9QSVA1xrXMlCA0A==
X-Received: by 2002:a05:6a00:638d:b0:736:aea8:c9b7 with SMTP id d2e1a72fcca58-7377a08766dmr8091725b3a.2.1742522256957;
        Thu, 20 Mar 2025 18:57:36 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73906159f6fsm566957b3a.156.2025.03.20.18.57.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 18:57:35 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Fri, 21 Mar 2025 12:57:32 +1100
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue] src: doc: Re-order gcc args so
 nf-queue.c compiles on Debian systems
Message-ID: <Z9zHjBkgCDyPiBoN@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20250319005605.18379-1-duncan_roe@optusnet.com.au>
 <Z9qOVEObhFzmVKx6@calendula>
 <Z9ssJMKDJDetdYV2@slk15.local.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9ssJMKDJDetdYV2@slk15.local.net>

Hi Pablo,

On Thu, Mar 20, 2025 at 07:42:12AM +1100, Duncan Roe wrote:
> Hi Pablo,
>
> On Wed, Mar 19, 2025 at 10:28:52AM +0100, Pablo Neira Ayuso wrote:
> > On Wed, Mar 19, 2025 at 11:56:05AM +1100, Duncan Roe wrote:
> > >   * Simple compile line:
> > >   * \verbatim
> > > -gcc -g3 -ggdb -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
> > > +gcc -g3 -gdwarf-4 -Wall nf-queue.c -o nf-queue -lnetfilter_queue -lmnl
> >
> > I am going t remove -g3 and -gdwarf-4, so it ends up with:
> >
> > gcc -Wall nf-queue.c -o nf-queue -lnetfilter_queue -lmnl
>
> That makes nonsense of the previous line:
>
> | you should start by reading (or, if feasible, compiling and stepping through with gdb) nf-queue.c
>
> You can only step through nf-queue.c if you compile with the debug options.
>
> Please leave them there.
  ^^^^^^ ^^^^^ ^^^^ ^^^^^^
You chose to ignore this or maybe you just missed it?

I can send a patch to remove the reference to gdb in the previous paragraph or I
can send a patch to reinstate the gcc debug options. Which would you prefer?

Cheers ... Duncan.
