From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] Extend nf_h323_error_boundary to work on bits as well
Date: Mon, 13 Nov 2017 14:14:46 +0100
Message-ID: <20171113131446.GB21936@salvia>
References: <20171106151313.GA21034@salvia>
 <20171113080941.616-2-eric.sesterhenn@x41-dsec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: eric.sesterhenn@x41-dsec.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35050 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754983AbdKMNOu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2017 08:14:50 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5DA2A8D0505
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2017 14:14:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4E3E1DA86E
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2017 14:14:49 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171113080941.616-2-eric.sesterhenn@x41-dsec.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 13, 2017 at 09:09:41AM +0100, eric.sesterhenn@x41-dsec.de wrote:
> From: Eric Sesterhenn <eric.sesterhenn@x41-dsec.de>
> 
> This patches several out of bounds memory reads by extending
> the nf_h323_error_boundary() function to work on bits as well
> an check the affected parts.

Also applied with changes, see below.

[...]
> diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
> index f358222b1e5e..b8b4fecaa016 100644
> --- a/net/netfilter/nf_conntrack_h323_asn1.c
> +++ b/net/netfilter/nf_conntrack_h323_asn1.c
> @@ -165,8 +165,13 @@ static unsigned int get_len(bitstr_t *bs)
>  }
>  
>  /****************************************************************************/
> -static int nf_h323_error_boundary(bitstr_t *bs, size_t bytes)
> +static int nf_h323_error_boundary(bitstr_t *bs, size_t bytes, size_t bits)
>  {
> +	bits += bs->bit;
> +	bytes += bits / 8;

I changed this to use BITS_PER_BYTE instead of hardcoded 8, just a
minor comestic cleanup.

Please, review I'm going to push to nf-next.git, given I have to
mangled your patches slightly, just to make sure I didn't slip through
any mistake.

Thanks.
