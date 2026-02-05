Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB41392800
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 13:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770299189; cv=none; b=cQFav9zuOZqhhyXImJrhnocpSm+S/hftUpve0AocEmpRuWN81TXxeoUIam/94NnIGP0joh1u1QfLczKRwujJh+wOd+n8idX2xH9puOWAJznbNNeiyBDLsBx1if0L06aLLH7X44N1NV3HO6aJd1UXL/PDK5TuHn79PkHRhIw1kGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770299189; c=relaxed/simple;
	bh=Dmu7/nbda68o8AWKJEVPUHUAWzFN+sSeaIfSEp/KXhE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=utr5IANRBKsERY7QRVstAQNy58MWGHPMtCk1OS14EBWAYgFAsP9ZgGgcvSw1NkE8GJnGES7V3cW0AyfET7jEA/jz/LMROplOGdz7SP1f1B1Rg0XVJPZRQo/xA2NzmVSOcImQkbtDtc+7Xvt0WZhhTTT4ELAFzBrE0Ged/4hVzBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C93B260807; Thu, 05 Feb 2026 14:46:26 +0100 (CET)
Date: Thu, 5 Feb 2026 14:46:26 +0100
From: Florian Westphal <fw@strlen.de>
To: Brian Witte <brianwitte@mailfence.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH v5 nf-next 1/3] Revert nf_tables commit_mutex in reset
 path
Message-ID: <aYSfMrYl6gmRpn0_@strlen.de>
References: <20260204202639.497235-1-brianwitte@mailfence.com>
 <20260204202639.497235-2-brianwitte@mailfence.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260204202639.497235-2-brianwitte@mailfence.com>

Brian Witte <brianwitte@mailfence.com> wrote:

TL;DR: I plan to queue this series up for the nf tree next week.
Not directly related to this patchset:

[ CC Phil ]

> Revert mutex-based locking for reset requests. It caused a circular
> lock dependency between commit_mutex, nfnl_subsys_ipset, and
> nlk_cb_mutex when nft reset, ipset list, and iptables-nft with set
> match ran concurrently.
> 
> This reverts bd662c4218f9, 3d483faa6663, 3cb03edb4de3.

Phil, Pablo, the reset infra is broken in the sense that it cannot
guarantee a correct dump+reset:

        nft_rule_for_each_expr(expr, next, rule) {
                if (nft_expr_dump(skb, NFTA_LIST_ELEM, expr, reset) < 0)
                        goto nla_put_failure;
        }
        nla_nest_end(skb, list);

-> when a single ->dump callback fails because netlink skb is full,
the dump is trimmed and resumed.

But, the reset side effects are already visible.
Hence, while dump may be complete, it can contain already-zeroed
counters without userspace ever getting the pre-reset value.

Maybe we should add a cushion in the relevant dump callbacks to
bail out before calling counter/quota->dump() when we run low on
remaining space?  What do you think?
