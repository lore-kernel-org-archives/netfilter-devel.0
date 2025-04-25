Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EDD2F2A;
	Fri, 25 Apr 2025 17:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745603975; cv=none; b=mII6Rpt1ywjUsAfxCAmHSmuRfeTBaqX7EvRd3ezN90cajfxBptFnGMz3F2V/pZC0exElqnrFsYL4zdPDN1A5NQA6pjkFrBKcXybKyjw3yenS+6Y/TzX9OZtmNk3Bv9Z5QP26QxFuQ6yVQ4GMkV7JwF8Fi/A3+Va7HhssNrXnBVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745603975; c=relaxed/simple;
	bh=YTUIEIyWGeLl0K6ocE/k2ap58m6xwnQhZVPcgyVPiOA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hsIrfc5yQOUnY+Ld1Q1JWJn6BDj9omee58Lza3X5eWwW4bGmF4i4xEsqrvg9uVRdXiTfL9OxRzMQIvJzf1o9Ma6wJeePAwt6eymENlYLVf2EGqsg6rhec2nuWdWfRQXVSOtiw64VwYEA4fufKj9Vvv6niwiMyOBt4BEpNdmuz6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1u8NKc-00073U-49; Fri, 25 Apr 2025 19:59:22 +0200
Date: Fri, 25 Apr 2025 19:59:22 +0200
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, fw@strlen.de,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
	horms@kernel.org
Subject: Re: [PATCH net-next,v2 0/7] Netfilter updates for net-next
Message-ID: <20250425175922.GA26506@breakpoint.cc>
References: <20250424211455.242482-1-pablo@netfilter.org>
 <20250425091854.4b5964fd@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250425091854.4b5964fd@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Jakub Kicinski <kuba@kernel.org> wrote:
> On Thu, 24 Apr 2025 23:14:48 +0200 Pablo Neira Ayuso wrote:
> > v2: including fixes from Florian to address selftest issues
> >     and a fix for set element count and type.
> 
> Thanks, appreciated! All our networking tests now pass, but there
> seems to still be some breakage on the BPF side, so
> tools/testing/selftests/bpf/config needs touching up.
> 
> I suppose while addressing the RT problem you're trying to move
> straggles off from the legacy stuff to nft? Which I'm entirely
> sympathetic to. But I'm worried that not everybody will be, and 
> there's plenty of defconfigs which include iptables:
> 
> $ git grep CONFIG_IP_NF_IPTABLES= | wc -l
> 54

Pablo, lets toss the relevant patch and try again later.

I have no idea how to make this work the way we want it to
without converting all "selects" to "depends on" clauses as in the patch.

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -14,6 +14,7 @@ config NF_DEFRAG_IPV4
 config IP_NF_IPTABLES_LEGACY
 	tristate "Legacy IP tables support"
 	default	n
+	depends on !PREEMPT_RT
 	select NETFILTER_XTABLES
 	help


... will not work, you just get a "Unmet direct dependencies" warning.
