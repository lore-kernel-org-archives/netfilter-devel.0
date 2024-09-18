Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574EE16D9C2
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Sep 2024 15:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726674577; cv=none; b=mPoUlVEjyT+NnxrcpAMGhht2mdGDElqJE1MM5u12/jYWrPVIP7pY7gWNhDq7VrD4XTJRQ6bNyKwkiMMVGJZIQqM3vLc2OMb6DK64vh+nvEUMAG/F5hcy89SllxAI9R3Zjy6Ss4l9VWIY5lKM0Sowp/n2lgOT6lC2Pnwku+aBX2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726674577; c=relaxed/simple;
	bh=Fg+YFrCbsJibr2Ae331akttM7VKXlPx5FQ5Xw7mm9Ho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ORdt+5uP5yp4PW3g9V0olrQ1aL1M8EZdrt6QxU0aePMRnQE42cQ5qDYEHfKNYtLr1Io5KfgNQ49AMTtTQslsFQzwgiycGnrAIroHMdXQn7ZNEwQf8jflOuzcm7IGE86FTeN4DyO7Kx5Kh8OThvIEGZLOowRHLNbEi45fV75x/F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sqwvr-0005ED-3Z; Wed, 18 Sep 2024 17:49:31 +0200
Date: Wed, 18 Sep 2024 17:49:31 +0200
From: Florian Westphal <fw@strlen.de>
To: Antonio Ojea <aojea@google.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] kselftest: add test for nfqueue induced conntrack race
Message-ID: <20240918154931.GA18635@breakpoint.cc>
References: <20240918131637.9733-1-fw@strlen.de>
 <CAAdXToTGaNiwNDViMpRxoz5=YZkH-bu6rtO5_6xmkvN7s1nW2w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAdXToTGaNiwNDViMpRxoz5=YZkH-bu6rtO5_6xmkvN7s1nW2w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Antonio Ojea <aojea@google.com> wrote:
> > +       # This is because nfqueue will delay packet for long enough so that
> > +       # second packet will not find existing conntrack entry.
> 
> for my own education,
> will both packets use the same tuple and get a different dnat destination?
> if both packets are enqueued for one second , -d option is
> milliseconds, why the conntrack entry will not exist?

The conntrack entry is inserted into hash table as last
step of postrouting.  As packet is held my nf_queue, this
insertion is delayed and when second packet arrives it will get
its own conntrack entry allocted.

Due to numgen+dnat combo, it gets its DNAT'd to a different
address.

There is extra code in conntrack to handle this case, source
tuple is the same, reverse tuple is not (because of conflicting
NAT).  This rather dns-specific hack inserts both entries, the
colliding (second) entry is only inserted in the reply
direction, where we can map reply packet back to originating
socket.

If client sends more packets, they only match the initial/first
conntrack entry.
