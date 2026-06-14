Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B67840D586
	for <netfilter-devel@vger.kernel.org>; Sun, 14 Jun 2026 11:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781435766; cv=none; b=FBdlpkSt4PI/QHF/3hGU98afOm7xMry60mcp2NiKfwLfw2+UvCxoAdO2ni45Bw/ylHsH7oQwfNwGDsBdvnX9l+WSkqxChm9gByYeWpByHQdD2YeBY0dtle5+5cedgnWzrNotLs07q2z11fozJYEzMrRoYkXepXevRaARs9ZFF58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781435766; c=relaxed/simple;
	bh=+fqcnpZmodZzxAfsixNQLP6qmG+9NTowYZMqgwziqf8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KvapKF1AZsOArmeEaATNyoLaU8ae43F6OmoHIB9Ko9Xz2DSqbdWi5Pzw01cDU3g3nGG1+OEcQfPlINz/8GQLF9PtdSx4VdOoa3d2mlEPL0lcCOomE5RgZP0Gb4CUuZtRWYhf/hWtWLREbom8TVtJIqY3mm+k/SMcrYR9Zi8002Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 013DE6047A; Sun, 14 Jun 2026 13:16:01 +0200 (CEST)
Date: Sun, 14 Jun 2026 13:16:01 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Ren Wei <n05ec@lzu.edu.cn>, netfilter-devel@vger.kernel.org,
	phil@nwl.cc, yuantan098@gmail.com, yifanwucs@gmail.com,
	tomapufckgml@gmail.com, zcliangcn@gmail.com, bird@lzu.edu.cn,
	bronzed_45_vested@icloud.com
Subject: Re: [PATCH nf 1/1] netfilter: xt_nat: reject unsupported target
 families
Message-ID: <ai6Ncagz3tfhFTAS@strlen.de>
References: <cover.1781144570.git.bronzed_45_vested@icloud.com>
 <5722ce33544cc22da3f811de77ab57847eb58366.1781144570.git.bronzed_45_vested@icloud.com>
 <ai3MJ2P2MnXLxcmb@strlen.de>
 <ai3TGFyMlkS1m8O3@strlen.de>
 <ai3WcsS00Rbjy61u@chamomile>
 <ai3Y68Fqd-V3cpOS@strlen.de>
 <ai533miYJF9-J3yB@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ai533miYJF9-J3yB@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Yes, but there are still around 33 match/targets extensions in the
> tree that use NFPROTO_UNSPEC as a .family.
>
> And some of these NFPROTO_UNSPEC are supported by ebtables, eg.
> xt_string (match), see ebt_string.c in ebtables userspace.

match != target.

> I think NFPROTO_UNSPEC should be replaced by explicit families that
> are supported.

ebtables CANNOT support NFPROTO_UNSPEC targets.  Thats all I said.

> > This is wnat ebtables.c already does which is why this poc would
> > not work for classic xtables.
> 
> Do you refer to targets specifically, correct?
> 
>         /* Reject UNSPEC, xtables verdicts/return values are incompatible */
>         if (target->family != NFPROTO_BRIDGE) {
>                 module_put(target->me);
>                 ret = -ENOENT;
>                 goto cleanup_watchers;
>         }

yes.

> > That said, this patch (the xt_nat.c patch) might be a good idea
> > anyway, but I don't think its enough.
> 
> I would probably replace all of the remaining NFPROTO_UNSPEC by
> explicit families.

Are you talking about matches, targets or both?  What about nftables?
I worry we see lots of redundancy when we have to expand UNSPEC to all
of ARP/BRIDGE/IPV4/IPV6/INET/NETDEV.

> As for xt_nat_target_reg, it does not set NFPROTO_UNSPEC explicitly,
> but given that target is allocated in the BSS, it results in an
> implicit NFPROTO_UNSPEC, which is the reason why it when uncaught by
> b6fe26f86a1649f84e057f3f15605b08eda15497.

Yes, its implicitly UNSPEC.
