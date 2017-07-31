From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v3] src: netlink: Subscribe nft monitor and nft
 monitor trace to respective groups.
Date: Mon, 31 Jul 2017 19:37:10 +0200
Message-ID: <20170731173710.GB22318@salvia>
References: <597e23e9.544f620a.5b0f3.3ef9@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Varsha Rao <rvarsha016@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58412 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750881AbdGaRh3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Jul 2017 13:37:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AB5733025A4
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 19:37:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 99EB5D1D9B
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 19:37:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8EF71DA7F1
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 19:37:13 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <597e23e9.544f620a.5b0f3.3ef9@mx.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jul 30, 2017 at 11:52:29PM +0530, Varsha Rao wrote:
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
> Changes in v3:
> - Define constant NFT_MONTRACE.
> 
>  src/netlink.c | 36 ++++++++++++++++++++++++++----------
>  1 file changed, 26 insertions(+), 10 deletions(-)
> 
> diff --git a/src/netlink.c b/src/netlink.c
> index 9cef4c4..123088a 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -39,6 +39,9 @@
>  #include <erec.h>
>  #include <iface.h>
>  
> +#define NFT_MONTRACE 131439
> +/* This value is OR of monitor_flags for trace event and NFNLGRP_NFTABLES */

This is still no enough.

Sorry, please respin and send v4. Thanks!
