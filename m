Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD97153835
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Jul 2024 22:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719872315; cv=none; b=b8Znv49a3bqfWCg5GB0WgigtJplQO1wkY0UIER8sK2q1dlT+iNJdRVDkkVMHMiiwn+nF3UA7eq2K5y3OVSq7TiGt0+PwTE9Eyo18sQBLhXTJhdwZzsmkHh/DHRPBM0Noq0JyfQvjT1T0o8xdO3MuaFyC9awf7pRz+NzzJE71bkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719872315; c=relaxed/simple;
	bh=xELfvWRRJCNsH4qdndrXO2yedifvAyoFa49xkhH3bOk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G6XWb8y6izCnUbMpGadT9XU8NcKSbjTELPnuacuI9KqD1orMg1YCbRBl6lzaozfqqCSL3/lHhJcbvRKBGzyhc4eejmDMuPQf0Nu69m/IXet47LqSohKbXEykV+x+GRV6wgnhGV9RREYw7B0ScJfBUKQq00s5xD8Pv9sCA5v3QAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sOPLy-0002vm-3I; Tue, 02 Jul 2024 00:18:30 +0200
Date: Tue, 2 Jul 2024 00:18:30 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [RFC nf-next 3/4] netfilter: nf_tables: insert register zeroing
 instructions for dodgy chains
Message-ID: <20240701221830.GB11142@breakpoint.cc>
References: <20240627135330.17039-1-fw@strlen.de>
 <20240627135330.17039-4-fw@strlen.de>
 <ZoMR2SKHjHJIb1eN@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZoMR2SKHjHJIb1eN@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > I would not add this patch and keep the reject behaviour, as the
> > nftables uapi is specifically built around the rule being a standalone
> > object.  I also question if it makes real sense to do such preload from
> > userspace, it has little benefit for well-formed (non-repetitive) rulesets.
> 
> I am afraid there won't be an easy way to revert this in this future?
> 
> Is there any specific concern you have? Buggy validation allowing to
> access uninitialized registers? In that case, there is a need to
> improve test infrastructure to exercise this code more.

Yes, for one thing, but I also do not see how we can ever move to a
model where registers are re-used by subsequent rules, its incompatible
with the rule-is-smallest-replaceable-object design.

(Meaning: userspace needs to be fully cooperative and aware that
 it cannot insert a random rule at location x).
