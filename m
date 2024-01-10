Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC91D3B185
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2024 08:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rNUCm-0006xV-4y; Wed, 10 Jan 2024 09:44:56 +0100
Date: Wed, 10 Jan 2024 09:44:56 +0100
From: Florian Westphal <fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 nft 3/3] evaluate: don't assert if set->data is NULL
Message-ID: <20240110084456.GC7664@breakpoint.cc>
References: <20240110082657.1967-1-fw@strlen.de>
 <20240110082657.1967-4-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240110082657.1967-4-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)

Florian Westphal <fw@strlen.de> wrote:
> For the objref map case, set->data is only non-null if set evaluation
> completed successfully.
> 
> Before:
> nft: src/evaluate.c:2115: expr_evaluate_mapping: Assertion `set->data != NULL' failed.
> 
> After:
> expr_evaluate_mapping_no_data_assert:1:5-5: Error: No such file or directory
> map m p {
>    ^

This is also the error that one gets with nft 1.0.7. Will add
Fixes: 56c90a2dd2eb ("evaluate: expand sets and maps before evaluation")

to the changelog.
