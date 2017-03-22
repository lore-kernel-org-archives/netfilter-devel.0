From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] src: allow update of net base w. meta l4proto icmpv6
Date: Wed, 22 Mar 2017 14:09:02 +0100
Message-ID: <20170322130902.GA21742@salvia>
References: <20170321185437.22959-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47916 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759625AbdCVNJR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Mar 2017 09:09:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 72E351392A4
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 14:09:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6329EDA86E
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 14:09:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 369A5DA86E
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 14:09:06 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170321185437.22959-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 21, 2017 at 07:54:37PM +0100, Florian Westphal wrote:
> nft add rule ip6 f i meta l4proto ipv6-icmp icmpv6 type nd-router-advert
> <cmdline>:1:50-60: Error: conflicting protocols specified: unknown vs. icmpv6
> 
> add icmpv6 to nexthdr list so base gets updated correctly.
> 
> Reported-by: Thomas Woerner <twoerner@redhat.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  NB: This is STILL not correct.
>  nft add rule ip6 f i meta l4proto ipv6-icmp icmpv6 type nd-router-advert
>  gets listed as
>   icmpv6 type nd-router-advert
> 
> because post processing removes the l3 dependency.
> 
> However, "icmpv6 type nd-router-advert" uses dependency
> ip6 nexthdr icmpv6
> which isn't the same as meta l4proto icmpv6.
> 
> I suspect nft should always generate implicit l4 dependencies
> via meta in the ipv6 case, what do others think
> (and not autoremove 'nexthdr' check)?

I think we should use meta l4proto, ip6 nexthdr may point to some of
the extension headers in the packet actually.

> diff --git a/src/proto.c b/src/proto.c
> index 79e9dbf2b33e..fcdfbe73c735 100644
> --- a/src/proto.c
> +++ b/src/proto.c
> @@ -779,6 +779,7 @@ const struct proto_desc proto_inet_service = {
>  		PROTO_LINK(IPPROTO_TCP,		&proto_tcp),
>  		PROTO_LINK(IPPROTO_DCCP,	&proto_dccp),
>  		PROTO_LINK(IPPROTO_SCTP,	&proto_sctp),
> +		PROTO_LINK(IPPROTO_ICMPV6,	&proto_icmp6),

This also allows icmp6 from IPv4, right? I remember I mentioned this
in a patch that I attached to bugzilla at some point so I didn't apply
this.
