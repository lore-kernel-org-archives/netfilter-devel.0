Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22F347F77B;
	Fri,  2 Oct 2026 09:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790935019; cv=none; b=TNN13IX7sAJarYMLnfyDakggOA5qsUDVJGzYTiQvs/r8b/jwwv4fMVtbABMFbrQG9u+FTYGuh91ls7CjlBolsc6ersZ5YedjDhL0KevCFbcf7Z3JkwutK46SouRLIS25eFnzdlaNGXoojzOE+ImanA2aKftSaZ56pBPzmztDFsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790935019; c=relaxed/simple;
	bh=IudtT5JVMzpeJTtXWYungiz/lcHganogxX0kfZhrCGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b4ji7zCqE9qZcnSC7TECGKOmhIah0pGu1vS9SIYeHnN79yl8PjefBLBg5qwknlaKwrn+C6FuHmescm3EbwjKbhWZldYmVitzagrp8QoA2SvI4UVPcDYrBHFUxgLpeNAks/nhHYYqpFspaLmAwJBBC9EhMqOgfpQ3umD/SC1bEOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Lm8/N+LR; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Lm8/N+LR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790935012;
	bh=pSfqvQVESVQLK/sCxwFCXROQqP+UwcpLSQ87zRZCZPg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lm8/N+LRsfEfemtExzqNK2UYTJ8ylsXuZbrYbp0pEJvfS2+DgyHoEPvQJNAZD08Kw
	 PbT0GGw+XKZGm4Q4gjT1Qn7mr0qbYYQj+GaSgo9eriqMiUhfHZzWw4ZjrHpicCJDtH
	 Q301O7w7kXt0PRAo/rJEkef3SWceroLt44sXtOIKAmX+u6vauGJz2t8dwutdaXcD89
	 6sK9AvpsPHOf8XoX+Q7AHS4Wao7ZRHymryDMhdiJrDNxf6SmMbghEnuuqE+UoI4V9+
	 W7KZ1fFB6Fiv4zELEWijPMPaLq9Usc3XLQ7tytg1k4GgxpjZTsIZwx3ZS6rokYlZDc
	 183r19B7OVrQQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id E399660232;
	Fri,  2 Oct 2026 11:56:51 +0200 (CEST)
Date: Fri, 2 Oct 2026 11:56:49 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Daehyeon Ko <4ncienth@gmail.com>
Cc: fw@strlen.de, phil@nwl.cc, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH net] netfilter: conntrack: avoid recursive master
 destruction
Message-ID: <ar9_4aVjl37HHnbz@chamomile>
References: <20261001180224.1018290-1-4ncienth@gmail.com>
 <ar6yM0h2zdVUU4rt@strlen.de>
 <20261002053941.1132097-1-4ncienth@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261002053941.1132097-1-4ncienth@gmail.com>

On Fri, Oct 02, 2026 at 02:39:41PM +0900, Daehyeon Ko wrote:
> Thanks for taking a look.
> 
> I think this check is reasonable for CTA_TUPLE_MASTER, but it does not seem
> to make master chains impossible by itself.  There is another master writer
> in init_conntrack(): expectation fulfillment assigns exp->master to the new
> conntrack.
> 
> In particular, ctnetlink_glue_attach_expect() can attach an expectation
> from an NFQUEUE verdict and set assign_helper.  The expected child then has
> both a master and a helper, so it can serve as the master of another
> userspace-helper expectation.  That path does not pass through the proposed
> check and has no cumulative depth bound.

Then, just restrict glue_attach_expect() to reject this too.

> This helper propagation was intentionally restored by dcb0f9aefdd6
> ("netfilter: nf_conntrack_expect: restore helper propagation via
> expectation") for SIP, H.323 and userspace helpers.  Restricting all nested
> masters would therefore need a wider helper/expectation compatibility
> change.
> 
> For that reason I think nf_ct_destroy() still needs to be stack-safe.  The
> creation-time check could be added separately if nested conntrackd restore
> should also be rejected.  Does that match your intended invariant?
> 
> Thanks,
> Daehyeon
