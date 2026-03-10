Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464FC3A3819;
	Tue, 10 Mar 2026 12:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773146475; cv=none; b=lua6NXwzOVfBN1zNk5d8wbP6TXZjWMD8ywNgp/Xf/VajkRhPvZNHRfpzqea1A1XO51OBjaIsONEO/0fqFTR6uTHTG5tFAIDodLdWGVWsN7Qu6MlR74Jz5/cSbm1xYOXaj2/n6UfQ0Tus5t20ew+KqrgPi9cFumiE9gmRVSmE/Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773146475; c=relaxed/simple;
	bh=PwoxdyEGpoX3hF4DbyXYXng3Q1boXI3halwpu/ThnEk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xua2wWnaPg2S/wmXQKslI7xNTCb33MeraHQQ4JSSIsUu3WHGBUQw0Drf0zMkx+dJBIazEtpLnXvBNWfuh/klVdA4RT0jvBfdZqgJ11U9b90lvk4fNN1Ld6+UgJiDj5SEw3E6AftCVdcNch+YTT/GHfVgFkmAiH+zk6jplOBDjdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RGRpW5kA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RGRpW5kA"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id BD43F6056B;
	Tue, 10 Mar 2026 13:41:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773146470;
	bh=i2eBlqyC0qnL/uht0sn+k3w5EBoHs3CC+Po1ztioVAU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RGRpW5kAP5rbxK+ipVCJQBH8oa2lsuuVxHEqSDvgbTDNJ70aLIIbjJjm/fwMiXhS5
	 5kRldN5R+Z6UZ7kKB7Hl15XmbAOq0Z+SCsKnTuAuyc+SZ8J9coDGl8lj3kPV+4pK/8
	 RPHKt6QUSplhjQo3uXcexlqKRrcFY8cGQPgL/FRuUBuFrMyuE9BjjGvmD4y9lyZztI
	 KnrxQMp/rU4FwSNZqW/KanZWCc5NzGBssXaoX5Fdc841n12eqVuX5tC3VB1uIYdV1c
	 ntEbkvjHZG6c1bDY88dK2DIkVc4Z2NSQiK9AZv+uIo6ABlGda4mJVp/hU+O8t82qSV
	 e3MAQ0WsFc65Q==
Date: Tue, 10 Mar 2026 13:41:08 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net 00/10] netfilter: updates for net
Message-ID: <abARZGTs_eP6yDu4@chamomile>
References: <20260309210845.15657-1-fw@strlen.de>
 <aa_4w9gXCkzQ06Nk@chamomile>
 <abAPlfmkO7gr142k@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <abAPlfmkO7gr142k@strlen.de>

On Tue, Mar 10, 2026 at 01:33:25PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Mon, Mar 09, 2026 at 10:08:35PM +0100, Florian Westphal wrote:
> > > 7-9) fix access bugs in the ctnetlink expectation handling.
> > >      Problem is that while RCU prevents the referenced nf_conn entry
> > >      from going way, nf_conn entries have an extension area that can
> > >      only be safely accessed if the cpu holds a reference to the
> > >      conntrack.  Else the extension area can be free'd at any time.
> > >      Fix is to grab references before the accesses happen.
> > >      These bugs are old, v3.10 resp. even pre-git days.
> > >      All fixes from Hyunwoo Kim.
> > 
> > I am not sure 7-9 are correct.
> > 
> > nfct_help() is accessed via exp->master in other existing paths,
> > I think these fixes are papering an underlying problem since the
> > typesafe rcu infrastructure was introduced in nf_conntrack.
> 
> AFAICS these patchers are correct and other areas need to be fixed too.
> I am currently auditing other conntrack helper usage for this bug
> type.  I'm working as fast as I can given the volume of bugs coming
> in.  I don't think that not taking these patches now is better in any
> way.

Are sure that adding refcount bump is the way to go?

# git grep "nfct_help(exp->master)" net/netfilter/
net/netfilter/nf_conntrack_expect.c:    struct nf_conn_help *master_help = nfct_help(exp->master);
net/netfilter/nf_conntrack_expect.c:    struct nf_conn_help *master_help = nfct_help(exp->master);
net/netfilter/nf_conntrack_helper.c:    struct nf_conn_help *help = nfct_help(exp->master);
net/netfilter/nf_conntrack_netlink.c:   m_help = nfct_help(exp->master);
net/netfilter/nf_conntrack_sip.c:                   nfct_help(exp->master)->helper != nfct_help(ct)->helper ||

These callsites need auditing.

Yes, I just wonder if this can be fixed without adding checks
everywhere in the code, I would need a bit more time too.

This report came in over the weekend.

> Its possible these changes do miss a check for confirmed bit, to
> avoid handling new, unconfirmed conntracks during object reuse.
> 
> Expect further patches in this area.
>
> But I'm not sure this is related to rcu infra usage.
> 
> I would not be surprised if this bug has always been there:
> 20+ years ago, without KASAN/UBSAN it would likely have never
> been found.
