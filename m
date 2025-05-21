Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D5A191F66;
	Wed, 21 May 2025 11:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747826568; cv=none; b=QdPq0sfhgmnbWfwyBTiKs0QkBTJd7hSewEG6mlKpU9XsJkttHU05NJgNgLuf2mTT2puXp/5kok6KfVT30DYBH7znbf8Lg9PvF3O/DENqsgi2ySU6PveOCV/GLgokfCbEDv+xjjiRzLXqXMZKDrROJ4mLez6zPNgNmfeU2ZKQaxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747826568; c=relaxed/simple;
	bh=cLCCirV9GPkFMi7h2wcC+PoguTJJ/VUPlFEcuFDnzNA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n5Qs8VhgNkA4dnhZKQUvJeu5nEhgWuZP5+7QnaPeCn3umk6y4K4DVKpj/PdcpcnRAZW8hfWVFLXNfWzA0tWoL7dSaW4NCqxn99Qu07hX/NqolhKTzrA3CAEZb2gGRXL++OTAMIaXh8HFDCvbIV/Eo2btYhvJoKQm1YeRbgnCzmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0B90A60167; Wed, 21 May 2025 13:22:42 +0200 (CEST)
Date: Wed, 21 May 2025 13:21:49 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Lance Yang <ioworker0@gmail.com>, kadlec@netfilter.org,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org, coreteam@netfilter.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	Zi Li <zi.li@linux.dev>, Lance Yang <lance.yang@linux.dev>
Subject: Re: [RESEND PATCH 1/1] netfilter: load nf_log_syslog on enabling
 nf_conntrack_log_invalid
Message-ID: <aC23TW08pieLxpsf@strlen.de>
References: <20250514053751.2271-1-lance.yang@linux.dev>
 <aC2lyYN72raND8S0@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aC2lyYN72raND8S0@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> I have been beaten by this usability issue in the past, it happens
> since conntrack is loaded on demand.
> 
> Maybe add an inconditionally soft dependency? This is a oneliner patch.
> 
>         MODULE_SOFTDEP("pre: nf_log_syslog");
> 
> Florian, do you prefer this patch (on-demand) or a oneliner to load
> this module when conntrack gets loaded too?
> 
> It is a bit more memory to make it inconditional, but better to expose
> to users this soft dependency via lsmod.
> 
> Thanks.

I don't like this patch or the above because we do have two log
backends, syslog + nflog.

There is no need for 'syslog' to be active for 'log_invalid' to be
useful as long as the system in question has e.g. ulogd running
and listening to nflog messages.

If anything, the modprobe should be done only when no logger
is registered.
