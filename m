From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v2] src: netlink: Subscribe nft monitor and nft
 monitor trace to respective groups.
Date: Fri, 28 Jul 2017 17:36:26 +0200
Message-ID: <20170728153626.GB3378@salvia>
References: <597acac5.1dc8620a.5a708.5f17@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Varsha Rao <rvarsha016@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51406 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752246AbdG1Pgc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Jul 2017 11:36:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9C70A5FFF32
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jul 2017 17:36:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9024DD1CAA
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jul 2017 17:36:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 76BF2D1CAA
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jul 2017 17:36:15 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <597acac5.1dc8620a.5a708.5f17@mx.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 28, 2017 at 10:55:21AM +0530, Varsha Rao wrote:
> Subscribe nft monitor to both NFNLGRP_NFTABLES and NFNLGRP_NFTRACE.
> nft monitor trace subscribes only to NFNLGRP_NFTRACE. Other event
> reporting options to only NFNLGRP_NFTABLES.
> 
> Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
> ---
> Changes in v1:
> - Subscribe nft monitor to only _NFTABLES.
> - Subsribe nft monitor trace to only _NFTRACE.
> 
> Changes in v2:
> - Subsribe nft monitor to both _NFTABLES and _NFTRACE.
> - Subscribe other events to _NFTABLES.
> - Modified commit message.
> 
>  src/netlink.c | 35 ++++++++++++++++++++++++-----------
>  1 file changed, 24 insertions(+), 11 deletions(-)
> 
> diff --git a/src/netlink.c b/src/netlink.c
> index 9cef4c4..f7069fd 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -3078,21 +3078,34 @@ static int netlink_events_cb(const struct nlmsghdr *nlh, void *data)
>  int netlink_monitor(struct netlink_mon_handler *monhandler,
>  		     struct mnl_socket *nf_sock)
>  {
> -	int group;
> -
> -	group = NFNLGRP_NFTABLES;
> -	if (mnl_socket_setsockopt(nf_sock, NETLINK_ADD_MEMBERSHIP, &group,
> -				  sizeof(int)) < 0)
> -		return netlink_io_error(monhandler->ctx, monhandler->loc,
> +	int group = NFNLGRP_NFTRACE, val;
> +
> +	val = monhandler->monitor_flags | NFNLGRP_NFTABLES;
> +	if (val == 131439) {

What is this magic number?

Please, express this via some definition, so we don't have to remember
the meaning of magic number, it's good to make software more
maintainable.

Thanks.
