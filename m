Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F31E1EF01
	for <netfilter-devel@vger.kernel.org>; Sun,  2 Jun 2024 15:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717342245; cv=none; b=Kyn5bxws8dPPIbpPNtPaVdMtikMFdbEQOtK6r0wa6Y+ZZR8zV/b6s3xyojSwtKmH7PpTJBlTmBT1m6XUFQ8gVf9+Jb0T4kic/So6u/Ne/uRLmjLWG8kU+7ZeLcp/S2qBBJF1m/Zx92KDS2W+VaiV8hogttwb65X8MlRwwmooJW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717342245; c=relaxed/simple;
	bh=gxVs0M+X7IsPCzsK9LZQ5OJ3BRUQeaQD3htZOitz5v0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fNO6Mt3KX0Z6LC5iI2ZEmiQd4hsDdFeIJ8v9IBSxGuQrGK2RYivXIc5E7RGqOiNfMNQyFKrDdnbFKhzdO+y4+g97SY99qYyuPWBMFnsZw4vsPWFuX4Wy5kB3bkz4GwSntJpLWjkJGNoksF+VdaHheam5Yc8tDZ5zZH9meNOejP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sDnAH-0004iv-1V; Sun, 02 Jun 2024 17:30:33 +0200
Date: Sun, 2 Jun 2024 17:30:33 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Antonio Ojea <aojea@google.com>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] netfilter: nfqueue: incorrect sctp checksum
Message-ID: <20240602153033.GA8496@breakpoint.cc>
References: <Zkszmr7lNVte6iNu@calendula>
 <Zktv4TN-DPvCLCXZ@calendula>
 <ZkuXgB_Qo5336q4-@calendula>
 <ZkuasOTMseQKGUr_@calendula>
 <CAAdXToQRUiJBzMPGZ7AD_16A-JRZNUrr0aJ20mwaoF7gb92Rqg@mail.gmail.com>
 <Zkx8BCuu6dyTDjcX@calendula>
 <20240521105124.GA29082@breakpoint.cc>
 <ZkyOjy0YBg35tUrk@calendula>
 <20240521124850.GC2980@breakpoint.cc>
 <ZkyajEEYa0SV8zq-@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZkyajEEYa0SV8zq-@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Yes, this is implicit case: skb is gso. This is adding an exception
> for sctp-gso.

Is that because sctp gso carries a new / distinct sctp header
per frag?

If so, we can't extend skb_zerocopy, as it would create
a bogus packet.

The only "speedup" we could do in that case is that we
do not need to fix the header csum if userspace enabled
GSO support as long as we indicate csum correctness via
the NFQA_SKB_CSUMNOTREADY flag.

But that should probably be done at a later time.
