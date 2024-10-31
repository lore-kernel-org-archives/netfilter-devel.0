Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B142E1BD9CC
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2024 23:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730415743; cv=none; b=j4GrXbzWlGguJn2bx9dXcNrqCS0j91iX5mLTC05rCY7T9erzGZsNbxjcO9YbAqE+UyV9Xjbdknb8r/Pf+CmTq/MQDQWPmiiWwP5QmEA1eLO0c6+6wmSOaWH7y5plcX1CgyeS5ftsq2vsfUhVsFXdkJ2arCtgb4Y/PK+gLn8Qf8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730415743; c=relaxed/simple;
	bh=u4XNKxccoGjFKoMDkMNwefLJ9APiBf7DAT2EGwjd+/w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ulvifkAZTnKBTqzkpL+f2gEHtdpkY1QPEYRAg06pib9V41P0k9Ptr6s5cy+G+bnCR30C4js5qYdgQ4oZrtJvoUAuxTB7kUaxx3PuhxPR9RlMaZK6EVYvh2e45xzfl/+zyfvZp5tz6D+Z+PKX3WBKIId5FG2siTOuFG3xJPvi5h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t6eBC-0001fu-Fl; Fri, 01 Nov 2024 00:02:14 +0100
Date: Fri, 1 Nov 2024 00:02:14 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 nf-next 0/7] netfilter: nf_tables: avoid
 PROVE_RCU_LIST splats
Message-ID: <20241031230214.GA6345@breakpoint.cc>
References: <20241030094053.13118-1-fw@strlen.de>
 <ZyP7Q94DCbwBmobU@calendula>
 <20241031215645.GB4460@breakpoint.cc>
 <ZyQHv5lxlCrciEiq@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyQHv5lxlCrciEiq@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> # nft -f test.nft
> test.nft:3:32-45: Error: Could not process rule: Operation not supported
>                 udp dport 4789 vxlan ip saddr 1.2.3.4
>                                ^^^^^^^^^^^^^^
> 
> Reverting "netfilter: nf_tables: must hold rcu read lock while iterating expression type list"
> makes it work for me again.
> 
> Are you compiling nf_tables built-in there? I make as a module, the
> type->owner is THIS_MODULE which refers to nf_tables.ko?

Indeed, this doesn't work.

But I cannot remove this test, this code looks broken to me in case
inner type is its own module.

No idea yet how to fix this.
