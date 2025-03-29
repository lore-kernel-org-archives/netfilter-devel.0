Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0AF17B402
	for <netfilter-devel@vger.kernel.org>; Sat, 29 Mar 2025 14:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743256812; cv=none; b=DhA4dDYOcxoiVjSy3YJjz9p9OJ3SP1CFb+1JScDwUSPeZIpzV5X4rfw4skWuISnrLYmf5QRngiUqR30SMEXW+R5z5hR8/HxRciH54Uk+0z50x5JnGsRV74NwMg50aAO0q1zJJBokLhe5yVc2kaNzgSeff/kcUcrBYuDZQ6qS0NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743256812; c=relaxed/simple;
	bh=UxqjtAVUC6pN0C6ukhJTag7ZcFS4LvoUTlIaNHvvrPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kByJb2A5Fy5ccutzVUuMpK/+WY7TGuRwsjr4QotoIQTmWcospuEF3WjXAjQyieRYFqtjJxOPfn5f8Zbeo7/PmYc7yNzvG0DGnrPwv64maaXTTOxBZYn5mZ95fKN912NwqUi/Tawm6LUAYaWQFPKRE81zBfssRt4A0TzXWqdaHNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tyWjH-0005gv-NM; Sat, 29 Mar 2025 15:00:07 +0100
Date: Sat, 29 Mar 2025 15:00:07 +0100
From: Florian Westphal <fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: Corubba Smith <corubba@gmx.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH ulogd2 1/2] ulog: remove input plugin
Message-ID: <20250329140007.GB19898@breakpoint.cc>
References: <23db0352-9525-427b-a936-c8ef87e4d5b7@gmx.de>
 <20250329133121.GA19898@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250329133121.GA19898@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Florian Westphal <fw@strlen.de> wrote:
> Corubba Smith <corubba@gmx.de> wrote:
> > The ULOG target was removed from the linux kernel with 7200135bc1e6
> > ("netfilter: kill ulog targets") aka v3.17, so remove the input plugin
> > for it. It's successor NFLOG should be used instead, which has its own
> > input plugin.
> 
> Your email client is reformattig parts of the diff:
> % git am ~/Downloads/ulogd2-1-2-ulog-remove-input-plugin.patch
> Applying: ulog: remove input plugin
> error: patch failed: doc/ulogd.sgml:132
> error: doc/ulogd.sgml: patch does not apply
> Patch failed at 0001 ulog: remove input plugin
> hint: Use 'git am --show-current-patch=diff' to see the failed patch

I resolved the conflicts locally and applied the patches, please
double check that I did not miss anything.

> https://patchwork.ozlabs.org/project/netfilter-devel/patch/23db0352-9525-427b-a936-c8ef87e4d5b7@gmx.de/
> 
> Can you send the pach to yourself and make sure "git am" can apply it
> again?

FWIW, it looks like something in the delivery path removes trailing
spaces, turning "some line \n" into "some line\n" which will make git-am
fail as intree and diff don't match.
