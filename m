Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C74B1D88DC
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Nov 2024 23:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730848505; cv=none; b=m3ogd+NzgYrXi4iGEHVCKTtvSlQCz130a6EA0gctkkSEoJ3eD+ks5vs7EnmVHa6Wm5hdcf4EfAjsLmAyjfatJDv2AFxkOFYqwGcsSRQ7gym+JcpnDmtcoT5h0VOL9HHax1Qd/uN7UhNurMopYg/XZQsb9SspbvQEARUlKQoyERA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730848505; c=relaxed/simple;
	bh=yIBf1L4p6DHIf2dS5bAEJdl8vMXCM0U8cFgbQdCdK40=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HCRdGLgz0H290M8sAxtrO/UYUeNk63FWCK93tudHxKAToNiM2LaYpopPEQfi8wJkCwM9S7f9cMWgMpTvGTWF0UKPTKRi7mgsnNf4c2wif29/WyBEcthJ3yzqtlozOA+FOBhqZDy2V5yPXWOkpZbZjZRdM4v8Ou1Se/deD0VhwuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=38862 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t8SlF-006oAy-KC; Wed, 06 Nov 2024 00:14:59 +0100
Date: Wed, 6 Nov 2024 00:14:56 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v3 0/7] netfilter: nf_tables: avoid
 PROVE_RCU_LIST splats
Message-ID: <Zyqm8Ld3c3qvNX7I@calendula>
References: <20241104094126.16917-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241104094126.16917-1-fw@strlen.de>
X-Spam-Score: -1.9 (-)

On Mon, Nov 04, 2024 at 10:41:12AM +0100, Florian Westphal wrote:
> v3: don't check for type->owner and add comment saying check on
> inner_ops is enough.
> Use IS_ERR() instead of ptr == NULL in patch 7/7.
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
> in parallel in case of module load/removal.

I have placed this series in nf-next testing branch.

Thanks Florian.
