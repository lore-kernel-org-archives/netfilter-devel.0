From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v5 nf-next] netfilter: connlimit: split xt_connlimit into
 front and backend
Date: Mon, 18 Dec 2017 11:58:07 +0100
Message-ID: <20171218105807.fuv5lm2boocmzfkx@salvia>
References: <20171209200108.15760-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50302 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758277AbdLRK6L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Dec 2017 05:58:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3A4D2BA1CF
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Dec 2017 11:58:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 05A6F1B32CD
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Dec 2017 11:58:00 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171209200108.15760-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Dec 09, 2017 at 09:01:08PM +0100, Florian Westphal wrote:
> This allows to reuse xt_connlimit infrastructure from nf_tables.
> The upcoming nf_tables frontend can just pass in an nftables register
> as input key, this allows limiting by any nft-supported key, including
> concatenations.
> 
> For xt_connlimit, pass in the zone and the ip/ipv6 address.
> 
> With help from Yi-Hung Wei.

Applied, thanks Florian.
