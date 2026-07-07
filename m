Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E8E3ED3CD
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jul 2026 10:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783420305; cv=none; b=gF0u/K3aM3RSH8XgWlbZAU6EIy9cR16LRyJVoglgXofZFOzFRVaG1vmtVlzMT3vwPtIhYZiygijLqOqC5oX0xIbc/C/jHEVwx6/LxpkF/tpKfSFPu5eFLGzGKMWfNfPzqKlDCmhl4SAD/gdHtWcFZKOt3vQ8EIVEJbVjx9cVdfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783420305; c=relaxed/simple;
	bh=/aA5GyhuQpl9bU98YSBXniNG69ZkWIyZdWhF6HcuObc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T5ABR9W9/P28YnrQ0C0MFzy64XY3KhnXsfcEMmC+lBo9dql2ipaVSN0+NgRh+013zxj5jGoB27OIFZduFhsrYOUgu2uMPNJILV34HxEaYM4PR+9d2mYYi1RkBAAxwaITO7F4Rv7TQ+FhmdlPGD3PTWPUpn8SiVp6zqI4NVynEcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7DA9B6047A; Tue, 07 Jul 2026 12:31:34 +0200 (CEST)
Date: Tue, 7 Jul 2026 12:31:34 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, lorenzo@kernel.org,
	chzhengyang2023@lzu.edu.cn
Subject: Re: [PATCH nf,v2 2/3] netfilter: flowtable: IPIP tunnel hardware
 offload is not yet support
Message-ID: <akzVhnsxasPRga8H@strlen.de>
References: <20260630094056.97038-1-pablo@netfilter.org>
 <20260630094056.97038-2-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630094056.97038-2-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> No driver supports for IPIP tunnels yet, give up early on setting up the
> hardware offload for this scenario.

This series triggers many drive-by findings.

No big deal, should be addressed later.

> +	__set_bit(NF_FLOW_HW, &flow->flags);

Would you mind if I mangle this to use set_bit() ?

Its a low-hanging fruit, the other findings need
more attention.

Otherwise I can also apply this as-is, its an improvement
in either case.
