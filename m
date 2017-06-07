From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] netlink_delinearize: prefer ct event set foo,bar
 over 'set foo|bar'
Date: Wed, 7 Jun 2017 17:24:10 +0200
Message-ID: <20170607152410.GA14650@salvia>
References: <20170607151647.22788-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52204 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751049AbdFGPYO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Jun 2017 11:24:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 00DB0275FA7
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Jun 2017 17:24:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E7D0C4EA83
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Jun 2017 17:24:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DEF2A100A67
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Jun 2017 17:24:02 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170607151647.22788-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 07, 2017 at 05:16:47PM +0200, Florian Westphal wrote:
> Translate binop representation to a list-based one, so nft prints
> "ct event destroy,new" instead of 'ct event destroy|new'.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks Florian.
