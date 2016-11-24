From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 0/2] netfilter: nat: fix regressions introduced by
 rhashtable conversion
Date: Thu, 24 Nov 2016 13:53:12 +0100
Message-ID: <20161124125312.GA23970@salvia>
References: <1479305616-4171-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, herbert@gondor.apana.org.au
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58812 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935112AbcKXMxS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2016 07:53:18 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 44BFB209432
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 13:53:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 34948DA861
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 13:53:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 24DD7DA862
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 13:53:14 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1479305616-4171-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 16, 2016 at 03:13:34PM +0100, Florian Westphal wrote:
> These two patches address bugs added when I converted the nat bysource hash
> to rhashtable.
> 
> First patch fixes object comparision, second patch converts
> nat bysource to the rhlist interface, we have to deal with identical
> source identities (distinct connections sharing same ip/port source pair).
> 
> Unfortunately the rhashlist interface isn't available in 4.8, so the question
> is how to address patch #2 for -stable.
> 
> One way would be to revert the rhashtable conversion, the other one
> would be to just set .insecure_elasticity in the rhashtable params.
> 
> The latter should work fine, as we do NOT need to identify the individual
> duplicate keys.

Series applied, thanks Florian.
