Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B8720C477
	for <netfilter-devel@vger.kernel.org>; Sun,  8 Mar 2026 10:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772966928; cv=none; b=sfab+qn4Miz7vjPXprllEjy3lzG3J3n0j3CjWnxFg9JAaNCW62br9JjQGBwG/2RyH9UiD6vXMSF36EWhXnE2mqqVk/9QIvtZX6ybc+cuxOxoRe4ihU63VY0KPjhUbo5bzbSoXYhn/dtJGTd6aUtdO4suyhTr4i0jUUyx1X3Dc50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772966928; c=relaxed/simple;
	bh=DGifS48hX4FURk/YYa+c2nvTrbRL/oGcZNvshK9owgg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pIS+3x5xRC5T3tBYgDl76sIsogRHbd3BSkdqSZL0+zq9PsLcRmzm9X7dBvqrTTKDBog+lS1PYWXsLj3DQku61c6WRT9Rg91nNVdD6I7dFNktwyiRD8y+7yEEOpY6gmEvJp3nvn8107XxzurggLOn839qDATGZZQ58GYVVsZBp2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BZHcb3kD; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BZHcb3kD"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 992FA6057E;
	Sun,  8 Mar 2026 11:48:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1772966925;
	bh=JmZglYM6jWpym4G9BPVdVKM6u7Vq+QppIEnqz42nzi0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BZHcb3kD65Yt/q0xHJWIm410dJwwcGJ8Y89nz1SSTzfM+JyNdaLYEiwh00KY96JcE
	 jZTaHKFHJZsVC27yQ9mSJli1NBLT2pyA2kKMHDCm/SVaB/3tovjOEfOM8XDYjnajaG
	 T9nF/MRVsMVxjPzrvEsxYEv73LbpidTisHZ+S20IccmliYXFEWfqh626kwxSDJQzgI
	 GuVzeu4AV5Y9O0YhbKo/NYFcOquNSYHw7ItWshq3vWi1L0uyxhRJZIHg5/+jyusKRX
	 5d+CclUoJGcFCXlev6fw0LzCzF5VKiz1Kne/GbvS4orWXEzv9eoZtds/MnUtyiZlZ2
	 TY6QQ9WmpQnhQ==
Date: Sun, 8 Mar 2026 11:48:43 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: syzbot ci <syzbot+ci49735e77812b876d@syzkaller.appspotmail.com>
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org, syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: netfilter: nft_set_rbtree: allocate same array
 size on updates
Message-ID: <aa1UC567sKmtkvcI@chamomile>
References: <20260306123649.2878676-1-pablo@netfilter.org>
 <69ac7562.050a0220.13f275.005a.GAE@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <69ac7562.050a0220.13f275.005a.GAE@google.com>

On Sat, Mar 07, 2026 at 10:58:42AM -0800, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v1] netfilter: nft_set_rbtree: allocate same array size on updates
> https://lore.kernel.org/all/20260306123649.2878676-1-pablo@netfilter.org
> * [PATCH nf] netfilter: nft_set_rbtree: allocate same array size on updates
> 
> and found the following issue:
> general protection fault in nft_array_may_resize
> 
> Full report is available here:
> https://ci.syzbot.org/series/63a7af7e-7e81-40b3-ac44-4a537af34cdfi

For the record, this is fixed in v2:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260307001124.2897063-1-pablo@netfilter.org/
