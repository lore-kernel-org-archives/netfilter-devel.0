Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4079C15DBB3
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Apr 2025 12:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743770523; cv=none; b=YxiloLSMlwRlftAMmC3w/hEMFXH2U47urjIIj1VjbPNEweEl9YBqF0kHgtxq0KMNt8kQ3JX9ZKjvHiK7LoxeiaqJD70PMgQDYJJhZNlgFeGUPLbQa1RSZBo79vykuInJ9uofDdv1dzSzncfsw9zNn2+bEFBzKZ6oHa4GfS5XT5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743770523; c=relaxed/simple;
	bh=887WqdEvOIuh1qVWGolvZlCW9oM7ukFjD72Kn4i0q2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aYEug4lEOE3E1HH/BFKlNVcl/+xTLswlNScDniTgZIQ26u2cB6YJRU37RVtc4u7G+D2oBs5wu874kr/etsWRBSVlQior5tKvaXUqblmHtSYQspHZbyYtMsxKnyU5D27BWuM6qq13YOSTsnO+qyQtgjjS6joSjvrxIZc8BsWU8dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1u0gMt-0000bD-Tb; Fri, 04 Apr 2025 14:41:55 +0200
Date: Fri, 4 Apr 2025 14:41:55 +0200
From: Florian Westphal <fw@strlen.de>
To: Xuanqiang Luo <xuanqiang.luo@linux.dev>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de,
	davem@davemloft.net, Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Subject: Re: [PATCH nf-next] netfilter: Remove redundant NFCT_ALIGN call
Message-ID: <20250404124155.GB28604@breakpoint.cc>
References: <20250404094751.106063-1-xuanqiang.luo@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250404094751.106063-1-xuanqiang.luo@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)

Xuanqiang Luo <xuanqiang.luo@linux.dev> wrote:
> From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
> 
> The "nf_ct_tmpl_alloc" function had a redundant call to "NFCT_ALIGN" when
> aligning the pointer "p". Since "NFCT_ALIGN" always gives the same result
> for the same input.

Acked-by: Florian Westphal <fw@strlen.de>
