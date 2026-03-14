Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20FB51DEFE9
	for <netfilter-devel@vger.kernel.org>; Sat, 14 Mar 2026 11:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773489041; cv=none; b=eDX8YeaKNjfgsqqm/il2feBJfj0hb+SUT7eJsFl6uNsvKVa4TXR7pA6pJv8cC3H0xYHEi0UxX5PzJMIl1cn0beYGJm51K0b3REBvwjiPgjIFxbzuOOzMaxkptLRDJQY1xdf7R8ZuY0ocNKHLMDrnpIRW4g4nkyBEmZoDcmQQne8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773489041; c=relaxed/simple;
	bh=2PE2AMcHb2NF8j/Ij0dymsjDBpxhk375VYJvTTfjYVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZG7rWLuxZXifSrsazMmHnX4NSbSv9jgYzHelDernBRCcmxdapUmDmY0R/YGIzjYa67lYbHmcGykfm5J1dtRDZNNq8heAXmWLIBBx0UnNg7rYvHukWxl7D1sNemiJySz5zAx6TcChP/t38/uNmxURs/qh0BpAjfqLfhOs72oQZDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=M9mydQLP; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="M9mydQLP"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 371E860181;
	Sat, 14 Mar 2026 12:50:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773489029;
	bh=FldjxWmNYJRBNW9FRlSptQ4agYj2aACSB7eE7jHsOZQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M9mydQLP1lzTnniPkykaVWj7TcD7M685/O2Z3nBwsTdCvgBJ6dkKVyYFl2ZAa5WWt
	 YyKKHRjDg+bAiB9Jj2pXkz5FkdlmmtGt+tRQSvEbzhdbd4KMLvE47dXpP4HDqeELta
	 VM+K2zcqM5Jhe6GxcqGStUXCn6Eg0VzkLhh/sOVXdfdiQVh2hoTa99gkvvdqUKTqXb
	 62SK6eQGM7/lZ3xt/aDF/dl+VWa3E5FCh9Wep007qJqb/J2jUg4lN9MQvwKoKtxDF+
	 z6Uan/iY7eelCLVSd7COIu59jlILsef2Y9CrLCGu3E0M4j20EM0qSsRmMZMUoW3E05
	 XorD/YskactdQ==
Date: Sat, 14 Mar 2026 12:50:27 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Jenny Guanni Qu <qguanni@gmail.com>, kadlec@netfilter.org,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_nat_sip: validate exp->dir in
 nf_nat_sip_expected()
Message-ID: <abVLg641YYZ6TlvM@chamomile>
References: <20260313201346.562476-1-qguanni@gmail.com>
 <abSelah2hPOUbEng@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <abSelah2hPOUbEng@strlen.de>

On Sat, Mar 14, 2026 at 12:32:37AM +0100, Florian Westphal wrote:
> Jenny Guanni Qu <qguanni@gmail.com> wrote:
> > nf_nat_sip_expected() uses exp->dir to index into the 2-element
> > tuplehash[] array without bounds checking. If exp->dir has an
> > out-of-range value, this causes a slab-out-of-bounds read.
> > 
> > KASAN reports:
> > 
> >   BUG: KASAN: slab-out-of-bounds in nf_nat_sip_expected+0x804/0x938
> >   Read of size 8 at addr ffff0000d113e3b8
> >   The buggy address is located 72 bytes to the right of
> >    allocated 240-byte region
> > 
> > Add a bounds check to ensure exp->dir is less than IP_CT_DIR_MAX.
> 
> Ok, but exp->dir isn't expected to contain crap.
> 
> How does exp->dir become >= IP_CT_DIR_MAX?
> Are you sure this isn't papering over another bug?
> 
> In particular, there is missing validation in the ctnetlink code
> for the dir argument.
> 
> https://lore.kernel.org/netdev/20260313150614.21177-3-fw@strlen.de/

Yes, this sounds like a duplicated bug.
