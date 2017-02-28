From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/7] nftables: add ct helper set support
Date: Tue, 28 Feb 2017 12:30:55 +0100
Message-ID: <20170228113055.GA19271@salvia>
References: <20170227150255.12624-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57662 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750957AbdB1LbD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Feb 2017 06:31:03 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 509672471B
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 12:30:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 422BEDA7F7
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 12:30:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 07B51DA7E9
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 12:30:57 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170227150255.12624-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 27, 2017 at 04:02:48PM +0100, Florian Westphal wrote:
> This series adds initial support to set conntrack helpers via
> the nft objref infrastructure.
> 
> As -next is closed I will not push this yet since kernel support
> is still missing.
> 
> Currently only supported attributes are:
> 
> type (e.g. "ftp", "sip)
> protocol (udp or tcp)
> l3proto (ip, ip6).
> 
> l3proto is optional, the kernel will infer it from
> the family, i.e. in "inet" case kernel will check for both ipv4 and ipv6.
> 
> Let me know in case you spot any isses, patches #3 and #5 could already
> be pushed to nft master since they are just preparation patches.

Series looks good, thanks Florian.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
