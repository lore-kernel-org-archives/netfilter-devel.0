From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V4 1/2] netfilter: xt_AUDIT: use consistent ipv4 network
 offset
Date: Wed, 22 Mar 2017 12:11:51 +0100
Message-ID: <20170322111151.GA2766@salvia>
References: <d2ef98ddd4884276879107d4cd4521330e709578.1490165887.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, linux-audit@redhat.com,
        Florian Westphal <fw@strlen.de>,
        Thomas Woerner <twoerner@redhat.com>,
        Thomas Graf <tgraf@infradead.org>,
        Eric Paris <eparis@redhat.com>, Paul Moore <pmoore@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50964 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933647AbdCVLMB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Mar 2017 07:12:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 892B2EAA68
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 12:11:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7B89EDA871
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 12:11:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4B98CDA87D
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 12:11:55 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <d2ef98ddd4884276879107d4cd4521330e709578.1490165887.git.rgb@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 22, 2017 at 03:05:36AM -0400, Richard Guy Briggs wrote:
> Even though the skb->data pointer has been moved from the link layer
> header to the network layer header, use the same method to calculate the
> offset in ipv4 and ipv6 routines.
> 
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  net/netfilter/xt_AUDIT.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
> index 4973cbd..cdb7cee 100644
> --- a/net/netfilter/xt_AUDIT.c
> +++ b/net/netfilter/xt_AUDIT.c
> @@ -76,7 +76,7 @@ static void audit_ip4(struct audit_buffer *ab, struct sk_buff *skb)
>  	struct iphdr _iph;
>  	const struct iphdr *ih;
>  
> -	ih = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
> +	ih = skb_header_pointer(skb, skb_network_offset(skb), sizeof(_iph), &_iph);

This update is completely pointless.

If you want I can place it in nf-next, your call.
