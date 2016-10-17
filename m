From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] meta: permit numeric interface type
Date: Mon, 17 Oct 2016 11:42:55 +0200
Message-ID: <20161017094255.GA29277@salvia>
References: <1476694417-14583-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33814 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754765AbcJQJnF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2016 05:43:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 83DED9B7F9
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 11:43:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 728DE96904
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 11:43:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0F560A8252
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 11:43:01 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1476694417-14583-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 17, 2016 at 10:53:37AM +0200, Florian Westphal wrote:
> If we can't translate an interface index back to a name
> we just print the number.
> 
> This change allows using a number instead of an interface index to
> make this symmetric.
> 
> If we can't find an interface with the given name check
> if its a numeric string and then use it instead.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
