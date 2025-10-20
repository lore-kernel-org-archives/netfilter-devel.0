Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2915A2EFDA0
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2025 22:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760998106; cv=none; b=kU+u9wzcqgFS0KVbwjrKoBfYy2OQTnLWbo9GO0KwXEZ0qX+wYCUcSwE+X/hdcR0jYBbXuGUUxVqYopZeM+ORV8E3ZJ8yPSXZbPwyzn9kcmax3hvnXLTIIdtkEKStK90E45Q+7oBMhRXWgQtWkvj7fVdZYUOl9HsiKNJFrpqM/xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760998106; c=relaxed/simple;
	bh=xNwz35VeXmweKFOtwmBNgSVHa1NRQoto/1OwK8pDD4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QYSmSLIo+JwfNMwZe5U6+a/YqOyHbX7sBFpN/Lb1wSTbV3gL+uekAEfYJ2bljI4IlbjQoOO+838ShiQFqOcRfKQWQ7t7iycs/s5M6ObHZHOk5Bw0xWpUXJiTqhE90o4Bsy8EkZApknbHiUGgwisRu4jDYM/1CFqo6GLypcZsgPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C795D6109E; Tue, 21 Oct 2025 00:08:21 +0200 (CEST)
Date: Tue, 21 Oct 2025 00:08:21 +0200
From: Florian Westphal <fw@strlen.de>
To: Antonio Ojea <aojea@google.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Eric Dumazet <edumazet@google.com>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] selftests: nft_queue: conntrack expiration requeue
Message-ID: <aPay1RM9jdkEnPbM@strlen.de>
References: <20251020200805.298670-1-aojea@google.com>
 <aPah2y2pdhIjwHBU@strlen.de>
 <CAAdXToT14bjkvCrP=tG4V4XJhhyGMfuJz+FdfTO+xJ10Z-RezA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAdXToT14bjkvCrP=tG4V4XJhhyGMfuJz+FdfTO+xJ10Z-RezA@mail.gmail.com>

Antonio Ojea <aojea@google.com> wrote:
> yeah, sorry, as you say, I meant disabled
> 
> > > state. Setting the conntrack entry timeout to 0 allows to remove the state
> > > and the packet is sent to the queue.
> >
> > But its the same as --delete, entry gets tossed (its timed out) and is
> > re-created from scratch.
> >
> 
> The behavior is not the same as deleting the entry, I tried both and
> only works by setting the timeout, I tried to follow the codepath but
> I'm very unfamiliar with the codebase to understand why delete is
> different from updating with timeout 0.

It should be the same.

Only difference:

ctnetlink delete zaps entry right away, timeout-0 zaps it on the next
(matching) packet or when gc finds the entry (or on next conntrack -L),
whatever comes first.

> > That zaps the entry and re-creates it, all state is lost.
> > Wouldn't it make more sense to bypass based on connmark or ctlabels?
> 
> This simplifies the datapath considerably and avoids the risk of
> having to coordinate marks with other components, but there is also
> some ignorance on my side on how to use all netfilter features
> efficiently.
> 
> The use case I have is to only process the first packet of each
> connection in user space BUT also be able to scan the conntrack table
> to match some connections that despite being established I want to
> reevaluate only once, so I have something like:

> ct state established,related accept
> queue flags bypass to 98

Understood.

> And then I scan the conntrack table, and for each flow I need to
> reevaluate once , I just reset the timeout and it ignores the rule "ct
> state established,related accept" , then if the verdict is accepted it
> keeps skipping the queue.

Yes, but thats because the packet that hits the timed-out flow zaps it
and is 'new' (for tcp_loose=1).

> However, if there is a more elegant way that does not depend on this
> "hack" please let me know
> Can I apply a connmark or ctlabel via netlink in an existing flow?

Yes, bypassing nfqueue was the original use-case that prompted the
connlabel feature.

> If so, how to make it so it only is enqueued once, do I need to mark
> and unmark the flow?

There are several ways to do what you want.

You can add a 'requeue' named set:
   ct id @myset queue ...

and then add/remove from that set to (re)enable via userspace.

Or you can use opt-in (or out, its simpler) via mark or label:
  ct state new ct label set shouldqueue ...
  ct label shouldqueue queue ...

or, without need to set initial state:
  ct label ! "wasqueued" queue ...

... and then use ctnetlink to set the label (or clear it).

Or, set/clear the label from the nfqueue program itself when setting accept
verdict (via nested NFQA_CT + CTA_MARK/LABELS).

Same with connmark, but I know that this might be impossible
due to those being used for policy routing etc.

> > I'm not sure what the test is supposed to assert.
> >
> > That setting timeout via ctnetlink to 0 kicks the entry out of the ct hash?
> 
> The behavior I'd like to assert is if this behavior is just some side
> effect I found or something it will be "stable" , since I'm trying to
> build the firewall on this behavior and if changes it will be very
> disruptive

Setting the timeout to 0 zaps the entry at earliest opportunity,
it will not be "reactivated" on next packet, its just
conntrack --delete with minor random delay.
