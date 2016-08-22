From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] parser_bison: keep snat/dnat existing syntax
 unchanged
Date: Mon, 22 Aug 2016 18:14:40 +0200
Message-ID: <20160822161440.GA5689@salvia>
References: <1471880055-17832-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46490 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755041AbcHVQOx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2016 12:14:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A183B1F18DF
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 18:14:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 91EBBFB45D
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 18:14:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 788B7FF2FD
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 18:14:49 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1471880055-17832-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 22, 2016 at 11:34:15PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> We should keep existing syntax unchanged, and this was emphasized
> in the commit 850f0a56b6ad ("src: add 'to' for snat and dnat")'s
> commit log: "Existing syntax is still preserved, but the listing
> shows the one including 'to'."
> 
> This problem was found by running shell test:
>   # ./run-tests.sh
>   [ ... ]
>   W: [FAILED]	./testcases/maps/anonymous_snat_map_0
>   I: [OK]		./testcases/maps/map_with_flags_0
>   W: [FAILED]	./testcases/maps/named_snat_map_0
>   [ ... ]

Applied, thanks!
