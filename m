Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8433BF2FE;
	Thu, 15 Jan 2026 17:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496845; cv=none; b=OUvo2GH3loJ68oTu+h5dm6MyyGX84yxXbZXRDWOMaZqww1X+6Bj0aID/7F9zIRBThPLq32UkoAiBEwZTSNV5vqUKUE6jLe3yYB3wlLo1yF6lqJm+38+IJPJ7I1zyNnbwjZn53NsronPxMt8zK+MfwVdYMcX/G5CbK7X8XSuiYP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496845; c=relaxed/simple;
	bh=Y5bCUzwpR7yHK2M2CwdzEcqkSnHX5QkN2HJ2y+FYJck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AXksb2NyBvClUVEx+RHsccTrN7e7LgeJjXvOckTZhPxLhe0ZipiW/PTqGrx/iSQNGzpDWgacq4qUX/4U3ssKsrMvG4dUi6D1zh8J9z1C91THeqXnZstI0I3Ygls5CZpg18nMUNu9ddhNT7TDzcdoLwb1GMtb/20bNMapMO8rgpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D3A9E606D9; Thu, 15 Jan 2026 18:07:08 +0100 (CET)
Date: Thu, 15 Jan 2026 18:07:03 +0100
From: Florian Westphal <fw@strlen.de>
To: Scott Mitchell <scott.k.mitch1@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, kadlec@netfilter.org,
	phil@nwl.cc, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzbot@syzkaller.appspotmail.com
Subject: Re: [PATCH v5] netfilter: nfnetlink_queue: optimize verdict lookup
 with hash table
Message-ID: <aWketzn78tzo5anB@strlen.de>
References: <20251122003720.16724-1-scott_mitchell@apple.com>
 <aWWQ-ooAmTIEhdHO@chamomile>
 <CAFn2buDeCxJp3OHDifc5yX0pQndmLCKc=PShT+6Jq3-uy8C-OA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFn2buDeCxJp3OHDifc5yX0pQndmLCKc=PShT+6Jq3-uy8C-OA@mail.gmail.com>

Scott Mitchell <scott.k.mitch1@gmail.com> wrote:
> > > +     NFQA_CFG_HASH_SIZE,             /* __u32 hash table size (rounded to power of 2) */
> >
> > This should use the rhashtable implementation, I don't find a good
> > reason why this is not used in first place for this enhancement.
> 
> Thank you for the review! I can make the changes. Before implementing,
> I have a few questions to ensure I understand the preferred approach:
> 
> 1. For the "perns" allocation comment - which approach did you have in mind:
>   a) Shared rhashtable in nfnl_queue_net (initialized in
> nfnl_queue_net_init) with key={queue_num, packet_id}
>   b) Per-instance rhashtable in nfqnl_instance, with lock refactoring

You could also go with c), single rhashtable created at module init
time, like what af_netlink.c is doing.

hash and compare function would then have to include struct net *
in the hash and the compare.

b) makes no sense; if you do the lock refactoring to also allow
   GFP_ACCOUNT you could also keep the existing hashtable approach,
   I think.

> 2. The lock refactoring (GFP_ATOMIC → GFP_KERNEL) is independent of
> the hash structure choice, correct? We could fix that separately?

Not needed if you go with a) or c).

> 3. Can you help me understand the trade-offs you considered for
> rhashtable vs hlist_head? Removing the API makes sense, and I want to
> better understand how to weigh that against runtime overhead (RCU,
> locks, atomic ops) for future design decisions.

I think for this not using rhashtable is fine, but as-is the patch would
allow almost unlimited memory consumption due to ability to create 64k
queues.
