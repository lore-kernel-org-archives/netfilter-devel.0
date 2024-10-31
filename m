Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4881946BC
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2024 23:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730417871; cv=none; b=GusRRIPoOXZRioYRG5n97xtBiveynC/0B5DglB0T4ZJUhD/GuMN2Ip5M/PqPAdFWfMoUepXykYshMqttTwSlPzZsXOZ64jjY3mWTsRL1laVwxAB60xZ1ZXevaKeeecZWCnojhwdnBaB/m5TVxY0C0AeTGbeTWYjcwSeuml+iyWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730417871; c=relaxed/simple;
	bh=EcJCIeGKOCgbt1E3mGyK/N+RMW07l+XN9cxM/BwomdA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mlHLUij+kd86HE1MiG/hD1r33PSlX8kyJrGrxXf2cPJFGWuq4D6KpbepLlxA0RlUub8fx6geQ4nMiuuTiuZKhQOrQpYXQrXt0uhgLDgg/NjYnh0+F97N1seKw0kOJ19xoIgZJM4hFEkTxvA/7HSdye67sNpYYPbSdlCBwimJO2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t6ejW-00027A-59; Fri, 01 Nov 2024 00:37:42 +0100
Date: Fri, 1 Nov 2024 00:37:42 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 nf-next 0/7] netfilter: nf_tables: avoid
 PROVE_RCU_LIST splats
Message-ID: <20241031233742.GA8050@breakpoint.cc>
References: <20241030094053.13118-1-fw@strlen.de>
 <ZyP7Q94DCbwBmobU@calendula>
 <20241031215645.GB4460@breakpoint.cc>
 <ZyQHv5lxlCrciEiq@calendula>
 <20241031230214.GA6345@breakpoint.cc>
 <ZyQR-4X_hw6ZRpRI@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyQR-4X_hw6ZRpRI@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Nov 01, 2024 at 12:02:14AM +0100, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > # nft -f test.nft
> > > test.nft:3:32-45: Error: Could not process rule: Operation not supported
> > >                 udp dport 4789 vxlan ip saddr 1.2.3.4
> > >                                ^^^^^^^^^^^^^^
> > > 
> > > Reverting "netfilter: nf_tables: must hold rcu read lock while iterating expression type list"
> > > makes it work for me again.
> > > 
> > > Are you compiling nf_tables built-in there? I make as a module, the
> > > type->owner is THIS_MODULE which refers to nf_tables.ko?
> > 
> > Indeed, this doesn't work.
> > 
> > But I cannot remove this test, this code looks broken to me in case
> > inner type is its own module.
> > 
> > No idea yet how to fix this.
> 
> I'm missing why this check is required by now.
> 
> Only meta and payload provide inner_ops and they are always built-in.
> 
> I understand this is an issue if more expressions are supported in the
> future.

Can you mangle the patch to remove the type->owner test and amend
the comment to say that this restriction exists (inner_ops != NULL ->
builtin?)

Else this might work:

+       if (!type->inner_ops || type->owner != THIS_MODULE) {

... but that would also need a comment, I think :-/
