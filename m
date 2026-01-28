Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F1C350D44
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Jan 2026 15:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615143; cv=none; b=FiDXM8NiidxOW9lUVVcPhCgfa9KDo2Rzzko4JLsO7q1bFW+uoViQxRPyE3jTZ9sxlVUjfES7wlPdOz+1Qo1BCwRr8bD4fDUVfA6xxmO/9qpNHNxhz/Wwj9H7k4tf7DuJyfTLcnJHu4BF/0RToWMbeVsh/6aqsAwecPsX6f47Kbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615143; c=relaxed/simple;
	bh=sRJMxEHiWKRaDqce1HIJXy+s/KXi+nXrTTTNO5HZ0f8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EGdYxECWvmfe+2i+jy7HN66rDoya+cj57l5QSNBCt2HaEJzYenRPA6cB0OsszLfWnTqKl0HsMhJTJgeKWLrpPifmwYWlUAObSDzZS4FYUBtrQzD97Cuns3iGSfy9AeEtxI6P+5eQbdrFFGqZVz368zJVp35DE5FXHXX3GXmhGrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C7BA6605C1; Wed, 28 Jan 2026 16:45:40 +0100 (CET)
Date: Wed, 28 Jan 2026 16:45:41 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/4] nf_tables: complete interval overlap
 detection
Message-ID: <aXovJVWj5PD-wrN9@strlen.de>
References: <20260128014251.754512-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128014251.754512-1-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Overlap detection from the kernel in interval sets is still missing a
> few corner cases, this is currently mitigated by nft from userspace by
> dumping the set content for each add/create element command.
>  
> This series is composed of:

Looks good to me.  I've held this back because syzbot found a problem
with rbtree + bsearch blob getting out of sync in some cases and
I would prefer to first get things back under control before making
more changes to it.

I wasn't able to fix all of the problems so far and need more time
to add relevant test coverage.

Once rbtree is back to 'syzbot is happy again' state I will apply them.

Sorry for the inconvenience.
