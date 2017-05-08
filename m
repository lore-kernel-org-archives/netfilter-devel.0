From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] netlink_delinearize: don't kill dependencies accross
 statements
Date: Mon, 8 May 2017 19:56:57 +0200
Message-ID: <20170508175657.GA7955@salvia>
References: <20170508081750.28093-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57018 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750851AbdEHR5H (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 May 2017 13:57:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 93E882519A8
        for <netfilter-devel@vger.kernel.org>; Mon,  8 May 2017 19:57:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 864801BA10C
        for <netfilter-devel@vger.kernel.org>; Mon,  8 May 2017 19:57:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 220721BA10C
        for <netfilter-devel@vger.kernel.org>; Mon,  8 May 2017 19:56:57 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170508081750.28093-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 08, 2017 at 10:17:50AM +0200, Florian Westphal wrote:
> nft currently translates
> ip protocol tcp meta mark set 1 tcp dport 22
> to
> mark set 0x00000001 tcp dport 22
> 
> This is wrong, the latter form is same as
> 
> mark set 0x00000001 ip protocol tcp tcp dport 22
> 
> and thats not correct (original rule sets mark for tcp packets only).
> 
> We need to clear the dependency stack whenever we see a statement other
> than stmt_expr, as these will have side effects (counter, payload
> mangling, logging and the like).
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Could you add a test for this? Thanks.
