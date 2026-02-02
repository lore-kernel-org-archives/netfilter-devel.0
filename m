Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5270637AA83
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Feb 2026 23:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770073608; cv=none; b=V5UpHR6UxxKjIb6MwRA9oWpSySKhdT2lYm6FYh81F2iQ4QUe4U4l/yrNAgY6rGID6KsAAEY3zmIPliWiUWZqfe8jgndY4hJ8N54Z4GMNwfgNaooL0zJw0VovzF8d6xunTHqke1Pct+ceY3gAO1cbMBbF4cgSEWjtGTD8wgBNgok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770073608; c=relaxed/simple;
	bh=tBFqMGC5zheweVI3TGcVIGezEIVaFISMUbW4wxhjg0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kfZLGjzqQmMLThMm9bsdaksOmVAjR6Jw4HvCjiGX3kk+kjzHiuumlRBrTgTEbSU6gk1xwOp/iJnjXBlbfw5a4p0c35hFaleaP7OZaL9XdGfLLLdGRtZh4i2E7fDkt2F6RCSeatLZuux6IIiaz0cBoBwNkpDG0P5O2wmw2mQUGhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 890D76033F; Tue, 03 Feb 2026 00:06:43 +0100 (CET)
Date: Tue, 3 Feb 2026 00:06:43 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Brian Witte <brianwitte@mailfence.com>, netfilter-devel@vger.kernel.org,
	kadlec@blackhole.kfki.hu
Subject: Re: [PATCH nf-next] netfilter: nf_tables: use dedicated mutex for
 reset operations
Message-ID: <aYEt98DPnGV4v7IE@strlen.de>
References: <20260127030604.39982-1-brianwitte@mailfence.com>
 <aXlTpuk0Z1CeoYwT@strlen.de>
 <aYEsrZpkqCb675vv@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYEsrZpkqCb675vv@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Jan 28, 2026 at 01:09:10AM +0100, Florian Westphal wrote:
> > Brian Witte <brianwitte@mailfence.com> wrote:
> > Maybe its worth investigating if we should instead protect
> > only the reset action itself, i.e. add private reset spinlocks
> > in nft_quota_do_dump() et al?
> 
> Last time we discussed this:
> 
> - There was an attempt to make reset fully atomic (for the whole
>   ruleset), which is not really possible because netlink dumps for a
>   large ruleset might not fit into, not worth trying.
> 
> - Still, there could be two threads resetting the counters at the same
>   time, and someone mentioned underrun is possible.
> 
>   Looking at last for nft_quota, it should be possible to use
>   atomic64_xchg():

Yep, agree, some .dump callbacks can probably be reworked
to use atomic ops for the reset case.

> Then, for nft_counter, it is a bit more complicated, maybe a per-netns
> spinlock for counters is sufficient, to protect this
> nft_counter_do_dump() when the reset flag is true.

Yes, a per-netns spinlock for reset serialization inside the dumper
callbacks is what we discussed, I think its the way to go.
