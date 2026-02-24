Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F9E3A0B3A
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Feb 2026 19:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771960804; cv=none; b=lyNuE8Ioj9/V15Glql3oILGmyb5H/po5zTrPHrmD1Dfs506S50S9vPnSyPqnv+V3aDkRkeaKWD3zfTTa8S/gGmlgHTakS5siuS0VGfz5GxoSsEBd2BAVlAkEeNZ4PhhrmbrzycXePYoqgBYiSF4jkX5/2GqL5stTA5BhSPNTXJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771960804; c=relaxed/simple;
	bh=RL4vdmaoJ80giJ+5y8hNYScEgqQ7uwaDufeTDaP/DVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SoFdfdA8DCaGUr4muVjPEW2vsPJiFmwY5gwsveOdTTWmun0nqxhwxwPBgMohmxBPWSbnRDk2k6U6cwAR8hVBdP0PdH/BbSlS8IJmw0BTBryGOHdMtSB5y1aa1nrk85DBXq4ZLjW3NAjQaguZS84rRUmupVM9WuM03Ybe52/HV5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1AC0560499; Tue, 24 Feb 2026 20:19:55 +0100 (CET)
Date: Tue, 24 Feb 2026 20:19:54 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: inconditionally bump
 set->nelems before insertion
Message-ID: <aZ352pI2B6v0yJzY@strlen.de>
References: <20260224182247.2343607-1-pablo@netfilter.org>
 <aZ30HscJe0XroBtg@strlen.de>
 <aZ334G68nwX2GXNi@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ334G68nwX2GXNi@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Makes sense to you?
> 
> My concern is that this slows down a scenario that is possible, ie.
> adding an element to a full set.
> 
> ... compared to 71e99ee20fc3, where it is almost *impossible* to reach
> that synchronize_rcu() in a real use-case since you have to register
> 1024 basechains.

Thats a good point, actually.  Let me think about it. I'll do a nf-next
PR now and will get back to this today.
