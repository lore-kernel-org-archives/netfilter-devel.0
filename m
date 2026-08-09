Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81BAC26A08A
	for <netfilter-devel@vger.kernel.org>; Sun,  9 Aug 2026 13:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786282599; cv=none; b=d0OfsHZum6z6OlX17Wi6Tus6kvb/Ic3DYhy6tmXwC0ufvu3f+Yz+3sGCqIP1IZAWs1Eapde1drRauEmat5VY2/kyVVJwTrmx67gXHEKjfrxR5WCGY7bXUiMcgKVyTr12XofXx1EZ2Dshxx5LWVniM0ejJJguMY3WKXPyorbHznU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786282599; c=relaxed/simple;
	bh=jVbLfLHcAzGiYI5qOtvUpbvSgDblk+xeaLDnIxP+YZM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=WdWkLfyRpjahrHiIHaEOFomCR8MFS8f0ij5bXygIXBbObuLRvq9XeoWFt7xIOv7JpCmFWbAlh0ij2sK/Ge+IceYUl2iafqGN3Yqp8UfkURjtZLIbSLY793IrXaUJfmOXdEIZOD2b1mVVO10CdR+/XUGWCiCZOXB1V2V1YJHakdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4hHzSM4hcfz7s7wb;
	Sun, 09 Aug 2026 15:36:35 +0200 (CEST)
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id E0Taa4Ruvvhm; Sun,  9 Aug 2026 15:36:33 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (78-131-74-220.pool.digikabel.hu [78.131.74.220])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp2.kfki.hu (Postfix) with ESMTPSA id 4hHzSK4kHXz7s7wZ;
	Sun, 09 Aug 2026 15:36:33 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 7BB6E140E07; Sun,  9 Aug 2026 15:36:33 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 77DC5140986;
	Sun,  9 Aug 2026 15:36:33 +0200 (CEST)
Date: Sun, 9 Aug 2026 15:36:33 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Florian Westphal <fw@strlen.de>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf v4] netfilter: ipset: remove need to allocate memory
 on delete operations operations
In-Reply-To: <anXipjQLvKUmiIYF@strlen.de>
Message-ID: <8cf7c661-5058-9e3d-30ba-1c0f2695b168@netfilter.org>
References: <20260807002808.20075-1-fw@strlen.de> <anXipjQLvKUmiIYF@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Hi Florian,

On Fri, 7 Aug 2026, Florian Westphal wrote:

> Florian Westphal <fw@strlen.de> wrote:
> > +		write_seqcount_end(&nets->seq);
> > +		spin_unlock_bh(&set->lock);
> >  	}
> >  #endif
> >  }
> > @@ -1253,31 +1310,41 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
> >  #if IPSET_NET_COUNT == 2
> >  	struct net_prefixes *nets1;
> >  	struct mtype_elem orig = *d;
> > +	unsigned int seq1;
> >  	int ret, i, j, k;
> >  #else
> >  	int ret, i, j;
> >  #endif
> > -	u32 key, multi = 0;
> > +	unsigned int seq0;
> > +	u32 key, multi;
> >  	u8 pos;
> >  
> >  	pr_debug("test by nets\n");
> >  	rcu_read_lock_bh();
> > +retry:
> > +	multi = 0;
> >  	nets0 = rcu_dereference_bh(h->rnets[0]);
> > +	seq0 = read_seqcount_begin(&nets0->seq);
> [..]
> >  unlock:
> > +	if (read_seqcount_retry(&nets0->seq, seq0))
> > +		goto retry;
> 
> Sashiko now says this retry loop causes double-count on match, yet v3 
> said not doing this causes possible miss of a nomatch entry.
> 
> I think missing nomatch entry is worse and doublecount is ok.
> 
> The restart is rare enough anyway because write_seqcount_begin() is only 
> called when set is flushed or a element deletion brings a cidr count 
> value down to 0.

Yes, exactly. [Somehow flush seems to "ask" to create a new empty set, 
switch to it and release the old one after, but then again, we might be 
out of memory to allocate.]
 
> Another option is to prellocate all possible CIDRs but I'd like to avoid 
> it, this means checking up to 128 possible CIDRs in ipv6 case.
> 
> Pre-sampling all values into local on-stack array is a non-starter too 
> due to stack cost.
> 
> What one COULD do is to use pcpu stash area for this, needs local bh / 
> local_lock.

I was thinking on pcpu as well: keep preallocated max size "struct 
net_prefixes" per cpu, signal end of lookup by the zero count value of 
"struct net_prefix". But then we'd just keep a lot of stash areas. But the 
arrays are not huge - I refrained to use linked lists both because struct 
net_prefix is small and also to count on the prefetching of the array 
elements.

> But I think its a bit "too much" for this problem.

Best regards,
Jozsef
-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
