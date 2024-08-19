Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC711DC49A
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2024 19:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724095171; cv=none; b=QHv6/Y3ceAY4J6Oy1xFz2MzeCuJMobtxmymB7npjj5LlUDwFkqlfhzwjuF0vxSI0AvvfFcXUhHnyJ0xVpuCxefG7wRQwG4P6RtU3b3O+xOKYCksog/Kk+u4zIDJ5PjOqqjaxPmMWO74kABniMNJIz4SWA5TsuTvXLhZeGK3z5is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724095171; c=relaxed/simple;
	bh=SuYIq107X9fOy8sqMGqizga74XVBglGJ9Bp61LdPjGA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fFdpSYPlK+9Zajw7XWEqzLZCS14/+egiw1k81Ga3Xeq7tn+bl9gzLKtsJ7xEiPvJfl/sN/mcMWajfJPBKlz8QXtwzrmhIDK5pQgg7xQM3zZkpFXkLWcLxrfoZyuf+ieLLS9T/p9F4+qRKcKyXABSVl7ZZK99dacrupafQGxeNIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=55560 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sg7uX-005l1W-TW; Mon, 19 Aug 2024 21:19:28 +0200
Date: Mon, 19 Aug 2024 21:19:25 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: pgnd <pgnd@dev-mail.net>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Fwd: correct nft v1.1.0 usage for flowtable h/w offload? `flags
 offload` &/or `devices=`
Message-ID: <ZsOavdWMizbUi9bP@calendula>
References: <890f23df-cdd6-4dab-9979-d5700d8b914b@dev-mail.net>
 <404e06e6-c2b4-4e17-8242-312da98193e5@dev-mail.net>
 <ZsN9Wob9N5Puajg_@calendula>
 <70800b8c-1463-4584-96f2-be494a335598@dev-mail.net>
 <ZsOQCgbMuwsEo3zj@calendula>
 <2408b714-a7a5-4c84-b108-64dab86eea3e@dev-mail.net>
 <ZsOam3aw4iMMoATg@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZsOam3aw4iMMoATg@calendula>
X-Spam-Score: -1.9 (-)

On Mon, Aug 19, 2024 at 09:18:54PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Aug 19, 2024 at 03:04:07PM -0400, pgnd wrote:
> > > driver needs to implement TC_SETUP_FT
> > > hw-tc-offload support is necessary, but not sufficient.
> > 
> > 
> > ah, thx o/
> > 
> > https://lore.kernel.org/netdev/20191111232956.24898-1-pablo@netfilter.org/T/
> 
> yes, unfortunately it only supports for net/sched/sch_ct that I am
                                          ^^^^^^^^^^^^^^^^
                                          net/sched/act_ct.c

> aware, it never made it to support netfilter's flowtable.
