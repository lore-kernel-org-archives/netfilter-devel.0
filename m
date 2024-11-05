Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E211D5CEB
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Nov 2024 22:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844223; cv=none; b=X8lXoSH4zNr7xnNbw55f8EyZOsCTKvzB7H8Mr8tQVl/7DvSOP68JfSYSjhDBVIm/IrQeiLtgd6rvmezT/9SuJGFHc2tmlGoObheAE+33w3Guu2VMWVcrsjmNBUz+wUymVqM9vtkO7yj4ucu/5Vkwt4islwntb8m8ZFxs6IXT2Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844223; c=relaxed/simple;
	bh=+7qTwVwWXfq0xCg6NTVztNGpEg074Q7FZJa9zUKiKlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y/zUlVaA0VafRqtJNBepyXLDbcQO/aFNQtuBJOAat+2d2Psb+uks2R8Lz+09o6eoNoxyvPy48Qn4youaNbsbbYLeoeAibuk4ZAPBFtQrjHDO6kktezPDG5ZnudIdmfNMh192gTT7GDQihvY8JGbwmNrFaq3rONIgFLxAwVNrttw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t8ReF-0004gm-Bn; Tue, 05 Nov 2024 23:03:39 +0100
Date: Tue, 5 Nov 2024 23:03:39 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 1/3] ebtables: Clone extensions before modifying
 them
Message-ID: <20241105220339.GD10152@breakpoint.cc>
References: <20241105203543.10545-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241105203543.10545-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> Upon identifying an extension option, ebt_command_default() would have
> the extension parse the option prior to creating a copy for attaching to
> the iptables_command_state object. After copying, the (modified)
> initial extension's data was cleared.

Patches look good to me, thanks for adding test cases.

Acked-by: Florian Westphal <fw@strlen.de>
