From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] payload: don't decode past last valid template
Date: Thu, 15 Feb 2018 15:41:13 +0100
Message-ID: <20180215144113.tupwncbnmdnvpl7z@salvia>
References: <20180215142938.9653-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43474 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1033002AbeBOOlT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Feb 2018 09:41:19 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B51E120990F
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Feb 2018 15:41:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 86E83C8805
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Feb 2018 15:41:17 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180215142938.9653-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 15, 2018 at 03:29:38PM +0100, Florian Westphal wrote:
> When trying to decode payload header fields, be sure to bail out
> when having exhausted all available templates.
> 
> Otherwise, we allocate invalid payload expressions (no dataype,
> header length of 0) and then crash when trying to print them.
> 
> Fixes: https://bugzilla.netfilter.org/show_bug.cgi?id=1226
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
