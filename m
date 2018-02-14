From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] tests: add test case for sets updated from packet
 path
Date: Wed, 14 Feb 2018 18:53:26 +0100
Message-ID: <20180214175326.hgvnavd6cgakwyqr@salvia>
References: <20180214164017.14205-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54368 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1161402AbeBNRxd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Feb 2018 12:53:33 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9DA74190F71
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 18:53:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8F244DA727
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 18:53:31 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180214164017.14205-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 14, 2018 at 05:40:17PM +0100, Florian Westphal wrote:
> currently kernel may pick a set implementation that doesn't provide
> a ->update() function. This causes an error when user attempts to
> add the nftables rule that is supposed to add entries to the set.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
> Pablo, unless you have objections I would push this now.

Go ahead. Thanks!

> diff --git a/tests/shell/testcases/sets/0028autoselect_0 b/tests/shell/testcases/sets/0028autoselect_0
> new file mode 100755
> index 000000000000..2225e7aee247
> --- /dev/null
> +++ b/tests/shell/testcases/sets/0028autoselect_0
> @@ -0,0 +1,18 @@
> +#!/bin/bash
> +
> +# This testscase checks kernel picks a suitable set backends.
> +# Ruleset attempts to update from packet path, so set backend
> +# needs an ->update() implementation.
> +
> +set -e
> +
> +$NFT add table t
> +$NFT add set t s1 { type inet_proto \; }
> +$NFT add set t s2 { type ipv4_addr \; }
> +$NFT add set t s3 { type ipv4_addr \; size 1024\; }
> +$NFT add chain t c {type filter hook input priority 0 \; }
> +
> +# chosen set type must support updates from packet path
> +$NFT add rule t c meta iifname foobar set add ip protocol @s1
> +$NFT add rule t c meta iifname foobar set add ip daddr @s2
> +$NFT add rule t c meta iifname foobar set add ip daddr @s3
> -- 
> 2.13.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
