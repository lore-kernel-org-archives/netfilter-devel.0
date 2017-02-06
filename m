From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nftables 5/9] src: add host byte order integer type
Date: Mon, 6 Feb 2017 18:31:10 +0100
Message-ID: <20170206173110.GA18703@salvia>
References: <20170203123556.17357-1-fw@strlen.de>
 <20170203123556.17357-6-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44468 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751617AbdBFRbP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Feb 2017 12:31:15 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 81D1D1395CC
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2017 18:31:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 72F6BDA7F7
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2017 18:31:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 08792DA848
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2017 18:31:11 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170203123556.17357-6-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Feb 03, 2017 at 01:35:52PM +0100, Florian Westphal wrote:
> diff --git a/include/datatype.h b/include/datatype.h
> index 9f127f2954e3..8c1c827253be 100644
> --- a/include/datatype.h
> +++ b/include/datatype.h
> @@ -82,6 +82,7 @@ enum datatypes {
>  	TYPE_DSCP,
>  	TYPE_ECN,
>  	TYPE_FIB_ADDR,
> +	TYPE_U32,
>  	__TYPE_MAX
>  };
>  #define TYPE_MAX		(__TYPE_MAX - 1)

Right, this is a real problem with host byteorder integer, the
bytecode that we generate is not correct.

I have a patch to avoid this, it's still incomplete. I'm attaching it.

Note this is still incomplete, since this doesn't solve the netlink
delinearize path. We can use the NFT_SET_USERDATA area and the tlv
infrastructure that Carlos made in summer to store this
metainformation that is only useful to

This shouldn't be a showstopper to get kernel patches in, we have a
bit of time ahead to solve this userspace issue.
