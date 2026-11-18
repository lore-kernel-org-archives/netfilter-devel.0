Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795002436;
	b=MzeoEcrIap5DhAEEeaE2ujHocIR7QNerCyevea4UyFeHNpSGkoalJmEffn0z9nvHIyy5
	 12FKTy5gJglaGIC2nq+GYmOHtGh7PvIHjsGD3nITOTUj8IDLrMv5Uad4SYDTD3+nK90M9
	 Q6zBWkMu7MVCXPFnK9+owpd856rijV+DVDBQymGIVIhIw8EFhGMnkR94Kmw/fp7Y3E/QU
	 v8YHhNL/B5noNJGVHaRyXH9q9H/wKHln6Bd0myAsE1xMkwaW9quh75Rx9cxg+2bIt4wYX
	 ohtEM5BNesvpiVK9dDGmpWsnD8FMWmO7nUpxFh8HDQl4W3+vV+BPYow/a7vE3YLCE5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795002436;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=yCRovRJLZSnC8+NEOr/ttmo+gNqMMch0BjxoeFzhucA=;
	b=T8SyreXBiaWdhzBZVBzzvUMBBs4EL34MGcahEbNoFB62Vi1nJ8P8TRiz+gtNqfkTPWy1
	 fm6nBkez82X3wdYyfOzdoDYr1TZ8lmfBjDO3zxY9SXCPP8AhetoHLKlqYYvXhbnZXvJYd
	 whOtHt79BHsqI8t37KhLBsmc9dZeTmJ5iwtkNaWK7qtzWv5uzk4mkLET9bDGHbUUrMLlm
	 zsqJutW6e1VmLvYlKoGgcQrHI3orxkaFXMiHS34N9O6EX+Wjk3L8iwLxPiIousKyHbQN0
	 NumNcwCHahhCuVjGAwxb9jsYv3iaj3uVyEPoMxs2mOHkWhDV4jfXiFvhfjkVkvCzaQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=SuulrDXD;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 9FAD4606A31C;
	Wed, 18 Nov 2026 11:47:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9FAD4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=SuulrDXD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795002428;
	bh=yCRovRJLZSnC8+NEOr/ttmo+gNqMMch0BjxoeFzhucA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SuulrDXDJs9PawWEi7SBkvD7B5lRgfs7t5SnGqtS8rB+IMsTttD6XMNoBJ3NbSOpJ
	 o8uyfdFkueVa9gIJkHmhtFkby/Kp5ziuiTtP+8LjMDxhuvSji3+/j2ZzlcnK2Whbht
	 pjoCbwdA9t8AqZwFgGMl4MArZvOyAH2sGFazbSg6JkwJDBEuDy+sjU8hX6FLvKNzBt
	 qj5gVCYhDyNDIH+Ma8bZIDtbSInBN+epFimP+byKqzB1qOvtPHJe7T/1aW/FypEbw3
	 Wmj+qDa5P1R5zjfbysDc1HU5S0Nk5moaBbNx691NEEHvVwhCQ3PNUfK5kkrNba4GVQ
	 SocUqyoyBd/CQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id D4CE660054;
	Wed, 18 Nov 2026 12:47:07 +0100 (CET)
Date: Wed, 18 Nov 2026 12:47:05 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Shashank Mohan Jain <jain.sm@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: ctnetlink: apply port filters to SCTP and
 GRE entries
Message-ID: <av2QOZbkZZnXBKme@chamomile>
References: <20261118042950.83129-1-jain.sm@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261118042950.83129-1-jain.sm@gmail.com>

Hi,

This is nf-next material.

This is a feature that is missing. BTW, GRE has no ports.

On Wed, Nov 18, 2026 at 09:59:50AM +0530, Shashank Mohan Jain wrote:
> ctnetlink_filter_match_tuple() only compares CTA_PROTO_SRC_PORT and
> CTA_PROTO_DST_PORT for TCP and UDP. SCTP and GRE also parse these
> attributes into the filter tuple (both use nf_ct_port_nlattr_to_tuple()),
> so a filter such as "protonum SCTP, src port X" is accepted, but the
> port part is then ignored and every SCTP entry matches.
> 
> CTA_FILTER is also honoured by IPCTNL_MSG_CT_DELETE
> (ctnetlink_flush_conntrack()), so a filtered flush that asks for one
> SCTP port deletes all SCTP conntrack entries in the netns, and a
> filtered dump returns all of them. The same applies to GRE keys.
> 
> The port and the GRE key share the same offset in
> nf_conntrack_man_proto and in the dst union, so the existing
> comparison works for both.
> 
> Found by reading the code with LLM assistance. Tested on x86_64 under
> QEMU: with three SCTP and three GRE entries, a delete filtered on one
> source port (or GRE key) removed all three entries of that protocol
> before this change and only the matching one with it. Filtered dumps
> show the same difference.
> 
> Fixes: cb8aa9a3affb ("netfilter: ctnetlink: add kernel side filtering for dump")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Shashank Mohan Jain <jain.sm@gmail.com>
> ---
> Prepared with Claude Code (Anthropic), model Claude Opus 5.5
> (claude-opus-5-5).
> 
> Based on nf.git main 734bef548a96. Tested with a small raw ctnetlink
> program in a busybox initramfs under QEMU (x86_64, TCG). It adds three
> SCTP, three GRE and three TCP entries, then sends dumps and
> IPCTNL_MSG_CT_DELETE requests with CTA_FILTER set to protonum plus
> source port. TCP behaves the same before and after. Also built for
> i386; W=1 shows no warnings for nf_conntrack_netlink.c before or after.
> 
>  net/netfilter/nf_conntrack_netlink.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index 1f8d94a05..5e8e0b93b 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -1127,6 +1127,8 @@ static int ctnetlink_filter_match_tuple(struct nf_conntrack_tuple *filter_tuple,
>  	switch (ct_tuple->dst.protonum) {
>  	case IPPROTO_TCP:
>  	case IPPROTO_UDP:
> +	case IPPROTO_SCTP:
> +	case IPPROTO_GRE:
>  		if ((flags & CTA_FILTER_FLAG(CTA_PROTO_SRC_PORT)) &&
>  		    filter_tuple->src.u.tcp.port != ct_tuple->src.u.tcp.port)
>  			return 0;
> -- 
> 2.43.0
> 
