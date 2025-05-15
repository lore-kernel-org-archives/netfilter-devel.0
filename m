Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63EAE801
	for <netfilter-devel@vger.kernel.org>; Thu, 15 May 2025 01:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747271372; cv=none; b=srCFJGWazmTnJrGkAaExYtUmZD7CGyZBEUDx2tRNfXgMi4FpE4it9Ld07ov8SQtldAhgLmvjPIyMalPzDlP6ZNT+6lWgi5yhU7ZqPMNZlAjpAHfgIJDXhQ8SjW/ShkpJWjoxdana71+GUuxZ1Y0Fj3Okm6GeQtspHMmj8VFb/Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747271372; c=relaxed/simple;
	bh=zHaA5NnaNR8vB0QBtR0co6v3T+tjyWDWF9fl+rF2O/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FmqWxVqpqeXWuECn0/O5v38Mf8YNQKG0Enb1oXdpkqwBrv12S7DL3YTKtcj70jbzurpPZpVxuWXwSzcHtc4DMAhJv76dq4PT03gGl7ZHj6HVM6H4A3aqA08YRxlXcRsRmlxTJvW4C0nXGXVwKRjp3LudTq4yTMRZCdAaCYbCq78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jrMTxWeA; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jrMTxWeA"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-6f0ad74483fso5071886d6.1
        for <netfilter-devel@vger.kernel.org>; Wed, 14 May 2025 18:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747271370; x=1747876170; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ob5lPTQZ3p6gkLLFtuuMoJxIWILx8ax9skOWmwDcFXs=;
        b=jrMTxWeAfMn1yXG++V6eQe+NPm4MpZ6Ol+o2+4szVDKCnGaTHqNQCM1LtGcEgpu279
         RkZmvAQJiU1zYtH7eQKgYfHDOLlKwu3AA2e9ohNgFBbpfynROB3mQtLu/n6WpjljNyVg
         +9pkJremg/lcr/dEbvRovU3mvRF6ml3yA9Qnfcd6JIBFeywAF2jHUTNP142wgS6cSu+N
         xWSHZBSMEzbBInkfaRswwxDydLzjA9xsWc3/Hho+xN7AF1R4F0fOW9tStmGGY5qtGlIH
         mtDdE9LVyIYopYQj+7PuGSM+VHosO+FWnxl+3+3/Jyhg+qbP5FrSUBVE08e5ANZSucI0
         xZjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747271370; x=1747876170;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ob5lPTQZ3p6gkLLFtuuMoJxIWILx8ax9skOWmwDcFXs=;
        b=wnbxZOww2mxksVMwtmBmUCtADGqZw9biowCdgCDLtxX6IhjrVeF85RkWZxN5KGE2Nb
         u/vStHlqohjhP/pxehG7+Hp2nRJzVjtKqNXrUZTBAEV3+igLImNabifXcAlxMXDLc3fe
         Ro71ttZQ9JIItFcHa8RaQtsCCkgctsQVxBis4kffg78pow5gB7iq0xWzRvux9cz7CSFq
         x2c7F7zDdNF8kJGmeSmjJnpL3t2DCHw+j1KNhBjESDlZzqNob+6Hy17uR+vTWqGPa690
         7WrQBcKQDZfwV5RTLTJTZxftQErpX1fROeDhly1g6Ba0NnEVMeT99URL0ZWso3iyLkkO
         r8pA==
X-Forwarded-Encrypted: i=1; AJvYcCUus8wWmJGggffeNfhmy7jAd3uLogTbYlzXcghTOQ/gxqogeO2Ebfc3aRY7LVi8p8AKdZHl7eIZwQta3kR4WV4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjyUoMG5qzdgS3Goq09xRFkeRB8pHXXVzLZcK07Gq+s+/QOWLX
	+nW14TeGiXdXRuOE1mtb+lFKPJ4q7WTBDfOCWfWfk+zlTg2O8oqf
X-Gm-Gg: ASbGnctLg+l0yDQ65mLAc0KLuCYa5AhKT5BycktFVxvDwIop4X0jtI0eBsEf+zr/c3y
	Tx2xFa1JniIh4Pj6emLPRl415hAUhKZ1H1e062LcFLQO8sRPGRriH5XEXxofBWanCrF3Bv2PXgb
	R5KFIB8Yb8HWqRxiZ8Q1Ij6p+fBpLPCxluor05YdNgEYa6LQZJeyZaQmBreYfoFUJrsfPmRr9dd
	zwhj+JDx/yEsMuGnylI3H7UHqbeJrX6F4RpvPMHaumPHssC6dFcxGgyis1Bfw7Rx4gezDAHtXf4
	m51RIUrmwLPwcY1UhnADrMLN1xhUeE8USmJ5U0Rc9iXfdukAmnOUN39yHao+kyqkfgN9Y02YBju
	FdcymrNVUAOOldoYkwpc=
X-Google-Smtp-Source: AGHT+IEGvPlMFoffb9gHIgqeEpzSGY68SKD3OODZamqSZ5PEOPr8OF/RBYed3h+5nK5bybrxKMPfMw==
X-Received: by 2002:a05:6214:234e:b0:6f2:b094:430e with SMTP id 6a1803df08f44-6f896e35c98mr91309606d6.25.1747271369480;
        Wed, 14 May 2025 18:09:29 -0700 (PDT)
Received: from fedora (syn-075-188-033-214.res.spectrum.com. [75.188.33.214])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f6e3a538f8sm87315206d6.114.2025.05.14.18.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 May 2025 18:09:29 -0700 (PDT)
Date: Wed, 14 May 2025 21:09:27 -0400
From: Shaun Brady <brady.1345@gmail.com>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, ppwaskie@kernel.org
Subject: Re: [PATCH v3] netfilter: nf_tables: Implement jump limit for
 nft_table_validate
Message-ID: <aCU-x4SbsJ_Jy7RM@fedora>
References: <20250513020856.2466270-1-brady.1345@gmail.com>
 <aCRPkxvH5LCtc7Bi@calendula>
 <aCSJiV5Hz-MTMFLd@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCSJiV5Hz-MTMFLd@strlen.de>

On Wed, May 14, 2025 at 02:16:09PM +0200, Florian Westphal wrote:
> > Maybe it is better to have a global limit for all tables, regardless
> > the family, in a non-init-netns?
> 
> Looks like it would be simpler.
> 
> The only cases where processing is disjunct is ipv4 vs. ipv6.
> 
> And arp. But large arp rulesets are unicorns so we should not bother
> with that.

I'm good with the simpler condition.  Let me double check my
understanding:

Each table will keep a running jump count.  When validating a table
(rule modification), sum every other table in the netns, with the single condition set being

if sibling_table->family == NFPROTO_IPV4 && table->family == NFPROTO_IPV6
||
   sibling_table->family == NFPROTO_IPV6 && table->family == NFPROTO_IPV4

   do not include in total for netns (break).


Assuming this logic is sound, I'll do v4.


Thanks!


SB
