Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D39436355;
	Wed, 21 Jan 2026 22:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769033126; cv=none; b=LQSge2+sE8Plnf8LD6FFbzi5DM03LLgS2eVUVZdmi3V1k2oJfGLrx58C/SS4+8kzGFfMQuZnKJzp0eN2+dr9ebnOxR/AYAOEJO/7bS/pRY8N12St/HyWjAcP3jEeGrYNm7L3OQeOKEwl1VF4EuCxvoWENPTkdliofWZOyyKQ4fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769033126; c=relaxed/simple;
	bh=LuTw8y90YApXhD/F4Zf/Rauzp1AiSIsi2AsfoS1T+no=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rzmGf3LoHyS/fsMXVoQG9OhvGrVPuyHCbMFJ71ATKbj5t+zUFQzhDfH3MIgwB0+dmR/E7BKV28MLY4Zrr6weFcdjgbO3rrOF2/2iaNhl46GHDMzsCEdlrkPkTNUdNJru/k0PpYrL04xBEjh9vT8zE2iQ1WIXos9Rh+xlIPrAzQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4402B604E3; Wed, 21 Jan 2026 23:05:21 +0100 (CET)
Date: Wed, 21 Jan 2026 23:05:21 +0100
From: Florian Westphal <fw@strlen.de>
To: Simon Horman <horms@kernel.org>
Cc: Kshitiz Bartariya <kshitiz.bartariya@zohomail.in>,
	Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: arptables: use xt_entry_foreach() in
 copy_entries_to_user()
Message-ID: <aXFNoRjTS71iqDDQ@strlen.de>
References: <20260119063704.12989-1-kshitiz.bartariya@zohomail.in>
 <aXERRqh79pmVsuzk@horms.kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXERRqh79pmVsuzk@horms.kernel.org>

Simon Horman <horms@kernel.org> wrote:
> On Mon, Jan 19, 2026 at 12:07:04PM +0530, Kshitiz Bartariya wrote:
> > Replace the manual offset-based iteration with xt_entry_foreach(),
> > thereby removing FIXME. The byte offset semantics and user ABI
> > are preserved.
> > 
> > Signed-off-by: Kshitiz Bartariya <kshitiz.bartariya@zohomail.in>
> > ---
> >  net/ipv4/netfilter/arp_tables.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
> > index 1cdd9c28ab2d..9f82ce0fcaa5 100644
> > --- a/net/ipv4/netfilter/arp_tables.c
> > +++ b/net/ipv4/netfilter/arp_tables.c
> > @@ -684,12 +684,11 @@ static int copy_entries_to_user(unsigned int total_size,
> >  
> >  	loc_cpu_entry = private->entries;
> >  
> > -	/* FIXME: use iterator macros --RR */
> > -	/* ... then go back and fix counters and names */
> > -	for (off = 0, num = 0; off < total_size; off += e->next_offset, num++){
> > +	num = 0;
> > +	xt_entry_foreach(e, loc_cpu_entry, total_size) {
> >  		const struct xt_entry_target *t;
> >  
> > -		e = loc_cpu_entry + off;
> > +		off = (unsigned char *)e - (unsigned char *)loc_cpu_entry;
> 
> This offset calculation makes me feel queasy.
> 
> Can the code start with off = 0 and increment it by e->next_offset
> as the loop iterates, as was the case before this patch?
> It would be similar to how num is handled.

I think this file should just be left alone resp. should be restricted
to bug fixes only.  Same for ip/ip6/ebtables.

Its too early to remove this file from the tree, but I don't see
value in making cosmetic improvements, sorry.
