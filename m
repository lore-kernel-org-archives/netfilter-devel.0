Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B648518732B
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Dec 2024 16:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733933780; cv=none; b=VWtSPjbQkyrDG4sob/YK7IzdaKG9Z0yb/HkpVKakYUPYgxcSRQOv5INmHYizloFHDMLy6kZ0yh6K4N9UVYcdV5m84cO/1970CV0SD60XV/seNHn30lrPbIfGTwbMt6haLXiPoVfkU4W8hIq9jpvhZqqSftwGZ2Qn4bmdK1TLmYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733933780; c=relaxed/simple;
	bh=Qp8KKsLc0BpWvgZ0ofanG8CabL9otiGQurPseJDnJ2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ELCM1HKt8yjbO7/fmOX68YunKZIvb3qFXq6qxLTMMWXAoBuLZfJpcgYepzhe40JnVDNkzXpLTxG9loRh5ecc5TKTuJ4C5djo9W/sCUj81VjWlz8M0u3CQo73RYv+j00dMa5t2vlune2UVocB/RnQgBlhMI32pgesa69z3WJ7wnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.39.247] (port=51988 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tLPNk-00Dk60-05; Wed, 11 Dec 2024 17:16:14 +0100
Date: Wed, 11 Dec 2024 17:16:11 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	syzkaller-bugs@googlegroups.com,
	syzbot+b26935466701e56cfdc2@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: nf_tables: do not defer rule destruction
 via call_rcu
Message-ID: <Z1m6y9dQs3d0Mff3@calendula>
References: <67478d92.050a0220.253251.0062.GAE@google.com>
 <20241207111459.7191-1-fw@strlen.de>
 <Z1dgtm5IhoJW5vGL@calendula>
 <20241209220401.GA4709@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241209220401.GA4709@breakpoint.cc>
X-Spam-Score: -1.9 (-)

Hi Florian

On Mon, Dec 09, 2024 at 11:04:01PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > One way would be to allocate nft_trans_rule objects + one nft_trans_chain
> > > object, deactivate the rules + the chain and then defer the freeing to the
> > > nft destroy workqueue.  We'd still need to keep the synchronize_rcu path as
> > > a fallback to handle -ENOMEM corner cases though.
> > 
> > I think it can be done _without_ nft_trans objects.
> > 
> > Since the commit mutex is held in this netdev event path: Remove this
> > basechain, deactivate rules and add basechain to global list protected
> > with spinlock, it invokes worker. Then, worker zaps this list
> > basechains, it calls synchronize_rcu() and it destroys rules and then
> > basechain. No memory allocations needed in this case?
> 
> I don't think its possible due to netlink dumps.
> 
> Its safe for normal commit path because list_del_rcu() gets called on
> these objects (making them unreachable for new dumps), then,
> synchronize_rcu is called (so all concurrent dumpers are done) and then
> we free.
> 
> It would work if you add a new list_head to the basechain, then you
> could just link the basechain object to some other list and then
> call nf_tables_rule_release() AFTER a synchronize_rcu because rules
> can't be picked up if the owning chain is no longer reachable.
> 
> However, I do wonder how complex it would be.

I started a patch, spent several hours in a row, but I need more time
to get this right.

There is also Phil making the line to remove this in nf-next.

> This is tricky to get right and I'm not sure this patch adds a
> noticeable issue, see nft_rcv_nl_event() which has similar pattern,
> i.e. synchronize_rcu() is called.

I can see veth hits synchronize_rcu(), this can be called from
default_device_exit_batch() which calls unregister_netdevice_many().

I need time, but it is difficult. We have to deliver a pull request
very late on wednesday so it can be taken on thursday.

Now the week has three days to fix and test stuff, so upstream
maintainers have a day to tidy up and submit upstream.

> I'm not saying we should not consider async route, but maybe better
> to followup in -next?

Yes, I can follow up in -next, but then Phil just remove this again in
-next.

I can just take this fix to address the existing situation which is
worse than before. Before this patch UAF was possible, although I
never manage to trigger it. Now crash is easy to trigger, I spent too
much time looking at the interaction with layers and I forgot basic
assumption regarding nf_tables in this patch.
