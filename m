Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF61240F8CF;
	Thu, 30 Apr 2026 13:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777555632; cv=none; b=Fr5fYBHXN6m0NlDypQfbm6ylM9NmdcdgI+m6beRFWuiP1fyO+0Kgia088Wss+s4lkIAnOhaV/jTO9k/FfqmS4uKZu5dqXnEkxzu0bCIcnW1lumsYpBXBBFeEF++74o8pqXfIjPEaq9n7Xtvg62iqiHkX8VjR2xD/zljUjAcz3f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777555632; c=relaxed/simple;
	bh=3dgeUzkiEX83s7h+MF13V8GO4MSQo/ZEe5yLBlN4o54=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sw1mHsa+ki1JjHOee7WQcnlTJfU9SSv3bxUH4HtJarV9egm1TlaRLU9bIQXcznF1vCKrsOV3q2qDneAfV9BG973Xd+J4DN17wURH3R3Y4CVcpVzsOGwERzOEMulQAt2X57esSYm8Iw+pjEAXrzM8BG677z6muhmOeXoajeDpZ7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 903A960981; Thu, 30 Apr 2026 15:27:08 +0200 (CEST)
Date: Thu, 30 Apr 2026 15:27:07 +0200
From: Florian Westphal <fw@strlen.de>
To: Tristan Madani <tristmd@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] netfilter: ip_tables: guard
 ipt_unregister_table_pre_exit against NULL ops
Message-ID: <afNYqx41pBCyDnjR@strlen.de>
References: <20260429175613.1459342-1-tristmd@gmail.com>
 <177750472539.3004201.15967003942391945312@talencesecurity.com>
 <177750474339.3016150.13196470704394042910@talencesecurity.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177750474339.3016150.13196470704394042910@talencesecurity.com>

Tristan Madani <tristmd@gmail.com> wrote:
> ipt_register_table() adds the table to the per-netns list via
> xt_register_table() before assigning the per-net ops copy to
> new_table->ops.  If cleanup_net runs during this window,
> ipt_unregister_table_pre_exit() finds the table via xt_find_table()
> and passes the NULL ops pointer to nf_unregister_net_hooks(), causing
> a general protection fault.
> 
> Guard against this by checking table->ops before calling
> nf_unregister_net_hooks().  If ops is NULL the table is still being
> set up; the register path will either complete and register the hooks
> normally, or fail and clean up via __ipt_unregister_table().

Is there a reproducer for this bug?

This explanation makes little sense to me.
If netns is being destroyed, then there should be no more requests
to set/getsockopt.

Is this perhaps about aggressive rmmod + parallel set/getsockopt calls?
That would make more sense, but this needs a different fix.

I'm working on a new unreg scheme to avoid rmmod racing with concurrent
calls into iptables set/getsockopts.
