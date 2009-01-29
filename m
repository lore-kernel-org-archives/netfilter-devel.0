From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 2/2] netfilter: log invalid new icmpv6 packet with
	nf_log_packet().
Date: Thu, 29 Jan 2009 23:47:54 +0300
Message-ID: <20090129204754.GA22097@x200.localdomain>
References: <1233261382-17030-1-git-send-email-eric@inl.fr> <1233261382-17030-3-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:52319 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384AbZA2UmP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Jan 2009 15:42:15 -0500
Received: by ey-out-2122.google.com with SMTP id 25so40128eya.37
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Jan 2009 12:42:13 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1233261382-17030-3-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 29, 2009 at 09:36:22PM +0100, Eric Leblond wrote:
> --- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
> +++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
> @@ -126,6 +126,10 @@ static bool icmpv6_new(struct nf_conn *ct, const struct sk_buff *skb,
>  		pr_debug("icmpv6: can't create new conn with type %u\n",
>  			 type + 128);
>  		nf_ct_dump_tuple_ipv6(&ct->tuplehash[0].tuple);
> +		if (LOG_INVALID(&init_net, IPPROTO_ICMPV6))

netns is nf_ct_net(ct) at this point, not &init_net.

> +			nf_log_packet(PF_INET6, 0, skb, NULL, NULL, NULL,
> +				      "nf_ct_icmpv6: invalid new with type %d ",
> +				      type + 128);
