Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5470513B7A6
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Sep 2024 08:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726477011; cv=none; b=g+dtSXhT/AUy9qF1EClyARDPAftNYzjwtJcqwRZxswmjLLH7ClX/e8LTkaK9EmWF/sAOH1COskS/i76Pwbhej3JkIOtjUUYX+VmLXnyyoO3AbFtsVuCPo1ITVQIOmKHuvs5khPYpyaYWWUU6/nNolgER+cf8eTOMPe1hkVwP0Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726477011; c=relaxed/simple;
	bh=mGxgZL5aArTZG5RwecnqDuZlUnTAGgrfYM5kjX1CKDQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c3q3YkZEd3e/qkKhXiS6nN4+QCFZPo0AH2EBwbue60Gs5nfgiR/Cd8DXMPbE/qV+BAbDNXABUCj5IqiFJo8i5YTT9R6hA2lW5Cn9y6hfBCljw4XNxUXGv3c3VNPQibm4ENIiXhEJ2Pyk8o0vIJJ6RiL8Gkl2cNl1WkVPbdJrYi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sq7XL-00040S-MU; Mon, 16 Sep 2024 10:56:47 +0200
Date: Mon, 16 Sep 2024 10:56:47 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] doc: tproxy is non-terminal in nftables
Message-ID: <20240916085647.GB14728@breakpoint.cc>
References: <20240915224528.158198-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240915224528.158198-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>  -------------------------------------
> +Note that the tproxy statement is non-terminal to allow post-processing of
> +packets, such logging the packet for debugging.
> +
> +.Example ruleset for tproxy statement with logging
> +-------------------------------------
> +table t {
> +    chain c {
> +        type filter hook prerouting priority mangle; policy accept;
> +        udp dport 9999 tproxy to :1234 log prefix "packet tproxied: " accept
> +        log prefix "no socket on port 1234 or not transparent?: " drop
> +    }

I'd suggest to use anon chain here:

    udp dport 9999 goto {
	tproxy to :1234 log prefix "packet tproxied: " accept
        log prefix "no socket on port 1234 or not transparent?: " drop
    }

I also think it might make sense to merge/add bits from the kernel
documentation file.
(Documentation/networking/tproxy.rst).

None of these examples will work in case the destination IP is
going to be forwarded, the example only works for port "redirect".

Maybe:
+As packet headers are unchanged, packets might be forwarded instead of delivered
+locally. This can be avoided by adding policy routing rules and the packet mark.
+
+.Example policy routing rules for local redirection:
+----------------------------------------------------
+ip rule add fwmark 1 lookup 100
+ip route add local 0.0.0.0/0 dev lo table 100
+----------------------------------------------------
+
+Then, add "mark set 1" right after the "tproxy statement".

I'm not sure how verbose it should be, tproxy is complicated
due to how its interacting with routing engine, even application
needs to do special things (IP_TRANSPARENT sockopt). Maybe
examples should also include "meta mark set 1" bit?

> +This is a change in behavior compared to the legacy iptables TPROXY target
> +which is terminal. To terminate the packet processing after the tproxy
> +statement, remember to issue a verdict as in the example above.

Agree, it makes sense to add this.
