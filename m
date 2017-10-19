From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] rule: fix netlink debug flag when listing table/rules
Date: Thu, 19 Oct 2017 11:56:59 +0200
Message-ID: <20171019095659.GA2089@salvia>
References: <20171018230607.22375-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51568 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751348AbdJSJ5F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2017 05:57:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 38C7CB6C75
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2017 11:57:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 26F28B7FEC
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2017 11:57:03 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171018230607.22375-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 19, 2017 at 01:06:07AM +0200, Florian Westphal wrote:
> nft --debug=netlink list table ...
> has no effect anymore.
> 
> Callers pass in debug_mask & DEBUG_NETLINK, which gets converted
> to 0/1 because the arg is a boolean.
> 
> Later on this bool is converted back to an integer, but that
> won't have the desired result.
> 
> Fixes: be441e1ffdc24 ("src: add debugging mask to context structure")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
