Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5677E2D46DD;
	Sun,  7 Dec 2025 10:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765102885; cv=none; b=f3qTjKzXEZ4RniXFDilfA1iJiKcUeHmIYAF+gKV0cUcNcfxbG/9VJTso14sK9JsVXVjh6oLGs4jXgrvMsXJNdsvitiGECw/0AKcVkZCcrS9fUNgls2+AlcQzPGJpVzGQOzdsHpBKwyJpDCofz45e20j7KGz2Aw/cVgy1NceEc9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765102885; c=relaxed/simple;
	bh=CDJEVZSxdMszsEuj4Wpr7PZfkSN6pZ+9xlpPG6OKslM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SqgVCZ9lfb8gY26xPCEEHJcfwBZhrbSwirkMADPBXzM4F5lchtCppii1fiTkhBkzNfjuyHoNZA65nmQnYYzU9KpXCiBaaDFJxshUfdVvKruE66Sdba8WNJXEByM/dEFyEO2LFwKt6oimHJ75ABrmCG5ScRS866W6T2Z+7upwgJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4BE4E60336; Sun, 07 Dec 2025 11:21:14 +0100 (CET)
Date: Sun, 7 Dec 2025 11:21:12 +0100
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
	pabeni@redhat.com, andrew+netdev@lunn.ch, horms@kernel.org,
	pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	willemdebruijn.kernel@gmail.com, kuniyu@google.com
Subject: Re: [PATCH net 4/4] netfilter: conntrack: warn when cleanup is stuck
Message-ID: <aTVVGM_1_B6CGZSK@strlen.de>
References: <20251207010942.1672972-1-kuba@kernel.org>
 <20251207010942.1672972-5-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251207010942.1672972-5-kuba@kernel.org>

Jakub Kicinski <kuba@kernel.org> wrote:
> nf_conntrack_cleanup_net_list() calls schedule() so it does not
> show up as a hung task. Add an explicit check to make debugging
> leaked skbs/conntack references more obvious.

Acked-by: Florian Westphal <fw@strlen.de>
