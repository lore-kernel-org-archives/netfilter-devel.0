Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE2D27453
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Mar 2025 02:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741229435; cv=none; b=YYBdL5QoMBkDbihKH1cG7giBYE2MoqOV6IDQjkJRUcwe3MFS7EHUs1RAG2Qnurw+LN7/H0kMKeVgwddu0MhHOVaL9ynLnSk8AqwHTweaeB6HH6QqRx6RdM3G8qemKB9yuI2owuHvdlWuCBxtVq4FCfsbnNc54oiz4uTE5LIjgzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741229435; c=relaxed/simple;
	bh=SPMgeudM2Z/aF4hhjpph/cta+JaTNR8tTXf1d2AVxbk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UKCbY1hZ9iBS4Mf4eFLvpWKtqocr5tyK6Lepk97dPSuyd8W5QzIwsZoFavye2AAA+YjPDuy/yyfuCcU+vx89w5N3GEtEAKmNvlbWRv1VZXwNulXoMU/qlSOw/Y7i3qrY95NtDyJa8bfLZlo+3v8ebIUr7+OzAokJibLk7BfDT5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tq1Jf-0006KN-0J; Thu, 06 Mar 2025 03:50:31 +0100
Date: Thu, 6 Mar 2025 03:50:30 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	syzbot+5d8c5789c8cb076b2c25@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: nf_tables: make destruction work queue
 pernet
Message-ID: <20250306025030.GB23740@breakpoint.cc>
References: <20250304115706.2566960-1-fw@strlen.de>
 <Z8jLZv6asBnqrniC@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8jLZv6asBnqrniC@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >  	mutex_unlock(&nft_net->commit_mutex);
> > +
> > +	cancel_work_sync(&nft_net->destroy_work);
> 
> __nft_release_tables() is called in this nf_tables_exit_net()
> function, cancel_work_sync() needs to be called before it?

Yep, thanks.  Will fix in v2.

> > @@ -12029,10 +12036,8 @@ static void __exit nf_tables_module_exit(void)
> >  	unregister_netdevice_notifier(&nf_tables_flowtable_notifier);
> >  	nft_chain_filter_fini();
> >  	nft_chain_route_fini();
> > -	nf_tables_trans_destroy_flush_work();
> 
> My understanding is that this is not required anymore because of the
> new cancel_work_sync() in the exit_net() path?

Right, the flush now needs to be done in exit_net and it happens
as part of the cancel_work_sync call.

