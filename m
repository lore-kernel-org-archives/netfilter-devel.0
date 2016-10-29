From: Chris Caputo <ccaputo@alt.net>
Subject: Re: [PATCH nf] netfilter: xt_NFLOG: fix unexpected truncated packet
Date: Sat, 29 Oct 2016 19:04:14 +0000 (UTC)
Message-ID: <Pine.LNX.4.64.1610291902380.20350@nacho.alt.net>
References: <1476191025-16296-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, jpiszcz@lucidpixels.com,
        vpai@akamai.com, Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org, Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nacho.alt.net ([208.90.169.18]:45218 "EHLO nacho.alt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752479AbcJ2TK5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Oct 2016 15:10:57 -0400
In-Reply-To: <1476191025-16296-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo,

Can we get this patch approved?  It is definitely needed for the 4.8.x 
tree and 4.9-rcX and mainline.

Thanks,
Chris

On Tue, 11 Oct 2016, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Justin and Chris spotted that iptables NFLOG target was broken when they
> upgraded the kernel to 4.8: "ulogd-2.0.5- IPs are no longer logged" or
> "results in segfaults in ulogd-2.0.5".
> 
> Because "struct nf_loginfo li;" is a local variable, and flags will be
> filled with garbage value, not inited to zero. So if it contains 0x1,
> packets will not be logged to the userspace anymore.
> 
> Fixes: 7643507fe8b5 ("netfilter: xt_NFLOG: nflog-range does not truncate packets")
> Reported-by: Justin Piszcz <jpiszcz@lucidpixels.com>
> Reported-by: Chris Caputo <ccaputo@alt.net>
> Tested-by: Chris Caputo <ccaputo@alt.net>
> Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
> ---
>  net/netfilter/xt_NFLOG.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/netfilter/xt_NFLOG.c b/net/netfilter/xt_NFLOG.c
> index 018eed7..8668a5c 100644
> --- a/net/netfilter/xt_NFLOG.c
> +++ b/net/netfilter/xt_NFLOG.c
> @@ -32,6 +32,7 @@ nflog_tg(struct sk_buff *skb, const struct xt_action_param *par)
>  	li.u.ulog.copy_len   = info->len;
>  	li.u.ulog.group	     = info->group;
>  	li.u.ulog.qthreshold = info->threshold;
> +	li.u.ulog.flags	     = 0;
>  
>  	if (info->flags & XT_NFLOG_F_COPY_LEN)
>  		li.u.ulog.flags |= NF_LOG_F_COPY_LEN;
> -- 
> 2.5.5
