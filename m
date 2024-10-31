Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23451E481
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2024 22:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730414560; cv=none; b=e1LRlqQKxF7IxbaLwymRMMgDvSlmGVEAo6ZrR+p9msV1DinmFJWoZb2PJ/N7SkJ+U+tDOpOCImq9C2aLbP7KveZpYRBvZT3eRb5p+gH6JEwubVlfEztzYYZsu0qVr0vNtKYBd1hqiJIN1lfo+XD2atlHxZZuD4pil60fuQsWCFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730414560; c=relaxed/simple;
	bh=VX7/StVIli/78iurQ34k9Ym2/7av2e377ENPz8G/A8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=csP11YgpX9aGFyij9mR+S5PjLg30uIrwriXM32aXq0M5yvm+XdQ982rlLfgbw3dSla1dCC5cBWuKu0g88Dt1hu84iQN7uSeUPY7LW4IDLf/bY6NJrpUW8PlYNE/pB8z7y/zSHodWqV+hsPi7VFDTOpKyNKOq3mQUeLGDnz9Q6es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=55784 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t6ds1-00HEeQ-Cn; Thu, 31 Oct 2024 23:42:31 +0100
Date: Thu, 31 Oct 2024 23:42:25 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 nf-next 0/7] netfilter: nf_tables: avoid
 PROVE_RCU_LIST splats
Message-ID: <ZyQHv5lxlCrciEiq@calendula>
References: <20241030094053.13118-1-fw@strlen.de>
 <ZyP7Q94DCbwBmobU@calendula>
 <20241031215645.GB4460@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241031215645.GB4460@breakpoint.cc>
X-Spam-Score: -1.8 (-)

On Thu, Oct 31, 2024 at 10:56:45PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > This targets nf-next because these are long-standing issues.
> > 
> > This series breaks inner matching, I can see tests/shell reports:
> > 
> > I: conf: NFT_TEST_HAVE_inner_matching=n
> 
> Uh, didn't i fix this in v2?  V1 had a bug in patch 6:
> 
> +       if (!type->inner_ops || type->owner) {
> +               err = -EOPNOTSUPP;

I am using v2, I can see this chunk.

> V1 had !type->owner, which causes feature probe to fail and the test to
> skip (it skips builtin instead of module...).
> 
> I re-tested, I get:
> I: conf: NFT_TEST_HAVE_inner_matching=y

# cat test.nft
table ip t {
        chain c {
                udp dport 4789 vxlan ip saddr 1.2.3.4
        }
}

# nft -f test.nft
test.nft:3:32-45: Error: Could not process rule: Operation not supported
                udp dport 4789 vxlan ip saddr 1.2.3.4
                               ^^^^^^^^^^^^^^

Reverting "netfilter: nf_tables: must hold rcu read lock while iterating expression type list"
makes it work for me again.

Are you compiling nf_tables built-in there? I make as a module, the
type->owner is THIS_MODULE which refers to nf_tables.ko?
