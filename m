From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4] netfilter: conntrack: clamp timeouts to INT_MAX
Date: Tue, 28 Nov 2017 00:24:29 +0100
Message-ID: <20171127232429.GA29199@salvia>
References: <1510786873-60834-1-git-send-email-jelliott@arista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org
To: Jay Elliott <jelliott@arista.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43310 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752409AbdK0XYe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Nov 2017 18:24:34 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C109ADA4C7
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Nov 2017 00:24:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B07E4DA812
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Nov 2017 00:24:32 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1510786873-60834-1-git-send-email-jelliott@arista.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 15, 2017 at 03:01:13PM -0800, Jay Elliott wrote:
> When the conntracking code multiplies a timeout by HZ, it can overflow
> from positive to negative; this causes it to instantly expire.  To
> protect against this the multiplication is done in 64-bit so we can
> prevent it from exceeding INT_MAX.

This is something you must be observing via conntrack utility or
conntrackd?

> Signed-off-by: Jay Elliott <jelliott@arista.com>
> ---
>  net/netfilter/nf_conntrack_netlink.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index de4053d..41db7e3 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -1560,9 +1560,11 @@ static int ctnetlink_change_helper(struct nf_conn *ct,
>  static int ctnetlink_change_timeout(struct nf_conn *ct,
>  				    const struct nlattr * const cda[])
>  {
> -	u_int32_t timeout = ntohl(nla_get_be32(cda[CTA_TIMEOUT]));
> +	u64 timeout = (u64)ntohl(nla_get_be32(cda[CTA_TIMEOUT])) * HZ;
>  
> -	ct->timeout = nfct_time_stamp + timeout * HZ;
> +	if (timeout > INT_MAX)
> +		timeout = INT_MAX;
> +	ct->timeout = nfct_time_stamp + (u32)timeout;
>  
>  	if (test_bit(IPS_DYING_BIT, &ct->status))
>  		return -ETIME;
> @@ -1762,6 +1764,7 @@ static int change_seq_adj(struct nf_ct_seqadj *seq,
>  	int err = -EINVAL;
>  	struct nf_conntrack_helper *helper;
>  	struct nf_conn_tstamp *tstamp;
> +	u64 timeout;
>  
>  	ct = nf_conntrack_alloc(net, zone, otuple, rtuple, GFP_ATOMIC);
>  	if (IS_ERR(ct))
> @@ -1770,7 +1773,10 @@ static int change_seq_adj(struct nf_ct_seqadj *seq,
>  	if (!cda[CTA_TIMEOUT])
>  		goto err1;
>  
> -	ct->timeout = nfct_time_stamp + ntohl(nla_get_be32(cda[CTA_TIMEOUT])) * HZ;
> +	timeout = (u64)ntohl(nla_get_be32(cda[CTA_TIMEOUT])) * HZ;
> +	if (timeout > INT_MAX)
> +		timeout = INT_MAX;
> +	ct->timeout = (u32)timeout + nfct_time_stamp;
>  
>  	rcu_read_lock();
>   	if (cda[CTA_HELP]) {
> -- 
> 1.8.1.4
> 
