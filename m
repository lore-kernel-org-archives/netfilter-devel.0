From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: xt_connlimit: remove mask argument
Date: Mon, 6 Nov 2017 14:51:35 +0100
Message-ID: <20171106135135.GA7097@salvia>
References: <20171102115038.18699-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36092 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752761AbdKFNvq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Nov 2017 08:51:46 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1B5B210FB03
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Nov 2017 14:51:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0D323DA812
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Nov 2017 14:51:45 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171102115038.18699-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 02, 2017 at 12:50:38PM +0100, Florian Westphal wrote:
> Instead of passing mask to all the helpers, just fixup the search key
> early.
> 
> After rbtree conversion, each rbtree node stores connections of same
> 'addr & mask', so no need to pass the mask too.

Applied, thanks Florian.
