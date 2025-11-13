Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7112C0265
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 09:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763024730; cv=none; b=hSo6BcBKSOJS4S6k/FlG4HMI3woLKPGsD9NnXWyl8nM1o+r48lz5QHEJ76YbTfVpgkouA67YDuVZAlH6sWraSGXIRpzUkIe3Cgl84DAYE+AJvY7O7t+Ou1qalsF3WvyWG1ljciVzOp4tRE7C8nU1jOArkQ5YW6B31j1Y2mjPQVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763024730; c=relaxed/simple;
	bh=cpmYb5soutkeQj89M0rYErhrtHK4cEGLxFlIfevMhrk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c9UMc4jG5jb/LwipiQZl9PJez3rwCgfBaGb39ENQ3QWANdYa2zx9yE8TbRWlUQR6IFCAk35noImT4xyZp1YNe2TIsQcGw6j1ZEYGSA2DCC3k+DRRfrf8nDedV2++nbTjTrfHs/jTGzJw3dHwHMqCjQyAoxBBBPy9Q8JgSbAsk7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=UzSYpIhx; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="UzSYpIhx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XX3c5dmBJWZq08xQ0Yf9tZPIjdu92pxv4mq/QuUgzns=; b=UzSYpIhxgA3OeZzuNIeprHEV3Z
	sljUy0rNIioUdb24+dCPg7kuwDtAjBGmqSJ3HRI7UYXdnM6kTfG3FNb+e5dJhGphtqbjzSmq+2V1R
	e/72Fv3oFqylZFgWieUqA/LX8VBunQVNv79XAo2vpP6WuYjN66aMcjEAj1KRqWLL6NWE+7qJgdXAp
	XofA9Rer8IdHR4f3A02m6vc1wDhzkonVB4ehZ8zPfH1gsEqHev2vzJovTPquC3rmvXyKN2RL1fvbw
	v8qF8jeBAjLgdP84DHU2puTy/VQdiWwQNlfCaqbbCrMah9ux5LZs46PwMENyIe4N0dDcLTWUHdgrO
	+E0JJKUA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vJTGe-000000002J3-29m4;
	Thu, 13 Nov 2025 10:05:24 +0100
Date: Thu, 13 Nov 2025 10:05:24 +0100
From: Phil Sutter <phil@nwl.cc>
To: Yi Chen <yiche@redhat.com>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2] tests: shell: add packetpath test for meta time
 expression.
Message-ID: <aRWfVPJlNW28gXlD@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, Yi Chen <yiche@redhat.com>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20251113072851.17420-1-yiche@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113072851.17420-1-yiche@redhat.com>

On Thu, Nov 13, 2025 at 03:28:51PM +0800, Yi Chen wrote:
> v2:
>  - Switched to range syntax instead of two matches as suggested by Phil.
> 
> Suggested-by: Phil Sutter <phil@nwl.cc>

AIUI, this tag is used for people suggesting the change itself, not
reviewers requesting changes to the patch. But I guess this can be fixed
up while applying.

> Signed-off-by: Yi Chen <yiche@redhat.com>

Reviewed-by: Phil Sutter <phil@nwl.cc>
