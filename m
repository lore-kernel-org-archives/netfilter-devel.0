Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C3233032B
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 13:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761656803; cv=none; b=LrProCbbSPhZJ6MXJz4t8j/fTvRa+PaQpdfkQyBZ7yczR93O9g4eBuEXrqInGL5u1lsUi5qKew/d+wBKw1eCsMn5WZbh9axdCmqtFLgM0DbTrfiU4w6KTcSVUsK6OAhjBOQM7E44J2kYMk8Z8oOZTh06i/jmSRKbNPFrZgJacVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761656803; c=relaxed/simple;
	bh=kj1zXZe1ye/igt0NYCpHyPLHOMLRGU7mSIm54FU+phw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cZpdrVQAQBWD2nre3BeEewLHEKct7bgCfu6XDL5BvF7n2t5CFkSQ6eBxh0SDDyLrh+LTGvq/BdchpFnASLMyeCsG9HZHTH/eYcGGi1oLtLYAbFdJuYpL8NjweSpFrhXPmybo5wUhzGGgO+Dh4FHT4cZ5jk/nCrPZ3VS5VD8lPvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 64B9160230; Tue, 28 Oct 2025 14:06:38 +0100 (CET)
Date: Tue, 28 Oct 2025 14:06:38 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, ffmancera@suse.de,
	brady.1345@gmail.com
Subject: Re: [PATCH nf 1/2] netfilter: nf_tables: limit maximum number of
 jumps/gotos per netns
Message-ID: <aQC_3p8Xu9-p48nV@strlen.de>
References: <20251027221722.183398-1-pablo@netfilter.org>
 <20251027221722.183398-2-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027221722.183398-2-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Add a new sysctl:
> 
>    net.netfilter.nf_tables_jump_max_netns
> 
> which is 65535 by default, because iptables-nft rulesets are more likely
> to have more jumps/gotos compared to native nftables rulesets.

I have existing / real-world iptables dumps that exceed 64k :-/
I'll forward you one of them.

Seems this patch misses a reset somewhere to deal with
chains/tables being deleted:

sysctl net.netfilter.nf_tables_jumps_max_netns=256000
net.netfilter.nf_tables_jumps_max_netns = 256000
iptables-nft-restore < kubernetes-huge-may-2018.txt; echo $?
0
iptables-nft-restore < kubernetes-huge-may-2018.txt
iptables-nft-restore v1.8.11 (nf_tables):
line 52222: RULE_APPEND failed (Too many links): rule in chain KUBE-SVC-FCXG7AJXWMSO3TT5

works after 'nft flush ruleset'.

I also have a hunch that a followup patch that sepearates ip and ip6
families (since they are mutually exclusive) will be needed sooner than
later.

If even a random old iptables-dump exceeds the 64k limit I would expect
combined ip+ip6tables rulesets to be even more brittle.
