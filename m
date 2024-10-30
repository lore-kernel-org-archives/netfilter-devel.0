Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6F61E32C5
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Oct 2024 10:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730284866; cv=none; b=hir1D4o3ntpytduJEtZU+3bXuG+Lka9b0N0V2PwVcECGG1THcBERNMBKbIyJvXGHSKEgEfruofhmMNNNtaEK9aR+9VUyKuKG4ULBFnI2ML8ymhfROsfSEH9hWbIoWjsP3BBL5uwSGconLoWDS/Y69QWkeR9Ls/9XneUjZt388hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730284866; c=relaxed/simple;
	bh=VU7TTpJ1OpZwRCY8FxMiIlmCdgobUoutrX7v87TNBwk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XB9XJ4OJge/vpwzMGAmb4ZfCdQFFFYACsC9VCDupOouenlxz8+twYQLK9p17Mnp7T91AhPpFNMH5uX1BQ/hs7DJVOtEBD5XVF6monXbOEwAS6krzEuStD+0No+MYd1Af0Y/pmy4BgSABED+/IoE4qXDtmuaudVaeyDUwHXDIOcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=53242 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t668I-00Aw1w-3c; Wed, 30 Oct 2024 11:41:00 +0100
Date: Wed, 30 Oct 2024 11:40:56 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 nf-next 0/7] netfilter: nf_tables: avoid
 PROVE_RCU_LIST splats
Message-ID: <ZyINOAO_Pl1QKQQL@calendula>
References: <20241030094053.13118-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241030094053.13118-1-fw@strlen.de>
X-Spam-Score: -1.9 (-)

On Wed, Oct 30, 2024 at 10:40:37AM +0100, Florian Westphal wrote:
> v2: fix typo in commit message & fix inverted logic in patch 6.
> No other changes.
> 
> Mathieu reported a lockdep splat on rule deletion with
> CONFIG_RCU_LIST=y.
> 
> Unfortunately there are many more errors, and not all are false positives.
> 
> First patches pass lockdep_commit_lock_is_held() to the rcu list traversal
> macro so that those splats are avoided.
> 
> The last two patches are real code change as opposed to
> 'pass the transaction mutex to relax rcu check':
>
> Those two lists are not protected by transaction mutex so could be altered
> in parallel.

Such list is altered via module load.

> Aside from context these patches could be applied in any order.
> 
> This targets nf-next because these are long-standing issues.

Series looks good to me.

I am compiling/running test, I am going to prepare a PR with this
series.

Thanks
