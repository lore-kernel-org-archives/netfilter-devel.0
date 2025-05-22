Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0206028D826;
	Thu, 22 May 2025 19:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747943905; cv=none; b=cagjTS23ErpvDTmJp8K0qpNYPql2zOiYaMuxl4VGxH3JIm8gJnnjp1R0PiZbaAHW7KcK/mdp1MZ/WEM+WQSFllrx8Z9Lz+oPlslMv1i15QBExyFmV0ZZhbW2zHkowe7EEG+wDM3qPf1KaHdYYEe88johAI3OuwChg7D5a0sr6G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747943905; c=relaxed/simple;
	bh=/pIbxgy4CZdFbAtgiY41pzg2aGXcuYziEXZ2E8WPvQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dSIriz6E84yjJbxUl/B3AB3jRgc8VDwcAWV792aDR6HyypyfddLOGwpH0vq+8fhbhLGd75XRPKDs8VeQsRdRKTcZL4hMe55lGZrnF13O8nNOIdQhDskp1DlDUiP3FgYQRUMGDNIjwB+mzXShmYbbLJZpqC2tuT1uelZ4ErEd95A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XGgK+ZGC; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kc2UasCB; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XGgK+ZGC";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kc2UasCB"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 5D0A06070D; Thu, 22 May 2025 21:58:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747943899;
	bh=wzmJH27Ubrj3iGVvCZHx1X0SPt1RhydnW+wmMCu/QM0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XGgK+ZGCFtfoZPCOHjZHdagIcK0WOzur2ZnVSsyZXIQmDdY3iMi1rCRtM+YLfDvLB
	 mSDm9E8nmHucRXzO3KG1Q6Z/hlBXGo/yVlQC+0Y3bG9B5v3ZnZ5jWdkmM490XVqMxa
	 mHdyKSFYuX3rELalvavEl4HKR8cOecflFg3j005HfbDVeoGy8K965zWQ2ic7igIW1/
	 MbM0K64i4TRgL1aRciX7ssDfZFdsYUaLz3Dk/+gxnzNA4QvzI9ZELAw9ikvN4b2uoX
	 26WbSGBASJ2e3jHVoIXNJUccHCw3gGGfw5uECFSHaiFR3ZwqRCX9DNpflMC+TGT3jp
	 sXenCUHcGtUQg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 46A936028A;
	Thu, 22 May 2025 21:58:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747943896;
	bh=wzmJH27Ubrj3iGVvCZHx1X0SPt1RhydnW+wmMCu/QM0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kc2UasCBkhi3OORM8zCRtLfZlxl+BIy5HqQsyB7h7sGWfpkqM/XYMQ9YPBCUNGY+1
	 /EEe5Y6DhoCIfU45enesy9W8dktoEna5PdYebz4X41qw18TZMKNE0HDFZkM1csQnqs
	 U00biYbPaMcbPQ3yqeTBneuBnhlpvxskeySvGyc59eZPQuA7kn+eAQ9PUrnsJUE7xZ
	 0H+ydgt6aQBUvoOIQ1n9j4HxXLFktx6Mv1NVw983IJ1euSy/QrMZ0k7A906sVYAosd
	 F+I4upxKyO7qZsxSa7sIAmSzx+AcEre+kgp1+CWz1wKTEn+uI2ldsoQhukD1ncyci4
	 2bbqzlPuMJ1gg==
Date: Thu, 22 May 2025 21:58:13 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: lvxiafei <xiafei_xupt@163.com>, coreteam@netfilter.org,
	davem@davemloft.net, edumazet@google.com, horms@kernel.org,
	kadlec@netfilter.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
	lvxiafei@sensetime.com, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH V6] netfilter: netns nf_conntrack: per-netns
 net.netfilter.nf_conntrack_max sysctl
Message-ID: <aC-B1aSmjDvLEisv@calendula>
References: <20250407095052.49526-1-xiafei_xupt@163.com>
 <20250415090834.24882-1-xiafei_xupt@163.com>
 <aC96AHaQX9WVtln5@calendula>
 <aC97x6CHFleb54i0@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aC97x6CHFleb54i0@strlen.de>

On Thu, May 22, 2025 at 09:32:23PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > -        to nf_conntrack_buckets by default.
> > > -        Note that connection tracking entries are added to the table twice -- once
> > > -        for the original direction and once for the reply direction (i.e., with
> > > -        the reversed address). This means that with default settings a maxed-out
> > > -        table will have a average hash chain length of 2, not 1.
> > > +    - 0 - disabled (unlimited)
> > 
> > unlimited is too much, and the number of buckets is also global, how
> > does this work?
> 
> Its an historic wart going back to ip_conntrack - it was never the
> default but you could disable any and all limits even in the original
> version.

Thanks, I was just sitting here clueless.

> Wether its time to disallow 0 is a different topic and not related to this patch.
>
> I would argue: "yes", disallow 0 -- users can still set INT_MAX if they
>  want and that should provide enough rope to strangle yourself.

The question is how to make it without breaking crazy people.

> > > +    The limit of other netns cannot be greater than init_net netns.
> > > +    +----------------+-------------+----------------+
> > > +    | init_net netns | other netns | limit behavior |
> > > +    +----------------+-------------+----------------+
> > > +    | 0              | 0           | unlimited      |
> > > +    +----------------+-------------+----------------+
> > > +    | 0              | not 0       | other          |
> > > +    +----------------+-------------+----------------+
> > > +    | not 0          | 0           | init_net       |

in this case above...

> > > +    +----------------+-------------+----------------+
> > > +    | not 0          | not 0       | min            |

... and this case, init_net value is used as a cap for other netns.
Then, this is basically allowing to specify a maximum that is smaller
than init_netns.

IIUC, that sounds reasonable.

As for how to discontinue the unlimited in other netns, let me know if
you have any suggestions.

> > > +    +----------------+-------------+----------------+
> 
> I think this is fine, it doesn't really change things from init_net
> point of view.

Thanks for explaning.
