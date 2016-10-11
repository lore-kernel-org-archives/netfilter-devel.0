From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subject: RE: [PATCH nf] netfilter: xt_NFLOG: fix unexpected truncated packet
Date: Tue, 11 Oct 2016 17:06:25 -0400
Message-ID: <000001d22403$544a6830$fcdf3890$@lucidpixels.com>
References: <1476191025-16296-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>, <ccaputo@alt.net>,
        <vpai@akamai.com>, "'Liping Zhang'" <liping.zhang@spreadtrum.com>
To: "'Liping Zhang'" <zlpnobody@163.com>, <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:36486 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752266AbcJKVG2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Oct 2016 17:06:28 -0400
Received: by mail-qk0-f194.google.com with SMTP id z190so2325273qkc.3
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Oct 2016 14:06:27 -0700 (PDT)
In-Reply-To: <1476191025-16296-1-git-send-email-zlpnobody@163.com>
Content-Language: en-us
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



> -----Original Message-----
> From: Liping Zhang [mailto:zlpnobody@163.com]
> Sent: Tuesday, October 11, 2016 9:04 AM
> To: pablo@netfilter.org
> Cc: netfilter-devel@vger.kernel.org; jpiszcz@lucidpixels.com;
> ccaputo@alt.net; vpai@akamai.com; Liping Zhang
> Subject: [PATCH nf] netfilter: xt_NFLOG: fix unexpected truncated packet
> 
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
> Fixes: 7643507fe8b5 ("netfilter: xt_NFLOG: nflog-range does not truncate
> packets")
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
> @@ -32,6 +32,7 @@ nflog_tg(struct sk_buff *skb, const struct
> xt_action_param *par)
>  	li.u.ulog.copy_len   = info->len;
>  	li.u.ulog.group	     = info->group;
>  	li.u.ulog.qthreshold = info->threshold;
> +	li.u.ulog.flags	     = 0;
> 
>  	if (info->flags & XT_NFLOG_F_COPY_LEN)
>  		li.u.ulog.flags |= NF_LOG_F_COPY_LEN;
> --
> 2.5.5
> 

Hello,

Applied patch against 4.8.1-- good here as well!

Thanks,

Justin.



