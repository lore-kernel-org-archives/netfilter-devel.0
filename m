From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V2] netfilter: nfnetlink_acct: avoid using
 NFACCT_F_OVERQUOTA with bit helper funcitons
Date: Thu, 31 Jul 2014 20:44:22 +0200
Message-ID: <20140731184422.GA7458@salvia>
References: <20140730163133.GB6018@salvia>
 <1406812445-2973-1-git-send-email-a.perevalov@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: alexey.perevalov@hotmail.com, mathieu.poirier@linaro.org,
	netfilter-devel@vger.kernel.org, kyungmin.park@samsung.com,
	hs81.go@samsung.com
To: Alexey Perevalov <a.perevalov@samsung.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60756 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbaGaSoJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2014 14:44:09 -0400
Content-Disposition: inline
In-Reply-To: <1406812445-2973-1-git-send-email-a.perevalov@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 31, 2014 at 05:14:05PM +0400, Alexey Perevalov wrote:
> Bit helper functions were used for manipulation with NFACCT_F_OVERQUOTA,
> but they are accepting pit position, but not a bit mask. As a result
> not a third bit for NFACCT_F_OVERQUOTA was set, but forth. Such
> behaviour was dangarous and could lead to unexpected overquota report
> result.

Applied, thanks.

I have made a minor change.

> Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
> ---
>  include/uapi/linux/netfilter/nfnetlink_acct.h |    5 ++++-
>  net/netfilter/nfnetlink_acct.c                |    7 ++++---
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/include/uapi/linux/netfilter/nfnetlink_acct.h b/include/uapi/linux/netfilter/nfnetlink_acct.h
> index 51404ec..81410b7 100644
> --- a/include/uapi/linux/netfilter/nfnetlink_acct.h
> +++ b/include/uapi/linux/netfilter/nfnetlink_acct.h
> @@ -14,10 +14,13 @@ enum nfnl_acct_msg_types {
>  	NFNL_MSG_ACCT_MAX
>  };
>  
> +#define NFACCT_OVERQUOTA_BIT 2
> +
>  enum nfnl_acct_flags {
>  	NFACCT_F_QUOTA_PKTS	= (1 << 0),
>  	NFACCT_F_QUOTA_BYTES	= (1 << 1),
> -	NFACCT_F_OVERQUOTA	= (1 << 2), /* can't be set from userspace */
> +	NFACCT_F_OVERQUOTA	= (1 << NFACCT_OVERQUOTA_BIT), /* can't be
> +		 set from userspace */
>  };

I know I asked for NFACCT_OVERQUOTA_BIT to be included here, bit after
seeing the patch it's obvious it doesn't make sense to expose this to
userspace, so I have mangled the patch to define this in
nfnetlink_acct.
