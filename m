From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH RFC v2 3/4] Implement --echo option
Date: Thu, 27 Jul 2017 18:43:00 +0200
Message-ID: <20170727164300.GA10637@salvia>
References: <20170727162144.28703-1-phil@nwl.cc>
 <20170727162144.28703-4-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40814 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751766AbdG0QnN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jul 2017 12:43:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 16CC757E802
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jul 2017 18:42:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 07AD01B32DA
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jul 2017 18:42:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 050C71B3074
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jul 2017 18:42:57 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170727162144.28703-4-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 27, 2017 at 06:21:43PM +0200, Phil Sutter wrote:
> diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
> index 40096de04e963..70404f724808a 100644
> --- a/include/linux/netfilter/nf_tables.h
> +++ b/include/linux/netfilter/nf_tables.h
> @@ -114,6 +114,7 @@ enum nf_tables_msg_types {
>  	NFT_MSG_GETOBJ,
>  	NFT_MSG_DELOBJ,
>  	NFT_MSG_GETOBJ_RESET,
> +	NFT_MSG_META_ECHO,

Why this?
