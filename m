Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E29D168BD
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Sep 2024 10:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726742974; cv=none; b=MM8EAFfxjkyxLw+ZZF0jNHOCi5zG6wN1tgVWmVjscjCAh6yKXqERkaVs5V/NYb+XzAuqC5x19ZuJaxCOkJ+fpb1N07T94IXvQSQJAO1i/hKZhjwy5ZxJ7rPA8YFaB98Gg9jSpXPtEP03wxrstzEA2OuUDQmnQEdg0tKEoEA8y74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726742974; c=relaxed/simple;
	bh=Iz+wOxcULq+6GqPTK3118sNAzN48dMk4EmQXQvNTRfU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NK2olRGVmmwMxrTSg50s1sjoEAlLDUeWBlOkaFjLOD2Vglq/C6/mxoTdeAtIQowWugOZMQDk6YzvrS2es/d8x8f2ArN264L0m1WBDldgscZDS0jznFyOJM65qGeYhA3DjMnQSksoPQpj4yOxouq+sCe8gGM9IGClGz5Dz1k8hQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1srEix-00036K-00; Thu, 19 Sep 2024 12:49:23 +0200
Date: Thu, 19 Sep 2024 12:49:22 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nf PATCH] netfilter: nf_tables: nft_flowtable_find_dev() lacks
 rcu_read_lock()
Message-ID: <20240919104922.GE8922@breakpoint.cc>
References: <20240919104503.20821-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240919104503.20821-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> Make sure writers won't free the current hook being dereferenced.

Are you sure?
AFAICS its only called from eval function/hook plane, those are already
rcu locked.
