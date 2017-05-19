From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: conntrack: fix false CRC32c mismatch using
 paged skb
Date: Fri, 19 May 2017 10:41:03 +0200
Message-ID: <20170519084103.GA2512@salvia>
References: <f156034b4975584477c319a0946eb7adfc8d1e36.1495119678.git.dcaratti@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To: Davide Caratti <dcaratti@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48596 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750761AbdESIlI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 May 2017 04:41:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F0E44210573
        for <netfilter-devel@vger.kernel.org>; Fri, 19 May 2017 10:40:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E0FC0ACBB
        for <netfilter-devel@vger.kernel.org>; Fri, 19 May 2017 10:40:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 82351FF2F7
        for <netfilter-devel@vger.kernel.org>; Fri, 19 May 2017 10:40:57 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <f156034b4975584477c319a0946eb7adfc8d1e36.1495119678.git.dcaratti@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Davide,

On Thu, May 18, 2017 at 06:01:43PM +0200, Davide Caratti wrote:
> sctp_compute_cksum() implementation assumes that at least the SCTP header
> is in the linear part of skb: modify conntrack error callback to avoid
> false CRC32c mismatch, if the transport header is partially/entirely paged.

I guess you considered this, but I would like to know the reason for
this approach. Why not fix this from sctp_compute_cksum()? I mean, I
can see other spots in the kernel tree that may be affected by this?
Or is it that you're only observing this from a path that is specific
of conntrack?

> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
>  net/netfilter/nf_conntrack_proto_sctp.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
> index 13875d5..1c5b14a 100644
> --- a/net/netfilter/nf_conntrack_proto_sctp.c
> +++ b/net/netfilter/nf_conntrack_proto_sctp.c
> @@ -512,16 +512,19 @@ static int sctp_error(struct net *net, struct nf_conn *tpl, struct sk_buff *skb,
>  		      u8 pf, unsigned int hooknum)
>  {
>  	const struct sctphdr *sh;
> -	struct sctphdr _sctph;
>  	const char *logmsg;
>  
> -	sh = skb_header_pointer(skb, dataoff, sizeof(_sctph), &_sctph);
> -	if (!sh) {
> +	if (skb->len < dataoff + sizeof(struct sctphdr)) {
>  		logmsg = "nf_ct_sctp: short packet ";
>  		goto out_invalid;
>  	}
>  	if (net->ct.sysctl_checksum && hooknum == NF_INET_PRE_ROUTING &&
>  	    skb->ip_summed == CHECKSUM_NONE) {
> +		if (!skb_make_writable(skb, dataoff + sizeof(struct sctphdr))) {
> +			logmsg = "nf_ct_sctp: failed to read header ";
> +			goto out_invalid;
> +		}
> +		sh = (const struct sctphdr *)(skb->data + dataoff);
>  		if (sh->checksum != sctp_compute_cksum(skb, dataoff)) {
>  			logmsg = "nf_ct_sctp: bad CRC ";
>  			goto out_invalid;
> -- 
> 2.7.4
> 
