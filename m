From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 1/1] netfilter: seqadj: Fix possible non-linear data
 access for TCP header
Date: Mon, 10 Apr 2017 14:06:39 +0200
Message-ID: <20170410120639.GA2386@salvia>
References: <1491820563-98023-1-git-send-email-gfree.wind@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Gao Feng <fgao@ikuai8.com>
To: gfree.wind@foxmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52800 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752955AbdDJMHD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Apr 2017 08:07:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 410DE5230A
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Apr 2017 14:06:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2FAF1BAAA7
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Apr 2017 14:06:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 82146BAAA3
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Apr 2017 14:06:50 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1491820563-98023-1-git-send-email-gfree.wind@foxmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 10, 2017 at 06:36:03PM +0800, gfree.wind@foxmail.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> The current call path of nf_ct_tcp_seqadj_set is the following.
> 
> nfqnl_recv_verdict->ctnetlink_glue_hook->ctnetlink_glue_seqadj
> ->nf_ct_tcp_seqadj_set.
> 
> It couldn't make sure the TCP header is in the linear data part.
> So use the skb_header_pointer instead of the current codes.
> 
> BTW, the nf_ct_tcp_seqadj_set is one external function of netfilter
> which works in the network layer, it should not assume the transport
> header is in the linear data.
> 
> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  net/netfilter/nf_conntrack_seqadj.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_conntrack_seqadj.c b/net/netfilter/nf_conntrack_seqadj.c
> index ef7063e..80394ab 100644
> --- a/net/netfilter/nf_conntrack_seqadj.c
> +++ b/net/netfilter/nf_conntrack_seqadj.c
> @@ -61,11 +61,14 @@ void nf_ct_tcp_seqadj_set(struct sk_buff *skb,
>  			  s32 off)
>  {
>  	const struct tcphdr *th;
> +	struct tcphdr tcph;
>  
>  	if (nf_ct_protonum(ct) != IPPROTO_TCP)
>  		return;
>  
> -	th = (struct tcphdr *)(skb_network_header(skb) + ip_hdrlen(skb));
> +	th = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(tcph), &tcph);
> +	if (!th)
> +		return;

This fix is required since your recent upgrade to check for 4 bytes
instead of 8 bytes from conntrack. Please confirm this.

If so, it would be good to review the NAT code to see if there are
more spots that are not broken since that change...
