Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F9413FBB3
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jan 2025 23:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736380130; cv=none; b=Slb5LY5aZUZLiR0n/FQIQBNsL8Rc/XsaS8bHh/QqSbvgPw1hB0C12rWl9DMlaa1+WLChr6gHbfcyPrJq9hr5dFUz19he5/VX3tx1aTjSNNl4kfcc3g73mZkohtTb90/3WL81yBOsKfV+wLSzJx52eP03MyhgE+EJ/v73tveoXs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736380130; c=relaxed/simple;
	bh=Oegznc75JkkcEMq2Dwe4TIvMxkxftq71jLjhMOXgCAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QpemDZYd9D6aFJ96PAqYVNUqWfGBxEM+HAP3FoT/k+2UAtVIfUell/7+hLV+VJXm4x+DIkYdCJslpjKNDkoFj3lf+QxqBxy8h0LAcRM3GlDe0pbq3X6IftSZ5WnF/7u6/YR5ajvq32koK1/YUtfjsZ7+jtJ7L/9zpFwX39Kgp4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Thu, 9 Jan 2025 00:48:44 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Nadia Pinaeva <n.m.pinaeva@gmail.com>
Subject: Re: [PATCH nf-next] netfilter: conntrack: add conntrack event
 timestamp
Message-ID: <Z38O3LCrBRUDwUMR@calendula>
References: <20241115134612.1333-1-fw@strlen.de>
 <Z31OB1LLNA5AEDn1@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z31OB1LLNA5AEDn1@strlen.de>

On Tue, Jan 07, 2025 at 04:53:43PM +0100, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > Nadia Pinaeva writes:
> >   I am working on a tool that allows collecting network performance
> >   metrics by using conntrack events.
> >   Start time of a conntrack entry is used to evaluate seen_reply
> >   latency, therefore the sooner it is timestamped, the better the
> >   precision is.
> >   In particular, when using this tool to compare the performance of the
> >   same feature implemented using iptables/nftables/OVS it is crucial
> >   to have the entry timestamped earlier to see any difference.
> > 
> > At this time, conntrack events can only get timestamped at recv time in
> > userspace, so there can be some delay between the event being generated
> > and the userspace process consuming the message.
>  
> Ping, should I resend this patch?

For some reason I considered this was waiting for Nadia's feedback and
I don't remember to have see an acknowledgment on this. I assume then
this is good enough for the measurements that are needed.

This is enabled via the ktimestamp toggle, so there is no new toggle
as you suggested.

Patch LGTM.

Will you follow up with userspace updates for this new code?

Thanks.
