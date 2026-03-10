Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4713D47A2;
	Tue, 10 Mar 2026 12:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773146009; cv=none; b=IyLmIn1tW2t8hUCKx9K7K5U/erti4cQ6q0rE19bzwlj0pevnMkQz/9BAtFU/ie5HFDOsoR3JLIZSWJBTIDQbHN8iK0wChR67kvVXoCuZ5/PwGcLv9u3eCv9i/mlDuLphd97vAt1hqqvAkm4sSZOGB1Gcu4WTcBIBMnlSmbL2KRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773146009; c=relaxed/simple;
	bh=YkfpishWw5v2wYEjjJuA0hAqEVcBUj0se89FfkOjNNE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A6RX5Mml2dOKJVv/VeHefagsMBkAPG2tFYHtM48h92gBGEe+Uq6A0pgBmyluQEgeRQxXJkWTCXVDmYZTGZm/vakEf93Qw5/Xi4tn36IUcJcsx/jK2Ek+pCu6FFvPdtMWKGkESjXwA6BV3nkYLiL2gCl9/rJ6ahbrhajEYFZg48k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 446756052A; Tue, 10 Mar 2026 13:33:25 +0100 (CET)
Date: Tue, 10 Mar 2026 13:33:25 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net 00/10] netfilter: updates for net
Message-ID: <abAPlfmkO7gr142k@strlen.de>
References: <20260309210845.15657-1-fw@strlen.de>
 <aa_4w9gXCkzQ06Nk@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa_4w9gXCkzQ06Nk@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Mar 09, 2026 at 10:08:35PM +0100, Florian Westphal wrote:
> > 7-9) fix access bugs in the ctnetlink expectation handling.
> >      Problem is that while RCU prevents the referenced nf_conn entry
> >      from going way, nf_conn entries have an extension area that can
> >      only be safely accessed if the cpu holds a reference to the
> >      conntrack.  Else the extension area can be free'd at any time.
> >      Fix is to grab references before the accesses happen.
> >      These bugs are old, v3.10 resp. even pre-git days.
> >      All fixes from Hyunwoo Kim.
> 
> I am not sure 7-9 are correct.
> 
> nfct_help() is accessed via exp->master in other existing paths,
> I think these fixes are papering an underlying problem since the
> typesafe rcu infrastructure was introduced in nf_conntrack.

AFAICS these patchers are correct and other areas need to be fixed too.
I am currently auditing other conntrack helper usage for this bug
type.  I'm working as fast as I can given the volume of bugs coming
in.  I don't think that not taking these patches now is better in any
way.

Its possible these changes do miss a check for confirmed bit, to
avoid handling new, unconfirmed conntracks during object reuse.

Expect further patches in this area.

But I'm not sure this is related to rcu infra usage.

I would not be surprised if this bug has always been there:
20+ years ago, without KASAN/UBSAN it would likely have never
been found.
