Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F69192B88;
	Wed, 25 Sep 2024 12:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727266854; cv=none; b=UyK9pIfoYgThnuLEg2rT8G/LMLL2LzY9epRue4M/A6WiwHjRe+AJoj3zZoBUIOqFArptzGJramvdNNW5C7P1Yc8Tg4NGSL4CBaRmui5vQXq7NsSmu/OxoBB1TkrwDazRp97OedOkHyiX47HhFgqNhlraTNJsLm/Pi423un2KwGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727266854; c=relaxed/simple;
	bh=1fgXmgd0c9VaeNQxq8yAVPMcbGNTaset1jrDO3tVaJo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OmUF3ScdPhrfC+ip0VW74kN4dS8y7Y2GNbgsFNB5eLcmPejx1QIthLGwH8xm7Ko4/ifE6WyVxjodQBh4aCUSbA32FDyVMZ704lolQpgwz8oRTO1SPZx9ffCsJ464+wByC9swgu2CuzEQ8+eXRCM+Tgxb6tvzI/Kgv2Y+JFCMnnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1stR0b-00033Z-HU; Wed, 25 Sep 2024 14:20:41 +0200
Date: Wed, 25 Sep 2024 14:20:41 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	kadlec@netfilter.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.11 049/244] netfilter: nf_tables: don't
 initialize registers in nft_do_chain()
Message-ID: <20240925122041.GA8444@breakpoint.cc>
References: <20240925113641.1297102-1-sashal@kernel.org>
 <20240925113641.1297102-49-sashal@kernel.org>
 <ZvP6-utbwqWmP5_0@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZvP6-utbwqWmP5_0@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Sasha,
> 
> This commit requires:
> 
> commit 14fb07130c7ddd257e30079b87499b3f89097b09
> Author: Florian Westphal <fw@strlen.de>
> Date:   Tue Aug 20 11:56:13 2024 +0200
> 
>     netfilter: nf_tables: allow loads only when register is initialized
> 
> so either drop it or pull-in this dependency for 6.11

It should be dropped, its crazy to pull the dependency into
stable.

Is there a way to indicate 'stable: never' in changelogs?
