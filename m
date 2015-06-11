From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3] nfnetlink_queue: add security context information
Date: Fri, 12 Jun 2015 01:37:57 +0200
Message-ID: <20150611233757.GE7125@breakpoint.cc>
References: <55634935.4020100@samsung.com>
 <20150525205210.GG3629@breakpoint.cc>
 <55646731.9040803@samsung.com>
 <20150526130623.GD7817@breakpoint.cc>
 <5565A4D2.70701@samsung.com>
 <5565A6AA.90908@samsung.com>
 <20150527124957.GA19819@salvia>
 <557855B2.8030803@samsung.com>
 <20150610160541.GD7125@breakpoint.cc>
 <55798582.1040903@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	=?utf-8?B?UmFmYcWC?= Krypa <r.krypa@samsung.com>
To: Roman Kubiak <r.kubiak@samsung.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:51957 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750818AbbFKXiA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Jun 2015 19:38:00 -0400
Content-Disposition: inline
In-Reply-To: <55798582.1040903@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Roman Kubiak <r.kubiak@samsung.com> wrote:
> Fixes applied (i'm not sure how i should use the mask parameter to check if NFQA_CFG_F_SECCTX is set
> on the userspace side both the mask and the flag are the same value when i looked at how uid/gid
> are set, maybe this could be done better?)

[..]

> @@ -1142,7 +1170,12 @@ nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
>  			ret = -EOPNOTSUPP;
>  			goto err_out_unlock;
>  		}
> -
> +#if !IS_ENABLED(CONFIG_NETWORK_SECMARK)
> +		if (flags == NFQA_CFG_F_SECCTX) {
> +			ret = -EOPNOTSUPP;
> +			goto err_out_unlock;
> +		}
> +#endif
>  		spin_lock_bh(&queue->lock);
>  		queue->flags &= ~mask;
>  		queue->flags |= flags & mask;

Based on last two lines it appears the test should be something like

if (flags & mask & NFQA_CFG_F_SECCTX)
	return -EOPNOTSUPP;

[ seems intent is to allow unsetting some flag(s) via
  flags = SOME_FEAT_I_WANT;
  mask = SOME_FEAT_I_WANT|SOME_FEAT_I_WANT_TO_SWITCH_OFF; ]

