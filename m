Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B743439C631
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 04:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789619800; cv=none; b=gQHd3pylDxFjkblDlZMzjKEHVNJmuoRhXGYBDuq+JlNtseFYtqgLKbQfCB6eWLb5AJ031+5q+PT6d+EgOGcC3Rk8d7B1acnP0NnQOHGRyE8Vp6dcg+iZXnqLd9lrnKfVPzgd71A6HQGWVHDeW3T4zXCuOOT9zpfGiLMrLJxVjo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789619800; c=relaxed/simple;
	bh=3MP1OrsCpKi0THGXh7zYaKAxsb+TjYYFRrZXYUUl8MQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mJ3m8ix4+anDlXFcWH7qb3OQzN3xoBJSLbRdZCQZSTbRT5QQSjmBeagmxywJ5kqUSVipejaeSZuaExGMk9nxIcDtf2xwnEXyelDUn1DcIls9kw6T1OFZv5zonhP8i6PRgaLBXUfZervQVWZPDUmuljR0mSTbAOKVsqO4Bgni8pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 25492601B4; Thu, 17 Sep 2026 06:36:35 +0200 (CEST)
Date: Thu, 17 Sep 2026 06:36:34 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nfnetlink_queue: hash queue instance
 by portid too
Message-ID: <aqtuUg-rFmUZYoD0@strlen.de>
References: <20260916220047.95751-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916220047.95751-1-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> netlink_release() calls netlink_remove() before delivering the
> NETLINK_URELEASE event. And a new queue instance can be created before
> delivering such NETLINK_URELEASE event. This allows for two different
> queue instances with the same portid to co-exist for a little while.
> Since the instance that is going away is destroyed by portid via netlink
> notifier, both the newly created instance and the one that is going away
> with the same portid are destroyed.
> 
> Fixes: 7af4cc3fa158 ("[NETFILTER]: Add "nfnetlink_queue" netfilter queue handler over nfnetlink")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> @Florian: this is the rare race that Clashiko uncover with your fix.
>           This is a pre-existing issue. I have to check if nfnetlink_log
> 	  is also affected.

AFAICS its complete bullshit report.

Needs threads that race to kill and resurrect the same queue all over
again, constantly.

Don't do that, then?!
What kind of userspace does this?!  I mean, what's the point?

We could make nfqueue refcounted, like _log, but I see no reason
whatsover.
