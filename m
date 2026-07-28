Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CE54734C4;
	Tue, 28 Jul 2026 19:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785266804; cv=none; b=JPoY08Zui2671KjXRGWTJNheqnXnd1ywWSFuzQUAATDorti0p2rUREGhxGw2xl6cAmHxgO7mAojfEOGHj/G4qhZ/FSAzyzUtzZ/L13CsMVXpigX74WzYvDNI0cnUJlz+cUSA5E4Kqa3ISLLArgNGt7rIgnEvnXak4SyF4FhsCQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785266804; c=relaxed/simple;
	bh=86K6vg15VfD9OXa2/xauBqFIPOM5uTHnBK6Jx4CCyKc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bLQfK1/ahuWFxco5vsw3NDsDUCuWuplNuNuKNvkL6GLa1Fq1gY1+tYiqIcKK4auXTGgHLFlInUU2p3g7Ii9oJfXW1yv3mBngcQuNjT6168KDPiTXXsXaARQSyVNUWsReuQUhRM5HeDHVejthZKOAJVcigMxwDbL5+O3Z1rgxjY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CoS//Fk2; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CoS//Fk2"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id A93E360196;
	Tue, 28 Jul 2026 21:26:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785266799;
	bh=MEECRbHkWBREqJmphTODP5tOHFNRtm4Szv75Afqgxo0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CoS//Fk2N71KPTPMbUEuwoTkOr43RLuYC7r27LdeGxw0qAjlufRTZS/X2DJGpral/
	 +7ZrDfmoDJ5MYOvHh+Ud4ZHPD/AjyLvpm7sVh2Nfk1MVYN5U7zQ8/eJ8ChzDalZn8V
	 Z8BDuXkZYmb54H7UMxdDCQZe96Rn7mTga6kayghzBbyulDg7AXrpBw+TG1vcsapU3K
	 RusjR6eGUgKZ8M5Ycm7gesBBLEce55f5jB40/DoPTzWkkCbui43zbMO2UOc1E6YbNz
	 /yHzyXkX/zdS1GwcOjrLS6STNmEmJ4E1vDn8yBhLixQijrSr5G57UifC8E0RbCFSTX
	 XEkPSCLWFK2lg==
Date: Tue, 28 Jul 2026 21:26:37 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	Ao Wang <wangao@seu.edu.cn>, Xuewei Feng <fengxw06@126.com>,
	Qi Li <qli01@tsinghua.edu.cn>, Ke Xu <xuke@tsinghua.edu.cn>
Subject: Re: [PATCH nf] netfilter: conntrack: sctp: verify vtag before state
 changes
Message-ID: <amkCbQ1UDRKcZBez@chamomile>
References: <20260728073507.30635-1-zhaoyz24@mails.tsinghua.edu.cn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260728073507.30635-1-zhaoyz24@mails.tsinghua.edu.cn>

Hi,

On Tue, Jul 28, 2026 at 03:35:06PM +0800, Yizhou Zhao wrote:
> The packet-wide vtag check in nf_conntrack_sctp_packet() is skipped when
> the bundle map contains any chunk type with special vtag handling.  The
> per-chunk path re-checks INIT, ABORT, SHUTDOWN_COMPLETE, and
> COOKIE_ECHO, but other state-changing chunks still fall through to
> sctp_new_state() without validating sh->vtag.
> 
> This lets a wrong-vtag packet bundle HEARTBEAT with COOKIE_ACK, ERROR,
> SHUTDOWN, or SHUTDOWN_ACK and still advance conntrack state.  That can
> desynchronize conntrack from the real SCTP association and cause denial
> of service for SCTP traffic behind a stateful firewall.

Are you assuming a specific policy in place? The connection tracking
does not police packets, it just provides tracking.

Can you provide a more specific scenario?

We are seeing several reports related to the connection tracking from
your university lately.

> Check sh->vtag before processing those chunks when conntrack already
> knows the expected direction vtag.  This keeps the existing
> HEARTBEAT/HEARTBEAT_ACK learning and connection-reuse behavior for the
> `vtag == 0` cases.

Proposed patches to hardening the connection tracking state machine
should be targeted at nf-next.

Thanks.

> Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
> Cc: stable@vger.kernel.org
> Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
> Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
> Reported-by: Ao Wang <wangao@seu.edu.cn>
> Reported-by: Xuewei Feng <fengxw06@126.com>
> Reported-by: Qi Li <qli01@tsinghua.edu.cn>
> Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
> Assisted-by: Claude-Code:GLM-5.2
> Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
> ---
>  net/netfilter/nf_conntrack_proto_sctp.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
> index 7e10fa65cbdd..9978ecd05b1e 100644
> --- a/net/netfilter/nf_conntrack_proto_sctp.c
> +++ b/net/netfilter/nf_conntrack_proto_sctp.c
> @@ -407,9 +407,17 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
>  			/* (D) vtag must be same as init_vtag as found in INIT_ACK */
>  			if (sh->vtag != ct->proto.sctp.vtag[dir])
>  				goto out_unlock;
> -		} else if (sch->type == SCTP_CID_COOKIE_ACK) {
> -			ct->proto.sctp.init[dir] = 0;
> -			ct->proto.sctp.init[!dir] = 0;
> +		} else if (sch->type == SCTP_CID_COOKIE_ACK ||
> +			   sch->type == SCTP_CID_ERROR ||
> +			   sch->type == SCTP_CID_SHUTDOWN ||
> +			   sch->type == SCTP_CID_SHUTDOWN_ACK) {
> +			if (ct->proto.sctp.vtag[dir] &&
> +			    sh->vtag != ct->proto.sctp.vtag[dir])
> +				goto out_unlock;
> +			if (sch->type == SCTP_CID_COOKIE_ACK) {
> +				ct->proto.sctp.init[dir] = 0;
> +				ct->proto.sctp.init[!dir] = 0;
> +			}
>  		} else if (sch->type == SCTP_CID_HEARTBEAT) {
>  			if (ct->proto.sctp.vtag[dir] == 0) {
>  				pr_debug("Setting %d vtag %x for dir %d\n", sch->type, sh->vtag, dir);
> -- 
> 2.47.3
> 
