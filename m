Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2CA14A4F9
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2024 21:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730411355; cv=none; b=sntR/vAwkWosRPwCmDPmjtk6SxLzzVjFuu47Fa+jls3smBKw87R+eOmp1X0hc/qRmTgTW2Q/YMcp3fm3A7Ajovx12eLWtBrdAxatJ8nQgKMTSOOoNiUEOx2YhDa72FVyaGo5QkpVq+oYwQoCaTjSZ882WNyTDDxJUlpkcOSl+q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730411355; c=relaxed/simple;
	bh=vd4umGe9lUZgWBtWzQyO0TbBoNad+noBLl41L2a1bb8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mulmtgu3iL78uZ87e1oWxeCq01mwpxaIqd6kVuSHJLXyILXDj8ShDthf3FqvKdL4Fp4ss+PUTj1kUYPod7QZfym0GRprH+U2ZoBhqkk/RXbKrx0zZgHIVpv5fLZA9HB8uWUhhou3JIaAgDWqdgesF6/eqah3GhMv246DjfIQvxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=46832 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t6d2C-00H3wD-Uz; Thu, 31 Oct 2024 22:48:58 +0100
Date: Thu, 31 Oct 2024 22:48:51 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 nf-next 0/7] netfilter: nf_tables: avoid
 PROVE_RCU_LIST splats
Message-ID: <ZyP7Q94DCbwBmobU@calendula>
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

Hi Florian,

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
> 
> Aside from context these patches could be applied in any order.
> 
> This targets nf-next because these are long-standing issues.

This series breaks inner matching, I can see tests/shell reports:

I: conf: NFT_TEST_HAVE_inner_matching=n

Thanks.
