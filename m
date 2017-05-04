From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] parser: allow listing sets in one table
Date: Thu, 4 May 2017 18:49:39 +0200
Message-ID: <20170504164939.GA10024@salvia>
References: <20170504160931.15400-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58464 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752384AbdEDQtw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 May 2017 12:49:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 290F1278BF9
        for <netfilter-devel@vger.kernel.org>; Thu,  4 May 2017 18:49:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1D0D6DA87A
        for <netfilter-devel@vger.kernel.org>; Thu,  4 May 2017 18:49:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 09927FF2C5
        for <netfilter-devel@vger.kernel.org>; Thu,  4 May 2017 18:49:43 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170504160931.15400-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 04, 2017 at 06:09:31PM +0200, Florian Westphal wrote:
> currently nft can lists sets:
> nft list sets
> 
> but unlike e.g. 'quotas' or 'counters' we didn't support
> restricting it to a table.  Now its possible to restrict set
> definition listing to one table:
> 
> nft list sets table inet filter
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
