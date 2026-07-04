Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3996EB672
	for <netfilter-devel@vger.kernel.org>; Sat,  4 Jul 2026 06:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783146465; cv=none; b=hKWFME6WVW24R8ed3le/DN4o9pN1f2iGiL8PeF+FUBOmdShYp2QOkpkjlZPKoUvU+AviP+Cq+iLbTTnIXZTahpy3Ur8WoBqYxnGeZ2lYZV5ms4jU9yqTJHY+lXEekC96I3IxfqSEXNS9STg243PhdlbuYUt3drYrN+RTo1USstY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783146465; c=relaxed/simple;
	bh=z4rr8jPxKwPxFdmNgsQaLFvsfffM4Q4x/+oBiUBg600=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f328D0VNp7OnRvVg8FlaI/dvvTQtRkbzfjnTQia5gUpcKQgEsa3M2/cHuWzA/K4l4PmJvh7+hSEc3RvKFvya41iEb7bb7VnPabF2cSmVVeB3QTmygpkfgS+A5pzL+6HTIUm0Ukb321iTieshVFRLuancuSKraBvteLDiGVZUjNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D0EEC6038C; Sat, 04 Jul 2026 08:27:34 +0200 (CEST)
Date: Sat, 4 Jul 2026 08:27:30 +0200
From: Florian Westphal <fw@strlen.de>
To: Haoze Xie <royenheart@gmail.com>
Cc: pablo@netfilter.org, phil@nwl.cc, yuantan098@gmail.com,
	yifanwucs@gmail.com, tomapufckgml@gmail.com, bird@lzu.edu.cn,
	netfilter-devel@vger.kernel.org, Ren Wei <n05ec@lzu.edu.cn>
Subject: Re: [PATCH nf v5 1/1] bridge: br_netfilter: pin bridge device while
 NFQUEUE holds fake dst
Message-ID: <akin0oTJJ47AL432@strlen.de>
References: <cb8bfe944f4afa8cec437fc15210a3d094612859.1780803571.git.royenheart@gmail.com>
 <53245eb5-baac-4e04-a632-1b722ea18972@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53245eb5-baac-4e04-a632-1b722ea18972@gmail.com>

Haoze Xie <royenheart@gmail.com> wrote:
> > --- a/net/netfilter/nfnetlink_queue.c
> > +++ b/net/netfilter/nfnetlink_queue.c
> > @@ -1214,6 +1214,9 @@ dev_cmp(struct nf_queue_entry *entry, unsigned long ifindex)
> >  
> >  	if (physinif == ifindex || physoutif == ifindex)
> >  		return 1;
> > +
> > +	if (entry->bridge_dev && entry->bridge_dev->ifindex == ifindex)
> > +		return 1;
> >  #endif
> >  	if (entry->skb_dev && entry->skb_dev->ifindex == ifindex)
> >  		return 1;
> 
> Hi, is there any follow up about this patch?

What do you mean, can you elaborate?

What is wrong with

c9c9b37f8c55 ("netfilter: nf_queue: pin bridge device while NFQUEUE holds fake dst")

If the patch is not sufficient, please submit a followup.
