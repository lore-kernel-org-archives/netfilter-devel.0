Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6380318B9E;
	Tue,  3 Feb 2026 16:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770137972; cv=none; b=UNO7JfkCgdzIiEGv3lH1sCqJGMJoe62boc1/5ANEg0b57D4v0pwAGPY5WyczpDK/uxsYCAaluQw2U3uVzZmBBXwrBpG+zFNTGqPKKYI99Km+5LW0+NDXyIjmmOxSbMgnwWAoKmELcp5MxRPPlEkHJfNGjN4SYo228kKXZ43HqUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770137972; c=relaxed/simple;
	bh=gsK9eh3/Ap3QzALZiIhqbj7KY1hIztJ1M9Xdd3pfZvA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jy3+cZqFP+CRpKptJ/+L8d4u01hMrXHXpyX3Zs0zAKWiaNYwSx5ghCFpoJ8lcJrPKfjIzlYUHVPjm4/AKNScle74+jNT7JQtNuW18fBUG0FsFQmCwuNxfZ26JG7f4E4u3N92HaQjDwQsyQvEwufgV2r9s2REUEa3nT5+rXzh3kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 95F5960345; Tue, 03 Feb 2026 17:59:28 +0100 (CET)
Date: Tue, 3 Feb 2026 17:59:28 +0100
From: Florian Westphal <fw@strlen.de>
To: sun jian <sun.jian.kdev@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] netfilter: amanda: fix RCU pointer typing for
 nf_nat_amanda_hook
Message-ID: <aYIpcHBufnxrcv5O@strlen.de>
References: <20260203080109.2682183-1-sun.jian.kdev@gmail.com>
 <20260203145511.164485-1-sun.jian.kdev@gmail.com>
 <aYIOXk55_DRFKCqo@strlen.de>
 <CABFUUZG9LnhXc+nsQA28WHiiT33_5wQ82E1bBSBncWkxkXaKZA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABFUUZG9LnhXc+nsQA28WHiiT33_5wQ82E1bBSBncWkxkXaKZA@mail.gmail.com>

sun jian <sun.jian.kdev@gmail.com> wrote:
> > Sun Jian <sun.jian.kdev@gmail.com> wrote:
> > >  enum amanda_strings {
> > > @@ -98,7 +98,12 @@ static int amanda_help(struct sk_buff *skb,
> > >       u_int16_t len;
> > >       __be16 port;
> > >       int ret = NF_ACCEPT;
> > > -     typeof(nf_nat_amanda_hook) nf_nat_amanda;
> > > +     unsigned int (*nf_nat_amanda)(struct sk_buff *skb,
> > > +                                   enum ip_conntrack_info ctinfo,
> > > +                                   unsigned int protoff,
> > > +                                   unsigned int matchoff,
> > > +                                   unsigned int matchlen,
> > > +                                   struct nf_conntrack_expect *exp);
> >
> > Why is that needed?
> Correct. Manual declaration is indeed verbose.
> 
> The reason I used it was that typeof(nf_nat_amanda_hook) carries over
> the __rcu attribute to the local variable, which triggers a Sparse
> warning when assigning the result of rcu_dereference().

sparse doesn't generate such a warning for me.

Also, this pattern you are changing here isn't specific to amanda, it
exists elsewhere as well:

net/netfilter/nf_conntrack_snmp.c:42:23: error: incompatible types in comparison expression (different address spaces):
net/netfilter/nf_conntrack_tftp.c:78:31: error: incompatible types in comparison expression (different address spaces):
net/netfilter/nf_conntrack_irc.c:242:38: error: incompatible types in comparison expression (different address spaces):
net/netfilter/nf_conntrack_ftp.c:521:22: error: incompatible types in comparison expression (different address spaces):

so why only fix this annotation for amanda?
