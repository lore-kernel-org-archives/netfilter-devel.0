Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0B73B0AC3
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Jun 2026 06:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780553830; cv=none; b=hWNJhz0ZYrAAeAEmY3CtI6sCrcdiBFryDy+wphSzmF91mifbqGcoJNG946TIfceMD91amHCeygW8VQyyuIbn5xTyPORBJYulsChT1d2pZIcfpzkzLXA5Ktyk7WmIhoFddlgWMJutKSFa3uLbgAtPS2dHJeTtq1h70TOdWY7NnZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780553830; c=relaxed/simple;
	bh=Fuf5eKsFuESO0WuLmIz4ZCzm8zqmqzHsP2pk9D0oLmE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QLTIMRqbb2JaTWuqGsCJMBYLISNFYpqOxCV7uZeaGpRU9BYFsK5R3OarOLq8f0eU62IK34Myo83wqlaZJ337nxCxh0m6WIx0i1tNVXdVIozVqFtY0UeAuDqj8h1S2z5NG626Y/S5P5VEg21ctGr7ut3pWRDhxvD/39IhBSXP6EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MHgHUsP3; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MHgHUsP3"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id B1BF96017D;
	Thu,  4 Jun 2026 08:17:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780553826;
	bh=V19F5AEHUoZ04xZgzRYPLE1CqMM8VbDID9tstg2hwGI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MHgHUsP3AA9SX+H+TX5PwXg7kR1X+ZtP7x5drRJ4c74gGlEAyf0vwY8V2Gan/6QCi
	 P0ynOMqqKdubjP60i59KblIh+nxxUKR85KvEP7REf2KyaEn2J0fOw1IcA+dUyE/YBx
	 Bw0mktlOEG3LbpHis2aNfIWsDMOInwRvscy41lOnGdQ0xzFWHb4W5sV7nZ0+jW8aFK
	 uYd5vQAq86uBfWL80B1wA+EFTUyU7QAc010gXjP94Zma4y1VHraS3zPFESzEvKKa3o
	 lMd9MVHvr2xDGMcnpcK/q+jrCQ9O2mIVWBAwbVRQ2v3Bt40gm4UEQFzGaC2o8au/47
	 iIH1Ygxyn4HRg==
Date: Thu, 4 Jun 2026 08:17:04 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [RFC nf 0/2] netfilter: add restrictions/validations for packet
 rewrites
Message-ID: <aiEYYP0PaWOkbRgh@chamomile>
References: <20260527121147.22076-1-fw@strlen.de>
 <aiCrpdgRNCC7LkaA@chamomile>
 <aiCtz2nBZL1Q-gmL@chamomile>
 <aiC0lYKyD5UDQgLS@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aiC0lYKyD5UDQgLS@strlen.de>

On Thu, Jun 04, 2026 at 01:11:17AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > If anyone is breaking with ilegals field, they should come here to
> > > explain? Data plane validation might look safer ... but it will just
> > > drop packets and it will take a bit more time to the user to debug.
> > > But your approach is more conservative, it just leave the packet
> > > untouch, so it is basically ignoring the invalid mangling.
> 
> Yes, ignore resp. BREAK verdict.
> 
> > Hm. Actually, it is harder than it seems to do this from control plane
> > because dscp needs to deal with bitwise to ensure that ihl and version
> > are not modified.
> 
> Yes, there are cases like those where control plane valition is not
> possible.  I will address the AI comments and resubmit w.o. RFC tag.

It should be possible with some sort of register tracking. At ruleset
load time, the hardware offload infrastructure already do something
similar, and I added infrastructure for this for a different purpose.

But this can be done later, the datapath checks now should be fine to
start with.
