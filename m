Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BEB17547
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2024 17:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727286719; cv=none; b=dLs7csxejM4oBAq3+vhVFH3p/vrtGjK19oJAJ0VxPJ1gkWCYihUwDPMc+9uF1S2rFGI59wd/ncV+alJSmhY3XVnfYtSgQILNe2W/QnPijCJsMp540QSpeNlC2Aele/O019jCvuGrIHIQ6efryYImvAn2qT1rzbtWWGejPFWDXHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727286719; c=relaxed/simple;
	bh=+9qVM/2KQpwZ+HFXay7nsZ3syM2IGdoTFPXhdnDZXVA=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K6H2o+aUVhHq1647NQ4GXWkZwwSP1XPbA5AUcBaZImeFKz+HCX/mDwa46Cjyjb08FAp1J8+hO6P1mKAAuAsgUMoaTuz4gH91mQOVORzcrkKoqPImga4fk8MJo01bg3OhDjzFttEooNSbggs+7fPceNJSDy4T6UysijjAwgkqRjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1stWB8-0006CB-1X; Wed, 25 Sep 2024 19:51:54 +0200
Date: Wed, 25 Sep 2024 19:51:54 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v4 15/16] netfilter: nf_tables: Add notications
 for hook changes
Message-ID: <20240925175154.GA22440@breakpoint.cc>
References: <20240920202347.28616-1-phil@nwl.cc>
 <20240920202347.28616-16-phil@nwl.cc>
 <20240921091034.GA5023@breakpoint.cc>
 <ZvRHmHn6wllDFukN@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZvRHmHn6wllDFukN@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> > This relies on implicit NFNL_CB_UNSPEC == 0 and nfnetlink
> > bailing out whe NFT_MSG_NEWDEV appears in a netlink message
> > coming from userspace.
> 
> I guess with 'implicit NFNL_CB_UNSPEC == 0' you mean the extra
> nf_tables_cb array fields' 'type' value being 0 (nfnetlink.h explicitly
> defines NFNL_CB_UNSPEC value as 0). I don't see the connection here
> though, probably I miss nfnetlink_rcv_msg() relying on that field value
> or so.

I should have been more clear, I was wondering if we need/want
an -EOPNOTSUPP stub callback rather than reliance of nfnetlink to
detect it.

> I see at least NFNL_MSG_ACCT_OVERQUOTA missing from nfnl_acct_cb. The
> former was introduced in 2014. May I claim grandfathering? ;)

I guess it just means "no we don't worry about it".
