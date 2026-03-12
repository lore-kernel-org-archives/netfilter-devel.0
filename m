Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E2F3FD140
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2026 22:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773353666; cv=none; b=JsI5tJtUgiXq0cGGyLruP/UkUf5eAtjCyoigvXLrp5ROJ7iq/JXelP5fKEm4OhhwBjjSOI63z6wbtqC/t9FgKgijhgfzYFgLpO7jFdHBRVYpRtXanOG++tuyZEwbDzZavUbbN/9XFTSkepvdTQlGv1T4c6qX+KZDqacRLF9FGaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773353666; c=relaxed/simple;
	bh=Oi9aKfBiBGMQ9e3JwobNd1BKrBGzXdUqm1kfNo9sDFM=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sN+gndPxXJQK8PiXnkedcBEl14iSAjGOT8YKtvJGqOQxu5h8TtKCJo4MpDkQZAdcj6iJQ4Pg2mp7nI0oTjMpCIFDjOwTRdCsvD1QVAETDNQuoIbfk3o1llcr3WrpYTTkR+373eFGKaCuTB9bJaqL6+bTjk0VvcpGNUPM1a6E+Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A195760345; Thu, 12 Mar 2026 23:14:18 +0100 (CET)
Date: Thu, 12 Mar 2026 23:14:20 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, Jeremy Sowden <jeremy@azazel.net>,
	Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] tests: py: use `os.unshare` Python function
Message-ID: <abM6vF13kX78q2Rh@strlen.de>
References: <20260305175358.806280-1-jeremy@azazel.net>
 <aasRsr93TOUuH_Xb@orbyte.nwl.cc>
 <20260306183553.GA5468@celephais.dreamlands>
 <abCki9aBa8wVBvQi@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abCki9aBa8wVBvQi@orbyte.nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> > which suggests it's time-zone related.  Didn't see anything about that
> > in the doc's.  Will take a closer look.  Apologies.
> 
> Yes, it's odd. Neither unshare module nor 'unshare -n' behave like this,
> even though os.unshare is described as doing the same as unshare command
> does. It also doesn't mangle os.environ['TZ'] value, no idea why it
> messes with this.

Is there anyone working on a fix?

This breaks my CI pipeline (i.e. I disabled meta.t tests).
