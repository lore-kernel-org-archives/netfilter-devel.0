Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5662314D15
	for <netfilter-devel@vger.kernel.org>; Sat,  4 Jul 2026 09:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783157514; cv=none; b=kRJrpQ/BwJ3Qu7UoFZZrt6xbixSbyDUtRDFf8NGkKZpEbbvX3Op82tP+mjPMHbJRxziNd9OhcWIHD1/va7G8wFK1ZvhEW8+w1HJe18xJ4BrUFuCtAOLNhKj0s1CLiqMuH3Vt6+SpVJzice+A0GMPuX+p6jhqMJZVXD5RYWstEcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783157514; c=relaxed/simple;
	bh=UeuMHe1e6fYelWnjGhltLGSr3YLP4D1aphM7j3xz/oM=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AOAdDoxy9JrGDf6UrmU39zPM8nBEQPGekhhsIsg/etZ0PCu6jWWrqCZF8UHKn3yWkLZzh8VOv+crBY6UpwmK/wX/JzL/brO7vVwCz0BPjb407XulXwQFlQH1unme4s1OcTHOuC9rGtbz6QuQNmXdenqFOhQdBmCfsI+eTll2QxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id BD47F60491; Sat, 04 Jul 2026 11:31:50 +0200 (CEST)
Date: Sat, 4 Jul 2026 11:31:50 +0200
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/3] netfilter: ebtables: shashiko nitpicks
Message-ID: <akjTBkrO5mGCecFS@strlen.de>
References: <20260704084811.27355-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260704084811.27355-1-fw@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> Three academic bug fixes for ebtables, based on sashiko
> drive-by reviews.
> 
> All of these "bugs" have existed forever, kets treat this
> as cleanups.
> 
> Florian Westphal (3):
>   netfilter: ebtables: zero chainstack array
>   netfilter: ebtables: account compat ebt_table_info to kmemcg
>   netfilter: ebtables: bound num_counters in do_update_counters()

Many more drive-bys here.  I don't think this is worth our time.

I propose to axe arptables CONFIG_COMPAT in nf-next
now.

Then, axe ebtables-compat next querter and finally rest of xt-32bit compat
after that.

All the xt COMPAT flavours are already restricted to the initial
namespace.
