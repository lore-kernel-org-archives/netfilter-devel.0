Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D687E105
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Jan 2026 00:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768782127; cv=none; b=SH0XhNk0CLsLxwbCuJ+aSy45aMcdt7W3ksPMTcWfYAgIxfSPuAhptN/OjRTVxE1qB5H/i3WsdPvSc2ZnlKNBcjLoRTGzHdmvsloX8uRTJy1rktBfkmqOECn5NCKMmnCYeHmGwlVfV+w6w5ju7xiM7jPGkgW3+4sEfQ2BPQsSvaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768782127; c=relaxed/simple;
	bh=Ph3hv64ogeoRwhwhI6U6XSxrviMtfzOiFBAWT816qw8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=au5GqrvAxLND2jdixf+PHGZdjpkpvc+Dy/LoYUI9O3Npr4LQVlRFMt41JewsJ0ZYgTMg44NfiJbSAcj/HI07qEVxz/1I6RcU3jtrIMcXkS0yHbriCiV4bLaCbtoOaGkjlz1WCMAqHQGCJKju5arq/L7RogMEIRrqPWHMCUhGx80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 77DB6602D9; Mon, 19 Jan 2026 01:21:56 +0100 (CET)
Date: Mon, 19 Jan 2026 01:21:51 +0100
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	pablo@netfilter.org, phil@nwl.cc,
	Michal Slabihoudek <michal.slabihoudek@gooddata.com>
Subject: Re: [PATCH nf-next] netfilter: nf_conncount: fix tracking of
 connections from localhost
Message-ID: <aW15H8M9tjLRHSED@strlen.de>
References: <20260118111316.4643-1-fmancera@suse.de>
 <aWzQoFTl6Cf4Vt3T@strlen.de>
 <db94e3de-d949-449f-aabb-75de17ee6d21@suse.de>
 <aW0EZPoM60XTy6kJ@strlen.de>
 <7d24517c-1209-49cc-a9cc-26eaf1a0e49e@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d24517c-1209-49cc-a9cc-26eaf1a0e49e@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> After a quick test, it works for local connections. Although it doesn't 
> work for reverse-connlimit on INPUT. Consider the following ruleset:
> 
> iptables -I INPUT -p tcp --sport 80 --tcp-flags FIN,SYN,RST,ACK SYN -m 
> connlimit --connlimit-above 100 -j LOG --log-prefix "Exceeded limit 
> established connections to 443"

Mhh, what is that supposed to do?

'sport 80' meaning that we're client and we're receiving back a syn/ack?
The rule only matches syn packets.

I'm confused what this should accomplish.

> To clarify this is the diff:
> 
> diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
> index 5588cd0fcd9a..339aaf5e3393 100644
> --- a/net/netfilter/nf_conncount.c
> +++ b/net/netfilter/nf_conncount.c
> @@ -182,7 +182,7 @@ static int __nf_conncount_add(struct net *net,
>                  /* connections from localhost are confirmed almost 
> instantly,
>                   * check if there has been a reply
>                   */
> -               if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
> +               if (skb->skb_iif != 1) {
>                          err = -EEXIST;
>                          goto out_put;
>                  }
> 
> I will send a V2 and ask for testing from Michal if possible.

Thanks!  connlimit is very old and there is no formal spec as
to what its supposed to do, so I supsect we should try to at least
fix the reported regression.   I'm fine with both approaches
(REPLY and iif test), but the iif one would be 'better' in the sense
that its a clear workaround for the more shady corner case :-)

Would you mind updating the comment was well to explain that
this is related to loopback traffic, with conncount sitting
in prerouting and thus after conntrack confirmation?

Thanks!
