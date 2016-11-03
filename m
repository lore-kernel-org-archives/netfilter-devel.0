From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH next] nft_meta: add skb hash get support
Date: Thu, 3 Nov 2016 17:47:50 +0100
Message-ID: <20161103164750.GA8096@salvia>
References: <1477917869-26872-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58346 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754848AbcKCQr4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Nov 2016 12:47:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 00B16A7CB5
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Nov 2016 17:47:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E77ED7E4E2
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Nov 2016 17:47:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C2D457E4E2
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Nov 2016 17:47:51 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1477917869-26872-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 31, 2016 at 01:44:29PM +0100, Florian Westphal wrote:
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
> NB1: Alternative is to place this in nft_hash, but that uses
> an sreg so i think meta is fine.

Right. We may still reuse all these attributes though if we use the
hash expression:

 * @NFTA_HASH_DREG: destination register (NLA_U32)
 * @NFTA_HASH_MODULUS: modulus value (NLA_U32)
 * @NFTA_HASH_OFFSET: add this offset value to hash result (NLA_U32)

This would need a new NFTA_HASH_TYPE, defaulting on jhash.

Otherwise we would need a scaling expression in case we want to use
this new meta field for load balancing just like af_packet fanout. Do
you prefer to follow up this path?
