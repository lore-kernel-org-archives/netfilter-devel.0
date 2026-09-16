Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281484F7998
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Sep 2026 13:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789565233; cv=none; b=HrXomFVKsUq7wF/Bw4dMq92q/8trL2sK2upMOtBDrBjll06Gb1mP/Y5egpj+FUM7ieY07EqBkcmq/9mC8+fL1mGQzY0Fupd6OQkqi1OWqXi9jfT0CjgrrCfDw21yTe3by8t2hfyeFXZWcwoSPwtFnY4Fpp16W2fvO6KpBnZeo3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789565233; c=relaxed/simple;
	bh=PUoe2Adz4sysvOB8cfWlo9soO4XEH+NTmqcVutVL6lM=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bnVyIyiOhRW97YgL3I77e5imvpG7hPr0JFZ9NOHci9LEWkZJkYEjvSuFCP7XIAcux6eH/625WKOh+ld0jlgPhRuNLz4351/P+shQ2JdJJVTYURqP7MxPG5pERUc548Dohqtr1sJguywoReQ6o+WwYGji33wRNQQk36zVdY/dJz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 732DF60456; Wed, 16 Sep 2026 15:27:04 +0200 (CEST)
Date: Wed, 16 Sep 2026 15:27:03 +0200
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v5 0/6] ipset: replace internal hash table with
 rhashtable
Message-ID: <aqqZJ8mgGIS48TJt@strlen.de>
References: <20260916125151.28062-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916125151.28062-1-fw@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> v5: add Herbert Xu's new rhashtable_flush_and_free() to rhashtable, this
> replaces my own version from v4.  I also dropped a few follwup patches
> with further changes/cleanups, not strictly required for initial
> conversion.

I hate this world.  More LLM mumbojumbo.  No idea I can ever get
this in a mergeable state.
