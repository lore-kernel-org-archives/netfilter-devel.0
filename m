Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD63C2F25E0
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 17:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761672386; cv=none; b=uYhxt+LJcuazx/xa3LU9OTWZR/5a1udsR0jLzIzdIQij55rgN9wo5/JMjPOY5soLwgEqpiPxmXHhThy+ycKMcgJi1jW3l4qStil2UFqEyIZQZRfkCNjh9f9Cuz5vf8A7a9xS2JFqITpIGP+8p1/yEZ1WDa0LMXiNy2I+ZKFu4bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761672386; c=relaxed/simple;
	bh=nA9LMOBOqaZdMnjpBR4oMe0qOP1YngowHmc5h43cGt8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K+sFrlB6jBv77k5wCot/LkZRD0O8W7Z9HU/0wW8qS6Mjd7vc+fD+qrg9e6Xg8VD7izR3VJf6VvdnEoz2jwzVjJHcTZgQ9vVucNOc3MObZfyj7KBvNAv3DhwJgJQ0EJF79tPPLaAJRAZ/MFRazlwNN67ReXR0xT6HYkGDXe2bHLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=E+CusihZ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="E+CusihZ"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5BA986028D;
	Tue, 28 Oct 2025 18:26:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1761672382;
	bh=7uTBoRfgbM4TdvNBPqdchorMtElJnRVesVGB9hIkNSM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E+CusihZdl2TG6i6fAVFZV34/3/riselgCKkgcYMgmGrZJusSNPn0zALvdKoUA6LN
	 ufwdHyM65Cq5QHaczSvpxlPqtId3NNIwT2uyg3j8QSYtKqELZ5PQ4zbyaj7AF8XcCQ
	 zdtqEJXQ7GvAKlBQ3/90KMX3bJ3CMI1xzmG/S29F/QO7qjCBSiOEJOb7hoICbOskXr
	 i320lgMHMgiudzhENd+Gj0+tRudmFdfbADoj9NU3qi4z3vO2iB+gBSbwxqNmJYw/ia
	 WSypXm8fJSPwptcNbZclF7b5ADhilx2meM0fKoQhLnUAuhBeRej+aBtvzsTrF5/bXv
	 CXX4vQcrnGv4w==
Date: Tue, 28 Oct 2025 18:26:20 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, ffmancera@suse.de,
	brady.1345@gmail.com
Subject: Re: [PATCH nf 1/2] netfilter: nf_tables: limit maximum number of
 jumps/gotos per netns
Message-ID: <aQD8vKn0O5iNuxif@calendula>
References: <20251027221722.183398-1-pablo@netfilter.org>
 <20251027221722.183398-2-pablo@netfilter.org>
 <aQC_3p8Xu9-p48nV@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aQC_3p8Xu9-p48nV@strlen.de>

On Tue, Oct 28, 2025 at 02:06:38PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Add a new sysctl:
> > 
> >    net.netfilter.nf_tables_jump_max_netns
> > 
> > which is 65535 by default, because iptables-nft rulesets are more likely
> > to have more jumps/gotos compared to native nftables rulesets.

iptables needs higher value, while nftables with vmaps could set a
much lower value, because vmap counts as a single immediate jump.

> I have existing / real-world iptables dumps that exceed 64k :-/

OK, so k8s can load this ruleset inside userns (because netns can
still rise this value). But your concern is the default value, right?

I can extract from that iptables k8 ruleset a good default value.

> I'll forward you one of them.

Yes, you passed me this huge ruleset.

> Seems this patch misses a reset somewhere to deal with
> chains/tables being deleted:
> 
> sysctl net.netfilter.nf_tables_jumps_max_netns=256000
> net.netfilter.nf_tables_jumps_max_netns = 256000
> iptables-nft-restore < kubernetes-huge-may-2018.txt; echo $?
> 0
> iptables-nft-restore < kubernetes-huge-may-2018.txt
> iptables-nft-restore v1.8.11 (nf_tables):
> line 52222: RULE_APPEND failed (Too many links): rule in chain KUBE-SVC-FCXG7AJXWMSO3TT5

Ah I see, let me have a look, it is missing deleted tables, yes.

> works after 'nft flush ruleset'.
> 
> I also have a hunch that a followup patch that sepearates ip and ip6
> families (since they are mutually exclusive) will be needed sooner than
> later.

I can take look, you mean:

- IPv4 count => count jumps in all table except ipv6.
- IPv6 count => count jumps in all table except ipv4.

Here, IIRC, I needed ~8 million jumps (_not_ net jump counts in the
rule, I mean number of jumps according to nft_jump_count_check()) in
the input chain to see softlockup with KASAN+KMEMLEAK.

256k is still far from 8 million.

> If even a random old iptables-dump exceeds the 64k limit I would expect
> combined ip+ip6tables rulesets to be even more brittle.

Yes, the problem here to set this default value is iptables,
nftables can set it very small, but iptables needs a large one.

I guess native nftables users can safely shrink the default value we
are going to set here.
