Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B210A4A02;
	Sat,  7 Mar 2026 19:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772910285; cv=none; b=C8HOXkzv7uy5CHZgnV/MIhjCEYUkTWb2FGZaysq15GmkyNkDFpEWb/ajQIMcUEasRxN+ngf7m4TQPqkr2dE1opC8hxRXamehrLNkIhhFsaW47TxQsGQ35gTxXnMQN27o+Lcu86yvWjYVrQdZUAp/INML4mrhVKPoUI0/6YKGkZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772910285; c=relaxed/simple;
	bh=isRIRvojdCPEIN1P0UCOUyVaqbphb78UW84CAW2Jm7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DxG2gFp2YuY7iGiismyQG4c9wIoclORC/uvO3oGijQiyQgMgb+g0Re+yxT3+8SgJFdJnuKIjFIxGALTVZaMhMi9EEOLenNeBFh6zX7A3JmZOHfDa9lBVTMWiTvqsSI1HALz149t6F269ZesEpMJpi0jeB7F7G+TR8hPE7sgOYE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CDFA06077F; Sat, 07 Mar 2026 20:04:41 +0100 (CET)
Date: Sat, 7 Mar 2026 20:04:41 +0100
From: Florian Westphal <fw@strlen.de>
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: pablo@netfilter.org, phil@nwl.cc, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nf_flow_table_offload: fix heap overflow
 in flow_action_entry_next()
Message-ID: <aax2yZtJce0d19gd@strlen.de>
References: <aaxe-uH2Qr6qM4E9@v4bel>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaxe-uH2Qr6qM4E9@v4bel>

Hyunwoo Kim <imv4bel@gmail.com> wrote:
> flow_action_entry_next() increments num_entries and returns a pointer
> into the flow_action_entry array without any bounds checking.  The array
> is allocated with a fixed size of NF_FLOW_RULE_ACTION_MAX (16) entries,
> but certain combinations of IPv6 + SNAT + DNAT + double VLAN (QinQ)
> require 17 or more entries, causing a slab-out-of-bounds write in the
> kmalloc-4k slab.
> 
> The maximum possible entry count is:
>   tunnel(2) + eth(4) + VLAN(4) + IPv6_NAT(10) + redirect(1) = 21
> 
> Increase NF_FLOW_RULE_ACTION_MAX to 24 (with headroom) to cover the
>  
> -#define NF_FLOW_RULE_ACTION_MAX	16
> +#define NF_FLOW_RULE_ACTION_MAX	24

This fix looks rather fragile.

What guarantees that this stays right-sized?

Can you add a BUILD_BUG_ON or if needed, run-time check?
