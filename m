Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEACE3B0AD6
	for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2026 23:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775000388; cv=none; b=tRTekHUoRqhLLFOZG2magZby90CKWRz7XdttHW439Zp8ak+H75jhBfuBUwo0TB+rpTLfPIC1SIzfKe/12p+jJuByUvHVzJLZJMnjfJnYgm0+d2wM6WTeT1UemmK4VK7pCeOejXyudipOF91NqdHY4eBK6bZGV/MRfJrNWCGCchw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775000388; c=relaxed/simple;
	bh=5bzmvfs1h8CdgnuiU8MSN5f9bhVj+MMr0fFF8LzQ49A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aY5dkwdwnNuxAaqk8CEV1tAf4/iKHZe4xohD9JBuxQ+XpW2HTUxVbjXyyP2kqV/yjwMglot3BO5SHu3D/lCXqDReukDOxkWh0+pbOmsDAAQpsdZP/CNSBU1/r3AnMqo/Yxbb2iKxICOVd0dnwp3tjmJUc3wmZD4qMiCyY57gRAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BCbZJyHd; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BCbZJyHd"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 445AF60253;
	Wed,  1 Apr 2026 01:39:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1775000384;
	bh=NbNWvAaYW5DdN2r34ENDtyVjglwV2RqihsVGgH6RRpY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BCbZJyHdCBqTqsmQ704zzdw6W9ciWURV/o//vZG9gSCX8W62/HZcrpRcUdj3QMMqJ
	 uWptLtADTkBnEE0hFbBPDSedBEQSNA14CziHxW1JLM5TNO+z5M45d6IfGGeCjXZWKq
	 +6rYXvzyVniXjsoLPlXwkm7LUazvs4tUIjOlwkvhWtt+vE9JXhID2+CavGbQ4ur/rO
	 QSe+/k+/Q35l4kUEv1PU3WBI9BQWqIBPQEDsfqjTJiTj4/kjrSgmyy49rkKwA834Ya
	 nBXh9AYgo8ssO3ZKIovhygebUibbAJtVnDqoSE8kc7hQeDgg63JuzKFUa3t+SJzM65
	 djedhW/cSv9aA==
Date: Wed, 1 Apr 2026 01:39:41 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: netfilter-devel@vger.kernel.org, security@kernel.org, fw@strlen.de,
	phil@nwl.cc, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	shuah@kernel.org, yuantan098@gmail.com, bird@lzu.edu.cn,
	z1652074432@gmail.com, kaber@trash.net,
	yasuyuki.kozakai@toshiba.co.jp, yifanwucs@gmail.com,
	tomapufckgml@gmail.com, enjou1224z@gmail.com
Subject: Re: [PATCH v2] netfilter: xt_multiport: reject trailing range markers
Message-ID: <acxbPWCI6timYqiL@chamomile>
References: <cover.1774624314.git.n05ec@lzu.edu.cn>
 <dc1b0139fc250e188657e874ce4bb67f60af6e0c.1774659119.git.n05ec@lzu.edu.cn>
 <acxY3z1h2qkpzaEw@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <acxY3z1h2qkpzaEw@chamomile>

On Wed, Apr 01, 2026 at 01:29:38AM +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> On Sat, Mar 28, 2026 at 10:51:23PM +0800, Ren Wei wrote:
> > diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
> > index 44a00f5acde8..38aa5b90d38e 100644
> > --- a/net/netfilter/xt_multiport.c
> > +++ b/net/netfilter/xt_multiport.c
> > @@ -26,10 +26,10 @@ MODULE_ALIAS("ip6t_multiport");
> >  /* Returns 1 if the port is matched by the test, 0 otherwise. */
> >  static inline bool
> >  ports_match_v1(const struct xt_multiport_v1 *minfo,
> > -	       u_int16_t src, u_int16_t dst)
> > +	       u16 src, u16 dst)
> >  {
> >  	unsigned int i;
> > -	u_int16_t s, e;
> > +	u16 s, e;
> >  
> >  	for (i = 0; i < minfo->count; i++) {
> >  		s = minfo->ports[i];
> 
> I see, this is a cleanup to use preferred datatypes.
> 
> > @@ -106,20 +106,36 @@ multiport_mt(const struct sk_buff *skb, struct xt_action_param *par)
> >  }
> >  
> >  static inline bool
> > -check(u_int16_t proto,
> > -      u_int8_t ip_invflags,
> > -      u_int8_t match_flags,
> > -      u_int8_t count)
> > +multiport_valid_ranges(const struct xt_multiport_v1 *multiinfo)
> > +{
> > +	unsigned int i;
> > +
> > +	for (i = 0; i < multiinfo->count; i++) {
> > +		if (!multiinfo->pflags[i])
> > +			continue;
> > +
> > +		if (i == multiinfo->count - 1)
> > +			return false;
> > +
> > +		i++;
> > +	}
> 
> Why so convoluted? This should just fix this bug:
> 
> static bool multiport_valid_ranges(const struct xt_multiport_v1 *multiinfo)
> {
>         return multiinfo->pflags[multiinfo->count - 1] == 0;
> }

Another possibility is full-blown range validation, ie.

if pflags[i] is one, then pflags[i+1] must be zero, checking that i+1
do not go over XT_MULTI_PORTS beforehand.
