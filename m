Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A84C23496F
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Jul 2025 23:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753746477; cv=none; b=sl8VNXOudzH8o7V5fs72DDWxsdxLNOnXVJh5y3qT3FFqnaTlwPGZgHjRgC523hcE2JQvxeTLStvBh6fRNyiDte0XkvJF053UNsYi7beyEaSsqwS60JVsijQYE9zo+vpWyu5qUid2JDM+POsZEZ6CLfBn8hKwVKw6VkiXPsbndKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753746477; c=relaxed/simple;
	bh=VSsjHFjxJ7T5X01Wd/kxxHvD1ovL+Ou5r1fXJc874Zs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LwfBUp34TvHoDoE+QTZ+B8bg7L93u2GqBF9CdkelRALpAtu9vrTlqngRCjYKaT5kdbNodsoMpLjDsQk5UaL8SoMYrya+/BAG6ok5LDXfe0r93Tpw7zVULHIp+A46kGI57pBw+xIb+ghrRqOHS4aQhPYsWE6yIvnhPtln9Pcqp2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D123B605E6; Tue, 29 Jul 2025 01:47:52 +0200 (CEST)
Date: Tue, 29 Jul 2025 01:47:52 +0200
From: Florian Westphal <fw@strlen.de>
To: Dan Moulding <dan@danm.net>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	regressions@lists.linux.dev
Subject: Re: [REGRESSION] v6.16 system hangs (bisected to nf_conntrack fix)
Message-ID: <aIgMKCuhag2snagZ@strlen.de>
References: <20250728232506.7170-1-dan@danm.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250728232506.7170-1-dan@danm.net>

Dan Moulding <dan@danm.net> wrote:
> Hello netfilter folks,
> 
> Since v6.16-rc7 I've been hitting a vexing system hang (no kernel
> panic is being produced that I can see). I did not have this problem
> when running rc6. I first noticed it the morning after upgrading to
> rc7. I found the machine unresponsive. Checking logs after restarting
> it, I could see it had been in the middle of being backed up by an
> rsync-based backup system. This same sequence repeated the following
> day.

Bah.  Can't see the problem.  Can you partial-revert and see what
happens?

E.g. only revert the changes to net/netfilter/nf_conntrack_core.c
and keep nf_ct_resolve_clash_harder().

Is this x86?
