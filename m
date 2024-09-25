Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928F31849
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2024 18:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727288167; cv=none; b=IQY+qFkKhZytPnrybKkKZaofIIb6VKywf7cZBIiO1JnLv4LbQT556fyPh8vBixGztsaKGp1tYL+q1ttUmi2JZxSV3PMAFvcrH3uoFvZzhIm1SG6+QMuWAagKiIuwTrCng/g0C7b2PprGSTaeMUiN0WqTVVEt+NpgvMWJn3uKCwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727288167; c=relaxed/simple;
	bh=mG7t2vqab6lB7JBKX6/1FKl+UJyh87x9p4QO/8+f1qU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OdHHhTb/rSqDEdMTI+HpnuD0fKfuOQWcSd69L1x8NBanueQmO7lsHXif7J3oo24cQJ12lNA9V75Sh6SNB+pU/n07VSMkpQtKbBffLgmTK52qZmHt0BIyfIafv24DlFrtoMYEGRR+JRHmAtmroBbuZtNkLsSYZUCHStd60cQUe90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=E4FUuWXC; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="E4FUuWXC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=P/Yt1J3eDfg6eN+H79ahoHBDzdsvKzdY/PQE3RtMi+Q=; b=E4FUuWXCa6hmZ1lbbQyET8Lk//
	duk1DZkRfwCNZvGaxcqagnwYE/pYUX6ZWv48kLx5BKVoyERYHbhAp4xHAWGGB2ojKAoV8RikE7RFS
	ARRB/HqiiLPdXY+3UwiXgWL7kINBVQTFxkv8z3WFSxg9ad3vcKU53sTt57Atl2oOkPMoI8x/yTJ1q
	zjdaiNXP5MxmxZQ0vGh1ustZ5MGxYROGh1kTOtRxJXovIYWFepcJAIdTViZDS2FYLJMmOPpPJiyzL
	eX4DZc3FYGgqhRDc4GOJVOhR2hY9774FMkmZoFmGINLy8QSlziMNlGSLZ+lI7ZabZdNA5HsclbxXe
	ZEUzLv1A==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1stWYT-000000000MF-2hxu;
	Wed, 25 Sep 2024 20:16:01 +0200
Date: Wed, 25 Sep 2024 20:16:01 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v4 15/16] netfilter: nf_tables: Add notications
 for hook changes
Message-ID: <ZvRTYZRufYyMD6kC@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
References: <20240920202347.28616-1-phil@nwl.cc>
 <20240920202347.28616-16-phil@nwl.cc>
 <20240921091034.GA5023@breakpoint.cc>
 <ZvRHmHn6wllDFukN@orbyte.nwl.cc>
 <20240925175154.GA22440@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240925175154.GA22440@breakpoint.cc>

On Wed, Sep 25, 2024 at 07:51:54PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > > This relies on implicit NFNL_CB_UNSPEC == 0 and nfnetlink
> > > bailing out whe NFT_MSG_NEWDEV appears in a netlink message
> > > coming from userspace.
> > 
> > I guess with 'implicit NFNL_CB_UNSPEC == 0' you mean the extra
> > nf_tables_cb array fields' 'type' value being 0 (nfnetlink.h explicitly
> > defines NFNL_CB_UNSPEC value as 0). I don't see the connection here
> > though, probably I miss nfnetlink_rcv_msg() relying on that field value
> > or so.
> 
> I should have been more clear, I was wondering if we need/want
> an -EOPNOTSUPP stub callback rather than reliance of nfnetlink to
> detect it.

Sure, I got your point. The NFNL_CB_UNSPEC reference was just a bit
confusing.

> > I see at least NFNL_MSG_ACCT_OVERQUOTA missing from nfnl_acct_cb. The
> > former was introduced in 2014. May I claim grandfathering? ;)
> 
> I guess it just means "no we don't worry about it".

Maybe. At least we rely upon the behaviour for a while now, possibly by
accident.

We could get rid of the nc->call != NULL check by assigning such stub in
nfnetlink_subsys_register(). OK, technically it would just move the NULL
check. Without such stunts, nfnetlink_rcv_msg() would have to remain
as-is to cover for future users with holes, right?

Cheers, Phil
