Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C3631327A
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 00:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785285572; cv=none; b=dJAzxvV0pXmXw8iSqXhvzQiOGGtvPnqggPnPBriZgFKrUPWss4D6Yp/g0TXTNcgA7rcmFdWdfGAb9+49bUu+VftuTr1zQyrHbkyDWXs5188Lm6Rg31D5u3XYO/dquMyNTiDERwzsrZpPSB2WZfAgNv9IO0udnIEep4DfkN2zJsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785285572; c=relaxed/simple;
	bh=azaKmwhNxu2T8s0ZqwIKynOEhXptRKppW2nBRM0tppI=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cULvOY9oHC/Ta7GZJAC/4I1g3AegrQCsut/8ZsUPr4BK9pyu67vkEZ83ZY3xSEyXwKgTNhItQS8OF7xWwog0mPSw1EoMZCAshUYo8pjSeQsjkPGS16qrDUwSo0A0/3JaUXUQLa1RNuqucE2zg8aPHhMk2vrsEXbPGMXeKtvACtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Jd6lk26+; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Jd6lk26+"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 679AC60194
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 02:39:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785285568;
	bh=NanxPjw0Cj192LnR06sPgf/3volZrsvoK7KhV5wrj5g=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=Jd6lk26+OzbEHJdWFrhuJjdFoigzyRptvuVNoFDVjzm/FI6pFc2DIQp/ZQbuT5xk1
	 zF1l5/0WaOwdwXYM5SUxYT7DKLtDtExL8sxv4CRsKnTix7RFQXzpnt+g1iHo/Ho7jS
	 eYHg7vAJkB54RMcoiqAgD7HTt5r6PVXCqB5iMVmt24WdR+PW2Brkr1F1idZP5APhD1
	 qwjMnHH9vMX6i5YE7XtZ66uFVBbB9kFQJx5qA/VjOmhvpok057sdZ+2IKyUizC2Rs3
	 EHpyOGWYvJgOuT2lPa+OLUhoHLNAuSU3ZFCxHOo0OJwBtxnAy22LHldd1MSPQCBKpq
	 3eLUGho4JibkQ==
Date: Wed, 29 Jul 2026 02:39:25 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_conntrack: move expectation hlist_head
 on ct extension realloc
Message-ID: <amlLvY22NrVZUhSs@chamomile>
References: <20260729001645.254396-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260729001645.254396-1-pablo@netfilter.org>

On Wed, Jul 29, 2026 at 02:16:45AM +0200, Pablo Neira Ayuso wrote:
> Commit 7c9664351980 ("netfilter: move nat hlist_head to nf_conn") moved
> the nat hlist_head to nf_conn and it removes the .move callback for ct
> extensions. This commit description already points to the same problem
> that is being addressed for expectations by this patch:
> 
>  1. ...
>  2. When reallocation of extension area occurs we need to fixup the
>     bysource hash head via hlist_replace_rcu.
> 
> This means that the .pprev pointer of the first expectation might refer
> to a stale hlist_head after reallocation.
> 
> This bug is now easier to trigger since the introduction of the commit
> 857b46027d6f ("netfilter: nft_ct: add ct expectations support") which
> allows to create expectations before the ct extension area have been
> fully set up for unconfirmed conntracks.
> 
> This patch uses hlist_move_list() because this conntrack is unconfirmed,
> ie. not yet in the hashes, and it is neither visible to the conntrack
> garbage collector nor ctnetlink.

Scratch this iteration, ctnetlink_del_expect() can reach the
expectation.
