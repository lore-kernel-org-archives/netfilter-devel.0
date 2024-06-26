Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659AD175567
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Jun 2024 22:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719441662; cv=none; b=krbqvomxODYvuIHL8y539yy2dzGtYYj0wVkHLuiaXovipygeqEAl+TZnK3ycUaKvwzTvPhPmfxFEQv9MyNhU3vw1/Kx7qLLIg3zbsbEBG+HPvdQmCBZXSH3Jn4FcjHTg6jRyN0osNzmzK0WgEm1OOoRk/n+C79QeeIyYqg0dAGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719441662; c=relaxed/simple;
	bh=qtAJm1cOG1IBXaimqyTvIHpsIFsSSEuYUFwJaxFkc3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kb7Mc0Z6ZR4QcvgHE/K4rl86t+kSxVdeSQ5d1TVzZH4YhDsVkR6/5yul58tCuZbIMukDf5jgZwoyEX5AtA3NZLykfNDfreqdE4OIy5T4Lgm7kqcX5Ih+J3ovwx8o7FsOhHdQwsRDv9MsucH7NT+3BvYfoZGgApyZejRvyYlxnt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=pHw1Msjr; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="pHw1Msjr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=fcfC0l5kXXUGQPffAqzm6xzM9E2XvZLtgdjJzdCBNrI=; b=pHw1Msjrld2GSI+HQlchaitVTw
	ZntAYL8LlBWii2ABismi5hW/jT6iTUxXzvV/d7OI+mJ+rGqDcg/tCcrSceam8PZ5RtefSMqMZBlGx
	K2SY+o6VRSRhOR1l8WFjz1IqOC8VTZHYk+AxZbvkf3HsVg9dwBI8p8jFBrspW2330T2aBHFw5UJdb
	pwWgr8OdjpGXQM4sLWJMH6+ovnLuiWuHekcYZWI7XG6m4zf0dn8MFfVLMGCAQ15On3K8KXjVJGmMa
	A3B60faoqB8qOc48FMkLQr5Pv+6hV60m2jkS1sDlOo1IbogEdGPlL6oz7TR9M1Qi/Sjaobhyl2XL3
	AbtV/tIA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sMbJy-000000002HF-1N0X;
	Thu, 27 Jun 2024 00:40:58 +0200
Date: Thu, 27 Jun 2024 00:40:58 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Fabio <pedretti.fabio@gmail.com>
Subject: Re: [nf-next PATCH v2 1/2] netfilter: xt_recent: Reduce size of
 struct recent_entry::nstamps
Message-ID: <ZnyY-j4pqHjflOnb@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Fabio <pedretti.fabio@gmail.com>
References: <20240614151641.28885-1-phil@nwl.cc>
 <20240614151641.28885-2-phil@nwl.cc>
 <Znw9-9hAxauzr2Ie@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Znw9-9hAxauzr2Ie@calendula>

On Wed, Jun 26, 2024 at 06:12:43PM +0200, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> On Fri, Jun 14, 2024 at 05:16:40PM +0200, Phil Sutter wrote:
> > There is no point in this change besides presenting its possibility
> > separate from a follow-up patch extending the size of both 'index' and
> > 'nstamps' fields.
> > 
> > The value of 'nstamps' is initialized to 1 in recent_entry_init() and
> > adjusted in recent_entry_update() to match that of 'index' if it becomes
> > larger after being incremented. Since 'index' is of type u8, it will at
> > max become 255 (and wrap to 0 afterwards). Therefore, 'nstamps' will
> > also never exceed the value 255.
> 
> Series LGTM.

Thanks for your review.

> I'd suggest you collapse these two patches while keeping the
> description above, because nstamps is shrinked here in 1/2 then it
> gets back to original u16 in 2/2.

ACK, that was the plan right from the start. :)

> Maybe something like:

I composed a new note to add to the second patch. Please review and let
me know if it's unclear or misleading.

Thanks, Phil
