Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB9B80BEE
	for <netfilter-devel@vger.kernel.org>; Sat, 27 Jul 2024 12:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722083638; cv=none; b=C0VbsUOtIuOicdncrrnVr7P2iayPK+403v5LH4q/rXpbL8aiuFOd6lS45pH7eNYx8oMBvjUI6ZRib19Gu33S4jcwcNMNtVfioQ8eZO6q8nhHAixZVtdgXDTgo7illjiSipCvfqrP1IlTnVFqVL8tvxfbsqN/zN575i3/tgnlUW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722083638; c=relaxed/simple;
	bh=Fro2Vv/Q3evCHV7jMFKBBiX3n3P1ThIL+vtXlgvAoxs=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hYSUSqSKkBROf9RlKI0g7hUwINV7jE4x5KShDlQgY8EGz3WaYO7x4eCvcw6oVb31O9shiZOVuDaJZGjtRzgDaQpXKu1O71WMz4kQxuIe/duRbaLjyH8S/CaxcyQHJrszgFL13v4J0l/8kfITn66KU4D9WtW6V+Ex7Dk2h5dhhdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=K5TX553j; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="K5TX553j"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Sb6IrdcAlDzVQiluYQ0zd9D+YZhaTA39k2/nq7yaNh8=; b=K5TX553jU4q3RkstIREWfqPnmO
	IXd+T7D83koe5EP+hwPyIcG+fobwQTUJQYZCqu3nEA9gAI1EscLClksfjejdx5pUd8Y/wnQ7O9KqX
	c0PcUeKU2lhDgra0ufI4Taq3N8hnzvLXLC0m62JZ9GjLQNosfYYSikFUbHShlRI99XQhXauiRhqHN
	feWvnPRlibzAQWTe7uHpBKiy371hG7xbFDb9/6Am70yZvkbhQPUaYygOX/o3iJ5U26ctWTGsxiDK3
	++UmGH5Q4/sKBLy/Inpep9PZ78d7N0PUAbuGAmljNdFtKnaF6Lq2l9fBzyCqXbtaHoqBLvF+LVYSA
	wYNikLfg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sXgcU-000000002qj-0bOQ
	for netfilter-devel@vger.kernel.org;
	Sat, 27 Jul 2024 14:33:54 +0200
Date: Sat, 27 Jul 2024 14:33:54 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] nft: Fix for zeroing non-existent builtin chains
Message-ID: <ZqTpMho4mkZs7TBO@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
References: <20240717104353.8915-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240717104353.8915-1-phil@nwl.cc>

On Wed, Jul 17, 2024 at 12:43:53PM +0200, Phil Sutter wrote:
> Trying to zero a specific rule in an entirely empty ruleset caused an
> error:
> 
> | # nft flush ruleset
> | # iptables-nft -Z INPUT
> | iptables v1.8.10 (nf_tables):  CHAIN_ZERO failed (No such file or directory): chain INPUT
> 
> To fix this, start by faking any non-existing builtin chains so verbose
> mode prints all the would-be-flushed chains. Later set 'skip' flag if
> given chain is a fake one (indicated by missing HANDLE attribute).
> Finally cover for concurrent ruleset updates by checking whether the
> chain exists.
> 
> This bug seems to exist for a long time already, Fixes tag identified
> via git-bisect. This patch won't apply to such old trees though, but
> calling nft_xt_builtin_init() from nft_chain_zero_counters() should work
> there.
> 
> Fixes: a6ce0c65d3a39 ("xtables: Optimize nft_chain_zero_counters()")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
