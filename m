Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2867A382360;
	Thu, 30 Apr 2026 22:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777587379; cv=none; b=byk7lHKPwCUISewdIAW9r53CYyDklsGRGFwTYY1bnSUXvC9Nd16UVvVt4AQOKvk+JB9ukZX11drcKydR8O7GGlIZJ+KXSqXUlgxt9o7Q6OZOMwM6ZUHB86Jy1xR0AOGYJqVNOeZz3stmr0jy9jFMiWK+xhwuuUz8SiGIw+2+3Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777587379; c=relaxed/simple;
	bh=4QmRf+byhHEBKFCnvv8uaksqD8g1nZ8oagGd4fIeWh4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SQ0CjzoF1UDHIjYzwVhnKWttbGdGN54eA6r+hsbJ9dDXNDjtDyCXUM/aXx3b5bZtQoUsKYBh2sagE7XQZ41e11ZSDsd9GYeaeUZewihrhHFWfZ+eNP3LTnO2fPM+tKQEZtddVKSZyQMQ1LqV/aR//tyeN8em2pt6NDN0/X/kwH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CA00160640; Fri, 01 May 2026 00:16:15 +0200 (CEST)
Date: Fri, 1 May 2026 00:16:15 +0200
From: Florian Westphal <fw@strlen.de>
To: Tristan Madani <tristmd@gmail.com>
Cc: pablo@netfilter.org, phil@nwl.cc, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, stable@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] netfilter: ip_tables: guard
 ipt_unregister_table_pre_exit against NULL ops
Message-ID: <afPUr2oksLlaMcOj@strlen.de>
References: <20260429175613.1459342-1-tristmd@gmail.com>
 <177750472539.3004201.15967003942391945312@talencesecurity.com>
 <177750474339.3016150.13196470704394042910@talencesecurity.com>
 <afNYqx41pBCyDnjR@strlen.de>
 <177758578919.118018.11758358602621428742@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177758578919.118018.11758358602621428742@gmail.com>

Tristan Madani <tristmd@gmail.com> wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > Is there a reproducer for this bug?
> 
> Syzkaller hit it under failslab. The race is between the lazy
> init path in ipt_register_table() and cleanup_net(). The table
> becomes visible via xt_register_table() before ops is assigned,
> so pre_exit can find it with NULL ops.

If we have races between a thread calling ipt_register_table and
the netns cleanup path there is nothing we could ever do to fix it:
we are tearing down a live network namespace.

Something else must be going on.
