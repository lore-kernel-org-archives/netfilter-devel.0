Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EFE435525
	for <netfilter-devel@vger.kernel.org>; Sat,  1 Aug 2026 11:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785583412; cv=none; b=MxODcRYUGAHZyQikft2rYS2HldfZYI5x0Xx3/HPjViala1DJMm4+wESCNs4MZQSxmTZjn5PvH4BcTiOfTFijFp6hM7Ro5FmKh2aIyu0UlpOOHszLXBySuAbABoXq2VdCh6AzsYP0utRc3SjWKFNb8gh5379sUUdqLJHSPEJ4NkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785583412; c=relaxed/simple;
	bh=CFdWcxXRjHhvjT8dM4o+HPA+Wwb9wpf8pq0yE3ouFzA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XhZ3+T4LrstevCZtIX3ixHNVNDSFcLMziVlBd+fQM5LB23hCSPSY2XB7Hnt2GdLElS1wuskfErkfvL1Zc2GddDnW0/R6+kIwGBN9us9Z+VXG/8/tITcZsVcAjK/279b7gtmWIRU84dV27xqgzhjH44DPfAbj/hu2aqwbdpvwotE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 140CF60952; Sat, 01 Aug 2026 13:23:22 +0200 (CEST)
Date: Sat, 1 Aug 2026 13:23:21 +0200
From: Florian Westphal <fw@strlen.de>
To: Zihan Xi <zihanx@nebusec.ai>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, phil@nwl.cc,
	davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
	horms@kernel.org, vega@nebusec.ai
Subject: Re: [PATCH nf v3 1/1] netfilter: nf_conntrack: defer invalid log
 until after unlock
Message-ID: <am3XIHlT8_E7Itxn@strlen.de>
References: <cover.1785497202.git.zihanx@nebusec.ai>
 <d60e62141f53ce698745909398f94be9af8f0a93.1785497202.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d60e62141f53ce698745909398f94be9af8f0a93.1785497202.git.zihanx@nebusec.ai>

Zihan Xi <zihanx@nebusec.ai> wrote:
> TCP and SCTP conntrack paths can emit invalid-packet logs while ct->lock
> is still held.
> 
> When invalid logging is routed to nfnetlink_log and conntrack export is
> enabled, the log path can re-enter conntrack netlink glue and dump the
> same conntrack again. Protocol attribute dumping may take ct->lock, so
> logging while holding that lock can deadlock.
> 
> Defer the TCP invalid logs by storing only the minimal log context while
> ct->lock is held and emitting the log after unlocking. Also make the TCP
> timeout-lowering invalid path return whether a log is needed, then emit
> that log after unlocking.
> 
> Do the same for the SCTP invalid state-transition log that can be reached
> while ct->lock is held.
> 
> Add a lockdep assertion to nf_ct_l4proto_log_invalid() so future callers
> that log invalid conntracks while holding ct->lock are caught outside TCP
> and SCTP as well.
> 
> Fixes: 628d694344a0 ("netfilter: conntrack: reduce timeout when receiving out-of-window fin or rst")
> Fixes: d9a6f0d0df18 ("netfilter: conntrack: prepare tcp_in_window for ternary return value")
> Fixes: f71cb8f45d09 ("netfilter: conntrack: sctp: use nf log infrastructure for invalid packets")
> Cc: stable@vger.kernel.org
> Reported-by: Vega <vega@nebusec.ai>
> Assisted-by: Codex:gpt-5.4
> Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
> Reviewed-by: Florian Westphal <fw@strlen.de>
> ---
> changes in v3:
>   - Squash the previous two TCP patches into one patch as requested.
>   - Include the SCTP invalid state-transition log in the same logical fix.
>   - Move the lockdep assertion and recursion comment into nf_ct_l4proto_log_invalid().
>   - Adjust the TCP local declaration order per review.
>   - Use the broader nf_conntrack subject suggested by Pablo.
>   - Correct the Fixes: set to the first held-lock invalid-log call sites.
>   - Keep Florian Westphal's Reviewed-by.
>   - v2 Link: https://lore.kernel.org/all/cover.1785348197.git.zihanx@nebusec.ai/
> changes in v2:
>   - Split the TCP timeout-lowering and tcp_in_window() handling for review.
>   - Switch the reproducer documentation to the packetdrill wrapper flow.
>   - Keep the decoded crash log and real reproduction artifacts in the cover letter.
>   - v1 Link: https://lore.kernel.org/all/cover.1785307980.git.zihanx@nebusec.ai/
> ---
>  net/netfilter/nf_conntrack_proto.c      |   6 ++
>  net/netfilter/nf_conntrack_proto_sctp.c |  12 ++-
>  net/netfilter/nf_conntrack_proto_tcp.c  | 132 ++++++++++++++++--------
>  3 files changed, 102 insertions(+), 48 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
> index ad96896516b6..9439596f34e6 100644
> --- a/net/netfilter/nf_conntrack_proto.c
> +++ b/net/netfilter/nf_conntrack_proto.c
> @@ -83,6 +83,12 @@ void nf_ct_l4proto_log_invalid(const struct sk_buff *skb,
>  	if (likely(net->ct.sysctl_log_invalid == 0))
>  		return;
>  
> +	/* nfnetlink_log may re-enter conntrack attribute dumping and try to
> +	 * take ct->lock again via helpers such as tcp_to_nlattr(), so invalid
> +	 * conntrack logs must only be emitted after dropping ct->lock.
> +	 */
> +	lockdep_assert_not_held(&ct->lock);
> +

This should be unconditional, i.e. *before* the sysctl check.
Other than this, this fix LGTM.
