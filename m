Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EA384FA0;
	Mon,  8 Jul 2024 14:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720447949; cv=none; b=dQsDI2AaN5T//jCvQ1lSaqbW0WR4t22L50Vp3f8Qd1OXIz23I21WokXoYeLRqT1wY8WZKdUDR8MtCVDxxEA8FT4OyWTg0fuubbkHQQ/icXatQfhAeiCxgjeWUGP51qE7u84m0SBmK7JJGPM7Vo1vXcm0mSOvY1LFQzKecyDcQAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720447949; c=relaxed/simple;
	bh=LLpg0T+VHX0EmEi5jcvfsJM7Nmdg3e6rcc+656CDa8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eFOETrCh/ldfbH1EBtNh4ioHLIFltOtVdvVtatqOpAxi+hKbkdFxeRkZBDNO4VLh2TNk8DD0ldM2eaiH30lbCZStL6EmaEKOvGyFRLzHDp9epoBF6xN/W9S9a+10wLhwQDMRvYPF4APwgOIg0IBBa3fZTg0NFrx58mDFxhiGp6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sQp66-0001V5-Uq; Mon, 08 Jul 2024 16:12:06 +0200
Date: Mon, 8 Jul 2024 16:12:06 +0200
From: Florian Westphal <fw@strlen.de>
To: yyxRoy <yyxroy22@gmail.com>
Cc: fw@strlen.de, 979093444@qq.com, coreteam@netfilter.org,
	davem@davemloft.net, edumazet@google.com,
	gregkh@linuxfoundation.org, kadlec@blackhole.kfki.hu,
	kuba@kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	pabeni@redhat.com, pablo@netfilter.org
Subject: Re: [PATCH] netfilter: conntrack: tcp: do not lower timeout to CLOSE
 for in-window RSTs
Message-ID: <20240708141206.GA5340@breakpoint.cc>
References: <20240706170432.GA7766@breakpoint.cc>
 <20240708085940.300976-1-979093444@qq.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240708085940.300976-1-979093444@qq.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

yyxRoy <yyxroy22@gmail.com> wrote:
> On Fri, 5 Jul 2024 at 17:43, Florian Westphal <fw@strlen.de> wrote:
> > Also, one can send train with data packet + rst and we will hit
> > the immediate close conditional:
> > 
> >    /* Check if rst is part of train, such as
> >     *   foo:80 > bar:4379: P, 235946583:235946602(19) ack 42
> >     *   foo:80 > bar:4379: R, 235946602:235946602(0)  ack 42
> >     */
> >     if (ct->proto.tcp.last_index == TCP_ACK_SET &&
> >         ct->proto.tcp.last_dir == dir &&
> >         seq == ct->proto.tcp.last_end)
> >             break;
> > 
> > So even if we'd make this change it doesn't prevent remote induced
> > resets.
> 
> Thank you for your time and prompt reply and for bringing to my attention the case
> I had overlooked. I acknowledge that as a middlebox, Netfilter faces significant
> challenges in accurately determining the correct sequence and acknowledgment
> numbers. However, it is crucial to consider the security implications as well.

Yes, but we have to make do with the information we have (or we can
observe) and we have to trade this vs. occupancy of the conntrack table.

> For instance, previously, an in-window RST could switch the mapping to the
> CLOSE state with a mere 10-second timeout. The recent patch, 
>  (netfilter: conntrack: tcp: only close if RST matches exact sequence),
> has aimed to improve security by keeping the mapping in the established state
> and extending the timeout to 300 seconds upon receiving a Challenge ACK.

be0502a3f2e9 ("netfilter: conntrack: tcp: only close if RST matches
exact sequence")?

Yes, that is a side effect.  It was about preventing nat mapping from going
away because of RST packet coming from an unrelated previous connection
(Carrier-Grade NAT makes this more likely, unfortunately).

I don't know how to prevent it for RST flooding with known address/port
pairs.

> However, this patch's efforts are still insufficient to completely prevent attacks.
> As I mentioned, attackers can manipulate the TTL to prevent the peer from
> responding to the Challenge ACK, thereby reverting the mapping to the
> 10-second timeout. This duration is quite short and potentially dangerous,
> leading to various attacks, including TCP hijacking (I have included a detailed 
> report on potential attacks if time permits). 
> else if (unlikely(index == TCP_RST_SET))
>        timeout = timeouts[TCP_CONNTRACK_CLOSE];
> 
> The problem is that current netfilter only checks if the packet has the RST flag
> (index == TCP_RST_SET) and lowers the timeout to that of CLOSE (10 seconds only).
> I strongly recommend implementing measures to prevent such vulnerabilities.

I don't know how.

We can track TTL/NH.
We can track TCP timestamps.

But how would we use such extra information?
E.g. what I we observe:

ACK, TTL 32
ACK, TTL 31
ACK, TTL 30
ACK, TTL 29

... will we just refuse to update TTL?
If we reduce it, any attacker can shrink it to needed low value
to prevent later RST from reaching end host.

If we don't, connection could get stuck on legit route change?
What about malicious entities injecting FIN/SYN packets rather than RST?

If we have last ts.echo from remote side, we can make it harder, but
what do if RST doesn't carry timestamp?

Could be perfectly legal when machine lost state, e.g. power-cycled.
So we can't ignore such RSTs.

> For example, in the case of an in-window RST, could we consider lowering
> the timeout to 300 seconds or else?

Yes, but I don't see how it helps.
Attacker can prepend data packet and we'd still move to close.

And I don't really want to change that because it helps to get rid
of stale connection with real/normal traffic.

I'm worried that adding cases where we do not act on RSTs will cause
conntrack table to fill up.
