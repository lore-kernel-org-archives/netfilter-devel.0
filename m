From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] netfilter: Expose connection tracking accounting
 toggles
Date: Wed, 23 Jun 2010 08:05:39 +0200
Message-ID: <4C21A433.4060906@trash.net>
References: <1277225075-30428-1-git-send-email-tim.gardner@canonical.com> <1277225075-30428-2-git-send-email-tim.gardner@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, ole@ans.pl
To: tim.gardner@canonical.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65090 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab0FWGFl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jun 2010 02:05:41 -0400
In-Reply-To: <1277225075-30428-2-git-send-email-tim.gardner@canonical.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

tim.gardner@canonical.com wrote:
> From: Tim Gardner <tim.gardner@canonical.com>
>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  include/net/netfilter/nf_conntrack.h |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
>
> diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
> index e624dae..2326754 100644
> --- a/include/net/netfilter/nf_conntrack.h
> +++ b/include/net/netfilter/nf_conntrack.h
> @@ -232,6 +232,18 @@ static inline void nf_ct_refresh(struct nf_conn *ct,
>  	__nf_ct_refresh_acct(ct, 0, skb, extra_jiffies, 0);
>  }
>  
> +/* Check if connection tracking accounting is enabled */
> +static inline bool nf_ct_acct_enabled(struct nf_conn *ct)
> +{
> +		return ct->ct_net->ct.sysctl_acct == 0 ? false : true;
> +}
> +
> +/* Enable/disable connection tracking accounting */
> +static inline void nf_ct_set_acct(struct nf_conn *ct, bool enable)
> +{
> +		ct->ct_net->ct.sysctl_acct = enable == true ? 1 : 0;
> +}
> +

This looks strangely indented, please use a single tab. You also need
to take care of the CONFIG_NET_NS=n case where the ct_net pointer is
#ifdef'ed out. I'd suggest to simply pass the net pointer from
xt_mtchk_param, which is available unconditionally.

